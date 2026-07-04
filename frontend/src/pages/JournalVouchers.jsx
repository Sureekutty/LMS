import React, { useState, useEffect } from 'react';
import API from '../api/axios';
import { Plus, Trash2, Save, FileText, CheckCircle, AlertCircle } from 'lucide-react';
import './JournalVouchers.css';

export default function JournalVouchers() {
  const [transactionTypes, setTransactionTypes] = useState([]);
  const [members, setMembers] = useState([]);
  
  const [description, setDescription] = useState('');
  const [transactionDate, setTransactionDate] = useState(new Date().toISOString().split('T')[0]);
  
  const [entries, setEntries] = useState([
    { id: 1, transactionTypeId: '', type: 'DEBIT', amount: '', memberId: '' },
    { id: 2, transactionTypeId: '', type: 'CREDIT', amount: '', memberId: '' }
  ]);

  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    fetchMetadata();
    fetchHistory();
  }, []);

  const fetchMetadata = async () => {
    try {
      const typesRes = await API.get('/transactions/types'); // Fallback if exists
      setTransactionTypes(typesRes.data);
      const membersRes = await API.get('/members');
      setMembers(membersRes.data);
    } catch (err) {
      console.log('Failed to fetch metadata', err);
      // Mock some transaction types if endpoint fails
      setTransactionTypes([
        { id: 1, typeName: 'Cash Account', typeCode: 'CASH' },
        { id: 2, typeName: 'Bank Account', typeCode: 'BANK' },
        { id: 3, typeName: 'Share Capital', typeCode: 'SHARE' },
        { id: 4, typeName: 'Loan Principle', typeCode: 'LOAN' },
      ]);
    }
  };

  const fetchHistory = async () => {
    try {
      const res = await API.get('/jv/recent');
      // Group by referenceNo
      const grouped = res.data.reduce((acc, t) => {
        if (!acc[t.referenceNo]) acc[t.referenceNo] = [];
        acc[t.referenceNo].push(t);
        return acc;
      }, {});
      
      const historyList = Object.keys(grouped).map(key => {
        const trs = grouped[key];
        const date = trs[0].transactionDate;
        const totalDebit = trs.filter(t => t.type === 'DEBIT').reduce((s, t) => s + t.amount, 0);
        return {
          referenceNo: key,
          date,
          description: trs[0].description,
          total: totalDebit,
          status: trs[0].status
        };
      }).sort((a,b) => new Date(b.date) - new Date(a.date));
      
      setHistory(historyList);
    } catch (err) {
      console.log('Failed to fetch JV history');
    }
  };

  const addRow = () => {
    setEntries([...entries, { id: Date.now(), transactionTypeId: '', type: 'DEBIT', amount: '', memberId: '' }]);
  };

  const removeRow = (id) => {
    if (entries.length <= 2) return;
    setEntries(entries.filter(e => e.id !== id));
  };

  const updateEntry = (id, field, value) => {
    setEntries(entries.map(e => e.id === id ? { ...e, [field]: value } : e));
  };

  const totalDebit = entries.filter(e => e.type === 'DEBIT').reduce((sum, e) => sum + (parseFloat(e.amount) || 0), 0);
  const totalCredit = entries.filter(e => e.type === 'CREDIT').reduce((sum, e) => sum + (parseFloat(e.amount) || 0), 0);
  const isBalanced = totalDebit === totalCredit && totalDebit > 0;

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!isBalanced) {
      setError('Voucher is not balanced! Total Debits must equal Total Credits.');
      return;
    }
    
    // Validate empty fields
    for (let entry of entries) {
      if (!entry.transactionTypeId || !entry.amount) {
        setError('Please select an account and enter an amount for all rows.');
        return;
      }
    }

    setLoading(true);
    setError('');
    setSuccess('');
    
    try {
      const payload = {
        description,
        transactionDate: transactionDate + "T00:00:00",
        entries: entries.map(e => ({
          transactionTypeId: parseInt(e.transactionTypeId),
          type: e.type,
          amount: parseFloat(e.amount),
          memberId: e.memberId ? parseInt(e.memberId) : null
        }))
      };
      
      const res = await API.post('/jv', payload);
      setSuccess(res.data.message || 'Journal Voucher posted successfully!');
      
      // Reset form
      setDescription('');
      setEntries([
        { id: Date.now(), transactionTypeId: '', type: 'DEBIT', amount: '', memberId: '' },
        { id: Date.now()+1, transactionTypeId: '', type: 'CREDIT', amount: '', memberId: '' }
      ]);
      fetchHistory();
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to post Journal Voucher.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="jv-container">
      <header className="page-header">
        <div>
          <h1 className="page-title">Journal Vouchers</h1>
          <p className="page-subtitle">Advanced Double-Entry Accounting</p>
        </div>
      </header>

      <div className="content-grid">
        <div className="main-section">
          <div className="glass-card">
            <h2 className="card-title" style={{ marginBottom: '1.5rem', display: 'flex', alignItems: 'center', gap: '8px' }}>
              <FileText size={20} className="text-primary" /> Create New Voucher
            </h2>
            
            {error && <div className="alert alert-danger" style={{ marginBottom: '1rem' }}><AlertCircle size={16}/> {error}</div>}
            {success && <div className="alert alert-success" style={{ marginBottom: '1rem' }}><CheckCircle size={16}/> {success}</div>}

            <form onSubmit={handleSubmit}>
              <div className="form-grid" style={{ marginBottom: '2rem' }}>
                <label className="enterprise-form-group">
                  <span className="enterprise-label">Voucher Date</span>
                  <input type="date" className="enterprise-input" value={transactionDate} onChange={e => setTransactionDate(e.target.value)} required />
                </label>
                <label className="enterprise-form-group">
                  <span className="enterprise-label">Description / Narration</span>
                  <input type="text" className="enterprise-input" placeholder="e.g. Being cash deposited into bank" value={description} onChange={e => setDescription(e.target.value)} required />
                </label>
              </div>

              <div className="jv-entries-table">
                <div className="jv-table-header">
                  <div>Dr/Cr</div>
                  <div>Account (Ledger Head)</div>
                  <div>Member (Optional)</div>
                  <div>Amount (₹)</div>
                  <div>Action</div>
                </div>
                
                {entries.map((entry, index) => (
                  <div key={entry.id} className="jv-table-row">
                    <select className="enterprise-input" value={entry.type} onChange={e => updateEntry(entry.id, 'type', e.target.value)}>
                      <option value="DEBIT">Dr (Debit)</option>
                      <option value="CREDIT">Cr (Credit)</option>
                    </select>
                    
                    <select className="enterprise-input" value={entry.transactionTypeId} onChange={e => updateEntry(entry.id, 'transactionTypeId', e.target.value)} required>
                      <option value="">-- Select Account --</option>
                      {transactionTypes.map(t => (
                        <option key={t.id} value={t.id}>{t.typeName} ({t.typeCode})</option>
                      ))}
                    </select>

                    <select className="enterprise-input" value={entry.memberId} onChange={e => updateEntry(entry.id, 'memberId', e.target.value)}>
                      <option value="">-- None --</option>
                      {members.map(m => (
                        <option key={m.id} value={m.id}>{m.firstName} {m.lastName} ({m.membershipNo})</option>
                      ))}
                    </select>

                    <input type="number" step="0.01" min="0" className="enterprise-input text-right" placeholder="0.00" value={entry.amount} onChange={e => updateEntry(entry.id, 'amount', e.target.value)} required />
                    
                    <button type="button" className="icon-btn danger" onClick={() => removeRow(entry.id)} disabled={entries.length <= 2}>
                      <Trash2 size={18} />
                    </button>
                  </div>
                ))}
              </div>

              <div className="jv-actions">
                <button type="button" className="btn-enterprise btn-secondary" onClick={addRow}>
                  <Plus size={16} /> Add Row
                </button>
                
                <div className="jv-totals">
                  <div className={`total-box ${isBalanced ? 'balanced' : 'unbalanced'}`}>
                    <span>Total Debit:</span>
                    <strong>₹{totalDebit.toFixed(2)}</strong>
                  </div>
                  <div className={`total-box ${isBalanced ? 'balanced' : 'unbalanced'}`}>
                    <span>Total Credit:</span>
                    <strong>₹{totalCredit.toFixed(2)}</strong>
                  </div>
                </div>
              </div>

              <div className="form-actions" style={{ marginTop: '2rem' }}>
                <button type="submit" className="btn-enterprise btn-primary" disabled={loading || !isBalanced} style={{ width: '100%', padding: '1rem', fontSize: '1.1rem' }}>
                  <Save size={18} /> {loading ? 'Posting...' : 'Post Journal Voucher'}
                </button>
              </div>
            </form>
          </div>
        </div>

        <div className="sidebar-section">
          <div className="glass-card">
            <h3 className="card-title" style={{ marginBottom: '1.25rem', fontSize: '1.1rem' }}>Recent Vouchers</h3>
            {history.length === 0 ? (
              <p className="text-secondary text-sm">No recent journal vouchers.</p>
            ) : (
              <div className="recent-jv-list">
                {history.map((jv, i) => (
                  <div key={i} className="recent-jv-item">
                    <div className="jv-item-header">
                      <span className="jv-ref">{jv.referenceNo}</span>
                      <span className="jv-date">{new Date(jv.date).toLocaleDateString()}</span>
                    </div>
                    <p className="jv-desc">{jv.description}</p>
                    <div className="jv-item-footer">
                      <span className="jv-status badge badge-active">{jv.status}</span>
                      <strong className="jv-amount">₹{jv.total.toFixed(2)}</strong>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
