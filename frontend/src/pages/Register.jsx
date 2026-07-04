import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Landmark, ArrowRight, User, Lock, Mail, ShieldAlert } from "lucide-react";
import api from "../api/axios";
import "./Register.css";

export default function Register() {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [adminPassword, setAdminPassword] = useState("");
  const [isAdminRegistration, setIsAdminRegistration] = useState(false);
  
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleRegister = async (e) => {
    e.preventDefault();
    setError("");
    setSuccess("");

    if (password !== confirmPassword) {
      setError("Passwords do not match!");
      return;
    }

    setLoading(true);
    try {
      const payload = {
        username,
        email,
        firstName,
        lastName,
        displayName,
        password,
        roles: isAdminRegistration ? ["ADMIN"] : ["MEMBER"],
        adminPassword: isAdminRegistration ? adminPassword : null
      };

      await api.post("/auth/register", payload);
      setSuccess("Account registered successfully! Redirecting to login...");
      setTimeout(() => {
        navigate("/login");
      }, 2500);
    } catch (err) {
      setError(err.response?.data?.message || "Registration failed. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="register-page">
      <div className="blur-blob blob-1" aria-hidden="true" />
      <div className="blur-blob blob-2" aria-hidden="true" />

      <nav className="navbar">
        <div className="logo">
          <div className="logo-box">
            <Landmark size={20} />
          </div>
          <span>LMS</span>
        </div>
      </nav>

      <div className="register-container">
        <div className="register-card">
          <h2>Create Account</h2>
          <p>Register as a member of the society</p>

          <form onSubmit={handleRegister} className="register-form">
            <div className="input-row">
              <label className="input-group">
                <input
                  type="text"
                  placeholder="First Name"
                  value={firstName}
                  onChange={(e) => setFirstName(e.target.value)}
                  required
                />
              </label>

              <label className="input-group">
                <input
                  type="text"
                  placeholder="Last Name"
                  value={lastName}
                  onChange={(e) => setLastName(e.target.value)}
                  required
                />
              </label>
            </div>

            <label className="input-group">
              <input
                type="text"
                placeholder="Display Name"
                value={displayName}
                onChange={(e) => setDisplayName(e.target.value)}
              />
            </label>

            <label className="input-group">
              <Mail size={18} className="input-icon" />
              <input
                type="email"
                placeholder="Email (UserId must match this)"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  setUsername(e.target.value); // Login ID automatically matches Email
                }}
                required
              />
            </label>

            <div className="input-row">
              <label className="input-group">
                <Lock size={18} className="input-icon" />
                <input
                  type="password"
                  placeholder="New Password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </label>

              <label className="input-group">
                <Lock size={18} className="input-icon" />
                <input
                  type="password"
                  placeholder="Confirm Password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                />
              </label>
            </div>

            <div className="admin-toggle-wrapper">
              <label className="checkbox-label">
                <input
                  type="checkbox"
                  checked={isAdminRegistration}
                  onChange={(e) => setIsAdminRegistration(e.target.checked)}
                />
                <span>Register as Administrator / Staff</span>
              </label>
            </div>

            {isAdminRegistration && (
              <label className="input-group admin-password-group">
                <ShieldAlert size={18} className="input-icon" />
                <input
                  type="password"
                  placeholder="Enter Master Admin Password"
                  value={adminPassword}
                  onChange={(e) => setAdminPassword(e.target.value)}
                  required
                />
              </label>
            )}

            {error && <div className="form-error">{error}</div>}
            {success && <div className="form-success">{success}</div>}

            <button type="submit" disabled={loading} className="register-btn">
              {loading ? (
                <span className="btn-spinner" />
              ) : (
                <>
                  Register Account <ArrowRight size={18} />
                </>
              )}
            </button>
          </form>

          <div className="card-footer">
            Already have an account? <Link to="/login">Sign In</Link>
          </div>
        </div>
      </div>
    </main>
  );
}
