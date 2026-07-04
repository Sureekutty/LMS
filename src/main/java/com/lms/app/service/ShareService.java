package com.lms.app.service;

import com.lms.app.model.Member;
import com.lms.app.model.ShareTransaction;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.ShareTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class ShareService {

    @Autowired
    private ShareTransactionRepository shareRepo;

    @Autowired
    private MemberRepository memberRepo;

    public List<ShareTransaction> getAllTransactions() {
        return shareRepo.findAll();
    }

    public List<ShareTransaction> getTransactionsByMember(Long memberId) {
        return shareRepo.findByMemberId(memberId);
    }

    @Transactional
    public ShareTransaction purchaseShares(ShareTransaction tx) {
        Member member = memberRepo.findById(tx.getMember().getId())
                .orElseThrow(() -> new RuntimeException("Member not found"));

        BigDecimal sharePrice = new BigDecimal("100.00");
        BigDecimal calculatedAmt = sharePrice.multiply(new BigDecimal(tx.getShareCount()));
        tx.setAmount(calculatedAmt);
        tx.setMember(member);

        int updatedShares = (member.getNoOfShares() != null ? member.getNoOfShares() : 0) + tx.getShareCount();
        member.setNoOfShares(updatedShares);
        
        BigDecimal updatedCapital = (member.getShareCapital() != null ? member.getShareCapital() : BigDecimal.ZERO).add(calculatedAmt);
        member.setShareCapital(updatedCapital);
        
        memberRepo.save(member);

        return shareRepo.save(tx);
    }
}
