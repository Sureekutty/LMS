package com.lms.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lms.app.model.Member;

import java.util.List;
import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {
    
    Optional<Member> findByMembershipNo(String membershipNo);
    
    Optional<Member> findByStaffCode(String staffCode);
    
    List<Member> findByIsActiveTrue();
    
    boolean existsByMembershipNo(String membershipNo);
    
    boolean existsByStaffCode(String staffCode);

    // ===== NEW QUERIES =====

    Optional<Member> findByPanNo(String panNo);

    Optional<Member> findByAadharNo(String aadharNo);

    List<Member> findByNameContainingIgnoreCase(String name);

    List<Member> findBySectionDivision(String sectionDivision);

    long countByIsActiveTrue();
}