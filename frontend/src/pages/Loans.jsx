import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { CreditCard, PlusCircle, RefreshCw, CheckCircle, XCircle, ArrowRight, ArrowLeft, ShieldCheck, Eye } from "lucide-react";
import API from "../api/axios";
import "./Loans.css";

const emptyForm = {
  memberId: "",
  loanType: "LTL", // LTL or EXL
  amountRequested: "",
  durationMonths: "12",
  purpose: "",
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
  
  // Dialog/Form overlays
  const [approvingLoanId, setApprovingLoanId] = useState(null);
  const [sanctionedAmount, setSanctionedAmount] = useState("");
  const [repayingLoan, setRepayingLoan] = useState(null);
  const [repaymentAmount, setRepaymentAmount] = useState("");

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
        // Fetch personal loans for Member
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
      setForm(emptyForm);
      setShowForm(false);
      fetchInitialData();
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
    if (!window.confirm("Are you sure you want to reject this loan application?")) {
      return;
    }
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

  const handleRepayment = async (e) => {
    e.preventDefault();
    try {
      const payload = {
        loan: { id: repayingLoan.id },
        amountPaid: parseFloat(repaymentAmount),
      };
      await API.post("/repayments", payload);
      setRepayingLoan(null);
      setRepaymentAmount("");
      fetchInitialData();
    } catch (err) {
      alert(err.response?.data?.message || "Failed to post repayment.");
    }
  };

  return (
    <main className="loans-page">
      <button className="back-btn" onClick={() => navigate("/dashboard")} style={{ marginBottom: 15, display: "inline-flex", alignItems: "center", gap: 6, border: "none", background: "none", cursor: "pointer", fontWeight: 700, color: "#64748b" }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header">
        <div>
          <h1>Loans & Repayments Ledger</h1>
          <p>Request advances, track installments, and disburse active credits</p>
        </div>
        {(isAdmin || isClerk) && (
          <button className="open-form-btn" onClick={() => setShowForm(!showForm)}>
            <PlusCircle size={18} />
            Apply For Loan
          </button>
        )}
      </header>

      {/* Apply Loan Form */}
      {showForm && (
        <section className="deposit-form-wrapper">
          <form onSubmit={handleApplyLoan} className="deposit-form">
            <h3>Apply for Credit / Loan</h3>
            
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
                <span>Loan Scheme</span>
                <select value={form.loanType} onChange={(e) => setForm({ ...form, loanType: e.target.value })} required>
                  <option value="LTL">Long Term Loan (LTL)</option>
                  <option value="EXL">Emergency Loan (EXL)</option>
                </select>
              </label>
            </div>

            <div className="form-row">
              <label>
                <span>Requested Principal (₹)</span>
                <input type="number" value={form.amountRequested} onChange={(e) => setForm({ ...form, amountRequested: e.target.value })} required />
              </label>

              <label>
                <span>Duration (Tenure Months)</span>
                <input type="number" value={form.durationMonths} onChange={(e) => setForm({ ...form, durationMonths: e.target.value })} required />
              </label>
            </div>

            <label className="purpose-label">
              <span>Purpose / Narration</span>
              <input type="text" placeholder="Medical, housing, education..." value={form.purpose} onChange={(e) => setForm({ ...form, purpose: e.target.value })} required />
            </label>

            {formSuccess && <div className="form-success-msg">{formSuccess}</div>}
            {error && <div className="form-error-msg">{error}</div>}

            <div className="form-actions">
              <button type="submit" disabled={formLoading} className="submit-btn">
                {formLoading ? "Submitting..." : "Apply Loan"}
              </button>
              <button type="button" className="cancel-btn" onClick={() => setShowForm(false)}>Cancel</button>
            </div>
          </form>
        </section>
      )}

      {/* Sanction Modal Overlay */}
      {approvingLoanId && (
        <div className="modal-overlay">
          <div className="modal-card">
            <h3>Approve Loan Sanction</h3>
            <label>
              <span>Sanctioned Principal Amount (₹)</span>
              <input type="number" value={sanctionedAmount} onChange={(e) => setSanctionedAmount(e.target.value)} required />
            </label>
            <div className="modal-actions">
              <button onClick={() => handleApprove(approvingLoanId)} className="submit-btn">Confirm Approve</button>
              <button onClick={() => setApprovingLoanId(null)} className="cancel-btn">Cancel</button>
            </div>
          </div>
        </div>
      )}

      {/* Post Repayment Modal Overlay */}
      {repayingLoan && (
        <div className="modal-overlay">
          <div className="modal-card">
            <h3>Post Loan Repayment</h3>
            <p>Repaying Loan No: <strong>{repayingLoan.loanNo}</strong></p>
            <form onSubmit={handleRepayment}>
              <label>
                <span>Repayment Installment Amount (₹)</span>
                <input type="number" value={repaymentAmount} onChange={(e) => setRepaymentAmount(e.target.value)} required />
              </label>
              <div className="modal-actions">
                <button type="submit" className="submit-btn">Confirm Payment</button>
                <button type="button" onClick={() => setRepayingLoan(null)} className="cancel-btn">Cancel</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Loans List */}
      <section className="deposits-list">
        <h2>System Loans Registry</h2>
        {loading ? (
          <div className="loading-state">
            <RefreshCw size={28} className="spin-icon" />
            <p>Fetching active loan cards...</p>
          </div>
        ) : loans.length === 0 ? (
          <div className="empty-state">
            <CreditCard size={36} />
            <p>No active loan profiles recorded.</p>
          </div>
        ) : (
          <div className="table-wrap">
            <table className="deposits-table">
              <thead>
                <tr>
                  <th>Loan No</th>
                  <th>Member</th>
                  <th>Type</th>
                  <th>Requested</th>
                  <th>Sanctioned</th>
                  <th>O/S Principal</th>
                  <th>EMI</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {loans.map(l => (
                  <tr key={l.id}>
                    <td>{l.loanNo}</td>
                    <td>{l.member?.name || "N/A"}</td>
                    <td>{l.loanType}</td>
                    <td>₹{l.amountRequested?.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>₹{l.amountSanctioned?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</td>
                    <td>₹{l.outstandingPrincipal?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "0.00"}</td>
                    <td>₹{l.monthlyInstallment?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</td>
                    <td>
                      <span className={`status-badge ${l.status?.toLowerCase()}`}>
                        {l.status}
                      </span>
                    </td>
                    <td>
                      <div className="action-row" style={{ display: "flex", gap: 10 }}>
                        <button className="close-btn" onClick={() => setSelectedLoan(l)} title="Inspect Loan Details" style={{ color: "#0ea5e9", background: "none", border: "none", cursor: "pointer", display: "flex", alignItems: "center" }}>
                          <Eye size={16} />
                        </button>
                        {/* Approve/Reject (Admin/Accountant) */}
                        {l.status === "APPLIED" && (isAdmin || isAccountant) && (
                          <>
                            <button className="approve-btn" onClick={() => setApprovingLoanId(l.id)} title="Approve Sanction">
                              <CheckCircle size={16} />
                            </button>
                            <button className="reject-btn" onClick={() => handleReject(l.id)} title="Reject Application">
                              <XCircle size={16} />
                            </button>
                          </>
                        )}
                        {/* Disburse (Clerk/Admin) */}
                        {l.status === "APPROVED" && (isAdmin || isClerk) && (
                          <button className="disburse-btn" onClick={() => handleDisburse(l.id)} title="Disburse Funds">
                            Disburse
                          </button>
                        )}
                        {/* Make Repayment (Clerk/Admin) */}
                        {l.status === "DISBURSED" && (isAdmin || isClerk) && (
                          <button className="repay-action-btn" onClick={() => setRepayingLoan(l)} title="Post Repayment">
                            Repay
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

      {/* Selected Loan Details Modal */}
      {selectedLoan && (
        <div className="modal-overlay" onClick={() => setSelectedLoan(null)}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h3>Loan Account Inspector</h3>
            <div className="details-grid" style={{ display: "grid", gridTemplateColumns: "1fr", gap: 12, margin: "20px 0", textAlign: "left", fontSize: "0.95rem" }}>
              <div><strong>Loan Number:</strong> {selectedLoan.loanNo}</div>
              <div><strong>Member Profile:</strong> {selectedLoan.member?.name} ({selectedLoan.member?.membershipNo})</div>
              <div><strong>Loan Scheme:</strong> {selectedLoan.loanType}</div>
              <div><strong>Requested Principal:</strong> ₹{selectedLoan.amountRequested?.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</div>
              <div><strong>Sanctioned Principal:</strong> ₹{selectedLoan.amountSanctioned?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</div>
              <div><strong>Outstanding Principal Balance:</strong> ₹{selectedLoan.outstandingPrincipal?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "0.00"}</div>
              <div><strong>Outstanding Accrued Interest:</strong> ₹{selectedLoan.outstandingInterest?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "0.00"}</div>
              <div><strong>Monthly Installment (EMI):</strong> ₹{selectedLoan.monthlyInstallment?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</div>
              <div><strong>Interest Rate:</strong> {selectedLoan.interestRate || "0"}%</div>
              <div><strong>Purpose:</strong> {selectedLoan.purpose || "N/A"}</div>
              <div><strong>Application Date:</strong> {selectedLoan.appliedDate ? new Date(selectedLoan.appliedDate).toLocaleDateString("en-IN") : "N/A"}</div>
              <div><strong>Sanction Date:</strong> {selectedLoan.sanctionedDate ? new Date(selectedLoan.sanctionedDate).toLocaleDateString("en-IN") : "N/A"}</div>
              <div><strong>Disbursed By:</strong> {selectedLoan.disbursedBy || "N/A"}</div>
              <div><strong>Status:</strong> <span className={`status-badge ${selectedLoan.status?.toLowerCase()}`}>{selectedLoan.status}</span></div>
            </div>
            <div className="modal-actions">
              <button className="cancel-btn" onClick={() => setSelectedLoan(null)}>Close Inspector</button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}
