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
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

public class Cashbookregistrationpdf {

	

	public static void getPDF(String cashfromdate,String cashtodate,String header,String number) throws Exception {
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("CashBookRegistration.pdf"));

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
		p = new Paragraph("                                                        Cash Book between "+cashfromdate+" - "+cashtodate+"                          Date: "+strDate+"    ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
	    document.add(enter);
	   /* String Fromdate;
	    String Todate;
	    String ReceiptNo;
	    String Receiptdate;
	    String MemeberAcc;
	    String RefId;
	    String Purpose;
	    int Amount;
	 */
		
	   	PdfPTable table3 = new PdfPTable(6);
	   	table3.setWidthPercentage(100);
	   	table3.getDefaultCell();
	   	table3.setWidths(new float[] { 3f, 2.5f,2.2f, 5.5f,2.0f,2.5f});
	   	
	 
	   	p = new Paragraph("Receipt No",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_CENTER);
		table3.addCell(p);
		
		p = new Paragraph(" Date",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_CENTER);
		table3.addCell(p);
		
		p = new Paragraph("Mem AccNo",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_CENTER);
		table3.addCell(p);
		
		p = new Paragraph("Mem Name",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_CENTER);
		table3.addCell(p);
		
		p = new Paragraph("Amount",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_CENTER);
		table3.addCell(p);
		
		p = new Paragraph("Total",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
		p.setAlignment(Element.ALIGN_CENTER);
		table3.addCell(p);
		document.add(table3);
		
	  	String sqlquery="speccs.SP_Prints 'CAHSBOOKREPORT','','','"+cashfromdate+"','"+cashtodate+"'";
			
	  	ps = connection.prepareStatement(sqlquery);
	  	ResultSet rs3 = ps.executeQuery();
       
		PdfPTable table7 = new PdfPTable(6);
		table7.setWidthPercentage(100);
		table7.getDefaultCell();
		table7.setWidths(new float[] {3f, 2.5f,2.2f, 5.5f,2.0f,2.5f});
		       
		int amount=0,rowspan=1;	
		String prvPurCode=null;
		while(rs3.next()) {					
			String purCode = rs3.getString("purpose")==null?"":rs3.getString("purpose");
			int purCount = rs3.getInt("purCount");
				if(!purCode.split("-")[0].equals(prvPurCode)){					
					rowspan=1;
					prvPurCode = purCode.split("-")[0];
					PdfPCell pdfCell = new PdfPCell(new Phrase(purCode.split("-")[1],FontFactory.getFont(FontFactory.TIMES_ROMAN, 12,Font.BOLD)));
					pdfCell.setColspan(6);
					pdfCell.setHorizontalAlignment(Element.ALIGN_CENTER);
					table7.addCell(pdfCell);
				}						
				table7.addCell(new Phrase(rs3.getString("ReceiptNo"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
				table7.addCell(new Phrase(rs3.getString("dt"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
			    table7.addCell(new Phrase(rs3.getString("MemAccNO"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
				table7.addCell(new Phrase(rs3.getString("MemName"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));	
				table7.addCell(new Phrase(""+ rs3.getInt("Amount"),FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0)))); 
				if(rowspan==1){
					PdfPCell cell=new PdfPCell(new Phrase(""+rs3.getInt("totalAmount"),FontFactory.getFont(FontFactory.TIMES_ROMAN, 12,Font.BOLD)));
					cell.setRowspan(purCount);
					cell.setHorizontalAlignment(Element.ALIGN_CENTER);
					cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table7.addCell(cell);					
				}
			rowspan++;
			amount=amount+rs3.getInt("Amount");
		}
		document.add(table7);  
		PdfPTable tables1 = new PdfPTable(6);
		tables1.setWidthPercentage(100);
		tables1.getDefaultCell();
		tables1.setWidths(new float[] {3f, 2.5f,2.2f, 5.5f,2.0f,2.5f});
	
		tables1.getDefaultCell().setColspan(4);
		p = new Paragraph(" ", FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0)));
		tables1.addCell(p);	
		tables1.getDefaultCell().setColspan(1);
		p = new Paragraph("Total", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12,Font.BOLD));
		tables1.addCell(p);
		tables1.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
		p = new Paragraph(""+amount,FontFactory.getFont(FontFactory.TIMES_ROMAN, 12,Font.BOLD));
		tables1.addCell(p);
		document.add(tables1);

		if(connection!=null){
			   connection.close();
			}
        document.add(rect);
		document.close();
	}


}
