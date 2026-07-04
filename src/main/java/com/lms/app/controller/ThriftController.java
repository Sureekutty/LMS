package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.ThriftTransaction;
import com.lms.app.service.ThriftService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/thrift")
@CrossOrigin(origins = "*")
public class ThriftController {

    @Autowired
    private ThriftService thriftService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<List<ThriftTransaction>> getAllTransactions() {
        return ResponseEntity.ok(thriftService.getAllTransactions());
    }

    @GetMapping("/member/{memberId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<ThriftTransaction>> getTransactionsByMemberId(@PathVariable Long memberId) {
        return ResponseEntity.ok(thriftService.getTransactionsByMemberId(memberId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT')")
    public ResponseEntity<?> recordTransaction(@RequestBody ThriftTransaction transaction) {
        try {
            ThriftTransaction saved = thriftService.recordTransaction(transaction);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
