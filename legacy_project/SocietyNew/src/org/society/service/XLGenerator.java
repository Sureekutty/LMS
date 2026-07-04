package org.society.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.http.HttpServletResponse;

import org.society.util.DataBaseConnectionForNewDB;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;


public class XLGenerator {
	
	
	public static void getExecl(HttpServletResponse response,String monandyear,String purposeval,String monthdate) throws Exception {
	  
                Connection connection = null;  
                System.out.println(purposeval);
                //File file=new File("C:/Users/Administrator/Downloads/"+monandyear+"&"+purposeval+".xlsx");
                connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	              
                String sqlQuery = "EXEC speccs.SP_MonthlyProcess 'EXCELDATA','"+purposeval+"','"+monthdate+"','',0,'','',''";
//          	System.out.println(sqlQuery);     
                PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
                ResultSet res = ps3.executeQuery();
                
                boolean flag=false;
                Workbook workbook = new XSSFWorkbook();
                Sheet sheet = workbook.createSheet(purposeval);

                // Add header row
                Row headerRow = sheet.createRow(0);
                headerRow.createCell(0).setCellValue("EMPCODE");
                headerRow.createCell(1).setCellValue("EMPLOYEENAME");
                headerRow.createCell(2).setCellValue("DESGFULLNAME");
                headerRow.createCell(3).setCellValue("CURRAMT");
                headerRow.createCell(4).setCellValue("PREVAMT");
                headerRow.createCell(5).setCellValue("DIFFAMT");
                
                

                // Add data rows from ResultSet
                int rowIndex = 1;
                while (res.next()) {
                	flag=true;
                    Row row = sheet.createRow(rowIndex++);
                    row.createCell(0).setCellValue(res.getString("Empcode"));
                    row.createCell(1).setCellValue(res.getString("MemName"));
                    row.createCell(2).setCellValue(res.getString("Designation"));
                    row.createCell(3).setCellValue(res.getInt("Recoveryamount"));
                    row.createCell(4).setCellValue(res.getInt("prvAmount"));
                    row.createCell(5).setCellValue(res.getInt("diffAmt"));
                }
                if(!flag){
                	Row row = sheet.createRow(rowIndex++);
                	 row.createCell(0).setCellValue("No Data"); 
                     row.createCell(1).setCellValue("No Data");
                     row.createCell(2).setCellValue("No Data");
                     row.createCell(3).setCellValue("No Data");
                     row.createCell(4).setCellValue("No Data");
                     row.createCell(5).setCellValue("No Data");
                 }
                
               /* try (FileOutputStream fileOut = new FileOutputStream(file)) {
                	//System.out.println(file);
                    workbook.write(fileOut);
                    fileOut.flush();
                    fileOut.close();
                    workbook.close(); 
                    
                }*/
                // Set response headers to trigger download
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment; filename="+monandyear+"&"+purposeval+".xlsx");

                // Write workbook to response output stream
                try (OutputStream out = response.getOutputStream()) {
                    workbook.write(out);
                }
                catch(Exception e){
                	 workbook.close(); 
        			if(connection!=null){
        				connection.close();
        			}
        		}
               
                       	
	}
	
}
