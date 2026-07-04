package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.ShareTransaction;
import com.lms.app.service.ShareService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shares")
@CrossOrigin(origins = "*")
public class ShareController {

    @Autowired
    private ShareService shareService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<ShareTransaction>> getAllTransactions() {
        return ResponseEntity.ok(shareService.getAllTransactions());
    }

    @GetMapping("/member/{memberId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<ShareTransaction>> getTransactionsByMember(@PathVariable Long memberId) {
        return ResponseEntity.ok(shareService.getTransactionsByMember(memberId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> purchaseShares(@RequestBody ShareTransaction tx) {
        try {
            ShareTransaction saved = shareService.purchaseShares(tx);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }
}
