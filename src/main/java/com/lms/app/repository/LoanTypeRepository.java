package com.lms.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lms.app.model.LoanType;

import java.util.Optional;
import java.util.List;

@Repository
public interface LoanTypeRepository extends JpaRepository<LoanType, Long> {
    
    Optional<LoanType> findByTypeCode(String typeCode);
    
    List<LoanType> findByIsActiveTrue();
    
    boolean existsByTypeCode(String typeCode);
}
