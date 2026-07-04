import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { ArrowLeft, CreditCard } from "lucide-react";
import API from "../api/axios";

export default function LoanDetails() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [loan, setLoan] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [formLoading, setFormLoading] = useState(false);

  // Role Parsing
  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isClerk = roles.includes("ROLE_CLERK");

  // Modals for actions
  const [repayingLoan, setRepayingLoan] = useState(null);
  const [repaymentAmount, setRepaymentAmount] = useState("");
  const [replacingSuretyLoan, setReplacingSuretyLoan] = useState(null);
  const [suretyIndexToReplace, setSuretyIndexToReplace] = useState(1);
  const [newSuretyMember, setNewSuretyMember] = useState("");
  const [members, setMembers] = useState([]);

  useEffect(() => {
    fetchLoan();
    if (isAdmin || isClerk) {
      fetchMembers();
    }
  }, [id]);

  const fetchLoan = async () => {
    setLoading(true);
    try {
      const res = await API.get(`/loans/${id}`);
      setLoan(res.data);
    } catch (err) {
      console.error(err);
      setError("Failed to fetch loan details.");
    } finally {
      setLoading(false);
    }
  };

  const fetchMembers = async () => {
    try {
      const res = await API.get("/members");
      setMembers(res.data || []);
    } catch (err) {
      console.error(err);
    }
  };

  const handleRepayment = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    try {
      await API.post(`/loans/${loan.id}/repay`, {
        amount: parseFloat(repaymentAmount),
        paymentMethod: "RAZORPAY",
        referenceNo: "ONLINE_PAY_" + Date.now()
      });
      setRepayingLoan(null);
      setRepaymentAmount("");
      fetchLoan();
    } catch (err) {
      console.error(err);
      alert("Repayment failed");
    } finally {
      setFormLoading(false);
    }
  };

  const handleReplaceSurety = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    try {
      await API.put(`/loans/${loan.id}/sureties/${suretyIndexToReplace}`, {
        membershipNo: newSuretyMember
      });
      setReplacingSuretyLoan(null);
      fetchLoan();
    } catch (err) {
      console.error(err);
      alert("Failed to update surety");
    } finally {
      setFormLoading(false);
    }
  };

  if (loading) return <div className="page-container">Loading...</div>;
  if (error || !loan) return <div className="page-container alert alert-danger">{error || "Loan not found"}</div>;

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/loans")} style={{ marginBottom: '1.5rem' }}>
        <ArrowLeft size={16} /> Back to Loans Ledger
      </button>

      <div className="glass-card" style={{ padding: '2.5rem' }}>
        <h2 style={{ fontSize: '2rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '8px' }}>
          Loan #{loan.loanNo}
        </h2>
        <p style={{ color: 'var(--primary)', fontWeight: 700, fontSize: '1.1rem', marginBottom: '2rem' }}>
          {loan.member?.name} • {loan.loanType}
        </p>

        <span className={`badge badge-${
              loan.status === 'APPLIED' ? 'warning' :
              loan.status === 'APPROVED' ? 'info' :
              loan.status === 'DISBURSED' ? 'success' :
              loan.status === 'REJECTED' ? 'danger' : 'secondary'
            }`} style={{ fontSize: '1rem', padding: '0.4rem 0.8rem', marginBottom: '2rem', display: 'inline-block' }}>
          Status: {loan.status}
        </span>

        <div className="loan-stat-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '1.5rem', marginBottom: '3rem' }}>
          <div className="loan-stat-box" style={{ padding: '1.5rem', background: 'rgba(255,255,255,0.5)', borderRadius: '12px', border: '1px solid var(--glass-border)' }}>
            <span style={{ fontSize: '0.85rem', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 600 }}>Sanctioned Principal</span>
            <strong style={{ display: 'block', fontSize: '1.5rem', color: '#0f172a', marginTop: '0.5rem' }}>₹{loan.amountSanctioned?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</strong>
          </div>
          <div className="loan-stat-box" style={{ padding: '1.5rem', background: 'rgba(255,255,255,0.5)', borderRadius: '12px', border: '1px solid var(--glass-border)' }}>
            <span style={{ fontSize: '0.85rem', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 600 }}>Outstanding Principal</span>
            <strong style={{ display: 'block', fontSize: '1.5rem', color: '#0f172a', marginTop: '0.5rem' }}>₹{loan.outstandingPrincipal?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "0.00"}</strong>
          </div>
          <div className="loan-stat-box" style={{ padding: '1.5rem', background: 'rgba(255,255,255,0.5)', borderRadius: '12px', border: '1px solid var(--glass-border)' }}>
            <span style={{ fontSize: '0.85rem', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 600 }}>Monthly Installment (EMI)</span>
            <strong style={{ display: 'block', fontSize: '1.5rem', color: '#0f172a', marginTop: '0.5rem' }}>₹{loan.monthlyInstallment?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "-"}</strong>
          </div>
          <div className="loan-stat-box" style={{ padding: '1.5rem', background: 'rgba(255,255,255,0.5)', borderRadius: '12px', border: '1px solid var(--glass-border)' }}>
            <span style={{ fontSize: '0.85rem', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 600 }}>Accrued Interest</span>
            <strong style={{ display: 'block', fontSize: '1.5rem', color: '#0f172a', marginTop: '0.5rem' }}>₹{loan.outstandingInterest?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || "0.00"}</strong>
          </div>
        </div>

        <h3 style={{ fontSize: '1.4rem', fontWeight: 700, marginBottom: '1.5rem', color: '#0f172a', borderBottom: '2px solid #e2e8f0', paddingBottom: '0.5rem' }}>Timeline & Terms</h3>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.5rem', fontSize: '1rem', color: '#475569', marginBottom: '3rem' }}>
          <div><strong style={{ color: '#0f172a', display: 'block' }}>Application Date</strong> {loan.appliedDate ? new Date(loan.appliedDate).toLocaleDateString("en-IN") : "N/A"}</div>
          <div><strong style={{ color: '#0f172a', display: 'block' }}>Sanction Date</strong> {loan.sanctionedDate ? new Date(loan.sanctionedDate).toLocaleDateString("en-IN") : "N/A"}</div>
          <div><strong style={{ color: '#0f172a', display: 'block' }}>Interest Rate</strong> {loan.interestRate || "0"}% p.a.</div>
          <div><strong style={{ color: '#0f172a', display: 'block' }}>Purpose</strong> {loan.purpose || "N/A"}</div>
        </div>

        <h3 style={{ fontSize: '1.4rem', fontWeight: 700, marginBottom: '1.5rem', color: '#0f172a', borderBottom: '2px solid #e2e8f0', paddingBottom: '0.5rem' }}>Guarantors (Sureties)</h3>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1.5rem', fontSize: '1rem', color: '#475569' }}>
          {[1, 2, 3].map((num) => {
            const suretyValue = loan[`surety${num}`];
            return (
              <div key={num} style={{ padding: '1rem', background: 'rgba(241,245,249,0.5)', borderRadius: '8px' }}>
                <strong style={{ color: '#0f172a', display: 'block', marginBottom: '0.5rem' }}>Surety {num}</strong>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span>{suretyValue || "None"}</span>
                  {(isAdmin || isClerk) && (
                    <button className="btn-enterprise btn-secondary" style={{ padding: '0.3rem 0.6rem', fontSize: '0.8rem' }} onClick={() => { setReplacingSuretyLoan(loan); setSuretyIndexToReplace(num); }}>Replace</button>
                  )}
                </div>
              </div>
            );
          })}
        </div>
        
        {loan.status === "DISBURSED" && (
          <div style={{ marginTop: '3rem', paddingTop: '2rem', borderTop: '1px solid #e2e8f0', display: 'flex', justifyContent: 'center' }}>
            <button className="btn-enterprise btn-primary" style={{ padding: '1rem 3rem', fontSize: '1.1rem' }} onClick={() => { setRepayingLoan(loan); setRepaymentAmount(loan.monthlyInstallment || ""); }}>
              <CreditCard size={20} /> Pay EMI Online
            </button>
          </div>
        )}
      </div>

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
