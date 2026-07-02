package com.lms.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lms.app.model.Loan;
import com.lms.app.model.Member;

import java.util.List;
import java.util.Optional;

@Repository
public interface LoanRepository extends JpaRepository<Loan, Long> {
    
    Optional<Loan> findByLoanNo(String loanNo);
    
    List<Loan> findByMember(Member member);
    
    List<Loan> findByStatus(String status);
    
    List<Loan> findByMemberAndStatus(Member member, String status);
    
    boolean existsByLoanNo(String loanNo);

    // ===== NEW QUERIES =====

    List<Loan> findByLoanType(String loanType);

    List<Loan> findByMemberAndLoanType(Member member, String loanType);

    long countByStatus(String status);

    List<Loan> findByClosedDateIsNull();
}