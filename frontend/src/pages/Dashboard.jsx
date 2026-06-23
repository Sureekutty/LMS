import { useNavigate } from "react-router-dom";
import { Landmark, Users, CreditCard, LogOut, LayoutDashboard, Settings, Bell } from "lucide-react";
import "./Dashboard.css";

export default function Dashboard() {
  const navigate = useNavigate();
  const username = localStorage.getItem("username") || "Admin";

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
          <a href="#members" className="nav-item">
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

      {/* Main Content */}
      <main className="main-content">
        <header className="topbar">
          <div>
            <h1 className="page-title">LMS Dashboard</h1>
            <p className="page-subtitle">Welcome back, {username}</p>
          </div>
          <div className="topbar-actions">
            <button className="icon-btn">
              <Bell size={20} />
            </button>
            <div className="avatar">{username.charAt(0).toUpperCase()}</div>
          </div>
        </header>

        <div className="dashboard-grid">
          {/* Stats Cards */}
          <div className="stat-card">
            <div className="stat-icon-wrapper" style={{background: 'rgba(14, 165, 233, 0.1)', color: '#0ea5e9'}}>
              <Users size={24} />
            </div>
            <div>
              <h3>Total Members</h3>
              <p className="stat-value">247</p>
            </div>
          </div>
          
          <div className="stat-card">
            <div className="stat-icon-wrapper" style={{background: 'rgba(16, 185, 129, 0.1)', color: '#10b981'}}>
              <CreditCard size={24} />
            </div>
            <div>
              <h3>Active Loans</h3>
              <p className="stat-value">₹42.6L</p>
            </div>
          </div>

          <div className="stat-card">
            <div className="stat-icon-wrapper" style={{background: 'rgba(245, 158, 11, 0.1)', color: '#f59e0b'}}>
              <Landmark size={24} />
            </div>
            <div>
              <h3>Pending Approvals</h3>
              <p className="stat-value">18</p>
            </div>
          </div>
        </div>

        <div className="recent-activity">
          <h2>Recent Applications</h2>
          <div className="empty-state">
            <p>Connect backend to view real loan applications.</p>
          </div>
        </div>
      </main>
    </div>
  );
}