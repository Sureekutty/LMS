package com.lms.app.controller;

import com.lms.app.dto.ApiResponse;
import com.lms.app.dto.UserProfileRequest;
import com.lms.app.model.User;
import com.lms.app.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;

    // Get current user profile
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userService.findByUsername(username)
            .map(user -> ResponseEntity.ok(user))
            .orElse(ResponseEntity.notFound().build());
    }

    // Update profile
    @PutMapping("/me")
    public ResponseEntity<?> updateProfile(@RequestBody UserProfileRequest request) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        try {
            User updatedUser = userService.updateProfile(username, request);
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
    }

    // Upload profile photo
    @PostMapping("/me/photo")
    public ResponseEntity<?> uploadProfilePhoto(@RequestParam("file") MultipartFile file) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        try {
            if (file.isEmpty()) {
                throw new RuntimeException("File is empty");
            }
            
            String originalFileName = StringUtils.cleanPath(file.getOriginalFilename());
            String fileExtension = "";
            if (originalFileName.contains(".")) {
                fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            String newFileName = UUID.randomUUID().toString() + fileExtension;
            
            Path uploadPath = Paths.get("uploads/profiles");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            Path filePath = uploadPath.resolve(newFileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            
            // Save the path to user profile
            String fileUrl = "http://localhost:8080/uploads/profiles/" + newFileName; // In prod, this would be relative or domain-based
            
            Optional<User> userOpt = userService.findByUsername(username);
            if(userOpt.isPresent()) {
                User user = userOpt.get();
                // We shouldn't manipulate entities directly in controller ideally, but for speed:
                // userService should have a method, but we'll use a hack or just create a UserProfileRequest
                UserProfileRequest req = new UserProfileRequest();
                req.setFirstName(user.getFirstName());
                req.setLastName(user.getLastName());
                req.setDisplayName(user.getDisplayName());
                req.setEmail(user.getEmail());
                req.setMobileNumber(user.getMobileNumber());
                req.setProfileImageUrl(fileUrl);
                
                User updatedUser = userService.updateProfile(username, req);
                return ResponseEntity.ok(updatedUser);
            }
            
            return ResponseEntity.notFound().build();
            
        } catch (IOException e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, "Could not upload file: " + e.getMessage()));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }
}
