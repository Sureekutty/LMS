import { useNavigate } from "react-router-dom";
import { Landmark, Users, CreditCard, LogOut, LayoutDashboard, Settings, Bell, RefreshCw } from "lucide-react";
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
      {/* Sidebar (Uses your sleek glass sidebar styles) */}
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

      {/* Main Content Viewport */}
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

        {/* Beautiful, Truthful Workspace Stream Box using your exact styles */}
        <div className="recent-activity">
          <div className="pipeline-header">
            <h2>Core Application Pipeline</h2>
          </div>

          <div className="empty-state">
            <div className="empty-state-icon">
              <RefreshCw size={26} className="spin-sync-icon" />
            </div>
            <h3>Workspace Synchronized</h3>
            <p>
              Database environment is live and secure. Use the navigation panel to manage members or register incoming requests.
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}