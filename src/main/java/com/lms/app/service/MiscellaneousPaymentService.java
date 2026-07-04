package com.lms.app.service;

import com.lms.app.model.*;
import com.lms.app.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class MiscellaneousPaymentService {

    @Autowired
    private MiscellaneousPaymentRepository miscellaneousPaymentRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private TransactionTypeRepository transactionTypeRepository;

    @Autowired
    private MemberRepository memberRepository;

    public List<MiscellaneousPayment> getAllPayments() {
        return miscellaneousPaymentRepository.findByOrderByPaymentDateDesc();
    }

    @Transactional
    public MiscellaneousPayment postPayment(MiscellaneousPayment payment) {
        if (payment.getAmount() == null || payment.getAmount().compareTo(java.math.BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero.");
        }

        payment.setVoucherNo("MISC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        payment.setPaymentDate(LocalDateTime.now());

        if (payment.getMember() != null && payment.getMember().getId() != null) {
            Member member = memberRepository.findById(payment.getMember().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Linked member not found."));
            payment.setMember(member);
        }

        MiscellaneousPayment savedPayment = miscellaneousPaymentRepository.save(payment);

        // Generate backing general ledger Transaction
        Transaction txn = new Transaction();
        txn.setMember(savedPayment.getMember());
        txn.setAmount(savedPayment.getAmount());
        txn.setReferenceNo(savedPayment.getVoucherNo());
        txn.setDescription("[" + savedPayment.getCategory() + "] " + savedPayment.getDescription());
        
        // Resolve Transaction Type: RECPT (Receipt) for INCOME, PYMNT (Payment) for EXPENSE
        String typeCode = "INCOME".equalsIgnoreCase(savedPayment.getType()) ? "RECPT" : "PYMNT";
        TransactionType type = transactionTypeRepository.findByTypeCode(typeCode)
                .orElseGet(() -> {
                    TransactionType fallback = new TransactionType();
                    fallback.setTypeCode(typeCode);
                    fallback.setTypeName("INCOME".equalsIgnoreCase(savedPayment.getType()) ? "Receipt" : "Payment");
                    fallback.setIsActive(true);
                    return transactionTypeRepository.save(fallback);
                });
        txn.setTransactionType(type);

        // In LMS accounting rules:
        // Receipt (INCOME) increases cash = DEBIT
        // Payment (EXPENSE) decreases cash = CREDIT
        txn.setType("INCOME".equalsIgnoreCase(savedPayment.getType()) ? "DEBIT" : "CREDIT");
        txn.setTransactionNo("TXN-" + savedPayment.getVoucherNo());
        txn.setStatus("ACTIVE");
        
        transactionRepository.save(txn);

        return savedPayment;
    }
}
