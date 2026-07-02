package com.lms.app.repository;

import com.lms.app.model.Deposit;
import com.lms.app.model.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface DepositRepository extends JpaRepository<Deposit, Long> {
    
    Optional<Deposit> findByDepositNo(String depositNo);
    
    List<Deposit> findByMember(Member member);
    
    List<Deposit> findByStatus(String status);
    
    List<Deposit> findByMaturityDateLessThanEqualAndStatus(LocalDate date, String status);
    
    boolean existsByDepositNo(String depositNo);
}
