package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "monthly_processes")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MonthlyProcess {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "process_month", nullable = false, length = 7) // format: YYYY-MM
    private String processMonth;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "purpose", nullable = false, length = 30) // LOAN_PRINCIPAL, LOAN_INTEREST, DEPOSIT_RCD, THRIFT_SUB
    private String purpose;

    @Column(name = "reference_no", length = 30) // Loan Account No or Deposit No
    private String referenceNo;

    @Column(name = "expected_amount", precision = 12, scale = 2)
    private BigDecimal expectedAmount = BigDecimal.ZERO;

    @Column(name = "recovered_amount", precision = 12, scale = 2)
    private BigDecimal recoveredAmount = BigDecimal.ZERO;

    @Column(name = "recovered_date")
    private LocalDate recoveredDate;

    @Column(name = "status", length = 15) // PENDING, RECOVERED
    private String status = "PENDING";

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
