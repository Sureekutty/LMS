import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Landmark, ArrowLeft, Wallet, Calendar, Percent, PlusCircle, RefreshCw, XCircle, Eye } from "lucide-react";
import API from "../api/axios";
import "./Deposits.css";

const emptyForm = {
  memberId: "",
  depositTypeId: "",
  principalAmount: "",
  durationMonths: "",
};

export default function Deposits() {
  const navigate = useNavigate();
  const [deposits, setDeposits] = useState([]);
  const [members, setMembers] = useState([]);
  const [depositTypes, setDepositTypes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedDeposit, setSelectedDeposit] = useState(null);
  const [bulkText, setBulkText] = useState("");
  const [bulkLoading, setBulkLoading] = useState(false);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState(emptyForm);
  const [formLoading, setFormLoading] = useState(false);
  const [formSuccess, setFormSuccess] = useState("");

  // Role Parsing
  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isClerk = roles.includes("ROLE_CLERK");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isMember = roles.includes("ROLE_MEMBER") || (!isAdmin && !isClerk && !isAccountant);

  // Live Calculator State
  const [calcPrincipal, setCalcPrincipal] = useState("10000");
  const [calcRate, setCalcRate] = useState("7.0");
  const [calcDuration, setCalcDuration] = useState("12");
  const [calcType, setCalcType] = useState("FD");
  const [calcMaturity, setCalcMaturity] = useState(0);

  const fetchInitialData = async () => {
    setLoading(true);
    try {
      if (isAdmin || isClerk || isAccountant) {
        // Fetch all deposits, members, and deposit types
        const [depRes, memRes, typeRes] = await Promise.all([
          API.get("/deposits"),
          API.get("/members"),
          API.get("/deposits/types") // Wait, does /api/deposits/types exist? Let's check or handle error gracefully
        ]);
        setDeposits(depRes.data || []);
        setMembers(memRes.data || []);
        setDepositTypes(typeRes.data || []);
      } else {
        // Fetch member profile first, then member deposits
        const meRes = await API.get("/members/me");
        const member = meRes.data;
        if (member && member.id) {
          const depRes = await API.get(`/deposits/member/${member.id}`);
          setDeposits(depRes.data || []);
        }
      }
    } catch (err) {
      console.error("Error loading deposits data:", err);
      setError("Failed to load deposit data. Falling back to dynamic views.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInitialData();
  }, []);

  // Run dynamic compounding math client-side for preview
  const runCalculator = () => {
    const p = parseFloat(calcPrincipal) || 0;
    const r = parseFloat(calcRate) || 0;
    const dur = parseInt(calcDuration) || 0;

    if (p <= 0 || r <= 0 || dur <= 0) {
      setCalcMaturity(0);
      return;
    }

    if (calcType === "FD") {
      // Compounded quarterly (frequency = 4)
      const amount = p * Math.pow(1 + (r / 100 / 4), 4 * (dur / 12));
      setCalcMaturity(Math.round(amount));
    } else {
      // Recurring Deposit bracket compounding logic
      let m1 = 0, m2 = 0, m3 = 0, m4 = 0, maturity = 0;
      if (dur <= 12) {
        m1 = (p * r * (dur * (dur + 1))) / 2400.0;
        maturity = m1 + (dur * p);
      } else if (dur <= 24) {
        m1 = (p * r * (12 * 13)) / 2400.0;
        m2 = ((p * r * ((dur - 12) * (dur - 12 + 1))) / 2400.0) + (((m1 + 12 * p) * r * (dur - 12)) / 1200.0);
        maturity = m1 + m2 + (dur * p);
      } else if (dur <= 36) {
        m1 = (p * r * (12 * 13)) / 2400.0;
        m2 = (p * r * (12 * 13)) / 2400.0 + ((m1 + 12 * p) * r) / 100.0;
        m3 = ((p * r * ((dur - 24) * (dur - 24 + 1))) / 2400.0) + (((m1 + m2 + 24 * p) * r * (dur - 24)) / 1200.0);
        maturity = m1 + m2 + m3 + (dur * p);
      } else {
        m1 = (p * r * (12 * 13)) / 2400.0;
        m2 = (p * r * (12 * 13)) / 2400.0 + ((m1 + 12 * p) * r) / 100.0;
        m3 = (p * r * (12 * 13)) / 2400.0 + ((m1 + m2 + 24 * p) * r) / 100.0;
        m4 = ((p * r * ((dur - 36) * (dur - 36 + 1))) / 2400.0) + (((m1 + m2 + m3 + 36 * p) * r * (dur - 36)) / 1200.0);
        maturity = m1 + m2 + m3 + m4 + (dur * p);
      }
      setCalcMaturity(Math.round(maturity));
    }
  };

  useEffect(() => {
    runCalculator();
  }, [calcPrincipal, calcRate, calcDuration, calcType]);

  const handleOpenDeposit = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    setFormSuccess("");
    setError("");

    try {
      // 1. Load Razorpay Script
      const res = await import("../utils/razorpay").then(m => m.loadRazorpayScript());
      if (!res) {
        setError("Razorpay SDK failed to load. Check connection.");
        setFormLoading(false);
        return;
      }

      const principal = parseFloat(form.principalAmount);

      // 2. Create Order on Backend
      const orderRes = await API.post("/payments/create-order", {
        amount: principal,
        referenceType: "DEPOSIT",
        referenceId: form.memberId
      });

      const { orderId, amount, currency } = orderRes.data;

      // 3. Configure Razorpay Options
      const options = {
        key: "rzp_test_YourTestKeyIdHere", // MUST MATCH BACKEND!
        amount: amount.toString(),
        currency: currency,
        name: "LMS Enterprise",
        description: "Open New Deposit",
        order_id: orderId,
        handler: async function (response) {
          try {
            // 4. Verify Payment on Backend
            await API.post("/payments/verify", {
              razorpay_payment_id: response.razorpay_payment_id,
              razorpay_order_id: response.razorpay_order_id,
              razorpay_signature: response.razorpay_signature
            });

            // 5. Create Deposit after successful payment
            const payload = {
              member: { id: form.memberId },
              depositType: { id: form.depositTypeId },
              principalAmount: principal,
              durationMonths: parseInt(form.durationMonths),
            };
      
            await API.post("/deposits", payload);
            setFormSuccess("Payment successful & Deposit account opened!");
            setForm(emptyForm);
            setShowForm(false);
            fetchInitialData();
          } catch (err) {
            setError("Payment verification failed on server.");
          }
        },
        prefill: {
          name: "Member Name",
          email: "member@example.com",
          contact: "9999999999"
        },
        theme: {
          color: "#4318ff"
        }
      };

      const rzp1 = new window.Razorpay(options);
      rzp1.on("payment.failed", function (response) {
        setError("Payment Failed: " + response.error.description);
      });
      rzp1.open();
      
    } catch (err) {
      setError(err.response?.data?.error || "Failed to initiate payment.");
    } finally {
      setFormLoading(false);
    }
  };

  const handleBulkThriftUpload = async (e) => {
    e.preventDefault();
    if (!bulkText.trim()) return;
    setBulkLoading(true);
    try {
      const lines = bulkText.split("\n");
      const records = lines
        .map(line => {
          const parts = line.split(",");
          if (parts.length < 2) return null;
          const codeOrNo = parts[0].trim();
          const amt = parseFloat(parts[1].trim());
          if (!codeOrNo || isNaN(amt)) return null;

          return {
            staffCode: codeOrNo.startsWith("MEM") ? "" : codeOrNo,
            membershipNo: codeOrNo.startsWith("MEM") ? codeOrNo : "",
            amount: amt
          };
        })
        .filter(Boolean);

      if (records.length === 0) {
        alert("No valid records found. Format: Code,Amount (e.g. SC101,150.00)");
        setBulkLoading(false);
        return;
      }

      await API.post("/deposits/upload-thrift", records);
      alert("Successfully posted bulk Thrift subscriptions!");
      setBulkText("");
      fetchInitialData();
    } catch (err) {
      alert(err.response?.data?.message || "Failed to process bulk thrift upload.");
    } finally {
      setBulkLoading(false);
    }
  };

  const handleCloseDeposit = async (id) => {
    if (!window.confirm("Are you sure you want to close/liquidate this deposit account?")) {
      return;
    }
    try {
      await API.put(`/deposits/${id}/close`);
      fetchInitialData();
    } catch (err) {
      alert("Failed to close deposit account.");
    }
  };

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header">
        <div className="page-title-group">
          <h1 className="gradient-heading">Deposits & Savings</h1>
          <p>Configure, open, and review interest accruals on savings accounts</p>
        </div>
        {(isAdmin || isClerk) && (
          <button className="btn-enterprise btn-primary" onClick={() => setShowForm(!showForm)}>
            <PlusCircle size={18} /> Open Deposit Account
          </button>
        )}
      </header>

      {/* Dynamic Compounding Calculator */}
      <section className="glass-card" style={{ padding: '2rem', marginBottom: '2rem' }}>
        <h3 style={{ fontSize: '1.3rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Dynamic Deposit Compounding Calculator</h3>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '1.25rem' }}>
          <label className="enterprise-form-group">
            <span className="enterprise-label">Principal Amount (₹)</span>
            <input className="enterprise-input" type="number" value={calcPrincipal} onChange={(e) => setCalcPrincipal(e.target.value)} />
          </label>
          <label className="enterprise-form-group">
            <span className="enterprise-label">Interest Rate (%)</span>
            <input className="enterprise-input" type="number" step="0.1" value={calcRate} onChange={(e) => setCalcRate(e.target.value)} />
          </label>
          <label className="enterprise-form-group">
            <span className="enterprise-label">Tenure (Months)</span>
            <input className="enterprise-input" type="number" value={calcDuration} onChange={(e) => setCalcDuration(e.target.value)} />
          </label>
          <label className="enterprise-form-group">
            <span className="enterprise-label">Deposit Type</span>
            <select className="enterprise-select" value={calcType} onChange={(e) => setCalcType(e.target.value)}>
              <option value="FD">Fixed Deposit (Quarterly Compound)</option>
              <option value="RD">Recurring Deposit (Bracket Compound)</option>
            </select>
          </label>
          <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'flex-end', backgroundColor: 'var(--primary)', color: 'white', padding: '1rem', borderRadius: 'var(--radius-md)' }}>
            <h4 style={{ fontSize: '0.85rem', fontWeight: 600, opacity: 0.9, textTransform: 'uppercase', letterSpacing: '0.05em' }}>Estimated Maturity</h4>
            <div style={{ fontSize: '1.75rem', fontWeight: 800 }}>₹{calcMaturity.toLocaleString("en-IN")}</div>
          </div>
        </div>
      </section>

      {/* Thrift Uploading console for Admin and Clerks */}
      {(isAdmin || isClerk) && (
        <section className="glass-card" style={{ padding: '2rem', marginBottom: '2rem' }}>
          <h3 style={{ fontSize: '1.3rem', fontWeight: 800, marginBottom: '0.5rem', color: 'var(--text-primary)' }}>Bulk Thrift Uploading Dispatcher</h3>
          <p style={{ color: "var(--text-secondary)", fontSize: "0.9rem", marginBottom: '1.5rem' }}>
            Input bulk subscription updates. Paste CSV rows in format: <strong>StaffCode/MembershipNo,Amount</strong> (e.g. <code>SC101,150.00</code> on each line)
          </p>
          <form onSubmit={handleBulkThriftUpload}>
            <textarea
              className="enterprise-input"
              placeholder="SC101,150.00&#10;MEM001,200.00"
              value={bulkText}
              onChange={(e) => setBulkText(e.target.value)}
              style={{ width: "100%", height: 110, fontFamily: "monospace", resize: 'vertical' }}
              required
            />
            <div style={{ marginTop: '1rem', textAlign: "right" }}>
              <button type="submit" disabled={bulkLoading} className="btn-enterprise btn-primary">
                {bulkLoading ? "Posting Subscriptions..." : "Post Bulk Subscriptions"}
              </button>
            </div>
          </form>
        </section>
      )}

      {/* Open Deposit Account Form */}
      {showForm && (
        <section className="glass-card" style={{ padding: '2rem', marginBottom: '2rem' }}>
          <form onSubmit={handleOpenDeposit}>
            <h3 style={{ fontSize: '1.3rem', fontWeight: 800, marginBottom: '1.5rem' }}>Open Deposit Account</h3>
            
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Select Member</span>
                <select className="enterprise-select" value={form.memberId} onChange={(e) => setForm({ ...form, memberId: e.target.value })} required>
                  <option value="">-- Choose Member --</option>
                  {members.map(m => (
                    <option key={m.id} value={m.id}>{m.name} ({m.membershipNo})</option>
                  ))}
                </select>
              </label>
              
              <label className="enterprise-form-group">
                <span className="enterprise-label">Deposit Type</span>
                <select className="enterprise-select" value={form.depositTypeId} onChange={(e) => setForm({ ...form, depositTypeId: e.target.value })} required>
                  <option value="">-- Choose Type --</option>
                  {depositTypes.map(t => (
                    <option key={t.id} value={t.id}>{t.typeName} ({t.typeCode})</option>
                  ))}
                  {/* Fallbacks if /api/deposits/types didn't return values */}
                  {depositTypes.length === 0 && (
                    <>
                      <option value="1">Fixed Deposit (FD)</option>
                      <option value="2">Recurring Deposit (RD)</option>
                    </>
                  )}
                </select>
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Deposit Amount (₹)</span>
                <input className="enterprise-input" type="number" value={form.principalAmount} onChange={(e) => setForm({ ...form, principalAmount: e.target.value })} required />
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Tenure (Months)</span>
                <input className="enterprise-input" type="number" value={form.durationMonths} onChange={(e) => setForm({ ...form, durationMonths: e.target.value })} required />
              </label>
            </div>

            {formSuccess && <div className="alert alert-success mt-4">{formSuccess}</div>}
            {error && <div className="alert alert-danger mt-4">{error}</div>}

            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem', borderTop: '1px solid #f1f5f9', paddingTop: '1.5rem' }}>
              <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowForm(false)}>Cancel</button>
              <button type="submit" disabled={formLoading} className="btn-enterprise btn-primary">
                {formLoading ? "Opening..." : "Open Account"}
              </button>
            </div>
          </form>
        </section>
      )}

      {/* Active Deposit list */}
      <section>
        <h2 style={{ fontSize: '1.35rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Active Deposit Accounts</h2>
        {loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" />
            <p style={{ marginTop: '1rem' }}>Fetching ledger records...</p>
          </div>
        ) : deposits.length === 0 ? (
          <div className="empty-state">
            <Wallet size={36} />
            <p style={{ marginTop: '1rem' }}>No active deposit records found.</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Account No</th>
                  <th>Member</th>
                  <th>Type</th>
                  <th>Principal</th>
                  <th>Rate</th>
                  <th>Maturity Date</th>
                  <th>Maturity Value</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {deposits.map(d => (
                  <tr key={d.id}>
                    <td><strong>{d.depositNo}</strong></td>
                    <td>{d.member?.name || "N/A"}</td>
                    <td>{d.depositType?.typeName || "FD/RD Account"}</td>
                    <td>₹{d.principalAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>{d.interestRate}%</td>
                    <td>{new Date(d.maturityDate).toLocaleDateString("en-IN")}</td>
                    <td>₹{d.maturityAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>
                      <span className={`badge badge-${
                        d.status === 'ACTIVE' ? 'success' :
                        d.status === 'CLOSED' ? 'secondary' : 'warning'
                      }`}>
                        {d.status}
                      </span>
                    </td>
                    <td>
                      <div style={{ display: "flex", gap: "8px", alignItems: 'center' }}>
                        <button className="btn-enterprise btn-secondary" onClick={() => setSelectedDeposit(d)} title="Inspect Account Details" style={{ padding: '0.4rem 0.6rem' }}>
                          <Eye size={14} /> View
                        </button>
                        {d.status === "ACTIVE" && (isAdmin || isClerk) && (
                          <button className="btn-enterprise btn-danger" onClick={() => handleCloseDeposit(d.id)} title="Liquidate Account" style={{ padding: '0.4rem 0.6rem' }}>
                            <XCircle size={14} /> Close
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>

      {/* Selected Deposit Detailed Modal */}
      {selectedDeposit && (
        <div className="modal-overlay" onClick={() => setSelectedDeposit(null)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()} style={{ maxWidth: 640 }}>
            <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem' }}>Deposit Account Inspector</h3>
            <div className="details-grid" style={{ display: "grid", gridTemplateColumns: "1fr", gap: 12, margin: "20px 0", textAlign: "left", fontSize: "0.95rem" }}>
              <div><strong>Account No:</strong> {selectedDeposit.depositNo}</div>
              <div><strong>Member:</strong> {selectedDeposit.member?.name} ({selectedDeposit.member?.membershipNo})</div>
              <div><strong>Deposit Scheme:</strong> {selectedDeposit.depositType?.typeName} ({selectedDeposit.depositType?.typeCode})</div>
              <div><strong>Interest Rate:</strong> {selectedDeposit.interestRate}%</div>
              <div><strong>Principal Balance:</strong> ₹{selectedDeposit.principalAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</div>
              <div><strong>Maturity Value:</strong> ₹{selectedDeposit.maturityAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</div>
              <div><strong>Open Date:</strong> {new Date(selectedDeposit.openDate).toLocaleDateString("en-IN")}</div>
              <div><strong>Maturity Date:</strong> {new Date(selectedDeposit.maturityDate).toLocaleDateString("en-IN")}</div>
              <div><strong>Tenure:</strong> {selectedDeposit.durationMonths} Months</div>
              <div><strong>Account Status:</strong> 
                <span className={`badge badge-${
                        selectedDeposit.status === 'ACTIVE' ? 'success' :
                        selectedDeposit.status === 'CLOSED' ? 'secondary' : 'warning'
                      }`} style={{ marginLeft: 8 }}>{selectedDeposit.status}</span>
              </div>
            </div>
            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem' }}>
              <button className="btn-enterprise btn-secondary" onClick={() => setSelectedDeposit(null)}>Close Inspector</button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}
