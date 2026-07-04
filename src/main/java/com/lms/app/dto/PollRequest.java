package com.lms.app.dto;

import lombok.Data;
import java.util.List;
import java.time.LocalDateTime;

@Data
public class PollRequest {
    private String title;
    private String description;
    private LocalDateTime expiresAt;
    private List<String> options;
}
