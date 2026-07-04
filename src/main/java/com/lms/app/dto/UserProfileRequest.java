package com.lms.app.dto;

import lombok.Data;

@Data
public class UserProfileRequest {
    private String email;
    private String mobileNumber;
    private String profileImageUrl;
    private String firstName;
    private String lastName;
    private String displayName;
}
