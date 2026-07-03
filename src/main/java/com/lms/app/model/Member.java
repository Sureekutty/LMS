package com.lms.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "members")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "membership_no", nullable = false, unique = true, length = 20)
    private String membershipNo;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 100)
    private String designation;

    @Column(name = "father_husband_name", length = 100)
    private String fatherHusbandName;

    @Column(name = "staff_code", unique = true, length = 20)
    private String staffCode;

    @Column(name = "section_division", length = 100)
    private String sectionDivision;

    private Integer age;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "date_of_joining")
    private LocalDate dateOfJoining;

    @Column(name = "bank_account_no", length = 30)
    private String bankAccountNo;

    @Column(name = "residential_address", columnDefinition = "TEXT")
    private String residentialAddress;

    @Column(name = "basic_pay", precision = 10, scale = 2)
    private BigDecimal basicPay;

    @Column(name = "share_capital", precision = 10, scale = 2)
    private BigDecimal shareCapital = BigDecimal.ZERO;

    @Column(name = "thrift_deposit", precision = 10, scale = 2)
    private BigDecimal thriftDeposit = BigDecimal.ZERO;

    @Column(name = "phone_no", length = 15)
    private String phoneNo;

    // ===== NEW FIELDS FOR LMS =====

    @Column(name = "pan_no", length = 20)
    private String panNo;

    @Column(name = "aadhar_no", length = 15)
    private String aadharNo;

    @Column(length = 150)
    private String email;

    @Column(name = "office_phone", length = 15)
    private String officePhone;

    @Column(name = "ifsc_code", length = 14)
    private String ifscCode;

    @Column(name = "bank_name", length = 100)
    private String bankName;

    @Column(name = "bank_place", length = 75)
    private String bankPlace;

    @Column(name = "retirement_date")
    private LocalDate retirementDate;

    @Column(name = "membership_fee", precision = 10, scale = 2)
    private BigDecimal membershipFee;

    @Column(name = "no_of_shares")
    private Integer noOfShares = 0;

    @Column(name = "welfare_fund", precision = 10, scale = 2)
    private BigDecimal welfareFund = BigDecimal.ZERO;

    @Column(name = "closed_date")
    private LocalDateTime closedDate;

    @Column(name = "nominee_name", length = 100)
    private String nomineeName;

    @Column(name = "nominee_dob")
    private LocalDate nomineeDob;

    @Column(name = "nominee_relationship", length = 50)
    private String nomineeRelationship;

    @Column(name = "nominee_gender", length = 20)
    private String nomineeGender;

    @Column(name = "nominee_address", columnDefinition = "TEXT")
    private String nomineeAddress;

    @Column(length = 250)
    private String remarks;

    // ===== END NEW FIELDS =====

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}