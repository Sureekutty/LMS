package com.lms.app.repository;

import com.lms.app.model.Bill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BillRepository extends JpaRepository<Bill, Long> {
    List<Bill> findByProcessMonth(String processMonth);
    List<Bill> findByMemberIdOrderByProcessMonthDesc(Long memberId);
    Optional<Bill> findByMemberIdAndProcessMonth(Long memberId, String processMonth);
    void deleteByProcessMonth(String processMonth);
}
