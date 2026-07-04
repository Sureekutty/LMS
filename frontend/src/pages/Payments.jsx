import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Landmark, PlusCircle, RefreshCw, XCircle, ArrowLeft } from "lucide-react";
import API from "../api/axios";
import "./Payments.css";

const emptyForm = {
  type: "DEBIT", // DEBIT increases cash (Receipt), CREDIT decreases cash (Payment)
  memberId: "",
  transactionTypeId: "",
  amount: "",
  referenceNo: "",
  description: "",
};

export default function Payments() {
  const navigate = useNavigate();
  const [transactions, setTransactions] = useState([]);
  const [members, setMembers] = useState([]);
  const [transactionTypes, setTransactionTypes] = useState([]);
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

  const fetchInitialData = async () => {
    setLoading(true);
    try {
      if (isAdmin || isClerk || isAccountant) {
        const [txnRes, memRes, typeRes] = await Promise.all([
          API.get("/transactions"),
          API.get("/members"),
          API.get("/transactions/types")
        ]);
        setTransactions(txnRes.data || []);
        setMembers(memRes.data || []);
        setTransactionTypes(typeRes.data || []);
      } else {
        // Fetch personal transactions for Member
        const meRes = await API.get("/members/me");
        const member = meRes.data;
        if (member && member.id) {
          const txnRes = await API.get(`/transactions/member/${member.id}`);
          setTransactions(txnRes.data || []);
        }
      }
    } catch (err) {
      console.error("Error loading payments data:", err);
      setError("Failed to load transactions.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInitialData();
  }, []);

  const handlePostVoucher = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    setFormSuccess("");
    setError("");

    try {
      const payload = {
        type: form.type,
        amount: parseFloat(form.amount),
        referenceNo: form.referenceNo,
        description: form.description,
        transactionType: { id: form.transactionTypeId },
      };

      if (form.memberId) {
        payload.member = { id: form.memberId };
      }

      await API.post("/transactions", payload);
      setFormSuccess("Voucher transaction posted successfully!");
      setForm(emptyForm);
      setShowForm(false);
      fetchInitialData();
    } catch (err) {
      setError(err.response?.data?.message || "Failed to post transaction voucher.");
    } finally {
      setFormLoading(false);
    }
  };

  const handleReverseVoucher = async (id) => {
    if (!window.confirm("Are you sure you want to write a counter-reversal entry for this voucher?")) {
      return;
    }
    try {
      await API.put(`/transactions/${id}/reverse`);
      fetchInitialData();
    } catch (err) {
      alert("Failed to reverse voucher entry.");
    }
  };

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header">
        <div className="page-title-group">
          <h1 className="gradient-heading">Payments & Receipts Ledger</h1>
          <p>Post financial vouchers, receipt cash deposits, and balance books</p>
        </div>
        {(isAdmin || isClerk || isAccountant) && (
          <button className="btn-enterprise btn-primary" onClick={() => setShowForm(!showForm)}>
            <PlusCircle size={18} />
            Post Voucher Entry
          </button>
        )}
      </header>

      {/* Post Voucher Entry Form */}
      {showForm && (
        <section className="glass-card" style={{ padding: '2rem', marginBottom: '2rem' }}>
          <form onSubmit={handlePostVoucher}>
            <h3 style={{ fontSize: '1.3rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Post Voucher Entry (Double-Entry Debit/Credit)</h3>
            
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Voucher Category</span>
                <select className="enterprise-select" value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })} required>
                  <option value="DEBIT">Debit (Receipt - Increases Cash)</option>
                  <option value="CREDIT">Credit (Payment - Decreases Cash)</option>
                </select>
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Transaction Type</span>
                <select className="enterprise-select" value={form.transactionTypeId} onChange={(e) => setForm({ ...form, transactionTypeId: e.target.value })} required>
                  <option value="">-- Choose Type --</option>
                  {transactionTypes.map(t => (
                    <option key={t.id} value={t.id}>{t.typeName} ({t.typeCode})</option>
                  ))}
                  {transactionTypes.length === 0 && (
                    <>
                      <option value="1">Share Capital Deposit</option>
                      <option value="2">Loan Disbursal / Repayment</option>
                    </>
                  )}
                </select>
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Linked Member (Optional)</span>
                <select className="enterprise-select" value={form.memberId} onChange={(e) => setForm({ ...form, memberId: e.target.value })}>
                  <option value="">-- No Member Linked --</option>
                  {members.map(m => (
                    <option key={m.id} value={m.id}>{m.name} ({m.membershipNo})</option>
                  ))}
                </select>
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Voucher Amount (₹)</span>
                <input className="enterprise-input" type="number" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} required />
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Reference / Instrument No</span>
                <input className="enterprise-input" type="text" placeholder="Chq No, Cash Slp..." value={form.referenceNo} onChange={(e) => setForm({ ...form, referenceNo: e.target.value })} />
              </label>

              <label className="enterprise-form-group">
                <span className="enterprise-label">Narrative / Description</span>
                <input className="enterprise-input" type="text" placeholder="Narration..." value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} required />
              </label>
            </div>

            {formSuccess && <div className="alert alert-success mt-4">{formSuccess}</div>}
            {error && <div className="alert alert-danger mt-4">{error}</div>}

            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem', borderTop: '1px solid #f1f5f9', paddingTop: '1.5rem' }}>
              <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowForm(false)}>Cancel</button>
              <button type="submit" disabled={formLoading} className="btn-enterprise btn-primary">
                {formLoading ? "Posting..." : "Post Voucher"}
              </button>
            </div>
          </form>
        </section>
      )}

      {/* Ledger list */}
      <section>
        <h2 style={{ fontSize: '1.35rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>System Transaction Vouchers</h2>
        {loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" />
            <p style={{ marginTop: '1rem' }}>Fetching transaction records...</p>
          </div>
        ) : transactions.length === 0 ? (
          <div className="empty-state">
            <Landmark size={36} />
            <p style={{ marginTop: '1rem' }}>No transactions registered in this ledger period.</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Voucher No</th>
                  <th>Date</th>
                  <th>Member</th>
                  <th>Txn Type</th>
                  <th>Debit (Dr)</th>
                  <th>Credit (Cr)</th>
                  <th>Reference</th>
                  <th>Status</th>
                  {(isAdmin || isAccountant) && <th>Actions</th>}
                </tr>
              </thead>
              <tbody>
                {transactions.map(t => (
                  <tr key={t.id}>
                    <td><strong>{t.transactionNo}</strong></td>
                    <td>{new Date(t.transactionDate).toLocaleDateString("en-IN")}</td>
                    <td>{t.member?.name || "Suspense Ledger"}</td>
                    <td>{t.transactionType?.typeName || "Voucher Entry"}</td>
                    <td>
                      {t.type === "DEBIT" ? (
                        <span style={{ color: '#059669', fontWeight: '700' }}>₹{t.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</span>
                      ) : "-"}
                    </td>
                    <td>
                      {t.type === "CREDIT" ? (
                        <span style={{ color: '#dc2626', fontWeight: '700' }}>₹{t.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</span>
                      ) : "-"}
                    </td>
                    <td>{t.referenceNo || "N/A"}</td>
                    <td>
                      <span className={`badge badge-${t.status === 'ACTIVE' ? 'success' : t.status === 'REVERSED' ? 'warning' : 'secondary'}`}>
                        {t.status}
                      </span>
                    </td>
                    {(isAdmin || isAccountant) && (
                      <td>
                        {t.status === "ACTIVE" && (
                          <button className="btn-enterprise btn-danger" onClick={() => handleReverseVoucher(t.id)} title="Reverse Voucher Entry" style={{ padding: '0.4rem 0.6rem' }}>
                            <XCircle size={14} /> Reverse
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
