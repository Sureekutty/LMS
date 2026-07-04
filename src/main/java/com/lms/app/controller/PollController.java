package com.lms.app.controller;

import com.lms.app.dto.PollDTO;
import com.lms.app.dto.PollOptionDTO;
import com.lms.app.dto.PollRequest;
import com.lms.app.model.Poll;
import com.lms.app.model.PollOption;
import com.lms.app.model.PollVote;
import com.lms.app.model.User;
import com.lms.app.repository.PollOptionRepository;
import com.lms.app.repository.PollRepository;
import com.lms.app.repository.PollVoteRepository;
import com.lms.app.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/polls")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", maxAge = 3600)
public class PollController {

    private final PollRepository pollRepository;
    private final PollOptionRepository pollOptionRepository;
    private final PollVoteRepository pollVoteRepository;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<PollDTO>> getAllPolls() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User currentUser = userRepository.findByUsername(username).orElse(null);
        Long currentUserId = currentUser != null ? currentUser.getId() : -1L;

        List<Poll> polls = pollRepository.findAll();
        List<PollDTO> pollDTOs = polls.stream().map(poll -> {
            PollDTO dto = new PollDTO();
            dto.setId(poll.getId());
            dto.setTitle(poll.getTitle());
            dto.setDescription(poll.getDescription());
            dto.setCreatedAt(poll.getCreatedAt());
            dto.setExpiresAt(poll.getExpiresAt());
            dto.setActive(poll.isActive());
            
            List<PollOptionDTO> options = poll.getOptions().stream().map(opt -> {
                PollOptionDTO optDto = new PollOptionDTO();
                optDto.setId(opt.getId());
                optDto.setOptionText(opt.getOptionText());
                optDto.setVotesCount(opt.getVotesCount());
                return optDto;
            }).collect(Collectors.toList());
            dto.setOptions(options);

            boolean hasVoted = pollVoteRepository.existsByPollIdAndUserId(poll.getId(), currentUserId);
            dto.setHasVoted(hasVoted);

            return dto;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(pollDTOs);
    }

    @PostMapping
    public ResponseEntity<?> createPoll(@RequestBody PollRequest request) {
        Poll poll = new Poll();
        poll.setTitle(request.getTitle());
        poll.setDescription(request.getDescription());
        poll.setExpiresAt(request.getExpiresAt());
        
        List<PollOption> options = request.getOptions().stream().map(optText -> {
            PollOption opt = new PollOption();
            opt.setOptionText(optText);
            opt.setPoll(poll);
            return opt;
        }).collect(Collectors.toList());
        
        poll.setOptions(options);
        pollRepository.save(poll);
        return ResponseEntity.ok().body("Poll created successfully");
    }

    @PostMapping("/{pollId}/vote/{optionId}")
    public ResponseEntity<?> vote(@PathVariable Long pollId, @PathVariable Long optionId) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User currentUser = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));

        if (pollVoteRepository.existsByPollIdAndUserId(pollId, currentUser.getId())) {
            return ResponseEntity.badRequest().body("You have already voted on this poll");
        }

        Poll poll = pollRepository.findById(pollId)
            .orElseThrow(() -> new RuntimeException("Poll not found"));
            
        if (!poll.isActive() || (poll.getExpiresAt() != null && poll.getExpiresAt().isBefore(LocalDateTime.now()))) {
            return ResponseEntity.badRequest().body("Poll is closed or expired");
        }

        PollOption option = pollOptionRepository.findById(optionId)
            .orElseThrow(() -> new RuntimeException("Option not found"));

        option.setVotesCount(option.getVotesCount() + 1);
        pollOptionRepository.save(option);

        PollVote vote = new PollVote();
        vote.setPoll(poll);
        vote.setPollOption(option);
        vote.setUser(currentUser);
        pollVoteRepository.save(vote);

        return ResponseEntity.ok().body("Vote cast successfully");
    }
}
