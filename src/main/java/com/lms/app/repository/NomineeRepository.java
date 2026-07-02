package com.lms.app.repository;

import com.lms.app.model.Member;
import com.lms.app.model.Nominee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NomineeRepository extends JpaRepository<Nominee, Long> {
    
    // Find all nominees linked to a specific member
    List<Nominee> findByMember(Member member);
    
    // Find nominees by relationship type
    List<Nominee> findByRelationship(String relationship);
}
