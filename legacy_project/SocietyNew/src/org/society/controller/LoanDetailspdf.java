package org.society.controller;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.Writer;
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
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import com.lowagie.text.DocumentException;

public class LoanDetailspdf {

	

	public static void getPDF(String MemAccNO,String LoanAppNo,String header,String number) throws Exception {
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("LoanDetailspdf.pdf"));

		PdfWriter.getInstance(document, outputStream);
            
		document.open();
		LineSeparator line=new LineSeparator();
	
		Rectangle rect= new Rectangle(36,38,559,800);
		 
	        rect.setBorder(Rectangle.BOX);
	       rect.setBorderWidth(1);
	       
		Paragraph enter = new Paragraph("\n");
		Paragraph p = null;
	

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
		p = new Paragraph("                                                                 Details of Loan                                                      Date: "+strDate+"               ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(new Chunk(line));
		
	 String  Member = null; 
	 String LoanAccNo = null;
	 String LoanType;
	 String LoanPurpose = null;
	 int NoOfInstallments = 0;
	 int MonthlyInstallments;
	 int Thriftdudamt;
	 String FundId;
	 String LoanSanctionAmount = null;
	 String InterestMethod;
	 String InterestRate = null;
	 String LoanSanctionDate;
	 String Loanappdate = null;
	 String DisbursedOnDate;
	 int ThriftSubscriptionAmount;
	 int ThriftBalance;
	 int ShareAmount = 0;
	 int NoOfShares = 0;
	 int princpleoutstandinng=0;
	 int remaininginstallments=0;
//------------------------------------------//
	    String LoanAccNo1;
	    String InstallmentNo;
	    String TransactionDate;
	    String PrincipalAmount;
	    String InterestAmount;
	    String PrincipalStatus;
	    String InterestStatus;
	    String InterestRate1;
	    String PriReceiptNo;
	    String IntReceiptNo;
	    
	
String sqlquery="speccs.SP_Prints 'LOANDETAILS','','','"+LoanAppNo+"',''";
	
     ps = connection.prepareStatement(sqlquery);
       ResultSet rs3 = ps.executeQuery();
       if(rs3.next()) {
    	   Member=rs3.getString("MemAccNo")+"-"+rs3.getString("MemEmpCode")+"-"+rs3.getString("MemName");
    	   LoanAccNo=rs3.getString("LoanAccNo");
    	   LoanType=rs3.getString("LoanType");
    	   LoanPurpose=rs3.getString("LoanPurpose");
    	   NoOfInstallments=rs3.getInt("NoOfInstallments");
    	   MonthlyInstallments=rs3.getInt("MonthlyInstallments");
    	   Thriftdudamt=rs3.getInt("Thriftdudamt");
    	   FundId=rs3.getString("FundId");
    	   LoanSanctionAmount=rs3.getString("LoanSanctionAmount");
    	   InterestMethod=rs3.getString("InterestMethod");
    	   InterestRate=rs3.getString("InterestRate");
    	   LoanSanctionDate=rs3.getString("LoanSanctionDate");
    	   Loanappdate=rs3.getString("Loanappdate").substring(0, 10);
    	   DisbursedOnDate=rs3.getString("DisbursedOnDate");
    	   ThriftSubscriptionAmount=rs3.getInt("ThriftSubscriptionAmount");
    	   ThriftBalance=rs3.getInt("ThriftBalance");
    	   ShareAmount=rs3.getInt("ShareAmount");
    	   NoOfShares=rs3.getInt("NoOfShares");
    	   princpleoutstandinng=rs3.getInt("prin_OS");
    	   remaininginstallments=rs3.getInt("remainingInstallments");
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
	   table1.addCell(new Phrase("Loan Application Date", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+Loanappdate, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("No Of Installments", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+NoOfInstallments, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("No Of Shares", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+NoOfShares, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Loan Number", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+LoanAccNo, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("Amount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+LoanSanctionAmount, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("InterestRate", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+InterestRate, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   table1.addCell(new Phrase("ShareAmount", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
	   table1.addCell(new Phrase(":"+ShareAmount, FontFactory.getFont(FontFactory.HELVETICA, 10)));
	   document.add(table1);
	   document.add(new Chunk(line));

		
		
			 
			 
		   	PdfPTable table2 = new PdfPTable(2);
		   	table2.setWidthPercentage(100);
		   	table2.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		   	table2.getDefaultCell();
		   	table2.setWidths(new float[] { 3f,3f});
		   	
		   	
		   	
		   	p = new Paragraph("Principal Outstanding :"+princpleoutstandinng,  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
			p.setAlignment(Element.ALIGN_LEFT);
			table2.addCell(p);
			
			
			p = new Paragraph("Remaining no. of installments :"+remaininginstallments,  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
			p.setAlignment(Element.ALIGN_LEFT);
			table2.addCell(p);
			  document.add(table2);
			  document.add(new Chunk(line));
			  
				
				
			
				
			 String query="speccs.SP_Prints 'LOANDETAILS2','','','"+LoanAppNo+"',''";
				 
					ps = connection.prepareStatement(query);
					ResultSet rs4 = ps.executeQuery();
				    
					   	PdfPTable table3 = new PdfPTable(5);
					   	table3.setWidthPercentage(100);
					   	table3.getDefaultCell();
					   	table3.setWidths(new float[] { 2f, 2f,2f, 3.5f,2f});
					   	
					 
					   	p = new Paragraph("Month",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Installment no.",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Transaction Date",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Purpose",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Amount",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						  document.add(table3);
						
						PdfPTable table7 = new PdfPTable(5);
						table7.setWidthPercentage(100);
						table7.getDefaultCell();
						table7.setWidths(new float[] {2f, 2f,2f, 3.5f,2f});
						
						int i=1;
						 while(rs4.next()) {
							 
							 
							 
	table7.addCell(new Phrase(rs4.getString("Month"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
	table7.addCell(new Phrase("-",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
	table7.addCell(new Phrase(rs4.getString("Processdate"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
	table7.addCell(new Phrase(rs4.getString("Purposecode"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));	
	table7.addCell(new Phrase(""+rs4.getInt("Recoveryamount"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));	
								
					       }
						
							document.add(table7);  
		
										if(connection!=null){
										   connection.close();
										}
	 document.add(rect);
		document.close();
	}


}
