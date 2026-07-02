package com.lms.app.service;

import com.lms.app.model.Member;
import com.lms.app.model.Share;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.ShareRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class ShareService {

    @Autowired
    private ShareRepository shareRepository;

    @Autowired
    private MemberRepository memberRepository;

    public List<Share> getAllShares() {
        return shareRepository.findAll();
    }

    public List<Share> getSharesByMemberId(Long memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Member not found with ID: " + memberId));
        return shareRepository.findByMember(member);
    }

    public Optional<Share> getShareById(Long id) {
        return shareRepository.findById(id);
    }

    // Update member aggregate counts
    private void updateMemberShareAggregates(Member member) {
        Integer totalShares = shareRepository.sumSharesByMember(member);
        if (totalShares == null) {
            totalShares = 0;
        }
        member.setNoOfShares(totalShares);
        // Assuming share price is ₹10
        member.setShareCapital(BigDecimal.valueOf(totalShares).multiply(BigDecimal.valueOf(10.00)));
        memberRepository.save(member);
    }

    // 1. Issue/Buy shares
    @Transactional
    public Share buyShares(Long memberId, Integer numberOfShares) {
        if (numberOfShares == null || numberOfShares <= 0) {
            throw new RuntimeException("Number of shares purchased must be greater than zero.");
        }

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new RuntimeException("Member not found."));

        Share share = new Share();
        share.setMember(member);
        share.setNumberOfShares(numberOfShares);
        share.setShareValue(BigDecimal.valueOf(10.00));
        share.setCapitalAmount(BigDecimal.valueOf(10.00).multiply(BigDecimal.valueOf(numberOfShares)));
        share.setPurchaseDate(LocalDate.now());
        share.setShareCertificateNo("SH-CERT-" + System.currentTimeMillis());
        share.setReceiptNo("REC-SH-" + System.currentTimeMillis());
        share.setStatus("ACTIVE");

        Share savedShare = shareRepository.save(share);

        // Update Member aggregates
        updateMemberShareAggregates(member);

        return savedShare;
    }

    // 2. Transfer shares from one member to another
    @Transactional
    public Share transferShares(Long shareId, Long targetMemberId) {
        Share sourceShare = shareRepository.findById(shareId)
                .orElseThrow(() -> new RuntimeException("Share certificate not found."));

        if (!"ACTIVE".equalsIgnoreCase(sourceShare.getStatus())) {
            throw new RuntimeException("Only active share certificates can be transferred.");
        }

        Member targetMember = memberRepository.findById(targetMemberId)
                .orElseThrow(() -> new RuntimeException("Target member not found."));

        if (sourceShare.getMember().getId().equals(targetMemberId)) {
            throw new RuntimeException("Cannot transfer shares to the same member.");
        }

        Member sourceMember = sourceShare.getMember();

        // Mark source certificate as TRANSFERRED
        sourceShare.setStatus("TRANSFERRED");
        shareRepository.save(sourceShare);

        // Create new active certificate for target member
        Share targetShare = new Share();
        targetShare.setMember(targetMember);
        targetShare.setNumberOfShares(sourceShare.getNumberOfShares());
        targetShare.setShareValue(sourceShare.getShareValue());
        targetShare.setCapitalAmount(sourceShare.getCapitalAmount());
        targetShare.setPurchaseDate(LocalDate.now());
        targetShare.setShareCertificateNo("SH-CERT-" + System.currentTimeMillis());
        targetShare.setReceiptNo("REC-TRF-" + System.currentTimeMillis());
        targetShare.setStatus("ACTIVE");

        Share savedTargetShare = shareRepository.save(targetShare);

        // Update aggregates for both members
        updateMemberShareAggregates(sourceMember);
        updateMemberShareAggregates(targetMember);

        return savedTargetShare;
    }

    // 3. Redeem/Refund shares
    @Transactional
    public Share redeemShares(Long shareId) {
        Share share = shareRepository.findById(shareId)
                .orElseThrow(() -> new RuntimeException("Share certificate not found."));

        if (!"ACTIVE".equalsIgnoreCase(share.getStatus())) {
            throw new RuntimeException("Only active share certificates can be redeemed.");
        }

        Member member = share.getMember();

        // Mark certificate as REDEEMED
        share.setStatus("REDEEMED");
        Share savedShare = shareRepository.save(share);

        // Update Member aggregates
        updateMemberShareAggregates(member);

        return savedShare;
    }
}
