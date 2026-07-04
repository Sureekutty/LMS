package com.lms.app.scheduler;

import com.lms.app.model.*;
import com.lms.app.repository.*;
import com.lms.app.service.DepositTransactionService;
import com.lms.app.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;

@Component
public class InterestAccruionScheduler {

    @Autowired
    private LoanRepository loanRepository;

    @Autowired
    private DepositRepository depositRepository;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private DepositTransactionService depositTransactionService;

    @Autowired
    private TransactionTypeRepository transactionTypeRepository;

    // Run at midnight on the 1st of every month
    @Scheduled(cron = "0 0 0 1 * ?")
    @Transactional
    public void runMonthlyInterestAccrual() {
        accrueLoanInterest();
        accrueDepositInterest();
    }

    @Transactional
    public void accrueLoanInterest() {
        List<Loan> activeLoans = loanRepository.findByStatus("ACTIVE");
        
        // Find or create TransactionType for Interest Accrual (code: INT_ACC)
        TransactionType txnType = transactionTypeRepository.findByTypeCode("INT_ACC")
            .orElseGet(() -> {
                TransactionType t = new TransactionType();
                t.setTypeCode("INT_ACC");
                t.setTypeName("Interest Accrual");
                return transactionTypeRepository.save(t);
            });

        for (Loan loan : activeLoans) {
            BigDecimal principal = loan.getOutstandingPrincipal();
            BigDecimal annualRate = loan.getInterestRate();
            
            if (principal != null && principal.compareTo(BigDecimal.ZERO) > 0 &&
                    annualRate != null && annualRate.compareTo(BigDecimal.ZERO) > 0) {
                
                // Monthly Interest = Principal * (Rate / 100) / 12
                BigDecimal monthlyInterest = principal
                        .multiply(annualRate.divide(BigDecimal.valueOf(100), 10, RoundingMode.HALF_UP))
                        .divide(BigDecimal.valueOf(12), 2, RoundingMode.HALF_UP);

                if (monthlyInterest.compareTo(BigDecimal.ZERO) > 0) {
                    // Update outstanding interest
                    BigDecimal currentOutstandingInt = loan.getOutstandingInterest() != null ? loan.getOutstandingInterest() : BigDecimal.ZERO;
                    loan.setOutstandingInterest(currentOutstandingInt.add(monthlyInterest));
                    loanRepository.save(loan);

                    // Post to general ledger
                    Transaction txn = new Transaction();
                    txn.setMember(loan.getMember());
                    txn.setTransactionType(txnType);
                    txn.setAmount(monthlyInterest);
                    txn.setType("DEBIT");
                    txn.setReferenceNo(loan.getLoanNo());
                    txn.setDescription("Monthly interest accrual for Loan: " + loan.getLoanNo());
                    transactionService.recordTransaction(txn);
                }
            }
        }
    }

    @Transactional
    public void accrueDepositInterest() {
        List<Deposit> activeDeposits = depositRepository.findByStatus("ACTIVE");
        
        // Find or create TransactionType for Deposit Interest (code: DEP_INT)
        TransactionType txnType = transactionTypeRepository.findByTypeCode("DEP_INT")
            .orElseGet(() -> {
                TransactionType t = new TransactionType();
                t.setTypeCode("DEP_INT");
                t.setTypeName("Deposit Interest Credit");
                return transactionTypeRepository.save(t);
            });

        for (Deposit deposit : activeDeposits) {
            BigDecimal principal = deposit.getPrincipalAmount();
            BigDecimal annualRate = deposit.getInterestRate();
            
            if (principal != null && principal.compareTo(BigDecimal.ZERO) > 0 &&
                    annualRate != null && annualRate.compareTo(BigDecimal.ZERO) > 0) {

                // Monthly Interest = Principal * (Rate / 100) / 12
                BigDecimal monthlyInterest = principal
                        .multiply(annualRate.divide(BigDecimal.valueOf(100), 10, RoundingMode.HALF_UP))
                        .divide(BigDecimal.valueOf(12), 2, RoundingMode.HALF_UP);

                if (monthlyInterest.compareTo(BigDecimal.ZERO) > 0) {
                    // 1. Post to Deposit Ledger
                    DepositTransaction depTxn = new DepositTransaction();
                    depTxn.setDeposit(deposit);
                    depTxn.setTransactionType("INTEREST");
                    depTxn.setAmount(monthlyInterest);
                    depTxn.setRemarks("Monthly interest credit");
                    depositTransactionService.recordTransaction(depTxn);

                    // 2. Post to general ledger
                    Transaction txn = new Transaction();
                    txn.setMember(deposit.getMember());
                    txn.setTransactionType(txnType);
                    txn.setAmount(monthlyInterest);
                    txn.setType("CREDIT");
                    txn.setReferenceNo(deposit.getDepositNo());
                    txn.setDescription("Monthly interest credited to Deposit: " + deposit.getDepositNo());
                    transactionService.recordTransaction(txn);
                }
            }
        }
    }
}
