package com.speccs.lms.repository;

import com.speccs.lms.model.Loan;
import com.speccs.lms.model.LoanRepayment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface LoanRepaymentRepository extends JpaRepository<LoanRepayment, Long> {
    
    List<LoanRepayment> findByLoan(Loan loan);
    
    List<LoanRepayment> findByLoanAndStatus(Loan loan, String status);
    
    long countByLoanAndStatus(Loan loan, String status);
}