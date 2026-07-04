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

public class DailyAccountsProcessingpdf {

	

	public static void getPDF(String processsdate,String header,String number) throws Exception {
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("Dailyaccountsprocesspdf.pdf"));

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
		p = new Paragraph("                                                Daily Accounts Processing                                                          Date: "+strDate+"          ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		document.add(enter);
	
		 
			String quer9="speccs.SP_Prints 'DAP','','','','"+processsdate+"'";

			ps = connection.prepareStatement(quer9);
			ResultSet rs9 = ps.executeQuery();
			
			PdfPTable tables8 = new PdfPTable(4);
			tables8.setWidthPercentage(100);
			tables8.getDefaultCell();
			tables8.setWidths(new float[] { 4f, 8f,4f, 5f});
		
			
			p = new Paragraph("Process Date", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			p = new Paragraph("Account Description", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			p = new Paragraph("Amount", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			p = new Paragraph("UserId", font6);
			p.setAlignment(Element.ALIGN_LEFT);
			tables8.addCell(p);
			
			
			PdfPTable table69 = new PdfPTable(4);
			table69.setWidthPercentage(100);
			table69.getDefaultCell();
			
			table69.setWidths(new float[] {4f, 8f,4f, 5f});
			while (rs9.next()) {
			table69.addCell(new Phrase(rs9.getString("ProcessDate"),font3));
			table69.addCell(new Phrase(rs9.getString("AccountDescription"),font3));
			table69.addCell(new Phrase(""+rs9.getInt("Amount"),font3));
			table69.addCell(new Phrase(rs9.getString("UserId"),font3));
			
			}
			document.add(tables8);
			document.add(table69);
        if(connection!=null){
			connection.close();
		}
        document.add(rect);
       document.close();
	}


}
