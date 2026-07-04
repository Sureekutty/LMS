package com.lms.app.service;

import com.lms.app.model.Loan;
import com.lms.app.model.Member;
import com.lms.app.model.Transaction;
import com.lms.app.model.TransactionType;
import com.lms.app.repository.LoanRepository;
import com.lms.app.repository.TransactionTypeRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

    @Autowired
    private InterestCalculationService interestCalculationService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private TransactionTypeRepository transactionTypeRepository;

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

    @Transactional
    public Loan replaceSurety(Long loanId, int suretyIndex, String newSurety) {
        Loan loan = loanRepository.findById(loanId)
            .orElseThrow(() -> new RuntimeException("Loan not found"));
        
        switch (suretyIndex) {
            case 1:
                loan.setSurety1(newSurety);
                break;
            case 2:
                loan.setSurety2(newSurety);
                break;
            case 3:
                loan.setSurety3(newSurety);
                break;
            default:
                throw new RuntimeException("Invalid surety index. Must be 1, 2, or 3");
        }
        
        return loanRepository.save(loan);
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
        loan.setOutstandingPrincipal(sanctionedAmount);
        loan.setOutstandingInterest(BigDecimal.ZERO);

        // Fetch dynamic interest rate if not set
        if (loan.getInterestRate() == null || loan.getInterestRate().compareTo(BigDecimal.ZERO) == 0) {
            try {
                BigDecimal rate = interestCalculationService.getApplicableRate(
                        loan.getLoanType(), 
                        sanctionedAmount, 
                        loan.getNoOfInstallments()
                );
                loan.setInterestRate(rate);
            } catch (Exception e) {
                // Fallback to default interest rate if lookup fails (e.g. 12%)
                loan.setInterestRate(BigDecimal.valueOf(12.0));
            }
        }

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

    // Disburse loan
    @Transactional
    public Loan disburseLoan(Long loanId, String disbursedBy) {
        Loan loan = loanRepository.findById(loanId)
            .orElseThrow(() -> new RuntimeException("Loan not found: " + loanId));
        
        if (!"APPROVED".equalsIgnoreCase(loan.getStatus())) {
            throw new RuntimeException("Only approved loans can be disbursed.");
        }

        loan.setStatus("ACTIVE"); // ACTIVE/DISBURSED
        loan.setDisbursedDate(LocalDate.now());
        loan.setDisbursedBy(disbursedBy);
        loan.setOutstandingPrincipal(loan.getAmountSanctioned());
        loan.setOutstandingInterest(BigDecimal.ZERO);
        loanRepository.save(loan);

        // Record the financial ledger transaction!
        Transaction txn = new Transaction();
        txn.setMember(loan.getMember());
        
        // Find TransactionType for Loan Disbursement (code: LD)
        TransactionType txnType = transactionTypeRepository.findByTypeCode("LD")
            .orElseGet(() -> {
                TransactionType t = new TransactionType();
                t.setTypeCode("LD");
                t.setTypeName("Loan Disbursement");
                return transactionTypeRepository.save(t);
            });
        
        txn.setTransactionType(txnType);
        txn.setAmount(loan.getAmountSanctioned());
        txn.setType("DEBIT");
        txn.setReferenceNo(loan.getLoanNo());
        txn.setDescription("Disbursement of loan account: " + loan.getLoanNo());
        transactionService.recordTransaction(txn);

        return loan;
    }
}