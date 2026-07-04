package com.lms.app.service;

import com.lms.app.model.*;
import com.lms.app.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class BillService {

    @Autowired
    private BillRepository billRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private MonthlyProcessService monthlyProcessService;

    @Autowired
    private MonthlyProcessRepository monthlyProcessRepository;

    @Autowired
    private ThriftService thriftService;

    @Transactional
    public List<Bill> generateBills(String processMonth) {
        // 1. Delete previous bills for this month to avoid duplicates
        billRepository.deleteByProcessMonth(processMonth);

        // 2. Generate expected MonthlyProcesses (Loans, RDs)
        monthlyProcessService.generateMonthlyProcess(processMonth);

        // 3. Roll up demands for each member
        List<Member> activeMembers = memberRepository.findAll().stream()
                .filter(Member::getIsActive)
                .toList();

        List<Bill> generatedBills = new ArrayList<>();

        for (Member member : activeMembers) {
            // Fetch all pending monthly process demands for this member and month
            List<MonthlyProcess> demands = monthlyProcessRepository.findByProcessMonth(processMonth).stream()
                    .filter(p -> p.getMember().getId().equals(member.getId()))
                    .toList();

            BigDecimal loanPrincipal = BigDecimal.ZERO;
            BigDecimal loanInterest = BigDecimal.ZERO;
            BigDecimal rdDue = BigDecimal.ZERO;
            // Default thrift savings demand contribution is ₹500
            BigDecimal thriftSub = new BigDecimal("500.00");

            for (MonthlyProcess demand : demands) {
                if ("LOAN_PRINCIPAL".equalsIgnoreCase(demand.getPurpose())) {
                    loanPrincipal = loanPrincipal.add(demand.getExpectedAmount());
                } else if ("LOAN_INTEREST".equalsIgnoreCase(demand.getPurpose())) {
                    loanInterest = loanInterest.add(demand.getExpectedAmount());
                } else if ("DEPOSIT_RCD".equalsIgnoreCase(demand.getPurpose())) {
                    rdDue = rdDue.add(demand.getExpectedAmount());
                }
            }

            BigDecimal total = loanPrincipal.add(loanInterest).add(rdDue).add(thriftSub);

            Bill bill = new Bill();
            bill.setBillNo("BILL-" + processMonth.replace("-", "") + "-" + String.format("%04d", member.getId()));
            bill.setProcessMonth(processMonth);
            bill.setMember(member);
            bill.setThriftContribution(thriftSub);
            bill.setLoanPrincipalDue(loanPrincipal);
            bill.setLoanInterestDue(loanInterest);
            bill.setRecurringDepositDue(rdDue);
            bill.setTotalAmount(total);
            bill.setAmountPaid(BigDecimal.ZERO);
            bill.setStatus("PENDING");

            generatedBills.add(billRepository.save(bill));
        }

        return generatedBills;
    }

    @Transactional
    public Bill payBill(Long billId, BigDecimal payAmount) {
        Bill bill = billRepository.findById(billId)
                .orElseThrow(() -> new IllegalArgumentException("Bill not found."));

        if ("PAID".equalsIgnoreCase(bill.getStatus())) {
            return bill;
        }

        BigDecimal remainingToPay = payAmount;
        BigDecimal newAmountPaid = bill.getAmountPaid().add(payAmount);

        if (newAmountPaid.compareTo(bill.getTotalAmount()) > 0) {
            throw new IllegalArgumentException("Payment amount exceeds outstanding bill total.");
        }

        bill.setAmountPaid(newAmountPaid);
        if (newAmountPaid.compareTo(bill.getTotalAmount()) == 0) {
            bill.setStatus("PAID");
        } else {
            bill.setStatus("PARTIAL");
        }

        // Apply recoveries to backing monthly processes:
        List<MonthlyProcess> demands = monthlyProcessRepository.findByProcessMonth(bill.getProcessMonth()).stream()
                .filter(p -> p.getMember().getId().equals(bill.getMember().getId()) && !"RECOVERED".equalsIgnoreCase(p.getStatus()))
                .toList();

        // 1. Pay loan interest first
        for (MonthlyProcess demand : demands) {
            if ("LOAN_INTEREST".equalsIgnoreCase(demand.getPurpose()) && remainingToPay.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal expected = demand.getExpectedAmount();
                BigDecimal toPay = remainingToPay.min(expected);
                monthlyProcessService.postRecovery(demand.getId(), toPay);
                remainingToPay = remainingToPay.subtract(toPay);
            }
        }

        // 2. Pay loan principal next
        for (MonthlyProcess demand : demands) {
            if ("LOAN_PRINCIPAL".equalsIgnoreCase(demand.getPurpose()) && remainingToPay.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal expected = demand.getExpectedAmount();
                BigDecimal toPay = remainingToPay.min(expected);
                monthlyProcessService.postRecovery(demand.getId(), toPay);
                remainingToPay = remainingToPay.subtract(toPay);
            }
        }

        // 3. Pay RD Deposit next
        for (MonthlyProcess demand : demands) {
            if ("DEPOSIT_RCD".equalsIgnoreCase(demand.getPurpose()) && remainingToPay.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal expected = demand.getExpectedAmount();
                BigDecimal toPay = remainingToPay.min(expected);
                monthlyProcessService.postRecovery(demand.getId(), toPay);
                remainingToPay = remainingToPay.subtract(toPay);
            }
        }

        // 4. Pay Thrift Contribution
        if (remainingToPay.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal expectedThrift = bill.getThriftContribution();
            BigDecimal toPay = remainingToPay.min(expectedThrift);

            ThriftTransaction thriftTxn = new ThriftTransaction();
            thriftTxn.setMember(bill.getMember());
            thriftTxn.setAmount(toPay);
            thriftTxn.setTransactionType("CONTRIBUTION");
            thriftTxn.setRemarks("Monthly Billing Contribution: " + bill.getProcessMonth());
            thriftService.recordTransaction(thriftTxn);

            remainingToPay = remainingToPay.subtract(toPay);
        }

        return billRepository.save(bill);
    }
}
