import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { 
  Landmark, Users, CreditCard, LogOut, Home, Settings, Bell, RefreshCw, 
  ShieldAlert, FileText, TrendingUp, Search, Sun, MoreVertical, ArrowUpRight, 
  UserPlus, PlusCircle, ArrowRight, MessageSquare, ChevronRight, ChevronLeft, Zap, PieChart
} from "lucide-react";
import API from "../api/axios";
import "./Dashboard.css";

export default function Dashboard() {
  const navigate = useNavigate();
  const username = localStorage.getItem("username") || "Admin";
  
  // Role Parsing
  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isClerk = roles.includes("ROLE_CLERK");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isMember = roles.includes("ROLE_MEMBER") || (!isAdmin && !isClerk && !isAccountant);

  const [currentTab, setCurrentTab] = useState("overview");

  // Add Staff State
  const [newStaff, setNewStaff] = useState({
    firstName: "", lastName: "", email: "", password: "", confirmPassword: "", role: "CLERK", adminPassword: ""
  });
  const [formError, setFormError] = useState("");
  const [formSuccess, setFormSuccess] = useState("");
  const [formLoading, setFormLoading] = useState(false);

  // Interest Accrual State
  const [accrualLoading, setAccrualLoading] = useState(false);
  const [accrualMsg, setAccrualMsg] = useState("");

  const handleRunAccrual = async () => {
    setAccrualLoading(true);
    setAccrualMsg("");
    try {
      const res = await API.post("/interest-accruals/run");
      setAccrualMsg(res.data.message || "Monthly interest accrual processed successfully!");
    } catch (err) {
      setAccrualMsg(err.response?.data?.message || "Failed to process interest accrual.");
    } finally {
      setAccrualLoading(false);
    }
  };

  const [stats, setStats] = useState({
    totalMembers: 0, totalShareCapital: 0, totalDeposits: 0, activeLoans: 0, thriftDeposit: 0, outstandingLoansAmount: 0, totalTransactions: 0
  });
  const [recentTransactions, setRecentTransactions] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      if (isAdmin) {
        const [membersRes, loansRes, txnsRes, depositsRes] = await Promise.all([
          API.get("/members"), API.get("/loans"), API.get("/transactions"), API.get("/deposits")
        ]);

        const members = membersRes.data || [];
        const loans = loansRes.data || [];
        const txns = txnsRes.data || [];
        const deposits = depositsRes.data || [];

        const totalShareCapital = members.reduce((sum, m) => sum + (m.shareCapital || 0), 0);
        const totalDeposits = deposits.reduce((sum, d) => sum + (d.principalAmount || 0), 0);
        const activeLoansCount = loans.filter(l => l.status && (l.status.toUpperCase() === "ACTIVE" || l.status.toUpperCase() === "APPROVED")).length;

        setStats({
          totalMembers: members.length, totalShareCapital, totalDeposits, activeLoans: activeLoansCount, thriftDeposit: 0, outstandingLoansAmount: 0, totalTransactions: txns.length
        });

        const sortedTxns = txns.sort((a, b) => new Date(b.transactionDate) - new Date(a.transactionDate));
        setRecentTransactions(sortedTxns.slice(0, 5));
      } else {
        const meRes = await API.get("/members/me");
        const member = meRes.data;

        if (member && member.id) {
          const [loansRes, txnsRes, depositsRes] = await Promise.all([
            API.get("/loans/member/" + member.id), API.get("/transactions/member/" + member.id), API.get("/deposits/member/" + member.id)
          ]);

          const loans = loansRes.data || [];
          const txns = txnsRes.data || [];
          const deposits = depositsRes.data || [];

          const outstandingLoansAmount = loans
            .filter(l => l.status && (l.status.toUpperCase() === "ACTIVE" || l.status.toUpperCase() === "APPROVED"))
            .reduce((sum, l) => sum + (l.outstandingPrincipal || 0) + (l.outstandingInterest || 0), 0);

          const totalDeposits = deposits.reduce((sum, d) => sum + (d.principalAmount || 0), 0);

          setStats({
            totalMembers: 0, totalShareCapital: member.shareCapital || 0, thriftDeposit: member.thriftDeposit || 0, totalDeposits,
            activeLoans: loans.filter(l => l.status && (l.status.toUpperCase() === "ACTIVE" || l.status.toUpperCase() === "APPROVED")).length, outstandingLoansAmount, totalTransactions: txns.length
          });

          const sortedTxns = txns.sort((a, b) => new Date(b.transactionDate) - new Date(a.transactionDate));
          setRecentTransactions(sortedTxns.slice(0, 5));
        }
      }
    } catch (err) {
      console.error("Error loading dashboard metrics:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("username");
    localStorage.removeItem("roles");
    localStorage.removeItem("membershipNo");
    navigate("/login");
  };

  const handleAddStaff = async (e) => {
    e.preventDefault();
    setFormError("");
    setFormSuccess("");
    if (newStaff.password !== newStaff.confirmPassword) {
      setFormError("Passwords do not match!");
      return;
    }
    setFormLoading(true);
    try {
      const payload = {
        username: newStaff.email, email: newStaff.email, firstName: newStaff.firstName, lastName: newStaff.lastName,
        displayName: newStaff.firstName + " " + newStaff.lastName, password: newStaff.password, roles: [newStaff.role], adminPassword: newStaff.adminPassword
      };
      await API.post("/auth/register", payload);
      setFormSuccess("Staff/Admin user registered successfully!");
      setNewStaff({ firstName: "", lastName: "", email: "", password: "", confirmPassword: "", role: "CLERK", adminPassword: "" });
    } catch (err) {
      setFormError(err.response?.data?.message || "Failed to create staff account.");
    } finally {
      setFormLoading(false);
    }
  };

  return (
    <div className="animate__animated animate__fadeIn" style={{ position: "relative", zIndex: 2 }}>

        {loading ? (
          <div className="empty-state" style={{ position: "relative", zIndex: 2 }}>
            <RefreshCw size={36} className="spin-icon" />
            <h3 style={{ marginTop: 15 }}>Syncing Ledger Data...</h3>
          </div>
        ) : currentTab === "settings" ? (
          <div className="dashboard-card" style={{ padding: '2.5rem', position: "relative", zIndex: 2 }}>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 800, marginBottom: '2rem', color: 'var(--text-primary)' }}>Account Settings & System Controls</h2>
            
            {isAdmin && (
              <div style={{ marginBottom: '3rem' }}>
                <h3 style={{ fontSize: '1.2rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '0.5rem' }}>System Controls: Add Staff/Admin Account</h3>
                <p style={{ color: 'var(--text-secondary)', marginBottom: '1.5rem' }}>Register new Admins, Accountants, or Clerks by confirming the master password.</p>

                <form onSubmit={handleAddStaff}>
                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.5rem', marginBottom: '1.5rem' }}>
                    <label className="enterprise-form-group">
                      <span className="enterprise-label">First Name</span>
                      <input className="enterprise-input" type="text" placeholder="First Name" value={newStaff.firstName} onChange={(e) => setNewStaff({ ...newStaff, firstName: e.target.value })} required />
                    </label>
                    <label className="enterprise-form-group">
                      <span className="enterprise-label">Last Name</span>
                      <input className="enterprise-input" type="text" placeholder="Last Name" value={newStaff.lastName} onChange={(e) => setNewStaff({ ...newStaff, lastName: e.target.value })} required />
                    </label>
                  </div>

                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.5rem', marginBottom: '1.5rem' }}>
                    <label className="enterprise-form-group">
                      <span className="enterprise-label">Email / Username</span>
                      <input className="enterprise-input" type="email" placeholder="Email ID" value={newStaff.email} onChange={(e) => setNewStaff({ ...newStaff, email: e.target.value })} required />
                    </label>
                    <label className="enterprise-form-group">
                      <span className="enterprise-label">Target System Role</span>
                      <select className="enterprise-select" value={newStaff.role} onChange={(e) => setNewStaff({ ...newStaff, role: e.target.value })} required>
                        <option value="CLERK">Clerk</option>
                        <option value="ACCOUNTANT">Accountant</option>
                        <option value="ADMIN">Administrator</option>
                      </select>
                    </label>
                  </div>

                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.5rem', marginBottom: '2rem' }}>
                    <label className="enterprise-form-group">
                      <span className="enterprise-label">Password</span>
                      <input className="enterprise-input" type="password" placeholder="Password" value={newStaff.password} onChange={(e) => setNewStaff({ ...newStaff, password: e.target.value })} required />
                    </label>
                    <label className="enterprise-form-group">
                      <span className="enterprise-label">Confirm Password</span>
                      <input className="enterprise-input" type="password" placeholder="Confirm Password" value={newStaff.confirmPassword} onChange={(e) => setNewStaff({ ...newStaff, confirmPassword: e.target.value })} required />
                    </label>
                  </div>

                  <label className="enterprise-form-group" style={{ backgroundColor: '#fff7ed', padding: '1.5rem', borderRadius: 'var(--radius-md)', border: '1px solid #fed7aa', marginBottom: '1.5rem' }}>
                    <span className="enterprise-label" style={{ color: '#c2410c' }}>Enter Master Admin Password to Authorize</span>
                    <input className="enterprise-input" type="password" placeholder="Master Admin Password" value={newStaff.adminPassword} onChange={(e) => setNewStaff({ ...newStaff, adminPassword: e.target.value })} required />
                  </label>

                  {formError && <div className="alert alert-danger" style={{ marginBottom: 15 }}>{formError}</div>}
                  {formSuccess && <div className="alert alert-success" style={{ marginBottom: 15 }}>{formSuccess}</div>}

                  <button type="submit" disabled={formLoading} className="btn-enterprise btn-primary">
                    {formLoading ? "Creating Account..." : "Create Staff Account"}
                  </button>
                </form>
              </div>
            )}

            {(isAdmin || isAccountant) && (
              <div style={{ borderTop: "1px solid #f1f5f9", paddingTop: "2.5rem" }}>
                <h3 style={{ fontSize: '1.2rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '0.5rem' }}>System Processes: Monthly Interest Accrual</h3>
                <p style={{ color: 'var(--text-secondary)', marginBottom: '1.5rem' }}>Run the monthly interest calculation engine to accrue outstanding interest on active loans and deposits.</p>
                
                <button onClick={handleRunAccrual} disabled={accrualLoading} className="btn-enterprise btn-success">
                  {accrualLoading ? "Processing Calculations..." : "Execute Interest Accrual"}
                </button>
                {accrualMsg && <div className="alert alert-success" style={{ marginTop: "15px" }}>{accrualMsg}</div>}
              </div>
            )}
          </div>
        ) : (
          <div style={{ position: "relative", zIndex: 2 }}>
            {/* Stats Grid */}
            <section style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '1.5rem', marginBottom: '1.5rem' }}>
              {isAdmin ? (
                <>
                  <div className="dashboard-card stat-card" style={{ position: 'relative', display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1.5rem' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', width: '100%' }}>
                      <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#e0f2fe', color: '#0ea5e9' }}>
                        <Users size={26} />
                      </div>
                      <MoreVertical size={18} style={{ color: '#94a3b8', cursor: 'pointer' }} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 800, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Members</h4>
                      <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>{stats.totalMembers}</h2>
                    </div>
                    <div className="stat-trend positive" style={{ marginTop: 'auto' }}><ArrowUpRight size={14} /> +2 this month</div>
                  </div>

                  <div className="dashboard-card stat-card" style={{ position: 'relative', display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1.5rem' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', width: '100%' }}>
                      <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#dcfce7', color: '#10b981' }}>
                        <Landmark size={26} />
                      </div>
                      <MoreVertical size={18} style={{ color: '#94a3b8', cursor: 'pointer' }} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 800, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Share Capital</h4>
                      <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.totalShareCapital.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</h2>
                    </div>
                    <div className="stat-trend positive" style={{ marginTop: 'auto' }}><ArrowUpRight size={14} /> +12.5% from last month</div>
                  </div>

                  <div className="dashboard-card stat-card" style={{ position: 'relative', display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1.5rem' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', width: '100%' }}>
                      <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#fef3c7', color: '#f59e0b' }}>
                        <CreditCard size={26} />
                      </div>
                      <MoreVertical size={18} style={{ color: '#94a3b8', cursor: 'pointer' }} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 800, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Deposits</h4>
                      <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.totalDeposits.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</h2>
                    </div>
                    <div className="stat-trend neutral" style={{ marginTop: 'auto' }}><ArrowRight size={14} /> 0% from last month</div>
                  </div>

                  <div className="dashboard-card stat-card" style={{ position: 'relative', display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1.5rem' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', width: '100%' }}>
                      <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#fee2e2', color: '#ef4444' }}>
                        <FileText size={26} />
                      </div>
                      <MoreVertical size={18} style={{ color: '#94a3b8', cursor: 'pointer' }} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 800, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Active Loans</h4>
                      <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>{stats.activeLoans}</h2>
                    </div>
                    <div className="stat-trend positive" style={{ marginTop: 'auto' }}><ArrowUpRight size={14} /> +1 this month</div>
                  </div>
                </>
              ) : (
                <>
                  <div className="glass-card stat-card" style={{ position: 'relative', display: 'flex', alignItems: 'flex-start', gap: '1.25rem', padding: '1.5rem', border: 'none', boxShadow: '0 4px 15px rgba(0,0,0,0.02)' }}>
                    <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#e0f2fe', color: '#0ea5e9' }}>
                      <Users size={26} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>My Share Capital</h4>
                      <h2 style={{ fontSize: '1.6rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.totalShareCapital.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</h2>
                    </div>
                  </div>

                  <div className="glass-card stat-card" style={{ position: 'relative', display: 'flex', alignItems: 'flex-start', gap: '1.25rem', padding: '1.5rem', border: 'none', boxShadow: '0 4px 15px rgba(0,0,0,0.02)' }}>
                    <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#dcfce7', color: '#10b981' }}>
                      <Landmark size={26} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>My Thrift Balance</h4>
                      <h2 style={{ fontSize: '1.6rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.thriftDeposit.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</h2>
                    </div>
                  </div>

                  <div className="glass-card stat-card" style={{ position: 'relative', display: 'flex', alignItems: 'flex-start', gap: '1.25rem', padding: '1.5rem', border: 'none', boxShadow: '0 4px 15px rgba(0,0,0,0.02)' }}>
                    <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#fef3c7', color: '#f59e0b' }}>
                      <CreditCard size={26} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>My Active Deposits</h4>
                      <h2 style={{ fontSize: '1.6rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.totalDeposits.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</h2>
                    </div>
                  </div>

                  <div className="glass-card stat-card" style={{ position: 'relative', display: 'flex', alignItems: 'flex-start', gap: '1.25rem', padding: '1.5rem', border: 'none', boxShadow: '0 4px 15px rgba(0,0,0,0.02)' }}>
                    <div style={{ padding: '0.8rem', borderRadius: '14px', backgroundColor: '#fee2e2', color: '#ef4444' }}>
                      <FileText size={26} />
                    </div>
                    <div>
                      <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Outstanding Loans</h4>
                      <h2 style={{ fontSize: '1.6rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.outstandingLoansAmount.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</h2>
                    </div>
                  </div>
                </>
              )}
            </section>

            {/* Financial Ratio Analytics */}
            <div className="dashboard-card animate__animated animate__fadeInUp" style={{ padding: "24px", marginBottom: "1.5rem", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
              <div style={{ flex: 1, paddingRight: "3rem" }}>
                <h3 style={{ fontSize: "1.1rem", fontWeight: 800, marginBottom: "20px", display: "flex", alignItems: "center", gap: "8px", color: 'var(--text-primary)' }}>
                  <TrendingUp size={18} style={{ color: "var(--primary)" }} /> Financial Portfolio Breakdown Ratio
                </h3>
                <div>
                  <div style={{ display: "flex", justifyContent: "space-between", fontSize: "0.85rem", fontWeight: 800, marginBottom: "8px", color: 'var(--text-primary)' }}>
                    <span>Share Capital vs Total Deposits</span>
                    <span>{stats.totalShareCapital > 0 ? ((stats.totalShareCapital / (stats.totalShareCapital + stats.totalDeposits || 1)) * 100).toFixed(1) : 0}%</span>
                  </div>
                  <div style={{ height: "12px", background: "#f1f5f9", borderRadius: "999px", overflow: "hidden", display: "flex" }}>
                    <div style={{ width: `${stats.totalShareCapital > 0 ? (stats.totalShareCapital / (stats.totalShareCapital + stats.totalDeposits || 1)) * 100 : 0}%`, background: "linear-gradient(90deg, #3b82f6, #2563eb)" }} />
                    <div style={{ flex: 1, background: "linear-gradient(90deg, #10b981, #059669)" }} />
                  </div>
                  <div style={{ display: "flex", gap: "16px", marginTop: "12px", fontSize: "0.8rem", color: "#64748b", fontWeight: 600 }}>
                    <span style={{ display: "flex", alignItems: "center", gap: "6px" }}><span style={{ width: "10px", height: "10px", borderRadius: "50%", background: "#3b82f6" }} /> Share Capital (Blue)</span>
                    <span style={{ display: "flex", alignItems: "center", gap: "6px" }}><span style={{ width: "10px", height: "10px", borderRadius: "50%", background: "#10b981" }} /> Total Deposits (Green)</span>
                  </div>
                </div>
              </div>
              <div style={{ padding: "1rem" }}>
                <div className="pie-chart-mock"></div>
              </div>
            </div>

            <div className="dashboard-main-grid">
              {/* Recent Activity */}
              <div className="dashboard-card" style={{ padding: '1.5rem', display: 'flex', flexDirection: 'column' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
                  <h3 style={{ fontSize: '1.1rem', fontWeight: 800, color: 'var(--text-primary)', display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <FileText size={18} style={{ color: 'var(--primary)' }} /> Recent Ledger Activity
                  </h3>
                  <button className="btn-secondary" style={{ padding: '0.4rem 0.8rem', fontSize: '0.75rem', borderRadius: '6px' }}>View All</button>
                </div>
                
                {recentTransactions.length === 0 ? (
                  <div className="empty-state" style={{ flex: 1 }}>
                    <h3 style={{ fontSize: '1rem', fontWeight: 700, marginBottom: '0.5rem' }}>No transactions recorded.</h3>
                    <p style={{ fontSize: '0.85rem' }}>Transactions will appear here once deposits or withdrawals are made.</p>
                  </div>
                ) : (
                  <>
                    <div className="table-wrapper" style={{ marginTop: 0, boxShadow: 'none', border: 'none' }}>
                      <table className="enterprise-table" style={{ fontSize: '0.8rem' }}>
                        <thead>
                          <tr>
                            <th style={{ background: 'transparent', padding: '0.75rem 0.5rem' }}>Txn No</th>
                            <th style={{ background: 'transparent', padding: '0.75rem 0.5rem' }}>Date</th>
                            <th style={{ background: 'transparent', padding: '0.75rem 0.5rem' }}>Type</th>
                            <th style={{ background: 'transparent', padding: '0.75rem 0.5rem' }}>Amount</th>
                            <th style={{ background: 'transparent', padding: '0.75rem 0.5rem' }}>Dr/Cr</th>
                            <th style={{ background: 'transparent', padding: '0.75rem 0.5rem' }}>Reference</th>
                            <th style={{ background: 'transparent', padding: '0.75rem 0.5rem' }}>Status</th>
                          </tr>
                        </thead>
                        <tbody>
                          {recentTransactions.map((t) => (
                            <tr key={t.id}>
                              <td style={{ padding: '0.75rem 0.5rem' }}><strong>{t.transactionNo}</strong></td>
                              <td style={{ padding: '0.75rem 0.5rem' }}>{new Date(t.transactionDate).toLocaleDateString("en-IN")}</td>
                              <td style={{ padding: '0.75rem 0.5rem' }}>{t.transactionType?.typeName || "Voucher Entry"}</td>
                              <td style={{ padding: '0.75rem 0.5rem', fontWeight: 700 }}>₹{t.amount.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</td>
                              <td style={{ padding: '0.75rem 0.5rem' }}>
                                <span style={{ color: t.type === "DEBIT" ? '#059669' : '#dc2626', fontWeight: 700, fontSize: '0.75rem' }}>
                                  {t.type}
                                </span>
                              </td>
                              <td style={{ padding: '0.75rem 0.5rem' }}>{t.referenceNo || "N/A"}</td>
                              <td style={{ padding: '0.75rem 0.5rem' }}>
                                <span className={`badge badge-${t.status === "COMPLETED" ? "success" : "warning"}`} style={{ fontSize: '0.7rem' }}>
                                  {t.status}
                                </span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                    
                    {stats.totalTransactions > 5 && (
                      <div style={{ marginTop: 'auto', display: 'flex', justifyContent: 'space-between', alignItems: 'center', paddingTop: '1rem', borderTop: '1px solid #f1f5f9', fontSize: '0.8rem', color: '#64748b' }}>
                        <span>Showing 1 to {recentTransactions.length} of {stats.totalTransactions} entries</span>
                        <div className="pagination" style={{ marginTop: 0, paddingTop: 0, borderTop: 'none' }}>
                          <button className="page-btn"><ChevronLeft size={14} /></button>
                          <button className="page-btn active">1</button>
                          {stats.totalTransactions > 5 && <button className="page-btn">2</button>}
                          {stats.totalTransactions > 10 && <button className="page-btn">3</button>}
                          <button className="page-btn"><ChevronRight size={14} /></button>
                        </div>
                      </div>
                    )}
                  </>
                )}
              </div>

              {/* Right Column: Quick Actions & System Overview */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                
                <div className="dashboard-card" style={{ padding: '1.5rem' }}>
                  <h3 style={{ fontSize: '1rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '1.25rem', display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <Zap size={16} style={{ color: 'var(--primary)', fill: 'var(--primary)' }} /> Quick Actions
                  </h3>
                  <div className="quick-actions-grid">
                    <div className="quick-action-btn" onClick={() => navigate("/members")}>
                      <div className="qa-icon-wrap" style={{ background: '#e0f2fe', color: '#0ea5e9' }}><UserPlus size={20} /></div>
                      <span>Add Member</span>
                    </div>
                    <div className="quick-action-btn" onClick={() => navigate("/loans")}>
                      <div className="qa-icon-wrap" style={{ background: '#dcfce7', color: '#10b981' }}><FileText size={20} /></div>
                      <span>New Loan</span>
                    </div>
                    <div className="quick-action-btn" onClick={() => navigate("/deposits")}>
                      <div className="qa-icon-wrap" style={{ background: '#fef3c7', color: '#f59e0b' }}><Landmark size={20} /></div>
                      <span>Add Deposit</span>
                    </div>
                    <div className="quick-action-btn" onClick={() => navigate("/payments")}>
                      <div className="qa-icon-wrap" style={{ background: '#f3e8ff', color: '#9333ea' }}><CreditCard size={20} /></div>
                      <span>Add Payment</span>
                    </div>
                  </div>
                </div>

                <div className="dashboard-card" style={{ padding: '1.5rem', flex: 1 }}>
                  <h3 style={{ fontSize: '1rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '1.25rem', display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <Zap size={16} style={{ color: 'var(--primary)', fill: 'var(--primary)' }} /> Live System Metrics
                  </h3>
                  
                  <div className="system-progress-item">
                    <div className="system-progress-header">
                      <span>System Status</span>
                      <span className="badge badge-success" style={{ background: '#dcfce7', color: '#10b981', border: '1px solid #bbf7d0', padding: '0.1rem 0.5rem' }}>Online</span>
                    </div>
                  </div>
                  
                  <div className="system-progress-item">
                    <div className="system-progress-header">
                      <span>Total Active Members</span>
                      <span style={{ color: 'var(--text-primary)' }}>{stats.totalMembers || 0}</span>
                    </div>
                  </div>

                  <div className="system-progress-item">
                    <div className="system-progress-header">
                      <span>Total Transactions Processed</span>
                      <span style={{ color: 'var(--text-primary)' }}>{stats.totalTransactions || 0}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

          </div>
        )}
    </div>
  );
}
