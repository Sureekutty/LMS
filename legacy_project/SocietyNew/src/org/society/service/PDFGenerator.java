package org.society.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

public class PDFGenerator {

	public static String generatePDF(JSONObject thriftDataObject, JSONObject loanDataObject, String filenamePrefix, String fy) throws Exception{
		
		OutputStream outputStream = null;
		Document document = new Document(PageSize.A4);
		ArrayList<String> thriftData=new ArrayList<String>();
		ArrayList<String> loanData=new ArrayList<String>();
		
		thriftData.add("");
		for(int i=1;i<=76;i++){
			thriftData.add(thriftDataObject.has("column"+i) ? thriftDataObject.get("column"+i).toString() : "");
		}
		
		loanData.add("");
		for(int i=1;i<=55;i++){
			loanData.add(loanDataObject.has("column"+i) ? loanDataObject.get("column"+i).toString() : "");
		}
		
		String finYr=(Integer.parseInt(fy)+1)+"";
		finYr=fy+"-"+finYr.substring(2,4);
		
		String fullFilePath=filenamePrefix+"_"+thriftData.get(3)+".pdf";
		outputStream = new FileOutputStream(new File(fullFilePath));
		
		DecimalFormat df1= new DecimalFormat("#");
		df1.setMinimumIntegerDigits(1);
		df1.setMaximumFractionDigits(0);
		df1.setMinimumFractionDigits(0);
	
		PdfWriter.getInstance(document, outputStream);
		document.open();
		Rectangle rect= new Rectangle(36,38,559,800);
		 
        rect.setBorder(Rectangle.BOX);
        rect.setBorderWidth(1);
        
        Font font6 = FontFactory.getFont(FontFactory.TIMES_ROMAN, 10, 0, new BaseColor(0, 0, 0));
        Font font1 = FontFactory.getFont(FontFactory.TIMES_ROMAN, 14,Font.BOLD);
        Font font2 = FontFactory.getFont(FontFactory.TIMES_ROMAN, 10,Font.BOLD);
        Font font3= FontFactory.getFont(FontFactory.TIMES_ROMAN, 10,0, new BaseColor(0, 0, 0));
        
		Paragraph p = null;
		
		p = new Paragraph("SHAR PROJECTS EMPLOYEES CO-OPERATIVE CREDIT SOCIETY LIMITED NO L1335 SRIHARIKOTA,TIRUPATHI DISTRICT", FontFactory.getFont(FontFactory.HELVETICA_BOLDOBLIQUE, 10,com.itextpdf.text.Font.BOLD, new BaseColor(0, 0, 0)));
		p.setAlignment(Element.ALIGN_CENTER);
		document.add(p);
		
		document.add(new Chunk(new LineSeparator()));
	
		PdfPTable table = new PdfPTable(11);
		table.setWidthPercentage(100);
		table.getDefaultCell();
		table.setWidths(new float[] {0.4f, 0.4f,0.3f, 0.4f,0.4f,0.4f,0.4f, 0.4f, 0.4f,0.4f,0.3f});
		
		//row1
		table.getDefaultCell().setColspan(11);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
		p=new Paragraph("SPECCS Annual Report for year "+finYr,font1);
		table.addCell(p);
		
		PdfPTable table1 = new PdfPTable(4);
		table1.setWidthPercentage(100);
		table1.getDefaultCell();
		table1.setWidths(new float[] {1f, 1.5f,1.5f, 1f});
		table1.getDefaultCell().setBorderWidth(0);

		//row2
		
		p=new Paragraph("Name of the member",font2);
		table1.addCell(p);
		
		p=new Paragraph(thriftData.get(4),font3);
		table1.addCell(p);
		
		p=new Paragraph("Employee code",font2);
		table1.addCell(p);
		
		p=new Paragraph(thriftData.get(3),font3);
		table1.addCell(p);
		
		//row3
		p=new Paragraph("Date of Membership",font2);
		table1.addCell(p);
		
		p=new Paragraph(thriftData.get(2),font3);
		table1.addCell(p);
		
		p=new Paragraph("Bank Account number",font2);
		table1.addCell(p);
		
		p=new Paragraph(thriftData.get(1).equals("") ? " NA" :df1.format(Double.parseDouble(thriftData.get(1))),font3);
		table1.addCell(p);
		
		//row4
		p=new Paragraph("Shares OBL",font2);
		table1.addCell(p);
		
		p=new Paragraph(getformattedNumeric(thriftData.get(5)),font3);
		table1.addCell(p);
		
		p=new Paragraph("Receipts",font2);
		table1.addCell(p);
	
		p=new Paragraph(getformattedNumeric(thriftData.get(6)),font3);
		table1.addCell(p);
		
		//row5
		p=new Paragraph("Payments",font2);
		table1.addCell(p);
		
		p=new Paragraph(getformattedNumeric(thriftData.get(7)),font3);
		table1.addCell(p);

		p=new Paragraph("Shares Capital CBL",font2);
		table1.addCell(p);
		
		p=new Paragraph(getformattedNumeric(thriftData.get(8)),font3);
		table1.addCell(p);
		table.addCell(table1);
		//row6
		table.getDefaultCell().setColspan(1);
		p = new Paragraph("Dividend for 2022-23 "+finYr, font2);
		table.addCell(p);
		
		p=new Paragraph(getformattedNumeric(thriftData.get(11)),font3);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(3);
		p = new Paragraph("Interest on Thrift for 2022-23 "+finYr, font2);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(1);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p=new Paragraph(getformattedNumeric(thriftData.get(75)),font3);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(5);
		table.getDefaultCell().setRowspan(2);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
		p=new Paragraph("Loan Account For the Year 2022-23");
		table.addCell(p);
		
		//Row7
		table.getDefaultCell().setColspan(1);
		table.getDefaultCell().setRowspan(2);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("Thrift Deposit Month of Recovery", font2);
		table.addCell(p);
		
		p = new Paragraph("Subscription", font2);
		table.addCell(p);
		
		p = new Paragraph("Receipts", font2);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(2);
		table.getDefaultCell().setRowspan(1);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
		p = new Paragraph("Payments", font2);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(1);
		table.getDefaultCell().setRowspan(2);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);		
		p = new Paragraph("CBL", font2);
		table.addCell(p);
		
		
		
		//Row8
		table.getDefaultCell().setColspan(1);
		table.getDefaultCell().setRowspan(1);
		p=new Paragraph("Loan",font2);
		table.addCell(p);
		p=new Paragraph("Cash",font2);
		table.addCell(p);
		
		p = new Paragraph("Recovery", font6);
		table.addCell(p);
		p = new Paragraph("Adjustment", font6);
		table.addCell(p);
		p = new Paragraph("Sanction", font6);
		table.addCell(p);
		p = new Paragraph("Thrift Adjustment", font6);
		table.addCell(p);
		p = new Paragraph("CBL", font6);
		table.addCell(p);
		
		//Row9
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
		table.getDefaultCell().setColspan(5);
		p = new Paragraph("Opening Balance", font2);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(1);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(9)), font2);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(4);
		p = new Paragraph("Opening Balance", font2);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(1);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(loanData.get(4)), font2);
		table.addCell(p);
		
		//Row10

		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("April-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(13)), font6);
		table.addCell(p);
		
		
		p = new Paragraph(getformattedNumeric(thriftData.get(14)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		
		p=new Paragraph(getformattedNumeric(thriftData.get(15)), font6);
		table.addCell(p);

		p = new Paragraph(getformattedNumeric(thriftData.get(16)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(6)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(7)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(8)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(9)), font6);
		table.addCell(p);
		
		
		//row11
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("May-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(17)), font6);
		table.addCell(p);
		
		
		p = new Paragraph(getformattedNumeric(thriftData.get(18)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(19)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(20)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(10)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(11)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(12)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(13)), font6);
		table.addCell(p);
		
		//row12
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("June-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(21)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(25)), font6);
		table.addCell(p);
		
		p=new Paragraph(getformattedNumeric(thriftData.get(23)), font6);
		table.addCell(p);
		
		p=new Paragraph(getformattedNumeric(thriftData.get(24)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(27)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(14)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(16)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(17)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(15)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(18)), font6);
		table.addCell(p);
		
		//row13
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("July-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(28)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(29)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(30)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(31)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(19)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(20)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(21)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(22)), font6);
		table.addCell(p);
		
		//row14
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("August-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(32)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(33)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(34)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(35)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(23)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(24)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(25)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(26)), font6);
		table.addCell(p);
		
		//row15
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("September-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(36)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(37)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(38)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(39)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(27)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(28)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(29)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(30)), font6);
		table.addCell(p);
		//row16
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("October-2022", font6);
		table.addCell(p);
		
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(40)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(41)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(42)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(43)), font6);
		table.addCell(p);
		
		
		p = new Paragraph(getformattedNumeric(loanData.get(31)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(32)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(33)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(34)), font6);
		table.addCell(p);
		
		//row17
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("November-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(44)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(45)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(46)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(47)), font6);
		table.addCell(p);
		
		
		p = new Paragraph(getformattedNumeric(loanData.get(35)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(36)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(37)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(38)), font6);
		table.addCell(p);
		
		//row18
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("December-2022", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(48)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(49)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(50)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(51)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(39)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(40)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(41)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(42)), font6);
		table.addCell(p);
		
		//row19
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("January-2023", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(52)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(53)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(54)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(55)), font6);
		table.addCell(p);
		
		
		p = new Paragraph(getformattedNumeric(loanData.get(43)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(44)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(46)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(47)), font6);
		table.addCell(p);
		
		//row20
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("February-2023", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(56)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(57)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(58)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(59)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(48)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(49)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(50)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(51)), font6);
		table.addCell(p);
		
		
		//row21
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
		p = new Paragraph("March-2023", font6);
		table.addCell(p);
		table.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
		p = new Paragraph(getformattedNumeric(thriftData.get(60)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(61)), font6);
		table.addCell(p);
		
		p=new Paragraph("",font6);
		table.addCell(p);
		p=new Paragraph(getformattedNumeric(thriftData.get(62)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(thriftData.get(63)), font6);
		table.addCell(p);
		
		p = new Paragraph(getformattedNumeric(loanData.get(52)), font6);
		table.addCell(p);		
		p = new Paragraph(getformattedNumeric(loanData.get(53)), font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(54)), font6);
		table.addCell(p);
		p = new Paragraph(" ", font6);
		table.addCell(p);
		p = new Paragraph(getformattedNumeric(loanData.get(55)), font6);
		table.addCell(p);
		
		table.getDefaultCell().setColspan(6);
		p = new Paragraph("");
		table.addCell(p);
		
		
		document.add(table);
		document.close();
	
		
		return fullFilePath;
	}
	
	protected static String getformattedNumeric(String numdata){
		
		DecimalFormat df= new DecimalFormat("#");
		df.setMinimumIntegerDigits(1);
		df.setMaximumFractionDigits(2);
		df.setMinimumFractionDigits(2);
		
		String formattedVal="-NA-";
		
		try{
			formattedVal=df.format(Double.parseDouble(numdata.trim().equals("") ? "0" :numdata.trim()));
		}catch (Exception e){
			if(e.toString().contains("NumberFormatException"))
				return "-NA-";
		}
		return formattedVal;
	}
}
