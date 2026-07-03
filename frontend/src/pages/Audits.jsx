import { useEffect, useState } from "react";
import { ShieldAlert, RefreshCw, User, Search, Calendar } from "lucide-react";
import API from "../api/axios";
import "./Audits.css";

export default function Audits() {
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
    <main className="audits-page">
      <header className="page-header">
        <div>
          <h1>Security Audit Logs</h1>
          <p>Trace operational events, administrative logins, and data modifications</p>
        </div>
        <button className="open-form-btn" onClick={fetchLogs}>
          <RefreshCw size={18} />
          Refresh Trails
        </button>
      </header>

      {/* Filter Toolbar */}
      <section className="filter-toolbar">
        <form onSubmit={handleFilterSearch} className="filter-form">
          <label className="filter-input-group">
            <User size={18} />
            <input 
              type="text" 
              placeholder="Filter by Username..." 
              value={searchUser} 
              onChange={(e) => setSearchUser(e.target.value)} 
            />
          </label>
          <button type="submit" className="filter-submit-btn">Filter User</button>
        </form>

        <div className="filter-input-group keyword-search">
          <Search size={18} />
          <input 
            type="text" 
            placeholder="Search descriptions / actions / IPs..." 
            value={searchKeyword} 
            onChange={(e) => setSearchKeyword(e.target.value)} 
          />
        </div>
      </section>

      {/* Logs Table */}
      <section className="deposits-list">
        <h2>Auditing Trail Logs</h2>
        {error ? (
          <div className="empty-state error-box">
            <ShieldAlert size={36} />
            <p>{error}</p>
          </div>
        ) : loading ? (
          <div className="loading-state">
            <RefreshCw size={28} className="spin-icon" />
            <p>Scanning audit records...</p>
          </div>
        ) : filteredLogs.length === 0 ? (
          <div className="empty-state">
            <ShieldAlert size={36} />
            <p>No audit trail logs match your query.</p>
          </div>
        ) : (
          <div className="table-wrap">
            <table className="deposits-table">
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
                    <td>#{l.id}</td>
                    <td>{new Date(l.timestamp).toLocaleString("en-IN")}</td>
                    <td style={{ fontWeight: 700 }}>{l.username || "System"}</td>
                    <td>
                      <span className={`event-badge ${l.action?.toLowerCase()}`}>
                        {l.action}
                      </span>
                    </td>
                    <td>{l.description}</td>
                    <td><code>{l.ipAddress || "N/A"}</code></td>
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
