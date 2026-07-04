package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.Nominee;
import com.lms.app.service.NomineeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/nominees")
@CrossOrigin(origins = "*")
public class NomineeController {

    @Autowired
    private NomineeService nomineeService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<List<Nominee>> getAllNominees() {
        return ResponseEntity.ok(nomineeService.getAllNominees());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','MEMBER')")
    public ResponseEntity<?> getNomineeById(@PathVariable Long id) {
        return nomineeService.getNomineeById(id)
                .map(nominee -> ResponseEntity.ok((Object) nominee))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/member/{memberId}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','MEMBER')")
    public ResponseEntity<List<Nominee>> getNomineesByMemberId(@PathVariable Long memberId) {
        return ResponseEntity.ok(nomineeService.getNomineesByMemberId(memberId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> createNominee(@RequestBody Nominee nominee) {
        try {
            Nominee saved = nomineeService.saveNominee(nominee);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> updateNominee(@PathVariable Long id, @RequestBody Nominee nominee) {
        try {
            nominee.setId(id);
            Nominee updated = nomineeService.updateNominee(nominee);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteNominee(@PathVariable Long id) {
        try {
            nomineeService.deleteNominee(id);
            return ResponseEntity.ok(new ApiResponse(true, "Nominee record deleted successfully."));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, e.getMessage()));
        }
    }
}
