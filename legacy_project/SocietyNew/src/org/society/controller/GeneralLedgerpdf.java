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
import java.time.format.DateTimeFormatter;
import java.util.Date;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.stream.ImageOutputStream;

import org.apache.poi.ss.examples.AligningCells;
import org.json.JSONArray;
import org.json.JSONObject;
import org.society.util.ConvertResultSetToJSON;
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

public class GeneralLedgerpdf {

	

	public static void getPDF(String purCode,String fromDate,String toDate,String header,String number) throws Exception {
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("GeneralLedger.pdf"));

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
		//Font f1=FontFactory.getFont(FontFactory.HELVETICA, 12,com.itextpdf.text.Font.UNDERLINE);
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
		p = new Paragraph("                                                General Ledger between "+fromDate+" - "+toDate+"                          Date: "+strDate+"    ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
	    document.add(enter);
	    p = new Paragraph(purCode.split("-")[1],FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		p.setSpacingAfter(5);
		document.add(p);
	 
		
	   	PdfPTable table3 = new PdfPTable(3);
	   	table3.setWidthPercentage(100);
	   	table3.getDefaultCell();
	   	table3.setWidths(new float[] { 0.3f, 0.5f,0.2f });
	   	table3.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
	 
	   	p = new Paragraph("Date",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		table3.addCell(p);
		
		p = new Paragraph("Paid/Received",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		table3.addCell(p);
		
		p = new Paragraph("Amount",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		table3.addCell(p);
		
		document.add(table3);
		
	  	String sqlquery="speccs.SP_Prints 'GENERALLEDGER','','"+purCode.split("-")[0]+"','"+fromDate+"','"+toDate+"'";
			
	  	ps = connection.prepareStatement(sqlquery);
	  	ResultSet rs3 = ps.executeQuery();
       
		PdfPTable table7 = new PdfPTable(3);
		table7.setWidthPercentage(100);
		table7.getDefaultCell();
		table7.setWidths(new float[] {0.3f, 0.5f,0.2f});
		table7.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
		int amount=0,TotalAmount = 0;
		String receiptNo = "",previousDate="";
		boolean a=true;
		/*while(rs3.next()) {	
			String date1 = new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("MM/dd/yyyy").parse(rs3.getString("recDate")));
			table7.addCell(new Phrase(date1,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
			String receiptNo = rs3.getString("ReceiptNo").trim();
			
			if(receiptNo.substring(0, 1).equals("P"))
				table7.addCell(new Phrase("To",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));				
			else if(receiptNo.substring(0, 1).equals("R") )
				table7.addCell(new Phrase("By",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
			else
				table7.addCell(new Phrase("",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
			
			table7.addCell(new Phrase(""+rs3.getInt("Amount"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));   			
			amount=amount+rs3.getInt("Amount");
		}*/

		while (rs3.next()){
			String date1 = rs3.getString("recDate");
			receiptNo = rs3.getString("ReceiptNo").trim();
			if(a)
			    previousDate=date1;
			
			if(!date1.equals(previousDate)){
				table7.addCell(new Phrase(previousDate,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
				
				if(receiptNo.substring(0, 1).equals("P"))
					table7.addCell(new Phrase("To",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));				
				else if(receiptNo.substring(0, 1).equals("R") )
					table7.addCell(new Phrase("By",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
				else
					table7.addCell(new Phrase("",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
				
				table7.addCell(new Phrase(""+amount,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
				amount=0;
			}
			amount+=rs3.getInt("Amount");			
			previousDate = date1;
			a=false;
			TotalAmount+=rs3.getInt("Amount");
		}
		
		table7.addCell(new Phrase(previousDate,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));		
		if(receiptNo.substring(0, 1).equals("P"))
			table7.addCell(new Phrase("To",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));				
		else if(receiptNo.substring(0, 1).equals("R") )
			table7.addCell(new Phrase("By",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
		else
			table7.addCell(new Phrase("",FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
		
		table7.addCell(new Phrase(""+amount,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
		document.add(table7);  
		PdfPTable tables1 = new PdfPTable(3);
		tables1.setWidthPercentage(100);
		tables1.getDefaultCell();
		tables1.setWidths(new float[] {0.3f, 0.5f,0.2f});
	
		tables1.getDefaultCell().setColspan(1);
		p = new Paragraph(" ", FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0)));
		tables1.addCell(p);	
		tables1.getDefaultCell().setColspan(1);
		tables1.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
		p = new Paragraph("Total", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		tables1.addCell(p);
		p = new Paragraph(""+TotalAmount,FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		tables1.addCell(p);
		document.add(tables1);

		if(connection!=null){
			   connection.close();
			}
        document.add(rect);
		document.close();
	}


}
