package com.lms.app.repository;

import com.lms.app.model.Deposit;
import com.lms.app.model.DepositTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DepositTransactionRepository extends JpaRepository<DepositTransaction, Long> {
    
    List<DepositTransaction> findByDepositOrderByTransactionDateDesc(Deposit deposit);
    
    Optional<DepositTransaction> findByReceiptNo(String receiptNo);

    // Get latest transaction for a deposit to find the current balance
    @Query("SELECT t FROM DepositTransaction t WHERE t.deposit = :deposit ORDER BY t.transactionDate DESC, t.id DESC")
    List<DepositTransaction> findLatestTransaction(@Param("deposit") Deposit deposit);
}
