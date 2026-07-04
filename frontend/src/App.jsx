import { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import Deposits from './pages/Deposits';
import Payments from './pages/Payments';
import Reports from './pages/Reports';
import Loans from './pages/Loans';
import LoanDetails from './pages/LoanDetails';
import Audits from './pages/Audits';
import Members from './pages/Members';
import MemberForm from './pages/MemberForm';
import BankLedger from './pages/BankLedger';
import Bills from './pages/Bills';
import MiscPayments from './pages/MiscPayments';
import JournalVouchers from './pages/JournalVouchers';
import Shares from './pages/Shares';
import Polls from './pages/Polls';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';
import AIAssistant from './components/AIAssistant';

function App() {
  useEffect(() => {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.classList.remove('dark-theme', 'thunder-theme');
    if (savedTheme === 'dark') {
      document.body.classList.add('dark-theme');
    } else if (savedTheme === 'thunder') {
      document.body.classList.add('thunder-theme');
    }
  }, []);

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Layout><Dashboard /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/members"
          element={
            <ProtectedRoute>
              <Layout><Members /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/members/new"
          element={
            <ProtectedRoute>
              <Layout><MemberForm /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/members/:id/edit"
          element={
            <ProtectedRoute>
              <Layout><MemberForm /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/deposits"
          element={
            <ProtectedRoute>
              <Layout><Deposits /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/payments"
          element={
            <ProtectedRoute>
              <Layout><Payments /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/reports"
          element={
            <ProtectedRoute>
              <Layout><Reports /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/loans"
          element={
            <ProtectedRoute>
              <Layout><Loans /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/loans/:id"
          element={
            <ProtectedRoute>
              <Layout><LoanDetails /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/audits"
          element={
            <ProtectedRoute>
              <Layout><Audits /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/banks"
          element={
            <ProtectedRoute>
              <Layout><BankLedger /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/bills"
          element={
            <ProtectedRoute>
              <Layout><Bills /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/misc-payments"
          element={
            <ProtectedRoute>
              <Layout><MiscPayments /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/journal-vouchers"
          element={
            <ProtectedRoute>
              <Layout><JournalVouchers /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/shares"
          element={
            <ProtectedRoute>
              <Layout><Shares /></Layout>
            </ProtectedRoute>
          }
        />
        <Route
          path="/polls"
          element={
            <ProtectedRoute>
              <Layout><Polls /></Layout>
            </ProtectedRoute>
          }
        />
        <Route path="/" element={<Navigate to="/login" replace />} />
      </Routes>
      
      <AIAssistant />
    </BrowserRouter>
  );
}

export default App;
