import React, { useState, useEffect, useRef } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { ArrowLeft, Save, UserCheck, Camera, Upload } from "lucide-react";
import API from "../api/axios";

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
  profileImageUrl: "",
};

export default function MemberForm() {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEditing = Boolean(id);

  const [form, setForm] = useState(emptyForm);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const fileInputRef = useRef(null);

  useEffect(() => {
    if (isEditing) {
      fetchMemberDetails();
    }
  }, [id]);

  const fetchMemberDetails = async () => {
    setLoading(true);
    try {
      const res = await API.get(`/members`);
      const member = res.data.find(m => m.id === parseInt(id));
      if (member) {
        setForm({
          membershipNo: member.membershipNo || "",
          name: member.name || "",
          designation: member.designation || "",
          fatherHusbandName: member.fatherHusbandName || "",
          staffCode: member.staffCode || "",
          sectionDivision: member.sectionDivision || "",
          age: member.age || "",
          dateOfBirth: member.dateOfBirth || "",
          dateOfJoining: member.dateOfJoining || "",
          bankAccountNo: member.bankAccountNo || "",
          residentialAddress: member.residentialAddress || "",
          basicPay: member.basicPay || "",
          shareCapital: member.shareCapital || "",
          thriftDeposit: member.thriftDeposit || "",
          phoneNo: member.phoneNo || "",
          nomineeName: member.nomineeName || "",
          nomineeDob: member.nomineeDob || "",
          nomineeRelationship: member.nomineeRelationship || "",
          nomineeGender: member.nomineeGender || "",
          nomineeAddress: member.nomineeAddress || "",
          profileImageUrl: member.profileImageUrl || "",
        });
      } else {
        setError("Member not found");
      }
    } catch (err) {
      setError("Failed to load member details.");
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setForm({ ...form, profileImageUrl: reader.result });
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError("");
    const payload = {
      ...form,
      age: form.age ? parseInt(form.age, 10) : null,
      basicPay: form.basicPay ? parseFloat(form.basicPay) : null,
      shareCapital: form.shareCapital ? parseFloat(form.shareCapital) : 0,
      thriftDeposit: form.thriftDeposit ? parseFloat(form.thriftDeposit) : 0,
    };
    try {
      if (isEditing) {
        await API.put(`/members/${id}`, payload);
      } else {
        await API.post("/members", payload);
      }
      navigate("/members");
    } catch (err) {
      setError(err.response?.data?.message || "Failed to save member.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-container" style={{ padding: '1rem', maxWidth: '1000px', margin: '0 auto' }}>
      
      {/* Separated Back Button */}
      <button 
        onClick={() => navigate("/members")} 
        style={{ background: 'transparent', border: 'none', color: 'var(--text-secondary)', padding: '0', display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '1.5rem', cursor: 'pointer', fontWeight: 700, fontSize: '0.9rem', transition: 'color 0.2s' }}
        onMouseOver={(e) => e.currentTarget.style.color = 'var(--primary)'}
        onMouseOut={(e) => e.currentTarget.style.color = 'var(--text-secondary)'}
      >
        <ArrowLeft size={18} /> Back to Directory
      </button>

      {/* Premium Title Box */}
      <div style={{ background: 'linear-gradient(135deg, #0f172a 0%, #1e293b 100%)', padding: '2rem 2.5rem', borderRadius: '16px', color: 'white', display: 'flex', justifyContent: 'space-between', alignItems: 'center', boxShadow: '0 10px 25px -5px rgba(15, 23, 42, 0.3)', marginBottom: '2rem' }}>
        <div>
          <h1 style={{ margin: 0, fontSize: '1.8rem', fontWeight: 800, color: 'white', letterSpacing: '-0.5px' }}>{isEditing ? "Edit Member Profile" : "Enroll New Member"}</h1>
          <p style={{ margin: '0.5rem 0 0 0', color: '#cbd5e1', fontSize: '1rem' }}>{isEditing ? `Updating comprehensive records for ${form.name || ''}` : "Register a new society member and set up their accounts"}</p>
        </div>
        <div style={{ background: 'rgba(255,255,255,0.05)', padding: '1.25rem', borderRadius: '50%', backdropFilter: 'blur(10px)', border: '1px solid rgba(255,255,255,0.1)' }}>
          <UserCheck size={36} color="#38bdf8" />
        </div>
      </div>

      {error && <div className="alert alert-danger" style={{ marginBottom: '1.5rem' }}>{error}</div>}

      <div className="glass-card">
        <form onSubmit={handleSubmit} className="member-form">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid #e2e8f0', paddingBottom: '1rem' }}>
            <h3 style={{ color: 'var(--primary)', display: 'flex', alignItems: 'center', gap: '8px', margin: 0 }}>
              <UserCheck size={20} /> Personal & Professional Details
            </h3>
            
            {/* Profile Photo Upload */}
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
              <div style={{ width: '60px', height: '60px', borderRadius: '50%', background: '#f1f5f9', border: '2px dashed #cbd5e1', display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden' }}>
                {form.profileImageUrl ? (
                  <img src={form.profileImageUrl} alt="Profile" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                ) : (
                  <Camera size={24} color="#94a3b8" />
                )}
              </div>
              <div>
                <button type="button" onClick={() => fileInputRef.current?.click()} className="btn-enterprise btn-secondary" style={{ padding: '0.4rem 0.8rem', fontSize: '0.85rem' }}>
                  <Upload size={14} style={{ marginRight: '6px' }} /> Upload Photo
                </button>
                <input type="file" accept="image/*" ref={fileInputRef} onChange={handleImageUpload} style={{ display: 'none' }} />
              </div>
            </div>
          </div>

          <div className="form-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem', marginBottom: '2rem' }}>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Membership No *</span>
              <input className="enterprise-input" name="membershipNo" value={form.membershipNo} onChange={handleChange} required disabled={isEditing} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Full Name *</span>
              <input className="enterprise-input" name="name" value={form.name} onChange={handleChange} required />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Designation</span>
              <input className="enterprise-input" name="designation" value={form.designation} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Father/Husband Name</span>
              <input className="enterprise-input" name="fatherHusbandName" value={form.fatherHusbandName} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Staff Code</span>
              <input className="enterprise-input" name="staffCode" value={form.staffCode} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Section/Division</span>
              <input className="enterprise-input" name="sectionDivision" value={form.sectionDivision} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Age</span>
              <input className="enterprise-input" type="number" name="age" value={form.age} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Date of Birth</span>
              <input className="enterprise-input" type="date" name="dateOfBirth" value={form.dateOfBirth} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Date of Joining</span>
              <input className="enterprise-input" type="date" name="dateOfJoining" value={form.dateOfJoining} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Bank Account No</span>
              <input className="enterprise-input" name="bankAccountNo" value={form.bankAccountNo} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Basic Pay (₹)</span>
              <input className="enterprise-input" type="number" step="0.01" name="basicPay" value={form.basicPay} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Share Capital (₹)</span>
              <input className="enterprise-input" type="number" step="0.01" name="shareCapital" value={form.shareCapital} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Thrift Deposit (₹)</span>
              <input className="enterprise-input" type="number" step="0.01" name="thriftDeposit" value={form.thriftDeposit} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Phone No</span>
              <input className="enterprise-input" name="phoneNo" value={form.phoneNo} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group" style={{ gridColumn: '1 / -1' }}>
              <span className="enterprise-label">Residential Address</span>
              <textarea className="enterprise-input" name="residentialAddress" value={form.residentialAddress} onChange={handleChange} rows="3" />
            </label>
          </div>

          <h3 style={{ marginBottom: '1.5rem', paddingBottom: '0.5rem', borderBottom: "1px solid #e2e8f0", color: 'var(--primary)' }}>Nominee Beneficiary Information</h3>
          <div className="form-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem', marginBottom: '2.5rem' }}>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Nominee Name</span>
              <input className="enterprise-input" name="nomineeName" value={form.nomineeName} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Nominee Date of Birth</span>
              <input className="enterprise-input" type="date" name="nomineeDob" value={form.nomineeDob} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Nominee Relationship</span>
              <input className="enterprise-input" name="nomineeRelationship" value={form.nomineeRelationship} onChange={handleChange} />
            </label>
            <label className="enterprise-form-group">
              <span className="enterprise-label">Nominee Gender</span>
              <select className="enterprise-select" name="nomineeGender" value={form.nomineeGender} onChange={handleChange}>
                <option value="">Select Gender</option>
                <option value="MALE">Male</option>
                <option value="FEMALE">Female</option>
              </select>
            </label>
            <label className="enterprise-form-group" style={{ gridColumn: '1 / -1' }}>
              <span className="enterprise-label">Nominee Address</span>
              <textarea className="enterprise-input" name="nomineeAddress" value={form.nomineeAddress} onChange={handleChange} rows="2" />
            </label>
          </div>
          
          <div className="form-actions" style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', borderTop: '1px solid #e2e8f0', paddingTop: '1.5rem' }}>
            <button type="button" className="btn-enterprise btn-secondary" onClick={() => navigate("/members")} style={{ padding: '0.75rem 1.5rem' }}>
              Cancel
            </button>
            <button type="submit" className="btn-enterprise btn-primary" disabled={loading} style={{ padding: '0.75rem 2rem', fontSize: '1.1rem' }}>
              <Save size={18} style={{ marginRight: '8px' }} /> {loading ? "Saving..." : (isEditing ? "Update Member" : "Enroll Member")}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
