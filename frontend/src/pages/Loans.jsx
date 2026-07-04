import { useEffect, useState, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { CreditCard, PlusCircle, RefreshCw, CheckCircle, XCircle, X, Search, FileSpreadsheet } from "lucide-react";
import API from "../api/axios";
import "./Loans.css";

const emptyForm = {
  memberId: "",
  loanType: "LTL",
  amountRequested: "",
  durationMonths: "12",
  purpose: "",
  surety1: "",
  surety2: "",
  surety3: "",
};

export default function Loans() {
  const navigate = useNavigate();
  const [loans, setLoans] = useState([]);
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedLoan, setSelectedLoan] = useState(null);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState(emptyForm);
  const [searchQuery, setSearchQuery] = useState("");
  
  // Dialog/Form overlays
  const [approvingLoanId, setApprovingLoanId] = useState(null);
  const [sanctionedAmount, setSanctionedAmount] = useState("");
  const [repayingLoan, setRepayingLoan] = useState(null);
  const [repaymentAmount, setRepaymentAmount] = useState("");
  const [replacingSuretyLoan, setReplacingSuretyLoan] = useState(null);
  const [suretyIndexToReplace, setSuretyIndexToReplace] = useState(1);
  const [newSuretyMember, setNewSuretyMember] = useState("");

  const [formLoading, setFormLoading] = useState(false);
  const [formSuccess, setFormSuccess] = useState("");

  // Role Parsing
  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isClerk = roles.includes("ROLE_CLERK");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isMember = roles.includes("ROLE_MEMBER") || (!isAdmin && !isClerk && !isAccountant);

  const fetchInitialData = async () => {
    setLoading(true);
    try {
      if (isAdmin || isClerk || isAccountant) {
        const [loansRes, memRes] = await Promise.all([
          API.get("/loans"),
          API.get("/members")
        ]);
        setLoans(loansRes.data || []);
        setMembers(memRes.data || []);
      } else {
        const meRes = await API.get("/members/me");
        const member = meRes.data;
        if (member && member.id) {
          const loansRes = await API.get(`/loans/member/${member.id}`);
          setLoans(loansRes.data || []);
        }
      }
    } catch (err) {
      console.error("Error loading loans:", err);
      setError("Failed to load loans directory.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInitialData();
  }, []);

  const handleApplyLoan = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    setFormSuccess("");
    setError("");

    try {
      const payload = {
        member: { id: form.memberId },
        loanType: form.loanType,
        amountRequested: parseFloat(form.amountRequested),
        durationMonths: parseInt(form.durationMonths),
        purpose: form.purpose,
      };

      await API.post("/loans", payload);
      setFormSuccess("Loan application submitted successfully!");
      setTimeout(() => {
        setForm(emptyForm);
        setShowForm(false);
        setFormSuccess("");
        fetchInitialData();
      }, 1500);
    } catch (err) {
      setError(err.response?.data?.message || "Failed to submit loan application.");
    } finally {
      setFormLoading(false);
    }
  };

  const handleApprove = async (id) => {
    if (!sanctionedAmount) {
      alert("Please enter sanctioned amount.");
      return;
    }
    try {
      await API.put(`/loans/${id}/approve?sanctionedAmount=${sanctionedAmount}`);
      setApprovingLoanId(null);
      setSanctionedAmount("");
      fetchInitialData();
    } catch (err) {
      alert("Failed to approve loan.");
    }
  };

  const handleReject = async (id) => {
    if (!window.confirm("Are you sure you want to reject this loan application?")) return;
    try {
      await API.put(`/loans/${id}/reject`);
      fetchInitialData();
    } catch (err) {
      alert("Failed to reject loan.");
    }
  };

  const handleDisburse = async (id) => {
    const disburserName = localStorage.getItem("username") || "System";
    try {
      await API.put(`/loans/${id}/disburse?disbursedBy=${disburserName}`);
      fetchInitialData();
    } catch (err) {
      alert("Failed to disburse loan.");
    }
  };

  const handleExportCsv = async () => {
    try {
      const res = await API.get(`/reports/loans/csv`, { responseType: 'blob' });
      const url = window.URL.createObjectURL(new Blob([res.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `loans_report.csv`);
      document.body.appendChild(link);
      link.click();
      link.parentNode.removeChild(link);
    } catch (err) {
      alert("Failed to download CSV report.");
    }
  };

  const handleReplaceSurety = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    try {
      await API.put(`/loans/${replacingSuretyLoan.id}/replace-surety?suretyIndex=${suretyIndexToReplace}&newSurety=${newSuretyMember}`);
      setReplacingSuretyLoan(null);
      setNewSuretyMember("");
      fetchInitialData();
    } catch (err) {
      alert(err.response?.data?.message || "Failed to replace surety.");
    } finally {
      setFormLoading(false);
    }
  };

  // Modern Online EMI Repayment via Razorpay
  const handleRepayment = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    try {
      // 1. Load Razorpay
      const res = await import("../utils/razorpay").then(m => m.loadRazorpayScript());
      if (!res) {
        alert("Razorpay SDK failed to load.");
        setFormLoading(false);
        return;
      }

      const amountToPay = parseFloat(repaymentAmount);

      // 2. Create Order
      const orderRes = await API.post("/payments/create-order", {
        amount: amountToPay,
        referenceType: "LOAN_REPAYMENT",
        referenceId: repayingLoan.id
      });
      const { orderId, amount, currency } = orderRes.data;

      // 3. Open Gateway
      const options = {
        key: "rzp_test_YourTestKeyIdHere", // MUST MATCH BACKEND!
        amount: amount.toString(),
        currency: currency,
        name: "LMS Enterprise",
        description: `EMI Repayment for Loan #${repayingLoan.loanNo}`,
        order_id: orderId,
        handler: async function (response) {
          try {
            await API.post("/payments/verify", {
              razorpay_payment_id: response.razorpay_payment_id,
              razorpay_order_id: response.razorpay_order_id,
              razorpay_signature: response.razorpay_signature
            });

            // Post actual repayment on success
            await API.post("/repayments", {
              loan: { id: repayingLoan.id },
              amountPaid: amountToPay,
            });
            
            setRepayingLoan(null);
            setRepaymentAmount("");
            fetchInitialData();
          } catch (err) {
            alert("Payment verification failed on server.");
          }
        },
        prefill: {
          name: repayingLoan.member?.name || "Member Name",
          contact: repayingLoan.member?.phoneNo || "9999999999"
        },
        theme: { color: "#4318ff" }
      };

      const rzp1 = new window.Razorpay(options);
      rzp1.on("payment.failed", function (response) {
        alert("Payment Failed: " + response.error.description);
      });
      rzp1.open();
    } catch (err) {
      alert(err.response?.data?.error || "Failed to initiate repayment.");
    } finally {
      setFormLoading(false);
    }
  };

  const filteredLoans = useMemo(() => {
    return loans.filter(l => 
      l.loanNo?.toLowerCase().includes(searchQuery.toLowerCase()) || 
      l.member?.name?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      l.member?.membershipNo?.toLowerCase().includes(searchQuery.toLowerCase())
    );
  }, [loans, searchQuery]);

  return (
    <main className="page-container animate__animated animate__fadeIn loans-container">
      <div className="page-header" style={{ marginBottom: '2rem' }}>
        <div className="page-title-group">
          <span style={{ fontSize: '0.85rem', color: '#64748b', fontWeight: 700, display: 'block', marginBottom: '6px', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
            Credit Management
          </span>
          <h1 className="gradient-heading">Loans & EMI Ledger</h1>
        </div>
      </div>

      <div className="loans-header-actions">
        <div className="search-bar-wrapper">
          <Search size={18} color="#94a3b8" />
          <input 
            type="text" 
            placeholder="Search loans by member or ID..." 
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        
        <div className="table-header-group">
          <button className="btn-enterprise btn-secondary" onClick={handleExportCsv}>
            <FileSpreadsheet size={16} /> Export CSV
          </button>
          {(isAdmin || isClerk || isMember) && (
            <button className="btn-enterprise btn-primary" onClick={() => setShowForm(true)}>
              <PlusCircle size={16} /> Apply For Loan
            </button>
          )}
        </div>
      </div>

      <div className="dashboard-card" style={{ padding: '0', overflow: 'hidden' }}>
        {loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" color="var(--primary)" />
            <p style={{ marginTop: '1rem', color: '#64748b' }}>Fetching active credit lines...</p>
          </div>
        ) : filteredLoans.length === 0 ? (
          <div className="empty-state">
            <CreditCard size={36} color="#94a3b8" />
            <p style={{ marginTop: '1rem', color: '#64748b' }}>No active loan profiles found.</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Loan ID</th>
                  <th>Member</th>
                  <th>Type</th>
                  <th>Principal Sanctioned</th>
                  <th>EMI Status</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredLoans.map(l => {
                  const sanctioned = l.amountSanctioned || l.amountRequested;
                  const paid = sanctioned - (l.outstandingPrincipal || sanctioned);
                  const progress = sanctioned > 0 ? (paid / sanctioned) * 100 : 0;
                  const isDisbursed = l.status === 'DISBURSED' || l.status === 'CLOSED';

                  return (
                  <tr key={l.id} className="interactive-row">
                    <td style={{ fontWeight: 800, color: 'var(--primary)' }}>{l.loanNo}</td>
                    <td>
                      <div style={{ fontWeight: 700, color: 'var(--text-primary)' }}>{l.member?.name || "N/A"}</div>
                      <div style={{ fontSize: '0.8rem', color: '#64748b' }}>{l.member?.membershipNo}</div>
                    </td>
                    <td style={{ color: '#64748b', fontWeight: 600 }}>{l.loanType}</td>
                    <td style={{ fontWeight: 700 }}>₹{sanctioned?.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>
                      {isDisbursed ? (
                        <div className="progress-wrapper">
                          <div className="progress-info">
                            <span>₹{paid.toLocaleString("en-IN", {maximumFractionDigits:0})} Paid</span>
                            <span>{Math.round(progress)}%</span>
                          </div>
                          <div className="progress-bar-bg">
                            <div className={`progress-bar-fill ${progress >= 100 ? 'complete' : ''}`} style={{ width: `${Math.min(progress, 100)}%` }}></div>
                          </div>
                        </div>
                      ) : (
                        <span style={{ color: '#94a3b8', fontSize: '0.85rem' }}>Pending Disbursal</span>
                      )}
                    </td>
                    <td>
                      <span className={`badge badge-${
                        l.status === 'APPLIED' ? 'warning' :
                        l.status === 'APPROVED' ? 'info' :
                        l.status === 'DISBURSED' ? 'success' :
                        l.status === 'REJECTED' ? 'danger' : 'secondary'
                      }`}>
                        {l.status}
                      </span>
                    </td>
                    <td>
                      <div style={{ display: "flex", gap: "8px", alignItems: 'center' }}>
                        <button className="btn-enterprise btn-secondary" onClick={() => navigate('/loans/' + l.id)} style={{ padding: '0.4rem 0.6rem' }}>
                          Inspect
                        </button>
                        
                        {l.status === "DISBURSED" && (
                          <button className="btn-enterprise btn-primary" onClick={() => { setRepayingLoan(l); setRepaymentAmount(l.monthlyInstallment || ""); }} style={{ padding: '0.4rem 0.8rem' }}>
                            Pay EMI
                          </button>
                        )}
                        
                        {l.status === "APPLIED" && (isAdmin || isAccountant) && (
                          <button className="btn-enterprise btn-success" onClick={() => setApprovingLoanId(l.id)} style={{ padding: '0.4rem 0.6rem' }}>
                            <CheckCircle size={14} /> Approve
                          </button>
                        )}
                        {l.status === "APPROVED" && (isAdmin || isClerk) && (
                          <button className="btn-enterprise btn-primary" onClick={() => handleDisburse(l.id)} style={{ padding: '0.4rem 0.6rem' }}>
                            Disburse
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                )})}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Slide-out Loan Inspector */}
      {selectedLoan && (
        <>
          <div className="slide-panel-overlay" onClick={() => setSelectedLoan(null)}></div>
          <div className="slide-panel">
            <button className="slide-panel-close" onClick={() => setSelectedLoan(null)}>
              <X size={20} />
            </button>
            
            <h2 style={{ fontSize: '1.6rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '4px' }}>
              Loan #{selectedLoan.loanNo}
            </h2>
            <p style={{ color: 'var(--primary)', fontWeight: 700, fontSize: '0.9rem', marginBottom: '1.5rem' }}>
              {selectedLoan.member?.name} • {selectedLoan.loanType}
            </p>

            <span className={`badge badge-${
                  selectedLoan.status === 'APPLIED' ? 'warning' :
                  selectedLoan.status === 'APPROVED' ? 'info' :
                  selectedLoan.status === 'DISBURSED' ? 'success' :
                  selectedLoan.status === 'REJECTED' ? 'danger' : 'secondary'
                }`}>
              Status: {selectedLoan.status}
            </span>

            <div className="loan-stat-grid">
              <div className="loan-stat-box">
                <span>Sanctioned Principal</span>
                <strong>₹{selectedLoan.amountSanctioned?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</strong>
              </div>
              <div className="loan-stat-box">
                <span>Outstanding Principal</span>
                <strong>₹{selectedLoan.outstandingPrincipal?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "0.00"}</strong>
              </div>
              <div className="loan-stat-box">
                <span>Monthly Installment (EMI)</span>
                <strong>₹{selectedLoan.monthlyInstallment?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</strong>
              </div>
              <div className="loan-stat-box">
                <span>Accrued Interest</span>
                <strong>₹{selectedLoan.outstandingInterest?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "0.00"}</strong>
              </div>
            </div>

            <div className="inspector-section-title">Timeline & Terms</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.8rem', fontSize: '0.9rem', color: '#475569' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Application Date</strong>
                <span>{selectedLoan.appliedDate ? new Date(selectedLoan.appliedDate).toLocaleDateString("en-IN") : "N/A"}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Sanction Date</strong>
                <span>{selectedLoan.sanctionedDate ? new Date(selectedLoan.sanctionedDate).toLocaleDateString("en-IN") : "N/A"}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Interest Rate</strong>
                <span>{selectedLoan.interestRate || "0"}% p.a.</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Purpose</strong>
                <span>{selectedLoan.purpose || "N/A"}</span>
              </div>
            </div>

            <div className="inspector-section-title">Guarantors (Sureties)</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.8rem', fontSize: '0.9rem', color: '#475569' }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <strong style={{ color: '#0f172a' }}>Surety 1</strong>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span>{selectedLoan.surety1 || "None"}</span>
                  {(isAdmin || isClerk) && (
                    <button className="btn-enterprise btn-secondary" style={{ padding: '0.2rem 0.5rem', fontSize: '0.75rem' }} onClick={() => {setReplacingSuretyLoan(selectedLoan); setSuretyIndexToReplace(1);}}>Replace</button>
                  )}
                </div>
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <strong style={{ color: '#0f172a' }}>Surety 2</strong>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span>{selectedLoan.surety2 || "None"}</span>
                  {(isAdmin || isClerk) && (
                    <button className="btn-enterprise btn-secondary" style={{ padding: '0.2rem 0.5rem', fontSize: '0.75rem' }} onClick={() => {setReplacingSuretyLoan(selectedLoan); setSuretyIndexToReplace(2);}}>Replace</button>
                  )}
                </div>
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <strong style={{ color: '#0f172a' }}>Surety 3</strong>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span>{selectedLoan.surety3 || "None"}</span>
                  {(isAdmin || isClerk) && (
                    <button className="btn-enterprise btn-secondary" style={{ padding: '0.2rem 0.5rem', fontSize: '0.75rem' }} onClick={() => {setReplacingSuretyLoan(selectedLoan); setSuretyIndexToReplace(3);}}>Replace</button>
                  )}
                </div>
              </div>
            </div>
            
            <div style={{ marginTop: '3rem', display: 'flex', gap: '1rem' }}>
              {selectedLoan.status === "DISBURSED" && (
                <button className="btn-enterprise btn-primary" style={{ flex: 1, justifyContent: 'center' }} onClick={() => { setRepayingLoan(selectedLoan); setRepaymentAmount(selectedLoan.monthlyInstallment || ""); setSelectedLoan(null); }}>
                  Pay EMI Online
                </button>
              )}
            </div>
          </div>
        </>
      )}

      {/* Apply Loan Modal Overlay */}
      {showForm && (
        <div className="modal-overlay" onClick={() => setShowForm(false)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()}>
            <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem' }}>Apply for Credit</h3>
            <form onSubmit={handleApplyLoan}>
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
                  <span className="enterprise-label">Loan Scheme</span>
                  <select className="enterprise-select" value={form.loanType} onChange={(e) => setForm({ ...form, loanType: e.target.value })} required>
                    <option value="LTL">Long Term Loan (LTL)</option>
                    <option value="EXL">Emergency Loan (EXL)</option>
                  </select>
                </label>

                <label className="enterprise-form-group">
                  <span className="enterprise-label">Requested Principal (₹)</span>
                  <input className="enterprise-input" type="number" value={form.amountRequested} onChange={(e) => setForm({ ...form, amountRequested: e.target.value })} required />
                </label>

                <label className="enterprise-form-group">
                  <span className="enterprise-label">Duration (Months)</span>
                  <input className="enterprise-input" type="number" value={form.durationMonths} onChange={(e) => setForm({ ...form, durationMonths: e.target.value })} required />
                </label>
              </div>

              <label className="enterprise-form-group full-width" style={{ marginTop: '1.25rem' }}>
                <span className="enterprise-label">Purpose / Narration</span>
                <input className="enterprise-input" type="text" placeholder="Medical, housing, education..." value={form.purpose} onChange={(e) => setForm({ ...form, purpose: e.target.value })} required />
              </label>

              <h4 style={{ marginTop: '2rem', marginBottom: '1rem', borderBottom: '1px solid #e2e8f0', paddingBottom: '0.5rem', fontSize: '1.1rem' }}>Sureties / Guarantors</h4>
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: '1.25rem' }}>
                <label className="enterprise-form-group">
                  <select className="enterprise-select" value={form.surety1} onChange={(e) => setForm({ ...form, surety1: e.target.value })}>
                    <option value="">-- Surety 1 --</option>
                    {members.filter(m => m.id != form.memberId).map(m => (
                      <option key={m.id} value={m.membershipNo}>{m.name}</option>
                    ))}
                  </select>
                </label>
                <label className="enterprise-form-group">
                  <select className="enterprise-select" value={form.surety2} onChange={(e) => setForm({ ...form, surety2: e.target.value })}>
                    <option value="">-- Surety 2 --</option>
                    {members.filter(m => m.id != form.memberId).map(m => (
                      <option key={m.id} value={m.membershipNo}>{m.name}</option>
                    ))}
                  </select>
                </label>
                <label className="enterprise-form-group">
                  <select className="enterprise-select" value={form.surety3} onChange={(e) => setForm({ ...form, surety3: e.target.value })}>
                    <option value="">-- Surety 3 --</option>
                    {members.filter(m => m.id != form.memberId).map(m => (
                      <option key={m.id} value={m.membershipNo}>{m.name}</option>
                    ))}
                  </select>
                </label>
              </div>

              {formSuccess && <div className="alert alert-success mt-4">{formSuccess}</div>}
              {error && <div className="alert alert-danger mt-4">{error}</div>}

              <div className="form-actions">
                <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowForm(false)}>Cancel</button>
                <button type="submit" disabled={formLoading} className="btn-enterprise btn-primary">
                  {formLoading ? "Submitting..." : "Apply Loan"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Sanction Modal Overlay */}
      {approvingLoanId && (
        <div className="modal-overlay">
          <div className="modal-box small-modal glass-card">
            <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem' }}>Approve Loan Sanction</h3>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Sanctioned Principal Amount (₹)</span>
              <input className="enterprise-input" type="number" value={sanctionedAmount} onChange={(e) => setSanctionedAmount(e.target.value)} required />
            </label>
            <div className="form-actions">
              <button onClick={() => setApprovingLoanId(null)} className="btn-enterprise btn-secondary">Cancel</button>
              <button onClick={() => handleApprove(approvingLoanId)} className="btn-enterprise btn-success">Confirm Sanction</button>
            </div>
          </div>
        </div>
      )}

      {/* Post Repayment Modal Overlay via Razorpay */}
      {repayingLoan && (
        <div className="modal-overlay">
          <div className="modal-box small-modal glass-card">
            <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '0.5rem' }}>Pay Loan EMI Online</h3>
            <p className="enterprise-label" style={{ marginBottom: '1.5rem' }}>Loan No: <strong style={{ color: 'var(--primary)' }}>{repayingLoan.loanNo}</strong></p>
            <form onSubmit={handleRepayment}>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Amount to Pay (₹)</span>
                <input className="enterprise-input" type="number" value={repaymentAmount} onChange={(e) => setRepaymentAmount(e.target.value)} required />
              </label>
              <div className="form-actions">
                <button type="button" onClick={() => setRepayingLoan(null)} className="btn-enterprise btn-secondary">Cancel</button>
                <button type="submit" disabled={formLoading} className="btn-enterprise btn-primary">
                  {formLoading ? "Processing..." : "Pay via Razorpay"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Replace Surety Modal */}
      {replacingSuretyLoan && (
        <div className="modal-overlay">
          <div className="modal-box small-modal glass-card">
            <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '0.5rem' }}>Replace Surety {suretyIndexToReplace}</h3>
            <p className="enterprise-label" style={{ marginBottom: '1.5rem' }}>Loan No: <strong style={{ color: 'var(--primary)' }}>{replacingSuretyLoan.loanNo}</strong></p>
            <form onSubmit={handleReplaceSurety}>
              <label className="enterprise-form-group">
                <span className="enterprise-label">New Surety Member</span>
                <select className="enterprise-select" value={newSuretyMember} onChange={(e) => setNewSuretyMember(e.target.value)} required>
                  <option value="">-- Choose New Surety --</option>
                  {members.filter(m => m.id != replacingSuretyLoan.member?.id).map(m => (
                    <option key={m.id} value={m.membershipNo}>{m.name} ({m.membershipNo})</option>
                  ))}
                </select>
              </label>
              <div className="form-actions" style={{ marginTop: '1.5rem' }}>
                <button type="button" onClick={() => setReplacingSuretyLoan(null)} className="btn-enterprise btn-secondary">Cancel</button>
                <button type="submit" disabled={formLoading} className="btn-enterprise btn-primary">
                  {formLoading ? "Updating..." : "Update Surety"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </main>
  );
}
