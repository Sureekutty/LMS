package com.lms.app.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.lms.app.model.LoanType;
import com.lms.app.model.DepositType;
import com.lms.app.model.TransactionType;
import com.lms.app.repository.LoanTypeRepository;
import com.lms.app.repository.DepositTypeRepository;
import com.lms.app.repository.TransactionTypeRepository;

import java.math.BigDecimal;

@Configuration
public class MasterDataInitializer {

    @Bean
    CommandLineRunner initMasterData(
            LoanTypeRepository loanTypeRepo,
            DepositTypeRepository depositTypeRepo,
            TransactionTypeRepository transactionTypeRepo) {
        return args -> {
            // 1. Initialize Loan Types
            if (loanTypeRepo.count() == 0) {
                loanTypeRepo.save(new LoanType(null, "PL", "Personal Loan", new BigDecimal("12.50"), new BigDecimal("500000"), 60, true, null));
                loanTypeRepo.save(new LoanType(null, "EL", "Education Loan", new BigDecimal("10.00"), new BigDecimal("1000000"), 84, true, null));
                loanTypeRepo.save(new LoanType(null, "HL", "Home Loan", new BigDecimal("8.50"), new BigDecimal("2500000"), 180, true, null));
                System.out.println("✅ Master Data: Loan Types seeded.");
            }

            // 2. Initialize Deposit Types
            if (depositTypeRepo.count() == 0) {
                depositTypeRepo.save(new DepositType(null, "FD", "Fixed Deposit", new BigDecimal("7.00"), 12, true, null));
                depositTypeRepo.save(new DepositType(null, "RD", "Recurring Deposit", new BigDecimal("6.50"), 12, true, null));
                depositTypeRepo.save(new DepositType(null, "TD", "Thrift Deposit", new BigDecimal("5.00"), null, true, null));
                System.out.println("✅ Master Data: Deposit Types seeded.");
            }

            // 3. Initialize Transaction Types
            if (transactionTypeRepo.count() == 0) {
                transactionTypeRepo.save(new TransactionType(null, "RECPT", "Receipt", true, null));
                transactionTypeRepo.save(new TransactionType(null, "PYMNT", "Payment", true, null));
                transactionTypeRepo.save(new TransactionType(null, "JRNL", "Journal", true, null));
                System.out.println("✅ Master Data: Transaction Types seeded.");
            }
        };
    }
}
