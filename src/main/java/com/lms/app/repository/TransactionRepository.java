package com.lms.app.repository;

import com.lms.app.model.Member;
import com.lms.app.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    
    Optional<Transaction> findByTransactionNo(String transactionNo);
    
    List<Transaction> findByMember(Member member);
    
    List<Transaction> findByReferenceNo(String referenceNo);
    
    List<Transaction> findByType(String type);
    
    List<Transaction> findByTransactionDateBetween(LocalDateTime start, LocalDateTime end);
}
