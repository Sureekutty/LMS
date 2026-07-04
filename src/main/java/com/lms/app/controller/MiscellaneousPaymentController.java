package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.MiscellaneousPayment;
import com.lms.app.service.MiscellaneousPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/misc-payments")
@CrossOrigin(origins = "*")
public class MiscellaneousPaymentController {

    @Autowired
    private MiscellaneousPaymentService miscellaneousPaymentService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<MiscellaneousPayment>> getAllPayments() {
        return ResponseEntity.ok(miscellaneousPaymentService.getAllPayments());
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> postPayment(@RequestBody MiscellaneousPayment payment) {
        try {
            MiscellaneousPayment saved = miscellaneousPaymentService.postPayment(payment);
            return ResponseEntity.ok(saved);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }
}
