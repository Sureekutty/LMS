import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { ShieldAlert, RefreshCw, User, Search, Calendar, ArrowLeft } from "lucide-react";
import API from "../api/axios";
import "./Audits.css";

export default function Audits() {
  const navigate = useNavigate();
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [searchUser, setSearchUser] = useState("");
  const [searchKeyword, setSearchKeyword] = useState("");

  const fetchLogs = async () => {
    setLoading(true);
    try {
      const res = await API.get("/audit-logs");
      setLogs(res.data || []);
      setError("");
    } catch (err) {
      console.error("Error loading audit logs:", err);
      setError("Unauthorized or failed to load system audit trails.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLogs();
  }, []);

  const handleFilterSearch = async (e) => {
    e.preventDefault();
    if (!searchUser) {
      fetchLogs();
      return;
    }
    setLoading(true);
    try {
      const res = await API.get(`/audit-logs/user/${searchUser}`);
      setLogs(res.data || []);
      setError("");
    } catch (err) {
      setError("Failed to load audit logs for this user.");
    } finally {
      setLoading(false);
    }
  };

  // Client-side text keyword filtering
  const filteredLogs = logs.filter(l => {
    if (!searchKeyword) return true;
    const desc = l.description?.toLowerCase() || "";
    const event = l.action?.toLowerCase() || "";
    const ip = l.ipAddress?.toLowerCase() || "";
    const keyword = searchKeyword.toLowerCase();
    return desc.includes(keyword) || event.includes(keyword) || ip.includes(keyword);
  });

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header" style={{ marginBottom: '2rem' }}>
        <div className="page-title-group">
          <h1 className="gradient-heading">Security Audit Logs</h1>
          <p>Trace operational events, administrative logins, and data modifications</p>
        </div>
      </header>

      {/* Logs Table */}
      <section>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: '1.5rem', flexWrap: 'wrap', gap: '1rem' }}>
          <h2 style={{ fontSize: '1.35rem', fontWeight: 800, color: 'var(--text-primary)', margin: 0 }}>Auditing Trail Logs</h2>
          
          <div className="members-header-actions" style={{ margin: 0, padding: 0, border: 'none', background: 'transparent' }}>
            <form onSubmit={handleFilterSearch} className="search-bar-wrapper" style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
              <User size={18} color="#94a3b8" />
              <input 
                type="text" 
                placeholder="Filter by User..." 
                value={searchUser} 
                onChange={(e) => setSearchUser(e.target.value)} 
                style={{ border: 'none', outline: 'none', background: 'transparent', width: '130px', padding: 0 }}
              />
              <button type="submit" className="btn-enterprise btn-secondary" style={{ padding: '0.25rem 0.5rem', fontSize: '0.75rem', borderRadius: '4px' }}>Filter</button>
            </form>

            <div className="search-bar-wrapper">
              <Search size={18} color="#94a3b8" />
              <input 
                type="text" 
                placeholder="Search descriptions / actions / IPs..." 
                value={searchKeyword} 
                onChange={(e) => setSearchKeyword(e.target.value)}
              />
            </div>

            <div className="table-header-group">
              <button className="btn-enterprise btn-primary" onClick={fetchLogs}>
                <RefreshCw size={16} /> Refresh Trails
              </button>
            </div>
          </div>
        </div>

        {error ? (
          <div className="empty-state" style={{ color: 'var(--danger)', borderColor: '#fecaca', backgroundColor: '#fef2f2' }}>
            <ShieldAlert size={36} />
            <p style={{ marginTop: '1rem' }}>{error}</p>
          </div>
        ) : loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" />
            <p style={{ marginTop: '1rem' }}>Scanning audit records...</p>
          </div>
        ) : filteredLogs.length === 0 ? (
          <div className="empty-state">
            <ShieldAlert size={36} />
            <p style={{ marginTop: '1rem' }}>No audit trail logs match your query.</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Log ID</th>
                  <th>Timestamp</th>
                  <th>Operator</th>
                  <th>Event Action</th>
                  <th>Narrative Description</th>
                  <th>Access IP</th>
                </tr>
              </thead>
              <tbody>
                {filteredLogs.map(l => (
                  <tr key={l.id}>
                    <td><strong>#{l.id}</strong></td>
                    <td>{new Date(l.timestamp).toLocaleString("en-IN")}</td>
                    <td style={{ fontWeight: 700 }}>{l.username || "System"}</td>
                    <td>
                      <span className={`badge badge-${
                        l.action?.toLowerCase().includes('create') || l.action?.toLowerCase().includes('add') ? 'success' :
                        l.action?.toLowerCase().includes('delete') || l.action?.toLowerCase().includes('remove') ? 'danger' :
                        l.action?.toLowerCase().includes('update') || l.action?.toLowerCase().includes('edit') ? 'warning' : 'primary'
                      }`}>
                        {l.action}
                      </span>
                    </td>
                    <td>{l.description}</td>
                    <td><code style={{ background: '#f1f5f9', padding: '0.2rem 0.4rem', borderRadius: '4px', fontSize: '0.85rem' }}>{l.ipAddress || "N/A"}</code></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </main>
  );
}
