package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "loans")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "loan_no", nullable = false, unique = true, length = 20)
    private String loanNo;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "amount_applied", nullable = false, precision = 12, scale = 2)
    private BigDecimal amountApplied;

    @Column(name = "amount_sanctioned", precision = 12, scale = 2)
    private BigDecimal amountSanctioned;

    @Column(columnDefinition = "TEXT")
    private String purpose;

    @Column(name = "no_of_installments")
    private Integer noOfInstallments;

    @Column(name = "monthly_installment", precision = 10, scale = 2)
    private BigDecimal monthlyInstallment;

    @Column(name = "interest_rate", precision = 5, scale = 2)
    private BigDecimal interestRate;

    @Column(length = 30)
    private String status = "PENDING";

    @Column(name = "applied_date")
    private LocalDate appliedDate;

    @Column(name = "sanctioned_date")
    private LocalDate sanctionedDate;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}