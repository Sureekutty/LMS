package com.lms.app.service;

import com.lms.app.model.Loan;
import com.lms.app.model.LoanRepayment;
import com.lms.app.repository.LoanRepository;
import com.lms.app.repository.LoanRepaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class LoanRepaymentService {

    @Autowired
    private LoanRepaymentRepository loanRepaymentRepository;

    @Autowired
    private LoanRepository loanRepository;

    public List<LoanRepayment> getAllRepayments() {
        return loanRepaymentRepository.findAll();
    }

    public List<LoanRepayment> getRepaymentsByLoanId(Long loanId) {
        Loan loan = loanRepository.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found with ID: " + loanId));
        return loanRepaymentRepository.findByLoan(loan);
    }

    public Optional<LoanRepayment> getRepaymentById(Long id) {
        return loanRepaymentRepository.findById(id);
    }

    @Transactional
    public LoanRepayment makeRepayment(LoanRepayment repayment) {
        if (repayment.getLoan() == null || repayment.getLoan().getId() == null) {
            throw new RuntimeException("Repayment must be linked to a valid loan account.");
        }

        // 1. Fetch loan
        Loan loan = loanRepository.findById(repayment.getLoan().getId())
                .orElseThrow(() -> new RuntimeException("Loan account not found."));

        if ("CLOSED".equalsIgnoreCase(loan.getStatus())) {
            throw new RuntimeException("Cannot make payments on a closed loan account.");
        }

        BigDecimal paymentAmount = repayment.getAmount();
        if (paymentAmount == null || paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Repayment amount must be greater than zero.");
        }

        // 2. Allocate payment amount to outstanding interest first, then outstanding principal
        BigDecimal remaining = paymentAmount;
        BigDecimal interestPaid = BigDecimal.ZERO;
        BigDecimal principalPaid = BigDecimal.ZERO;

        BigDecimal outstandingInterest = loan.getOutstandingInterest();
        if (outstandingInterest == null) {
            outstandingInterest = BigDecimal.ZERO;
        }

        BigDecimal outstandingPrincipal = loan.getOutstandingPrincipal();
        if (outstandingPrincipal == null) {
            outstandingPrincipal = loan.getAmountSanctioned();
        }

        // Pay off interest first
        if (outstandingInterest.compareTo(BigDecimal.ZERO) > 0) {
            if (remaining.compareTo(outstandingInterest) >= 0) {
                interestPaid = outstandingInterest;
                remaining = remaining.subtract(outstandingInterest);
                loan.setOutstandingInterest(BigDecimal.ZERO);
            } else {
                interestPaid = remaining;
                loan.setOutstandingInterest(outstandingInterest.subtract(remaining));
                remaining = BigDecimal.ZERO;
            }
        }

        // Pay off principal with whatever is left
        if (remaining.compareTo(BigDecimal.ZERO) > 0) {
            if (remaining.compareTo(outstandingPrincipal) >= 0) {
                principalPaid = outstandingPrincipal;
                loan.setOutstandingPrincipal(BigDecimal.ZERO);
            } else {
                principalPaid = remaining;
                loan.setOutstandingPrincipal(outstandingPrincipal.subtract(remaining));
            }
        }

        // 3. Update loan status if fully paid
        if (loan.getOutstandingPrincipal().compareTo(BigDecimal.ZERO) <= 0 &&
                loan.getOutstandingInterest().compareTo(BigDecimal.ZERO) <= 0) {
            loan.setStatus("CLOSED");
            loan.setClosedDate(LocalDate.now());
            loan.setClosedBy("SYSTEM");
        } else {
            loan.setStatus("ACTIVE"); // Make active once payments begin
        }

        // Save updated Loan
        loanRepository.save(loan);

        // 4. Fill in Repayment details
        long installmentCount = loanRepaymentRepository.countByLoanAndStatus(loan, "PAID");
        repayment.setInstallmentNo((int) installmentCount + 1);
        repayment.setLoan(loan);
        repayment.setPaidDate(LocalDate.now());
        repayment.setStatus("PAID");
        repayment.setClosingBalance(loan.getOutstandingPrincipal());
        
        // Auto-generate receipt if not present
        if (repayment.getReceiptNo() == null) {
            repayment.setReceiptNo("REC-LN-" + System.currentTimeMillis());
        }

        if (interestPaid.compareTo(BigDecimal.ZERO) > 0 && principalPaid.compareTo(BigDecimal.ZERO) > 0) {
            repayment.setPrincipalOrInterest("B"); // Both
        } else if (interestPaid.compareTo(BigDecimal.ZERO) > 0) {
            repayment.setPrincipalOrInterest("I"); // Interest only
        } else {
            repayment.setPrincipalOrInterest("P"); // Principal only
        }

        return loanRepaymentRepository.save(repayment);
    }
}
