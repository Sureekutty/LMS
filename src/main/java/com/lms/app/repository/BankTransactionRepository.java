package com.lms.app.repository;

import com.lms.app.model.BankTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BankTransactionRepository extends JpaRepository<BankTransaction, Long> {
    List<BankTransaction> findByBankAccountIdOrderByTransactionDateDesc(Long bankAccountId);
}
