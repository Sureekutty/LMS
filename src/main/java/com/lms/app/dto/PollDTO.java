package com.lms.app.dto;

import lombok.Data;
import java.util.List;
import java.time.LocalDateTime;

@Data
public class PollDTO {
    private Long id;
    private String title;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private boolean active;
    private List<PollOptionDTO> options;
    private boolean hasVoted;
}
