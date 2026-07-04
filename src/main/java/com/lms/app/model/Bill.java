package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "bills")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Bill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "bill_no", nullable = false, unique = true, length = 30)
    private String billNo;

    @Column(name = "process_month", nullable = false, length = 7) // format: YYYY-MM
    private String processMonth;

    @ManyToOne(optional = false)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "thrift_contribution", nullable = false, precision = 12, scale = 2)
    private BigDecimal thriftContribution = BigDecimal.ZERO;

    @Column(name = "loan_principal_due", nullable = false, precision = 12, scale = 2)
    private BigDecimal loanPrincipalDue = BigDecimal.ZERO;

    @Column(name = "loan_interest_due", nullable = false, precision = 12, scale = 2)
    private BigDecimal loanInterestDue = BigDecimal.ZERO;

    @Column(name = "recurring_deposit_due", nullable = false, precision = 12, scale = 2)
    private BigDecimal recurringDepositDue = BigDecimal.ZERO;

    @Column(name = "total_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Column(name = "amount_paid", nullable = false, precision = 12, scale = 2)
    private BigDecimal amountPaid = BigDecimal.ZERO;

    @Column(nullable = false, length = 15)
    private String status = "PENDING"; // PENDING, PARTIAL, PAID

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
