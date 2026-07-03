import { useEffect, useState } from "react";
import { Landmark, FileText, Download, Users, Landmark as BankIcon, CreditCard, RefreshCw } from "lucide-react";
import API from "../api/axios";
import "./Reports.css";

export default function Reports() {
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
    
    // Create temporary download anchor to support authorization headers or download directly via browser
    const a = document.createElement("a");
    a.href = url;
    a.download = `${type}_report.csv`;
    
    // Fall back to opening window with token attached in URL query or standard link
    window.open(`${url}?token=${token}`, "_blank");
  };

  return (
    <main className="reports-page">
      <header className="page-header">
        <div>
          <h1>Financial Reports & Ledger Book</h1>
          <p>Download system ledgers, compile cash books, and run balance sheets</p>
        </div>
        <button className="open-form-btn" onClick={fetchStats}>
          <RefreshCw size={18} />
          Recalculate Balances
        </button>
      </header>

      {loading ? (
        <div className="loading-state">
          <RefreshCw size={36} className="spin-icon" />
          <p>Compiling financial statements...</p>
        </div>
      ) : (
        <>
          {/* Summary Cards */}
          <section className="reports-grid">
            <div className="report-card">
              <Users size={28} className="report-icon icon-blue" />
              <div>
                <h4>Total Active Members</h4>
                <h2>{stats.totalMembers}</h2>
              </div>
            </div>

            <div className="report-card">
              <BankIcon size={28} className="report-icon icon-green" />
              <div>
                <h4>Share Capital Pool</h4>
                <h2>₹{stats.totalShareCapital.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
              </div>
            </div>

            <div className="report-card">
              <CreditCard size={28} className="report-icon icon-yellow" />
              <div>
                <h4>Outstanding Credit (Loans)</h4>
                <h2>₹{stats.outstandingLoansAmount.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
              </div>
            </div>

            <div className="report-card">
              <Landmark size={28} className="report-icon icon-red" />
              <div>
                <h4>Cash Book Balance</h4>
                <h2>₹{stats.cashBalance.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</h2>
              </div>
            </div>
          </section>

          {/* Export Downloads Section */}
          <section className="export-section">
            <h3>Download System Ledgers</h3>
            <div className="export-buttons-grid">
              <div className="export-card">
                <FileText size={32} />
                <div>
                  <h4>Members Roster Registry</h4>
                  <p>Includes names, staff codes, designation, and share capital</p>
                </div>
                <button onClick={() => handleDownloadCsv("members")} className="download-btn">
                  <Download size={16} />
                  Download CSV
                </button>
              </div>

              <div className="export-card">
                <FileText size={32} />
                <div>
                  <h4>Double-Entry Cash Book Ledger</h4>
                  <p>Full transaction journals containing voucher entries and audits</p>
                </div>
                <button onClick={() => handleDownloadCsv("transactions")} className="download-btn">
                  <Download size={16} />
                  Download CSV
                </button>
              </div>

              <div className="export-card">
                <FileText size={32} />
                <div>
                  <h4>Outstanding Loan Ledger</h4>
                  <p>EMI payments, outstanding interest, and principal balances</p>
                </div>
                <button onClick={() => handleDownloadCsv("loans")} className="download-btn">
                  <Download size={16} />
                  Download CSV
                </button>
              </div>
            </div>
          </section>
        </>
      )}
    </main>
  );
}
