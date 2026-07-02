package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "shares")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Share {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "share_certificate_no", nullable = false, unique = true, length = 30)
    private String shareCertificateNo;

    @Column(name = "number_of_shares", nullable = false)
    private Integer numberOfShares;

    @Column(name = "share_value", nullable = false, precision = 10, scale = 2)
    private BigDecimal shareValue = BigDecimal.valueOf(10.00); // Default standard share price: ₹10

    @Column(name = "capital_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal capitalAmount; // numberOfShares * shareValue

    @Column(name = "purchase_date", nullable = false)
    private LocalDate purchaseDate;

    @Column(name = "receipt_no", length = 20)
    private String receiptNo;

    @Column(nullable = false, length = 20)
    private String status = "ACTIVE"; // ACTIVE, TRANSFERRED, REDEEMED

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (purchaseDate == null) {
            purchaseDate = LocalDate.now();
        }
        if (shareValue == null) {
            shareValue = BigDecimal.valueOf(10.00);
        }
        if (numberOfShares != null) {
            capitalAmount = shareValue.multiply(BigDecimal.valueOf(numberOfShares));
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
        if (shareValue != null && numberOfShares != null) {
            capitalAmount = shareValue.multiply(BigDecimal.valueOf(numberOfShares));
        }
    }
}
