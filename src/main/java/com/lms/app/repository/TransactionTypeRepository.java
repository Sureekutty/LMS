package com.lms.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lms.app.model.TransactionType;

import java.util.Optional;
import java.util.List;

@Repository
public interface TransactionTypeRepository extends JpaRepository<TransactionType, Long> {
    
    Optional<TransactionType> findByTypeCode(String typeCode);
    
    List<TransactionType> findByIsActiveTrue();
    
    boolean existsByTypeCode(String typeCode);
}
