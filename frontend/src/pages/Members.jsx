import { useEffect, useState } from "react";
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
};

function Members() {
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [form, setForm] = useState(emptyForm);

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
  }, []);

  const openAddForm = () => {
    setForm(emptyForm);
    setEditingId(null);
    setShowForm(true);
  };

  const openEditForm = (member) => {
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
    });
    setEditingId(member.id);
    setShowForm(true);
  };

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const payload = {
      ...form,
      age: form.age ? parseInt(form.age, 10) : null,
      basicPay: form.basicPay ? parseFloat(form.basicPay) : null,
      shareCapital: form.shareCapital ? parseFloat(form.shareCapital) : 0,
      thriftDeposit: form.thriftDeposit ? parseFloat(form.thriftDeposit) : 0,
    };
    try {
      if (editingId) {
        await API.put(`/members/${editingId}`, payload);
      } else {
        await API.post("/members", payload);
      }
      setShowForm(false);
      fetchMembers();
    } catch (err) {
      alert(err.response?.data?.message || "Failed to save member.");
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

  return (
    <div className="members-page">
      <div className="members-header">
        <h1>Members</h1>
        <button className="btn-primary" onClick={openAddForm}>
          + Add Member
        </button>
      </div>

      {error && <div className="members-error">{error}</div>}

      {loading ? (
        <p>Loading members...</p>
      ) : (
        <div className="members-table-wrap">
          <table className="members-table">
            <thead>
              <tr>
                <th>Membership No</th>
                <th>Name</th>
                <th>Designation</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {members.length === 0 ? (
                <tr>
                  <td colSpan="6" className="empty-row">
                    No members found.
                  </td>
                </tr>
              ) : (
                members.map((m) => (
                  <tr key={m.id}>
                    <td>{m.membershipNo}</td>
                    <td>{m.name}</td>
                    <td>{m.designation}</td>
                    <td>{m.phoneNo}</td>
                    <td>
                      <span className={m.isActive ? "badge-active" : "badge-inactive"}>
                        {m.isActive ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td>
                      <button className="btn-link" onClick={() => openEditForm(m)}>
                        Edit
                      </button>
                      {m.isActive && (
                        <button
                          className="btn-link danger"
                          onClick={() => handleDeactivate(m.id)}
                        >
                          Deactivate
                        </button>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      )}

      {showForm && (
        <div className="modal-overlay" onClick={() => setShowForm(false)}>
          <div className="modal-box" onClick={(e) => e.stopPropagation()}>
            <h2>{editingId ? "Edit Member" : "Add Member"}</h2>
            <form onSubmit={handleSubmit} className="member-form">
              <div className="form-grid">
                <label>
                  Membership No *
                  <input name="membershipNo" value={form.membershipNo} onChange={handleChange} required />
                </label>
                <label>
                  Name *
                  <input name="name" value={form.name} onChange={handleChange} required />
                </label>
                <label>
                  Designation
                  <input name="designation" value={form.designation} onChange={handleChange} />
                </label>
                <label>
                  Father/Husband Name
                  <input name="fatherHusbandName" value={form.fatherHusbandName} onChange={handleChange} />
                </label>
                <label>
                  Staff Code
                  <input name="staffCode" value={form.staffCode} onChange={handleChange} />
                </label>
                <label>
                  Section/Division
                  <input name="sectionDivision" value={form.sectionDivision} onChange={handleChange} />
                </label>
                <label>
                  Age
                  <input type="number" name="age" value={form.age} onChange={handleChange} />
                </label>
                <label>
                  Date of Birth
                  <input type="date" name="dateOfBirth" value={form.dateOfBirth} onChange={handleChange} />
                </label>
                <label>
                  Date of Joining
                  <input type="date" name="dateOfJoining" value={form.dateOfJoining} onChange={handleChange} />
                </label>
                <label>
                  Bank Account No
                  <input name="bankAccountNo" value={form.bankAccountNo} onChange={handleChange} />
                </label>
                <label>
                  Basic Pay
                  <input type="number" step="0.01" name="basicPay" value={form.basicPay} onChange={handleChange} />
                </label>
                <label>
                  Share Capital
                  <input type="number" step="0.01" name="shareCapital" value={form.shareCapital} onChange={handleChange} />
                </label>
                <label>
                  Thrift Deposit
                  <input type="number" step="0.01" name="thriftDeposit" value={form.thriftDeposit} onChange={handleChange} />
                </label>
                <label>
                  Phone No
                  <input name="phoneNo" value={form.phoneNo} onChange={handleChange} />
                </label>
                <label className="full-width">
                  Residential Address
                  <textarea name="residentialAddress" value={form.residentialAddress} onChange={handleChange} />
                </label>
              </div>
              <div className="form-actions">
                <button type="button" className="btn-secondary" onClick={() => setShowForm(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn-primary">
                  {editingId ? "Update" : "Save"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default Members;
