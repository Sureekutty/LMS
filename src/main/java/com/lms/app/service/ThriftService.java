package com.lms.app.service;

import com.lms.app.model.Member;
import com.lms.app.model.ThriftTransaction;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.ThriftTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ThriftService {

    @Autowired
    private ThriftTransactionRepository thriftTransactionRepository;

    @Autowired
    private MemberRepository memberRepository;

    public List<ThriftTransaction> getAllTransactions() {
        return thriftTransactionRepository.findAll();
    }

    public List<ThriftTransaction> getTransactionsByMemberId(Long memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Member not found with ID: " + memberId));
        return thriftTransactionRepository.findByMemberOrderByTransactionDateDesc(member);
    }

    // Get current thrift balance of a member
    public BigDecimal getCurrentBalance(Member member) {
        List<ThriftTransaction> txns = thriftTransactionRepository.findLatestTransaction(member);
        if (txns.isEmpty()) {
            return BigDecimal.ZERO;
        }
        return txns.get(0).getClosingBalance();
    }

    // Record a new thrift transaction
    @Transactional
    public ThriftTransaction recordTransaction(ThriftTransaction txn) {
        if (txn.getMember() == null || txn.getMember().getId() == null) {
            throw new RuntimeException("Transaction must be linked to a valid member.");
        }

        // 1. Fetch member
        Member member = memberRepository.findById(txn.getMember().getId())
                .orElseThrow(() -> new RuntimeException("Member not found."));

        if (!member.getIsActive()) {
            throw new RuntimeException("Cannot perform thrift transactions for an inactive member.");
        }

        // 2. Fetch current balance
        BigDecimal currentBalance = getCurrentBalance(member);
        txn.setOpeningBalance(currentBalance);

        // 3. Process amount validation
        BigDecimal amount = txn.getAmount();
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Transaction amount must be greater than zero.");
        }

        String type = txn.getTransactionType();
        if (type == null) {
            throw new RuntimeException("Transaction type is required.");
        }

        BigDecimal closingBalance;
        if ("CONTRIBUTION".equalsIgnoreCase(type) || "INTEREST".equalsIgnoreCase(type)) {
            closingBalance = currentBalance.add(amount);
            // Auto-generate receipt number for contributions if not provided
            if ("CONTRIBUTION".equalsIgnoreCase(type) && txn.getReceiptNo() == null) {
                txn.setReceiptNo("REC-TH-" + System.currentTimeMillis());
            }
        } else if ("WITHDRAWAL".equalsIgnoreCase(type)) {
            if (currentBalance.compareTo(amount) < 0) {
                throw new RuntimeException("Insufficient balance for withdrawal. Current balance: " + currentBalance);
            }
            closingBalance = currentBalance.subtract(amount);
        } else {
            throw new RuntimeException("Invalid transaction type. Allowed: CONTRIBUTION, WITHDRAWAL, INTEREST.");
        }

        txn.setMember(member);
        txn.setClosingBalance(closingBalance);
        txn.setTransactionDate(LocalDateTime.now());

        ThriftTransaction savedTxn = thriftTransactionRepository.save(txn);

        // 4. Update the Member's aggregate thrift balance
        member.setThriftDeposit(closingBalance);
        memberRepository.save(member);

        return savedTxn;
    }
}
