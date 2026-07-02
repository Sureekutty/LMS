import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Landmark, Users, CreditCard, LogOut, LayoutDashboard, Settings, Bell, RefreshCw } from "lucide-react";
import API from "../api/axios";
import "./Dashboard.css";

export default function Dashboard() {
  const navigate = useNavigate();
  const username = localStorage.getItem("username") || "Admin";

  const [stats, setStats] = useState({
    totalMembers: 0,
    totalShareCapital: 0,
    totalDeposits: 0,
    activeLoans: 0
  });
  const [recentTransactions, setRecentTransactions] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
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
        activeLoans: activeLoansCount
      });

      // Sort by transaction date descending, slice to get top 5
      const sortedTxns = txns.sort((a, b) => new Date(b.transactionDate) - new Date(a.transactionDate));
      setRecentTransactions(sortedTxns.slice(0, 5));
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
    navigate("/login");
  };

  return (
    <div className="dashboard-layout">
      {/* Sidebar */}
      <aside className="sidebar">
        <div className="sidebar-header">
          <div className="logo-box">
            <Landmark size={20} />
          </div>
          <span>LMS Admin</span>
        </div>

        <nav className="sidebar-nav">
          <a href="#overview" className="nav-item active">
            <LayoutDashboard size={18} />
            Overview
          </a>
          <a href="#members" className="nav-item" onClick={() => navigate("/members")}>
            <Users size={18} />
            Members
          </a>
          <a href="#loans" className="nav-item">
            <CreditCard size={18} />
            Loans
          </a>
          <a href="#settings" className="nav-item">
            <Settings size={18} />
            Settings
          </a>
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
        ) : (
          <>
            {/* Stats Grid */}
            <div className="dashboard-grid">
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
                  <div className="stat-value">₹{stats.totalShareCapital.toLocaleString('en-IN')}</div>
                </div>
              </div>

              <div className="stat-card">
                <div className="stat-icon-wrapper" style={{ background: "rgba(245, 158, 11, 0.1)", color: "#f59e0b" }}>
                  <Landmark size={28} />
                </div>
                <div>
                  <h3>Total Deposits</h3>
                  <div className="stat-value">₹{stats.totalDeposits.toLocaleString('en-IN')}</div>
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
            </div>

            {/* Recent Activity */}
            <div className="recent-activity">
              <h2>Recent Ledger Activity</h2>
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