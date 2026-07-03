import { useEffect, useState } from "react";
import { Landmark, PlusCircle, RefreshCw, XCircle, ArrowDownCircle, ArrowUpCircle } from "lucide-react";
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
    <main className="payments-page">
      <header className="page-header">
        <div>
          <h1>Payments & Receipts Ledger</h1>
          <p>Post financial vouchers, receipt cash deposits, and balance books</p>
        </div>
        {(isAdmin || isClerk || isAccountant) && (
          <button className="open-form-btn" onClick={() => setShowForm(!showForm)}>
            <PlusCircle size={18} />
            Post Voucher Entry
          </button>
        )}
      </header>

      {/* Post Voucher Entry Form */}
      {showForm && (
        <section className="deposit-form-wrapper">
          <form onSubmit={handlePostVoucher} className="deposit-form">
            <h3>Post Voucher Entry (Double-Entry Debit/Credit)</h3>
            
            <div className="form-row">
              <label>
                <span>Voucher Category</span>
                <select value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })} required>
                  <option value="DEBIT">Debit (Receipt - Increases Cash)</option>
                  <option value="CREDIT">Credit (Payment - Decreases Cash)</option>
                </select>
              </label>

              <label>
                <span>Transaction Type</span>
                <select value={form.transactionTypeId} onChange={(e) => setForm({ ...form, transactionTypeId: e.target.value })} required>
                  <option value="">-- Choose Type --</option>
                  {transactionTypes.map(t => (
                    <option key={t.id} value={t.id}>{t.typeName} ({t.typeCode})</option>
                  ))}
                  {/* Fallbacks if Types list is empty */}
                  {transactionTypes.length === 0 && (
                    <>
                      <option value="1">Share Capital Deposit</option>
                      <option value="2">Loan Disbursal / Repayment</option>
                    </>
                  )}
                </select>
              </label>
            </div>

            <div className="form-row">
              <label>
                <span>Linked Member (Optional)</span>
                <select value={form.memberId} onChange={(e) => setForm({ ...form, memberId: e.target.value })}>
                  <option value="">-- No Member Linked --</option>
                  {members.map(m => (
                    <option key={m.id} value={m.id}>{m.name} ({m.membershipNo})</option>
                  ))}
                </select>
              </label>

              <label>
                <span>Voucher Amount (₹)</span>
                <input type="number" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} required />
              </label>
            </div>

            <div className="form-row">
              <label>
                <span>Reference / Instrument No</span>
                <input type="text" placeholder="Chq No, Cash Slp..." value={form.referenceNo} onChange={(e) => setForm({ ...form, referenceNo: e.target.value })} />
              </label>

              <label>
                <span>Narrative / Description</span>
                <input type="text" placeholder="Narration..." value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} required />
              </label>
            </div>

            {formSuccess && <div className="form-success-msg">{formSuccess}</div>}
            {error && <div className="form-error-msg">{error}</div>}

            <div className="form-actions">
              <button type="submit" disabled={formLoading} className="submit-btn">
                {formLoading ? "Posting..." : "Post Voucher"}
              </button>
              <button type="button" className="cancel-btn" onClick={() => setShowForm(false)}>Cancel</button>
            </div>
          </form>
        </section>
      )}

      {/* Ledger list */}
      <section className="deposits-list">
        <h2>System Transaction Vouchers</h2>
        {loading ? (
          <div className="loading-state">
            <RefreshCw size={28} className="spin-icon" />
            <p>Fetching transaction records...</p>
          </div>
        ) : transactions.length === 0 ? (
          <div className="empty-state">
            <Landmark size={36} />
            <p>No transactions registered in this ledger period.</p>
          </div>
        ) : (
          <div className="table-wrap">
            <table className="deposits-table">
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
                    <td>{t.transactionNo}</td>
                    <td>{new Date(t.transactionDate).toLocaleDateString("en-IN")}</td>
                    <td>{t.member?.name || "Suspense Ledger"}</td>
                    <td>{t.transactionType?.typeName || "Voucher Entry"}</td>
                    <td>
                      {t.type === "DEBIT" ? (
                        <span className="dr-val">₹{t.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</span>
                      ) : "-"}
                    </td>
                    <td>
                      {t.type === "CREDIT" ? (
                        <span className="cr-val">₹{t.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</span>
                      ) : "-"}
                    </td>
                    <td>{t.referenceNo || "N/A"}</td>
                    <td>
                      <span className={`status-badge ${t.status?.toLowerCase()}`}>
                        {t.status}
                      </span>
                    </td>
                    {(isAdmin || isAccountant) && (
                      <td>
                        {t.status === "ACTIVE" && (
                          <button className="close-btn" onClick={() => handleReverseVoucher(t.id)} title="Reverse Voucher Entry">
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
