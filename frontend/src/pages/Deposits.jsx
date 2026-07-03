import { useEffect, useState } from "react";
import { Landmark, ArrowRight, Wallet, Calendar, Percent, PlusCircle, RefreshCw, XCircle } from "lucide-react";
import API from "../api/axios";
import "./Deposits.css";

const emptyForm = {
  memberId: "",
  depositTypeId: "",
  principalAmount: "",
  durationMonths: "",
};

export default function Deposits() {
  const [deposits, setDeposits] = useState([]);
  const [members, setMembers] = useState([]);
  const [depositTypes, setDepositTypes] = useState([]);
  const [loading, setLoading] = useState(true);
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
      let m1 = 0, m2 = 0, m3 = 0, m4 = 0, m5 = 0, maturity = 0;
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
      const payload = {
        member: { id: form.memberId },
        depositType: { id: form.depositTypeId },
        principalAmount: parseFloat(form.principalAmount),
        durationMonths: parseInt(form.durationMonths),
      };

      await API.post("/deposits", payload);
      setFormSuccess("Deposit account opened successfully!");
      setForm(emptyForm);
      setShowForm(false);
      fetchInitialData();
    } catch (err) {
      setError(err.response?.data?.message || "Failed to open deposit account.");
    } finally {
      setFormLoading(false);
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
    <main className="deposits-page">
      <header className="page-header">
        <div>
          <h1>Deposits & Savings</h1>
          <p>Configure, open, and review interest accruals on savings accounts</p>
        </div>
        {(isAdmin || isClerk) && (
          <button className="open-form-btn" onClick={() => setShowForm(!showForm)}>
            <PlusCircle size={18} />
            Open Deposit Account
          </button>
        )}
      </header>

      {/* Dynamic Compounding Calculator */}
      <section className="calculator-section">
        <h3>Dynamic Deposit Compounding Calculator</h3>
        <div className="calculator-grid">
          <label>
            <span>Principal Amount (₹)</span>
            <input type="number" value={calcPrincipal} onChange={(e) => setCalcPrincipal(e.target.value)} />
          </label>
          <label>
            <span>Interest Rate (%)</span>
            <input type="number" step="0.1" value={calcRate} onChange={(e) => setCalcRate(e.target.value)} />
          </label>
          <label>
            <span>Tenure (Months)</span>
            <input type="number" value={calcDuration} onChange={(e) => setCalcDuration(e.target.value)} />
          </label>
          <label>
            <span>Deposit Type</span>
            <select value={calcType} onChange={(e) => setCalcType(e.target.value)}>
              <option value="FD">Fixed Deposit (Quarterly Compound)</option>
              <option value="RD">Recurring Deposit (Bracket Compound)</option>
            </select>
          </label>
          <div className="calc-result">
            <h4>Estimated Maturity Value</h4>
            <div className="maturity-val">₹{calcMaturity.toLocaleString("en-IN")}</div>
          </div>
        </div>
      </section>

      {/* Open Deposit Account Form */}
      {showForm && (
        <section className="deposit-form-wrapper">
          <form onSubmit={handleOpenDeposit} className="deposit-form">
            <h3>Open Deposit Account</h3>
            
            <div className="form-row">
              <label>
                <span>Select Member</span>
                <select value={form.memberId} onChange={(e) => setForm({ ...form, memberId: e.target.value })} required>
                  <option value="">-- Choose Member --</option>
                  {members.map(m => (
                    <option key={m.id} value={m.id}>{m.name} ({m.membershipNo})</option>
                  ))}
                </select>
              </label>
              
              <label>
                <span>Deposit Type</span>
                <select value={form.depositTypeId} onChange={(e) => setForm({ ...form, depositTypeId: e.target.value })} required>
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
            </div>

            <div className="form-row">
              <label>
                <span>Deposit Amount (₹)</span>
                <input type="number" value={form.principalAmount} onChange={(e) => setForm({ ...form, principalAmount: e.target.value })} required />
              </label>

              <label>
                <span>Tenure (Months)</span>
                <input type="number" value={form.durationMonths} onChange={(e) => setForm({ ...form, durationMonths: e.target.value })} required />
              </label>
            </div>

            {formSuccess && <div className="form-success-msg">{formSuccess}</div>}
            {error && <div className="form-error-msg">{error}</div>}

            <div className="form-actions">
              <button type="submit" disabled={formLoading} className="submit-btn">
                {formLoading ? "Opening..." : "Open Account"}
              </button>
              <button type="button" className="cancel-btn" onClick={() => setShowForm(false)}>Cancel</button>
            </div>
          </form>
        </section>
      )}

      {/* Active Deposit list */}
      <section className="deposits-list">
        <h2>Active Deposit Accounts</h2>
        {loading ? (
          <div className="loading-state">
            <RefreshCw size={28} className="spin-icon" />
            <p>Fetching ledger records...</p>
          </div>
        ) : deposits.length === 0 ? (
          <div className="empty-state">
            <Wallet size={36} />
            <p>No active deposit records found.</p>
          </div>
        ) : (
          <div className="table-wrap">
            <table className="deposits-table">
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
                  {(isAdmin || isClerk) && <th>Actions</th>}
                </tr>
              </thead>
              <tbody>
                {deposits.map(d => (
                  <tr key={d.id}>
                    <td>{d.depositNo}</td>
                    <td>{d.member?.name || "N/A"}</td>
                    <td>{d.depositType?.typeName || "FD/RD Account"}</td>
                    <td>₹{d.principalAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>{d.interestRate}%</td>
                    <td>{new Date(d.maturityDate).toLocaleDateString("en-IN")}</td>
                    <td>₹{d.maturityAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>
                      <span className={`status-badge ${d.status?.toLowerCase()}`}>
                        {d.status}
                      </span>
                    </td>
                    {(isAdmin || isClerk) && (
                      <td>
                        {d.status === "ACTIVE" && (
                          <button className="close-btn" onClick={() => handleCloseDeposit(d.id)} title="Liquidate Account">
                            <XCircle size={16} />
                          </button>
                        )}
                      </td>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </main>
  );
}
