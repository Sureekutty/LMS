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
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfWriter;

public class CompusoryMonthlyThriftDepositpdf {

	public static void getPDF(String applNumber,String header,String number) throws Exception {
	
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("CompusoryMonthlyThriftDeposit.pdf"));

		PdfWriter.getInstance(document, outputStream);

		document.open();
		 Rectangle rect= new Rectangle(31,38,560,805);
		 
	        rect.setBorder(Rectangle.BOX);
	       rect.setBorderWidth(1);
		Paragraph enter = new Paragraph("\n");
		Paragraph p = null;
		
		Font f1=FontFactory.getFont(FontFactory.HELVETICA, 12,com.itextpdf.text.Font.UNDERLINE);		
		String memname="";
		String memeempcode="";
		String designation="";
	
		String division="";
		int basicpay = 0;
		
		String nomname="";
		String relation="";
		String address="";
		
		String query=" speccs.SP_Prints 'MONTHLYTHIFTDEPOSIT','"+applNumber+"','','',''";
				
		ps = connection.prepareStatement(query);
		ResultSet rs3 = ps.executeQuery();
		while (rs3.next()) {
			memname=rs3.getString("MemName");
			memeempcode=rs3.getString("MemEmpCode");
			
			designation=rs3.getString("Designation");
			division=rs3.getString("Division");
			basicpay=rs3.getInt("BasicPay");
			nomname=rs3.getString("NomName");
			relation=rs3.getString("Relationship");
			address=rs3.getString("Address");
		}
		p = new Paragraph(header+", SRIHARIKOTA.", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 11, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		
	
		document.add(enter);
		p = new Paragraph("COMPULSORY MONTHLY THRIFT DEPOSIT",f1);
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		document.add(enter);
		p = new Paragraph("The Managing Committee                                                                                                                Application No:"+applNumber, FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph(header+",          Group : ", FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p); 
		p = new Paragraph("SRIHARIKOTA: 524124,                                                                                                                                 BasicPay:"+basicpay, FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("ANDHRA PRADESH .", FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Sir,", FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);

		p = new Paragraph("I  "+memname+ " being a member of the society need to pay not less than the amount mentioned in the bye laws(4A) of society towards monthly thrift deposit regularly from my salary. Hence,herewith i am authorizing the AccountsOfficer, Pay & Establishment section,SDSC SHAR to effect recoveries of thrift deposit with a minimum contribution asmentioned in the bye law No.4(A) from my salary regularly until cessetion of my membership. Further, i also agree to the terms and conditions of thrift scheme in force and that may be amended from time to time.", FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("Further, i also not ask for any suspension of thrift recoveries while in service or in future and or to  modify the said agreement with the society.", FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		p = new Paragraph("SRIHARIKOTA", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Date :                                                                                                                                  Signature of the Member", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		
		p = new Paragraph("NOMINATION", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		document.add(enter);
		p = new Paragraph("I here by authorize S/Shri/Smt/Kum "+nomname+" who is my "+relation+" in case of  my death/absence to collect my all amounts that is due from the above society", FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(enter);
		
		p = new Paragraph("Residential Address:", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph(address, FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		p = new Paragraph("Signature of the Depositer  ", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_RIGHT);
		document.add(p);
		p = new Paragraph("Name:"+memname+" ", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_RIGHT);
		document.add(p);
		p = new Paragraph("Designation: "+designation, FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_RIGHT);
		document.add(p);
		p = new Paragraph("Staff Code No:"+memeempcode+" ", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_RIGHT);
		document.add(p);
		p = new Paragraph("Unit: "+division+" ", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 9, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_RIGHT);
		document.add(p);
		if(connection!=null){
			connection.close();
			}
		document.add(rect);
		document.close();
	}
}
