package org.society.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
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
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import com.lowagie.text.HeaderFooter;


public class SanctionReleasedPDF {
	
	
	public static void getPDF( HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		HttpSession session = request.getSession();
		Connection connection = null;
		
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;

		String chequeNumber = request.getParameter("chequeNumber");
		String amount = request.getParameter("totalAmount");
		String JsonData = request.getParameter("JsonData").trim();
		String strDate = new SimpleDateFormat("dd MMMMM, yyyy").format(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("idate").trim()));
		JSONArray jsonArrayData = new JSONArray(JsonData);
		
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("SanctionReleasedPDF.pdf"));
	
		PdfWriter write= PdfWriter.getInstance(document, outputStream);
		
		
		document.open();
		Rectangle rect= new Rectangle(36,38,559,800);
		 
        rect.setBorder(Rectangle.BOX);
        rect.setBorderWidth(1);
       
		Paragraph enter = new Paragraph("\n");
		Paragraph p = null;
		
		
		LineSeparator line=new LineSeparator();
		
		
		p = new Paragraph("Date of Regn : 02 May 1974"+"                                                                                                                                      "+"Phone Nos. 08623-222085",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
		document.add(p);
		
		
		p = new Paragraph( "Date of Starting : 13 May 1974"+"                                                                                                                                                               "+"222095",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
		document.add(p);
		
		
		p = new Paragraph("SHAR PROJECTS EMPLOYEES CO-OPERATIVE CREDIT SOCIETY LIMITED NO L1335 SRIHARIKOTA,TIRUPATHI DISTRICT", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.BOLD, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		
		p = new Paragraph( "Ex-officio president"+"                                                                                   "+"president"+"                                                                     "+"secretary",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
		document.add(p);
		
		p = new Paragraph( "Shri.M Srinivasulu Reddy, I T S."+"                                                      "+"Shri.K V Suresh Babu"+"                                              "+"Shri.V Ramanjaneya",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
		document.add(p);
		
		p = new Paragraph( "Controller SDSC SHAR Sci."+"                                                                "+" Sci. Engineer-SG"+"                                                     "+"Technical Officer-C",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
		document.add(p);
		
		document.add(new Chunk(line));
		
		p = new Paragraph("Date: "+strDate+"",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_RIGHT);
		document.add(p);
		
		p = new Paragraph("The Branch Manager \n _________ \n Sriharikota Branch",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		
		p = new Paragraph("\n Sir",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
		
		p = new Paragraph("        "+"Please find herewith enclosed a cheque bearing No. "+chequeNumber+" dated: "+strDate+" "+" for Rs. "+amount+" /- In this regard ,it is requested to kindly arrange to deposit the same as per the list enclosed here under and oblige. ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		//p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		
		document.add(new Chunk());
		
		
		Font font6 = FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, 0, new BaseColor(0, 0, 0));
	       
		PdfPTable tables = new PdfPTable(4);
		tables.setWidthPercentage(100);
		tables.getDefaultCell();
		tables.setWidths(new float[] { 0.1f, 0.4f,0.3f, 0.2f});
	
		
		p = new Paragraph("Sl\nNo.", font6);
		tables.addCell(p);
		
		p = new Paragraph("Name of the member S/Shri/Smt.", font6);		
		tables.addCell(p);
		
		
		p = new Paragraph("Account Number", font6);		
		tables.addCell(p);				
		
		p = new Paragraph("Amount\nRs", font6);		
		tables.addCell(p);
		
		document.add(tables);
			
		
		int count=1;
		for(int i=0;i<jsonArrayData.length();i++) {
						
			JSONObject jobj = jsonArrayData.getJSONObject(i);
			
			PdfPTable tables1 = new PdfPTable(4);
			tables1.setWidthPercentage(100);
			tables1.getDefaultCell();
			tables1.setWidths(new float[] { 0.1f, 0.4f,0.3f, 0.2f});
				
			p = new Paragraph(count+".", font6);			
			tables1.addCell(p);
			
			
			p = new Paragraph(jobj.getString("memname"), font6);			
			tables1.addCell(p);
			
			
			p = new Paragraph(jobj.getString("bankaccno"), font6);			
			tables1.addCell(p);
			
			p = new Paragraph(jobj.getInt("chequeAmount")+"", font6);			
			tables1.addCell(p);
			
			document.add(tables1);
			count++;
//			document.newPage();
		}
		
			PdfPTable tables1 = new PdfPTable(4);
			tables1.setWidthPercentage(100);
			tables1.getDefaultCell();
			tables1.setWidths(new float[] { 0.1f, 0.4f,0.3f, 0.2f});
		
			
			p = new Paragraph(" ", font6);
			tables1.addCell(p);
			
			p = new Paragraph(" ", font6);
			tables1.addCell(p);
				
			p = new Paragraph("Total", font6);
			tables1.addCell(p);
									
			p = new Paragraph(amount,font6);
			tables1.addCell(p);
			document.add(tables1);
			
			
			/*document.add(new Chunk("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"));
	
			p=new Paragraph("Secretary / Director",FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, 0, new BaseColor(0, 0, 0)));
			p.setAlignment(Element.ALIGN_RIGHT);
			document.add(p);
			document.add(new Chunk("\n\n\n\n\n\n\n\n"));
			
			document.add(new Chunk(line));
			
			p = new Paragraph( "BOARD OF DIRECTOR",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
			p.setAlignment(Element.ALIGN_CENTER);
			document.add(p);
			
			p = new Paragraph( "Shri.A Rama Rao,Senior Technician Assistant-A"+"                                                                                           "+"Shri.M Sridhar chowhan,Assistant",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
			document.add(p);
			
			p = new Paragraph( "Shri.U Krisna,Senior Technician-A"+"                                                                                                               "+"Shri.A Tavitinaidu,Technicialn Officer-c",FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0)));
			document.add(p);*/
			write.setPageEvent(new PdfPageEventHelper() {
				@Override
				public void onEndPage(PdfWriter writer,Document doc) {
					
					float contentSpace = doc.bottom()+60;
					float lineSpace =20f;
					PdfContentByte canvas = writer.getDirectContent();
					Font font = FontFactory.getFont(FontFactory.TIMES_ITALIC, 9, 0, new BaseColor(0, 0, 0));
					try {
						ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_RIGHT, new Phrase("Secretary / Director"), doc.right()-10, contentSpace, 0);
						contentSpace -=lineSpace+10;					
//						ColumnText.showTextAligned(writer.getDirectContent(), 0, new Phrase(new Chunk(new LineSeparator())), (doc.right()-doc.left())/2, doc.bottom()-10, 0);
						canvas.setLineWidth(1f);
						canvas.moveTo(doc.left(), contentSpace);
						canvas.lineTo(doc.right(), contentSpace);
						canvas.stroke();
						ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_CENTER, new Phrase("BOARD OF DIRECTOR",font), (doc.right()-doc.left())/2, contentSpace+10, 0);
						contentSpace -=lineSpace;
						ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_LEFT, new Phrase("Shri.A Rama Rao,Engineer SC",font), doc.left()+10, contentSpace+10, 0);
						ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_RIGHT, new Phrase("Shri.M Sridhar chowhan,Sr. Assistant",font), doc.right()-10, contentSpace+10, 0);
						contentSpace -=lineSpace-10;
						ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_LEFT, new Phrase("Shri.U Krisna,Senior Technician-A",font), doc.left()+10, contentSpace+10, 0);
						ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_RIGHT, new Phrase("Shri.A Tavitinaidu,Technical Officer-c",font), doc.right()-10, contentSpace+10, 0);
					}catch (Exception e) {
						e.printStackTrace();
					}
					}
				
			});
			
		    document.close();
		   
		    JSONObject jsonObject = new JSONObject();
			jsonObject.put("SUCCESS", "Y");
			response.getWriter().write(jsonObject.toString());
	   	
	}

}



