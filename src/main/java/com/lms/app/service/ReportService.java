package com.lms.app.service;

import com.lms.app.model.Loan;
import com.lms.app.model.Member;
import com.lms.app.model.Transaction;
import com.lms.app.repository.LoanRepository;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.util.List;

@Service
public class ReportService {

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private LoanRepository loanRepository;

    // Export members report to CSV
    public ByteArrayInputStream exportMembersToCsv() {
        List<Member> members = memberRepository.findAll();
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        
        try (PrintWriter writer = new PrintWriter(out)) {
            // Write CSV Header
            writer.println("Membership No,Name,Designation,Staff Code,Phone No,Share Capital,Thrift Deposit,Status");

            // Write Data
            for (Member m : members) {
                writer.println(String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%s,%s,\"%s\"",
                        m.getMembershipNo(),
                        m.getName(),
                        m.getDesignation() != null ? m.getDesignation() : "",
                        m.getStaffCode() != null ? m.getStaffCode() : "",
                        m.getPhoneNo() != null ? m.getPhoneNo() : "",
                        m.getShareCapital(),
                        m.getThriftDeposit(),
                        m.getIsActive() != null && m.getIsActive() ? "ACTIVE" : "INACTIVE"
                ));
            }
            writer.flush();
            return new ByteArrayInputStream(out.toByteArray());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Member CSV report: " + e.getMessage());
        }
    }

    // Export transactions ledger report to CSV
    public ByteArrayInputStream exportTransactionsToCsv() {
        List<Transaction> txns = transactionRepository.findAll();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try (PrintWriter writer = new PrintWriter(out)) {
            // Write CSV Header
            writer.println("Transaction No,Date,Type,Amount,Dr/Cr,Member No,Member Name,Reference,Description,Status");

            for (Transaction t : txns) {
                writer.println(String.format("\"%s\",\"%s\",\"%s\",%s,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
                        t.getTransactionNo(),
                        t.getTransactionDate(),
                        t.getTransactionType().getTypeName(),
                        t.getAmount(),
                        t.getType(),
                        t.getMember() != null ? t.getMember().getMembershipNo() : "N/A",
                        t.getMember() != null ? t.getMember().getName() : "General Society",
                        t.getReferenceNo() != null ? t.getReferenceNo() : "",
                        t.getDescription() != null ? t.getDescription() : "",
                        t.getStatus()
                ));
            }
            writer.flush();
            return new ByteArrayInputStream(out.toByteArray());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Transaction CSV report: " + e.getMessage());
        }
    }

    // Export active loans report to CSV
    public ByteArrayInputStream exportLoansToCsv() {
        List<Loan> loans = loanRepository.findAll();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try (PrintWriter writer = new PrintWriter(out)) {
            // Write CSV Header
            writer.println("Loan No,Member No,Member Name,Type,Applied Date,Sanctioned Date,Sanctioned Amount,Rate (%),Monthly EMI,Outstanding Principal,Outstanding Interest,Status");

            for (Loan l : loans) {
                writer.println(String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%s,%s,%s,%s,%s,\"%s\"",
                        l.getLoanNo(),
                        l.getMember().getMembershipNo(),
                        l.getMember().getName(),
                        l.getLoanType() != null ? l.getLoanType() : "",
                        l.getAppliedDate() != null ? l.getAppliedDate() : "",
                        l.getSanctionedDate() != null ? l.getSanctionedDate() : "",
                        l.getAmountSanctioned() != null ? l.getAmountSanctioned() : 0.00,
                        l.getInterestRate() != null ? l.getInterestRate() : 0.00,
                        l.getMonthlyInstallment() != null ? l.getMonthlyInstallment() : 0.00,
                        l.getOutstandingPrincipal() != null ? l.getOutstandingPrincipal() : 0.00,
                        l.getOutstandingInterest() != null ? l.getOutstandingInterest() : 0.00,
                        l.getStatus()
                ));
            }
            writer.flush();
            return new ByteArrayInputStream(out.toByteArray());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Loan CSV report: " + e.getMessage());
        }
    }
}
