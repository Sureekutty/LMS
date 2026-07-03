package com.lms.app.repository;

import com.lms.app.model.MonthlyProcess;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MonthlyProcessRepository extends JpaRepository<MonthlyProcess, Long> {
    List<MonthlyProcess> findByProcessMonth(String processMonth);
    List<MonthlyProcess> findByProcessMonthAndPurpose(String processMonth, String purpose);
    void deleteByProcessMonth(String processMonth);
}
