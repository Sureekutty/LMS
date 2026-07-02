package com.lms.app.aspect;

import com.lms.app.service.AuditLogService;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Aspect
@Component
public class AuditLogAspect {

    @Autowired
    private AuditLogService auditLogService;

    // Define pointcut for sensitive loan service operations
    @Pointcut("execution(* com.lms.app.service.LoanService.approveLoan(..)) || " +
              "execution(* com.lms.app.service.LoanService.rejectLoan(..)) || " +
              "execution(* com.lms.app.service.LoanService.disburseLoan(..))")
    public void loanOperations() {}

    // Define pointcut for sensitive nominee service operations
    @Pointcut("execution(* com.lms.app.service.NomineeService.saveNominee(..)) || " +
              "execution(* com.lms.app.service.NomineeService.deleteNominee(..))")
    public void nomineeOperations() {}

    // Define pointcut for sensitive share service operations
    @Pointcut("execution(* com.lms.app.service.ShareService.buyShares(..)) || " +
              "execution(* com.lms.app.service.ShareService.transferShares(..)) || " +
              "execution(* com.lms.app.service.ShareService.redeemShares(..))")
    public void shareOperations() {}

    @AfterReturning(pointcut = "loanOperations() || nomineeOperations() || shareOperations()", returning = "result")
    public void logSensitiveOperation(JoinPoint joinPoint, Object result) {
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getSignature().getDeclaringTypeName();
        Object[] args = joinPoint.getArgs();

        String username = "SYSTEM";
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            username = authentication.getName();
        }

        String action = className.substring(className.lastIndexOf('.') + 1) + "." + methodName;
        String details = "Arguments: " + Arrays.toString(args);
        
        auditLogService.log(action, username, details);
    }
}
