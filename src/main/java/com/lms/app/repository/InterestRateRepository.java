package com.lms.app.repository;

import com.lms.app.model.InterestRate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface InterestRateRepository extends JpaRepository<InterestRate, Long> {
    
    // Find all rates for a specific code (e.g. personal loan, FD)
    List<InterestRate> findByTypeCode(String typeCode);

    // Find active rates for a specific product code
    List<InterestRate> findByTypeCodeAndIsActiveTrue(String typeCode);

    // Find applicable interest rate based on product code, amount, tenure and date range
    @Query("SELECT r FROM InterestRate r WHERE r.typeCode = :typeCode " +
           "AND r.isActive = true " +
           "AND (r.minAmount IS NULL OR :amount >= r.minAmount) " +
           "AND (r.maxAmount IS NULL OR :amount <= r.maxAmount) " +
           "AND (r.minTenureMonths IS NULL OR :tenure >= r.minTenureMonths) " +
           "AND (r.maxTenureMonths IS NULL OR :tenure <= r.maxTenureMonths) " +
           "AND r.effectiveFrom <= :date " +
           "AND (r.effectiveTo IS NULL OR r.effectiveTo >= :date)")
    Optional<InterestRate> findApplicableRate(
            @Param("typeCode") String typeCode,
            @Param("amount") BigDecimal amount,
            @Param("tenure") Integer tenure,
            @Param("date") LocalDate date);
}
