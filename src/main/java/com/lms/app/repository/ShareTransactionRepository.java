package com.lms.app.repository;

import com.lms.app.model.ShareTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ShareTransactionRepository extends JpaRepository<ShareTransaction, Long> {
    List<ShareTransaction> findByMemberId(Long memberId);
}
