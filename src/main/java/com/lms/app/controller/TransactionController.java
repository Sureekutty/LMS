package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.Transaction;
import com.lms.app.model.TransactionType;
import com.lms.app.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/transactions")
@CrossOrigin(origins = "*")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<Transaction>> getAllTransactions() {
        return ResponseEntity.ok(transactionService.getAllTransactions());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<?> getTransactionById(@PathVariable Long id) {
        return transactionService.getTransactionById(id)
                .map(txn -> ResponseEntity.ok((Object) txn))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/member/{memberId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Transaction>> getTransactionsByMemberId(@PathVariable Long memberId) {
        return ResponseEntity.ok(transactionService.getTransactionsByMemberId(memberId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> recordTransaction(@RequestBody Transaction transaction) {
        try {
            Transaction saved = transactionService.recordTransaction(transaction);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PutMapping("/{id}/reverse")
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT')")
    public ResponseEntity<?> reverseTransaction(@PathVariable Long id) {
        try {
            Transaction reversed = transactionService.reverseTransaction(id);
            return ResponseEntity.ok(reversed);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @GetMapping("/types")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<TransactionType>> getAllTransactionTypes() {
        return ResponseEntity.ok(transactionService.getAllTransactionTypes());
    }
}
