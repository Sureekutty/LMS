package org.society.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.society.util.DataBaseConnectionForNewDB;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

@WebServlet("/downloadExcel")
public class ThriftInterestExcel extends HttpServlet {

	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
   	 	Connection connection = null; 
   	 	
    	try {
    		String opt=req.getParameter("req");
    	if(opt.equals("MemThriftIntDetails")) {
    		 float intRate = Float.parseFloat(req.getParameter("intRate"));
			String fromDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(req.getParameter("fromDate").trim()));
			String toDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(req.getParameter("toDate").trim()));
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	              
            String sqlQuery = "EXEC speccs.Sp_getThriftInterest "+intRate+",'"+fromDate+"','"+toDate+"'";
//      	System.out.println(sqlQuery);     
            PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
            ResultSet res = ps3.executeQuery();
            
            boolean flag=false;
    	
         // Create Excel workbook and sheet
            Workbook workbook = new XSSFWorkbook(); 
            Sheet sheet = workbook.createSheet("Thrift Interest");

            // Create header row
            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("EMPCODE");
            headerRow.createCell(1).setCellValue("EMPLOYEENAME");
            headerRow.createCell(2).setCellValue("THRIFT INTEREST");
            headerRow.createCell(3).setCellValue("BANK NAME");
            headerRow.createCell(4).setCellValue("BANK ACC No.");

            // Add some sample data rows
            int rowIndex = 1;
            while (res.next()) {
            	flag=true;
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(res.getString("MemEmpCode"));
                row.createCell(1).setCellValue(res.getString("MemName"));
                row.createCell(2).setCellValue(res.getInt("ThriftInterest"));
                row.createCell(3).setCellValue(res.getString("BankName"));
                row.createCell(4).setCellValue(res.getString("BankAccNo"));

            }
            if(!flag){
            	Row row = sheet.createRow(rowIndex++);
            	 row.createCell(0).setCellValue("No Data"); 
                 row.createCell(1).setCellValue("No Data");
                 row.createCell(2).setCellValue("No Data");
                 row.createCell(3).setCellValue("No Data");
                 row.createCell(4).setCellValue("No Data");
              
             }

            // Set response headers to trigger download
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=ThriftInterest.xlsx");

            // Write workbook to response output stream
           OutputStream out = resp.getOutputStream() ;
                workbook.write(out);
            
    	}
    	if(opt.equals("MemThriftPoll")) {
    		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	              
            String sqlQuery = "Select MemName,MemEmpCode,ThriftIntOpt,ThriftOption,OptedDate from speccs.ThriftIntPoll";
//      	System.out.println(sqlQuery);     
            PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
            ResultSet res = ps3.executeQuery();
            
            boolean flag=false;
    	
         // Create Excel workbook and sheet
            Workbook workbook = new XSSFWorkbook(); 
            Sheet sheet = workbook.createSheet("Thrift Poll");

            // Create header row
            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("EMPCODE");
            headerRow.createCell(1).setCellValue("EMPLOYEENAME");            
            headerRow.createCell(2).setCellValue("OPTION NAME");
            headerRow.createCell(3).setCellValue("OPTION NUMBER");
            headerRow.createCell(4).setCellValue("OPTION OPTED DATE");

            // Add some sample data rows
            int rowIndex = 1;
            while (res.next()) {
            	flag=true;
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(res.getString("MemEmpCode"));
                row.createCell(1).setCellValue(res.getString("MemName"));
                row.createCell(2).setCellValue(res.getString("ThriftIntOpt"));
                row.createCell(3).setCellValue(res.getInt("ThriftOption"));
                
                row.createCell(4).setCellValue(new SimpleDateFormat("dd/MM/yyyy").format(res.getDate("OptedDate")));

            }
            if(!flag){
            	Row row = sheet.createRow(rowIndex++);
            	 row.createCell(0).setCellValue("No Data"); 
                 row.createCell(1).setCellValue("No Data");
                 row.createCell(2).setCellValue("No Data");
                 row.createCell(3).setCellValue("No Data");
                 row.createCell(4).setCellValue("No Data");
              
             }

            // Set response headers to trigger download
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=ThriftPoll.xlsx");

            // Write workbook to response output stream
           OutputStream out = resp.getOutputStream() ;
                workbook.write(out);
    	}
    	} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	finally {

			if(connection!=null){
				try {
					connection.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		
		}
    }
}