package com.lms.app.service;

import com.lms.app.model.Loan;
import com.lms.app.model.Member;
import com.lms.app.model.Surety;
import com.lms.app.repository.LoanRepository;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.SuretyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SuretyService {

    @Autowired
    private SuretyRepository suretyRepository;

    @Autowired
    private LoanRepository loanRepository;

    @Autowired
    private MemberRepository memberRepository;

    public List<Surety> getAllSureties() {
        return suretyRepository.findAll();
    }

    public List<Surety> getSuretiesByLoanId(Long loanId) {
        Loan loan = loanRepository.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found with ID: " + loanId));
        return suretyRepository.findByLoan(loan);
    }

    public List<Surety> getGuaranteedLoansByMemberId(Long memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Member not found with ID: " + memberId));
        return suretyRepository.findByMember(member);
    }

    @Transactional
    public Surety addSurety(Long loanId, Long memberId) {
        // 1. Fetch and validate Loan
        Loan loan = loanRepository.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found."));

        if ("CLOSED".equalsIgnoreCase(loan.getStatus())) {
            throw new RuntimeException("Cannot add guarantors to a closed loan account.");
        }

        // 2. Fetch and validate Member (Guarantor)
        Member guarantor = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Guarantor member not found."));

        if (!guarantor.getIsActive()) {
            throw new RuntimeException("An inactive member cannot act as a loan guarantor.");
        }

        // 3. Rule: Member cannot guarantee their own loan
        if (loan.getMember().getId().equals(memberId)) {
            throw new RuntimeException("A member cannot act as a guarantor for their own loan.");
        }

        // 4. Rule: Member cannot act as surety for more than 3 active loans
        List<Surety> existingGuarantees = suretyRepository.findByMember(guarantor);
        long activeGuaranteesCount = existingGuarantees.stream()
                .filter(s -> !"CLOSED".equalsIgnoreCase(s.getLoan().getStatus()) && !"REJECTED".equalsIgnoreCase(s.getLoan().getStatus()))
                .count();

        if (activeGuaranteesCount >= 3) {
            throw new RuntimeException("Member '" + guarantor.getName() + "' is already acting as a guarantor for the maximum limit of 3 active loans.");
        }

        // 5. Rule: Check if already a surety for this specific loan
        List<Surety> loanSureties = suretyRepository.findByLoan(loan);
        boolean alreadyExists = loanSureties.stream()
                .anyMatch(s -> s.getMember().getId().equals(memberId));

        if (alreadyExists) {
            throw new RuntimeException("Member is already acting as a guarantor for this loan.");
        }

        // 6. Create Surety record
        Surety surety = new Surety();
        surety.setLoan(loan);
        surety.setMember(guarantor);
        surety.setSuretyOrder(loanSureties.size() + 1);
        surety.setStatus("ACTIVE");

        return suretyRepository.save(surety);
    }

    @Transactional
    public void removeSurety(Long id) {
        Surety surety = suretyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Surety record not found with ID: " + id));

        if (!"CLOSED".equalsIgnoreCase(surety.getLoan().getStatus())) {
            // Re-order remaining guarantors for the loan
            List<Surety> remaining = suretyRepository.findByLoan(surety.getLoan()).stream()
                    .filter(s -> !s.getId().equals(id))
                    .collect(Collectors.toList());
            
            for (int i = 0; i < remaining.size(); i++) {
                remaining.get(i).setSuretyOrder(i + 1);
                suretyRepository.save(remaining.get(i));
            }
        }
        
        suretyRepository.deleteById(id);
    }
}
