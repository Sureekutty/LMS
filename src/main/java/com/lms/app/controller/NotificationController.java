package com.lms.app.controller;

import com.lms.app.model.Notification;
import com.lms.app.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationRepository notificationRepository;

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<Notification>> getUserNotifications(Authentication authentication) {
        String username = authentication.getName();
        // Return both specific user notifications and global "ALL" notifications
        List<Notification> userNotifications = notificationRepository.findByUsernameOrderByCreatedAtDesc(username);
        List<Notification> globalNotifications = notificationRepository.findByUsernameOrderByCreatedAtDesc("ALL");
        
        userNotifications.addAll(globalNotifications);
        userNotifications.sort((n1, n2) -> n2.getCreatedAt().compareTo(n1.getCreatedAt()));
        
        return ResponseEntity.ok(userNotifications);
    }

    @GetMapping("/unread")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<Notification>> getUnreadNotifications(Authentication authentication) {
        String username = authentication.getName();
        List<Notification> userUnread = notificationRepository.findByUsernameAndIsReadFalseOrderByCreatedAtDesc(username);
        List<Notification> globalUnread = notificationRepository.findByUsernameAndIsReadFalseOrderByCreatedAtDesc("ALL");
        
        userUnread.addAll(globalUnread);
        userUnread.sort((n1, n2) -> n2.getCreatedAt().compareTo(n1.getCreatedAt()));
        
        return ResponseEntity.ok(userUnread);
    }

    @PostMapping("/{id}/read")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> markAsRead(@PathVariable Long id, Authentication authentication) {
        Notification notification = notificationRepository.findById(id).orElse(null);
        if (notification != null && (notification.getUsername().equals(authentication.getName()) || notification.getUsername().equals("ALL"))) {
            notification.setRead(true);
            notificationRepository.save(notification);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
    
    @PostMapping("/mark-all-read")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> markAllAsRead(Authentication authentication) {
        String username = authentication.getName();
        List<Notification> unread = notificationRepository.findByUsernameAndIsReadFalseOrderByCreatedAtDesc(username);
        for(Notification n : unread) {
            n.setRead(true);
        }
        notificationRepository.saveAll(unread);
        return ResponseEntity.ok().build();
    }
}
