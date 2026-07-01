package com.lms.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lms.app.model.DepositType;

import java.util.Optional;
import java.util.List;

@Repository
public interface DepositTypeRepository extends JpaRepository<DepositType, Long> {
    
    Optional<DepositType> findByTypeCode(String typeCode);
    
    List<DepositType> findByIsActiveTrue();
    
    boolean existsByTypeCode(String typeCode);
}
