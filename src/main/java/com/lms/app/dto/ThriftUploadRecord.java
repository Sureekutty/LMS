package com.lms.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ThriftUploadRecord {
    private String staffCode;
    private String membershipNo;
    private BigDecimal amount;
}
