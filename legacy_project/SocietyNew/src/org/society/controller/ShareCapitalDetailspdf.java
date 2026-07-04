package org.society.controller;

import java.io.File;
import java.io.FileOutputStream;
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
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

public class ShareCapitalDetailspdf {
	
public static void getPDF(String MemAccNO,String header,String number) throws Exception {
	
Connection connection = null;

connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
OutputStream outputStream = null;
Document document = new Document(PageSize.A4);
outputStream = new FileOutputStream(new File("ShareCapitalDetailspdf.pdf"));

PdfWriter.getInstance(document, outputStream);

document.open();
Rectangle rect= new Rectangle(36,38,559,800);
	 
rect.setBorder(Rectangle.BOX);
rect.setBorderWidth(1);
   
Paragraph enter = new Paragraph("\n");
Paragraph p = null;

Date date = new Date();
SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
String strDate = formatter.format(date);
LineSeparator line=new LineSeparator();
System.out.println("inside share capital pdf");

p = new Paragraph(header+",", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
p.setAlignment(Element.ALIGN_CENTER);
document.add(p);
p = new Paragraph(number+"",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
p.setAlignment(Element.ALIGN_CENTER);
document.add(p);
document.add(enter);
p = new Paragraph("                                                   Details of Share Capital & Thrift Deposit                                 Date: "+strDate+"      ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
p.setAlignment(Element.ALIGN_LEFT);
document.add(p);
document.add(new Chunk(line));
	
 String  Member = null; 
 String Opendate=null;    
 String Remarks = null;
 int ShareAmount = 0,noOfShares = 0;
 int thriftBalance=0,thrSubscrAmount=0;
	
String sqlquery="speccs.SP_Prints 'MEMETAILS','"+MemAccNO+"','','',''";
	
PreparedStatement ps = connection.prepareStatement(sqlquery);
   ResultSet rs3 = ps.executeQuery();
   if(rs3.next()) {
	   Member=rs3.getString("MemAccNo")+"-"+rs3.getString("MemEmpCode")+"-"+rs3.getString("MemName");
	   ShareAmount=rs3.getInt("ShareAmount");
	   thriftBalance=rs3.getInt("ThriftBalance");
	   thrSubscrAmount=rs3.getInt("ThriftSubscriptionAmount");
	   Opendate=rs3.getString("MemDate").substring(0, 10);
	   Remarks=rs3.getString("Remarks");
	   noOfShares = rs3.getInt("NoOfShares");
   }   
String query="speccs.SP_Prints 'MEMNOMDETAILS','"+MemAccNO+"','','',''";
String nominee=null;
PreparedStatement ps1 = connection.prepareStatement(query);
 ResultSet rs = ps1.executeQuery();
 if(rs.next()) {
	 nominee=rs.getString("NomName").trim();
 }
       
 PdfPTable table1 = new PdfPTable(2);
table1.setWidthPercentage(100);
table1.getDefaultCell().setBorder(Rectangle.NO_BORDER);
table1.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
table1.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);
table1.getDefaultCell().setMinimumHeight(15);
table1.setWidths(new float[] {2f,6f});
table1.addCell(new Phrase("Memeber ", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+Member, FontFactory.getFont(FontFactory.HELVETICA, 10)));
table1.addCell(new Phrase("Share Capital", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+ShareAmount, FontFactory.getFont(FontFactory.HELVETICA, 10)));
table1.addCell(new Phrase("Number of Shares", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+noOfShares, FontFactory.getFont(FontFactory.HELVETICA, 10)));
table1.addCell(new Phrase("Thrift Balance", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+thriftBalance, FontFactory.getFont(FontFactory.HELVETICA, 10)));
table1.addCell(new Phrase("Thrift Subscription Amount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+thrSubscrAmount, FontFactory.getFont(FontFactory.HELVETICA, 10)));
table1.addCell(new Phrase("Account OpenDate", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+Opendate, FontFactory.getFont(FontFactory.HELVETICA, 10)));
table1.addCell(new Phrase("Remarks", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+Remarks, FontFactory.getFont(FontFactory.HELVETICA, 10)));
table1.addCell(new Phrase("Nominee", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
table1.addCell(new Phrase(":"+nominee, FontFactory.getFont(FontFactory.HELVETICA, 10)));
document.add(table1);
document.add(enter);	  

PdfPTable table3 = new PdfPTable(3);
table3.setWidthPercentage(100);
table3.getDefaultCell();
table3.setWidths(new float[] {3f, 3f,3f});

p = new Paragraph("Month",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
p.setAlignment(Element.ALIGN_CENTER);
table3.addCell(p);

p = new Paragraph("Transaction Date",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
p.setAlignment(Element.ALIGN_CENTER);
table3.addCell(p);						

p = new Paragraph("Subscription",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
p.setAlignment(Element.ALIGN_CENTER);
table3.addCell(p);
document.add(table3);
						
PdfPTable table7 = new PdfPTable(3);
table7.setWidthPercentage(100);
table7.getDefaultCell();
table7.setWidths(new float[] {3f,3f,3f});

table7.addCell(new Phrase("",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
table7.addCell(new Phrase("",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
table7.addCell(new Phrase("",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
	 
document.add(table7);  
		
if(connection!=null){
   connection.close();
}
document.add(rect);
document.close();

	}

}
