package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.LoanRepayment;
import com.lms.app.service.LoanRepaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/repayments")
@CrossOrigin(origins = "*")
public class LoanRepaymentController {

    @Autowired
    private LoanRepaymentService loanRepaymentService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<LoanRepayment>> getAllRepayments() {
        return ResponseEntity.ok(loanRepaymentService.getAllRepayments());
    }

    @GetMapping("/loan/{loanId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<LoanRepayment>> getRepaymentsByLoanId(@PathVariable Long loanId) {
        return ResponseEntity.ok(loanRepaymentService.getRepaymentsByLoanId(loanId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> makeRepayment(@RequestBody LoanRepayment repayment) {
        try {
            LoanRepayment saved = loanRepaymentService.makeRepayment(repayment);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
