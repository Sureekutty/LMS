package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.Surety;
import com.lms.app.service.SuretyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sureties")
@CrossOrigin(origins = "*")
public class SuretyController {

    @Autowired
    private SuretyService suretyService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<Surety>> getAllSureties() {
        return ResponseEntity.ok(suretyService.getAllSureties());
    }

    @GetMapping("/loan/{loanId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Surety>> getSuretiesByLoanId(@PathVariable Long loanId) {
        return ResponseEntity.ok(suretyService.getSuretiesByLoanId(loanId));
    }

    @GetMapping("/member/{memberId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Surety>> getGuaranteedLoansByMemberId(@PathVariable Long memberId) {
        return ResponseEntity.ok(suretyService.getGuaranteedLoansByMemberId(memberId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> addSurety(
            @RequestParam Long loanId,
            @RequestParam Long memberId) {
        try {
            Surety saved = suretyService.addSurety(loanId, memberId);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> removeSurety(@PathVariable Long id) {
        try {
            suretyService.removeSurety(id);
            return ResponseEntity.ok(new ApiResponse(true, "Guarantor removed successfully."));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
