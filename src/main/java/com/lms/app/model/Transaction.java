package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member; // Linked member (optional for general society expenses/vouchers)

    @Column(name = "transaction_no", nullable = false, unique = true, length = 20)
    private String transactionNo; // Unique voucher or transaction number

    @ManyToOne
    @JoinColumn(name = "transaction_type_id", nullable = false)
    private TransactionType transactionType; // Master TransactionType (LD, LR, DEP, WDR, etc.)

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 10)
    private String type; // DEBIT or CREDIT

    @Column(name = "transaction_date", nullable = false)
    private LocalDateTime transactionDate;

    @Column(name = "reference_no", length = 30)
    private String referenceNo; // e.g. Loan ID, Repayment ID, or Receipt Number

    @Column(length = 250)
    private String description;

    @Column(nullable = false, length = 15)
    private String status = "ACTIVE"; // ACTIVE, REVERSED

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (transactionDate == null) {
            transactionDate = LocalDateTime.now();
        }
    }
}
