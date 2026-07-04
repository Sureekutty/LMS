import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, PlusCircle, RefreshCw, FileText, Download, DollarSign, Printer, CheckCircle } from "lucide-react";
import API from "../api/axios";
import "./Bills.css";

const emptyPayForm = {
  billId: "",
  amount: "",
  memberName: "",
  totalOutstanding: 0
};

export default function Bills() {
  const navigate = useNavigate();
  const [bills, setBills] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  
  const [monthStr, setMonthStr] = useState(new Date().toISOString().split("T")[0].substring(0, 7)); // YYYY-MM
  const [showPayModal, setShowPayModal] = useState(false);
  const [payForm, setPayForm] = useState(emptyPayForm);
  const [selectedBill, setSelectedBill] = useState(null); // For Invoice Statement view

  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isClerk = roles.includes("ROLE_CLERK");
  const isMember = roles.includes("ROLE_MEMBER") && !isAdmin && !isAccountant && !isClerk;
  
  const fetchBills = async () => {
    setLoading(true);
    setError("");
    try {
      if (isMember) {
        // Members see their own billing history
        const meRes = await API.get("/members/me");
        const member = meRes.data;
        if (member && member.id) {
          const res = await API.get(`/api/bills/member/${member.id}`);
          setBills(res.data || []);
        }
      } else {
        // Staff see bills by month
        const res = await API.get(`/bills/month/${monthStr}`);
        setBills(res.data || []);
      }
    } catch (err) {
      console.error(err);
      setError("Failed to fetch demand billing statement data.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBills();
  }, [monthStr]);

  const handleGenerateBills = async () => {
    setLoading(true);
    setError("");
    setSuccess("");
    try {
      await API.post(`/bills/generate?month=${monthStr}`);
      setSuccess(`Consolidated demand bills for ${monthStr} generated successfully!`);
      fetchBills();
    } catch (err) {
      setError(err.response?.data?.message || "Failed to generate billing records.");
    } finally {
      setLoading(false);
    }
  };

  const handlePayBill = async (e) => {
    e.preventDefault();
    setError("");
    setSuccess("");
    try {
      await API.post("/bills/pay", {
        billId: payForm.billId,
        amount: parseFloat(payForm.amount)
      });
      setSuccess("Monthly bill recovery payment posted successfully!");
      setShowPayModal(false);
      setPayForm(emptyPayForm);
      fetchBills();
    } catch (err) {
      setError(err.response?.data?.message || "Failed to post recovery payment.");
    }
  };

  const openPayment = (bill) => {
    setPayForm({
      billId: bill.id,
      amount: (bill.totalAmount - bill.amountPaid).toFixed(2),
      memberName: bill.member?.name,
      totalOutstanding: (bill.totalAmount - bill.amountPaid).toFixed(2)
    });
    setShowPayModal(true);
  };

  const printInvoice = () => {
    window.print();
  };

  const totalDemanded = bills.reduce((sum, b) => sum + b.totalAmount, 0);
  const totalRecovered = bills.reduce((sum, b) => sum + b.amountPaid, 0);

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header">
        <div className="page-title-group">
          <h1 className="gradient-heading">Periodic Demand Billing (Invoices)</h1>
          <p>{isMember ? "Your monthly society billing statements and statements." : "Process, review, and recover monthly billing demands."}</p>
        </div>
        {!isMember && (isAdmin || isAccountant) && (
          <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
            <input
              className="enterprise-input"
              type="month"
              value={monthStr}
              onChange={(e) => setMonthStr(e.target.value)}
              style={{ width: 'auto' }}
            />
            <button className="btn-enterprise btn-primary" onClick={handleGenerateBills} disabled={loading}>
              <PlusCircle size={18} />
              {loading ? "Generating..." : "Generate Demands"}
            </button>
          </div>
        )}
      </header>

      {error && <div className="alert alert-danger" style={{ marginBottom: 15 }}>{error}</div>}
      {success && <div className="alert alert-success" style={{ marginBottom: 15 }}>{success}</div>}

      {/* Summary Cards */}
      {!isMember && (
        <section className="dashboard-stats" style={{ marginBottom: 30, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.5rem' }}>
          <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
            <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#e0f2fe', color: '#0369a1' }}>
              <DollarSign size={28} />
            </div>
            <div>
              <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Demanded ({monthStr})</h4>
              <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{totalDemanded.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
            </div>
          </div>
          <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
            <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#dcfce7', color: '#15803d' }}>
              <CheckCircle size={28} />
            </div>
            <div>
              <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Recovered ({monthStr})</h4>
              <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{totalRecovered.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
            </div>
          </div>
        </section>
      )}

      {/* Bills Ledger */}
      <section>
        <h2 style={{ fontSize: '1.35rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>{isMember ? "Your Invoices History" : `Consolidated Billing Registry - ${monthStr}`}</h2>
        {loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" />
            <p style={{ marginTop: '1rem' }}>Compiling statements...</p>
          </div>
        ) : bills.length === 0 ? (
          <div className="empty-state">
            <FileText size={36} />
            <p style={{ marginTop: '1rem' }}>No billing records found. Ensure demands are generated.</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Bill No</th>
                  <th>Month</th>
                  {!isMember && <th>Member</th>}
                  <th>Thrift Savings</th>
                  <th>Loan Principal</th>
                  <th>Loan Interest</th>
                  <th>RD Deposit</th>
                  <th>Total Due</th>
                  <th>Amount Paid</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {bills.map(b => (
                  <tr key={b.id}>
                    <td><strong>{b.billNo}</strong></td>
                    <td>{b.processMonth}</td>
                    {!isMember && <td>{b.member?.name} ({b.member?.membershipNo})</td>}
                    <td>₹{b.thriftContribution.toLocaleString("en-IN")}</td>
                    <td>₹{b.loanPrincipalDue.toLocaleString("en-IN")}</td>
                    <td>₹{b.loanInterestDue.toLocaleString("en-IN")}</td>
                    <td>₹{b.recurringDepositDue.toLocaleString("en-IN")}</td>
                    <td style={{ fontWeight: 700 }}>₹{b.totalAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td style={{ color: "var(--success)", fontWeight: 700 }}>₹{b.amountPaid.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>
                      <span className={`badge badge-${
                        b.status === 'PAID' ? 'success' :
                        b.status === 'PARTIAL' ? 'warning' : 'danger'
                      }`}>
                        {b.status}
                      </span>
                    </td>
                    <td>
                      <div style={{ display: "flex", gap: "8px", alignItems: 'center' }}>
                        <button className="btn-enterprise btn-secondary" onClick={() => setSelectedBill(b)} style={{ padding: '0.4rem 0.6rem' }}>
                          <FileText size={14} /> View
                        </button>
                        {!isMember && (isAdmin || isAccountant || isClerk) && b.status !== "PAID" && (
                          <button className="btn-enterprise btn-success" onClick={() => openPayment(b)} style={{ padding: '0.4rem 0.6rem' }}>
                            <DollarSign size={14} /> Collect
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

      {/* Bill Recovery Modal */}
      {showPayModal && (
        <div className="modal-overlay" onClick={() => setShowPayModal(false)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()} style={{ maxWidth: 450 }}>
            <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem' }}>Post Salary/Cash Bill Recovery</h3>
            <form onSubmit={handlePayBill}>
              <div style={{ marginBottom: 20, padding: '1rem', backgroundColor: '#f8fafc', borderRadius: 'var(--radius-md)' }}>
                <p style={{ marginBottom: '0.5rem' }}><strong>Member Name:</strong> {payForm.memberName}</p>
                <p><strong>Outstanding Balance:</strong> ₹{payForm.totalOutstanding}</p>
              </div>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Enter Amount Recovered (₹)</span>
                <input
                  className="enterprise-input"
                  type="number"
                  step="0.01"
                  value={payForm.amount}
                  onChange={(e) => setPayForm({ ...payForm, amount: e.target.value })}
                  max={payForm.totalOutstanding}
                  required
                />
              </label>
              <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem' }}>
                <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowPayModal(false)}>Cancel</button>
                <button type="submit" className="btn-enterprise btn-success">Post Recovery</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Invoice Statement Overlay */}
      {selectedBill && (
        <div className="modal-overlay print-modal" onClick={() => setSelectedBill(null)}>
          <div className="invoice-box" onClick={(e) => e.stopPropagation()}>
            <div className="invoice-header">
              <div>
                <h2>LMS DEMAND STATEMENT</h2>
                <p>Bill Ref: {selectedBill.billNo}</p>
                <p>Month: {selectedBill.processMonth}</p>
              </div>
              <div style={{ textAlign: "right" }}>
                <h3>Society Billing</h3>
                <p>Status: <strong>{selectedBill.status}</strong></p>
              </div>
            </div>

            <div className="invoice-details">
              <h4>Billed To:</h4>
              <p><strong>Name:</strong> {selectedBill.member?.name}</p>
              <p><strong>Membership Number:</strong> {selectedBill.member?.membershipNo}</p>
              <p><strong>Staff Code / Division:</strong> {selectedBill.member?.staffCode} / {selectedBill.member?.sectionDivision}</p>
            </div>

            <table className="invoice-table">
              <thead>
                <tr>
                  <th>Demand Description</th>
                  <th style={{ textAlign: "right" }}>Amount Billed</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Monthly Mandatory Thrift Savings Contribution</td>
                  <td style={{ textAlign: "right" }}>₹{selectedBill.thriftContribution.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                </tr>
                {selectedBill.loanPrincipalDue > 0 && (
                  <tr>
                    <td>Outstanding Loan Principal Installment due</td>
                    <td style={{ textAlign: "right" }}>₹{selectedBill.loanPrincipalDue.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                  </tr>
                )}
                {selectedBill.loanInterestDue > 0 && (
                  <tr>
                    <td>Outstanding Loan Interest accrued</td>
                    <td style={{ textAlign: "right" }}>₹{selectedBill.loanInterestDue.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                  </tr>
                )}
                {selectedBill.recurringDepositDue > 0 && (
                  <tr>
                    <td>Recurring Deposit RD Subscription due</td>
                    <td style={{ textAlign: "right" }}>₹{selectedBill.recurringDepositDue.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                  </tr>
                )}
                <tr className="invoice-total">
                  <td><strong>TOTAL DEMAND DUE</strong></td>
                  <td style={{ textAlign: "right" }}><strong>₹{selectedBill.totalAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</strong></td>
                </tr>
                <tr className="invoice-recovered">
                  <td>Amount Recovered/Credited</td>
                  <td style={{ textAlign: "right", color: "var(--success)" }}>₹{selectedBill.amountPaid.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                </tr>
              </tbody>
            </table>

            <div className="invoice-footer no-print">
              <button className="btn-enterprise btn-primary" onClick={printInvoice}>
                <Printer size={16} /> Print Statement
              </button>
              <button className="btn-enterprise btn-secondary" onClick={() => setSelectedBill(null)}>Close</button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}
