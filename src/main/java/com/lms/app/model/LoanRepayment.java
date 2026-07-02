package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "loan_repayments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoanRepayment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "loan_id", nullable = false)
    private Loan loan;

    @Column(name = "installment_no")
    private Integer installmentNo;

    @Column(precision = 10, scale = 2)
    private BigDecimal amount;

    @Column(name = "paid_date")
    private LocalDate paidDate;

    @Column(length = 20)
    private String status = "PENDING";

    // ===== NEW FIELDS FOR LMS =====

    @Column(name = "pay_code", length = 3)
    private String payCode;

    @Column(name = "principal_or_interest", length = 1)
    private String principalOrInterest;

    @Column(name = "mode_of_payment", length = 15)
    private String modeOfPayment;

    @Column(name = "receipt_no", length = 14)
    private String receiptNo;

    @Column(name = "closing_balance", precision = 12, scale = 2)
    private BigDecimal closingBalance;

    // ===== END NEW FIELDS =====

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}