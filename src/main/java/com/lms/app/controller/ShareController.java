package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.Share;
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
    public ResponseEntity<List<Share>> getAllShares() {
        return ResponseEntity.ok(shareService.getAllShares());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<?> getShareById(@PathVariable Long id) {
        return shareService.getShareById(id)
                .map(share -> ResponseEntity.ok((Object) share))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/member/{memberId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Share>> getSharesByMemberId(@PathVariable Long memberId) {
        return ResponseEntity.ok(shareService.getSharesByMemberId(memberId));
    }

    @PostMapping("/buy")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> buyShares(
            @RequestParam Long memberId,
            @RequestParam Integer numberOfShares) {
        try {
            Share saved = shareService.buyShares(memberId, numberOfShares);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PostMapping("/transfer/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> transferShares(
            @PathVariable Long id,
            @RequestParam Long targetMemberId) {
        try {
            Share saved = shareService.transferShares(id, targetMemberId);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PostMapping("/redeem/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> redeemShares(@PathVariable Long id) {
        try {
            Share saved = shareService.redeemShares(id);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
