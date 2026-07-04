package com.lms.app.service;

import com.lms.app.model.Loan;
import com.lms.app.model.Member;
import com.lms.app.model.Transaction;
import com.lms.app.repository.LoanRepository;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.TransactionRepository;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.properties.UnitValue;
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
            writer.println("Membership No,Name,Designation,Staff Code,Phone No,Share Capital,Thrift Deposit,Status");

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

    // Export members report to PDF using iText
    public ByteArrayInputStream exportMembersToPdf() {
        List<Member> members = memberRepository.findAll();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            document.add(new Paragraph("LOAN MANAGEMENT SYSTEM").setFontSize(18).setBold());
            document.add(new Paragraph("MEMBERS REGISTRY DIRECTORY").setFontSize(14).setBold().setMarginBottom(15));

            Table table = new Table(UnitValue.createPercentArray(new float[]{15, 25, 20, 15, 15, 10}));
            table.useAllAvailableWidth();

            table.addHeaderCell(new Cell().add(new Paragraph("Mem No").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Name").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Designation").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Shares").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Thrift Bal").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Status").setBold()));

            for (Member m : members) {
                table.addCell(new Cell().add(new Paragraph(m.getMembershipNo())));
                table.addCell(new Cell().add(new Paragraph(m.getName())));
                table.addCell(new Cell().add(new Paragraph(m.getDesignation() != null ? m.getDesignation() : "")));
                table.addCell(new Cell().add(new Paragraph(m.getShareCapital().toString())));
                table.addCell(new Cell().add(new Paragraph(m.getThriftDeposit().toString())));
                table.addCell(new Cell().add(new Paragraph(m.getIsActive() != null && m.getIsActive() ? "ACTIVE" : "INACTIVE")));
            }

            document.add(table);
            document.close();
            return new ByteArrayInputStream(out.toByteArray());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Member PDF report: " + e.getMessage());
        }
    }

    // Export transactions ledger report to PDF using iText
    public ByteArrayInputStream exportTransactionsToPdf() {
        List<Transaction> txns = transactionRepository.findAll();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            document.add(new Paragraph("LOAN MANAGEMENT SYSTEM").setFontSize(18).setBold());
            document.add(new Paragraph("TRANSACTIONS LEDGER AUDIT BOOK").setFontSize(14).setBold().setMarginBottom(15));

            Table table = new Table(UnitValue.createPercentArray(new float[]{15, 20, 15, 15, 10, 25}));
            table.useAllAvailableWidth();

            table.addHeaderCell(new Cell().add(new Paragraph("Txn No").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Date").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Type").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Amount").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Dr/Cr").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Description").setBold()));

            for (Transaction t : txns) {
                table.addCell(new Cell().add(new Paragraph(t.getTransactionNo())));
                table.addCell(new Cell().add(new Paragraph(t.getTransactionDate().toString().substring(0, 10))));
                table.addCell(new Cell().add(new Paragraph(t.getTransactionType().getTypeName())));
                table.addCell(new Cell().add(new Paragraph(t.getAmount().toString())));
                table.addCell(new Cell().add(new Paragraph(t.getType())));
                table.addCell(new Cell().add(new Paragraph(t.getDescription() != null ? t.getDescription() : "")));
            }

            document.add(table);
            document.close();
            return new ByteArrayInputStream(out.toByteArray());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Transaction PDF report: " + e.getMessage());
        }
    }

    // Export active loans report to PDF using iText
    public ByteArrayInputStream exportLoansToPdf() {
        List<Loan> loans = loanRepository.findAll();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            document.add(new Paragraph("LOAN MANAGEMENT SYSTEM").setFontSize(18).setBold());
            document.add(new Paragraph("ACTIVE LOANS STATEMENT REGISTRY").setFontSize(14).setBold().setMarginBottom(15));

            Table table = new Table(UnitValue.createPercentArray(new float[]{15, 25, 15, 15, 15, 15}));
            table.useAllAvailableWidth();

            table.addHeaderCell(new Cell().add(new Paragraph("Loan No").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Member").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Sanctioned").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Principal Due").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Interest Due").setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Status").setBold()));

            for (Loan l : loans) {
                table.addCell(new Cell().add(new Paragraph(l.getLoanNo())));
                table.addCell(new Cell().add(new Paragraph(l.getMember().getName())));
                table.addCell(new Cell().add(new Paragraph(l.getAmountSanctioned() != null ? l.getAmountSanctioned().toString() : "0.00")));
                table.addCell(new Cell().add(new Paragraph(l.getOutstandingPrincipal() != null ? l.getOutstandingPrincipal().toString() : "0.00")));
                table.addCell(new Cell().add(new Paragraph(l.getOutstandingInterest() != null ? l.getOutstandingInterest().toString() : "0.00")));
                table.addCell(new Cell().add(new Paragraph(l.getStatus())));
            }

            document.add(table);
            document.close();
            return new ByteArrayInputStream(out.toByteArray());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Loan PDF report: " + e.getMessage());
        }
    }
}
