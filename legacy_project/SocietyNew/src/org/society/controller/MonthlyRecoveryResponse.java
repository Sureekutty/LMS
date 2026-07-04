package org.society.controller;


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.Scanner;

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


@WebServlet("/MonthlyRecoveryResponse")
public class MonthlyRecoveryResponse extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String incomingRequest = request.getParameter("req");
		
		
	
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		String sqlQuery = "";
		JSONObject jsonObject = null;
		String userId = (String) session.getAttribute("EMPLOYEECODE");
		try {
			

			if(incomingRequest.equalsIgnoreCase("txtxfile")){
				Connection connection = null;
				try{
					connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String fileUploadfile = request.getParameter("file").trim();
					//System.out.println(fileUploadfile);
					fileUploadfile=fileUploadfile.replace("\n", "");
					String monthproces=request.getParameter("monthproces").trim();
					String monthdate[]=monthproces.split("/");
					String month=monthdate[1];
					//month = (Integer.parseInt(month)<10)?"0"+month:month;
					int currmon=Integer.parseInt(month)+1;
					String Purpose=request.getParameter("Purpose").trim();
					String purpose1 = request.getParameter("purpose1").trim();
//					System.out.println("Purpose is "+Purpose); //o/p L24
					
//					sqlQuery = "EXEC speccs.SP_MonthlyProcess 'SalaryCode','"+Purpose+"','"+month+"/01/"+monthdate[2]+"','"+Empcode[0]+"',"+empamount+",'"+userId+"','',''";
					sqlQuery = "EXEC speccs.SP_MonthlyProcess 'Salarycode','"+Purpose+"','','',0,'','',''";
					PreparedStatement  ps2 = connection.prepareStatement(sqlQuery); 
			     	 ResultSet rs = ps2.executeQuery();
			     	 String salCode = "";
			     	 
			     	 while(rs.next()) {
			     		salCode = rs.getString("SalaryCode");
			     		if(salCode == null) {
			     			salCode="0";
			     		}		     		
			     		}
			     	
			     	if(purpose1.contains(salCode)) {
					String splitline[]=fileUploadfile.split("&&");
//					System.out.println(" splitline "+Arrays.toString(splitline));
//					JSONArray json = new JSONArray().put(splitline);
//					System.out.println(json.toString());
					 //System.out.println(Arrays.toString(splitline)+" length is "+splitline.length+" second value "+splitline[2]+" splitline[2]+ "+ splitline[3]);
					for(int i=2;i<splitline.length;i++) {
						//System.out.println(" inside loop "+splitline[i]);
		             String Empcode[]=splitline[i].split(":");
		             
		             String amount[]=splitline[i].split(":");
		             
						float empamount=Float.parseFloat(amount[1]);
						
						sqlQuery = "EXEC speccs.SP_MonthlyProcess 'TXTDATAUPDATE','"+Purpose+"','"+month+"/01/"+monthdate[2]+"','"+Empcode[0]+"',"+empamount+",'"+userId+"','',''";
						
						System.out.println("Purpose is  "+Purpose);
						System.out.println("date is  "+month+"/01/"+monthdate[2]);
						System.out.println("emp code is--  "+Empcode[0]+" code");
						System.out.println("amount is  "+empamount);
						PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
				     	 ps3.executeUpdate();
					}
					jsonObject = new JSONObject();
					jsonObject.put("success", "Y");
					response.getWriter().write(jsonObject.toString());
					}
			     	else {
			     		jsonObject = new JSONObject();
						jsonObject.put("success", "N");
						jsonObject.put("error", "sal code is not available");
						response.getWriter().write(jsonObject.toString());
			     	}
			     	
//					System.out.println("after json sended data");
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
			if(incomingRequest.equalsIgnoreCase("approve")) {
				Connection con = null;
				
				try {
				con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String monthproces = request.getParameter("monthproces").trim();
				String monthdate[]=monthproces.split("/");
				String month=monthdate[1];
				System.out.println("approve "+month);
				//month = (Integer.parseInt(month)<10)?"0"+month:month;
				//int currmon=month+1;
				
				String Purpose = request.getParameter("Purpose").trim();
	
				
				String JsonData = request.getParameter("gridData").trim();
				JSONArray jarr=new JSONArray(JsonData); 
				int count = 0 ;
				for(int i=0;i<jarr.length();i++) {
					JSONObject jobj=jarr.getJSONObject(i);
					//System.out.println(jobj.getString("MemAccNo")+"--"+jobj.getInt("amount")+" date "+month+"/01/"+monthdate[2]);

					sqlQuery = "EXEC speccs.SP_MonthlyProcess 'APPROVEMONTHLYRESP','"+Purpose+"','"+month+"/01/"+monthdate[2]+"','"+jobj.getString("MemAccNo")+"',"+jobj.getInt("recamount")+",'"+userId+"','',''";
					 PreparedStatement  ps3 = con.prepareStatement(sqlQuery); 
				     ps3.executeUpdate();
				   count++;
				   
				}
				System.out.println(Purpose);
				if(count == jarr.length()) {
					jsonObject = new JSONObject();
					jsonObject.put("SUCCESS", "Y");
					response.getWriter().write(jsonObject.toString());
				}else{
					jsonObject = new JSONObject();
					jsonObject.put("SUCCESS", "N");
					response.getWriter().write(jsonObject.toString());
				}
				 if(con!=null)
			     		con.close();
				}catch(Exception e){
					e.printStackTrace();
					 if(con!=null)
				     		con.close();				     				
				}
			}
	if(incomingRequest.equalsIgnoreCase("gettinggriddata")){
		Connection connection = null;
		try{
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
		
		String monthproces = request.getParameter("monthproces").trim();
		String monthdate[]=monthproces.split("/");
		String month=monthdate[1];
		//month = (Integer.parseInt(month)<10)?"0"+month:month;
		int currmon=Integer.parseInt(month)+1;
		System.out.println("grid "+month);
		String Purpose = request.getParameter("Purpose").trim();
	    sqlQuery = "EXEC speccs.SP_MonthlyProcess 'RESPGRIDDATA','"+Purpose+"','"+month+"/01/"+monthdate[2]+"','',0,'','',''";
        
        PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
    	ResultSet res = ps3.executeQuery();
		
		JSONArray array3 = new JSONArray();
		int flag=0;
		while (res.next()) {
			flag=1;
			jsonObject = new JSONObject();
			String MemAccNo=res.getString("Memcode").trim();
			String Emp=res.getString("Empcode").trim()+"-"+res.getString("MemName").trim();
			String Refid=res.getString("Refid").trim();
			String Paycode=res.getString("Purposecode");
			int Salcode=res.getInt("Salcode");
			float amount=res.getFloat("Recoveryamount");
			float recamount=res.getFloat("Recoveredamount");
			String status=res.getString("Status");
			
			jsonObject.put("MemAccNo", MemAccNo);
			jsonObject.put("Emp", Emp);
			jsonObject.put("Refid", Refid);
			jsonObject.put("Paycode", Paycode);
			jsonObject.put("Salcode", Salcode);
			jsonObject.put("amount", amount);
			jsonObject.put("recamount", recamount);
			jsonObject.put("status", status);
			array3.put(jsonObject);	
		}
		
		if(flag==0){
			jsonObject = new JSONObject();
			jsonObject.put("RECDETAILS", "N");
			response.getWriter().write(jsonObject.toString());
		}else{
			jsonObject = new JSONObject();
			jsonObject.put("RECDETAILS", array3);
			response.getWriter().write(jsonObject.toString());
		}
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
		catch(SQLException e){
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
}
}

