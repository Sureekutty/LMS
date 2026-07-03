package com.lms.app.config;

import com.lms.app.model.Member;
import com.lms.app.model.Role;
import com.lms.app.model.User;
import com.lms.app.repository.MemberRepository;
import com.lms.app.repository.RoleRepository;
import com.lms.app.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Configuration
public class UserRoleDataSeeder {

    @Bean
    CommandLineRunner seedUsersAndRoles(
            UserRepository userRepo,
            RoleRepository roleRepo,
            MemberRepository memberRepo,
            PasswordEncoder passwordEncoder) {
        return args -> {
            // Seed roles
            Role adminRole = roleRepo.findByName("ROLE_ADMIN").orElseGet(() -> roleRepo.save(new Role(null, "ROLE_ADMIN", "Administrator", null)));
            Role clerkRole = roleRepo.findByName("ROLE_CLERK").orElseGet(() -> roleRepo.save(new Role(null, "ROLE_CLERK", "Clerk Operator", null)));
            Role accountantRole = roleRepo.findByName("ROLE_ACCOUNTANT").orElseGet(() -> roleRepo.save(new Role(null, "ROLE_ACCOUNTANT", "Accountant Auditor", null)));
            Role memberRole = roleRepo.findByName("ROLE_MEMBER").orElseGet(() -> roleRepo.save(new Role(null, "ROLE_MEMBER", "Society Member", null)));

            String defaultPassword = passwordEncoder.encode("password123");

            // 1. Seed Admin
            if (!userRepo.findByUsername("admin").isPresent()) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setPassword(defaultPassword);
                admin.setEmail("admin@lms.com");
                admin.setDisplayName("System Admin");
                admin.setFirstName("System");
                admin.setLastName("Admin");
                admin.setIsActive(true);
                admin.getRoles().add(adminRole);
                userRepo.save(admin);
                System.out.println("✅ Seeded Admin user (username: admin / password: password123)");
            }

            // 2. Seed Clerk
            if (!userRepo.findByUsername("clerk").isPresent()) {
                User clerk = new User();
                clerk.setUsername("clerk");
                clerk.setPassword(defaultPassword);
                clerk.setEmail("clerk@lms.com");
                clerk.setDisplayName("Clerk Operator");
                clerk.setFirstName("Clerk");
                clerk.setLastName("Operator");
                clerk.setIsActive(true);
                clerk.getRoles().add(clerkRole);
                userRepo.save(clerk);
                System.out.println("✅ Seeded Clerk user (username: clerk / password: password123)");
            }

            // 3. Seed Accountant
            if (!userRepo.findByUsername("accountant").isPresent()) {
                User accountant = new User();
                accountant.setUsername("accountant");
                accountant.setPassword(defaultPassword);
                accountant.setEmail("accountant@lms.com");
                accountant.setDisplayName("Accountant Auditor");
                accountant.setFirstName("Accountant");
                accountant.setLastName("Auditor");
                accountant.setIsActive(true);
                accountant.getRoles().add(accountantRole);
                userRepo.save(accountant);
                System.out.println("✅ Seeded Accountant user (username: accountant / password: password123)");
            }

            // 4. Seed Member
            if (!userRepo.findByUsername("member").isPresent()) {
                // Ensure a member profile exists first
                Member memberProfile = memberRepo.findByMembershipNo("MEM001").orElseGet(() -> {
                    Member profile = new Member();
                    profile.setMembershipNo("MEM001");
                    profile.setName("John Doe Member");
                    profile.setDesignation("Engineer");
                    profile.setFatherHusbandName("Richard Doe");
                    profile.setStaffCode("SC101");
                    profile.setSectionDivision("Telecom");
                    profile.setAge(35);
                    profile.setDateOfBirth(LocalDate.of(1991, 1, 1));
                    profile.setDateOfJoining(LocalDate.of(2020, 1, 1));
                    profile.setBankAccountNo("1234567890");
                    profile.setBasicPay(new BigDecimal("60000.00"));
                    profile.setShareCapital(new BigDecimal("10000.00"));
                    profile.setThriftDeposit(new BigDecimal("25000.00"));
                    profile.setPhoneNo("9876543210");
                    profile.setIsActive(true);
                    return memberRepo.save(profile);
                });

                User memberUser = new User();
                memberUser.setUsername("member");
                memberUser.setPassword(defaultPassword);
                memberUser.setEmail("member@lms.com");
                memberUser.setDisplayName("John Doe");
                memberUser.setFirstName("John");
                memberUser.setLastName("Doe");
                memberUser.setMember(memberProfile);
                memberUser.setIsActive(true);
                memberUser.getRoles().add(memberRole);
                userRepo.save(memberUser);
                System.out.println("✅ Seeded Member user (username: member / password: password123)");
            }
        };
    }
}
