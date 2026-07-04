package com.lms.app.repository;
import com.lms.app.model.PollOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PollOptionRepository extends JpaRepository<PollOption, Long> {}
