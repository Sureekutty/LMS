package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "miscellaneous_payments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MiscellaneousPayment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "voucher_no", nullable = false, unique = true, length = 30)
    private String voucherNo;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member; // Optional (e.g. general expense or tied to a member)

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 10)
    private String type; // INCOME, EXPENSE

    @Column(nullable = false, length = 50)
    private String category; // ADMISSION_FEE, PENALTY, WELFARE_FUND, OFFICE_EXPENSE, STATIONERY, OTHER

    @Column(name = "payment_date", nullable = false)
    private LocalDateTime paymentDate;

    @Column(name = "payment_mode", nullable = false, length = 20)
    private String paymentMode; // CASH, BANK

    @Column(length = 250)
    private String description;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (paymentDate == null) {
            paymentDate = LocalDateTime.now();
        }
    }
}
