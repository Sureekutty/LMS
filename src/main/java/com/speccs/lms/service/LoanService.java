package com.speccs.lms.service;

import com.speccs.lms.model.Loan;
import com.speccs.lms.model.Member;
import com.speccs.lms.repository.LoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class LoanService {

    @Autowired
    private LoanRepository loanRepository;

    @Autowired
    private MemberService memberService;

    // Get all loans
    public List<Loan> getAllLoans() {
        return loanRepository.findAll();
    }

    // Get loan by ID
    public Optional<Loan> getLoanById(Long id) {
        return loanRepository.findById(id);
    }

    // Get loans by status
    public List<Loan> getLoansByStatus(String status) {
        return loanRepository.findByStatus(status);
    }

    // Get loans by member
    public List<Loan> getLoansByMember(Member member) {
        return loanRepository.findByMember(member);
    }

    // Apply for loan
    public Loan applyLoan(Loan loan) {
        // Generate unique loan number
        loan.setLoanNo(generateLoanNo());
        loan.setStatus("PENDING");
        loan.setAppliedDate(LocalDate.now());
        return loanRepository.save(loan);
    }

    // Approve loan
    public Loan approveLoan(Long loanId, BigDecimal sanctionedAmount) {
        Loan loan = loanRepository.findById(loanId)
            .orElseThrow(() -> new RuntimeException("Loan not found: " + loanId));
        loan.setStatus("APPROVED");
        loan.setAmountSanctioned(sanctionedAmount);
        loan.setSanctionedDate(LocalDate.now());
        // Calculate EMI
        loan.setMonthlyInstallment(calculateEMI(
            sanctionedAmount,
            loan.getInterestRate(),
            loan.getNoOfInstallments()
        ));
        return loanRepository.save(loan);
    }

    // Reject loan
    public Loan rejectLoan(Long loanId) {
        Loan loan = loanRepository.findById(loanId)
            .orElseThrow(() -> new RuntimeException("Loan not found: " + loanId));
        loan.setStatus("REJECTED");
        return loanRepository.save(loan);
    }

    // Calculate EMI — Very Important Formula!
    public BigDecimal calculateEMI(BigDecimal principal, 
                                    BigDecimal annualRate, 
                                    int months) {
        if (annualRate.compareTo(BigDecimal.ZERO) == 0) {
            // Simple division if no interest
            return principal.divide(
                BigDecimal.valueOf(months), 2, RoundingMode.HALF_UP);
        }
        // EMI Formula: P * R * (1+R)^N / ((1+R)^N - 1)
        double p = principal.doubleValue();
        double r = annualRate.doubleValue() / (12 * 100);
        double n = months;
        double emi = p * r * Math.pow(1 + r, n) / (Math.pow(1 + r, n) - 1);
        return BigDecimal.valueOf(emi).setScale(2, RoundingMode.HALF_UP);
    }

    // Generate unique loan number
    private String generateLoanNo() {
        long count = loanRepository.count() + 1;
        return "LOAN" + String.format("%06d", count);
    }

    // Calculate loan eligibility
    public BigDecimal calculateEligibility(BigDecimal basicPay) {
        // Member can get maximum 20x of basic pay
        return basicPay.multiply(BigDecimal.valueOf(20));
    }
}