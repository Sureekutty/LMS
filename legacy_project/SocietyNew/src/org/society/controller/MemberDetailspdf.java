package org.society.controller;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;



import org.society.util.DataBaseConnectionForNewDB;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;

import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;

import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

public class MemberDetailspdf {

	

	public static void getPDF(String MemAccNO,String mem,String header,String number) throws Exception {
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("MemberDetailspdf.pdf"));

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
		p = new Paragraph("                                                                 MEMBER DETAILS                                                       Date: "+strDate+"      ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(new Chunk(line));
		
		
if(mem.equals("MEM")){

	   String empcode = null;
		String membername= null;
		String pannno = null;
		String aadharno = null;
	    String mailid= null;
	    String designation= null;
	    String division= null;
	    String phone= null;
	    String officephone= null;
	    String bankaccno= null;
	    String ifsccode= null;
	    String bankname= null;
	    String bankaddress= null;
	    String basicpay= null;
	    String memdate= null;
	    String memdob= null;
	    String retireddate= null;
	    String careof= null;
	    String remarks= null;
	    int thriftsubamt = 0;
	    int thriftbal = 0;
	    int shareamt = 0;
	    int noofshares = 0;
			
	    
		    

String sqlquery="speccs.SP_Prints 'MEMDETAILS','"+MemAccNO+"','','',''";
	
     ps = connection.prepareStatement(sqlquery);
       ResultSet rs3 = ps.executeQuery();
       if(rs3.next()) {
    	   empcode=rs3.getString("MemEmpCode");
			 membername=rs3.getString("MemName");
			 pannno=rs3.getString("PanNo");
			 aadharno=rs3.getString("AadharNo");
		     mailid=rs3.getString("MailId");
		     designation=rs3.getString("Designation");
		     division=rs3.getString("Division");
		     phone=rs3.getString("Phone");
		     officephone=rs3.getString("OffPhone");
		     bankaccno=rs3.getString("BankAccNo");
		     ifsccode=rs3.getString("IfscCode");
		     bankname=rs3.getString("BankName");
		     bankaddress=rs3.getString("BankAddress");
		     basicpay=rs3.getString("BasicPay");
		     memdate=rs3.getString("MemDate").substring(0, 10);
		     memdob=rs3.getString("Dob").substring(0, 10);
		     retireddate=rs3.getString("RetiredDate").substring(0, 10);
		     careof=rs3.getString("CareOf");
		     remarks=rs3.getString("Remarks").trim();
		     thriftsubamt=rs3.getInt("ThriftSubscriptionAmount");
		     thriftbal=rs3.getInt("ThriftBalance");
		     shareamt=rs3.getInt("ShareAmount");
		     noofshares=rs3.getInt("NoOfShares");
       }
       
       PdfPTable table1 = new PdfPTable(2);
       table1.setWidthPercentage(100);
       table1.getDefaultCell().setBorder(Rectangle.NO_BORDER);
       table1.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
       table1.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);
       table1.getDefaultCell().setMinimumHeight(15);
       table1.setWidths(new float[] {2f,6f});
       table1.addCell(new Phrase("Memeber Code", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+empcode, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Memeber name", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+membername, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Pan No", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+pannno, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Aadhar", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+aadharno, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("MailId", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+mailid, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Designation", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+designation, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Division", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+division, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Phone", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+phone, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("OffPhone", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+officephone, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Bank Acc No", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+bankaccno, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Ifsc Code", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+ifsccode, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Bank Name", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+bankname, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Bank Adress", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+bankaddress, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Basic Pay", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+basicpay, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("MemberDate", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+memdate, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Dob", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+memdob, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("RetiredDate", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+retireddate, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("CareOf", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+careof, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Remarks", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+remarks, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("ThriftSubscriptionAmount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+thriftsubamt, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("ThriftBalance", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+thriftbal, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("ShareAmount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+shareamt, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("NoOfShares", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+noofshares, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	    
	   document.add(new Chunk(line));
	   
	   
	   String query="speccs.SP_Prints 'MEMNOMDETAILS','"+MemAccNO+"','','',''";

		ps = connection.prepareStatement(query);
		ResultSet rs4 = ps.executeQuery();
		
		PdfPTable tables = new PdfPTable(5);
		tables.setWidthPercentage(100);
		tables.getDefaultCell();
		tables.setWidths(new float[] { 0.5f, 0.3f,0.3f, 0.2f, 0.8f});
	
		
		p = new Paragraph("NomineeName", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Dob", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Relationship", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Gender", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Address", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		PdfPTable table6 = new PdfPTable(5);
		table6.setWidthPercentage(100);
		table6.getDefaultCell();
		
		table6.setWidths(new float[] { 0.5f, 0.3f,0.3f, 0.2f, 0.8f});
		while (rs4.next()) {
		
		table6.addCell(new Phrase(rs4.getString("NomName"),font3));
		table6.addCell(new Phrase(rs4.getString("NomDOB"),font3));
		table6.addCell(new Phrase(rs4.getString("Relationship"),font3));
		table6.addCell(new Phrase(rs4.getString("Gender"),font3));
		table6.addCell(new Phrase(rs4.getString("Address"),font3));
		}
		

		 String query1="speccs.SP_Prints 'MEMADDDETAILS','"+MemAccNO+"','','',''";
		
		ps = connection.prepareStatement(query1);
		ResultSet rs5 = ps.executeQuery();
		
		PdfPTable table2 = new PdfPTable(7);
		table2.setWidthPercentage(100);
		table2.getDefaultCell();
		table2.setWidths(new float[] { 0.5f, 0.5f,0.4f, 0.4f, 0.3f,0.3f, 0.7f});
	
		
		p = new Paragraph("Address1", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		table2.addCell(p);
		
		p = new Paragraph("Address2", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		table2.addCell(p);
		
		p = new Paragraph("City", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		table2.addCell(p);
		
		p = new Paragraph("District", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		table2.addCell(p);
		
		p = new Paragraph("State", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		table2.addCell(p);
		p = new Paragraph("Pincode", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		table2.addCell(p);
		p = new Paragraph("Remarks", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		table2.addCell(p);
		
		
		PdfPTable table7 = new PdfPTable(7);
		table7.setWidthPercentage(100);
		table7.getDefaultCell();
		
		table7.setWidths(new float[] {0.5f, 0.5f,0.4f, 0.4f, 0.3f,0.3f, 0.7f });
		while (rs5.next()) {
		
		
		table7.addCell(new Phrase(rs5.getString("Address1"),font3));
		table7.addCell(new Phrase(rs5.getString("Address2"),font3));
		table7.addCell(new Phrase(rs5.getString("City"),font3));
		table7.addCell(new Phrase(rs5.getString("District"),font3));
		table7.addCell(new Phrase(rs5.getString("State"),font3));
		table7.addCell(new Phrase(rs5.getString("Pincode"),font3));
		table7.addCell(new Phrase(rs5.getString("Remarks"),font3));
		}
		document.add(table1);
		document.add(enter);
		document.add(tables);
		document.add(table6);
		document.add(enter);
		document.add(table2);
		document.add(table7);
  
		}else{
			 String query="speccs.SP_Prints 'BASICDETAILS','"+MemAccNO+"','','',''";
				
		ps = connection.prepareStatement(query);
		ResultSet rs3 = ps.executeQuery();
		document.add(enter);
		PdfPTable tables = new PdfPTable(8);
		tables.setWidthPercentage(100);
		tables.getDefaultCell();
		tables.setWidths(new float[] { 0.3f, 0.3f, 0.5f,1.2f, 1f, 0.4f,0.9f,0.5f });
		p = new Paragraph("SlNo", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Ac No", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Emp Code", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Employee Name", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Designation", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Basic Pay", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("CareOf", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Memb Date", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		document.add(tables);
		
		int i=1;
		PdfPTable table6 = new PdfPTable(8);
		table6.setWidthPercentage(100);
		table6.getDefaultCell();
		
		table6.setWidths(new float[] {0.3f, 0.3f, 0.5f,1.2f, 1f, 0.4f,0.9f,0.5f  });
		int total = 0;
		while (rs3.next()) {
			total=i;
		table6.addCell((new Phrase(""+i,font3)));
		table6.addCell(new Phrase(rs3.getString("AccNumber"),font3));
		table6.addCell(new Phrase(rs3.getString("MemEmpCode"),font3));
		table6.addCell(new Phrase(rs3.getString("Name"),font3));
		table6.addCell(new Phrase(rs3.getString("Desination"),font3));
		table6.addCell(new Phrase(""+rs3.getInt("BasicPay"),font3));
		table6.addCell(new Phrase(rs3.getString("Nominee"),font3));
		table6.addCell(new Phrase(rs3.getString("MemberDate"),font3));
		i++;
		}
		
		
		
		document.add(table6);
		}
if(connection!=null){
	connection.close();
}
        document.add(rect);
		document.close();
	}


}
