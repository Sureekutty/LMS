package com.speccs.lms.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class JwtResponse {
    private String token;
    private String username;
    private String type = "Bearer";

    public JwtResponse(String token, String username) {
        this.token = token;
        this.username = username;
    }
}