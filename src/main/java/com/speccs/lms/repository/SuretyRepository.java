package com.speccs.lms.repository;

import com.speccs.lms.model.Loan;
import com.speccs.lms.model.Member;
import com.speccs.lms.model.Surety;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SuretyRepository extends JpaRepository<Surety, Long> {
    
    List<Surety> findByLoan(Loan loan);
    
    List<Surety> findByMember(Member member);
}