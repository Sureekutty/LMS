package com.lms.app.service;

import com.lms.app.model.PaymentTransaction;
import com.lms.app.repository.PaymentTransactionRepository;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.util.UUID;
import java.time.LocalDateTime;

@Service
public class RazorpayService {

    @Value("${razorpay.key.id}")
    private String keyId;

    @Value("${razorpay.key.secret}")
    private String keySecret;

    private final PaymentTransactionRepository paymentRepo;

    public RazorpayService(PaymentTransactionRepository paymentRepo) {
        this.paymentRepo = paymentRepo;
    }

    public PaymentTransaction createOrder(Double amount, String referenceType, Long referenceId) throws RazorpayException {
        RazorpayClient client = new RazorpayClient(keyId, keySecret);
        
        JSONObject orderRequest = new JSONObject();
        // Razorpay expects amount in paise (multiply by 100)
        orderRequest.put("amount", Math.round(amount * 100)); 
        orderRequest.put("currency", "INR");
        String receiptId = "txn_" + UUID.randomUUID().toString().substring(0, 8);
        orderRequest.put("receipt", receiptId);

        Order order = client.orders.create(orderRequest);

        PaymentTransaction txn = new PaymentTransaction();
        txn.setRazorpayOrderId(order.get("id"));
        txn.setAmount(amount);
        txn.setReceiptId(receiptId);
        txn.setStatus("CREATED");
        txn.setReferenceType(referenceType);
        txn.setReferenceId(referenceId);
        
        return paymentRepo.save(txn);
    }

    public boolean verifySignature(String orderId, String paymentId, String signature) {
        try {
            JSONObject options = new JSONObject();
            options.put("razorpay_order_id", orderId);
            options.put("razorpay_payment_id", paymentId);
            options.put("razorpay_signature", signature);

            boolean isValid = Utils.verifyPaymentSignature(options, keySecret);

            if (isValid) {
                PaymentTransaction txn = paymentRepo.findByRazorpayOrderId(orderId)
                        .orElseThrow(() -> new RuntimeException("Transaction not found"));
                txn.setRazorpayPaymentId(paymentId);
                txn.setRazorpaySignature(signature);
                txn.setStatus("SUCCESS");
                txn.setUpdatedAt(LocalDateTime.now());
                paymentRepo.save(txn);
                
                // TODO: Update the actual Loan/Deposit status here based on txn.getReferenceType()
                
                return true;
            }
            return false;
        } catch (RazorpayException e) {
            return false;
        }
    }
}
