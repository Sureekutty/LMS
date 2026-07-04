package com.lms.app.service;

import com.lms.app.model.Member;
import com.lms.app.repository.MemberRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class MemberService {

    @Autowired
    private MemberRepository memberRepository;

    // Get all active members
    public List<Member> getAllActiveMembers() {
        return memberRepository.findByIsActiveTrue();
    }

    // Get member by ID
    public Optional<Member> getMemberById(Long id) {
        return memberRepository.findById(id);
    }

    // Get member by membership number
    public Optional<Member> getMemberByMembershipNo(String membershipNo) {
        return memberRepository.findByMembershipNo(membershipNo);
    }

    // Get member by staff code
    public Optional<Member> getMemberByStaffCode(String staffCode) {
        return memberRepository.findByStaffCode(staffCode);
    }

    // Save new member
    public Member saveMember(Member member) {
        // Check if membership number already exists
        if (memberRepository.existsByMembershipNo(member.getMembershipNo())) {
            throw new RuntimeException("Membership number already exists: " 
                + member.getMembershipNo());
        }
        // Check if staff code already exists
        if (memberRepository.existsByStaffCode(member.getStaffCode())) {
            throw new RuntimeException("Staff code already exists: " 
                + member.getStaffCode());
        }
        return memberRepository.save(member);
    }

    // Update member
    public Member updateMember(Member member) {
        return memberRepository.save(member);
    }

    // Deactivate member (never delete!)
    public void deactivateMember(Long id) {
        Member member = memberRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Member not found: " + id));
        member.setIsActive(false);
        memberRepository.save(member);
    }

    // Get all members
    public List<Member> getAllMembers() {
        return memberRepository.findAll();
    }
}