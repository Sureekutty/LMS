package com.lms.app.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class JournalVoucherRequest {
    private String description;
    private LocalDateTime transactionDate;
    private List<JournalEntryDto> entries;
}
