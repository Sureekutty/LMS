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

public class ThriftLedgerpdf {

	

	public static void getPDF(String memeaccNo,String purposecode,String ReceiptNo,String header,String number) throws Exception {
		
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("ThriftLedgerpdf.pdf"));

		PdfWriter.getInstance(document, outputStream);

		document.open();
		LineSeparator line=new LineSeparator();
		Rectangle rect= new Rectangle(36,38,559,800);
		 
	        rect.setBorder(Rectangle.BOX);
	       rect.setBorderWidth(1);
		Paragraph enter = new Paragraph("\n");
		Paragraph p = null;
		String name = null;
		
		
		Font font3 = FontFactory.getFont(FontFactory.TIMES_ROMAN, 8, 0, new BaseColor(0, 0, 0));
		Font font6 = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, 0, new BaseColor(0, 0, 0));
		Font f1=FontFactory.getFont(FontFactory.HELVETICA, 12,com.itextpdf.text.Font.UNDERLINE);
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String strDate = formatter.format(date);
		String MemeAccNo="";
		String MemEmpCode="";
		String MemName="";
		int ThriftSubAmt=0;
		String Designation="";
		int Thriftbalance = 0;
		String Month="";
		String Receiptno ="";
		int amount=0;
		String modeofpayment="";
		
		String query=" speccs.SP_Prints 'THIFTLEDGER','"+memeaccNo+"','"+ReceiptNo+"','',''";
				
		ps = connection.prepareStatement(query);
		ResultSet rs3 = ps.executeQuery();
		while (rs3.next()) {
			MemeAccNo=rs3.getString("MemAccNo");
			MemEmpCode=rs3.getString("MemEmpCode");
			MemName =rs3.getString("MemName");
			Designation=rs3.getString("Designation");
			Thriftbalance=rs3.getInt("ThriftBalance");
			ThriftSubAmt=rs3.getInt("ThriftSubscriptionAmount");
			Month=rs3.getString("Month");
			Receiptno=rs3.getString("ReceiptNo");
			amount=rs3.getInt("Amount");
			modeofpayment=rs3.getString("ModeOfPayment");
		}
		p = new Paragraph(header+",SRIHARIKOTA. AP", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		p = new Paragraph(number+"",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.UNDERLINE, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		document.add(enter);
		p = new Paragraph("                                                                 Thrift Ledger                                                      Date: "+strDate+"               ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		document.add(new Chunk(line));
		
		
	     PdfPTable table1 = new PdfPTable(2);
	       table1.setWidthPercentage(100);
	       table1.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	       table1.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
	       table1.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);
	       table1.getDefaultCell().setMinimumHeight(15);
	       table1.setWidths(new float[] {2f,6f});
	       table1.addCell(new Phrase("Member account number ", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
		   table1.addCell(new Phrase(":"+MemeAccNo, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		   table1.addCell(new Phrase("Name of the Member", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
		   table1.addCell(new Phrase(":"+MemName, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		   table1.addCell(new Phrase("MemEmpCode", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
		   table1.addCell(new Phrase(":"+MemEmpCode, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		   table1.addCell(new Phrase("Designation", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
		   table1.addCell(new Phrase(":"+Designation, FontFactory.getFont(FontFactory.HELVETICA, 10)));
		 
		   document.add(table1);
		
		PdfPTable tables = new PdfPTable(7);
		tables.setWidthPercentage(90);
		tables.getDefaultCell();
		tables.setWidths(new float[] { 0.3f, 1.3f, 0.4f,0.4f, 1.2f, 0.8f,0.6f });
		p = new Paragraph("SlNo", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("ReceiptNo", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Month", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Amount", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Thrift SubScription Amount", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Thrift Balance", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		
		p = new Paragraph("Mode of Pay", font6);
		p.setAlignment(Element.ALIGN_LEFT);
		tables.addCell(p);
		document.add(tables);
		int i=1;
		PdfPTable table6 = new PdfPTable(7);
		table6.setWidthPercentage(90);
		table6.getDefaultCell();
		
		table6.setWidths(new float[] { 0.3f, 1.3f, 0.4f,0.4f, 1.2f, 0.8f,0.6f });

		table6.addCell((new Phrase(""+i,font3)));
		table6.addCell(new Phrase(Receiptno,font3));
		table6.addCell(new Phrase(Month,font3));
		table6.addCell(new Phrase(""+amount,font3));
		table6.addCell(new Phrase(""+ThriftSubAmt,font3));
		table6.addCell(new Phrase(""+Thriftbalance,font3));
		table6.addCell(new Phrase(modeofpayment,font3));
		
		document.add(table6);
		if(connection!=null){
			connection.close();
		}
		document.add(rect);
		document.close();
	}


}
