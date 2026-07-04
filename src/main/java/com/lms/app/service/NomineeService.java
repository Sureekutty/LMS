package com.lms.app.service;

import com.lms.app.model.Member;
import com.lms.app.model.Nominee;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.NomineeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NomineeService {

    @Autowired
    private NomineeRepository nomineeRepository;

    @Autowired
    private MemberRepository memberRepository;

    // Get all nominees in the system
    public List<Nominee> getAllNominees() {
        return nomineeRepository.findAll();
    }

    // Get a specific nominee by ID
    public Optional<Nominee> getNomineeById(Long id) {
        return nomineeRepository.findById(id);
    }

    // Get all nominees associated with a member
    public List<Nominee> getNomineesByMemberId(Long memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Member not found with ID: " + memberId));
        return nomineeRepository.findByMember(member);
    }

    // Create a new nominee record
    public Nominee saveNominee(Nominee nominee) {
        if (nominee.getMember() == null || nominee.getMember().getId() == null) {
            throw new RuntimeException("Nominee must be associated with a valid member.");
        }
        
        // Validate member existence
        Member member = memberRepository.findById(nominee.getMember().getId())
                .orElseThrow(() -> new RuntimeException("Associated member not found."));
        
        nominee.setMember(member);
        return nomineeRepository.save(nominee);
    }

    // Update an existing nominee record
    public Nominee updateNominee(Nominee nominee) {
        if (nominee.getId() == null || !nomineeRepository.existsById(nominee.getId())) {
            throw new RuntimeException("Cannot update non-existent nominee record.");
        }
        
        // Re-validate member association
        if (nominee.getMember() != null && nominee.getMember().getId() != null) {
            Member member = memberRepository.findById(nominee.getMember().getId())
                    .orElseThrow(() -> new RuntimeException("Associated member not found."));
            nominee.setMember(member);
        }
        
        return nomineeRepository.save(nominee);
    }

    // Delete a nominee record by ID
    public void deleteNominee(Long id) {
        if (!nomineeRepository.existsById(id)) {
            throw new RuntimeException("Nominee not found with ID: " + id);
        }
        nomineeRepository.deleteById(id);
    }
}
