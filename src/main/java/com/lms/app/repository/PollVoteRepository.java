package com.lms.app.repository;
import com.lms.app.model.PollVote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PollVoteRepository extends JpaRepository<PollVote, Long> {
    boolean existsByPollIdAndUserId(Long pollId, Long userId);
}
