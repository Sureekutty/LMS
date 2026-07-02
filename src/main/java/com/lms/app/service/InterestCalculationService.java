package com.lms.app.service;

import com.lms.app.model.InterestRate;
import com.lms.app.repository.InterestRateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

@Service
public class InterestCalculationService {

    @Autowired
    private InterestRateRepository interestRateRepository;

    /**
     * Get applicable interest rate for a product based on amount and tenure today.
     */
    public BigDecimal getApplicableRate(String typeCode, BigDecimal amount, Integer tenureMonths) {
        return interestRateRepository.findApplicableRate(typeCode, amount, tenureMonths, LocalDate.now())
                .map(InterestRate::getInterestRate)
                .orElseThrow(() -> new RuntimeException("No active interest rate rule found for type: " + typeCode 
                        + " with amount: " + amount + " and tenure: " + tenureMonths));
    }

    /**
     * Calculate Simple Interest.
     * SI = (Principal * Rate * TenureInMonths) / (12 * 100)
     */
    public BigDecimal calculateSimpleInterest(BigDecimal principal, BigDecimal annualRate, Integer tenureMonths) {
        if (principal == null || annualRate == null || tenureMonths == null) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal rateFraction = annualRate.divide(BigDecimal.valueOf(100), 10, RoundingMode.HALF_UP);
        BigDecimal timeInYears = BigDecimal.valueOf(tenureMonths).divide(BigDecimal.valueOf(12), 10, RoundingMode.HALF_UP);
        
        return principal.multiply(rateFraction).multiply(timeInYears).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculate Equated Monthly Installment (EMI) using Reducing Balance Method.
     * EMI = [P * r * (1 + r)^n] / [(1 + r)^n - 1]
     * where r = monthly interest rate = (Annual Rate / 12 / 100)
     * n = tenure in months
     */
    public BigDecimal calculateReducingEMI(BigDecimal principal, BigDecimal annualRate, Integer tenureMonths) {
        if (principal == null || annualRate == null || tenureMonths == null || tenureMonths <= 0) {
            return BigDecimal.ZERO;
        }
        
        // If interest rate is 0, EMI is simply Principal / Tenure
        if (annualRate.compareTo(BigDecimal.ZERO) == 0) {
            return principal.divide(BigDecimal.valueOf(tenureMonths), 2, RoundingMode.HALF_UP);
        }

        // r = annual rate / 12 / 100
        double r = annualRate.doubleValue() / 12.0 / 100.0;
        int n = tenureMonths;
        double p = principal.doubleValue();

        // Formula: EMI = (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1)
        double emi = (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);

        return BigDecimal.valueOf(emi).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculate Compound Interest (specifically for Fixed Deposits).
     * A = P * (1 + r/k)^(k * t)
     * Interest = A - P
     * where r = annual rate / 100
     * k = compounding frequency per year (e.g. 4 for quarterly)
     * t = time in years (tenureMonths / 12.0)
     */
    public BigDecimal calculateCompoundInterest(BigDecimal principal, BigDecimal annualRate, Integer tenureMonths, int compoundingFrequency) {
        if (principal == null || annualRate == null || tenureMonths == null || compoundingFrequency <= 0) {
            return BigDecimal.ZERO;
        }

        double p = principal.doubleValue();
        double r = annualRate.doubleValue() / 100.0;
        double t = tenureMonths.doubleValue() / 12.0;
        double k = compoundingFrequency;

        // Formula: A = P * Math.pow(1 + r/k, k * t)
        double amount = p * Math.pow(1 + (r / k), k * t);
        double interest = amount - p;

        return BigDecimal.valueOf(interest).setScale(2, RoundingMode.HALF_UP);
    }
}
