package org.society.controller;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.FileOutputStream;
import java.time.LocalDate;
import java.time.Period;

public class LoanApplicationPDF04062025 {
    public static void main(String[] args) {
        try {
            PdfReader reader = new PdfReader("C:/Users/Administrator/Desktop/LoanApplicationForm.pdf");
            PdfStamper stamper = new PdfStamper(reader, new FileOutputStream("Loan_Application.pdf"));
            BaseFont font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);

            LocalDate dob = LocalDate.of(1999, 9, 10);
            LocalDate curDate=LocalDate.now();
            Period age = Period.between(dob, curDate);
            System.out.println(age);
            // Page 1 - Applicant Info
            PdfContentByte page1 = stamper.getOverContent(1);
            page1.beginText();
            page1.setFontAndSize(font, 11);
            page1.showTextAligned(Element.ALIGN_CENTER, "John Doe", 380.10f, 900.10f, 0); // Name
            page1.showTextAligned(Element.ALIGN_CENTER, "Engineer",380.10f, 878.10f, 0); // Designation
            page1.showTextAligned(Element.ALIGN_CENTER, "Mr. Doe Sr.", 380.10f, 856.10f, 0); // Father's Name
            page1.showTextAligned(Element.ALIGN_CENTER, "SH123456", 380.10f, 830.10f, 0); // Staff Code
            page1.showTextAligned(Element.ALIGN_CENTER, "COWAA", 380.10f, 807.10f, 0); // Section
            page1.showTextAligned(Element.ALIGN_CENTER, "35, 01-Jan-1989",380.10f, 786.10f, 0); // Age & DOB
            page1.showTextAligned(Element.ALIGN_RIGHT, "15-Mar-2010", 300.10f, 743.10f, 0); // DOJ
            page1.showTextAligned(Element.ALIGN_CENTER, "1234567890",  307.10f, 722.10f, 0); // Bank Account No
            page1.showTextAligned(Element.ALIGN_RIGHT, "YES", 290.10f, 687.10f, 0); // Member of other society
            page1.showTextAligned(Element.ALIGN_LEFT, "123 ISRO Colony, SHAR",420.10f, 687.10f, 0); // Address
            page1.showTextAligned(Element.ALIGN_RIGHT, "SURETY1", 270.10f, 484.10f, 0); // Surety1
            page1.showTextAligned(Element.ALIGN_CENTER, "SURETY2",375.10f, 484.10f, 0); // Surety2
            page1.showTextAligned(Element.ALIGN_LEFT, "SURETY3", 480.10f, 484.10f, 0); // Surety3
            page1.showTextAligned(Element.ALIGN_RIGHT, "COWAA ", 270.10f, 463.10f, 0); // Surety1 desg
            page1.showTextAligned(Element.ALIGN_CENTER, "COWAA",375.10f, 463.10f, 0); // Surety2 desg
            page1.showTextAligned(Element.ALIGN_LEFT, "COWAA", 480.10f,463.10f, 0); // Surety3 desg
            page1.showTextAligned(Element.ALIGN_RIGHT, "SH123456",270.10f, 441.10f, 0); // Surety1 code
            page1.showTextAligned(Element.ALIGN_CENTER, "SH123456",375.10f, 441.10f, 0); // Surety2 code
            page1.showTextAligned(Element.ALIGN_LEFT, "SH123456", 480.10f 	, 441.10f, 0); // Surety3 code
            page1.showTextAligned(Element.ALIGN_RIGHT, "15-Mar-2010 ", 270.10f, 395.10f, 0); // Surety1 date of retirement
            page1.showTextAligned(Element.ALIGN_CENTER, "15-Mar-2010",375.10f, 395.10f, 0); // Surety2 date of retirement
            page1.showTextAligned(Element.ALIGN_LEFT, "15-Mar-2010", 480.10f,395.10f, 0); // Surety3 date of retirement
            page1.showTextAligned(Element.ALIGN_RIGHT, "xyz",265.10f, 370.10f, 0); // Surety1 father name
            page1.showTextAligned(Element.ALIGN_CENTER, "xyz",375.10f, 370.10f, 0); // Surety2 father name
            page1.showTextAligned(Element.ALIGN_LEFT, "xyz", 487.10f 	, 370.10f, 0); // Surety3 father name
            page1.showTextAligned(Element.ALIGN_RIGHT, "123 ", 265.10f, 345.10f, 0); // Surety1 Basic Pay
            page1.showTextAligned(Element.ALIGN_CENTER, "123",375.10f, 345.10f, 0); // Surety2 Basic Pay
            page1.showTextAligned(Element.ALIGN_LEFT, "123", 487.10f,345.10f, 0); // Surety3 Basic Pay
            page1.showTextAligned(Element.ALIGN_RIGHT, "456",265.10f, 320.10f, 0); // Surety2 Share Capital
            page1.showTextAligned(Element.ALIGN_CENTER, "456", 375.10f 	, 320.10f, 0); // Surety3 Share Capital
            page1.showTextAligned(Element.ALIGN_LEFT, "456", 487.10f,320.10f, 0); // Surety3 Share Capital
            page1.showTextAligned(Element.ALIGN_RIGHT, "789 ", 265.10f, 296.10f, 0); // Surety1 Thrift Deposit
            page1.showTextAligned(Element.ALIGN_CENTER, "789",375.10f, 296.10f, 0); // Surety2 Thrift Deposit
            page1.showTextAligned(Element.ALIGN_LEFT, "789", 487.10f,296.10f, 0); // Surety3 Thrift Deposit
            page1.showTextAligned(Element.ALIGN_RIGHT, "SH123456",270.10f, 273.10f, 0); // Surety1 Permanent Address
            page1.showTextAligned(Element.ALIGN_CENTER, "SH123456",375.10f, 273.10f, 0); // Surety2 Permanent Address
            page1.showTextAligned(Element.ALIGN_LEFT, "SH123456", 480.10f 	, 273.10f, 0); // Surety3 Permanent Address
            
            font = BaseFont.createFont(BaseFont.COURIER, BaseFont.WINANSI, BaseFont.EMBEDDED);
            page1.setFontAndSize(font, 9);
            page1.showTextAligned(Element.ALIGN_LEFT, "SURETY1", 75.10f,103.10f, 0); // Surety1
            page1.showTextAligned(Element.ALIGN_RIGHT, "SURETY2",242.10f, 103.10f, 0); // Surety2
            page1.showTextAligned(Element.ALIGN_CENTER, "SURETY3",334.10f, 103.10f, 0); // Surety3
            page1.showTextAligned(Element.ALIGN_LEFT, "John Doe", 444.10f 	, 103.10f, 0); // Loanee Name
           
            page1.endText();

            // Page 2 - Sureties Info
            //font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
            PdfContentByte page2 = stamper.getOverContent(2);
            page2.beginText();
            page2.setFontAndSize(font, 11);
            page2.showTextAligned(Element.ALIGN_RIGHT, "SURETY1", 190.10f, 615.10f, 0); // Surety1
            page2.showTextAligned(Element.ALIGN_LEFT, "John Doe",380.10f, 615.10f, 0); // Loanee Name
            page2.showTextAligned(Element.ALIGN_RIGHT, "SURETY2",190.10f, 549.10f, 0); // Surety2
            page2.showTextAligned(Element.ALIGN_LEFT, "SURETY3", 380.10f, 549.10f, 0); // Surety3
            page2.showTextAligned(Element.ALIGN_RIGHT, "SURETY1", 181.10f, 172.10f, 0); // Surety1
            page2.showTextAligned(Element.ALIGN_LEFT, "John Doe",375.10f, 172.10f, 0); // Loanee Name
            page2.showTextAligned(Element.ALIGN_RIGHT, "SURETY2",181.10f, 108.10f, 0); // Surety2
            page2.showTextAligned(Element.ALIGN_LEFT, "SURETY3", 375.10f, 108.10f, 0); // Surety3
            
            page2.endText();

            // Page 3 - Loanee Summary
            font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
            PdfContentByte page3 = stamper.getOverContent(3);
            page3.beginText();
            page3.setFontAndSize(font, 11);
            page3.showTextAligned(Element.ALIGN_RIGHT, "John Doe",380.10f, 843.10f, 0); // Loanee Name
            page3.showTextAligned(Element.ALIGN_RIGHT, "SURETY1",380.10f, 715.10f, 0); // Surety1
            page3.showTextAligned(Element.ALIGN_RIGHT, "SURETY2", 380.10f, 589.10f, 0); // Surety2
            page3.showTextAligned(Element.ALIGN_RIGHT, "SURETY3", 380.10f, 466.10f, 0); // Surety3
            page3.showTextAligned(Element.ALIGN_RIGHT, "John Doe", 330.10f, 290.10f, 0); // Loanee Name
            page3.endText();

            font = BaseFont.createFont(BaseFont.COURIER, BaseFont.WINANSI, BaseFont.EMBEDDED);
            PdfContentByte page4 = stamper.getOverContent(4);
            page4.beginText();
            page4.setFontAndSize(font, 11);
            page4.showTextAligned(Element.ALIGN_RIGHT, "SURETY1",205.10f, 697.10f, 0); // Surety1
            page4.showTextAligned(Element.ALIGN_LEFT, "John Doe", 430.10f, 697.10f, 0); // Loanee Name
            page4.showTextAligned(Element.ALIGN_RIGHT, "SURETY2", 205.10f, 633.10f, 0); // Surety2
            page4.showTextAligned(Element.ALIGN_LEFT, "SURETY3",430.10f, 633.10f, 0); // Surety3
            
            page4.endText();
            
            stamper.close();
            reader.close();

            //System.out.println(" PDF filled and saved successfully as 'Filled_Loan_Application.pdf'");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
