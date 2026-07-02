package com.lms.app.repository;

import com.lms.app.model.Member;
import com.lms.app.model.ThriftTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ThriftTransactionRepository extends JpaRepository<ThriftTransaction, Long> {
    
    List<ThriftTransaction> findByMemberOrderByTransactionDateDesc(Member member);
    
    Optional<ThriftTransaction> findByReceiptNo(String receiptNo);

    // Get latest transaction for a member to find the current balance
    @Query("SELECT t FROM ThriftTransaction t WHERE t.member = :member ORDER BY t.transactionDate DESC, t.id DESC")
    List<ThriftTransaction> findLatestTransaction(@Param("member") Member member);
}
