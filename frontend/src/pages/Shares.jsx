import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Landmark, PlusCircle, RefreshCw, ArrowLeft, Eye } from "lucide-react";
import API from "../api/axios";
import "./Shares.css";

const emptyForm = {
  memberId: "",
  shareCount: "",
  receiptNo: "",
  transactionDate: new Date().toISOString().split("T")[0],
  remarks: "",
};

export default function Shares() {
  const navigate = useNavigate();
  const [shares, setShares] = useState([]);
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedShare, setSelectedShare] = useState(null);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState(emptyForm);
  const [formLoading, setFormLoading] = useState(false);
  const [formSuccess, setFormSuccess] = useState("");

  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isClerk = roles.includes("ROLE_CLERK");
  const isAccountant = roles.includes("ROLE_ACCOUNTANT");
  const isMember = roles.includes("ROLE_MEMBER") || (!isAdmin && !isClerk && !isAccountant);

  const fetchInitialData = async () => {
    setLoading(true);
    setError("");
    try {
      if (isAdmin || isClerk || isAccountant) {
        const [sharesRes, membersRes] = await Promise.all([
          API.get("/shares"),
          API.get("/members"),
        ]);
        setShares(sharesRes.data);
        setMembers(membersRes.data);
      } else {
        const meRes = await API.get("/members/me");
        const member = meRes.data;
        if (member && member.id) {
          const sharesRes = await API.get(`/shares/member/${member.id}`);
          setShares(sharesRes.data || []);
          setMembers([member]);
        }
      }
    } catch (err) {
      setError("Failed to load share ledger accounts.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInitialData();
  }, []);

  const handleIssueShares = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    setFormSuccess("");
    setError("");

    try {
      const payload = {
        member: { id: form.memberId },
        shareCount: parseInt(form.shareCount, 10),
        receiptNo: form.receiptNo,
        transactionDate: form.transactionDate,
        remarks: form.remarks,
      };

      await API.post("/shares", payload);
      setFormSuccess("Shares issued successfully!");
      setForm(emptyForm);
      setShowForm(false);
      fetchInitialData();
    } catch (err) {
      setError(err.response?.data?.message || "Failed to issue shares.");
    } finally {
      setFormLoading(false);
    }
  };

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header" style={{ marginBottom: '2rem' }}>
        <div className="page-title-group">
          <h1 className="gradient-heading">{isMember ? "My Share Capital" : "Share Capital Ledger"}</h1>
          <p>{isMember ? "Track your share certificates and capital contributions" : "Issue society shares, manage share values, and track certificates"}</p>
        </div>
      </header>

      {/* Form Overlay Modal */}
      {showForm && (
        <div className="modal-overlay" onClick={() => setShowForm(false)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()}>
            <form onSubmit={handleIssueShares}>
              <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Issue Society Shares</h3>
              
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Select Member</span>
                  <select className="enterprise-select" value={form.memberId} onChange={(e) => setForm({ ...form, memberId: e.target.value })} required>
                    <option value="">-- Choose Member --</option>
                    {members.map(m => (
                      <option key={m.id} value={m.id}>{m.name} ({m.membershipNo})</option>
                    ))}
                  </select>
                </label>
                
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">No of Shares</span>
                  <input className="enterprise-input" type="number" value={form.shareCount} onChange={(e) => setForm({ ...form, shareCount: e.target.value })} required />
                </label>

                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Receipt Number</span>
                  <input className="enterprise-input" name="receiptNo" value={form.receiptNo} onChange={(e) => setForm({ ...form, receiptNo: e.target.value })} required />
                </label>
                
                <label className="enterprise-form-group" style={{ minWidth: 0 }}>
                  <span className="enterprise-label">Transaction Date</span>
                  <input className="enterprise-input" type="date" value={form.transactionDate} onChange={(e) => setForm({ ...form, transactionDate: e.target.value })} required />
                </label>
              </div>
              
              <label className="enterprise-form-group full-width" style={{ marginTop: '1.25rem', minWidth: 0 }}>
                <span className="enterprise-label">Remarks / Certificate Notes</span>
                <input className="enterprise-input" type="text" value={form.remarks} onChange={(e) => setForm({ ...form, remarks: e.target.value })} />
              </label>
              
              {formSuccess && <div className="alert alert-success mt-4">{formSuccess}</div>}
              {error && <div className="alert alert-danger mt-4">{error}</div>}
              
              <div className="form-actions" style={{ marginTop: '2rem' }}>
                <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowForm(false)}>Cancel</button>
                <button type="submit" disabled={formLoading} className="btn-enterprise btn-primary">
                  {formLoading ? "Saving..." : "Issue Shares"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Share List */}
      <section>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.35rem', fontWeight: 800, color: 'var(--text-primary)' }}>{isMember ? "My Share Transactions" : "Shares Log Book"}</h2>
          <div className="table-header-group">
            {(isAdmin || isClerk) && (
              <button className="btn-enterprise btn-primary" onClick={() => setShowForm(true)}>
                <PlusCircle size={16} /> Issue Shares
              </button>
            )}
          </div>
        </div>
        {loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" />
            <p style={{ marginTop: '1rem' }}>Fetching logs...</p>
          </div>
        ) : shares.length === 0 ? (
          <div className="empty-state">
            <Landmark size={36} />
            <p style={{ marginTop: '1rem' }}>No share transactions recorded.</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Txn Date</th>
                  <th>Member Name</th>
                  <th>Share Count</th>
                  <th>Total Amount</th>
                  <th>Receipt No</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {shares.map(s => (
                  <tr key={s.id}>
                    <td>{new Date(s.transactionDate).toLocaleDateString("en-IN")}</td>
                    <td>{s.member?.name || "N/A"}</td>
                    <td>{s.shareCount}</td>
                    <td>₹{s.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                    <td>{s.receiptNo || "-"}</td>
                    <td><span className="badge badge-success">{s.status}</span></td>
                    <td>
                      <button className="btn-enterprise btn-secondary" onClick={() => setSelectedShare(s)} title="Inspect Share Details" style={{ padding: '0.4rem 0.6rem' }}>
                        <Eye size={14} /> View
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>

      {/* Selected Share Details Inspector */}
      {selectedShare && (
        <div className="modal-overlay" onClick={() => setSelectedShare(null)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()} style={{ maxWidth: 640 }}>
            <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem' }}>Share Certificate Inspector</h3>
            <div className="details-grid" style={{ display: "grid", gridTemplateColumns: "1fr", gap: 12, margin: "20px 0", textAlign: "left", fontSize: "0.95rem" }}>
              <div><strong>Member Name:</strong> {selectedShare.member?.name} ({selectedShare.member?.membershipNo})</div>
              <div><strong>Staff Code:</strong> {selectedShare.member?.staffCode || "N/A"}</div>
              <div><strong>Shares Issued:</strong> {selectedShare.shareCount} Shares</div>
              <div><strong>Capital Amount Added:</strong> ₹{selectedShare.amount.toLocaleString("en-IN", { minimumFractionDigits: 2 })} (₹100 par value)</div>
              <div><strong>Receipt / Certificate No:</strong> {selectedShare.receiptNo || "N/A"}</div>
              <div><strong>Issue Date:</strong> {new Date(selectedShare.transactionDate).toLocaleDateString("en-IN")}</div>
              <div><strong>Certificate Status:</strong> <span className="badge badge-success" style={{ marginLeft: 8 }}>{selectedShare.status}</span></div>
              <div><strong>Remarks:</strong> {selectedShare.remarks || "None"}</div>
            </div>
            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem' }}>
              <button className="btn-enterprise btn-secondary" onClick={() => setSelectedShare(null)}>Close Inspector</button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}
