import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Landmark, Users, CreditCard, LogOut, LayoutDashboard, Settings, Bell, RefreshCw, ShieldAlert } from "lucide-react";
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
    firstName: "",
    lastName: "",
    email: "",
    password: "",
    confirmPassword: "",
    role: "CLERK",
    adminPassword: ""
  });
  const [formError, setFormError] = useState("");
  const [formSuccess, setFormSuccess] = useState("");
  const [formLoading, setFormLoading] = useState(false);

  const [stats, setStats] = useState({
    totalMembers: 0,
    totalShareCapital: 0,
    totalDeposits: 0,
    activeLoans: 0,
    thriftDeposit: 0,
    outstandingLoansAmount: 0
  });
  const [recentTransactions, setRecentTransactions] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      if (isAdmin) {
        // Global administrative metrics
        const [membersRes, loansRes, txnsRes, depositsRes] = await Promise.all([
          API.get("/members"),
          API.get("/loans"),
          API.get("/transactions"),
          API.get("/deposits")
        ]);

        const members = membersRes.data || [];
        const loans = loansRes.data || [];
        const txns = txnsRes.data || [];
        const deposits = depositsRes.data || [];

        const totalShareCapital = members.reduce((sum, m) => sum + (m.shareCapital || 0), 0);
        const totalDeposits = deposits.reduce((sum, d) => sum + (d.principalAmount || 0), 0);
        const activeLoansCount = loans.filter(l => l.status && (l.status.toUpperCase() === "ACTIVE" || l.status.toUpperCase() === "APPROVED")).length;

        setStats({
          totalMembers: members.length,
          totalShareCapital,
          totalDeposits,
          activeLoans: activeLoansCount,
          thriftDeposit: 0,
          outstandingLoansAmount: 0
        });

        // Sort by transaction date descending, slice to get top 5
        const sortedTxns = txns.sort((a, b) => new Date(b.transactionDate) - new Date(a.transactionDate));
        setRecentTransactions(sortedTxns.slice(0, 5));
      } else {
        // Personalized Member metrics
        const meRes = await API.get("/members/me");
        const member = meRes.data;

        if (member && member.id) {
          const [loansRes, txnsRes, depositsRes] = await Promise.all([
            API.get("/loans/member/" + member.id),
            API.get("/transactions/member/" + member.id),
            API.get("/deposits/member/" + member.id)
          ]);

          const loans = loansRes.data || [];
          const txns = txnsRes.data || [];
          const deposits = depositsRes.data || [];

          // Outstanding loans amount = sum of outstandingPrincipal + outstandingInterest for ACTIVE/APPROVED loans
          const outstandingLoansAmount = loans
            .filter(l => l.status && (l.status.toUpperCase() === "ACTIVE" || l.status.toUpperCase() === "APPROVED"))
            .reduce((sum, l) => sum + (l.outstandingPrincipal || 0) + (l.outstandingInterest || 0), 0);

          const totalDeposits = deposits.reduce((sum, d) => sum + (d.principalAmount || 0), 0);

          setStats({
            totalMembers: 0,
            totalShareCapital: member.shareCapital || 0,
            thriftDeposit: member.thriftDeposit || 0,
            totalDeposits,
            activeLoans: loans.filter(l => l.status && (l.status.toUpperCase() === "ACTIVE" || l.status.toUpperCase() === "APPROVED")).length,
            outstandingLoansAmount
          });

          // Sort by transaction date descending, slice to get top 5
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
        username: newStaff.email,
        email: newStaff.email,
        firstName: newStaff.firstName,
        lastName: newStaff.lastName,
        displayName: newStaff.firstName + " " + newStaff.lastName,
        password: newStaff.password,
        roles: [newStaff.role],
        adminPassword: newStaff.adminPassword
      };

      await API.post("/auth/register", payload);
      setFormSuccess("Staff/Admin user registered successfully!");
      setNewStaff({
        firstName: "",
        lastName: "",
        email: "",
        password: "",
        confirmPassword: "",
        role: "CLERK",
        adminPassword: ""
      });
    } catch (err) {
      setFormError(err.response?.data?.message || "Failed to create staff account.");
    } finally {
      setFormLoading(false);
    }
  };

  return (
    <div className="dashboard-layout">
      {/* Sidebar */}
      <aside className="sidebar">
        <div className="sidebar-header">
          <div className="logo-box">
            <Landmark size={20} />
          </div>
          <span>LMS Console</span>
        </div>

        <nav className="sidebar-nav">
          <a
            href="#overview"
            className={`nav-item ${currentTab === "overview" ? "active" : ""}`}
            onClick={(e) => { e.preventDefault(); setCurrentTab("overview"); }}
          >
            <LayoutDashboard size={18} />
            Overview
          </a>

          {(isAdmin || isClerk) && (
            <a
              href="#members"
              className="nav-item"
              onClick={(e) => { e.preventDefault(); navigate("/members"); }}
            >
              <Users size={18} />
              Members
            </a>
          )}

          <a
            href="#deposits"
            className="nav-item"
            onClick={(e) => { e.preventDefault(); navigate("/deposits"); }}
          >
            <Landmark size={18} />
            {isMember ? "My Deposits" : "Deposits"}
          </a>

          {(isAdmin || isClerk) && (
            <a
              href="#loans"
              className="nav-item"
              onClick={(e) => { e.preventDefault(); navigate("/loans"); }}
            >
              <CreditCard size={18} />
              Loans
            </a>
          )}

          {isMember && (
            <a
              href="#my-loans"
              className="nav-item"
              onClick={(e) => { e.preventDefault(); navigate("/loans"); }}
            >
              <CreditCard size={18} />
              My Loans
            </a>
          )}

          {(isAdmin || isClerk || isAccountant) && (
            <a
              href="#payments"
              className="nav-item"
              onClick={(e) => { e.preventDefault(); navigate("/payments"); }}
            >
              <Landmark size={18} />
              Payments
            </a>
          )}

          {(isAdmin || isAccountant) && (
            <a
              href="#reports"
              className="nav-item"
              onClick={(e) => { e.preventDefault(); navigate("/reports"); }}
            >
              <Settings size={18} />
              Reports
            </a>
          )}

          {isAdmin && (
            <a
              href="#settings"
              className={`nav-item ${currentTab === "settings" ? "active" : ""}`}
              onClick={(e) => { e.preventDefault(); setCurrentTab("settings"); }}
            >
              <Settings size={18} />
              Settings
            </a>
          )}

          {isAdmin && (
            <a
              href="#audits"
              className="nav-item"
              onClick={(e) => { e.preventDefault(); navigate("/audits"); }}
            >
              <ShieldAlert size={18} />
              Audit Logs
            </a>
          )}
        </nav>

        <div className="sidebar-footer">
          <button onClick={handleLogout} className="logout-btn">
            <LogOut size={18} />
            Sign Out
          </button>
        </div>
      </aside>

      {/* Main Content Viewport */}
      <main className="main-content">
        <header className="topbar">
          <div>
            <h1 className="page-title">LMS Dashboard</h1>
            <p className="page-subtitle">Welcome back, {username}</p>
          </div>
          
          <div className="topbar-actions">
            <button className="icon-btn" onClick={fetchDashboardData} title="Sync Workspace">
              <RefreshCw size={20} />
            </button>
            <button className="icon-btn">
              <Bell size={20} />
            </button>
            <div className="avatar">{username.charAt(0).toUpperCase()}</div>
          </div>
        </header>

        {loading ? (
          <div className="empty-state">
            <RefreshCw size={36} className="spin-sync-icon" />
            <h3 style={{ marginTop: 15 }}>Syncing Ledger Data...</h3>
          </div>
        ) : currentTab === "settings" ? (
          <div className="settings-panel">
            <h2>Account Settings & System Controls</h2>
            
            {isAdmin && (
              <div className="settings-section">
                <h3>System Controls: Add Staff/Admin Account</h3>
                <p>Register new Admins, Accountants, or Clerks by confirming the master password.</p>

                <form onSubmit={handleAddStaff} className="settings-form">
                  <div className="form-row">
                    <label>
                      <span>First Name</span>
                      <input
                        type="text"
                        placeholder="First Name"
                        value={newStaff.firstName}
                        onChange={(e) => setNewStaff({ ...newStaff, firstName: e.target.value })}
                        required
                      />
                    </label>
                    <label>
                      <span>Last Name</span>
                      <input
                        type="text"
                        placeholder="Last Name"
                        value={newStaff.lastName}
                        onChange={(e) => setNewStaff({ ...newStaff, lastName: e.target.value })}
                        required
                      />
                    </label>
                  </div>

                  <div className="form-row">
                    <label>
                      <span>Email / Username</span>
                      <input
                        type="email"
                        placeholder="Email ID"
                        value={newStaff.email}
                        onChange={(e) => setNewStaff({ ...newStaff, email: e.target.value })}
                        required
                      />
                    </label>
                    <label>
                      <span>Target System Role</span>
                      <select
                        value={newStaff.role}
                        onChange={(e) => setNewStaff({ ...newStaff, role: e.target.value })}
                        required
                      >
                        <option value="CLERK">Clerk</option>
                        <option value="ACCOUNTANT">Accountant</option>
                        <option value="ADMIN">Administrator</option>
                      </select>
                    </label>
                  </div>

                  <div className="form-row">
                    <label>
                      <span>Password</span>
                      <input
                        type="password"
                        placeholder="Password"
                        value={newStaff.password}
                        onChange={(e) => setNewStaff({ ...newStaff, password: e.target.value })}
                        required
                      />
                    </label>
                    <label>
                      <span>Confirm Password</span>
                      <input
                        type="password"
                        placeholder="Confirm Password"
                        value={newStaff.confirmPassword}
                        onChange={(e) => setNewStaff({ ...newStaff, confirmPassword: e.target.value })}
                        required
                      />
                    </label>
                  </div>

                  <label className="admin-password-label">
                    <span>Enter Master Admin Password to Authorize</span>
                    <input
                      type="password"
                      placeholder="Master Admin Password"
                      value={newStaff.adminPassword}
                      onChange={(e) => setNewStaff({ ...newStaff, adminPassword: e.target.value })}
                      required
                    />
                  </label>

                  {formError && <div className="form-error-msg">{formError}</div>}
                  {formSuccess && <div className="form-success-msg">{formSuccess}</div>}

                  <button type="submit" disabled={formLoading} className="settings-submit-btn">
                    {formLoading ? "Creating Account..." : "Create Staff Account"}
                  </button>
                </form>
              </div>
            )}
          </div>
        ) : (
          <>
            {/* Stats Grid */}
            <div className="dashboard-grid">
              {isAdmin ? (
                <>
                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(14, 165, 233, 0.1)", color: "#0ea5e9" }}>
                      <Users size={28} />
                    </div>
                    <div>
                      <h3>Total Members</h3>
                      <div className="stat-value">{stats.totalMembers}</div>
                    </div>
                  </div>

                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(16, 185, 129, 0.1)", color: "#10b981" }}>
                      <Landmark size={28} />
                    </div>
                    <div>
                      <h3>Share Capital</h3>
                      <div className="stat-value">₹{stats.totalShareCapital.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</div>
                    </div>
                  </div>

                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(245, 158, 11, 0.1)", color: "#f59e0b" }}>
                      <Landmark size={28} />
                    </div>
                    <div>
                      <h3>Total Deposits</h3>
                      <div className="stat-value">₹{stats.totalDeposits.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</div>
                    </div>
                  </div>

                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(239, 68, 68, 0.1)", color: "#ef4444" }}>
                      <CreditCard size={28} />
                    </div>
                    <div>
                      <h3>Active Loans</h3>
                      <div className="stat-value">{stats.activeLoans}</div>
                    </div>
                  </div>
                </>
              ) : (
                <>
                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(14, 165, 233, 0.1)", color: "#0ea5e9" }}>
                      <Users size={28} />
                    </div>
                    <div>
                      <h3>My Share Capital</h3>
                      <div className="stat-value">₹{stats.totalShareCapital.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</div>
                    </div>
                  </div>

                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(16, 185, 129, 0.1)", color: "#10b981" }}>
                      <Landmark size={28} />
                    </div>
                    <div>
                      <h3>My Thrift Balance</h3>
                      <div className="stat-value">₹{stats.thriftDeposit.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</div>
                    </div>
                  </div>

                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(245, 158, 11, 0.1)", color: "#f59e0b" }}>
                      <Landmark size={28} />
                    </div>
                    <div>
                      <h3>My Active Deposits</h3>
                      <div className="stat-value">₹{stats.totalDeposits.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</div>
                    </div>
                  </div>

                  <div className="stat-card">
                    <div className="stat-icon-wrapper" style={{ background: "rgba(239, 68, 68, 0.1)", color: "#ef4444" }}>
                      <CreditCard size={28} />
                    </div>
                    <div>
                      <h3>Outstanding Loans</h3>
                      <div className="stat-value">₹{stats.outstandingLoansAmount.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</div>
                    </div>
                  </div>
                </>
              )}
            </div>

            {/* Recent Activity */}
            <div className="recent-activity">
              <h2>{isAdmin ? "Recent Ledger Activity" : "My Recent Ledger Transactions"}</h2>
              {recentTransactions.length === 0 ? (
                <div className="empty-state">
                  <h3>No transactions recorded.</h3>
                  <p>Transactions will appear here once deposits, withdrawals, or disbursements are made.</p>
                </div>
              ) : (
                <div className="activity-table-wrap">
                  <table className="activity-table">
                    <thead>
                      <tr>
                        <th>Txn No</th>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Dr/Cr</th>
                        <th>Reference</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      {recentTransactions.map((t) => (
                        <tr key={t.id}>
                          <td>{t.transactionNo}</td>
                          <td>{new Date(t.transactionDate).toLocaleDateString("en-IN")}</td>
                          <td>{t.transactionType?.typeName || "Voucher Entry"}</td>
                          <td>₹{t.amount.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</td>
                          <td>
                            <span className={t.type === "DEBIT" ? "type-debit" : "type-credit"}>
                              {t.type}
                            </span>
                          </td>
                          <td>{t.referenceNo || "N/A"}</td>
                          <td>
                            <span className={`badge-status ${t.status === "COMPLETED" ? "status-completed" : "status-pending"}`}>
                              {t.status}
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          </>
        )}
      </main>
    </div>
  );
}