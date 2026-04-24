package com.speccs.lms.repository;

import com.speccs.lms.model.Loan;
import com.speccs.lms.model.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface LoanRepository extends JpaRepository<Loan, Long> {
    
    Optional<Loan> findByLoanNo(String loanNo);
    
    List<Loan> findByMember(Member member);
    
    List<Loan> findByStatus(String status);
    
    List<Loan> findByMemberAndStatus(Member member, String status);
    
    boolean existsByLoanNo(String loanNo);
}