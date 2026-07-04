import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, PlusCircle, RefreshCw, FileText, ArrowUpRight, ArrowDownLeft, Calendar, Tag } from "lucide-react";
import API from "../api/axios";
import "./MiscPayments.css";

const emptyForm = {
  memberId: "",
  amount: "",
  type: "EXPENSE", // INCOME or EXPENSE
  category: "OFFICE_EXPENSE", // ADMISSION_FEE, PENALTY, WELFARE_FUND, OFFICE_EXPENSE, STATIONERY, OTHER
  paymentMode: "CASH", // CASH, BANK
  description: ""
};

export default function MiscPayments() {
  const navigate = useNavigate();
  const [payments, setPayments] = useState([]);
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [formSuccess, setFormSuccess] = useState("");
  const [formError, setFormError] = useState("");

  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState(emptyForm);

  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isClerk = roles.includes("ROLE_CLERK");

  const fetchInitialData = async () => {
    setLoading(true);
    setError("");
    try {
      const [paymentsRes, membersRes] = await Promise.all([
        API.get("/misc-payments"),
        API.get("/members")
      ]);
      setPayments(paymentsRes.data || []);
      setMembers(membersRes.data || []);
    } catch (err) {
      console.error(err);
      setError("Failed to load miscellaneous vouchers ledger.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInitialData();
  }, []);

  const handlePostPayment = async (e) => {
    e.preventDefault();
    setFormError("");
    setFormSuccess("");
    try {
      const payload = {
        ...form,
        amount: parseFloat(form.amount),
        member: form.memberId ? { id: parseInt(form.memberId) } : null
      };
      await API.post("/misc-payments", payload);
      setFormSuccess("Miscellaneous voucher entry posted successfully!");
      setForm(emptyForm);
      setShowForm(false);
      fetchInitialData();
    } catch (err) {
      setFormError(err.response?.data?.message || "Failed to post miscellaneous voucher.");
    }
  };

  const totalExpense = payments.filter(p => p.type === "EXPENSE").reduce((sum, p) => sum + p.amount, 0);
  const totalIncome = payments.filter(p => p.type === "INCOME").reduce((sum, p) => sum + p.amount, 0);

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header">
        <div className="page-title-group">
          <h1 className="gradient-heading">Miscellaneous Vouchers (Income & Expenses)</h1>
          <p>Register one-off office expenses, Admission fees, Welfare fund payouts, or Penalties.</p>
        </div>
        {(isAdmin || isAccountant || isClerk) && (
          <button className="btn-enterprise btn-primary" onClick={() => setShowForm(!showForm)}>
            <PlusCircle size={18} />
            Post Misc Voucher
          </button>
        )}
      </header>

      {error && <div className="alert alert-danger" style={{ marginBottom: 15 }}>{error}</div>}
      {formSuccess && <div className="alert alert-success" style={{ marginBottom: 15 }}>{formSuccess}</div>}
      {formError && <div className="alert alert-danger" style={{ marginBottom: 15 }}>{formError}</div>}

      {/* Post Payment Form Modal */}
      {showForm && (
        <section className="glass-card" style={{ padding: '2rem', marginBottom: '2rem' }}>
          <form onSubmit={handlePostPayment}>
            <h3 style={{ fontSize: '1.3rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Post Miscellaneous Income or Expense Voucher</h3>
            
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Voucher Type</span>
                <select
                  className="enterprise-select"
                  value={form.type}
                  onChange={(e) => setForm({ ...form, type: e.target.value })}
                  required
                >
                  <option value="EXPENSE">Expense (Outward Payment)</option>
                  <option value="INCOME">Income (Inward Receipt)</option>
                </select>
              </label>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Voucher Category</span>
                <select
                  className="enterprise-select"
                  value={form.category}
                  onChange={(e) => setForm({ ...form, category: e.target.value })}
                  required
                >
                  <option value="ADMISSION_FEE">Admission Fee (Income)</option>
                  <option value="PENALTY">Late Penalty / Fine (Income)</option>
                  <option value="WELFARE_FUND">Welfare Fund (Expense/Receipt)</option>
                  <option value="OFFICE_EXPENSE">Office Maintenance (Expense)</option>
                  <option value="STATIONERY">Stationery & Print (Expense)</option>
                  <option value="OTHER">Other Custom</option>
                </select>
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Amount (₹)</span>
                <input
                  className="enterprise-input"
                  type="number"
                  step="0.01"
                  placeholder="0.00"
                  value={form.amount}
                  onChange={(e) => setForm({ ...form, amount: e.target.value })}
                  required
                />
              </label>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Payment Mode</span>
                <select
                  className="enterprise-select"
                  value={form.paymentMode}
                  onChange={(e) => setForm({ ...form, paymentMode: e.target.value })}
                  required
                >
                  <option value="CASH">Cash Drawer</option>
                  <option value="BANK">Bank Transfer</option>
                </select>
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Link Member (Optional)</span>
                <select
                  className="enterprise-select"
                  value={form.memberId}
                  onChange={(e) => setForm({ ...form, memberId: e.target.value })}
                >
                  <option value="">-- No Linked Member --</option>
                  {members.map(m => (
                    <option key={m.id} value={m.id}>{m.name} ({m.membershipNo})</option>
                  ))}
                </select>
              </label>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Description / Purpose Details</span>
                <input
                  className="enterprise-input"
                  type="text"
                  placeholder="e.g. Purchased admission notebooks"
                  value={form.description}
                  onChange={(e) => setForm({ ...form, description: e.target.value })}
                  required
                />
              </label>
            </div>

            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem', borderTop: '1px solid #f1f5f9', paddingTop: '1.5rem' }}>
              <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowForm(false)}>Cancel</button>
              <button type="submit" className="btn-enterprise btn-primary">Post Voucher</button>
            </div>
          </form>
        </section>
      )}

      {/* Summary Cards */}
      <section className="dashboard-stats" style={{ marginBottom: 30, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.5rem' }}>
        <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
          <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#dcfce7', color: '#15803d' }}>
            <ArrowUpRight size={28} />
          </div>
          <div>
            <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Misc Income Receipts</h4>
            <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{totalIncome.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
          </div>
        </div>
        <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
          <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#fee2e2', color: '#b91c1c' }}>
            <ArrowDownLeft size={28} />
          </div>
          <div>
            <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Misc Expenditures</h4>
            <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{totalExpense.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
          </div>
        </div>
      </section>

      {/* Table grid of payments */}
      <section>
        <h2 style={{ fontSize: '1.35rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Miscellaneous Vouchers Registry</h2>
        {loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" />
            <p style={{ marginTop: '1rem' }}>Compiling general vouchers ledger...</p>
          </div>
        ) : payments.length === 0 ? (
          <div className="empty-state">
            <Tag size={36} />
            <p style={{ marginTop: '1rem' }}>No miscellaneous vouchers posted.</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Voucher No</th>
                  <th>Date</th>
                  <th>Type</th>
                  <th>Category</th>
                  <th>Linked Member</th>
                  <th>Amount</th>
                  <th>Mode</th>
                  <th>Description</th>
                </tr>
              </thead>
              <tbody>
                {payments.map(p => (
                  <tr key={p.id}>
                    <td><strong>{p.voucherNo}</strong></td>
                    <td>{new Date(p.paymentDate).toLocaleString("en-IN")}</td>
                    <td>
                      <span style={{ color: p.type === "INCOME" ? '#059669' : '#dc2626', fontWeight: 700 }}>
                        {p.type}
                      </span>
                    </td>
                    <td>{p.category.replace("_", " ")}</td>
                    <td>{p.member ? `${p.member.name} (${p.member.membershipNo})` : "General Office"}</td>
                    <td style={{ fontWeight: 700 }}>₹{p.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>{p.paymentMode}</td>
                    <td>{p.description}</td>
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
