import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import {
  ArrowRight,
  BarChart3,
  CheckCircle2,
  FileText,
  Landmark,
  Lock,
  Receipt,
  Settings,
  ShieldCheck,
  User,
  Wallet,
  HelpCircle
} from "lucide-react";
import api from "../api/axios";
import "./Login.css";

export default function Login() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [showHelpModal, setShowHelpModal] = useState(false);
  const navigate = useNavigate();

  const currentDateStr = new Date().toLocaleDateString("en-IN", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      const response = await api.post("/auth/login", { username, password });
      localStorage.setItem("token", response.data.token);
      localStorage.setItem("username", response.data.username);
      localStorage.setItem("roles", JSON.stringify(response.data.roles || []));
      localStorage.setItem("membershipNo", response.data.membershipNo || "");
      navigate("/dashboard");
    } catch (err) {
      setError("Invalid username or password");
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="login-page">
      <div className="blur-blob blob-1" aria-hidden="true" />
      <div className="blur-blob blob-2" aria-hidden="true" />
      <div className="blur-blob blob-3" aria-hidden="true" />

      <nav className="navbar" aria-label="Main navigation">
        <div className="logo" style={{ display: "flex", alignItems: "center", gap: "10px" }}>
          <img src="/lms_logo.svg" alt="LMS Logo" style={{ height: "40px", width: "40px", filter: "drop-shadow(0 2px 8px rgba(56, 189, 248, 0.4))" }} />
          <span style={{ fontSize: "1.4rem", fontWeight: 800, color: "#0ea5e9", letterSpacing: "-0.02em" }}>LMS</span>
        </div>
        <div className="nav-links">
          <a href="#modules">Modules</a>
          <a href="#security">Security</a>
        </div>
      </nav>

      <div className="hero-section">
        <div className="hero-info-panel">
          <span className="hero-badge">
            <ShieldCheck size={14} />
            Smart Loan Management Platform
          </span>

          <h1>
            Loan operations,
            <span> finally in one place.</span>
          </h1>

          <p>
            Manage members, applications, approvals, EMI tracking,
            and automated reporting from an ultra-responsive interface
            engineered for fast-moving teams.
          </p>

          {/* Kept the preview structure intact but wiped the exact stats text strings */}
          <div className="dashboard-preview" aria-hidden="true">
            <div className="dashboard-card">
              <div className="dashboard-header">
                <div>
                  <h3>LMS Overview</h3>
                </div>
                <span className="live-pill">
                  <span className="live-dot" />
                  Live System
                </span>
              </div>
              <div className="summary-row">
                <div>
                  <strong>Console Access Point</strong>
                </div>
                <BarChart3 size={26} />
              </div>
            </div>
          </div>
        </div>

        <div className="login-wrapper">
          <div className="login-card">
            <div className="marquee-wrapper" style={{ display: "flex", justifyContent: "center", alignItems: "center" }}>
              <span className="lms-marquee">
                Welcome to LMS • Management System
              </span>
            </div>
            
            <div className="login-header-row">
              <span className="login-eyebrow">
                <ShieldCheck size={13} />
                Secure Gateway
              </span>
              <button
                type="button"
                onClick={() => setShowHelpModal(true)}
                className="guide-help-link"
                title="Open Help Center"
                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 0 }}
              >
                <HelpCircle size={18} />
              </button>
            </div>

            <div className="date-display">{currentDateStr}</div>
            
            <h2>Welcome back</h2>
            <p>Sign in to continue to your dashboard</p>

            <form onSubmit={handleSubmit} className="login-form">
              <label className="input-group">
                <User size={18} className="input-icon" />
                <input
                  type="text"
                  placeholder="Username"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  required
                  autoFocus
                />
              </label>

              <label className="input-group">
                <Lock size={18} className="input-icon" />
                <input
                  type="password"
                  placeholder="Password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </label>

              {error && <div className="form-error">{error}</div>}

              <button type="submit" disabled={loading}>
                {loading ? (
                  <span className="btn-spinner" />
                ) : (
                  <>
                    Sign In <ArrowRight size={18} />
                  </>
                )}
              </button>
            </form>
            <div className="login-footer">
              Don't have an id? <Link to="/register">Register (New Id creation)</Link>
            </div>
          </div>
        </div>
      </div>

      <section id="modules" className="feature-section">
        <span className="section-eyebrow">Core Modules</span>
        <h2>Everything a lending team needs</h2>
        <div className="feature-grid">
          <FeatureCard icon={<FileText size={22} />} title="Loan Applications" text="Capture, verify, and review incoming requests instantly." path="/loans" navigate={navigate} />
          <FeatureCard icon={<CheckCircle2 size={22} />} title="Smart Approvals" text="Route complex applications through custom multi-stage tracks." path="/loans" navigate={navigate} />
          <FeatureCard icon={<Wallet size={22} />} title="EMI Tracking" text="Monitor upcoming collections, reminders, and late balances." path="/deposits" navigate={navigate} />
          <FeatureCard icon={<Receipt size={22} />} title="Ledger & Trails" text="Maintain flawless transaction auditing with immutable logs." path="/payments" navigate={navigate} />
          <FeatureCard icon={<BarChart3 size={22} />} title="Analytics Suite" text="Generate performance metrics and portfolio snapshots on demand." path="/reports" navigate={navigate} />
          <FeatureCard icon={<Settings size={22} />} title="System Controls" text="Tailor permission structures and logic gates to fit your team." path="/members" navigate={navigate} />
        </div>
      </section>

      <section id="security" className="feature-section" style={{ background: '#f8fafc', paddingTop: '4rem', paddingBottom: '4rem' }}>
        <span className="section-eyebrow">Enterprise Security</span>
        <h2>Bank-grade protection out of the box</h2>
        <div className="feature-grid" style={{ marginTop: '3rem' }}>
          <FeatureCard icon={<ShieldCheck size={22} />} title="Stateless JWT" text="Industry-standard JSON Web Tokens for secure session management." path="#" navigate={() => {}} />
          <FeatureCard icon={<Lock size={22} />} title="BCrypt Hashing" text="Passwords are salted and cryptographically hashed with BCrypt." path="#" navigate={() => {}} />
          <FeatureCard icon={<User size={22} />} title="Strict RBAC" text="Role-Based Access Control restricts resources based on user roles." path="#" navigate={() => {}} />
          <FeatureCard icon={<FileText size={22} />} title="Audit Logging" text="Every critical action is logged for compliance and traceability." path="#" navigate={() => {}} />
          <FeatureCard icon={<CheckCircle2 size={22} />} title="Input Validation" text="XSS & SQLi protection with strict DTO validations." path="#" navigate={() => {}} />
          <FeatureCard icon={<Wallet size={22} />} title="Payment Security" text="Encrypted transaction logs and secure voucher postings." path="#" navigate={() => {}} />
        </div>
      </section>

      {/* Help Center Modal */}
      {showHelpModal && (
        <div className="modal-overlay" onClick={() => setShowHelpModal(false)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()} style={{ maxWidth: '600px', width: '90%', maxHeight: '80vh', overflowY: 'auto' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
              <h3 style={{ fontSize: '1.4rem', fontWeight: 800 }}>Help Center & FAQ</h3>
              <button onClick={() => setShowHelpModal(false)} style={{ background: 'none', border: 'none', fontSize: '1.5rem', cursor: 'pointer', color: '#64748b' }}>&times;</button>
            </div>
            
            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem', textAlign: 'left' }}>
              <div>
                <h4 style={{ fontWeight: 800, color: 'var(--primary)' }}>Login Guidance</h4>
                <p style={{ fontSize: '0.9rem', color: '#475569', marginTop: '0.5rem' }}>Enter your assigned username and password. Default accounts include 'admin', 'accountant', 'clerk', or member IDs.</p>
              </div>
              
              <div>
                <h4 style={{ fontWeight: 800, color: 'var(--primary)' }}>Password Rules</h4>
                <p style={{ fontSize: '0.9rem', color: '#475569', marginTop: '0.5rem' }}>Passwords must be at least 8 characters long and contain a mix of letters and numbers. If you forgot your password, please contact the System Administrator to request a reset link.</p>
              </div>

              <div>
                <h4 style={{ fontWeight: 800, color: 'var(--primary)' }}>Troubleshooting</h4>
                <p style={{ fontSize: '0.9rem', color: '#475569', marginTop: '0.5rem' }}>If you experience a "Session Expired" error, simply log out and log back in. Ensure your browser allows cookies and local storage for this domain.</p>
              </div>

              <div>
                <h4 style={{ fontWeight: 800, color: 'var(--primary)' }}>Browser Support</h4>
                <p style={{ fontSize: '0.9rem', color: '#475569', marginTop: '0.5rem' }}>LMS Enterprise is optimized for modern browsers: Chrome (v90+), Firefox (v88+), Safari (v14+), and Edge.</p>
              </div>

              <div style={{ borderTop: '1px solid #e2e8f0', paddingTop: '1rem', marginTop: '1rem' }}>
                <h4 style={{ fontWeight: 800, color: 'var(--primary)' }}>Contact Support</h4>
                <p style={{ fontSize: '0.9rem', color: '#475569', marginTop: '0.5rem' }}>Email: support@lmsenterprise.com<br/>Phone: 1-800-LMS-HELP (Available Mon-Fri, 9am-5pm EST)</p>
              </div>
            </div>
            
            <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '2rem' }}>
              <button className="btn-enterprise btn-secondary" onClick={() => setShowHelpModal(false)}>Close Help</button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}

function FeatureCard({ icon, title, text, path, navigate }) {
  const handleClick = () => {
    const token = localStorage.getItem("token");
    if (token) {
      navigate(path);
    } else {
      alert("Please sign in using the Login console above to access this module.");
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  };

  return (
    <article className="feature-box" onClick={handleClick} style={{ cursor: "pointer" }}>
      <div className="feature-icon-wrapper">{icon}</div>
      <h3>{title}</h3>
      <p>{text}</p>
    </article>
  );
}
