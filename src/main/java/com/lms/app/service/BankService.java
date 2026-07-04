package com.lms.app.service;

import com.lms.app.model.BankAccount;
import com.lms.app.model.BankTransaction;
import com.lms.app.repository.BankAccountRepository;
import com.lms.app.repository.BankTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class BankService {

    @Autowired
    private BankAccountRepository bankAccountRepository;

    @Autowired
    private BankTransactionRepository bankTransactionRepository;

    public List<BankAccount> getAllAccounts() {
        return bankAccountRepository.findAll();
    }

    public BankAccount createAccount(BankAccount account) {
        if (account.getBalance() == null) {
            account.setBalance(BigDecimal.ZERO);
        }
        BankAccount savedAccount = bankAccountRepository.save(account);

        // If initial balance is greater than 0, create an initial deposit transaction
        if (savedAccount.getBalance().compareTo(BigDecimal.ZERO) > 0) {
            BankTransaction initialTxn = new BankTransaction();
            initialTxn.setBankAccount(savedAccount);
            initialTxn.setTransactionNo("BT" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            initialTxn.setTransactionDate(LocalDateTime.now());
            initialTxn.setAmount(savedAccount.getBalance());
            initialTxn.setType("DEBIT"); // DEBIT increases balance
            initialTxn.setReferenceNo("INITIAL");
            initialTxn.setDescription("Initial Balance Deposit");
            bankTransactionRepository.save(initialTxn);
        }

        return savedAccount;
    }

    public List<BankTransaction> getTransactionsByAccount(Long accountId) {
        return bankTransactionRepository.findByBankAccountIdOrderByTransactionDateDesc(accountId);
    }

    public List<BankTransaction> getAllTransactions() {
        return bankTransactionRepository.findAll();
    }

    @Transactional
    public BankTransaction postTransaction(Long accountId, BigDecimal amount, String type, String referenceNo, String description) {
        BankAccount account = bankAccountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Bank account not found."));

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero.");
        }

        BankTransaction txn = new BankTransaction();
        txn.setBankAccount(account);
        txn.setTransactionNo("BT" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        txn.setTransactionDate(LocalDateTime.now());
        txn.setAmount(amount);
        txn.setType(type.toUpperCase());
        txn.setReferenceNo(referenceNo);
        txn.setDescription(description);

        // Update balance:
        // DEBIT = Inward (adds to balance)
        // CREDIT = Outward (subtracts from balance)
        if ("DEBIT".equalsIgnoreCase(type)) {
            account.setBalance(account.getBalance().add(amount));
        } else if ("CREDIT".equalsIgnoreCase(type)) {
            if (account.getBalance().compareTo(amount) < 0) {
                throw new IllegalArgumentException("Insufficient balance in bank account.");
            }
            account.setBalance(account.getBalance().subtract(amount));
        } else {
            throw new IllegalArgumentException("Invalid transaction type. Must be DEBIT or CREDIT.");
        }

        bankAccountRepository.save(account);
        return bankTransactionRepository.save(txn);
    }
}
