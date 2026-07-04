package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.BankAccount;
import com.lms.app.model.BankTransaction;
import com.lms.app.service.BankService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/banks")
@CrossOrigin(origins = "*")
public class BankController {

    @Autowired
    private BankService bankService;

    @GetMapping("/accounts")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<BankAccount>> getAllAccounts() {
        return ResponseEntity.ok(bankService.getAllAccounts());
    }

    @PostMapping("/accounts")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> createAccount(@RequestBody BankAccount account) {
        try {
            BankAccount saved = bankService.createAccount(account);
            return ResponseEntity.ok(saved);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }

    @GetMapping("/transactions")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<BankTransaction>> getAllTransactions() {
        return ResponseEntity.ok(bankService.getAllTransactions());
    }

    @GetMapping("/transactions/account/{accountId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<BankTransaction>> getTransactionsByAccount(@PathVariable Long accountId) {
        return ResponseEntity.ok(bankService.getTransactionsByAccount(accountId));
    }

    @PostMapping("/transactions")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> postTransaction(@RequestBody Map<String, Object> payload) {
        try {
            Long accountId = Long.valueOf(payload.get("accountId").toString());
            BigDecimal amount = new BigDecimal(payload.get("amount").toString());
            String type = payload.get("type").toString();
            String referenceNo = payload.get("referenceNo") != null ? payload.get("referenceNo").toString() : null;
            String description = payload.get("description") != null ? payload.get("description").toString() : null;

            BankTransaction saved = bankService.postTransaction(accountId, amount, type, referenceNo, description);
            return ResponseEntity.ok(saved);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }
}
