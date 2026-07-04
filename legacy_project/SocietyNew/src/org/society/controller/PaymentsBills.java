package org.society.controller;


import java.io.IOException;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.LinkedList;

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


@WebServlet("/PaymentsBills")
public class PaymentsBills extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String incomingRequest = request.getParameter("req");
	
		Connection connection = null;

	
		HttpSession session = request.getSession();
		String sqlQuery = "";
		JSONObject jsonObject = null;
		CallableStatement cStatement=null;
		try {
			if(incomingRequest.equalsIgnoreCase("saveasst")){
				try{
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
		
	
				String payvoucherdate = request.getParameter("payvoucherdate");
				String modeofpay = request.getParameter("modeofpay");
				String accountnum = request.getParameter("accountnum");
				String Chequeno = request.getParameter("Chequeno");
				String chequeDate = request.getParameter("chequeDate");
				String remarks = request.getParameter("remarks");
				String option = request.getParameter("option");
				String selecteddata = request.getParameter("griddata");
                String userId = (String) session.getAttribute("EMPLOYEECODE");
				String ipaddress=request.getRemoteHost(); 
				float totalamount = 0;
				String checkboxdata[]=selecteddata.split("&");
				for(int i=0;i<checkboxdata.length;i++){
					String data=checkboxdata[i];
					String spilitdata[]=data.split("-");
					String amount=spilitdata[1];
					totalamount=totalamount+Float.parseFloat(amount);
				}
			
				String Query = "{call speccs.SP_Paymentsbills(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
				 cStatement = connection.prepareCall(Query);
				cStatement.setString(1, option);
				cStatement.setString(2, "");
				cStatement.setString(3, "");
				cStatement.setString(4, payvoucherdate);
				cStatement.setFloat(5, totalamount);
				cStatement.setString(6, modeofpay);
				cStatement.setString(7, accountnum);
				cStatement.setString(8, Chequeno);
				cStatement.setString(9, chequeDate);
				cStatement.setString(10, "");
				cStatement.setString(11, remarks);
				cStatement.setString(12, userId);
				cStatement.setString(13, ipaddress);
				cStatement.registerOutParameter(14, Types.VARCHAR);
				cStatement.executeUpdate();
				String VoucherNoNew = cStatement.getString(14);
			
				for(int i=0;i<checkboxdata.length;i++){
					String data=checkboxdata[i];
					String spilitdata[]=data.split("-");
					String billno=spilitdata[0];
					
					   sqlQuery = "speccs.SP_Paymentsbills 'BILLSUPDATE','"+billno+"','"+VoucherNoNew+"','',0,'','','','','','"+remarks+"','"+userId+"','',''";
						 PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
							ps3.executeUpdate();
				}
                 cStatement.close();
                 if(connection!=null){
     				connection.close();
     				}
				jsonObject = new JSONObject();
				jsonObject.put("success", "y");
				jsonObject.put("NewVoucherNo", VoucherNoNew);
				response.getWriter().write(jsonObject.toString());
				
				}catch(Exception e){
					e.printStackTrace();
					if(connection!=null){
						connection.close();
						}
				
				}
					
				}

			if(incomingRequest.equalsIgnoreCase("saveoffc")){
				try{
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
				String payvoucombo = request.getParameter("payvoucombo");
				String remarks = request.getParameter("remarks");
				String option = request.getParameter("option");
                String userId = (String) session.getAttribute("EMPLOYEECODE");
				String ipaddress=request.getRemoteHost(); 
			sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','"+payvoucombo+"','',0,'','','','','','"+remarks+"','"+userId+"','"+ipaddress+"',''";
			PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
			ps3.executeUpdate();
				
                 
				jsonObject = new JSONObject();
				jsonObject.put("success", "y");
				response.getWriter().write(jsonObject.toString());
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
			
			
			
			
			
	if(incomingRequest.equalsIgnoreCase("gettingpaymentdata")){
		
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
		String option = request.getParameter("option");
		sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','','',0,'','','','','','','','',''";
		
		PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
		ResultSet res = ps2.executeQuery();
		
		JSONArray array2 = new JSONArray();
		while (res.next()) {
			jsonObject = new JSONObject();
			String BillNo=res.getString("BillNo").trim();
			String BillingDate=res.getString("BillingDate").trim();
			String PurposeCode=res.getString("PurposeCode");
			float Amount=res.getFloat("Amount");
			String ModeOfPayment=res.getString("ModeOfPayment");
			String Status=res.getString("Status");
			String RefNo=res.getString("RefNo");
			String MemEmpCode=res.getString("MemEmpCode");
			String Member=res.getString("MemAccNo").trim()+"-"+res.getString("MemName");
					
			jsonObject.put("billnum", BillNo.trim());
			jsonObject.put("member", Member.trim());
			jsonObject.put("billdate", BillingDate.trim());
			jsonObject.put("purpose", PurposeCode.trim());
			jsonObject.put("amount", Amount);
			jsonObject.put("ModeOfPayment", ModeOfPayment.trim());
			jsonObject.put("Status", Status.trim());
			jsonObject.put("RefNo", RefNo.trim());
			jsonObject.put("MemEmpCode", MemEmpCode.trim());
			array2.put(jsonObject);	
		}
		jsonObject = new JSONObject();
		jsonObject.put("BILLDATA", array2);
		response.getWriter().write(jsonObject.toString());
		
		if(connection!=null){
			connection.close();
		}
			}	
	
	if(incomingRequest.equalsIgnoreCase("payvouchersdata")){
		
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
		String option = request.getParameter("option");
		String payvouchernum = request.getParameter("payvouchernum");
		
		sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','"+payvouchernum+"','',0,'','','','','','','','',''";
		
		PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
		ResultSet res = ps2.executeQuery();
		
		JSONArray array2 = new JSONArray();
		while (res.next()) {
			jsonObject = new JSONObject();
			
		
			String VoucherDate[]=res.getString("VoucherDate").split("/");

			String ModeOfPayment=res.getString("ModeOfPayment").trim();
			String AccountNo=res.getString("AccountNo");
			String ChequeNo=res.getString("ChequeNo");
			String ChequeDate[]=res.getString("ChequeDate").split("/");
			String Remarks=res.getString("Remarks");
					
			jsonObject.put("VoucherDate",VoucherDate[1]+"/"+VoucherDate[0]+"/"+VoucherDate[2] );
			jsonObject.put("ModeOfPayment", ModeOfPayment.trim());
			jsonObject.put("AccountNo", AccountNo.trim());
			jsonObject.put("ChequeNo", ChequeNo.trim());
			jsonObject.put("ChequeDate", ChequeDate[1]+"/"+ChequeDate[0]+"/"+ChequeDate[2]);
			jsonObject.put("Remarks", Remarks.trim());
			array2.put(jsonObject);	
		}
		jsonObject = new JSONObject();
		jsonObject.put("VOUCHERDATA", array2);
		jsonObject.put("success", "y");
		response.getWriter().write(jsonObject.toString());
		
		if(connection!=null){
			connection.close();
		}
			}
	
	if(incomingRequest.equalsIgnoreCase("billdata")){
		
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
		String option = request.getParameter("option");
		String bill = request.getParameter("bill");
		
		sqlQuery = "speccs.SP_Paymentsbills '"+option+"','"+bill+"','','',0,'','','','','','','','',''";
		System.out.println(sqlQuery);
		PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
		ResultSet res = ps2.executeQuery();
		
		JSONArray array2 = new JSONArray();
		while (res.next()) {
			jsonObject = new JSONObject();
			
			String MemEmpCode;
			if(res.getString("MemEmpCode")==null){
				MemEmpCode="No Data";
			}else{
				MemEmpCode=res.getString("MemEmpCode");
			}
			String Name;
			if(res.getString("MemAccNo").trim()==null || res.getString("MemName").trim()==null){
				Name="No data";
			}else{
				
				Name=res.getString("MemAccNo")+"-"+res.getString("MemName");
			}
			String BillingDate=res.getString("BillingDate");
		     int Amount=res.getInt("Amount");
		     String depositNo=res.getString("RefNo");
			String Remarks=res.getString("Remarks");
			String loanNo;
			if(res.getString("AdjustRefNo")==null){
				loanNo="-";
			}else{
				loanNo=res.getString("AdjustRefNo");
			}
					
			jsonObject.put("MemEmpCode",MemEmpCode);
			jsonObject.put("Name", Name.trim());
			jsonObject.put("BillingDate", BillingDate.trim());
			jsonObject.put("Amount", Amount);
			jsonObject.put("depositNo",depositNo);
			jsonObject.put("LoanNo", loanNo);
			jsonObject.put("Remarks", Remarks.trim());
			array2.put(jsonObject);	
		}
		jsonObject = new JSONObject();
		jsonObject.put("billsDATA", array2);
		response.getWriter().write(jsonObject.toString());
		
		if(connection!=null){
			connection.close();
		}
			}
	if(incomingRequest.equalsIgnoreCase("gettingpaymentdataoffc")){
		
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
	
		String option = request.getParameter("option");
		
		
		sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','','',0,'','','','','','','','',''";
		
		PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
		ResultSet res = ps2.executeQuery();
		
		JSONArray array2 = new JSONArray();
		while (res.next()) {
			jsonObject = new JSONObject();
			String PayVoucherNo=res.getString("PayVoucherNo").trim();
			String VoucherDate=res.getString("VoucherDate").trim();
			float Amount=res.getFloat("Amount");
			String ModeOfPayment=res.getString("ModeOfPayment");
	
					
			jsonObject.put("pvn", PayVoucherNo.trim());
			jsonObject.put("pvd", VoucherDate.trim());
			jsonObject.put("amount", Amount);
			jsonObject.put("mop", ModeOfPayment.trim());
			array2.put(jsonObject);	
		}
		jsonObject = new JSONObject();
		jsonObject.put("PAYVOUCHERDATA", array2);
		response.getWriter().write(jsonObject.toString());
		
		if(connection!=null){
			connection.close();
		}
			}
	if(incomingRequest.equalsIgnoreCase("gettingvoucherdata")){
		
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
	
		String option = request.getParameter("option");
		String payvouchernum = request.getParameter("payvouchernum");
		
		sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','"+payvouchernum+"','',0,'','','','','','','','',''";
		
		PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
		ResultSet res = ps2.executeQuery();
		
		JSONArray array2 = new JSONArray();
		while (res.next()) {
			jsonObject = new JSONObject();
			String BillNo=res.getString("BillNo").trim();
			String BillingDate=res.getString("BillingDate").trim();
			String PurposeCode=res.getString("PurposeCode");
			float Amount=res.getFloat("Amount");
			String ModeOfPayment=res.getString("ModeOfPayment");
			String Status=res.getString("Status");
			String RefNo=res.getString("RefNo");
			String MemEmpCode=res.getString("MemEmpCode");
			String Member=res.getString("MemAccNo").trim()+"-"+res.getString("MemName");
					
			jsonObject.put("billnum", BillNo.trim());
			jsonObject.put("member", Member.trim());
			jsonObject.put("billdate", BillingDate.trim());
			jsonObject.put("purpose", PurposeCode.trim());
			jsonObject.put("amount", Amount);
			jsonObject.put("ModeOfPayment", ModeOfPayment.trim());
			jsonObject.put("Status", Status.trim());
			jsonObject.put("RefNo", RefNo.trim());
			jsonObject.put("MemEmpCode", MemEmpCode.trim());
			array2.put(jsonObject);	
		}
		jsonObject = new JSONObject();
		jsonObject.put("BILLVOUCHERDATA", array2);
		response.getWriter().write(jsonObject.toString());
		
		if(connection!=null){
			connection.close();
		}
			}
	
	if(incomingRequest.equalsIgnoreCase("jsaveasst")){
		try{
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	


		String jvoucherDate = request.getParameter("jvoucherDate");
		String bills = request.getParameter("bills");
		String remarks = request.getParameter("remarks");
		float amount=Float.parseFloat(request.getParameter("amount"));
		String option = request.getParameter("option");
        String userId = (String) session.getAttribute("EMPLOYEECODE");
		String ipaddress=request.getRemoteHost(); 

		String Query = "{call speccs.SP_Paymentsbills(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
		 cStatement = connection.prepareCall(Query);
		cStatement.setString(1, option);
		cStatement.setString(2, bills);
		cStatement.setString(3, "");
		cStatement.setString(4, jvoucherDate);
		cStatement.setFloat(5, amount);
		cStatement.setString(6, "");
		cStatement.setString(7, "");
		cStatement.setString(8, "");
		cStatement.setString(9, "");
		cStatement.setString(10, "");
		cStatement.setString(11, remarks);
		cStatement.setString(12, userId);
		cStatement.setString(13, ipaddress);
		cStatement.registerOutParameter(14, Types.VARCHAR);
		cStatement.executeUpdate();
		String JVoucherNoNew = cStatement.getString(14);
	
         cStatement.close();
         if(connection!=null){
				connection.close();
				}
		jsonObject = new JSONObject();
		jsonObject.put("success", "y");
		jsonObject.put("JNewVoucherNo", JVoucherNoNew);
		response.getWriter().write(jsonObject.toString());
		
		}catch(Exception e){
			e.printStackTrace();
			if(connection!=null){
				connection.close();
				}
		}
		}
	if(incomingRequest.equalsIgnoreCase("jvouchersdata")){
		
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
	
		String option = request.getParameter("option");
		String jvouchernum = request.getParameter("jvouchernum");
		
		sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','"+jvouchernum+"','',0,'','','','','','','','',''";
		System.out.println(sqlQuery);
		PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
		ResultSet res = ps2.executeQuery();
	
		JSONArray array2 = new JSONArray();
		while (res.next()) {
			jsonObject = new JSONObject();
			String JVoucherNo=res.getString("JVoucherNo").trim();
			String VoucherDate[]=res.getString("VoucherDate").split("/");
			String SourceRef=res.getString("SourceRef");
			float Amount=res.getFloat("Amount");
			String DestinationRef=res.getString("DestinationRef");
			String Remarks=res.getString("Remarks");
			
			jsonObject.put("JVoucherNo", JVoucherNo.trim());
			jsonObject.put("VoucherDate", VoucherDate[1]+"/"+VoucherDate[0]+"/"+VoucherDate[2].trim());
			jsonObject.put("SourceRef", SourceRef.trim());
			jsonObject.put("amount", Amount);
			jsonObject.put("DestinationRef", DestinationRef.trim());
			jsonObject.put("Remarks", Remarks.trim());
			array2.put(jsonObject);	
		}
		jsonObject = new JSONObject();
		jsonObject.put("JOURNALVOUCHERDATA", array2);
		response.getWriter().write(jsonObject.toString());
		
		if(connection!=null){
			connection.close();
		}
			}
	
	if(incomingRequest.equalsIgnoreCase("journalsaveoffc")){
		try{
		connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
		String jvoucombo = request.getParameter("jvoucombo");
		String remarks = request.getParameter("remarks");
		String option = request.getParameter("option");
		
        String userId = (String) session.getAttribute("EMPLOYEECODE");
		String ipaddress=request.getRemoteHost(); 
		
	sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','"+jvoucombo+"','',0,'','','','','','"+remarks+"','"+userId+"','"+ipaddress+"',''";
	PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
	ps3.executeUpdate();
		
         
		jsonObject = new JSONObject();
		jsonObject.put("success", "y");
		response.getWriter().write(jsonObject.toString());
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
		
	}
		catch(SQLException | JSONException | InstantiationException | IllegalAccessException | ClassNotFoundException e){
			e.printStackTrace();
		}
}
}

