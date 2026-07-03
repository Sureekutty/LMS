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
        <div className="logo">
          <div className="logo-box">
            <Landmark size={20} />
          </div>
          <span>LMS</span>
        </div>
        <div className="nav-links">
          <a href="#modules">Modules</a>
          <a href="#features">Features</a>
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
            <div className="marquee-wrapper">
              <marquee className="lms-marquee" behavior="scroll" direction="left">
                Welcome to LMS • Manage your credits easily
              </marquee>
            </div>
            
            <div className="login-header-row">
              <span className="login-eyebrow">
                <ShieldCheck size={13} />
                Secure Gateway
              </span>
              <a 
                href="/assets/user_guide.pdf" 
                target="_blank" 
                rel="noreferrer" 
                className="guide-help-link"
                title="Open Guide Document"
              >
                <HelpCircle size={18} />
              </a>
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
          <FeatureCard icon={<FileText size={22} />} title="Loan Applications" text="Capture, verify, and review incoming requests instantly." />
          <FeatureCard icon={<CheckCircle2 size={22} />} title="Smart Approvals" text="Route complex applications through custom multi-stage tracks." />
          <FeatureCard icon={<Wallet size={22} />} title="EMI Tracking" text="Monitor upcoming collections, reminders, and late balances." />
          <FeatureCard icon={<Receipt size={22} />} title="Ledger & Trails" text="Maintain flawless transaction auditing with immutable logs." />
          <FeatureCard icon={<BarChart3 size={22} />} title="Analytics Suite" text="Generate performance metrics and portfolio snapshots on demand." />
          <FeatureCard icon={<Settings size={22} />} title="System Controls" text="Tailor permission structures and logic gates to fit your team." />
        </div>
      </section>
    </main>
  );
}

function FeatureCard({ icon, title, text }) {
  return (
    <article className="feature-box">
      <div className="feature-icon-wrapper">{icon}</div>
      <h3>{title}</h3>
      <p>{text}</p>
    </article>
  );
}