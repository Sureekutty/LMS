package org.society.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.society.util.DataBaseConnectionForNewDB;

import com.itextpdf.text.Document;
import com.itextpdf.text.FontFactory;

import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;


public class MonthlyRecoveryTextfile {

	public static void getText(String monandyear,String purposeval,String monthdate) throws Exception {     
		 Connection connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	       
         boolean flag=false;
		       OutputStream outputStream = new FileOutputStream(new File(monandyear+"&"+purposeval+".txt"));
               File file=new File(monandyear+"&"+purposeval+".txt");
               Document document = new Document();
               PdfWriter.getInstance(document, outputStream);
               FileOutputStream fos=new FileOutputStream(file);
               OutputStreamWriter osw=new OutputStreamWriter(fos);
               
                      
               String sqlQuery = "EXEC speccs.SP_MonthlyProcess 'TEXTDATA','"+purposeval+"','"+monthdate.replace("-", "/")+"','',0,'','',''";
//             System.out.println(sqlQuery);     
               PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
               ResultSet res = ps3.executeQuery();
                      
              int loop=0;
//                  System.out.println("loop value is  "+loop);
              while (res.next()) {
	             	flag=true;
	//              System.out.println((loop>=0 )+"thats why it is not going inside if condition");
	             	if(loop==0)	
	             		osw.write("Sal Code  : "+res.getInt("Salcode")+"\r");	             	
	             	else if(purposeval.equals("D20"))
		            	osw.write(res.getString("Empcode").trim()+" : "+res.getFloat("Recoveryamount")+" : "+res.getString("Refid").trim()+"\r");
	                else
		            	osw.write(res.getString("Empcode").trim()+" : "+res.getFloat("Recoveryamount")+"\r");
		             
//			        System.out.println("loop outside"+loop);
                   	loop++;                   	
                }
                if(!flag)
                     osw.write("                     NO DATA                ");
                   
				osw.close();
				connection.close();	           		
	
	}	
}


