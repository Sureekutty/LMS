package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "deposit_transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DepositTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "deposit_id", nullable = false)
    private Deposit deposit;

    @Column(name = "transaction_date", nullable = false)
    private LocalDateTime transactionDate;

    @Column(name = "transaction_type", nullable = false, length = 20)
    private String transactionType; // DEPOSIT, WITHDRAWAL, INTEREST

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(name = "opening_balance", nullable = false, precision = 12, scale = 2)
    private BigDecimal openingBalance;

    @Column(name = "closing_balance", nullable = false, precision = 12, scale = 2)
    private BigDecimal closingBalance;

    @Column(name = "receipt_no", length = 20)
    private String receiptNo;

    @Column(length = 250)
    private String remarks;

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
