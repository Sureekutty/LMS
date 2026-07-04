package org.society.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.society.util.DataBaseConnectionForNewDB;

import com.itextpdf.text.Element;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;

@SuppressWarnings("serial")
@WebServlet("/GeneratePDF")
public class LoanApplicationPDF extends HttpServlet {
	
	 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		Connection connection=null;
		HttpSession session = request.getSession();
		String empCode = (String) session.getAttribute("EMPLOYEECODE");
		try {
			
			
			
			
			
			
			 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	 
			//1 for employee Detail start
			String MemName="",Designation="",Division="",CareOf="",Dob="",BankAccNo="",BasicPay="",Address="";
            String sqlQuery = "Select * from speccs.Members where MemEmpCode='"+empCode+"'";     
            PreparedStatement  ps = connection.prepareStatement(sqlQuery); 
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
            	MemName= rs.getString("MemName");
            	Designation=rs.getString("Designation");
            	Division=rs.getString("Division");
            	CareOf=rs.getString("CareOf");
            	Dob=rs.getString("Dob");
            	BankAccNo=rs.getString("BankAccNo");
            	BasicPay=rs.getString("BasicPay");
            }
           // end 1
          //2 for member acc detail 
			String ShareAmount="",ThriftBalance="";
            String sqlQuery1 = "Select * from speccs.MemberAccount where MemAccNo=(Select MemAccNo from speccs.Members where MemEmpCode='"+empCode+"')";     
            PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) {
            	ShareAmount=rs1.getString("ShareAmount");
            	ThriftBalance=rs1.getString("ThriftBalance");
            }
            //end 2
           //3 for member surety start
			String SuretyAcc1="",SuretyAcc2="",SuretyAcc3="";
			String sqlQuery2 = "Select SMemAccNo,count(MemAccNo) AS counts from speccs.Surety where MemAccNo=(Select MemAccNo from speccs.Members where MemEmpCode='"+empCode+"') GROUP BY MemAccNo";     
            PreparedStatement  ps2 = connection.prepareStatement(sqlQuery2); 
            ResultSet rs2 = ps2.executeQuery();
            int count=0;
           while(rs2.next()) {
        	   if(count==0)
        		   SuretyAcc1=rs2.getString("SMemAccNo");
        	   if(count==1) 
        		   SuretyAcc2=rs2.getString("SMemAccNo");       		           	   
        	   if(count==2) 
        		   SuretyAcc3=rs2.getString("SMemAccNo");       		          	   
        	   count++;
           }
           
			//end 3
         //4 for member Surety detail start 
			String Surety1="",SMemName1="",SDesignation1="",SDivision1="",SCareOf1="",SRetiredDate1="",SDob1="",SAddress1="",SBasicPay1="";
			String Surety2="",SMemName2="",SDesignation2="",SDivision2="",SCareOf2="",SRetiredDate2="",SDob2="",SAddress2="",SBasicPay2="";
			String Surety3="",SMemName3="",SDesignation3="",SDivision3="",SCareOf3="",SRetiredDate3="",SDob3="",SAddress3="",SBasicPay3="";
            String SurDet = "Select * from speccs.Members where MemAccNo IN ('"+SuretyAcc1+"','"+SuretyAcc2+"','"+SuretyAcc3+"')";     
            PreparedStatement  ps3 = connection.prepareStatement(SurDet); 
            ResultSet rs3 = ps3.executeQuery();
            while(rs3.next()) { 
            	if(SuretyAcc1.equals(rs3.getString("MemAccNo").trim())) {
	            	Surety1=rs3.getString("MemEmpCode");
	            	SMemName1= rs3.getString("MemName");
	            	SDesignation1=rs3.getString("Designation");
	            	SDivision1=rs3.getString("Division");
	            	SCareOf1=rs3.getString("CareOf");
	            	SDob1=rs3.getString("Dob");
	            	SBasicPay1=rs3.getString("BasicPay");
	            	SRetiredDate1=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(rs3.getString("RetiredDate")));
            	}
            	if(SuretyAcc2.equals(rs3.getString("MemAccNo").trim())) {
            		Surety2=rs3.getString("MemEmpCode");
                	SMemName2= rs3.getString("MemName");
                	SDesignation2=rs3.getString("Designation");
                	SDivision2=rs3.getString("Division");
                	SCareOf2=rs3.getString("CareOf");
                	SDob2=rs3.getString("Dob");
                	SBasicPay2=rs3.getString("BasicPay");
                	SRetiredDate2=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(rs3.getString("RetiredDate")));
            	}
            	if(SuretyAcc3.equals(rs3.getString("MemAccNo").trim())) {
            		Surety3=rs3.getString("MemEmpCode");
                	SMemName3= rs3.getString("MemName");
                	SDesignation3=rs3.getString("Designation");
                	SDivision3=rs3.getString("Division");
                	SCareOf3=rs3.getString("CareOf");
                	SDob3=rs3.getString("Dob");
                	SBasicPay3=rs3.getString("BasicPay");
                	SRetiredDate3=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(rs3.getString("RetiredDate")));
            	}
            }
         
			//end 4
          //5 for member surety acc detail 
			String SShareAmount1="",SThriftBalanc1="";
			String SShareAmount2="",SThriftBalanc2="";
			String SShareAmount3="",SThriftBalanc3="";
			 String SurAccDet = "Select * from speccs.MemberAccount where MemAccNo IN ('"+SuretyAcc1+"','"+SuretyAcc2+"','"+SuretyAcc3+"')";     
	            PreparedStatement  ps4 = connection.prepareStatement(SurAccDet); 
	            ResultSet rs4 = ps4.executeQuery();
	            while(rs4.next()) { 
	            	if(SuretyAcc1.equals(rs4.getString("MemAccNo").trim())) {
		            	SShareAmount1=rs4.getString("ShareAmount");
		            	SThriftBalanc1=rs4.getString("ThriftBalance");
	            	}
	            	if(SuretyAcc2.equals(rs4.getString("MemAccNo").trim())) {
	            		SShareAmount2=rs4.getString("ShareAmount");
		            	SThriftBalanc2=rs4.getString("ThriftBalance");
	            	}
	            	if(SuretyAcc3.equals(rs4.getString("MemAccNo").trim())) {
	            		SShareAmount3=rs4.getString("ShareAmount");
		            	SThriftBalanc3=rs4.getString("ThriftBalance");
	            	}
	            }
			
			//end 5
		 //ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		 PrintWriter out = response.getWriter();
		 String relativePath = request.getServletContext().getRealPath("webapp/commonFiles/pdf/LoanApplicationForm.pdf");
		 PdfReader reader = new PdfReader(relativePath);
         PdfStamper stamper = new PdfStamper(reader, new FileOutputStream("Filled_Loan_Application.pdf"));
         BaseFont font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         Dob=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(Dob));
         // Page 1 - Applicant Info
         PdfContentByte page1 = stamper.getOverContent(1);
         page1.beginText();
         page1.setFontAndSize(font, 11);
         page1.showTextAligned(Element.ALIGN_CENTER, MemName, 380.10f, 900.10f, 0); // Name
         page1.showTextAligned(Element.ALIGN_CENTER, Designation,380.10f, 878.10f, 0); // Designation
         page1.showTextAligned(Element.ALIGN_CENTER, CareOf, 380.10f, 856.10f, 0); // Father's Name
         page1.showTextAligned(Element.ALIGN_CENTER, empCode, 380.10f, 830.10f, 0); // Staff Code
         page1.showTextAligned(Element.ALIGN_CENTER, Division, 380.10f, 807.10f, 0); // Section
         page1.showTextAligned(Element.ALIGN_CENTER, Dob,380.10f, 786.10f, 0); // Age & DOB
         //page1.showTextAligned(Element.ALIGN_RIGHT, "15-Mar-2010", 300.10f, 743.10f, 0); // DOJ
         page1.showTextAligned(Element.ALIGN_CENTER, BankAccNo,  307.10f, 722.10f, 0); // Bank Account No
         page1.showTextAligned(Element.ALIGN_RIGHT, BasicPay, 285.10f, 640.10f, 0); // basic pay
         page1.showTextAligned(Element.ALIGN_RIGHT, ShareAmount, 395.10f, 640.10f, 0); // share capital
         page1.showTextAligned(Element.ALIGN_LEFT, ThriftBalance, 460.10f, 640.10f, 0); // thrift balance
         //page1.showTextAligned(Element.ALIGN_LEFT, "",420.10f, 687.10f, 0); // Address
         font = BaseFont.createFont(BaseFont.COURIER, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page1.setFontAndSize(font, 9);
         page1.showTextAligned(Element.ALIGN_RIGHT, SMemName1, 270.10f, 484.10f, 0); // Surety1
         page1.showTextAligned(Element.ALIGN_CENTER, SMemName2,375.10f, 484.10f, 0); // Surety2
         page1.showTextAligned(Element.ALIGN_LEFT, SMemName3, 450.10f, 484.10f, 0); // Surety3
         page1.showTextAligned(Element.ALIGN_RIGHT, SDesignation1, 270.10f, 463.10f, 0); // Surety1 desg
         page1.showTextAligned(Element.ALIGN_CENTER, SDesignation2,365.10f, 463.10f, 0); // Surety2 desg
         page1.showTextAligned(Element.ALIGN_LEFT,SDesignation3, 430.10f,463.10f, 0); // Surety3 desg
         page1.setFontAndSize(font, 11);
         page1.showTextAligned(Element.ALIGN_RIGHT, Surety1,270.10f, 441.10f, 0); // Surety1 code
         page1.showTextAligned(Element.ALIGN_CENTER, Surety2,375.10f, 441.10f, 0); // Surety2 code
         page1.showTextAligned(Element.ALIGN_LEFT, Surety3, 480.10f 	, 441.10f, 0); // Surety3 code
         page1.showTextAligned(Element.ALIGN_RIGHT, SRetiredDate1, 270.10f, 395.10f, 0); // Surety1 date of retirement
         page1.showTextAligned(Element.ALIGN_CENTER, SRetiredDate2,375.10f, 395.10f, 0); // Surety2 date of retirement
         page1.showTextAligned(Element.ALIGN_LEFT, SRetiredDate3, 480.10f,395.10f, 0); // Surety3 date of retirement
         page1.showTextAligned(Element.ALIGN_RIGHT, CareOf,265.10f, 370.10f, 0); // Surety1 father name
         page1.showTextAligned(Element.ALIGN_CENTER, CareOf,375.10f, 370.10f, 0); // Surety2 father name
         page1.showTextAligned(Element.ALIGN_LEFT, CareOf, 487.10f 	, 370.10f, 0); // Surety3 father name
         page1.showTextAligned(Element.ALIGN_RIGHT,SBasicPay1, 265.10f, 345.10f, 0); // Surety1 Basic Pay
         page1.showTextAligned(Element.ALIGN_CENTER, SBasicPay2,375.10f, 345.10f, 0); // Surety2 Basic Pay
         page1.showTextAligned(Element.ALIGN_LEFT,SBasicPay3, 487.10f,345.10f, 0); // Surety3 Basic Pay
         page1.showTextAligned(Element.ALIGN_RIGHT, SShareAmount1,265.10f, 320.10f, 0); // Surety2 Share Capital
         page1.showTextAligned(Element.ALIGN_CENTER, SShareAmount2, 375.10f 	, 320.10f, 0); // Surety3 Share Capital
         page1.showTextAligned(Element.ALIGN_LEFT, SShareAmount3, 487.10f,320.10f, 0); // Surety3 Share Capital
         page1.showTextAligned(Element.ALIGN_RIGHT, SThriftBalanc1, 265.10f, 296.10f, 0); // Surety1 Thrift Deposit
         page1.showTextAligned(Element.ALIGN_CENTER,SThriftBalanc2,375.10f, 296.10f, 0); // Surety2 Thrift Deposit
         page1.showTextAligned(Element.ALIGN_LEFT, SThriftBalanc3, 487.10f,296.10f, 0); // Surety3 Thrift Deposit
         page1.showTextAligned(Element.ALIGN_RIGHT, "",270.10f, 273.10f, 0); // Surety1 Permanent Address
         page1.showTextAligned(Element.ALIGN_CENTER, "",375.10f, 273.10f, 0); // Surety2 Permanent Address
         page1.showTextAligned(Element.ALIGN_LEFT, "", 480.10f 	, 273.10f, 0); // Surety3 Permanent Address
         
         font = BaseFont.createFont(BaseFont.COURIER, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page1.setFontAndSize(font, 9);
         page1.showTextAligned(Element.ALIGN_LEFT, SMemName1, 55.10f,96.10f, 0); // Surety1
         page1.showTextAligned(Element.ALIGN_RIGHT, SMemName2,250.10f, 96.10f, 0); // Surety2
         page1.showTextAligned(Element.ALIGN_CENTER, SMemName3,330.10f, 96.10f, 0); // Surety3
         page1.showTextAligned(Element.ALIGN_LEFT, MemName, 444.10f 	, 103.10f, 0); // Loanee Name
        
         page1.endText();

         // Page 2 - Sureties Info
         //font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         PdfContentByte page2 = stamper.getOverContent(2);
         page2.beginText();
         page2.setFontAndSize(font, 11);
         page2.showTextAligned(Element.ALIGN_RIGHT, SMemName1, 200.10f, 615.10f, 0); // Surety1
         page2.showTextAligned(Element.ALIGN_LEFT, MemName,380.10f, 615.10f, 0); // Loanee Name
         page2.showTextAligned(Element.ALIGN_RIGHT, SMemName2,250.10f, 549.10f, 0); // Surety2
         page2.showTextAligned(Element.ALIGN_LEFT, SMemName3, 380.10f, 549.10f, 0); // Surety3
         page2.showTextAligned(Element.ALIGN_RIGHT, SMemName1, 200.10f, 172.10f, 0); // Surety1
         page2.showTextAligned(Element.ALIGN_LEFT, MemName,375.10f, 172.10f, 0); // Loanee Name
         page2.showTextAligned(Element.ALIGN_RIGHT, SMemName2,250.10f, 108.10f, 0); // Surety2
         page2.showTextAligned(Element.ALIGN_LEFT,SMemName3, 375.10f, 108.10f, 0); // Surety3
         
         page2.endText();

         // Page 3 - Loanee Summary
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         PdfContentByte page3 = stamper.getOverContent(3);
         page3.beginText();
         page3.setFontAndSize(font, 11);
         page3.showTextAligned(Element.ALIGN_RIGHT, MemName,445.10f, 843.10f, 0); // Loanee Name
         page3.showTextAligned(Element.ALIGN_RIGHT,CareOf,480.10f, 820.10f, 0); // careof
         page3.showTextAligned(Element.ALIGN_RIGHT, empCode,200.10f, 765.10f, 0); // empcode
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 9);
         page3.showTextAligned(Element.ALIGN_RIGHT, Designation,420.10f, 765.10f, 0); // desg
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 7);
         page3.showTextAligned(Element.ALIGN_LEFT, Division,465.10f, 775.10f, 0); //division
         page3.setFontAndSize(font, 11);
         page3.showTextAligned(Element.ALIGN_RIGHT, SMemName1,380.10f, 715.10f, 0); // Surety1
         page3.showTextAligned(Element.ALIGN_RIGHT, SCareOf1,480.10f, 690.10f, 0); // careof
         page3.showTextAligned(Element.ALIGN_RIGHT, Surety1,200.10f, 645.10f, 0); // Surety empcode
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 9);
         page3.showTextAligned(Element.ALIGN_RIGHT, SDesignation1,420.10f, 645.10f, 0); // desg
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 7);
         page3.showTextAligned(Element.ALIGN_LEFT, SDivision1,465.10f, 645.10f, 0); //division
         page3.setFontAndSize(font, 11);
         page3.showTextAligned(Element.ALIGN_RIGHT, SMemName2, 380.10f, 589.10f, 0); // Surety2
         page3.showTextAligned(Element.ALIGN_RIGHT, SCareOf2,480.10f, 565.10f, 0); // careof
         page3.showTextAligned(Element.ALIGN_RIGHT, Surety2,200.10f, 520.10f, 0); // Surety empcode
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 9);
         page3.showTextAligned(Element.ALIGN_RIGHT, SDesignation2,420.10f, 520.10f, 0); // desg
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 7);
         page3.showTextAligned(Element.ALIGN_LEFT, SDivision2,465.10f, 520.10f, 0); //division
         page3.setFontAndSize(font, 11);
         page3.showTextAligned(Element.ALIGN_RIGHT, SMemName3, 380.10f, 466.10f, 0); // Surety3
         page3.showTextAligned(Element.ALIGN_RIGHT, SCareOf3,480.10f, 440.10f, 0); // careof
         page3.showTextAligned(Element.ALIGN_RIGHT, Surety3,200.10f, 390.10f, 0); // Surety empcode
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 9);
         page3.showTextAligned(Element.ALIGN_RIGHT, SDesignation3,420.10f, 390.10f, 0); // desg
         font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
         page3.setFontAndSize(font, 7);
         page3.showTextAligned(Element.ALIGN_LEFT, SDivision3,465.10f, 390.10f, 0); //division
         page3.setFontAndSize(font, 11);
         page3.showTextAligned(Element.ALIGN_RIGHT, MemName, 350.10f, 290.10f, 0); // Loanee Name
         page3.endText();

         font = BaseFont.createFont(BaseFont.COURIER, BaseFont.WINANSI, BaseFont.EMBEDDED);
         PdfContentByte page4 = stamper.getOverContent(4);
         page4.beginText();
         page4.setFontAndSize(font, 11);
         page4.showTextAligned(Element.ALIGN_RIGHT, SMemName1,135.10f, 680.10f, 0); // Surety1
         page4.showTextAligned(Element.ALIGN_LEFT, MemName, 365.10f, 680.10f, 0); // Loanee Name
         page4.showTextAligned(Element.ALIGN_RIGHT, SMemName2, 280.10f, 640.10f, 0); // Surety2
         page4.showTextAligned(Element.ALIGN_LEFT, SMemName3,420.10f, 640.10f, 0); // Surety3
         
         page4.endText();
         
         
			stamper.close();
		
         reader.close();

         System.out.println(" PDF filled and saved successfully as 'Filled_Loan_Application.pdf'");
         
         
	        // Send PDF to client
	     /*   response.setContentType("application/pdf");
	        response.setHeader("Content-Disposition", "attachment; filename=filled_template.pdf");
	        response.setContentLength(outputStream.size());
	        OutputStream out = response.getOutputStream();
	        outputStream.writeTo(out);
	        out.flush();*/
	        
	        
	    	String fileName = "Filled_Loan_Application.pdf";
			response.setContentType("application/pdf");
			
			File file1 = new File(fileName);
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			response.setContentLength((int) file1.length());
			FileInputStream fis = new FileInputStream(file1);
			int len = (int) file1.length();

			out.flush();
			int temp;

			while ((temp = fis.read()) != -1) {
				out.write(temp);
				out.flush();

			}
			
			out.close();
			fis.close();
			return;
	        
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	    }
    /*public static void main(String[] args) {
        try {
            PdfReader reader = new PdfReader("C:/Users/Administrator/Desktop/LoanApplicationForm.pdf");
            PdfStamper stamper = new PdfStamper(reader, new FileOutputStream("Filled_Loan_Application.pdf"));
            BaseFont font = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);

            // Page 1 - Applicant Info
            PdfContentByte page1 = stamper.getOverContent(1);
            page1.beginText();
            page1.setFontAndSize(font, 11);
            page1.showTextAligned(Element.ALIGN_CENTER, "John Doe", 380.10f, 840.10f, 0); // Name
            page1.showTextAligned(Element.ALIGN_CENTER, "Engineer",380.10f, 824.10f, 0); // Designation
            page1.showTextAligned(Element.ALIGN_CENTER, "Mr. Doe Sr.", 380.10f, 805.10f, 0); // Father's Name
            page1.showTextAligned(Element.ALIGN_CENTER, "SH123456", 380.10f, 782.10f, 0); // Staff Code
            page1.showTextAligned(Element.ALIGN_CENTER, "COWAA", 380.10f, 761.10f, 0); // Section
            page1.showTextAligned(Element.ALIGN_CENTER, "35, 01-Jan-1989",380.10f, 740.10f, 0); // Age & DOB
            page1.showTextAligned(Element.ALIGN_RIGHT, "15-Mar-2010", 300.10f, 701.10f, 0); // DOJ
            page1.showTextAligned(Element.ALIGN_CENTER, "1234567890",  380.10f, 681.10f, 0); // Bank Account No
            page1.showTextAligned(Element.ALIGN_RIGHT, "YES", 300.10f, 640.10f, 0); // Member of other society
            page1.showTextAligned(Element.ALIGN_LEFT, "123 ISRO Colony, SHAR",420.10f, 640.10f, 0); // Address
            page1.showTextAligned(Element.ALIGN_RIGHT, "SURETY1", 270.10f, 442.10f, 0); // Surety1
            page1.showTextAligned(Element.ALIGN_CENTER, "SURETY2",375.10f, 442.10f, 0); // Surety2
            page1.showTextAligned(Element.ALIGN_LEFT, "SURETY3", 480.10f, 442.10f, 0); // Surety3
            page1.showTextAligned(Element.ALIGN_RIGHT, "COWAA ", 270.10f, 425.10f, 0); // Surety1 desg
            page1.showTextAligned(Element.ALIGN_CENTER, "COWAA",375.10f, 425.10f, 0); // Surety2 desg
            page1.showTextAligned(Element.ALIGN_LEFT, "COWAA", 480.10f,425.10f, 0); // Surety3 desg
            page1.showTextAligned(Element.ALIGN_RIGHT, "SH123456",270.10f, 410.10f, 0); // Surety1 code
            page1.showTextAligned(Element.ALIGN_CENTER, "SH123456",375.10f, 410.10f, 0); // Surety2 code
            page1.showTextAligned(Element.ALIGN_LEFT, "SH123456", 480.10f 	, 410.10f, 0); // Surety3 code
            page1.showTextAligned(Element.ALIGN_RIGHT, "15-Mar-2010 ", 270.10f, 375.10f, 0); // Surety1 date of retirement
            page1.showTextAligned(Element.ALIGN_CENTER, "15-Mar-2010",375.10f, 375.10f, 0); // Surety2 date of retirement
            page1.showTextAligned(Element.ALIGN_LEFT, "15-Mar-2010", 480.10f,375.10f, 0); // Surety3 date of retirement
            page1.showTextAligned(Element.ALIGN_RIGHT, "xyz",265.10f, 356.10f, 0); // Surety1 father name
            page1.showTextAligned(Element.ALIGN_CENTER, "xyz",375.10f, 356.10f, 0); // Surety2 father name
            page1.showTextAligned(Element.ALIGN_LEFT, "xyz", 487.10f 	, 356.10f, 0); // Surety3 father name
            page1.showTextAligned(Element.ALIGN_RIGHT, "123 ", 265.10f, 338.10f, 0); // Surety1 Basic Pay
            page1.showTextAligned(Element.ALIGN_CENTER, "123",375.10f, 338.10f, 0); // Surety2 Basic Pay
            page1.showTextAligned(Element.ALIGN_LEFT, "123", 487.10f,338.10f, 0); // Surety3 Basic Pay
            page1.showTextAligned(Element.ALIGN_RIGHT, "456",265.10f, 320.10f, 0); // Surety2 Share Capital
            page1.showTextAligned(Element.ALIGN_CENTER, "456", 375.10f 	, 320.10f, 0); // Surety3 Share Capital
            page1.showTextAligned(Element.ALIGN_LEFT, "456", 487.10f,320.10f, 0); // Surety3 Share Capital
            page1.showTextAligned(Element.ALIGN_RIGHT, "789 ", 265.10f, 302.10f, 0); // Surety1 Thrift Deposit
            page1.showTextAligned(Element.ALIGN_CENTER, "789",375.10f, 302.10f, 0); // Surety2 Thrift Deposit
            page1.showTextAligned(Element.ALIGN_LEFT, "789", 487.10f,302.10f, 0); // Surety3 Thrift Deposit
            page1.showTextAligned(Element.ALIGN_RIGHT, "SH123456",270.10f, 284.10f, 0); // Surety1 Permanent Address
            page1.showTextAligned(Element.ALIGN_CENTER, "SH123456",375.10f, 284.10f, 0); // Surety2 Permanent Address
            page1.showTextAligned(Element.ALIGN_LEFT, "SH123456", 480.10f 	, 284.10f, 0); // Surety3 Permanent Address
            
            page1.showTextAligned(Element.ALIGN_LEFT, "SURETY1", 83.10f,97.10f, 0); // Surety1
            page1.showTextAligned(Element.ALIGN_RIGHT, "SURETY2",250.10f, 97.10f, 0); // Surety2
            page1.showTextAligned(Element.ALIGN_CENTER, "SURETY3",340.10f, 97.10f, 0); // Surety3
            page1.showTextAligned(Element.ALIGN_LEFT, "John Doe", 452.10f 	, 97.10f, 0); // Loanee Name
           
            page1.endText();

            // Page 2 - Sureties Info
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
            PdfContentByte page3 = stamper.getOverContent(3);
            page3.beginText();
            page3.setFontAndSize(font, 11);
            page3.showTextAligned(Element.ALIGN_RIGHT, "John Doe",380.10f, 881.10f, 0); // Loanee Name
            page3.showTextAligned(Element.ALIGN_RIGHT, "SURETY1",380.10f, 760.10f, 0); // Surety1
            page3.showTextAligned(Element.ALIGN_RIGHT, "SURETY2", 380.10f, 632.10f, 0); // Surety2
            page3.showTextAligned(Element.ALIGN_RIGHT, "SURETY3", 380.10f, 507.10f, 0); // Surety3
            page3.showTextAligned(Element.ALIGN_RIGHT, "John Doe", 330.10f, 330.10f, 0); // Loanee Name
            page3.endText();

            
            PdfContentByte page4 = stamper.getOverContent(4);
            page4.beginText();
            page4.setFontAndSize(font, 11);
            page4.showTextAligned(Element.ALIGN_RIGHT, "SURETY1",135.10f, 680.10f, 0); // Surety1
            page4.showTextAligned(Element.ALIGN_LEFT, "John Doe", 365.10f, 680.10f, 0); // Loanee Name
            page4.showTextAligned(Element.ALIGN_RIGHT, "SURETY2", 135.10f, 615.10f, 0); // Surety2
            page4.showTextAligned(Element.ALIGN_LEFT, "SURETY3",360.10f, 615.10f, 0); // Surety3
            
            page4.endText();
            
            stamper.close();
            reader.close();

            System.out.println(" PDF filled and saved successfully as 'Filled_Loan_Application.pdf'");
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }*/
}
