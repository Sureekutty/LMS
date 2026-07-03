package com.lms.app.service;

import com.lms.app.model.Member;
import com.lms.app.model.Transaction;
import com.lms.app.model.TransactionType;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.TransactionRepository;
import com.lms.app.repository.TransactionTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private TransactionTypeRepository transactionTypeRepository;

    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }

    public Optional<Transaction> getTransactionById(Long id) {
        return transactionRepository.findById(id);
    }

    public List<Transaction> getTransactionsByMemberId(Long memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Member not found with ID: " + memberId));
        return transactionRepository.findByMember(member);
    }

    public List<Transaction> getTransactionsByReference(String referenceNo) {
        return transactionRepository.findByReferenceNo(referenceNo);
    }

    // Record a new financial ledger transaction
    @Transactional
    public Transaction recordTransaction(Transaction transaction) {
        if (transaction.getTransactionType() == null || transaction.getTransactionType().getId() == null) {
            throw new RuntimeException("Transaction must have a valid transaction type.");
        }

        // 1. Fetch and validate TransactionType
        TransactionType type = transactionTypeRepository.findById(transaction.getTransactionType().getId())
                .orElseThrow(() -> new RuntimeException("Transaction type not found."));
        transaction.setTransactionType(type);

        // 2. Validate amount
        if (transaction.getAmount() == null || transaction.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Transaction amount must be greater than zero.");
        }

        // 3. Validate Debit/Credit
        String entryType = transaction.getType();
        if (entryType == null || (!"DEBIT".equalsIgnoreCase(entryType) && !"CREDIT".equalsIgnoreCase(entryType))) {
            throw new RuntimeException("Transaction entry type must be either 'DEBIT' or 'CREDIT'.");
        }
        transaction.setType(entryType.toUpperCase());

        // 4. Resolve Member if provided
        if (transaction.getMember() != null && transaction.getMember().getId() != null) {
            Member member = memberRepository.findById(transaction.getMember().getId())
                    .orElseThrow(() -> new RuntimeException("Linked member not found."));
            transaction.setMember(member);
        }

        // 5. Generate transaction number
        transaction.setTransactionNo("TXN" + System.currentTimeMillis());
        transaction.setTransactionDate(LocalDateTime.now());
        transaction.setStatus("ACTIVE");

        return transactionRepository.save(transaction);
    }

    // Reverse/Cancel a transaction
    @Transactional
    public Transaction reverseTransaction(Long id) {
        Transaction txn = transactionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Transaction not found with ID: " + id));

        if ("REVERSED".equalsIgnoreCase(txn.getStatus())) {
            throw new RuntimeException("Transaction is already reversed.");
        }

        // Mark as REVERSED
        txn.setStatus("REVERSED");
        Transaction savedTxn = transactionRepository.save(txn);

        // Create a counter-balancing transaction to keep ledger correct
        Transaction counterTxn = new Transaction();
        counterTxn.setMember(txn.getMember());
        counterTxn.setTransactionType(txn.getTransactionType());
        counterTxn.setAmount(txn.getAmount());
        counterTxn.setType("DEBIT".equalsIgnoreCase(txn.getType()) ? "CREDIT" : "DEBIT"); // Swap type
        counterTxn.setTransactionNo("REV-" + txn.getTransactionNo());
        counterTxn.setTransactionDate(LocalDateTime.now());
        counterTxn.setReferenceNo(txn.getTransactionNo());
        counterTxn.setDescription("Reversal entry for Transaction " + txn.getTransactionNo() + ": " + txn.getDescription());
        counterTxn.setStatus("ACTIVE");
        transactionRepository.save(counterTxn);

        return savedTxn;
    }

    public List<TransactionType> getAllTransactionTypes() {
        return transactionTypeRepository.findAll();
    }
}
