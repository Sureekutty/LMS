package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.model.Member;
import com.lms.app.service.MemberService;
import com.lms.app.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/members")
@CrossOrigin(origins = "*")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private UserService userService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Member>> getAllMembers() {
        return ResponseEntity.ok(memberService.getAllMembers());
    }

    @GetMapping("/active")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<List<Member>> getActiveMembers() {
        return ResponseEntity.ok(memberService.getAllActiveMembers());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','MEMBER')")
    public ResponseEntity<?> getMemberById(@PathVariable Long id) {
        return memberService.getMemberById(id)
            .map(member -> ResponseEntity.ok((Object) member))
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> createMember(@RequestBody Member member) {
        try {
            Member saved = memberService.saveMember(member);
            return ResponseEntity.ok(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK')")
    public ResponseEntity<?> updateMember(
            @PathVariable Long id, @RequestBody Member member) {
        try {
            member.setId(id);
            Member updated = memberService.updateMember(member);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PutMapping("/{id}/deactivate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deactivateMember(@PathVariable Long id) {
        try {
            memberService.deactivateMember(id);
            return ResponseEntity.ok(
                new ApiResponse(true, "Member deactivated successfully!"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @GetMapping("/me")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','ACCOUNTANT','MEMBER')")
    public ResponseEntity<?> getCurrentMember() {
        String username = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName();
        return userService.findByUsername(username)
            .map(user -> {
                if (user.getMember() != null) {
                    return ResponseEntity.ok((Object) user.getMember());
                } else {
                    return ResponseEntity.badRequest().body((Object) new ApiResponse(false, "No member profile linked to this user account."));
                }
            })
            .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/statement/pdf")
    @PreAuthorize("hasAnyRole('ADMIN','CLERK','MEMBER')")
    public ResponseEntity<byte[]> downloadStatementPdf(@PathVariable Long id) {
        Member member = memberService.getMemberById(id)
                .orElseThrow(() -> new RuntimeException("Member not found"));

        java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
        try {
            com.itextpdf.kernel.pdf.PdfWriter writer = new com.itextpdf.kernel.pdf.PdfWriter(baos);
            com.itextpdf.kernel.pdf.PdfDocument pdf = new com.itextpdf.kernel.pdf.PdfDocument(writer);
            com.itextpdf.layout.Document document = new com.itextpdf.layout.Document(pdf);

            document.add(new com.itextpdf.layout.element.Paragraph("SOCIETY MEMBER STATEMENT DISPATCH")
                    .setFontSize(18).setBold());
            document.add(new com.itextpdf.layout.element.Paragraph("Generated Date: " + java.time.LocalDate.now()));
            document.add(new com.itextpdf.layout.element.Paragraph("------------------------------------------------------------------"));

            document.add(new com.itextpdf.layout.element.Paragraph("Membership No: " + member.getMembershipNo()));
            document.add(new com.itextpdf.layout.element.Paragraph("Member Name: " + member.getName()));
            document.add(new com.itextpdf.layout.element.Paragraph("Staff Code: " + member.getStaffCode()));
            document.add(new com.itextpdf.layout.element.Paragraph("Designation: " + member.getDesignation()));
            document.add(new com.itextpdf.layout.element.Paragraph("Basic Pay: INR " + member.getBasicPay()));
            document.add(new com.itextpdf.layout.element.Paragraph("Share Capital Account Balance: INR " + member.getShareCapital()));
            document.add(new com.itextpdf.layout.element.Paragraph("Thrift Deposit Account Balance: INR " + member.getThriftDeposit()));
            
            if (member.getNomineeName() != null) {
                document.add(new com.itextpdf.layout.element.Paragraph("\nNominee Beneficiary Details")
                        .setFontSize(14).setBold());
                document.add(new com.itextpdf.layout.element.Paragraph("Nominee Name: " + member.getNomineeName()));
                document.add(new com.itextpdf.layout.element.Paragraph("Relationship: " + member.getNomineeRelationship()));
                document.add(new com.itextpdf.layout.element.Paragraph("Nominee Address: " + member.getNomineeAddress()));
            }

            document.close();
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate statement PDF", e);
        }

        byte[] pdfBytes = baos.toByteArray();
        org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
        headers.setContentType(org.springframework.http.MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", "statement_" + member.getMembershipNo() + ".pdf");
        
        return new ResponseEntity<>(pdfBytes, headers, org.springframework.http.HttpStatus.OK);
    }
}