package com.lms.app.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "payment_transactions")
public class PaymentTransaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String razorpayOrderId;
    private String razorpayPaymentId;
    private String razorpaySignature;
    
    private String receiptId;
    private Double amount;
    private String currency = "INR";
    private String status; // CREATED, SUCCESS, FAILED
    
    // Can link to Loan EMI or Deposit Id if needed
    private String referenceType; // "LOAN", "DEPOSIT", "MISC"
    private Long referenceId;

    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();
}
