package org.society.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

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
import org.society.util.DataBaseConnectionForNewDB;



@WebServlet("/PaymentController")
public class PaymentController extends  HttpServlet  {

	
	protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException {
		Connection connection = null;
		String incomingReq=request.getParameter("req");
		JSONObject jsonObject = null;
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		
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
					jsonObject.put("refNum", executeQuery.getString("refNum"));
			

					array.put(jsonObject);
				}
				jsonObject = new JSONObject();
				jsonObject.put("ReferenceDetails", array);
				jsonObject.put("ERROR", "NO");
				
			}
			if (incomingReq.equals("paymentregreport")) {
				
				String paymentfromdate = request.getParameter("paymentfromdate");
				String paymenttodate = request.getParameter("paymenttodate");
				String purCode = request.getParameter("purCode");
				
				ServletContext ctx=getServletContext();
				 String header=ctx.getInitParameter("HEADER");
				 String number=ctx.getInitParameter("NUMBERS");
				 Paymentregistrationpdf.getPDF(purCode,paymentfromdate,paymenttodate,header,number);
				String fileName = "PaymentRegistration.pdf";
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
	if (incomingReq.equals("cashregreport")) {
				
				String cashfromdate = request.getParameter("cashfromdate");
				String cashtodate = request.getParameter("cashtodate");
				String purCode = request.getParameter("purCode").trim();
				
				ServletContext ctx=getServletContext();
				 String header=ctx.getInitParameter("HEADER");
				 String number=ctx.getInitParameter("NUMBERS");
				 Cashbookregistrationpdf.getPDF(cashfromdate,cashtodate,header,number);
				String fileName = "CashBookRegistration.pdf";
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
			if(incomingReq.equalsIgnoreCase("SavePayment")) {
			
				
				String MemAccNO=request.getParameter("MemAccNO");           
				String ReceiptDate=request.getParameter("ReceiptDate");     
				ReceiptDate = ReceiptDate.split("/")[1]+"/"+ReceiptDate.split("/")[0]+"/"+ReceiptDate.split("/")[2];
				String PurposeCode=request.getParameter("PurposeCode");    
				double amount = Double.parseDouble(request.getParameter("Amount"));    
				String ModeOfPayment=request.getParameter("ModeOfPayment"); 
			    String Option = request.getParameter("option");
			    String referenceNumber = request.getParameter("referenceNumber");
			
				String userId = (String) session.getAttribute("EMPLOYEECODE");		    
			    
				String sqlQuery = "{call speccs.SP_Payments(?,?,?,?,?,?,?,?,?,?)}";
				CallableStatement cStatement = connection.prepareCall(sqlQuery);
				cStatement.setString(1, Option);
				cStatement.setString(2, MemAccNO);
				cStatement.setString(3, ReceiptDate);
				cStatement.setString(4, PurposeCode);
				cStatement.setDouble(5, amount);
				cStatement.setString(6, ModeOfPayment);
				cStatement.setString(7, referenceNumber);
				cStatement.setString(8, userId);
				cStatement.setString(9, "");
				cStatement.registerOutParameter(10, Types.VARCHAR);
				 cStatement.executeUpdate();
				String RecieptNo=cStatement.getString(10);
				jsonObject = new JSONObject();
				jsonObject.put("ReceiptNumber", RecieptNo);
				jsonObject.put("ERROR", "NO");
				
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
