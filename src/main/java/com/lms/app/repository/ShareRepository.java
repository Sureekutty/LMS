package com.lms.app.repository;

import com.lms.app.model.Member;
import com.lms.app.model.Share;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShareRepository extends JpaRepository<Share, Long> {
    
    Optional<Share> findByShareCertificateNo(String shareCertificateNo);
    
    List<Share> findByMember(Member member);
    
    List<Share> findByMemberAndStatus(Member member, String status);

    // Sum of shares held by a specific member
    @Query("SELECT SUM(s.numberOfShares) FROM Share s WHERE s.member = :member AND s.status = 'ACTIVE'")
    Integer sumSharesByMember(@Param("member") Member member);
}
