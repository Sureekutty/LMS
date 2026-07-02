package com.lms.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.List;

@Data
@AllArgsConstructor
public class JwtResponse {
    private String token;
    private String username;
    private List<String> roles;
    private String membershipNo;
    private String type = "Bearer";

    public JwtResponse(String token, String username, List<String> roles, String membershipNo) {
        this.token = token;
        this.username = username;
        this.roles = roles;
        this.membershipNo = membershipNo;
    }
}