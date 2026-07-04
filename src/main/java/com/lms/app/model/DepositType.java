package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "deposit_types")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DepositType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "type_code", nullable = false, unique = true, length = 10)
    private String typeCode;

    @Column(name = "type_name", nullable = false, length = 100)
    private String typeName;

    @Column(name = "default_interest_rate", precision = 5, scale = 2)
    private BigDecimal defaultInterestRate;

    @Column(name = "min_duration_months")
    private Integer minDurationMonths;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
