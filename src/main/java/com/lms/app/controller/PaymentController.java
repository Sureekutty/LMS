package com.lms.app.controller;

import com.lms.app.model.PaymentTransaction;
import com.lms.app.service.RazorpayService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*")
public class PaymentController {

    private final RazorpayService razorpayService;

    public PaymentController(RazorpayService razorpayService) {
        this.razorpayService = razorpayService;
    }

    @PostMapping("/create-order")
    public ResponseEntity<?> createOrder(@RequestBody Map<String, Object> data) {
        try {
            Double amount = Double.parseDouble(data.get("amount").toString());
            String referenceType = (String) data.get("referenceType");
            Long referenceId = data.containsKey("referenceId") ? Long.parseLong(data.get("referenceId").toString()) : null;

            PaymentTransaction txn = razorpayService.createOrder(amount, referenceType, referenceId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("orderId", txn.getRazorpayOrderId());
            response.put("amount", txn.getAmount());
            response.put("currency", txn.getCurrency());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> err = new HashMap<>();
            err.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(err);
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verifyPayment(@RequestBody Map<String, String> data) {
        String orderId = data.get("razorpay_order_id");
        String paymentId = data.get("razorpay_payment_id");
        String signature = data.get("razorpay_signature");

        boolean isValid = razorpayService.verifySignature(orderId, paymentId, signature);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", isValid);
        if (isValid) {
            response.put("message", "Payment verified successfully");
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "Payment verification failed");
            return ResponseEntity.badRequest().body(response);
        }
    }
}
