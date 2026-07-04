package com.lms.app.service;

import com.lms.app.model.*;
import com.lms.app.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class MonthlyProcessService {

    @Autowired
    private MonthlyProcessRepository monthlyProcessRepository;

    @Autowired
    private LoanRepository loanRepository;

    @Autowired
    private LoanRepaymentRepository loanRepaymentRepository;

    @Autowired
    private DepositRepository depositRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private InterestCalculationService interestCalculationService;

    @Autowired
    private LoanRepaymentService loanRepaymentService;

    @Autowired
    private DepositTransactionService depositTransactionService;

    /**
     * Generate the expected monthly recovery schedule for a given month (format: YYYY-MM).
     */
    @Transactional
    public List<MonthlyProcess> generateMonthlyProcess(String monthStr) {
        // Clear previous calculations for the target month if they exist
        monthlyProcessRepository.deleteByProcessMonth(monthStr);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate monthStart = LocalDate.parse(monthStr + "-01", formatter);
        List<MonthlyProcess> processes = new ArrayList<>();

        // 1. Process Loans (LTL, EXL etc.)
        List<Loan> activeLoans = loanRepository.findAll().stream()
                .filter(l -> "ACTIVE".equalsIgnoreCase(l.getStatus()) || "RELEASED".equalsIgnoreCase(l.getStatus()))
                .toList();

        for (Loan loan : activeLoans) {
            BigDecimal principalBal = loan.getOutstandingPrincipal();
            if (principalBal == null || principalBal.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }

            // Expected principal installment
            BigDecimal expectedPrincipal = loan.getMonthlyInstallment();
            if (expectedPrincipal == null || expectedPrincipal.compareTo(principalBal) > 0) {
                expectedPrincipal = principalBal;
            }

            // Generate expected Principal recovery record
            MonthlyProcess principalProc = new MonthlyProcess(
                    null, monthStr, loan.getMember(), "LOAN_PRINCIPAL", loan.getLoanNo(),
                    expectedPrincipal, BigDecimal.ZERO, null, "PENDING", null
            );
            processes.add(monthlyProcessRepository.save(principalProc));

            // Generate expected Interest recovery record using daily weighted calculation
            LocalDate prevMonthStart = monthStart.minusMonths(1);
            List<LoanRepayment> repaymentsOfPrevMonth = loanRepaymentRepository.findByLoan(loan).stream()
                    .filter(r -> r.getPaidDate() != null && !r.getPaidDate().isBefore(prevMonthStart) && r.getPaidDate().isBefore(monthStart))
                    .toList();

            BigDecimal expectedInterest = interestCalculationService.calculateLoanInterestForMonth(
                    loan.getAmountSanctioned(), loan.getInterestRate(), loan.getDisbursedDate(),
                    prevMonthStart, repaymentsOfPrevMonth, loan.getOutstandingPrincipal()
            );

            if (expectedInterest.compareTo(BigDecimal.ZERO) > 0) {
                MonthlyProcess interestProc = new MonthlyProcess(
                        null, monthStr, loan.getMember(), "LOAN_INTEREST", loan.getLoanNo(),
                        expectedInterest, BigDecimal.ZERO, null, "PENDING", null
                );
                processes.add(monthlyProcessRepository.save(interestProc));
            }
        }

        // 2. Process Recurring Deposits (RCD)
        List<Deposit> activeRCDs = depositRepository.findAll().stream()
                .filter(d -> "ACTIVE".equalsIgnoreCase(d.getStatus()) && "RCD".equalsIgnoreCase(d.getDepositType().getTypeCode()))
                .toList();

        for (Deposit rcd : activeRCDs) {
            BigDecimal subscription = rcd.getPrincipalAmount();
            if (subscription == null) {
                subscription = BigDecimal.ZERO;
            }

            MonthlyProcess rcdProc = new MonthlyProcess(
                    null, monthStr, rcd.getMember(), "DEPOSIT_RCD", rcd.getDepositNo(),
                    subscription, BigDecimal.ZERO, null, "PENDING", null
            );
            processes.add(monthlyProcessRepository.save(rcdProc));
        }

        return processes;
    }

    /**
     * Post/Process actual monthly recoveries (salary uploads) dynamically.
     */
    @Transactional
    public void postRecovery(Long processId, BigDecimal recoveredAmount) {
        MonthlyProcess proc = monthlyProcessRepository.findById(processId)
                .orElseThrow(() -> new RuntimeException("Monthly process record not found."));

        if ("RECOVERED".equalsIgnoreCase(proc.getStatus())) {
            return;
        }

        proc.setRecoveredAmount(recoveredAmount);
        proc.setRecoveredDate(LocalDate.now());
        proc.setStatus("RECOVERED");
        monthlyProcessRepository.save(proc);

        // Perform actual account ledger actions based on category
        if ("LOAN_PRINCIPAL".equals(proc.getPurpose()) || "LOAN_INTEREST".equals(proc.getPurpose())) {
            Loan loan = loanRepository.findAll().stream()
                    .filter(l -> l.getLoanNo().equals(proc.getReferenceNo()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Loan not found: " + proc.getReferenceNo()));

            LoanRepayment repayment = new LoanRepayment();
            repayment.setLoan(loan);
            repayment.setAmount(recoveredAmount);
            repayment.setPaidDate(LocalDate.now());
            repayment.setPayCode(proc.getPurpose().substring(0, 3));
            repayment.setModeOfPayment("SALARY_DEDUCTION");
            loanRepaymentService.makeRepayment(repayment);
        } else if ("DEPOSIT_RCD".equals(proc.getPurpose())) {
            Deposit rcd = depositRepository.findAll().stream()
                    .filter(d -> d.getDepositNo().equals(proc.getReferenceNo()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("RD Deposit not found: " + proc.getReferenceNo()));

            DepositTransaction txn = new DepositTransaction();
            txn.setDeposit(rcd);
            txn.setAmount(recoveredAmount);
            txn.setTransactionType("DEPOSIT");
            txn.setTransactionDate(LocalDateTime.now());
            txn.setRemarks("Monthly RD Subscription Recovery");
            depositTransactionService.recordTransaction(txn);
        }
    }
}
