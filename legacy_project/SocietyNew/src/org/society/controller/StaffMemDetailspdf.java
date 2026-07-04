package org.society.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.stream.ImageOutputStream;

import org.society.util.DataBaseConnectionForNewDB;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

public class StaffMemDetailspdf {

	

	public static void getPDF(String MemAccNO,String header,String number) throws Exception {
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("StaffMemDetailspdf.pdf"));

		PdfWriter.getInstance(document, outputStream);

		document.open();
		LineSeparator line=new LineSeparator();
		Rectangle rect= new Rectangle(36,38,559,800);
		 
	        rect.setBorder(Rectangle.BOX);
	       rect.setBorderWidth(1);
		
		Paragraph enter = new Paragraph("\n");
		Paragraph p = null;
		Font font3 = FontFactory.getFont(FontFactory.TIMES_ROMAN, 8, 0, new BaseColor(0, 0, 0));
		Font font6 = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, 0, new BaseColor(0, 0, 0));
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String strDate = formatter.format(date);
		
		p = new Paragraph(header+",", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		p = new Paragraph(number+"",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		document.add(enter);
		p = new Paragraph("                                                                 Details of Member                                                      Date: "+strDate+"          ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(new Chunk(line));
		 String MemAccNo= null;
		 String  MemEmpCode= null;
		 String  MemName= null; 
		 String  PanNo= null;
		 String  AadharNo= null;
		 String  MailId= null;
		 String Designation= null; 
		 String Division= null; 
		 String Phone= null; 
		 String OffPhone= null;
		 String  BankAccNo = null; 
		 String IfscCode= null; 
		 String BankName= null; 
		 String BankAddress= null; 
		 String BankPlace= null;
		 String BasicPay= null; 
		 String MemDate= null;
		 String  Dob= null; 
		 String  RetiredDate= null; 
		 String Status= null;
		 String CareOf= null; 
		 String ClosedDate= null;  
		 String Remarks= null;
	
		 int ThriftSubscriptionAmount = 0; 
		 String ThriftBalance= null; 
		 int ShareAmount = 0; 
		 int NoOfShares = 0; 
		 String WelfareFund= null;
		 String SERBS= null; 
		 String Insurance_Loan= null; 
		 String Insurance_Thrift= null;
		 String RegTime=null;
		String Employee = null;
		
		

	
String sqlquery="speccs.SP_Prints 'STAFFMEMETAILS','"+MemAccNO+"','','',''";
	
     ps = connection.prepareStatement(sqlquery);
       ResultSet rs3 = ps.executeQuery();
       if(rs3.next()) {
    	   Employee=rs3.getString("MemAccNo")+"-"+rs3.getString("MemName");
    	   BasicPay=rs3.getString("BasicPay");
    	   Phone=rs3.getString("Phone");
    	   Dob=rs3.getString("Dob").substring(0, 10);
    	   AadharNo=rs3.getString("AadharNo");
    	   PanNo=rs3.getString("PanNo");
    	   MemDate=rs3.getString("MemDate").substring(0, 10);
    	   ShareAmount=rs3.getInt("ShareAmount");
    	   NoOfShares=rs3.getInt("NoOfShares");
    	   ThriftSubscriptionAmount=rs3.getInt("ThriftSubscriptionAmount");
    	   RegTime=rs3.getString("RegTime").substring(0, 10);
       }
	
       p = new Paragraph("Personal Information",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
       PdfPTable table1 = new PdfPTable(4);
       table1.setWidthPercentage(100);
       table1.getDefaultCell().setBorder(Rectangle.NO_BORDER);
       table1.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
       table1.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);
       table1.getDefaultCell().setMinimumHeight(15);
       table1.setWidths(new float[] {4f,13f,4f,8f});
       table1.addCell(new Phrase("Employee", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
	   table1.addCell(new Phrase(":"+Employee, FontFactory.getFont(FontFactory.HELVETICA, 9)));
       table1.addCell(new Phrase("BasicPay", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
	   table1.addCell(new Phrase(":"+BasicPay, FontFactory.getFont(FontFactory.HELVETICA, 9)));
	   table1.addCell(new Phrase("Date Of Birth ", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
	   table1.addCell(new Phrase(":"+Dob, FontFactory.getFont(FontFactory.HELVETICA, 9)));
	 
	   table1.addCell(new Phrase("AadharNo ", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
	   table1.addCell(new Phrase(":"+AadharNo, FontFactory.getFont(FontFactory.HELVETICA, 9)));
	   table1.addCell(new Phrase("PanNo ", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
	   table1.addCell(new Phrase(":"+PanNo, FontFactory.getFont(FontFactory.HELVETICA, 9)));
	   table1.addCell(new Phrase("Contact Info ", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
	   table1.addCell(new Phrase(":"+Phone, FontFactory.getFont(FontFactory.HELVETICA, 9)));
	   table1.addCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
	   table1.addCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9)));
		document.add(table1);
	   
	  
	   
	   Paragraph  p1 = new Paragraph("Society Information",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
	   p1.setAlignment(Element.ALIGN_CENTER);
		document.add(p1);
		PdfPTable table2 = new PdfPTable(4);
		table2.setWidthPercentage(100);
	       table2.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	       table2.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
	       table2.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);
	       table2.getDefaultCell().setMinimumHeight(15);
	       table2.setWidths(new float[] {5f,8f,6f,7f});
		table2.addCell(new Phrase("MembershipDate", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
		table2.addCell(new Phrase(":"+MemDate, FontFactory.getFont(FontFactory.HELVETICA, 9)));
		table2.addCell(new Phrase("ShareAmt/NoOfShares ", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
		table2.addCell(new Phrase(":"+ShareAmount+"/"+NoOfShares, FontFactory.getFont(FontFactory.HELVETICA, 9)));
		table2.addCell(new Phrase("ThriftAmount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
		table2.addCell(new Phrase(":"+ThriftSubscriptionAmount, FontFactory.getFont(FontFactory.HELVETICA, 9)));
		table2.addCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9)));
		table2.addCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9)));
		   document.add(table2);
		
		   p = new Paragraph("Bank Information",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
			p.setAlignment(Element.ALIGN_CENTER);
			document.add(p);
			document.add(enter);
			
			
			String quer9="speccs.SP_Prints 'BANKINFO','"+MemAccNO+"','','',''";

			ps = connection.prepareStatement(quer9);
			ResultSet rs9 = ps.executeQuery();
			
			PdfPTable tables8 = new PdfPTable(4);
			tables8.setWidthPercentage(100);
			tables8.getDefaultCell();
			tables8.setWidths(new float[] { 0.3f, 0.3f,0.5f, 0.5f});
		
			
			p = new Paragraph("Bank Acc No", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			p = new Paragraph("Ifsc Code", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			p = new Paragraph("Bank Name", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			p = new Paragraph("Bank Place", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			
			PdfPTable table69 = new PdfPTable(4);
			table69.setWidthPercentage(100);
			table69.getDefaultCell();
			
			table69.setWidths(new float[] {0.3f, 0.3f,0.5f, 0.5f});
			while (rs9.next()) {
			
			table69.addCell(new Phrase(rs9.getString("Bankaccno"),font3));
			table69.addCell(new Phrase(rs9.getString("Ifsccode"),font3));
			table69.addCell(new Phrase(rs9.getString("Bankname"),font3));
			table69.addCell(new Phrase(rs9.getString("Bankplace"),font3));
			
			}
			document.add(tables8);
			document.add(table69);
		   
		   
		  
			
			Paragraph  p4 = new Paragraph("Member Address",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
			   p4.setAlignment(Element.ALIGN_CENTER);
				document.add(p4);
				document.add(enter);
			 String query1="speccs.SP_Prints 'MEMADDDETAILS','"+MemAccNO+"','','',''";
			
			ps = connection.prepareStatement(query1);
			ResultSet rs5 = ps.executeQuery();
			
			PdfPTable table7 = new PdfPTable(7);
			table7.setWidthPercentage(100);
			table7.getDefaultCell();
			table7.setWidths(new float[] { 0.5f, 0.5f,0.4f, 0.4f, 0.3f,0.3f, 0.7f});
		
			
			p = new Paragraph("Address1", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			table7.addCell(p);
			
			p = new Paragraph("Address2", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			table7.addCell(p);
			
			p = new Paragraph("City", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			table7.addCell(p);
			
			p = new Paragraph("District", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			table7.addCell(p);
			
			p = new Paragraph("State", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			table7.addCell(p);
			p = new Paragraph("Pincode", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			table7.addCell(p);
			p = new Paragraph("Remarks", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			table7.addCell(p);
			
			
			PdfPTable table8 = new PdfPTable(7);
			table8.setWidthPercentage(100);
			table8.getDefaultCell();
			
			table8.setWidths(new float[] {0.5f, 0.5f,0.4f, 0.4f, 0.3f,0.3f, 0.7f });
			while (rs5.next()) {
			
			
				table8.addCell(new Phrase(rs5.getString("Address1"),font3));
				table8.addCell(new Phrase(rs5.getString("Address2"),font3));
				table8.addCell(new Phrase(rs5.getString("City"),font3));
				table8.addCell(new Phrase(rs5.getString("District"),font3));
				table8.addCell(new Phrase(rs5.getString("State"),font3));
				table8.addCell(new Phrase(rs5.getString("Pincode"),font3));
				table8.addCell(new Phrase(rs5.getString("Remarks"),font3));
			}
			document.add(table7);
			document.add(table8);
		
		   
		Paragraph p2 = new Paragraph("Share purchases", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p2.setAlignment(Element.ALIGN_CENTER);
		document.add(p2);
		document.add(enter);
		PdfPTable table9 = new PdfPTable(3);
		table9.setWidthPercentage(100);
		table9.getDefaultCell();
		table9.setWidths(new float[] { 4f,4f,4f});
	
		
		p = new Paragraph("No.Of Shares",FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_MIDDLE);
		table9.addCell(p);
		
		p = new Paragraph("Amount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_MIDDLE);
		table9.addCell(p);
		
		p = new Paragraph("Transaction date", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_MIDDLE);
		table9.addCell(p);
		

		PdfPTable table10 = new PdfPTable(3);
		table10.setWidthPercentage(100);
		table10.getDefaultCell();
		
		table10.setWidths(new float[] {4f,4f,4f});

		
		table10.addCell(new Phrase(""+NoOfShares, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table10.addCell(new Phrase(""+ShareAmount, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table10.addCell(new Phrase(RegTime, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	
		document.add(table9);
        document.add(table10);
    
        
		Paragraph   p5 = new Paragraph("Thrift transactions", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p5.setAlignment(Element.ALIGN_CENTER);
		   document.add(p5);
		   document.add(enter);
		PdfPTable table = new PdfPTable(2);
		table.setWidthPercentage(100);
		table.getDefaultCell();
		table.setWidths(new float[] { 4f,4f});
		
		p = new Paragraph("Subscription Amount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_MIDDLE);
		table.addCell(p);
		
		p = new Paragraph("Transaction date", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_MIDDLE);
		table.addCell(p);
		
		PdfPTable table11 = new PdfPTable(2);
		table11.setWidthPercentage(100);
		table11.getDefaultCell();
		
		table11.setWidths(new float[] {4f,4f});
		table11.addCell(new Phrase(""+ThriftSubscriptionAmount, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table11.addCell(new Phrase(RegTime, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	
		document.add(table);
        document.add(table11);
        if(connection!=null){
			connection.close();
		}
        document.add(rect);
       document.close();
	}


}
