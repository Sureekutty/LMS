package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.Bill;
import com.lms.app.service.BillService;
import com.lms.app.repository.BillRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bills")
@CrossOrigin(origins = "*")
public class BillController {

    @Autowired
    private BillService billService;

    @Autowired
    private BillRepository billRepository;

    @PostMapping("/generate")
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT')")
    public ResponseEntity<?> generateBills(@RequestParam String month) {
        if (!month.matches("\\d{4}-\\d{2}")) {
            return ResponseEntity.badRequest().body("Invalid month format. Expected YYYY-MM.");
        }
        try {
            List<Bill> list = billService.generateBills(month);
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }

    @GetMapping("/month/{month}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Bill>> getBillsByMonth(@PathVariable String month) {
        return ResponseEntity.ok(billRepository.findByProcessMonth(month));
    }

    @GetMapping("/member/{memberId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Bill>> getBillsByMember(@PathVariable Long memberId) {
        return ResponseEntity.ok(billRepository.findByMemberIdOrderByProcessMonthDesc(memberId));
    }

    @PostMapping("/pay")
    @PreAuthorize("hasAnyRole('ADMIN','ACCOUNTANT','CLERK')")
    public ResponseEntity<?> payBill(@RequestBody Map<String, Object> payload) {
        try {
            Long billId = Long.valueOf(payload.get("billId").toString());
            BigDecimal amount = new BigDecimal(payload.get("amount").toString());
            Bill paidBill = billService.payBill(billId, amount);
            return ResponseEntity.ok(paidBill);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }
}
