import { useEffect, useState, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { Eye, Plus, Search, X, Download, FileSpreadsheet, ChevronRight, User, RefreshCw } from "lucide-react";
import API from "../api/axios";
import "./Members.css";

const emptyForm = {
  membershipNo: "",
  name: "",
  designation: "",
  fatherHusbandName: "",
  staffCode: "",
  sectionDivision: "",
  age: "",
  dateOfBirth: "",
  dateOfJoining: "",
  bankAccountNo: "",
  residentialAddress: "",
  basicPay: "",
  shareCapital: "",
  thriftDeposit: "",
  phoneNo: "",
  nomineeName: "",
  nomineeDob: "",
  nomineeRelationship: "",
  nomineeGender: "",
  nomineeAddress: "",
};

function Members() {
  const navigate = useNavigate();
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [selectedMember, setSelectedMember] = useState(null);
  const [searchQuery, setSearchQuery] = useState("");

  const roles = JSON.parse(localStorage.getItem("roles") || "[]");
  const isAdminOrClerk = roles.some(r => ["ROLE_ADMIN", "ROLE_CLERK"].includes(r));

  const fetchMembers = async () => {
    setLoading(true);
    try {
      const res = await API.get("/members");
      setMembers(res.data);
      setError("");
    } catch (err) {
      setError("Failed to load members. Check login/permissions.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMembers();
  }, [navigate]);

  const openAddForm = () => {
    navigate("/members/new");
  };

  const openEditForm = (member) => {
    navigate(`/members/${member.id}/edit`);
  };

  const downloadPdf = async (id, membershipNo) => {
    try {
      const response = await API.get(`/members/${id}/statement/pdf`, {
        responseType: 'blob'
      });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `statement_${membershipNo}.pdf`);
      document.body.appendChild(link);
      link.click();
      link.remove();
    } catch (err) {
      alert("Failed to download member statement PDF.");
    }
  };

  const handleDeactivate = async (id) => {
    if (!window.confirm("Deactivate this member?")) return;
    try {
      await API.put(`/members/${id}/deactivate`);
      fetchMembers();
    } catch (err) {
      alert(err.response?.data?.message || "Failed to deactivate member.");
    }
  };

  const filteredMembers = useMemo(() => {
    return members.filter(m => 
      m.name?.toLowerCase().includes(searchQuery.toLowerCase()) || 
      m.membershipNo?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      m.designation?.toLowerCase().includes(searchQuery.toLowerCase())
    );
  }, [members, searchQuery]);

  return (
    <div className="page-container animate__animated animate__fadeIn members-container">
      <div className="page-header" style={{ marginBottom: '2rem' }}>
        <div className="page-title-group">
          <span style={{ fontSize: '0.85rem', color: '#64748b', fontWeight: 700, display: 'block', marginBottom: '6px', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
            User Management
          </span>
          <h1 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>Member Directory</h1>
        </div>
        {isAdminOrClerk && (
          <button className="btn-enterprise btn-primary" onClick={openAddForm}>
            <Plus size={18} /> Enroll New Member
          </button>
        )}
      </div>

      <div className="members-header-actions">
        <div className="search-bar-wrapper">
          <Search size={18} color="#94a3b8" />
          <input 
            type="text" 
            placeholder="Search by name, ID, or staff code..." 
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        
        <div className="table-header-group">
          <button className="btn-enterprise btn-secondary" onClick={() => alert("Exporting to Excel...")}>
            <FileSpreadsheet size={16} /> Export CSV
          </button>
        </div>
      </div>

      {error && <div className="members-error">{error}</div>}

      <div className="dashboard-card" style={{ padding: '0', overflow: 'hidden' }}>
        {loading ? (
          <div className="empty-state">
            <div className="spin-icon"><RefreshCw size={32} color="var(--primary)" /></div>
            <p style={{ marginTop: '1rem', color: '#64748b' }}>Loading member directory...</p>
          </div>
        ) : (
          <div className="table-wrapper">
            <table className="enterprise-table">
              <thead>
                <tr>
                  <th>Member Name</th>
                  <th>Membership No</th>
                  <th>Designation</th>
                  <th>Staff Code</th>
                  <th>Contact</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredMembers.length === 0 ? (
                  <tr>
                    <td colSpan="7" className="empty-state">
                      No members found matching your search.
                    </td>
                  </tr>
                ) : (
                  filteredMembers.map((m) => (
                    <tr key={m.id} className="interactive-row">
                      <td style={{ fontWeight: 600, color: 'var(--text-primary)' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                          <div style={{ width: '32px', height: '32px', borderRadius: '50%', background: 'linear-gradient(135deg, #0ea5e9, #3b82f6)', color: 'white', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '0.85rem' }}>
                            {m.name ? m.name.charAt(0).toUpperCase() : 'M'}
                          </div>
                          <div style={{ display: 'flex', flexDirection: 'column' }}>
                            <span>{m.name}</span>
                            {(m.staffCode || m.designation?.toLowerCase().includes("staff") || m.designation?.toLowerCase().includes("admin")) && (
                              <span style={{ fontSize: '0.7rem', background: '#fef08a', color: '#854d0e', padding: '2px 6px', borderRadius: '4px', width: 'fit-content', marginTop: '2px', fontWeight: 700 }}>
                                STAFF
                              </span>
                            )}
                          </div>
                        </div>
                      </td>
                      <td>{m.membershipNo}</td>
                      <td>{m.designation || '-'}</td>
                      <td>{m.staffCode || '-'}</td>
                      <td>{m.phoneNo || '-'}</td>
                      <td>
                        <span className={`badge ${m.isActive ? "badge-success" : "badge-danger"}`}>
                          {m.isActive ? "Active" : "Inactive"}
                        </span>
                      </td>
                      <td>
                        <div style={{ display: "flex", gap: "0.5rem" }}>
                          <button className="action-icon-btn btn-view" title="View Profile" onClick={() => setSelectedMember(m)}>
                            <Eye size={18} />
                          </button>
                          {isAdminOrClerk && (
                            <button className="action-icon-btn btn-edit" title="Edit Member" onClick={() => openEditForm(m)}>
                              <ChevronRight size={18} />
                            </button>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
            
            <div style={{ padding: '1rem 1.5rem', borderTop: '1px solid #f1f5f9', display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: '0.8rem', color: '#64748b', fontWeight: 600 }}>
              <span>Showing {filteredMembers.length} members</span>
            </div>
          </div>
        )}
      </div>

      {/* Member Profile Slide-out Panel */}
      {selectedMember && (
        <>
          <div className="slide-panel-overlay" onClick={() => setSelectedMember(null)}></div>
          <div className="slide-panel">
            <button className="slide-panel-close" onClick={() => setSelectedMember(null)}>
              <X size={20} />
            </button>
            
            <div className="profile-avatar">
              {selectedMember.name.charAt(0).toUpperCase()}
            </div>
            
            <h2 style={{ fontSize: '1.6rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '4px' }}>
              {selectedMember.name}
            </h2>
            <p style={{ color: 'var(--primary)', fontWeight: 700, fontSize: '0.9rem', marginBottom: '1.5rem' }}>
              {selectedMember.designation || 'Member'} • #{selectedMember.membershipNo}
            </p>

            <div className="profile-stat-grid">
              <div className="profile-stat-box">
                <span>Share Capital</span>
                <strong>₹{selectedMember.shareCapital?.toLocaleString('en-IN', { minimumFractionDigits: 2 }) || '0.00'}</strong>
              </div>
              <div className="profile-stat-box">
                <span>Thrift Deposit</span>
                <strong>₹{selectedMember.thriftDeposit?.toLocaleString('en-IN', { minimumFractionDigits: 2 }) || '0.00'}</strong>
              </div>
            </div>

            <div className="profile-section-title">Personal Information</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.8rem', fontSize: '0.9rem', color: '#475569' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Staff Code</strong>
                <span>{selectedMember.staffCode || "N/A"}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Father/Husband</strong>
                <span>{selectedMember.fatherHusbandName || "N/A"}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Phone Number</strong>
                <span>{selectedMember.phoneNo || "N/A"}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Date of Birth</strong>
                <span>{selectedMember.dateOfBirth || "N/A"}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Bank Account</strong>
                <span>{selectedMember.bankAccountNo || "N/A"}</span>
              </div>
            </div>

            <div className="profile-section-title">Nominee Details</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.8rem', fontSize: '0.9rem', color: '#475569' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Name</strong>
                <span>{selectedMember.nomineeName || "N/A"}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong style={{ color: '#0f172a' }}>Relationship</strong>
                <span>{selectedMember.nomineeRelationship || "N/A"}</span>
              </div>
            </div>

            <div style={{ marginTop: '3rem', display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              <button className="btn-enterprise btn-primary" style={{ width: '100%', justifyContent: 'center' }} onClick={() => downloadPdf(selectedMember.id, selectedMember.membershipNo)}>
                <Download size={16} /> Download Full Statement
              </button>
              <div style={{ display: 'flex', gap: '1rem' }}>
                <button className="btn-enterprise btn-secondary" style={{ flex: 1, justifyContent: 'center' }} onClick={() => { setSelectedMember(null); openEditForm(selectedMember); }}>
                  Edit Profile
                </button>
                {selectedMember.isActive && (
                  <button className="btn-enterprise btn-danger" style={{ flex: 1, justifyContent: 'center' }} onClick={() => { handleDeactivate(selectedMember.id); setSelectedMember(null); }}>
                    Deactivate
                  </button>
                )}
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}

export default Members;
