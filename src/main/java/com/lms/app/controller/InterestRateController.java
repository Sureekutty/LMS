package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.InterestRate;
import com.lms.app.service.InterestRateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/interest-rates")
@CrossOrigin(origins = "*")
public class InterestRateController {

    @Autowired
    private InterestRateService interestRateService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<InterestRate>> getAllRates() {
        return ResponseEntity.ok(interestRateService.getAllRates());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> getRateById(@PathVariable Long id) {
        return interestRateService.getRateById(id)
                .map(rate -> ResponseEntity.ok((Object) rate))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/type/{typeCode}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<InterestRate>> getRatesByTypeCode(@PathVariable String typeCode) {
        return ResponseEntity.ok(interestRateService.getRatesByTypeCode(typeCode));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createRate(@RequestBody InterestRate interestRate) {
        try {
            InterestRate saved = interestRateService.saveRate(interestRate);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateRate(@PathVariable Long id, @RequestBody InterestRate interestRate) {
        try {
            interestRate.setId(id);
            InterestRate updated = interestRateService.updateRate(interestRate);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteRate(@PathVariable Long id) {
        try {
            interestRateService.deleteRate(id);
            return ResponseEntity.ok(new ApiResponse(true, "Interest rate rule deleted successfully."));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
