package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.scheduler.InterestAccruionScheduler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/interest-accruals")
@CrossOrigin(origins = "*")
public class InterestAccrualController {

    @Autowired
    private InterestAccruionScheduler interestAccruionScheduler;

    @PostMapping("/run")
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT')")
    public ResponseEntity<?> runMonthlyAccrual() {
        try {
            interestAccruionScheduler.runMonthlyInterestAccrual();
            return ResponseEntity.ok(new ApiResponse(true, "Monthly interest accrual executed successfully for all active loans and deposits."));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
