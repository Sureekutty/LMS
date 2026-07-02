package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.Loan;
import com.lms.app.service.LoanService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/loans")
@CrossOrigin(origins = "*")
public class LoanController {

    @Autowired
    private LoanService loanService;

    // GET ALL LOANS
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<Loan>> getAllLoans() {
        return ResponseEntity.ok(loanService.getAllLoans());
    }

    // GET LOAN BY ID
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<?> getLoanById(@PathVariable Long id) {
        return loanService.getLoanById(id)
            .map(loan -> ResponseEntity.ok((Object) loan))
            .orElse(ResponseEntity.notFound().build());
    }

    // GET LOANS BY STATUS
    @GetMapping("/status/{status}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<Loan>> getLoansByStatus(
            @PathVariable String status) {
        return ResponseEntity.ok(
            loanService.getLoansByStatus(status.toUpperCase()));
    }

    // APPLY FOR LOAN
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','MEMBER')")
    public ResponseEntity<?> applyLoan(@RequestBody Loan loan) {
        try {
            Loan saved = loanService.applyLoan(loan);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    // APPROVE LOAN
    @PutMapping("/{id}/approve")
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT')")
    public ResponseEntity<?> approveLoan(
            @PathVariable Long id,
            @RequestParam BigDecimal sanctionedAmount) {
        try {
            Loan approved = loanService.approveLoan(id, sanctionedAmount);
            return ResponseEntity.ok(approved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    // REJECT LOAN
    @PutMapping("/{id}/reject")
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT')")
    public ResponseEntity<?> rejectLoan(@PathVariable Long id) {
        try {
            Loan rejected = loanService.rejectLoan(id);
            return ResponseEntity.ok(rejected);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    // DISBURSE LOAN
    @PutMapping("/{id}/disburse")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> disburseLoan(
            @PathVariable Long id,
            @RequestParam String disbursedBy) {
        try {
            Loan disbursed = loanService.disburseLoan(id, disbursedBy);
            return ResponseEntity.ok(disbursed);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }
}