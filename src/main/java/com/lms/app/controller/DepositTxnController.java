package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.DepositTransaction;
import com.lms.app.service.DepositTransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/deposit-txns")
@CrossOrigin(origins = "*")
public class DepositTxnController {

    @Autowired
    private DepositTransactionService depositTransactionService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<DepositTransaction>> getAllTransactions() {
        return ResponseEntity.ok(depositTransactionService.getAllTransactions());
    }

    @GetMapping("/deposit/{depositId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<DepositTransaction>> getTransactionsByDepositId(@PathVariable Long depositId) {
        return ResponseEntity.ok(depositTransactionService.getTransactionsByDepositId(depositId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> recordTransaction(@RequestBody DepositTransaction transaction) {
        try {
            DepositTransaction saved = depositTransactionService.recordTransaction(transaction);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
