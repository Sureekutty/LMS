import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Landmark, FileText, Download, Users, Landmark as BankIcon, CreditCard, RefreshCw, ArrowLeft } from "lucide-react";
import API from "../api/axios";
import "./Reports.css";

export default function Reports() {
  const navigate = useNavigate();
  const [stats, setStats] = useState({
    totalMembers: 0,
    totalShareCapital: 0,
    thriftDeposit: 0,
    totalDeposits: 0,
    outstandingLoansAmount: 0,
    cashBalance: 0,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const fetchStats = async () => {
    setLoading(true);
    try {
      // Fetch member count and summaries
      const [membersRes, txnsRes, loansRes] = await Promise.all([
        API.get("/members"),
        API.get("/transactions"),
        API.get("/loans")
      ]);

      const members = membersRes.data || [];
      const txns = txnsRes.data || [];
      const loans = loansRes.data || [];

      // Sum metrics
      let shareCapital = 0;
      let thriftDeposit = 0;
      members.forEach(m => {
        shareCapital += m.shareCapital || 0;
        thriftDeposit += m.thriftDeposit || 0;
      });

      let outstandingLoans = 0;
      loans.forEach(l => {
        if (l.status && l.status.toUpperCase() === "ACTIVE") {
          outstandingLoans += l.outstandingPrincipal || 0;
        }
      });

      // Calculate Cash balance = Total Debits - Total Credits
      let debits = 0;
      let credits = 0;
      txns.forEach(t => {
        if (t.status === "ACTIVE") {
          if (t.type === "DEBIT") {
            debits += t.amount || 0;
          } else {
            credits += t.amount || 0;
          }
        }
      });

      setStats({
        totalMembers: members.length,
        totalShareCapital: shareCapital,
        thriftDeposit: thriftDeposit,
        totalDeposits: shareCapital + thriftDeposit,
        outstandingLoansAmount: outstandingLoans,
        cashBalance: debits - credits,
      });
    } catch (err) {
      console.error("Failed to load reports data:", err);
      setError("Failed to compile financial metrics.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStats();
  }, []);

  const handleDownloadCsv = (type) => {
    const token = localStorage.getItem("token");
    const url = `${API.defaults.baseURL}/reports/${type}/csv`;
    window.open(`${url}?token=${token}`, "_blank");
  };

  const handleDownloadPdf = (type) => {
    const token = localStorage.getItem("token");
    const url = `${API.defaults.baseURL}/reports/${type}/pdf`;
    window.open(`${url}?token=${token}`, "_blank");
  };

  return (
    <main className="page-container animate__animated animate__fadeIn">
      <button className="btn-enterprise btn-secondary mb-4" onClick={() => navigate("/dashboard")} style={{ marginBottom: 20 }}>
        <ArrowLeft size={16} /> Back to Dashboard
      </button>
      <header className="page-header">
        <div className="page-title-group">
          <h1 className="gradient-heading">Financial Reports & Ledger Book</h1>
          <p>Download system ledgers, compile cash books, and run balance sheets</p>
        </div>
        <button className="btn-enterprise btn-primary" onClick={fetchStats}>
          <RefreshCw size={18} />
          Recalculate Balances
        </button>
      </header>

      {loading ? (
        <div className="empty-state">
          <RefreshCw size={36} className="spin-icon" />
          <p style={{ marginTop: '1rem' }}>Compiling financial statements...</p>
        </div>
      ) : (
        <>
          {/* Summary Cards */}
          <section className="dashboard-stats" style={{ marginBottom: 30, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '1.5rem' }}>
            <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
              <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#e0f2fe', color: '#0369a1' }}>
                <Users size={28} />
              </div>
              <div>
                <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Total Active Members</h4>
                <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>{stats.totalMembers}</h2>
              </div>
            </div>

            <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
              <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#dcfce7', color: '#15803d' }}>
                <BankIcon size={28} />
              </div>
              <div>
                <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Share Capital Pool</h4>
                <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.totalShareCapital.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
              </div>
            </div>

            <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
              <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#fef3c7', color: '#b45309' }}>
                <CreditCard size={28} />
              </div>
              <div>
                <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Outstanding Credit (Loans)</h4>
                <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.outstandingLoansAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
              </div>
            </div>

            <div className="glass-card stat-card" style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1.5rem' }}>
              <div style={{ padding: '1rem', borderRadius: 'var(--radius-full)', backgroundColor: '#fee2e2', color: '#b91c1c' }}>
                <Landmark size={28} />
              </div>
              <div>
                <h4 style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '0.25rem' }}>Cash Book Balance</h4>
                <h2 style={{ fontSize: '1.8rem', fontWeight: 800, color: 'var(--text-primary)' }}>₹{stats.cashBalance.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
              </div>
            </div>
          </section>

          {/* Export Downloads Section */}
          <section>
            <h3 style={{ fontSize: '1.35rem', fontWeight: 800, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>Download System Ledgers</h3>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem' }}>
              <div className="glass-card" style={{ padding: '2rem', display: 'flex', flexDirection: 'column', gap: '1rem', alignItems: 'flex-start' }}>
                <div style={{ backgroundColor: '#f1f5f9', padding: '1rem', borderRadius: 'var(--radius-md)', color: 'var(--primary)' }}>
                  <FileText size={32} />
                </div>
                <div>
                  <h4 style={{ fontSize: '1.1rem', fontWeight: 700, color: 'var(--text-primary)', marginBottom: '0.25rem' }}>Members Roster Registry</h4>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', lineHeight: 1.4 }}>Includes names, staff codes, designation, and share capital</p>
                </div>
                <div style={{ display: "flex", gap: "10px", marginTop: 'auto', width: '100%' }}>
                  <button onClick={() => handleDownloadCsv("members")} className="btn-enterprise btn-secondary" style={{ flex: 1 }}>
                    <Download size={16} />
                    CSV
                  </button>
                  <button onClick={() => handleDownloadPdf("members")} className="btn-enterprise" style={{ flex: 1, backgroundColor: 'white', color: '#ef4444', border: '1px solid #fca5a5' }}>
                    <Download size={16} />
                    PDF
                  </button>
                </div>
              </div>

              <div className="glass-card" style={{ padding: '2rem', display: 'flex', flexDirection: 'column', gap: '1rem', alignItems: 'flex-start' }}>
                <div style={{ backgroundColor: '#f1f5f9', padding: '1rem', borderRadius: 'var(--radius-md)', color: 'var(--primary)' }}>
                  <FileText size={32} />
                </div>
                <div>
                  <h4 style={{ fontSize: '1.1rem', fontWeight: 700, color: 'var(--text-primary)', marginBottom: '0.25rem' }}>Double-Entry Cash Book Ledger</h4>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', lineHeight: 1.4 }}>Full transaction journals containing voucher entries and audits</p>
                </div>
                <div style={{ display: "flex", gap: "10px", marginTop: 'auto', width: '100%' }}>
                  <button onClick={() => handleDownloadCsv("transactions")} className="btn-enterprise btn-secondary" style={{ flex: 1 }}>
                    <Download size={16} />
                    CSV
                  </button>
                  <button onClick={() => handleDownloadPdf("transactions")} className="btn-enterprise" style={{ flex: 1, backgroundColor: 'white', color: '#ef4444', border: '1px solid #fca5a5' }}>
                    <Download size={16} />
                    PDF
                  </button>
                </div>
              </div>

              <div className="glass-card" style={{ padding: '2rem', display: 'flex', flexDirection: 'column', gap: '1rem', alignItems: 'flex-start' }}>
                <div style={{ backgroundColor: '#f1f5f9', padding: '1rem', borderRadius: 'var(--radius-md)', color: 'var(--primary)' }}>
                  <FileText size={32} />
                </div>
                <div>
                  <h4 style={{ fontSize: '1.1rem', fontWeight: 700, color: 'var(--text-primary)', marginBottom: '0.25rem' }}>Outstanding Loan Ledger</h4>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', lineHeight: 1.4 }}>EMI payments, outstanding interest, and principal balances</p>
                </div>
                <div style={{ display: "flex", gap: "10px", marginTop: 'auto', width: '100%' }}>
                  <button onClick={() => handleDownloadCsv("loans")} className="btn-enterprise btn-secondary" style={{ flex: 1 }}>
                    <Download size={16} />
                    CSV
                  </button>
                  <button onClick={() => handleDownloadPdf("loans")} className="btn-enterprise" style={{ flex: 1, backgroundColor: 'white', color: '#ef4444', border: '1px solid #fca5a5' }}>
                    <Download size={16} />
                    PDF
                  </button>
                </div>
              </div>
            </div>
          </section>
        </>
      )}
    </main>
  );
}
