package com.lms.app.service;

import com.lms.app.model.Deposit;
import com.lms.app.model.DepositTransaction;
import com.lms.app.repository.DepositRepository;
import com.lms.app.repository.DepositTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class DepositTransactionService {

    @Autowired
    private DepositTransactionRepository depositTransactionRepository;

    @Autowired
    private DepositRepository depositRepository;

    public List<DepositTransaction> getAllTransactions() {
        return depositTransactionRepository.findAll();
    }

    public List<DepositTransaction> getTransactionsByDepositId(Long depositId) {
        Deposit deposit = depositRepository.findById(depositId)
                .orElseThrow(() -> new RuntimeException("Deposit account not found with ID: " + depositId));
        return depositTransactionRepository.findByDepositOrderByTransactionDateDesc(deposit);
    }

    // Get current balance of a deposit account
    public BigDecimal getCurrentBalance(Deposit deposit) {
        List<DepositTransaction> txns = depositTransactionRepository.findLatestTransaction(deposit);
        if (txns.isEmpty()) {
            return BigDecimal.ZERO;
        }
        return txns.get(0).getClosingBalance();
    }

    // Record a new transaction
    public DepositTransaction recordTransaction(DepositTransaction txn) {
        if (txn.getDeposit() == null || txn.getDeposit().getId() == null) {
            throw new RuntimeException("Transaction must be linked to a valid deposit account.");
        }

        // 1. Fetch deposit account
        Deposit deposit = depositRepository.findById(txn.getDeposit().getId())
                .orElseThrow(() -> new RuntimeException("Deposit account not found."));

        if (!"ACTIVE".equalsIgnoreCase(deposit.getStatus())) {
            throw new RuntimeException("Cannot perform transactions on an inactive deposit account.");
        }

        // 2. Fetch current balance
        BigDecimal currentBalance = getCurrentBalance(deposit);
        txn.setOpeningBalance(currentBalance);

        // 3. Process type-specific logic
        BigDecimal amount = txn.getAmount();
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Transaction amount must be greater than zero.");
        }

        String type = txn.getTransactionType();
        if (type == null) {
            throw new RuntimeException("Transaction type is required.");
        }

        BigDecimal closingBalance;
        if ("DEPOSIT".equalsIgnoreCase(type) || "INTEREST".equalsIgnoreCase(type)) {
            closingBalance = currentBalance.add(amount);
            // Auto-generate receipt number for deposits if not provided
            if ("DEPOSIT".equalsIgnoreCase(type) && txn.getReceiptNo() == null) {
                txn.setReceiptNo("REC" + System.currentTimeMillis());
            }
        } else if ("WITHDRAWAL".equalsIgnoreCase(type)) {
            if (currentBalance.compareTo(amount) < 0) {
                throw new RuntimeException("Insufficient balance for withdrawal. Current balance: " + currentBalance);
            }
            closingBalance = currentBalance.subtract(amount);
        } else {
            throw new RuntimeException("Invalid transaction type. Allowed: DEPOSIT, WITHDRAWAL, INTEREST.");
        }

        txn.setDeposit(deposit);
        txn.setClosingBalance(closingBalance);
        txn.setTransactionDate(LocalDateTime.now());

        return depositTransactionRepository.save(txn);
    }
}
