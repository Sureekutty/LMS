import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Landmark, PlusCircle, RefreshCw, ArrowLeft, ArrowUpRight, ArrowDownLeft, Calendar, FileText } from "lucide-react";
import API from "../api/axios";
import "./BankLedger.css";

const emptyAccountForm = {
  accountName: "",
  accountNumber: "",
  bankName: "",
  branchName: "",
  balance: ""
};

const emptyTxnForm = {
  accountId: "",
  amount: "",
  type: "DEBIT", // DEBIT = Deposit, CREDIT = Withdrawal
  referenceNo: "",
  description: ""
};

export default function BankLedger() {
  const navigate = useNavigate();
  const [accounts, setAccounts] = useState([]);
  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [formSuccess, setFormSuccess] = useState("");
  const [formError, setFormError] = useState("");

  const [showAccountForm, setShowAccountForm] = useState(false);
  const [showTxnForm, setShowTxnForm] = useState(false);
  
  const [accountForm, setAccountForm] = useState(emptyAccountForm);
  const [txnForm, setTxnForm] = useState(emptyTxnForm);
  const [selectedAccountId, setSelectedAccountId] = useState("ALL");

  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isClerk = roles.includes("ROLE_CLERK");

  const fetchInitialData = async () => {
    setLoading(true);
    setError("");
    try {
      const [accountsRes, txnsRes] = await Promise.all([
        API.get("/banks/accounts"),
        API.get("/banks/transactions")
      ]);
      setAccounts(accountsRes.data || []);
      setTransactions(txnsRes.data || []);
    } catch (err) {
      console.error(err);
      setError("Failed to load banking ledger accounts and logs.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInitialData();
  }, []);

  const handleCreateAccount = async (e) => {
    e.preventDefault();
    setFormError("");
    setFormSuccess("");
    try {
      const payload = {
        ...accountForm,
        balance: accountForm.balance ? parseFloat(accountForm.balance) : 0
      };
      await API.post("/banks/accounts", payload);
      setFormSuccess("Bank account opened successfully!");
      setAccountForm(emptyAccountForm);
      setShowAccountForm(false);
      fetchInitialData();
    } catch (err) {
      setFormError(err.response?.data?.message || "Failed to create bank account.");
    }
  };

  const handlePostTransaction = async (e) => {
    e.preventDefault();
    setFormError("");
    setFormSuccess("");
    try {
      const payload = {
        ...txnForm,
        amount: parseFloat(txnForm.amount)
      };
      await API.post("/banks/transactions", payload);
      setFormSuccess("Bank transaction posted successfully!");
      setTxnForm(emptyTxnForm);
      setShowTxnForm(false);
      fetchInitialData();
    } catch (err) {
      setFormError(err.response?.data?.message || "Failed to post transaction.");
    }
  };

  const filteredTransactions = transactions.filter(t => {
    if (selectedAccountId === "ALL") return true;
    return t.bankAccount?.id === parseInt(selectedAccountId);
  });

  const totalBankBalance = accounts.reduce((sum, acc) => sum + (acc.balance || 0), 0);

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header" style={{ marginBottom: '2rem' }}>
        <div className="page-title-group">
          <h1 className="gradient-heading">Society Bank Accounts & Balances</h1>
          <p>Track cash reserves, reconcile bank accounts, and log ledger transactions.</p>
        </div>
      </header>

      {error && <div className="alert alert-danger" style={{ marginBottom: 15 }}>{error}</div>}
      {formSuccess && <div className="alert alert-success" style={{ marginBottom: 15 }}>{formSuccess}</div>}
      {formError && <div className="alert alert-danger" style={{ marginBottom: 15 }}>{formError}</div>}

      {/* Account Creation Modal */}
      {showAccountForm && (
        <div className="modal-overlay" onClick={() => setShowAccountForm(false)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()}>
            <form onSubmit={handleCreateAccount}>
              <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Open Society Bank Account</h3>
              
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Account Name</span>
                  <input className="enterprise-input" type="text" placeholder="e.g. Operating Savings" value={accountForm.accountName} onChange={(e) => setAccountForm({ ...accountForm, accountName: e.target.value })} required />
                </label>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Account Number</span>
                  <input className="enterprise-input" type="text" placeholder="Account Number" value={accountForm.accountNumber} onChange={(e) => setAccountForm({ ...accountForm, accountNumber: e.target.value })} required />
                </label>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Bank Name</span>
                  <input className="enterprise-input" type="text" placeholder="Bank Name" value={accountForm.bankName} onChange={(e) => setAccountForm({ ...accountForm, bankName: e.target.value })} required />
                </label>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Branch Name</span>
                  <input className="enterprise-input" type="text" placeholder="Branch Name" value={accountForm.branchName} onChange={(e) => setAccountForm({ ...accountForm, branchName: e.target.value })} required />
                </label>
                <label className="enterprise-form-group full-width" style={{ gridColumn: 'span 2', minWidth: 0 }}>
                  <span className="enterprise-label">Initial Balance (₹)</span>
                  <input className="enterprise-input" type="number" placeholder="0.00" value={accountForm.balance} onChange={(e) => setAccountForm({ ...accountForm, balance: e.target.value })} />
                </label>
              </div>
              
              <div className="form-actions" style={{ marginTop: '2rem' }}>
                <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowAccountForm(false)}>Cancel</button>
                <button type="submit" className="btn-enterprise btn-primary">Create Account</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Transaction Modal */}
      {showTxnForm && (
        <div className="modal-overlay" onClick={() => setShowTxnForm(false)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()}>
            <form onSubmit={handlePostTransaction}>
              <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Post Bank Transaction</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Select Account</span>
                  <select className="enterprise-select" value={txnForm.accountId} onChange={(e) => setTxnForm({ ...txnForm, accountId: e.target.value })} required>
                    <option value="">-- Select Bank Account --</option>
                    {accounts.map(acc => (
                      <option key={acc.id} value={acc.id}>{acc.bankName} - {acc.accountName} ({acc.accountNumber})</option>
                    ))}
                  </select>
                </label>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Transaction Type</span>
                  <select className="enterprise-select" value={txnForm.type} onChange={(e) => setTxnForm({ ...txnForm, type: e.target.value })} required>
                    <option value="DEBIT">Deposit / Inward Receipt</option>
                    <option value="CREDIT">Withdrawal / Outward Payment</option>
                  </select>
                </label>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Amount (₹)</span>
                  <input className="enterprise-input" type="number" step="0.01" placeholder="0.00" value={txnForm.amount} onChange={(e) => setTxnForm({ ...txnForm, amount: e.target.value })} required />
                </label>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">UTR / Reference No</span>
                  <input className="enterprise-input" type="text" placeholder="Transaction Ref / Cheque No" value={txnForm.referenceNo} onChange={(e) => setTxnForm({ ...txnForm, referenceNo: e.target.value })} />
                </label>
                <label className="enterprise-form-group full-width" style={{ gridColumn: 'span 2', minWidth: 0 }}>
                  <span className="enterprise-label">Remarks / Description</span>
                  <input className="enterprise-input" type="text" placeholder="Reason for payment/deposit" value={txnForm.description} onChange={(e) => setTxnForm({ ...txnForm, description: e.target.value })} />
                </label>
              </div>
              <div className="form-actions" style={{ marginTop: '2rem' }}>
                <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowTxnForm(false)}>Cancel</button>
                <button type="submit" className="btn-enterprise btn-primary">Post Transaction</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Summary Cards */}
      <section className="dashboard-stats" style={{ marginBottom: 30, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.5rem' }}>
        <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
          <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#e0f2fe', color: '#0369a1' }}>
            <Landmark size={28} />
          </div>
          <div>
            <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Bank Balance</h4>
            <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{totalBankBalance.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
          </div>
        </div>
        <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
          <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#dcfce7', color: '#15803d' }}>
            <FileText size={28} />
          </div>
          <div>
            <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Active Bank Accounts</h4>
            <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>{accounts.length}</h2>
          </div>
        </div>
      </section>

      {/* Accounts List & Balance Sheet */}
      <section style={{ marginBottom: 40 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.35rem', fontWeight: 800, color: 'var(--text-primary)' }}>Bank Accounts Registry</h2>
          <div className="table-header-group">
            {(isAdmin || isAccountant || isClerk) && (
              <>
                <button className="btn-enterprise btn-primary" onClick={() => { setShowAccountForm(true); setShowTxnForm(false); }}>
                  <PlusCircle size={16} /> Open Bank Account
                </button>
                <button className="btn-enterprise btn-success" onClick={() => { setShowTxnForm(true); setShowAccountForm(false); }}>
                  <PlusCircle size={16} /> Post Txn
                </button>
              </>
            )}
          </div>
        </div>
        {accounts.length === 0 ? (
          <div className="empty-state">No bank accounts registered yet.</div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Account Name</th>
                  <th>Account Number</th>
                  <th>Branch Name</th>
                  <th>Current Balance</th>
                </tr>
              </thead>
              <tbody>
                {accounts.map(acc => (
                  <tr key={acc.id} className="interactive-row">
                    <td>
                      <div style={{ fontWeight: 700, color: 'var(--text-primary)' }}>{acc.accountName}</div>
                      <div style={{ fontSize: '0.8rem', color: '#64748b' }}>{acc.bankName}</div>
                    </td>
                    <td style={{ fontWeight: 800, color: 'var(--primary)' }}>{acc.accountNumber}</td>
                    <td style={{ color: '#64748b', fontWeight: 600 }}>{acc.branchName}</td>
                    <td style={{ fontWeight: 700 }}>
                      ₹{acc.balance.toLocaleString("en-IN", { minimumFractionDigits: 2 })}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>

      {/* Transaction Logs */}
      <section>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
          <h2 style={{ fontSize: '1.35rem', fontWeight: 800, color: 'var(--text-primary)' }}>Bank Transaction Logs</h2>
          <div>
            <select
              className="enterprise-select"
              value={selectedAccountId}
              onChange={(e) => setSelectedAccountId(e.target.value)}
              style={{ width: 'auto', minWidth: '200px' }}
            >
              <option value="ALL">All Accounts</option>
              {accounts.map(acc => (
                <option key={acc.id} value={acc.id}>{acc.bankName} - {acc.accountName}</option>
              ))}
            </select>
          </div>
        </div>

        {filteredTransactions.length === 0 ? (
          <div className="empty-state">No bank transactions recorded.</div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Txn No</th>
                  <th>Date</th>
                  <th>Account</th>
                  <th>Type</th>
                  <th>Amount</th>
                  <th>UTR/Ref</th>
                  <th>Description</th>
                </tr>
              </thead>
              <tbody>
                {filteredTransactions.map(t => (
                  <tr key={t.id} className="interactive-row">
                    <td style={{ fontWeight: 800, color: 'var(--primary)' }}>{t.transactionNo}</td>
                    <td style={{ color: '#64748b', fontWeight: 600 }}>{new Date(t.transactionDate).toLocaleString("en-IN")}</td>
                    <td>
                      <div style={{ fontWeight: 700, color: 'var(--text-primary)' }}>{t.bankAccount?.accountName}</div>
                      <div style={{ fontSize: '0.8rem', color: '#64748b' }}>{t.bankAccount?.bankName}</div>
                    </td>
                    <td>
                      <span className={`badge badge-${t.type === "DEBIT" ? "success" : "danger"}`}>
                        {t.type === "DEBIT" ? "DEBIT" : "CREDIT"}
                      </span>
                    </td>
                    <td style={{ fontWeight: 700 }}>₹{t.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td style={{ color: '#64748b', fontWeight: 600 }}>{t.referenceNo || "N/A"}</td>
                    <td style={{ color: '#64748b', fontWeight: 600 }}>{t.description}</td>
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
