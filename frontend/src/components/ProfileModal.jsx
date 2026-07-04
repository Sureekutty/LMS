import React, { useState, useEffect } from 'react';
import { X, User, Mail, Phone, Image as ImageIcon } from 'lucide-react';
import API from '../api/axios';
import './ProfileModal.css';

export default function ProfileModal({ isOpen, onClose }) {
  const [profile, setProfile] = useState({
    firstName: '',
    lastName: '',
    displayName: '',
    email: '',
    mobileNumber: '',
    profileImageUrl: ''
  });
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  
  useEffect(() => {
    if (isOpen) {
      loadProfile();
    }
  }, [isOpen]);

  const loadProfile = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await API.get('/users/me');
      setProfile({
        firstName: res.data.firstName || '',
        lastName: res.data.lastName || '',
        displayName: res.data.displayName || '',
        email: res.data.email || '',
        mobileNumber: res.data.mobileNumber || '',
        profileImageUrl: res.data.profileImageUrl || ''
      });
    } catch (err) {
      setError('Failed to load profile details.');
    } finally {
      setLoading(false);
    }
  };

  const handlePhotoUpload = async (e) => {
    const file = e.target.files[0];
    if (!file) return;
    
    const formData = new FormData();
    formData.append("file", file);
    
    setUploading(true);
    setError('');
    setSuccess('');
    try {
      const res = await API.post('/users/me/photo', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      setProfile({ ...profile, profileImageUrl: res.data.profileImageUrl });
      setSuccess('Profile photo updated successfully!');
      window.dispatchEvent(new CustomEvent('profile-updated', { detail: res.data }));
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to upload photo.');
    } finally {
      setUploading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setError('');
    setSuccess('');
    try {
      const res = await API.put('/users/me', profile);
      setSuccess('Profile updated successfully!');
      
      // Update local storage if username/display name affects layout
      // Although we use localStorage "username" which is actual username, 
      // some apps might want to store display name. We'll leave it simple for now.
      
      setTimeout(() => {
        onClose();
        window.dispatchEvent(new CustomEvent('profile-updated', { detail: res.data }));
      }, 1500);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to update profile.');
    } finally {
      setSaving(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-box small-modal profile-modal glass-card" onClick={e => e.stopPropagation()}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
          <h3 style={{ fontSize: '1.4rem', fontWeight: 800 }}>Edit Profile</h3>
          <button className="icon-btn" onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer' }}>
            <X size={20} color="#64748b" />
          </button>
        </div>

        {loading ? (
          <div style={{ textAlign: 'center', padding: '2rem 0', color: '#64748b' }}>Loading profile...</div>
        ) : (
          <form onSubmit={handleSubmit}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginBottom: '1.5rem', paddingBottom: '1.5rem', borderBottom: '1px solid #e2e8f0' }}>
              <div style={{ width: '64px', height: '64px', borderRadius: '50%', background: profile.profileImageUrl ? `url(${profile.profileImageUrl}) center/cover` : 'linear-gradient(135deg, #0ea5e9, #3b82f6)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'white', fontSize: '1.5rem', fontWeight: 800 }}>
                {!profile.profileImageUrl && (profile.firstName ? profile.firstName.charAt(0) : 'U')}
              </div>
              <div style={{ flex: 1 }}>
                <div className="enterprise-form-group" style={{ marginBottom: 0 }}>
                  <span className="enterprise-label" style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><ImageIcon size={14} /> Upload Profile Picture</span>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginTop: '0.5rem' }}>
                    <label style={{ cursor: 'pointer', background: 'var(--primary)', color: 'white', padding: '0.4rem 1rem', borderRadius: '8px', fontSize: '0.8rem', fontWeight: 600, transition: 'all 0.2s' }}>
                      Choose Image
                      <input type="file" accept="image/*" onChange={handlePhotoUpload} style={{ display: 'none' }} />
                    </label>
                    {uploading && <span style={{ fontSize: '0.8rem', color: 'var(--primary)' }}>Uploading...</span>}
                  </div>
                </div>
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1rem' }}>
              <label className="enterprise-form-group">
                <span className="enterprise-label">First Name</span>
                <input type="text" className="enterprise-input" value={profile.firstName} onChange={e => setProfile({...profile, firstName: e.target.value})} />
              </label>
              <label className="enterprise-form-group">
                <span className="enterprise-label">Last Name</span>
                <input type="text" className="enterprise-input" value={profile.lastName} onChange={e => setProfile({...profile, lastName: e.target.value})} />
              </label>
            </div>

            <label className="enterprise-form-group" style={{ marginBottom: '1rem' }}>
              <span className="enterprise-label">Display Name (User ID mapping)</span>
              <input type="text" className="enterprise-input" value={profile.displayName} onChange={e => setProfile({...profile, displayName: e.target.value})} />
            </label>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.5rem' }}>
              <label className="enterprise-form-group">
                <span className="enterprise-label" style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><Mail size={14} /> Email ID</span>
                <input type="email" className="enterprise-input" value={profile.email} onChange={e => setProfile({...profile, email: e.target.value})} />
              </label>
              <label className="enterprise-form-group">
                <span className="enterprise-label" style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><Phone size={14} /> Mobile Number</span>
                <input type="text" className="enterprise-input" value={profile.mobileNumber} onChange={e => setProfile({...profile, mobileNumber: e.target.value})} />
              </label>
            </div>

            {error && <div className="alert alert-danger" style={{ marginBottom: '1rem' }}>{error}</div>}
            {success && <div className="alert alert-success" style={{ marginBottom: '1rem' }}>{success}</div>}

            <div className="form-actions" style={{ marginTop: '1rem' }}>
              <button type="button" className="btn-enterprise btn-secondary" onClick={onClose}>Cancel</button>
              <button type="submit" className="btn-enterprise btn-primary" disabled={saving}>
                {saving ? "Saving..." : "Save Profile"}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}
