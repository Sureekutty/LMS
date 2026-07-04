package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "deposits")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Deposit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "deposit_no", nullable = false, unique = true, length = 20)
    private String depositNo;

    @ManyToOne
    @JoinColumn(name = "deposit_type_id", nullable = false)
    private DepositType depositType; // Links to master DepositType (FD, RD, TD)

    @Column(name = "principal_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal principalAmount; // For FD: lump sum. For RD: monthly installment.

    @Column(name = "interest_rate", nullable = false, precision = 5, scale = 2)
    private BigDecimal interestRate;

    @Column(name = "open_date", nullable = false)
    private LocalDate openDate;

    @Column(name = "duration_months", nullable = false)
    private Integer durationMonths;

    @Column(name = "maturity_date", nullable = false)
    private LocalDate maturityDate;

    @Column(name = "maturity_amount", precision = 12, scale = 2)
    private BigDecimal maturityAmount;

    @Column(nullable = false, length = 20)
    private String status = "ACTIVE"; // ACTIVE, MATURED, CLOSED, PREMATURE_CLOSED

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
