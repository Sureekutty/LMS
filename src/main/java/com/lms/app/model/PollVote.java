package com.lms.app.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "poll_votes")
public class PollVote {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "poll_id")
    private Poll poll;
    
    @ManyToOne
    @JoinColumn(name = "poll_option_id")
    private PollOption pollOption;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    private LocalDateTime votedAt = LocalDateTime.now();
}
