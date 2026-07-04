package com.lms.app.service;

import com.lms.app.model.InterestRate;
import com.lms.app.model.LoanRepayment;
import com.lms.app.repository.InterestRateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

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

    /**
     * Calculate RCD (Recurring Deposit) Compounding Maturity value based on legacy SP_Calculations.sql brackets.
     */
    public BigDecimal calculateRCDMaturity(BigDecimal amount, BigDecimal annualRate, Integer durationMonths) {
        if (amount == null || annualRate == null || durationMonths == null || durationMonths <= 0) {
            return BigDecimal.ZERO;
        }

        double p = amount.doubleValue();
        double r = annualRate.doubleValue();
        int dur = durationMonths;

        double m1 = 0;
        double m2 = 0;
        double m3 = 0;
        double m4 = 0;
        double m5 = 0;
        double maturity = 0;

        if (dur <= 12) {
            m1 = (p * r * (dur * (dur + 1))) / 2400.0;
            maturity = m1 + (dur * p);
        } else if (dur <= 24) {
            m1 = (p * r * (12 * 13)) / 2400.0;
            m2 = ((p * r * ((dur - 12) * (dur - 12 + 1))) / 2400.0) + (((m1 + 12 * p) * r * (dur - 12)) / 1200.0);
            maturity = m1 + m2 + (dur * p);
        } else if (dur <= 36) {
            m1 = (p * r * (12 * 13)) / 2400.0;
            m2 = (p * r * (12 * 13)) / 2400.0 + ((m1 + 12 * p) * r) / 100.0;
            m3 = ((p * r * ((dur - 24) * (dur - 24 + 1))) / 2400.0) + (((m1 + m2 + 24 * p) * r * (dur - 24)) / 1200.0);
            maturity = m1 + m2 + m3 + (dur * p);
        } else if (dur <= 48) {
            m1 = (p * r * (12 * 13)) / 2400.0;
            m2 = (p * r * (12 * 13)) / 2400.0 + ((m1 + 12 * p) * r) / 100.0;
            m3 = (p * r * (12 * 13)) / 2400.0 + ((m1 + m2 + 24 * p) * r) / 100.0;
            m4 = ((p * r * ((dur - 36) * (dur - 36 + 1))) / 2400.0) + (((m1 + m2 + m3 + 36 * p) * r * (dur - 36)) / 1200.0);
            maturity = m1 + m2 + m3 + m4 + (dur * p);
        } else { // 49 to 60 or more
            m1 = (p * r * (12 * 13)) / 2400.0;
            m2 = (p * r * (12 * 13)) / 2400.0 + ((m1 + 12 * p) * r) / 100.0;
            m3 = (p * r * (12 * 13)) / 2400.0 + ((m1 + m2 + 24 * p) * r) / 100.0;
            m4 = (p * r * (12 * 13)) / 2400.0 + ((m1 + m2 + m3 + 36 * p) * r) / 100.0;
            m5 = ((p * r * ((dur - 48) * (dur - 48 + 1))) / 2400.0) + (((m1 + m2 + m3 + m4 + 48 * p) * r * (dur - 48)) / 1200.0);
            maturity = Math.round(m1 + m2 + m3 + m4 + m5 + (dur * p));
        }

        return BigDecimal.valueOf(maturity).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculate daily-weighted interest for a loan over a calendar month, matching SP_getIntAmount.sql.
     */
    public BigDecimal calculateLoanInterestForMonth(
            BigDecimal amountSanctioned,
            BigDecimal annualRate,
            LocalDate disbursedDate,
            LocalDate monthStart,
            List<LoanRepayment> repayments,
            BigDecimal prevMonthEndingPrincipal) {

        if (annualRate == null || annualRate.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }

        int daysInMonth = monthStart.lengthOfMonth();
        BigDecimal totalInterest = BigDecimal.ZERO;
        BigDecimal dailyRate = annualRate.divide(BigDecimal.valueOf(12 * 100 * daysInMonth), 10, RoundingMode.HALF_UP);

        // Calculate active principal balance for each day of the month
        for (int day = 1; day <= daysInMonth; day++) {
            LocalDate currentDay = monthStart.withDayOfMonth(day);
            BigDecimal principalOnDay = BigDecimal.ZERO;

            if (disbursedDate != null && !currentDay.isBefore(disbursedDate)) {
                // If disbursed during this month, start with amountSanctioned
                principalOnDay = prevMonthEndingPrincipal != null && prevMonthEndingPrincipal.compareTo(BigDecimal.ZERO) > 0 
                        ? prevMonthEndingPrincipal 
                        : amountSanctioned;

                // Check if any repayments happened on or before currentDay in this month
                LocalDate finalCurrentDay = currentDay;
                Optional<LoanRepayment> lastRepaymentBeforeOrOnDay = repayments.stream()
                        .filter(r -> !r.getPaidDate().isAfter(finalCurrentDay))
                        .reduce((first, second) -> second); // Get the last repayment up to this day

                if (lastRepaymentBeforeOrOnDay.isPresent()) {
                    principalOnDay = lastRepaymentBeforeOrOnDay.get().getClosingBalance();
                }
            }

            if (principalOnDay.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal dayInterest = principalOnDay.multiply(dailyRate);
                totalInterest = totalInterest.add(dayInterest);
            }
        }

        return totalInterest.setScale(2, RoundingMode.HALF_UP);
    }
}
