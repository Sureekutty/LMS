package com.lms.app.service;

import com.lms.app.dto.RegisterRequest;
import com.lms.app.model.Role;
import com.lms.app.model.User;
import com.lms.app.repository.RoleRepository;
import com.lms.app.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.HashSet;
import java.util.Set;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Register new user
    public User registerUser(RegisterRequest request) {

        // Check username exists
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already exists!");
        }

        // Check email exists
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists!");
        }

        // Create new user
        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        // Encrypt password — never store plain text!
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        // Assign roles
        Set<Role> roles = new HashSet<>();
        if (request.getRoles() == null || request.getRoles().isEmpty()) {
            // Default role is MEMBER
            Role memberRole = roleRepository.findByName("ROLE_MEMBER")
                .orElseThrow(() -> new RuntimeException("Role not found!"));
            roles.add(memberRole);
        } else {
            request.getRoles().forEach(roleName -> {
                Role role = roleRepository.findByName("ROLE_" + roleName.toUpperCase())
                    .orElseThrow(() -> new RuntimeException("Role not found: " + roleName));
                roles.add(role);
            });
        }
        user.setRoles(roles);
        return userRepository.save(user);
    }

    public java.util.Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
}