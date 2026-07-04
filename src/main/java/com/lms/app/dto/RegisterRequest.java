package com.lms.app.dto;

import lombok.Data;
import java.util.Set;

@Data
public class RegisterRequest {
    private String username;
    private String password;
    private String email;
    private String firstName;
    private String lastName;
    private String displayName;
    private String adminPassword;
    private Set<String> roles;
}