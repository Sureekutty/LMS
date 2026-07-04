package com.lms.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lms.app.model.Loan;
import com.lms.app.model.LoanRepayment;

import java.util.List;

@Repository
public interface LoanRepaymentRepository extends JpaRepository<LoanRepayment, Long> {
    
    List<LoanRepayment> findByLoan(Loan loan);
    
    List<LoanRepayment> findByLoanAndStatus(Loan loan, String status);
    
    long countByLoanAndStatus(Loan loan, String status);
}