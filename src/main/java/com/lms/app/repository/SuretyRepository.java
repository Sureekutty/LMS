package com.lms.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lms.app.model.Loan;
import com.lms.app.model.Member;
import com.lms.app.model.Surety;

import java.util.List;

@Repository
public interface SuretyRepository extends JpaRepository<Surety, Long> {
    
    List<Surety> findByLoan(Loan loan);
    
    List<Surety> findByMember(Member member);
}