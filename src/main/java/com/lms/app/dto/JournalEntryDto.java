package com.lms.app.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class JournalEntryDto {
    private Long transactionTypeId;
    private Long memberId; // Optional
    private String type; // "DEBIT" or "CREDIT"
    private BigDecimal amount;
}
