package org.society.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.LinkedList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;
import org.society.util.DataBaseConnectionForNewDB;

import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;

/**
 * Servlet implementation class DepositProcessingController
 */
@WebServlet("/DepositProcessingController")
public class DepositProcessingController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

String incomingRequest = request.getParameter("req");
		
		

		Connection connection = null;

		CallableStatement cs1 = null;

		String sqlQuery = "";
		JSONObject jsonObject = null;
		//PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		
		try {
		
			if(incomingRequest.equalsIgnoreCase("savedepositprocess")){
				try{
					
					String ipaddress=request.getRemoteHost();
					
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				
				String depositprocesstypes = request.getParameter("depositprocesstypes");
				String depositNumber = request.getParameter("depositNumber");
				String depositprocessreq = request.getParameter("depositprocessreq").trim();
				String remarks = request.getParameter("remarks");
				String option = request.getParameter("option");
				String memaccno = request.getParameter("memaccno");
				String loanrefno = request.getParameter("loanrefno");
				
				int loanadjamt =Integer.parseInt(request.getParameter("loanadjamt"));
				String processDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse( request.getParameter("processDate").trim()));
				
			
				sqlQuery = "{call speccs.SP_DepositsProcess(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
				
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				cs1 = connection.prepareCall(sqlQuery);
				
				cs1.setString(1, option);
				cs1.setString(2, depositNumber);
				cs1.setString(3, depositprocesstypes);
				cs1.setString(4, depositprocessreq);
				cs1.setString(5, remarks);
				cs1.setString(6, memaccno);
				cs1.setString(7, processDate);
				cs1.setInt(8, loanadjamt);
				cs1.setString(9, loanrefno);
				cs1.setString(10, loanrefno);
				cs1.setString(11, userId);
				cs1.setString(12, ipaddress);
				cs1.registerOutParameter(13, Types.VARCHAR);
				cs1.executeUpdate();
							
				jsonObject = new JSONObject();
				jsonObject.put("success", "y");
				jsonObject.put("paymentno", cs1.getString(13));
				if(connection!=null){
					connection.close();
					}
				
				}catch(Exception e){
					e.printStackTrace();
					if(connection!=null){
						connection.close();
						}
				}
			}
			
			if(incomingRequest.equalsIgnoreCase("processbillsnumber")){
				try{
					
					String ipaddress=request.getRemoteHost();
					
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				
				String memaccno = request.getParameter("memaccno");
				String depositnum = request.getParameter("depositnum");
				
					connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
					String sqlQuery1 = "speccs.SP_DepositsView 'PAYMENTNUMBER','"+memaccno+"','','"+depositnum+"','',''";
						ResultSet executeQuery = connection.createStatement().executeQuery(sqlQuery1);
						String paymentnumber=null;
							if (executeQuery.next()) {
								paymentnumber=executeQuery.getString("PayVoucherNo").trim();
							}
							jsonObject = new JSONObject();
							jsonObject.put("PAYMENTNUMBER", paymentnumber);
							if(connection!=null){
								connection.close();
								}
									
				}catch(Exception e){
					e.printStackTrace();
					if(connection!=null){
						connection.close();
						}
				}
			}
			
			
			
			
			if(incomingRequest.equalsIgnoreCase("savedepositprocessoffc")){
				try{
					
					String ipaddress=request.getRemoteHost();
					
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				
				String memaccno = request.getParameter("memaccno");
				String depositNumber = request.getParameter("depositNumber");
				String depositprocessreq = request.getParameter("depositprocessreq").trim();
				String remarks = request.getParameter("remarks");
				String paymentnum = request.getParameter("paymentnum").trim();
				
				String approvereq=depositprocessreq.replace("INIT", "APPROVE");
			
	
				sqlQuery = "{call speccs.SP_DepositsProcess(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
				
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				cs1 = connection.prepareCall(sqlQuery);
				
				cs1.setString(1, approvereq);
				cs1.setString(2, depositNumber);
				cs1.setString(3, "");
				cs1.setString(4, depositprocessreq);
				cs1.setString(5, remarks);
				cs1.setString(6, memaccno);
				cs1.setString(7, "");
				cs1.setInt(8, 0);
				cs1.setString(9, "");
				cs1.setString(10, paymentnum);
				cs1.setString(11, userId);
				cs1.setString(12, ipaddress);
				cs1.registerOutParameter(13, Types.VARCHAR);
				cs1.execute();
	
							
				jsonObject = new JSONObject();
				jsonObject.put("success", "y");
				if(connection!=null){
					connection.close();
					}
				
				}catch(Exception e){
					e.printStackTrace();
					if(connection!=null){
						connection.close();
						}
				}
			}
			if(incomingRequest.equals("processMIS")) {

				connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
				String month = request.getParameter("month");
				month = (Integer.parseInt(month)<10)?"0"+month:month;
				String year = request.getParameter("year");
				 String monandyear="01/"+month+"/"+year;
				 monandyear=new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(monandyear));
				 //String promonth =month+"/01/"+year;
				 String role = request.getParameter("role");
				 String userId = (String) session.getAttribute("EMPLOYEECODE");
				 sqlQuery = "EXEC speccs.SP_DepositsProcess 'PROCESS','"+monandyear+"','','','"+role+"','','',0,'','',"+userId+",'',''";
				 PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
			      	ResultSet res = ps3.executeQuery();
				
				 JSONArray array3 = new JSONArray();
				 int flag=0;
					while (res.next()) {
						flag=1;
						jsonObject = new JSONObject();
						String MemAccNo=res.getString("MemAccNo").trim();
						String Emp=res.getString("MemEmpCode").trim()+"-"+res.getString("MemName").trim();
						String Refid=res.getString("DepositNo").trim();
						String accNumber = res.getString("BankAccNo");
						String processedMonth=res.getString("Month");
						String openDate = res.getString("OpenDate");
						openDate = new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(openDate));
						processedMonth=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(processedMonth));
						float amount=res.getFloat("PaidInterest");
						
						jsonObject.put("MemAccNo", MemAccNo);
						jsonObject.put("Emp", Emp);
						jsonObject.put("depositNo", Refid);	
						jsonObject.put("accNo", accNumber);
						jsonObject.put("amount", amount);
						jsonObject.put("month", processedMonth);
						jsonObject.put("openDate", openDate);
						array3.put(jsonObject);	
					}
					
					if(flag==0){
						jsonObject = new JSONObject();
						jsonObject.put("MISDETAILS", "N");
						
					}else{
						jsonObject = new JSONObject();
						jsonObject.put("MISDETAILS", array3);
						if(Integer.parseInt(role)==2)
							jsonObject.put("msg", "PROCESSED SUCCESSFULLY");
						//System.out.println(jsonObject.toString());
						
						
					}
					if(connection!=null){
						connection.close();
					}
			}
			
			if(incomingRequest.equalsIgnoreCase("getClosingBal")){
				try{
					
					String ipaddress=request.getRemoteHost();
					
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				
				String depositprocesstypes = request.getParameter("depositprocesstypes");
				
				String depositNumber = request.getParameter("depositNumber");
				String processDate =new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse( request.getParameter("processDate").trim()));
				System.out.println(depositprocesstypes+" -- "+depositNumber);
			
				sqlQuery = "{call speccs.SP_getDepositClosingBal(?,?,?,?)}";
				
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				cs1 = connection.prepareCall(sqlQuery);
				
				cs1.setString(1, depositprocesstypes);
				cs1.setString(2, processDate);
				cs1.setString(3, depositNumber);
				cs1.registerOutParameter(4, Types.NUMERIC);
				cs1.executeUpdate();
							
				jsonObject = new JSONObject();
				jsonObject.put("success", "y");
				jsonObject.put("bal", cs1.getInt(4));
				//System.out.println(jsonObject.toString());
				if(connection!=null){
					connection.close();
					}
				
				}catch(Exception e){
					e.printStackTrace();
					if(connection!=null){
						connection.close();
						}
				}
			}
			
/*			if (incomingRequest.equals("MemGenpdfforMISPayments")) {
				
				String month = request.getParameter("month");
				String year = request.getParameter("year");
				
				MISPaymentPDF.getPDF(request, response,month,year);
				String fileName = "MISPaymentsPDF.pdf";
				response.setContentType("application/pdf");
				
				File file1 = new File(fileName);
				response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
				response.setContentLength((int) file1.length());
				FileInputStream fis = new FileInputStream(file1);
				int len = (int) file1.length();

				out.flush();
				int temp;

				while ((temp = fis.read()) != -1) {
					out.write(temp);
					out.flush();

				}
				
				out.close();
				fis.close();
				return;

			}*/
			if(incomingRequest.equals("MemGenpdfforMISPayments")) {
				
				
				String JsonData = request.getParameter("JsonData").trim();
				JSONArray jsonArrayData = new JSONArray(JsonData);
	    		//connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	              
	            
	            
	            boolean flag=false;
	    	
	         // Create Excel workbook and sheet
	            Workbook workbook = new XSSFWorkbook(); 
	            Sheet sheet = workbook.createSheet("MIS Payments");

	            // Create header row
	            Row headerRow = sheet.createRow(0);
	            headerRow.createCell(0).setCellValue("EMPCODE");
	            headerRow.createCell(1).setCellValue("EMPLOYEENAME");            
	            headerRow.createCell(2).setCellValue("ACC NUMBER");
	            headerRow.createCell(3).setCellValue("AMOUNT");
	           

	            // Add some sample data rows
	            int rowIndex = 1,amount=0;
	        	for(int i=0;i<jsonArrayData.length();i++) {
					flag=true;
	    			JSONObject jobj = jsonArrayData.getJSONObject(i);
	    			amount=amount+jobj.getInt("amount");
					Row row = sheet.createRow(rowIndex++);
					row.createCell(0).setCellValue(jobj.getString("Emp").split("-")[0]);
					row.createCell(1).setCellValue(jobj.getString("Emp").split("-")[1]);
					row.createCell(2).setCellValue(jobj.getString("accNo"));
					row.createCell(3).setCellValue(jobj.getInt("amount"));
	    			
	    		}
	            if(!flag){
	            	Row row = sheet.createRow(rowIndex++);
	            	 row.createCell(0).setCellValue("No Data"); 
	                 row.createCell(1).setCellValue("No Data");
	                 row.createCell(2).setCellValue("No Data");
	                 row.createCell(3).setCellValue("No Data");
	              
	             }

	            // Set response headers to trigger download
	            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	            response.setHeader("Content-Disposition", "attachment; filename=MISPayments.xlsx");

	            // Write workbook to response output stream
	            
	          try( OutputStream outStream = response.getOutputStream() ){
	                workbook.write(outStream);
	                outStream.flush();
	          }
	          finally {
				
	        	  workbook.close();
			}
	                
	                
	                return;
	    	}
			response.getWriter().write(jsonObject.toString());
	}
		catch(Exception e){
			e.printStackTrace();
			if(connection!=null){
				try {
					connection.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}
		}
		//response.setContentType("application/json");
		
}

}
