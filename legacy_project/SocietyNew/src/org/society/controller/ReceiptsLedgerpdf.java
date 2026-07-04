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

public class ReceiptsLedgerpdf {

	

	public static void getPDF(String MemAccNO,String receiptno,String header,String number) throws Exception {
		
		Connection connection = null;
		PreparedStatement ps = null;
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		outputStream = new FileOutputStream(new File("ReceiptLedger.pdf"));

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
		p = new Paragraph("                                                        Receipts between "+strDate+" - "+strDate+"                          Date: "+strDate+"    ",FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10, 0, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_LEFT);
		document.add(p);
	    document.add(enter);
	    String Fromdate;
	    String Todate;
	    String ReceiptNo;
	    String Receiptdate;
	    String MemeberAcc;
	    String RefId;
	    String Purpose;
	    int Amount;
	 
		
					   	PdfPTable table3 = new PdfPTable(6);
					   	table3.setWidthPercentage(100);
					   	table3.getDefaultCell();
					   	table3.setWidths(new float[] { 3f, 3f,3f, 3f,3f,3f});
					   	
					 
					   	p = new Paragraph("Receipt No",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Receipt Date",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Mem AccNo",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Ref Id",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Purpose",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						
						p = new Paragraph("Amount",  FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10));
						p.setAlignment(Element.ALIGN_CENTER);
						table3.addCell(p);
						  document.add(table3);
						
						  String sqlquery="speccs.SP_Prints 'RECEIPTLEDGER','','"+receiptno+"','',''";
							String receiptnum = null;
							String receiptdate= null;
							String memeacc= null;
							String refid= null;
							String purpose= null;
							int amount=0;
						     ps = connection.prepareStatement(sqlquery);
						       ResultSet rs3 = ps.executeQuery();
						       if(rs3.next()) {
						    	   receiptnum=rs3.getString("ReceiptNo");
						    	   receiptdate=rs3.getString("ReceiptDate").substring(0, 10);
						    	   memeacc=rs3.getString("MemAccNO");
						    	   amount=rs3.getInt("Amount");						   
						    	   refid=rs3.getString("RefNo");
						    	   purpose=rs3.getString("purposedesc");
						       }
						  
						       if(refid==""||refid==null)
						    	   refid="-";
						  
						  
						  
						PdfPTable table7 = new PdfPTable(6);
						table7.setWidthPercentage(100);
						table7.getDefaultCell();
						table7.setWidths(new float[] {3f, 3f,3f, 3f,3f,3f});
						
							   table7.addCell(new Phrase(receiptnum,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
								table7.addCell(new Phrase(receiptdate,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
								table7.addCell(new Phrase(memeacc,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
								table7.addCell(new Phrase(refid,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));	
								table7.addCell(new Phrase(purpose,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));	
								table7.addCell(new Phrase(""+amount,FontFactory.getFont(FontFactory.HELVETICA, 10, 0, new BaseColor(0, 0, 0))));
								document.add(table7);  
		
			
								if(connection!=null){
									   connection.close();
									}
        document.add(rect);
		document.close();
	}


}
