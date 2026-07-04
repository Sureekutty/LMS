import React, { useState, useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { 
  Landmark, Users, CreditCard, LogOut, Home, Settings, Bell, 
  ShieldAlert, FileText, Search, Sun, Moon, ChevronRight, UserPlus 
} from 'lucide-react';
import ProfileModal from './ProfileModal';
import './Layout.css';

export default function Layout({ children }) {
  const navigate = useNavigate();
  const location = useLocation();
  const currentPath = location.pathname;
  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const [isProfileModalOpen, setIsProfileModalOpen] = useState(false);
  const [isNotificationsOpen, setIsNotificationsOpen] = useState(false);
  const [isDarkMode, setIsDarkMode] = useState(false);
  const searchInputRef = useRef(null);

  useEffect(() => {
    const handleKeyDown = (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        searchInputRef.current?.focus();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  const toggleTheme = () => {
    setIsDarkMode(!isDarkMode);
    if (!isDarkMode) {
      document.body.classList.add('dark-theme');
    } else {
      document.body.classList.remove('dark-theme');
    }
  };
  
  const [username, setUsername] = useState(localStorage.getItem("username") || "Admin");
  const [profileImage, setProfileImage] = useState(null);

  // Listen for profile updates
  React.useEffect(() => {
    const handleProfileUpdate = (e) => {
      const data = e.detail;
      if (data.displayName) {
        setUsername(data.displayName);
        // We do not change localStorage username here because it's used for login checks, 
        // but we can update the UI display state.
      }
      if (data.profileImageUrl) {
        setProfileImage(data.profileImageUrl);
      }
    };
    window.addEventListener('profile-updated', handleProfileUpdate);
    return () => window.removeEventListener('profile-updated', handleProfileUpdate);
  }, []);

  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isClerk = roles.includes("ROLE_CLERK");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isMember = roles.includes("ROLE_MEMBER") || (!isAdmin && !isClerk && !isAccountant);

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("username");
    localStorage.removeItem("roles");
    localStorage.removeItem("membershipNo");
    navigate("/login");
  };

  return (
    <div className="dashboard-layout">
      {/* Sidebar */}
      <aside className="sidebar">
        <div className="sidebar-header" style={{ padding: "0.5rem 0.5rem", gap: "12px", marginBottom: "2rem", display: 'flex', alignItems: 'center' }}>
          <img src="/lms_logo.svg" alt="LMS Logo" style={{ height: "38px", width: "38px", filter: "drop-shadow(0 2px 8px rgba(56, 189, 248, 0.4))" }} />
          <span style={{ fontSize: "1.4rem", fontWeight: 800, color: "#0ea5e9", letterSpacing: "-0.02em" }}>LMS</span>
        </div>

        <nav className="sidebar-nav">
          <div className="sidebar-group-label">Overview</div>
          <button className={`nav-item ${currentPath === "/dashboard" ? "active" : ""}`} onClick={() => navigate("/dashboard")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
            <div className="nav-item-content">
              <Home size={18} /> Dashboard
            </div>
          </button>

          <div className="sidebar-group-label">Core Modules</div>
          <button className={`nav-item ${currentPath === "/members" ? "active" : ""}`} onClick={() => navigate("/members")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
            <div className="nav-item-content"><Users size={18} /> Members</div>
            <ChevronRight size={14} opacity={0.5} />
          </button>
          <button className={`nav-item ${currentPath === "/deposits" ? "active" : ""}`} onClick={() => navigate("/deposits")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
            <div className="nav-item-content"><Landmark size={18} /> {isMember ? "My Deposits" : "Deposits"}</div>
            <ChevronRight size={14} opacity={0.5} />
          </button>
          <button className={`nav-item ${currentPath === "/shares" ? "active" : ""}`} onClick={() => navigate("/shares")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
            <div className="nav-item-content"><UserPlus size={18} /> Shares</div>
            <ChevronRight size={14} opacity={0.5} />
          </button>
          <button className={`nav-item ${currentPath === "/loans" ? "active" : ""}`} onClick={() => navigate("/loans")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
            <div className="nav-item-content"><CreditCard size={18} /> {isMember ? "My Loans" : "Loans"}</div>
            <ChevronRight size={14} opacity={0.5} />
          </button>

          <div className="sidebar-group-label">Accounting & Ledger</div>
          {(isAdmin || isClerk || isAccountant) && (
            <button className={`nav-item ${currentPath === "/payments" ? "active" : ""}`} onClick={() => navigate("/payments")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
              <div className="nav-item-content"><Landmark size={18} /> Payments</div>
              <ChevronRight size={14} opacity={0.5} />
            </button>
          )}
          {(isAdmin || isClerk || isAccountant) && (
            <button className={`nav-item ${currentPath === "/banks" ? "active" : ""}`} onClick={() => navigate("/banks")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
              <div className="nav-item-content"><Landmark size={18} /> Bank Accounts</div>
            </button>
          )}
          <button className={`nav-item ${currentPath === "/bills" ? "active" : ""}`} onClick={() => navigate("/bills")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
            <div className="nav-item-content"><FileText size={18} /> Billing & Invoices</div>
          </button>
          {(isAdmin || isClerk || isAccountant) && (
            <button className={`nav-item ${currentPath === "/misc-payments" ? "active" : ""}`} onClick={() => navigate("/misc-payments")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
              <div className="nav-item-content"><FileText size={18} /> Misc Vouchers</div>
            </button>
          )}
          {(isAdmin || isAccountant) && (
            <button className={`nav-item ${currentPath === "/journal-vouchers" ? "active" : ""}`} onClick={() => navigate("/journal-vouchers")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
              <div className="nav-item-content"><FileText size={18} /> Journal Vouchers</div>
            </button>
          )}
          {(isAdmin || isAccountant) && (
            <button className={`nav-item ${currentPath === "/reports" ? "active" : ""}`} onClick={() => navigate("/reports")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
              <div className="nav-item-content"><FileText size={18} /> Reports</div>
            </button>
          )}

          <div className="sidebar-group-label">Settings & Config</div>
          {isAdmin && (
            <button className={`nav-item ${currentPath === "/audits" ? "active" : ""}`} onClick={() => navigate("/audits")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
              <div className="nav-item-content"><ShieldAlert size={18} /> Users & Roles</div>
            </button>
          )}
          <button className={`nav-item ${currentPath === "/polls" ? "active" : ""}`} onClick={() => navigate("/polls")} style={{background: 'none', width: '100%', cursor: 'pointer'}}>
            <div className="nav-item-content"><Users size={18} /> Society Polls</div>
          </button>
        </nav>

        <div className="ai-assistant-card" style={{ marginTop: '2rem' }}>
          <h4>Need Help?</h4>
          <h4>LMS AI Assistant</h4>
          <p>Ask me anything about your loans, deposits, or members.</p>
          <button 
            className="btn-enterprise btn-primary" 
            style={{ width: '100%', marginTop: '0.75rem', fontSize: '0.8rem', padding: '0.5rem' }}
            onClick={() => window.dispatchEvent(new CustomEvent('open-ai-chat'))}
          >
            Open Chat
          </button>
          <div style={{ position: 'absolute', right: '-15px', bottom: '-15px', opacity: 0.3, transform: 'rotate(-15deg)' }}>
            <svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="11" width="18" height="10" rx="2" />
              <circle cx="12" cy="5" r="2" />
              <path d="M12 7v4" />
            </svg>
          </div>
        </div>
      </aside>

      <div className="main-wrapper">
        {/* Global Topbar */}
        <header className="global-topbar">
          <div className="page-title-group">
            <span style={{ fontSize: '0.85rem', color: '#64748b', fontWeight: 600, display: 'block', marginBottom: '4px' }}>Good Morning, {username}! 👋</span>
            <h1 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)' }}>LMS Enterprise</h1>
          </div>
          
          <div style={{ display: 'flex', gap: '1.5rem', alignItems: 'center' }}>
            <div className="topbar-search">
              <Search size={16} color="#94a3b8" />
              <input ref={searchInputRef} type="text" placeholder="Search anything..." />
              <kbd>Ctrl+K</kbd>
            </div>
            
            <div style={{ display: 'flex', gap: '1rem', alignItems: 'center', marginLeft: '0.5rem' }}>
              <button className="icon-btn" onClick={toggleTheme} style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: '50%', width: '40px', height: '40px', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-secondary)', cursor: 'pointer' }}>
                {isDarkMode ? <Moon size={20} /> : <Sun size={20} />}
              </button>
              
              <div style={{ position: 'relative' }}>
                <button className="icon-btn" onClick={() => setIsNotificationsOpen(!isNotificationsOpen)} style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: '50%', width: '40px', height: '40px', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-secondary)', cursor: 'pointer' }}>
                  <Bell size={20} />
                  <span style={{ position: 'absolute', top: '-2px', right: '-2px', width: '18px', height: '18px', background: '#ef4444', borderRadius: '50%', border: '2px solid var(--bg-card)', color: 'white', fontSize: '10px', fontWeight: 800, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>3</span>
                </button>
                
                {isNotificationsOpen && (
                  <div style={{ position: 'absolute', top: '100%', right: '0', marginTop: '0.5rem', background: 'var(--bg-card)', borderRadius: '12px', boxShadow: '0 10px 25px rgba(0,0,0,0.1)', border: '1px solid var(--border-color)', width: '320px', zIndex: 100, overflow: 'hidden' }}>
                    <div style={{ padding: '1rem', borderBottom: '1px solid var(--border-color)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <strong style={{ color: 'var(--text-primary)' }}>Notifications</strong>
                      <span style={{ fontSize: '0.75rem', color: 'var(--primary)', cursor: 'pointer', fontWeight: 600 }}>Mark all read</span>
                    </div>
                    <div style={{ padding: '0', maxHeight: '300px', overflowY: 'auto' }}>
                      {[
                        { id: 1, title: 'New Loan Application', desc: 'Rajesh applied for a personal loan.', link: '/loans' },
                        { id: 2, title: 'Share Transfer Request', desc: 'John Doe requested a transfer of 50 shares.', link: '/shares' },
                        { id: 3, title: 'System Alert', desc: 'Monthly audit reports generated successfully.', link: '/reports' }
                      ].map(n => (
                        <div 
                          key={n.id} 
                          onClick={() => { navigate(n.link); setIsNotificationsOpen(false); }}
                          style={{ padding: '1rem', borderBottom: '1px solid var(--border-color)', display: 'flex', gap: '1rem', cursor: 'pointer' }}
                          onMouseOver={(e) => e.currentTarget.style.background = 'var(--border-light)'}
                          onMouseOut={(e) => e.currentTarget.style.background = 'transparent'}
                        >
                          <div style={{ width: '8px', height: '8px', borderRadius: '50%', background: 'var(--primary)', marginTop: '6px', flexShrink: 0 }}></div>
                          <div>
                            <p style={{ margin: 0, fontSize: '0.85rem', color: 'var(--text-primary)', fontWeight: 600 }}>{n.title}</p>
                            <p style={{ margin: '4px 0 0 0', fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{n.desc}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
              
              <div style={{ position: 'relative' }}>
                <div onClick={() => setIsProfileOpen(!isProfileOpen)} title="Account Settings" style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', marginLeft: '0.5rem', cursor: 'pointer', padding: '0.5rem', borderRadius: '50px', transition: 'all 0.2s', background: isProfileOpen ? 'var(--border-light)' : 'transparent' }}>
                  <div style={{ 
                    width: '42px', height: '42px', borderRadius: '50%', 
                    backgroundColor: 'var(--primary)', color: 'white', 
                    display: 'flex', alignItems: 'center', justifyContent: 'center', 
                    fontWeight: 800, fontSize: '1.1rem', boxShadow: '0 4px 10px rgba(37,99,235,0.2)',
                    background: profileImage ? `url(${profileImage}) center/cover` : 'var(--primary)'
                  }}>
                    {!profileImage && username.charAt(0).toUpperCase()}
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column' }}>
                    <span style={{ fontSize: '0.9rem', fontWeight: 800, color: 'var(--text-primary)' }}>{username}</span>
                    <span style={{ fontSize: '0.75rem', fontWeight: 600, color: 'var(--text-secondary)', display: 'flex', alignItems: 'center', gap: '4px' }}>
                      {isAdmin ? 'Super Admin' : (isClerk ? 'Clerk' : 'User')}
                      <ChevronRight size={12} style={{ transform: isProfileOpen ? 'rotate(90deg)' : 'rotate(0deg)', transition: 'transform 0.2s' }} />
                    </span>
                  </div>
                </div>

                {isProfileOpen && (
                  <div style={{ position: 'absolute', top: '100%', right: '0', marginTop: '0.5rem', background: 'var(--bg-card)', borderRadius: '12px', boxShadow: '0 10px 25px rgba(0,0,0,0.1)', border: '1px solid var(--border-color)', width: '220px', zIndex: 100, overflow: 'hidden' }}>
                    <div style={{ padding: '1rem', borderBottom: '1px solid var(--border-color)' }}>
                      <strong style={{ display: 'block', color: 'var(--text-primary)' }}>{username}</strong>
                      <span style={{ fontSize: '0.8rem', color: '#64748b' }}>Manage your account</span>
                    </div>
                    <div style={{ padding: '0.5rem' }}>
                      <button className="nav-item" onClick={() => { setIsProfileOpen(false); setIsProfileModalOpen(true); }} style={{ width: '100%', background: 'none', border: 'none', textAlign: 'left', padding: '0.5rem 1rem', cursor: 'pointer', display: 'flex', gap: '8px', alignItems: 'center' }}>
                        <Settings size={16} /> Edit Profile
                      </button>
                      <button className="nav-item" onClick={() => { setIsProfileOpen(false); handleLogout(); }} style={{ width: '100%', background: 'none', border: 'none', textAlign: 'left', padding: '0.5rem 1rem', cursor: 'pointer', display: 'flex', gap: '8px', alignItems: 'center', color: '#dc2626' }}>
                        <LogOut size={16} /> Sign Out
                      </button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </header>

        {/* Dynamic Page Content */}
        <main className="main-content-scrollable">
          {children}
        </main>
      </div>

      <ProfileModal isOpen={isProfileModalOpen} onClose={() => setIsProfileModalOpen(false)} />
    </div>
  );
}
