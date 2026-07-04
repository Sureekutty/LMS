import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { CheckCircle2, ListPlus, ArrowLeft, RefreshCw, BarChart3, AlertCircle } from "lucide-react";
import API from "../api/axios";
import "./Polls.css";

export default function Polls() {
  const navigate = useNavigate();
  const [polls, setPolls] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  
  const [formTitle, setFormTitle] = useState("");
  const [formDesc, setFormDesc] = useState("");
  const [formOptions, setFormOptions] = useState(["", ""]);
  
  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdmin = roles.includes("ROLE_ADMIN");
  const isClerk = roles.includes("ROLE_CLERK");

  const fetchPolls = async () => {
    setLoading(true);
    try {
      const res = await API.get("/polls");
      setPolls(res.data || []);
      setError("");
    } catch (err) {
      console.error(err);
      setError("Failed to load polls.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPolls();
  }, []);

  const handleAddOption = () => {
    setFormOptions([...formOptions, ""]);
  };

  const handleOptionChange = (index, value) => {
    const newOptions = [...formOptions];
    newOptions[index] = value;
    setFormOptions(newOptions);
  };

  const handleCreatePoll = async (e) => {
    e.preventDefault();
    try {
      const filteredOptions = formOptions.filter(o => o.trim() !== "");
      if (filteredOptions.length < 2) {
        alert("Please provide at least two options.");
        return;
      }
      const payload = {
        title: formTitle,
        description: formDesc,
        options: filteredOptions
      };
      await API.post("/polls", payload);
      setShowForm(false);
      setFormTitle("");
      setFormDesc("");
      setFormOptions(["", ""]);
      fetchPolls();
    } catch (err) {
      alert("Failed to create poll: " + (err.response?.data?.message || err.message));
    }
  };

  const handleVote = async (pollId, optionId) => {
    try {
      await API.post(`/polls/${pollId}/vote/${optionId}`);
      fetchPolls();
    } catch (err) {
      alert("Failed to cast vote: " + (err.response?.data || err.message));
    }
  };

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      <header className="page-header" style={{ marginBottom: '2rem' }}>
        <div className="page-title-group">
          <h1 className="gradient-heading">Society Polls</h1>
          <p>Vote on important society decisions and elections</p>
        </div>
      </header>

      {showForm && (
        <div className="modal-overlay" onClick={() => setShowForm(false)}>
          <div className="modal-box glass-card" onClick={(e) => e.stopPropagation()}>
            <form onSubmit={handleCreatePoll}>
              <h3 style={{ fontSize: '1.4rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Create New Poll</h3>
              
              <label className="enterprise-form-group full-width">
                <span className="enterprise-label">Poll Title</span>
                <input className="enterprise-input" value={formTitle} onChange={e => setFormTitle(e.target.value)} required />
              </label>

              <label className="enterprise-form-group full-width">
                <span className="enterprise-label">Description (Optional)</span>
                <textarea className="enterprise-input" rows="3" value={formDesc} onChange={e => setFormDesc(e.target.value)} />
              </label>

              <div style={{ marginTop: '1.5rem', marginBottom: '1rem' }}>
                <span className="enterprise-label" style={{ display: 'block', marginBottom: '0.5rem' }}>Poll Options</span>
                {formOptions.map((opt, i) => (
                  <div key={i} style={{ display: 'flex', gap: '0.5rem', marginBottom: '0.5rem' }}>
                    <input 
                      className="enterprise-input" 
                      placeholder={`Option ${i + 1}`}
                      value={opt} 
                      onChange={e => handleOptionChange(i, e.target.value)} 
                      style={{ margin: 0 }}
                    />
                  </div>
                ))}
                <button type="button" className="btn-enterprise btn-secondary" onClick={handleAddOption} style={{ marginTop: '0.5rem', padding: '0.4rem 0.8rem', fontSize: '0.8rem' }}>
                  + Add Option
                </button>
              </div>

              <div className="form-actions" style={{ marginTop: '2rem' }}>
                <button type="button" className="btn-enterprise btn-secondary" onClick={() => setShowForm(false)}>Cancel</button>
                <button type="submit" className="btn-enterprise btn-primary">Publish Poll</button>
              </div>
            </form>
          </div>
        </div>
      )}

      <section>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.35rem', fontWeight: 800, color: 'var(--text-primary)' }}>Active Polls</h2>
          <div className="table-header-group">
            {(isAdmin || isClerk) && (
              <button className="btn-enterprise btn-primary" onClick={() => setShowForm(true)}>
                <ListPlus size={16} /> Create Poll
              </button>
            )}
          </div>
        </div>
        {loading ? (
          <div className="empty-state">
            <RefreshCw size={28} className="spin-icon" />
            <p style={{ marginTop: '1rem' }}>Loading active polls...</p>
          </div>
        ) : error ? (
          <div className="empty-state" style={{ color: 'var(--danger)', backgroundColor: '#fef2f2', borderColor: '#fecaca' }}>
            <AlertCircle size={36} />
            <p style={{ marginTop: '1rem' }}>{error}</p>
          </div>
        ) : polls.length === 0 ? (
          <div className="empty-state">
            <BarChart3 size={36} />
            <p style={{ marginTop: '1rem' }}>No active polls found.</p>
          </div>
        ) : (
          <div className="polls-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(350px, 1fr))', gap: '1.5rem' }}>
            {polls.map(poll => {
              const totalVotes = poll.options.reduce((sum, opt) => sum + opt.votesCount, 0);
              return (
                <div key={poll.id} className="glass-card poll-card" style={{ padding: '1.5rem', display: 'flex', flexDirection: 'column' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '1rem' }}>
                    <h3 style={{ fontSize: '1.2rem', fontWeight: 800, color: 'var(--text-primary)' }}>{poll.title}</h3>
                    {poll.active ? (
                      <span className="badge badge-success">Active</span>
                    ) : (
                      <span className="badge badge-danger">Closed</span>
                    )}
                  </div>
                  {poll.description && (
                    <p style={{ fontSize: '0.9rem', color: 'var(--text-secondary)', marginBottom: '1.5rem' }}>{poll.description}</p>
                  )}
                  
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem', flex: 1 }}>
                    {poll.options.map(opt => {
                      const percentage = totalVotes === 0 ? 0 : Math.round((opt.votesCount / totalVotes) * 100);
                      return (
                        <div key={opt.id} className="poll-option-row" style={{ position: 'relative' }}>
                          <button 
                            className={`poll-option-btn ${poll.hasVoted || !poll.active ? 'disabled' : ''}`}
                            onClick={() => !poll.hasVoted && poll.active && handleVote(poll.id, opt.id)}
                            disabled={poll.hasVoted || !poll.active}
                            style={{ 
                              width: '100%', 
                              padding: '1rem', 
                              textAlign: 'left', 
                              border: '1px solid var(--border-color)', 
                              borderRadius: '8px', 
                              background: 'transparent',
                              cursor: poll.hasVoted || !poll.active ? 'default' : 'pointer',
                              position: 'relative',
                              overflow: 'hidden',
                              display: 'flex',
                              justifyContent: 'space-between',
                              alignItems: 'center'
                            }}
                          >
                            <span style={{ position: 'relative', zIndex: 2, fontWeight: 600, color: 'var(--text-primary)' }}>{opt.optionText}</span>
                            {(poll.hasVoted || !poll.active) && (
                              <span style={{ position: 'relative', zIndex: 2, fontSize: '0.85rem', fontWeight: 700, color: 'var(--text-secondary)' }}>
                                {percentage}% ({opt.votesCount})
                              </span>
                            )}
                            
                            {(poll.hasVoted || !poll.active) && (
                              <div 
                                style={{ 
                                  position: 'absolute', 
                                  top: 0, 
                                  left: 0, 
                                  height: '100%', 
                                  width: `${percentage}%`, 
                                  background: 'rgba(14, 165, 233, 0.1)', 
                                  zIndex: 1,
                                  transition: 'width 0.5s ease-out'
                                }} 
                              />
                            )}
                          </button>
                        </div>
                      );
                    })}
                  </div>
                  
                  <div style={{ marginTop: '1.5rem', paddingTop: '1rem', borderTop: '1px solid var(--border-color)', fontSize: '0.85rem', color: 'var(--text-secondary)', display: 'flex', justifyContent: 'space-between' }}>
                    <span>Total Votes: <strong>{totalVotes}</strong></span>
                    {poll.hasVoted && <span style={{ color: 'var(--primary)', fontWeight: 700, display: 'flex', alignItems: 'center', gap: '4px' }}><CheckCircle2 size={14} /> You voted</span>}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </section>
    </main>
  );
}
