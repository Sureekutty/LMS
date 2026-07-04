package org.society.controller;


import java.io.File;
import java.io.FileOutputStream;

import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;



import org.society.util.DataBaseConnectionForNewDB;

import com.itextpdf.text.BaseColor;
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

public class ApplicationforsharesandmembershipPdf {

	public static void getPDF(String applNumber,String header,String number) throws Exception {
	
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("Applicationforsharesandmembership.pdf"));

		PdfWriter.getInstance(document, outputStream);

		document.open();
		Rectangle rect= new Rectangle(31,38,560,805);
		 
        rect.setBorder(Rectangle.BOX);
       rect.setBorderWidth(1);
		Paragraph enter = new Paragraph("\n");
		Paragraph p = null;
		
		Font f1=FontFactory.getFont(FontFactory.HELVETICA, 12,com.itextpdf.text.Font.UNDERLINE);

		
		  
		p = new Paragraph(header+",SRIHARIKOTA.", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 11, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		
	
		document.add(enter);
		p = new Paragraph("APPLICATION FOR SHARES AND MEMBERSHIP",f1);
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		document.add(enter);
		p = new Paragraph("The Managing Committee", FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph(header+",", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("SRIHARIKOTA: 524124,", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("ANDHRA PRADESH .", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Sir,", FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		String memname="";
		String memeempcode="";
		String designation="";
		String careof="";
		String division="";
		int basicpay = 0;
		String dob="";
		int noofshares = 0;
		String nomname="";
		String relation="";
		String address="";
		
		String query=" speccs.SP_Prints 'APPSHAREANDMEMSHIP','"+applNumber+"','','',''";
		
		ps = connection.prepareStatement(query);
		ResultSet rs3 = ps.executeQuery();
		while (rs3.next()) {
			memname=rs3.getString("MemName");
			memeempcode=rs3.getString("MemEmpCode");
			designation=rs3.getString("Designation");
			careof=rs3.getString("CareOf");
			division=rs3.getString("Division");
			basicpay=rs3.getInt("BasicPay");
			dob=rs3.getString("Dob");
			noofshares=rs3.getInt("NoOfShares");
			nomname=rs3.getString("NomName");
			relation=rs3.getString("Relationship");
			address=rs3.getString("Address");
		}
		p = new Paragraph("I am an employee of SDSC SHAR and would like to join as a member of our SPECCS Ltd, Sriharikota. Hence,I request  you to allot me  "+noofshares+"  shares in our society as per the details below.", FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);

		p = new Paragraph("Name                     :"+memname,FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Designation           :"+designation,FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Guardian name      :"+careof,FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		
		p = new Paragraph("Staff Code                :"+memeempcode,FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Date of Birth         :"+dob,FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Basic Pay              :"+basicpay,FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Section                  :"+division,FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		
		
		
		
		
		document.add(enter);
		p = new Paragraph("Date :                                                                                                                                  Signature of the Applicant", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("I approve of  S/Shri/Smt/kum  "+memname+"  is a regular/adhoc employee being admitted as member share holder of the society", FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("Signature of the Applicant's", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("Division/Section,HEAD", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("NOMINATION", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		document.add(enter);
		p = new Paragraph("I hereby authorize S/Shri/Smt/Kum  "+nomname+"  who is my "+noofshares+" to collect the shares and other deposits in my absence", FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("Guardian(if Nominee is minor)", FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("Residential Address:                                                                                                        Signature of the Depositer", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		PdfPTable table1 = new PdfPTable(2);
		table1.setWidthPercentage(100);
		
		table1.getDefaultCell().setBorder(Rectangle.NO_BORDER);
        table1.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
        table1.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);
        table1.getDefaultCell().setMinimumHeight(15);
        table1.setWidths(new float[] {5f,7f});
        table1.addCell(new Phrase(address, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("                                              Cash Receipt Number:", FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("Relation :"+relation, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("                                              Application No:"+applNumber, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 10)));
	
		table1.addCell(new Phrase("                                              Approved", FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("                                              SECRETARY", FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 10)));
		table1.addCell(new Phrase("                                               Date:", FontFactory.getFont(FontFactory.HELVETICA, 10)));
		document.add(table1);
		if(connection!=null){
		connection.close();
		}
		document.add(rect);
		document.close();
	}
}
