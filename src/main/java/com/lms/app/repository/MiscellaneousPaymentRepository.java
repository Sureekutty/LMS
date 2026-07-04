package com.lms.app.repository;

import com.lms.app.model.MiscellaneousPayment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MiscellaneousPaymentRepository extends JpaRepository<MiscellaneousPayment, Long> {
    List<MiscellaneousPayment> findByOrderByPaymentDateDesc();
    List<MiscellaneousPayment> findByMemberIdOrderByPaymentDateDesc(Long memberId);
}
