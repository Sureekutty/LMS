package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "bank_transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BankTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "bank_account_id", nullable = false)
    private BankAccount bankAccount;

    @Column(name = "transaction_no", nullable = false, unique = true, length = 20)
    private String transactionNo;

    @Column(name = "transaction_date", nullable = false)
    private LocalDateTime transactionDate;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 10)
    private String type; // DEBIT (Deposit/Inward), CREDIT (Withdrawal/Outward)

    @Column(name = "reference_no", length = 30)
    private String referenceNo; // Cheque / UTR number

    @Column(length = 250)
    private String description;

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
