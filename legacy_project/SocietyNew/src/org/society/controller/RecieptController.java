package org.society.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Collection;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.society.dto.ReceiptDto;
import org.society.util.DataBaseConnectionForNewDB;



@WebServlet("/RecieptController")
public class RecieptController extends  HttpServlet  {

	
	protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException {
		Connection connection = null;
		String incomingReq=request.getParameter("req");
		JSONObject jsonObject = null;
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
	
		String userID = (String) session.getAttribute("EMPLOYEECODE");
		try {
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			if(incomingReq.equals("getReferenceNumber")){
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String memcode = request.getParameter("memcode");
				String purpose = request.getParameter("purpose");
				String sqlQuery ="{CALL speccs.SP_getReferenceDetails(?,?)}";
				
				CallableStatement cs1 = connection.prepareCall(sqlQuery);
				cs1.setString(1, memcode);
				cs1.setString(2, purpose);
				ResultSet executeQuery = cs1.executeQuery();
				JSONArray array = new JSONArray();
				
				while(executeQuery.next()){
					jsonObject = new JSONObject();
					jsonObject.put("refNum", executeQuery.getString("refNum") + "-"+executeQuery.getString("remAmount"));
				

					array.put(jsonObject);
				}
				jsonObject = new JSONObject();
				jsonObject.put("ReferenceDetails", array);
				jsonObject.put("ERROR", "NO");
			}
	
			
			if(incomingReq.equalsIgnoreCase("SaveReciept")) {
				
				String MemAccNO=request.getParameter("MemAccNO");           
				String ReceiptDate=request.getParameter("ReceiptDate");     
				ReceiptDate = ReceiptDate.split("/")[1]+"/"+ReceiptDate.split("/")[0]+"/"+ReceiptDate.split("/")[2];
				String ReferenceNumber=request.getParameter("referenceNumber");
				String ReceiptMonth = request.getParameter("recieptMonth");
				String ReceiptNo=request.getParameter("ReceiptNo"); 
				//System.out.println("receipt no "+ReceiptNo);
				String PurposeCode=request.getParameter("PurposeCode");     
				double amount = Double.parseDouble(request.getParameter("Amount"));   
				String ModeOfPayment=request.getParameter("ModeOfPayment"); 
			    String Option = request.getParameter("option");
			    String Remarks = request.getParameter("Remarks");
			    String ipaddress=request.getRemoteHost();
				
				
				if(Option.equals("UPDATE"))
				{
					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String sqlQuery = "{call speccs.SP_ReceiptsUpdate(?,?,?,?,?,?,?,?,?,?,?,?)}";
					CallableStatement cStatement = connection.prepareCall(sqlQuery);
					cStatement.setString(1, Option);
					cStatement.setString(2, MemAccNO);
					cStatement.setString(3, ReceiptDate);
					cStatement.setString(4, PurposeCode);
					cStatement.setDouble(5, amount);
					cStatement.setString(6, ModeOfPayment);
					cStatement.setString(7, ReferenceNumber);
					cStatement.setString(8, userId);
					cStatement.setString(9, ReceiptMonth);
					cStatement.setString(10, ipaddress);
					cStatement.setString(11, Remarks);
					cStatement.setString(12, ReceiptNo);
					 cStatement.executeUpdate();
					
			     	jsonObject = new JSONObject();
			     	jsonObject.put("success", "y");
				}
				else
				{
				String userId = (String) session.getAttribute("EMPLOYEECODE");
			    
			    
			    
				String sqlQuery = "{call speccs.SP_Receipts(?,?,?,?,?,?,?,?,?,?,?,?)}";
				CallableStatement cStatement = connection.prepareCall(sqlQuery);
				cStatement.setString(1, Option);
				cStatement.setString(2, MemAccNO);
				cStatement.setString(3, ReceiptDate);
				cStatement.setString(4, PurposeCode);
				cStatement.setDouble(5, amount);
				cStatement.setString(6, ModeOfPayment);
				cStatement.setString(7, ReferenceNumber);
				cStatement.setString(8, userId);
				cStatement.setString(9, ReceiptMonth);
				cStatement.setString(10, ipaddress);
				cStatement.setString(11, Remarks);
				cStatement.registerOutParameter(12, Types.VARCHAR);
				 cStatement.executeUpdate();
				String RecieptNo=cStatement.getString(12);
				//System.out.println(ReceiptNo+" no");
				
				jsonObject = new JSONObject();
				jsonObject.put("ReceiptNumber", RecieptNo);
				jsonObject.put("SUCCESS", "Y");
				
			}	
			}
	if(incomingReq.equalsIgnoreCase("deposittypes")) {
				
				String purposecode=request.getParameter("purposecode");
			
				String sqlQuery ="exec speccs.SP_ReceiptView ?,?,?,?";
			
				CallableStatement cs1 = connection.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
				

				cs1.setString(1,"DEPOSITDETAILS");//
				cs1.setString(2,purposecode);//SHAREMP
				cs1.setString(3,"");//New
				cs1.setString(4, "");//""
				
				ResultSet rsMembersDetails = cs1.executeQuery();
				
				String deposittypecode;
				String month="";
				int openingbal=0;
				int closingbal=0;
				JSONArray array1= new JSONArray();
				while(rsMembersDetails.next()) {
					
					jsonObject = new JSONObject();
					deposittypecode=rsMembersDetails.getString("DepositTypeCode").trim();
					month=rsMembersDetails.getString("Month").trim();
					openingbal=rsMembersDetails.getInt("OpeningBalance");
					closingbal=rsMembersDetails.getInt("ClosingBalance");
				
					
					jsonObject.put("deposittypecode", deposittypecode);
					jsonObject.put("month", month);
					jsonObject.put("openingbal", openingbal);
					jsonObject.put("closingbal", closingbal);
					array1.put(jsonObject);
				}
				jsonObject = new JSONObject();
				
				
				jsonObject.put("depositdetails", array1);

			
				
				}
			
			if (incomingReq.equals("Genpdfform")) {

				String MemAccNo = request.getParameter("MemAccNO");
				String PurposeCodee = request.getParameter("PurposeCode");
				String ReceiptNO = request.getParameter("ReceiptNo");
				ServletContext ctx=getServletContext();
				 String header=ctx.getInitParameter("HEADER");
				 String number=ctx.getInitParameter("NUMBERS");
				 
				ThriftLedgerpdf.getPDF(MemAccNo,PurposeCodee,ReceiptNO,header,number);
				String fileName = "ThriftLedgerpdf.pdf";
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

			}
			if (incomingReq.equals("MemGenpdfform")) {
				
				String MemAccNo = request.getParameter("MemAccNO");

				ServletContext ctx=getServletContext();
				 String header=ctx.getInitParameter("HEADER");
				 String number=ctx.getInitParameter("NUMBERS");
				MemberDetailspdf.getPDF(MemAccNo,"",header,number);
				String fileName = "MemberDetailspdf.pdf";
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

			}
			
	if (incomingReq.equals("MemGenpdfReceiptLedger")) {
				
				String MemAccNo = request.getParameter("accNo");
				String receiptno = request.getParameter("receiptno");
				
				ServletContext ctx=getServletContext();
				 String header=ctx.getInitParameter("HEADER");
				 String number=ctx.getInitParameter("NUMBERS");
				 ReceiptsLedgerpdf.getPDF(MemAccNo,receiptno,header,number);
				String fileName = "ReceiptLedger.pdf";
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

			}
	if (incomingReq.equals("regreport")) {
		
		String recfromdate = request.getParameter("receiptfromdate");
		String rectodate = request.getParameter("receipttodate");
		String purCode = request.getParameter("purCode");
		System.out.println(purCode);
		ServletContext ctx=getServletContext();
		 String header=ctx.getInitParameter("HEADER");
		 String number=ctx.getInitParameter("NUMBERS");
		 Receiptregistrationpdf.getPDF(purCode,recfromdate,rectodate,header,number);
		String fileName = "ReceiptRegistration.pdf";
		response.setContentType("application/pdf");

		File file1 = new File(fileName);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setContentLength((int) file1.length());
		FileInputStream fis = new FileInputStream(file1);
		out.flush();
		int temp;

		while ((temp = fis.read()) != -1) {
			out.write(temp);
			out.flush();

		}

		out.close();
		fis.close();
		return;

	}
	
if (incomingReq.equals("generalLedgerReoprt")) {
		
		String recfromdate = request.getParameter("receiptfromdate");
		String rectodate = request.getParameter("receipttodate");
		String purCode = request.getParameter("purCode");
		
		ServletContext ctx=getServletContext();
		 String header=ctx.getInitParameter("HEADER");
		 String number=ctx.getInitParameter("NUMBERS");
		 GeneralLedgerpdf.getPDF(purCode,recfromdate,rectodate,header,number);
		String fileName = "GeneralLedger.pdf";
		response.setContentType("application/pdf");

		File file1 = new File(fileName);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setContentLength((int) file1.length());
		FileInputStream fis = new FileInputStream(file1);
		out.flush();
		int temp;

		while ((temp = fis.read()) != -1) {
			out.write(temp);
			out.flush();

		}

		out.close();
		fis.close();
		return;

	}

	
			 if(incomingReq.equalsIgnoreCase("rejectmember")){
					
					try{
						
					String accNo = request.getParameter("accNo").trim();
					String emplcode = request.getParameter("emplcode");
					String type = request.getParameter("type").trim();
					String Remarks = request.getParameter("Remarks").trim();
					String ipaddress=request.getRemoteHost();
			        
					String sqlQuery1 ="exec speccs.SP_ReceiptView ?,?,?,?,?,?";
					
					CallableStatement cs3 = connection.prepareCall(sqlQuery1,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
					

					cs3.setString(1,type );
					cs3.setString(2,accNo);
					cs3.setString(3,userID);
					cs3.setString(4,emplcode);
					cs3.setString(5,Remarks);
					cs3.setString(6,ipaddress);
					ResultSet rs=cs3.executeQuery();
				
					jsonObject = new JSONObject();
					jsonObject.put("success", "y");
					
					}catch(Exception e){
						e.printStackTrace();
						
					}
				  }
			 if(incomingReq.equals("getRecieptInfo")){
				 
					String receiptno = null;
					String memAccno = null;
					String purposecode=null;
					receiptno = request.getParameter("receiptno");
					 memAccno = request.getParameter("memAccno");
					 purposecode=request.getParameter("purposecode");
					 String Month=null;
					 try {
						 Statement statement = connection.createStatement();
							

	String sqlQuery=" speccs.SP_RecieptProcess 'RECEIPTINFO','','"+purposecode+"','','','"+receiptno+"',''";	
	
											ResultSet rsReceiptDetails = statement.executeQuery(sqlQuery);
											
											JSONArray array = new JSONArray();
											if(rsReceiptDetails.next()){
												jsonObject = new JSONObject();
												String MemAccNo=rsReceiptDetails.getString("MemAccNO");
												String Receiptno=rsReceiptDetails.getString("ReceiptNo");
												String Remarks=rsReceiptDetails.getString("Remarks");
												String ModeOfPay=rsReceiptDetails.getString("ModeOfPayment");
												String ReceiptDatee=rsReceiptDetails.getString("ReceiptDate");
												String PurposeCodee=rsReceiptDetails.getString("PurposeCode");
												String RefNo=rsReceiptDetails.getString("RefNo");
												float Amount=rsReceiptDetails.getFloat("Amount");
												if(PurposeCodee.equals("D08") ||PurposeCodee.equals("M03") || PurposeCodee.equals("D20") ){
													Month=rsReceiptDetails.getString("Month");
												}else{
													Month="";
												}
											
												
												if(MemAccNo==null) MemAccNo="";
												if(Receiptno==null) Receiptno="";
												if(Remarks==null) Remarks="";
												if(ModeOfPay==null) ModeOfPay="";
												if(ReceiptDatee==null) ReceiptDatee="";
												else ReceiptDatee=new SimpleDateFormat("dd/MM/yyyy").format(rsReceiptDetails.getDate("ReceiptDate"));
												//if(Month==null) Month="";
												//else Month=new SimpleDateFormat("MM/yyyy").format(rsReceiptDetails.getDate("Month"));
										
										
											
												jsonObject.put("MemAccNo", MemAccNo);
												jsonObject.put("ReceiptNo", Receiptno);
												jsonObject.put("Remarks", Remarks);
												jsonObject.put("ModeOfPayment", ModeOfPay);
												jsonObject.put("ReceiptDate", ReceiptDatee);
												jsonObject.put("PurposeCode", PurposeCodee);
												jsonObject.put("RefNo", RefNo);
												jsonObject.put("Amount", Amount);
												jsonObject.put("Month", Month);
												array.put(jsonObject);
											 }
											jsonObject = new JSONObject();
											jsonObject.put("ReceiptDetails", array);
					} catch (Exception e) {
						e.printStackTrace();
					}
					 
				}
		    
				 if(incomingReq.equalsIgnoreCase("activemember")){
						try{
					
						String accNo = request.getParameter("accNo").trim();
						String emplcode = request.getParameter("emplcode");
						String type = request.getParameter("type").trim();
						String Remarks = request.getParameter("Remarks").trim();
						String ipaddress=request.getRemoteHost();
			
						  
						
						
						String sqlQuery1 ="exec speccs.SP_ReceiptView ?,?,?,?,?,?";
						
						CallableStatement cs2 = connection.prepareCall(sqlQuery1,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
						

						cs2.setString(1,"APPROVE" );
						cs2.setString(2,accNo);
						cs2.setString(3,userID);
						cs2.setString(4, emplcode);
						cs2.setString(5, Remarks);
						cs2.setString(6, ipaddress);
						System.out.println(type+" -- "+Remarks);
						//cs2.executeUpdate();
						int count=cs2.executeUpdate();
						if(count>0) {
							jsonObject = new JSONObject();
							jsonObject.put("success", "y");
						}
						else {
							jsonObject = new JSONObject();
							jsonObject.put("success", "N");
						}
						
				
						}catch(Exception e){
							e.printStackTrace();
							
						}
					  }
			
			
			
		} catch (Exception e) {
			// TODO: handle exception
			jsonObject = new JSONObject();
			try {
				jsonObject.put("ERROR", e.getMessage());
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		finally{
			if(connection != null){
				try {
					connection.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		response.getWriter().write(jsonObject.toString());
		
	}
}
	
