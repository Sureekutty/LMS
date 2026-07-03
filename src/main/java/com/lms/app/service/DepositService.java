package com.lms.app.service;

import com.lms.app.model.Deposit;
import com.lms.app.model.DepositType;
import com.lms.app.model.Member;
import com.lms.app.dto.ThriftUploadRecord;
import com.lms.app.repository.DepositRepository;
import com.lms.app.repository.DepositTypeRepository;
import com.lms.app.repository.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class DepositService {

    @Autowired
    private DepositRepository depositRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private DepositTypeRepository depositTypeRepository;

    @Autowired
    private InterestCalculationService interestCalculationService;

    public List<Deposit> getAllDeposits() {
        return depositRepository.findAll();
    }

    public Optional<Deposit> getDepositById(Long id) {
        return depositRepository.findById(id);
    }

    public List<Deposit> getDepositsByMemberId(Long memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Member not found with ID: " + memberId));
        return depositRepository.findByMember(member);
    }

    public List<Deposit> getDepositsByStatus(String status) {
        return depositRepository.findByStatus(status);
    }

    // Open/Create a new Deposit account
    public Deposit openDeposit(Deposit deposit) {
        if (deposit.getMember() == null || deposit.getMember().getId() == null) {
            throw new RuntimeException("Deposit must be linked to a valid member.");
        }
        if (deposit.getDepositType() == null || deposit.getDepositType().getId() == null) {
            throw new RuntimeException("Deposit must have a valid deposit type.");
        }

        // 1. Fetch and validate Member
        Member member = memberRepository.findById(deposit.getMember().getId())
                .orElseThrow(() -> new RuntimeException("Linked member not found."));

        // 2. Fetch and validate DepositType
        DepositType depositType = depositTypeRepository.findById(deposit.getDepositType().getId())
                .orElseThrow(() -> new RuntimeException("Deposit type not found."));

        // 3. Set properties
        deposit.setMember(member);
        deposit.setDepositType(depositType);
        
        // Auto-generate unique deposit number
        String generatedNo = "DEP" + System.currentTimeMillis();
        deposit.setDepositNo(generatedNo);

        if (deposit.getOpenDate() == null) {
            deposit.setOpenDate(LocalDate.now());
        }

        // Calculate maturity date
        deposit.setMaturityDate(deposit.getOpenDate().plusMonths(deposit.getDurationMonths()));

        // 4. Determine interest rate (fetch from rules or fall back to default)
        BigDecimal rate;
        try {
            rate = interestCalculationService.getApplicableRate(
                    depositType.getTypeCode(), 
                    deposit.getPrincipalAmount(), 
                    deposit.getDurationMonths()
            );
        } catch (Exception e) {
            // Fall back to the default interest rate stored on the DepositType master record
            rate = depositType.getDefaultInterestRate();
        }
        deposit.setInterestRate(rate);

        // 5. Calculate maturity amount
        BigDecimal maturityAmount;
        if ("FD".equalsIgnoreCase(depositType.getTypeCode())) {
            // Compound quarterly (compounding frequency = 4)
            BigDecimal interest = interestCalculationService.calculateCompoundInterest(
                    deposit.getPrincipalAmount(), 
                    deposit.getInterestRate(), 
                    deposit.getDurationMonths(), 
                    4
            );
            maturityAmount = deposit.getPrincipalAmount().add(interest);
        } else if ("RD".equalsIgnoreCase(depositType.getTypeCode()) || "RCD".equalsIgnoreCase(depositType.getTypeCode())) {
            // Use legacy multi-bracket compounding formula for RD/RCD
            maturityAmount = interestCalculationService.calculateRCDMaturity(
                    deposit.getPrincipalAmount(), 
                    deposit.getInterestRate(), 
                    deposit.getDurationMonths()
            );
        } else {
            // Simple interest
            BigDecimal interest = interestCalculationService.calculateSimpleInterest(
                    deposit.getPrincipalAmount(), 
                    deposit.getInterestRate(), 
                    deposit.getDurationMonths()
            );
            maturityAmount = deposit.getPrincipalAmount().add(interest);
        }
        deposit.setMaturityAmount(maturityAmount);
        deposit.setStatus("ACTIVE");

        return depositRepository.save(deposit);
    }

    // Close/Liquidate an active deposit
    public Deposit closeDeposit(Long id) {
        Deposit deposit = depositRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Deposit account not found with ID: " + id));
        
        if ("CLOSED".equalsIgnoreCase(deposit.getStatus())) {
            throw new RuntimeException("Deposit account is already closed.");
        }

        deposit.setStatus("CLOSED");
        return depositRepository.save(deposit);
    }

    public List<DepositType> getAllDepositTypes() {
        return depositTypeRepository.findAll();
    }

    @Transactional
    public void processThriftBulkUpload(List<ThriftUploadRecord> records) {
        for (ThriftUploadRecord record : records) {
            Optional<Member> memberOpt = Optional.empty();
            if (record.getStaffCode() != null && !record.getStaffCode().trim().isEmpty()) {
                memberOpt = memberRepository.findByStaffCode(record.getStaffCode());
            }
            if (memberOpt.isEmpty() && record.getMembershipNo() != null && !record.getMembershipNo().trim().isEmpty()) {
                memberOpt = memberRepository.findByMembershipNo(record.getMembershipNo());
            }

            Member member = memberOpt.orElseThrow(() -> new RuntimeException("Member not found for staffCode: " + record.getStaffCode() + " / membershipNo: " + record.getMembershipNo()));
            BigDecimal newBal = member.getThriftDeposit() != null ? member.getThriftDeposit().add(record.getAmount()) : record.getAmount();
            member.setThriftDeposit(newBal);
            memberRepository.save(member);
        }
    }
}
