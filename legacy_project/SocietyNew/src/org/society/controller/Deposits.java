package org.society.controller;



import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import java.util.Map;

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
import org.society.service.GenericDetailsService;
import org.society.util.DataBaseConnectionForNewDB;



@SuppressWarnings("serial")
@WebServlet("/deposits")
public class Deposits extends HttpServlet {

	@SuppressWarnings("resource")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection connection = null;

		CallableStatement cs1 = null;

		String sqlQuery = "";
		JSONObject jsonObject = null;
		HttpSession session = request.getSession();
		PrintWriter out=response.getWriter();
		String userID = (String) session.getAttribute("EMPLOYEECODE");

		GenericDetailsService genericDetailsService = null;
		try {
	
			String incomingRequest = request.getParameter("req");
			
			if(incomingRequest.equalsIgnoreCase("getDepositsTypes")){
				genericDetailsService = new GenericDetailsService();
				String depositMode = "deposit";
				LinkedList<Map<String,String>> deposits = genericDetailsService.getDeposits(depositMode);
				jsonObject = new JSONObject();
				jsonObject.put("DEPOSITS", deposits);
				jsonObject.put("ERROR", "NO");
				response.getWriter().write(jsonObject.toString());
			}
			
			if(incomingRequest.equals("getRulesOfDeposits")){
				String deposit = request.getParameter("deposit");
				String ruleCode = "";
				genericDetailsService = new GenericDetailsService();
				Map<String, String> ruleDetails = null;
				jsonObject = new JSONObject();
				if(deposit.equals("FXD")){
					ruleCode = "121";
					ruleDetails = genericDetailsService.getRuleDetails(ruleCode);
					JSONArray array = new JSONArray();
					if(ruleDetails.size() > 0){
						array.put(ruleDetails);
					}
					jsonObject.put("MIN", array);
					array = new JSONArray();
					ruleCode = "122";
					ruleDetails = null;
					 ruleDetails = genericDetailsService.getRuleDetails(ruleCode);
					if(ruleDetails.size() > 0){
						array.put(ruleDetails);
					}
					jsonObject.put("MAX", array);
				}
				if(deposit.equals("MIS")){
//					MIS Fixed Duration
					ruleCode = "118";
					ruleDetails = genericDetailsService.getRuleDetails(ruleCode);
					JSONArray array = new JSONArray();
					if(ruleDetails.size() > 0){
						array.put(ruleDetails);
					}
					jsonObject.put("MINDURATION", array);
					array = new JSONArray();
//					 MIS Minimum Deposit Amount
					ruleCode = "119";
					ruleDetails = null;
					 ruleDetails = genericDetailsService.getRuleDetails(ruleCode);
					if(ruleDetails.size() > 0){
						array.put(ruleDetails);
					}
					jsonObject.put("MINAMT", array);
					array = new JSONArray();
					ruleCode = "120";
					ruleDetails = null;
					 ruleDetails = genericDetailsService.getRuleDetails(ruleCode);
					if(ruleDetails.size() > 0){
						array.put(ruleDetails);
					}
					jsonObject.put("MULTIPLE", array);
				}
				if(deposit.equalsIgnoreCase("RCD")){
					ruleCode = "123";
					ruleDetails = genericDetailsService.getRuleDetails(ruleCode);
					JSONArray array = new JSONArray();
					if(ruleDetails.size() > 0){
						array.put(ruleDetails);
					}
					jsonObject.put("MIN", array);
					array = new JSONArray();
					ruleCode = "124";
					ruleDetails = null;
					 ruleDetails = genericDetailsService.getRuleDetails(ruleCode);
					if(ruleDetails.size() > 0){
						array.put(ruleDetails);
					}
					jsonObject.put("MAX", array);
				}
				response.getWriter().write(jsonObject.toString());
			}
			if(incomingRequest.equalsIgnoreCase("checkInDeposits")){
				String deposit = request.getParameter("deposit");
				String empCode = request.getParameter("empCode");
				genericDetailsService =  new GenericDetailsService();
				LinkedList<Map<String,String>> depositDetails = genericDetailsService.getDepositDetails("individual",deposit, "SANCTION", null, empCode);

				jsonObject = new  JSONObject();
				jsonObject.put("DEPOSIT", depositDetails);
				response.getWriter().write(jsonObject.toString());
			}
			
			if(incomingRequest.equalsIgnoreCase("getInterestRate")){
				String deposit = request.getParameter("deposit");
				String duration = request.getParameter("duration");
				String date = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("date").trim()));
				
				genericDetailsService = new GenericDetailsService();
				float interestRates = genericDetailsService.getInterestRates(deposit,duration,date);
				//System.out.println(interestRates);
				jsonObject = new JSONObject();
				jsonObject.put("INTERESTRATE", interestRates);
				response.getWriter().write(jsonObject.toString());
				
			}
			
			
			
			if(incomingRequest.equalsIgnoreCase("saveDeposit")){
			try {
				connection  = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String memAccNo = request.getParameter("memAccNo");
				String deposit = request.getParameter("deposit");
				String depositNumber1 = request.getParameter("depositNumber");
				String maturityDate="";
				if(deposit.equals("FXD") || deposit.equals("RCD"))
					maturityDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("maturityDate")));
				else
					maturityDate="";
				Double maturityAmnt = Double.parseDouble(request.getParameter("maturityAmnt"));
				String nomineeRefNu = request.getParameter("nomineeRefNu");
				String arr[]=nomineeRefNu.split("-");
				nomineeRefNu =arr[0];
				int duration;
				String durationn;
			    durationn=request.getParameter("duration");
				if(durationn.equals("NA"))
					duration=0;
			    duration=Integer.parseInt(durationn);
				
				String depositDate=new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("depositDate")));
				Double amount = Double.parseDouble( request.getParameter("amount"));			   
				String remarks = request.getParameter("remarks");				
				String ipaddress=request.getRemoteHost();			
				//depositDate = depositDate.split("/")[1]+"/"+depositDate.split("/")[0]+"/"+depositDate.split("/")[2];				
				String option = request.getParameter("option");
				String nomrefnum=depositNumber1+"NR"+1;
				if(option.equals("UPDATE"))
				{
					Statement statement = connection.createStatement();
 
					sqlQuery="speccs.SP_DepositUpdates '"+option+"','"+memAccNo+"','"+deposit+"','"+depositDate+"',"+duration+","+amount+",'"+remarks+"','"+userID+"','"+depositNumber1+"','"+ipaddress+"'";
					statement.executeUpdate(sqlQuery);
										 
					sqlQuery="speccs.SP_NomineeRef '"+option+"','"+memAccNo+"','"+nomineeRefNu+"','','"+nomrefnum+"','"+depositNumber1+"','"+ipaddress+"','"+remarks+"','"+userID+"'"; 
					statement.executeUpdate(sqlQuery);
			   
			     	jsonObject = new JSONObject();
			     	jsonObject.put("success", "y");
			     	if(connection!=null){
			     		connection.close();
			     	}
			     	
				}
				else
				{
				sqlQuery = "{call speccs.SP_DepositsSave(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
			
				CallableStatement cStatement = connection.prepareCall(sqlQuery);
		

				cStatement.setString(1, deposit);
				cStatement.setString(2, memAccNo);
				cStatement.setString(3, deposit);
				cStatement.setString(4, deposit);
				cStatement.setString(5, depositDate);
				cStatement.setDouble(6, amount);
				cStatement.setInt(7, duration);
				cStatement.setString(8, remarks);
				cStatement.setString(9, maturityDate);
				cStatement.setString(10, null);
				cStatement.setDouble(11, maturityAmnt);
				cStatement.setInt(12, 0);
				cStatement.setString(13, null);
				cStatement.setString(14, depositDate.split("/")[1]);
				cStatement.setString(15, userID);
				cStatement.setString(16, ipaddress);
				cStatement.registerOutParameter(17, Types.VARCHAR);
				cStatement.executeUpdate();
				String depositNumber = cStatement.getString(17);
				
				
				jsonObject = new JSONObject();
				jsonObject.put("DEPOSITNUMBER", depositNumber);
				response.getWriter().write(jsonObject.toString());
				if(connection!=null){
		     		connection.close();
		     	}
				}
			}
			catch (Exception e) {
				e.printStackTrace();
				if(connection!=null){
		     		connection.close();
		     	}
			}
			}
               if(incomingRequest.equals("savenomineeref")){
            	   try {
				connection  = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String nomineeRefNu = request.getParameter("nomineeRefNu");
				String nomineeid[]=nomineeRefNu.split("-");
				String option = request.getParameter("option");
			
				String depositnumber = request.getParameter("depositnumber");
				
				String 	sqlQuery1 =	"{call speccs.SP_NomineeRef(?,?,?,?,?,?,?,?,?)}";
				
				CallableStatement cStatement1 = connection.prepareCall(sqlQuery1);
				cStatement1.setString(1, option);
				cStatement1.setString(2, "");
				cStatement1.setString(3, nomineeid[1]);
				cStatement1.setString(4, null);
				cStatement1.setString(5, depositnumber+"NR"+1);
				cStatement1.setString(6, depositnumber);
				cStatement1.setString(7, "");
				cStatement1.setString(8, "");
				cStatement1.setString(9, userID);
				cStatement1.executeUpdate();
				jsonObject = new JSONObject();
				jsonObject.put("success", "y");
				response.getWriter().write(jsonObject.toString());
				if(connection!=null){
		     		connection.close();
		     	}
            	}catch (Exception e) {
       				e.printStackTrace();
    				if(connection!=null){
    		     		connection.close();
    		     	}
    			}
				}
				
			
			if(incomingRequest.equals("loadNominees")){
				try{
				connection  = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String memCode = request.getParameter("memCode");
				String option = request.getParameter("option");
				String sqlQuery1 = "speccs.SP_Nominee '"+option+"','"+memCode+"','','','','','','','','','',''";
						
						
				ResultSet executeQuery = connection.createStatement().executeQuery(sqlQuery1);
				JSONArray  array = new JSONArray();
				while (executeQuery.next()) {
					jsonObject = new JSONObject();
					jsonObject.put("NomDetails", executeQuery.getString("Nominess"));
					array.put(jsonObject);
				}
				jsonObject = new JSONObject();
				jsonObject.put("DETAILS", array);
//				System.out.println(array);
				jsonObject.put("ERROR", "NO");
				response.getWriter().write(jsonObject.toString());
				if(connection!=null){
		     		connection.close();
		     	}
				}catch (Exception e) {
       				e.printStackTrace();
    				if(connection!=null){
    		     		connection.close();
    		     	}
    			}
			}
			
			
            if(incomingRequest.equalsIgnoreCase("rejectmember")){
				
				try{
					connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String accNo = request.getParameter("accNo").trim();
				String emplcode = request.getParameter("emplcode");
				String remarks = request.getParameter("remarks");
				String type = request.getParameter("type").trim();
		
				String ipaddress=request.getRemoteHost();
				String sqlQuery1 ="exec speccs.SP_DepositsView ?,?,?,?,?,?";
				
				CallableStatement cs3 = connection.prepareCall(sqlQuery1);
				

				cs3.setString(1,type );
				cs3.setString(2,accNo);
				cs3.setString(3,userID);
				cs3.setString(4, emplcode);
				cs3.setString(5, remarks);
				cs3.setString(6,ipaddress);
				
				cs3.execute();
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
			 if(incomingRequest.equalsIgnoreCase("activemember")){
					try{
					connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
					String accNo = request.getParameter("accNo").trim();
					String emplcode = request.getParameter("emplcode");
					String remarks = request.getParameter("remarks");
					String type = request.getParameter("type").trim();
					
					
					String ipaddress=request.getRemoteHost();
					
					String sqlQuery1 ="exec speccs.SP_DepositsView ?,?,?,?,?,?";
					
					CallableStatement cs2 = connection.prepareCall(sqlQuery1);
					

					cs2.setString(1,type );
					cs2.setString(2,accNo);
					cs2.setString(3,userID);
					cs2.setString(4, emplcode);
					cs2.setString(5,remarks);
					cs2.setString(6,ipaddress);
					
					cs2.execute();
					//ResultSet rs=cs2.executeQuery();
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
			
				if(incomingRequest.equals("getDepositInfo")){
					try{
					connection  = DataBaseConnectionForNewDB.getConnectionForSyBase();
					String	depositnum = request.getParameter("depositnum");
					String memAccno = request.getParameter("memAccno");
					Statement statement = connection.createStatement();
					
                   sqlQuery="speccs.SP_DepositUpdates 'GETINFO','"+memAccno+"','','',0,0,'','','"+depositnum+"','','',0,0,'','',''";

					ResultSet rsDepositDetails = statement.executeQuery(sqlQuery);
					
					JSONArray array = new JSONArray();
					if(rsDepositDetails.next()){
						jsonObject = new JSONObject();
						String MemAccNo=rsDepositDetails.getString("MemAccNo");
						String DepositNo=rsDepositDetails.getString("DepositNo");
						String DepositType=rsDepositDetails.getString("DepositType");
						String OpenDate=rsDepositDetails.getString("OpenDate");
						int Duration=rsDepositDetails.getInt("Duration");
						float IntRate=rsDepositDetails.getFloat("IntRate");
						float Subscription=rsDepositDetails.getFloat("Subscription");
						String Remarks=rsDepositDetails.getString("Remarks");
						String NomineeId=rsDepositDetails.getString("NomineeId");
						String maturityDate=rsDepositDetails.getString("MaturityDate");
						int maturityAmount=rsDepositDetails.getInt("MaturityAmount");
						
						if(MemAccNo==null) MemAccNo="";
						if(DepositNo==null) DepositNo="";
						if(DepositType==null) DepositType="";
						
						if(Remarks==null) Remarks="";
						if(NomineeId==null) NomineeId="";
					
						if(OpenDate==null) OpenDate="";
						else OpenDate=new SimpleDateFormat("dd/MM/yyyy").format(rsDepositDetails.getDate("OpenDate"));
				
				
					
						jsonObject.put("MemAccNo", MemAccNo);
						jsonObject.put("DepositNo", DepositNo);
						jsonObject.put("DepositType", DepositType);
						jsonObject.put("MemAccNo", MemAccNo);
						jsonObject.put("OpenDate", OpenDate);
						jsonObject.put("Duration", Duration);
						jsonObject.put("IntRate", IntRate);
						jsonObject.put("Subscription", Subscription);
						jsonObject.put("Remarks", Remarks);
						jsonObject.put("NomineeId", NomineeId);
						jsonObject.put("MaturityAmount", maturityAmount);
						jsonObject.put("MaturityDate", maturityDate);
	
						array.put(jsonObject);
					 }
					jsonObject = new JSONObject();
					jsonObject.put("DepositDetails", array);
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
				if(incomingRequest.equals("getProcessinfo")){
					try{
					connection  = DataBaseConnectionForNewDB.getConnectionForSyBase();
					String	depositnum = request.getParameter("depositno");
					String memAccno = request.getParameter("memAccno");
					Statement statement = connection.createStatement();
					
                   sqlQuery="speccs.SP_DepositUpdates 'PROCESSINFO','"+memAccno+"','','',0,0,'','','"+depositnum+"','','',0,0,'','',''";
					
                   ResultSet rsDepositDetails = statement.executeQuery(sqlQuery);
					
					JSONArray array = new JSONArray();
					if(rsDepositDetails.next()){
						jsonObject = new JSONObject();
						String Memdetails=rsDepositDetails.getString("Memdetails");
						String DepositNo=rsDepositDetails.getString("DepositNo");
						String DepositType=rsDepositDetails.getString("DepositType");
						String MaturityDate=rsDepositDetails.getString("MaturityDate");
						int MaturityAmount=rsDepositDetails.getInt("MaturityAmount");
						String Remarks=rsDepositDetails.getString("Remarks");
						String Status=rsDepositDetails.getString("Status");
						String AdjustRefNo=rsDepositDetails.getString("AdjustRefNo");
						int AdjustedAmount=rsDepositDetails.getInt("AdjustedAmount");
						int SettlementAmount=rsDepositDetails.getInt("SettlementAmount");
						
						
						if(Memdetails==null) Memdetails="";
						if(DepositNo==null) DepositNo="";
						if(DepositType==null) DepositType="";
						if(MaturityDate==null) MaturityDate="";
						if(Remarks==null) Remarks="";
						if(AdjustRefNo==null) AdjustRefNo="";
					
					
						jsonObject.put("Memdetails", Memdetails);
						jsonObject.put("DepositNo", DepositNo);
						jsonObject.put("DepositType", DepositType);
						jsonObject.put("MaturityDate", MaturityDate);
						jsonObject.put("MaturityAmount", MaturityAmount);
						jsonObject.put("Remarks", Remarks);
						jsonObject.put("Status", Status);
						jsonObject.put("AdjustRefNo", AdjustRefNo);
						jsonObject.put("AdjustedAmount", AdjustedAmount);
						jsonObject.put("SettlementAmount", SettlementAmount);
						
						array.put(jsonObject);
					 }
					jsonObject = new JSONObject();
					jsonObject.put("DepositProcess", array);
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
				// maturity details start
				if(incomingRequest.equals("maturityDetail")){
					try{
					connection  = DataBaseConnectionForNewDB.getConnectionForSyBase();
					String memCode = request.getParameter("empCode");
					String option = request.getParameter("option");
					String deposit = request.getParameter("deposit");
					int duration =Integer.parseInt( request.getParameter("duration"));
					System.out.println(request.getParameter("depositDate"));
					String depositDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("depositDate")));
					System.out.println(depositDate);
					int amount = Integer.parseInt( request.getParameter("amount"));
					String sqlQuery1 = "{call speccs.SP_Calculations(?,?,?,?,?,?,?,?)}";
					//System.out.println(option+"-"+memCode+"-"+deposit+"-"+depositDate+"-"+amount+"-"+duration);		
					Double maturityAmount=0.0; //boolean count=false;	
					String maturityDate=null;
					CallableStatement cs3 = connection.prepareCall(sqlQuery1);
					cs3.setString(1,option );
					cs3.setString(2,memCode );
					cs3.setString(3,deposit);
					cs3.setString(4,depositDate );
					cs3.setInt(5,amount);
					cs3.setInt(6,duration );
					cs3.registerOutParameter(7,java.sql.Types.VARCHAR);
					cs3.registerOutParameter(8,java.sql.Types.NUMERIC );
					
					int count=cs3.executeUpdate();
					maturityDate=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("MM/dd/yyyy").parse(cs3.getString(7)));;
					maturityAmount=cs3.getDouble(8);
					
					/*ResultSet rs= cs3.executeQuery();
					if(rs.next()) {
						count=true;
//						System.out.println("------start------"+rs.getString(1)+"|"+rs.getString(2));
//						System.out.println("-------end-----"+rs.getInt("maturityAmount"));						
							maturityDate=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("MM/dd/yyyy").parse(rs.getString("maturityDate")));;
							maturityAmount=rs.getDouble("maturityAmount");
					}*/
					
						
					
					
					jsonObject = new JSONObject();
					if(count==1) {
					jsonObject.put("maturityAmount", maturityAmount);
					jsonObject.put("maturityDate", maturityDate);
					jsonObject.put("SUCCESS", "Y");
					}
					
					else {
						count=0;
						jsonObject.put("SUCCESS", "N");
					}
					//System.out.println("json data "+jsonObject.toString());
					response.getWriter().write(jsonObject.toString());
					if(connection!=null){
			     		connection.close();
			     	}
					}catch (Exception e) {
	       				e.printStackTrace();
	       				response.getWriter().write(new JSONObject().put("ERROR", e.toString()).toString());
	    				if(connection!=null){
	    		     		connection.close();
	    		     	}
	    			}
				}
				// maturity details end
				 if (incomingRequest.equals("DepositDetails")) {
					
						String memaccNo = request.getParameter("accNo");
						String depositcode = request.getParameter("depositcode");
						String depositno = request.getParameter("depositno");
						System.out.println("dep no "+depositno +" mem code "+memaccNo);
						
						ServletContext ctx=getServletContext();
						 String header=ctx.getInitParameter("HEADER");
						 String number=ctx.getInitParameter("NUMBERS");
						 String fileName="";
						 if(memaccNo.equals(depositno)){
							 System.out.println("inside");
							 ShareCapitalDetailspdf.getPDF(memaccNo, header, number);
							 fileName="ShareCapitalDetailspdf.pdf";
						 }
						 else{
							 DepositDetailspdf.getPDF(memaccNo,depositno,depositcode,header,number);
							 fileName = "DepositDetailspdf.pdf";
						 }
						
						response.setContentType("application/pdf");

						File file1 = new File(fileName);
						response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
						response.setContentLength((int) file1.length());
						FileInputStream fis = new FileInputStream(file1);
						//int len = (int) file1.length();

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
				
				
				
			
		}
		catch(SQLException sqlException){
			sqlException.printStackTrace();
			jsonObject = new JSONObject();
			
			try {
				jsonObject.put("ERROR", "Please try again later");
				sqlException.printStackTrace();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		catch (Exception e) {
			// TODO: handle exception
			jsonObject = new JSONObject();
			String message = e.getMessage();
			try {
				//jsonObject.put("ERROR", message);
				response.getWriter().write(new JSONObject().put("ERROR", message).toString());
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	
		
		
	}
	
}
