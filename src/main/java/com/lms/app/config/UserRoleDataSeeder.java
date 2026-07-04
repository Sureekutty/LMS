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

            String defaultPassword = passwordEncoder.encode("password123!");

            // Delete existing users to ensure clean slate
            userRepo.findByUsername("admin").ifPresent(u -> { userRepo.delete(u); userRepo.flush(); });
            userRepo.findByUsername("clerk").ifPresent(u -> { userRepo.delete(u); userRepo.flush(); });
            userRepo.findByUsername("accountant").ifPresent(u -> { userRepo.delete(u); userRepo.flush(); });
            userRepo.findByUsername("member").ifPresent(u -> { userRepo.delete(u); userRepo.flush(); });

            // Create admin user
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

            // Create clerk user
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

            // Create accountant user
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

            // Create MEM001 profile & member user
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

            // Create extra member profiles (MEM002, MEM003, MEM004) if not exist
            if (!memberRepo.findByMembershipNo("MEM002").isPresent()) {
                Member m2 = new Member();
                m2.setMembershipNo("MEM002");
                m2.setName("Alice Smith");
                m2.setDesignation("Manager");
                m2.setFatherHusbandName("Gary Smith");
                m2.setStaffCode("SC102");
                m2.setSectionDivision("Accounts");
                m2.setAge(42);
                m2.setDateOfBirth(LocalDate.of(1984, 5, 12));
                m2.setDateOfJoining(LocalDate.of(2015, 6, 1));
                m2.setBankAccountNo("9876543211");
                m2.setBasicPay(new BigDecimal("95000.00"));
                m2.setShareCapital(new BigDecimal("15000.00"));
                m2.setThriftDeposit(new BigDecimal("45000.00"));
                m2.setPhoneNo("9876543211");
                m2.setIsActive(true);
                memberRepo.save(m2);
            }

            if (!memberRepo.findByMembershipNo("MEM003").isPresent()) {
                Member m3 = new Member();
                m3.setMembershipNo("MEM003");
                m3.setName("Bob Johnson");
                m3.setDesignation("Supervisor");
                m3.setFatherHusbandName("Donald Johnson");
                m3.setStaffCode("SC103");
                m3.setSectionDivision("Production");
                m3.setAge(29);
                m3.setDateOfBirth(LocalDate.of(1997, 8, 22));
                m3.setDateOfJoining(LocalDate.of(2022, 3, 15));
                m3.setBankAccountNo("9876543212");
                m3.setBasicPay(new BigDecimal("45000.00"));
                m3.setShareCapital(new BigDecimal("5000.00"));
                m3.setThriftDeposit(new BigDecimal("12000.00"));
                m3.setPhoneNo("9876543212");
                m3.setIsActive(true);
                memberRepo.save(m3);
            }

            if (!memberRepo.findByMembershipNo("MEM004").isPresent()) {
                Member m4 = new Member();
                m4.setMembershipNo("MEM004");
                m4.setName("Charlie Brown");
                m4.setDesignation("Assistant");
                m4.setFatherHusbandName("Linus Brown");
                m4.setStaffCode("SC104");
                m4.setSectionDivision("Administration");
                m4.setAge(31);
                m4.setDateOfBirth(LocalDate.of(1995, 11, 4));
                m4.setDateOfJoining(LocalDate.of(2021, 10, 1));
                m4.setBankAccountNo("9876543213");
                m4.setBasicPay(new BigDecimal("35000.00"));
                m4.setShareCapital(new BigDecimal("8000.00"));
                m4.setThriftDeposit(new BigDecimal("18000.00"));
                m4.setPhoneNo("9876543213");
                m4.setIsActive(true);
                memberRepo.save(m4);
            }

            System.out.println("✅ All system users re-seeded cleanly with password123, and dummy members created!");
        };
    }
}
