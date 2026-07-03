package com.lms.app.controller;

import com.lms.app.model.MonthlyProcess;
import com.lms.app.service.MonthlyProcessService;
import com.lms.app.repository.MonthlyProcessRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/monthly-process")
@CrossOrigin(origins = "*", maxAge = 3600)
public class MonthlyProcessController {

    @Autowired
    private MonthlyProcessService monthlyProcessService;

    @Autowired
    private MonthlyProcessRepository monthlyProcessRepository;

    @PostMapping("/generate")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<?> generateProcess(@RequestParam String month) {
        if (!month.matches("\\d{4}-\\d{2}")) {
            return ResponseEntity.badRequest().body("Invalid month format. Expected YYYY-MM.");
        }
        List<MonthlyProcess> schedule = monthlyProcessService.generateMonthlyProcess(month);
        return ResponseEntity.ok(schedule);
    }

    @GetMapping("/grid")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT', 'CLERK')")
    public ResponseEntity<List<MonthlyProcess>> getGridData(@RequestParam String month) {
        return ResponseEntity.ok(monthlyProcessRepository.findByProcessMonth(month));
    }

    @PostMapping("/post")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<?> postRecovery(@RequestBody Map<String, Object> payload) {
        Long processId = Long.valueOf(payload.get("processId").toString());
        BigDecimal recoveredAmount = new BigDecimal(payload.get("recoveredAmount").toString());

        monthlyProcessService.postRecovery(processId, recoveredAmount);
        return ResponseEntity.ok().body(Map.of("message", "Monthly recovery posted successfully"));
    }
}
