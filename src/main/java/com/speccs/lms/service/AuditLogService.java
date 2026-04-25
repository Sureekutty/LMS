package com.speccs.lms.service;

import com.speccs.lms.model.AuditLog;
import com.speccs.lms.repository.AuditLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AuditLogService {

    @Autowired
    private AuditLogRepository auditLogRepository;

    // Log any action
    public void log(String action, String performedBy, String details) {
        AuditLog auditLog = new AuditLog();
        auditLog.setAction(action);
        auditLog.setPerformedBy(performedBy);
        auditLog.setDetails(details);
        auditLogRepository.save(auditLog);
    }

    // Get logs by user
    public List<AuditLog> getLogsByUser(String performedBy) {
        return auditLogRepository.findByPerformedBy(performedBy);
    }

    // Get all logs
    public List<AuditLog> getAllLogs() {
        return auditLogRepository.findAll();
    }
}