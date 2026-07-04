package com.lms.app.dto;

import lombok.Data;

@Data
public class PollOptionDTO {
    private Long id;
    private String optionText;
    private int votesCount;
}
