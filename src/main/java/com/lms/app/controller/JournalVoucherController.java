package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.dto.JournalVoucherRequest;
import com.lms.app.model.Transaction;
import com.lms.app.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/jv")
@CrossOrigin(origins = "*")
public class JournalVoucherController {

    @Autowired
    private TransactionService transactionService;

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT')")
    public ResponseEntity<?> postJournalVoucher(@RequestBody JournalVoucherRequest request) {
        try {
            List<Transaction> transactions = transactionService.postJournalVoucher(request);
            return ResponseEntity.ok(new ApiResponse(true, "Journal Voucher posted successfully with " + transactions.size() + " entries."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }

    @GetMapping("/recent")
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT','CLERK')")
    public ResponseEntity<?> getRecentJVs() {
        // Fetch recent transactions that look like JVs (referenceNo starts with JV-)
        // For simplicity, we just fetch all and filter, though a custom repository query is better for large DBs.
        List<Transaction> all = transactionService.getAllTransactions();
        List<Transaction> jvs = all.stream()
                .filter(t -> t.getReferenceNo() != null && t.getReferenceNo().startsWith("JV-"))
                .collect(Collectors.toList());
        return ResponseEntity.ok(jvs);
    }
}
