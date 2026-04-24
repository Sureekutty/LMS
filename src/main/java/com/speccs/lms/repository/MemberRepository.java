package com.speccs.lms.repository;

import com.speccs.lms.model.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {
    
    Optional<Member> findByMembershipNo(String membershipNo);
    
    Optional<Member> findByStaffCode(String staffCode);
    
    List<Member> findByIsActiveTrue();
    
    boolean existsByMembershipNo(String membershipNo);
    
    boolean existsByStaffCode(String staffCode);
}