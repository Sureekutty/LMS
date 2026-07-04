package org.society.controller;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

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
import org.society.service.LoanApplicationService;
import org.society.util.DataBaseConnectionForNewDB;

/**
 * Servlet implementation class Loanapplication
 */
@WebServlet("/ApplicationForLoan")
public class LoanApplication extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
  
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String incomingRequest = request.getParameter("req");
		JSONObject jsonObject = null;
		Connection connection = null;
		HttpSession session = request.getSession();
		CallableStatement cStatement=null;
		try{
			connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
              if(incomingRequest.equalsIgnoreCase("getTypeOfLoans")){
				
				String query="EXEC speccs.SP_LoanRecovery 'LOANTYPE','','','','','','','','','','','','',''";
				
				
				Statement statement = connection.createStatement();
				ResultSet resultSet = statement.executeQuery(query);
				
				LinkedList<String> list=new LinkedList<>();
				
				while(resultSet.next()){
					
					list.add(resultSet.getString(1));
					list.add(resultSet.getString(2));
					
				}
				
				
				if(list.size()>0){
				jsonObject = new JSONObject();
				jsonObject.put("TYPEOFLOANS", list);
				}
		
				
			}
              if(incomingRequest.equalsIgnoreCase("getsanctionloandata")){
            	  String loanAccno  = request.getParameter("loanAccno");
  				String query="EXEC speccs.SP_LoanRecovery 'SANCDETAILS','"+loanAccno+"','','',0,0,'','','',0,'','',0,0,'','','','',0,''";
  			
  				Statement statement = connection.createStatement();
  				ResultSet resultSet = statement.executeQuery(query);
  				
  				JSONArray array = new JSONArray();
  				if(resultSet.next()){
  					jsonObject = new JSONObject();
  		
  					String NoOfInstallments=String.valueOf(resultSet.getInt("NoOfInstallments"));
  					String LoanSanctionDate =resultSet.getString("LoanSanctionDate");  					
  					String LoanSanctionAmount=String.valueOf(resultSet.getInt("LoanSanctionAmount"));
  					String InterestRate=String.valueOf(resultSet.getInt("InterestRate"));
  					//String Opendate=String.valueOf(resultSet.getString("Loanappdate"));
  					String Opendate=resultSet.getString("Loanappdate");
  					String installmentspaid=String.valueOf(resultSet.getString("MonthlyInstallments"));
  					String loantype=resultSet.getString("LoanType");
  					//String principleamount=String.valueOf(resultSet.getInt("Amount"));
  					String Receiptno=resultSet.getString("ReceiptNo");
  					String pi=resultSet.getString("P_I");
  					String Modeofpay=resultSet.getString("Modeofpay");
  					
  					String query1="EXEC speccs.SP_LoanRecovery 'INTSANCDETAILS','"+loanAccno+"','','',0,0,'','','',0,'','',0,0,'','','','',0,''";
  		  			
  	  				Statement statement1 = connection.createStatement();
  	  				ResultSet resultSet1 = statement1.executeQuery(query1);
  					int intrestamount = 0;
  					if(resultSet1.next()){
  					intrestamount=resultSet1.getInt("intamount");
  					}
  					
  					String query5="EXEC speccs.SP_LoanRecovery 'PRIAMOUNTDETAILS','"+loanAccno+"','','',0,0,'','','',0,'','',0,0,'','','','',0,''";
  		  			
  	  				Statement statement3 = connection.createStatement();
  	  				ResultSet resultSet3 = statement3.executeQuery(query5);
  					float principleamount = 0;
  					if(resultSet3.next()){
  						principleamount=resultSet3.getFloat("PriAmount");
  						
  					}
  					
  					jsonObject.put("loantype", loantype);
  					jsonObject.put("Opendate", Opendate);
  					jsonObject.put("installmentspaid", installmentspaid);
  					jsonObject.put("NoOfInstallments", NoOfInstallments);
  					jsonObject.put("LoanSanctionDate", LoanSanctionDate);
  					jsonObject.put("LoanSanctionAmount", LoanSanctionAmount);
  					jsonObject.put("InterestRate", InterestRate);
  					jsonObject.put("Receiptno", Receiptno);
  					jsonObject.put("principleamount", principleamount);
  					jsonObject.put("pi", pi);
  					jsonObject.put("intrestamount", intrestamount);
  					
  					jsonObject.put("Modeofpay", Modeofpay);
  					
  					
  					array.put(jsonObject);
  					
  				}
  				
  				jsonObject = new JSONObject();
  				jsonObject.put("SANCLOANDETAILS", array);
  				response.getWriter().write(jsonObject.toString());
  				}
              
              
              if(incomingRequest.equalsIgnoreCase("getsurietythr")){
            	  String suriety1  = request.getParameter("suriety1");
            	  String suriety2  = request.getParameter("suriety2");
            	  String suriety3  = request.getParameter("suriety3");
            	  //System.out.println("calling 144");
  				String query="EXEC speccs.SP_EMPLOYEECODELIST 'SURITYLISTTHRIFT','"+suriety1+"'";
  				Statement statement = connection.createStatement();
  				ResultSet resultSet = statement.executeQuery(query);
  				JSONArray array = new JSONArray();
  				JSONObject jsonObject1=null;
  				if(resultSet.next()){
  					jsonObject1 = new JSONObject();
  					jsonObject1.put("suriety1", String.valueOf(resultSet.getInt("ThriftBalance")));
  					array.put(jsonObject1);
  				}
  				
  				String query1="EXEC speccs.SP_EMPLOYEECODELIST 'SURITYLISTTHRIFT','"+suriety2+"'";
  				Statement statement1 = connection.createStatement();
  				ResultSet resultSet1 = statement1.executeQuery(query1);
  				JSONArray array1 = new JSONArray();
  				JSONObject jsonObject11=null;
  				if(resultSet1.next()){
  					jsonObject11 = new JSONObject();
  					jsonObject11.put("suriety2", String.valueOf(resultSet1.getInt("ThriftBalance")));
  					array1.put(jsonObject11);
  				}
  				
  				String query3="EXEC speccs.SP_EMPLOYEECODELIST 'SURITYLISTTHRIFT','"+suriety3+"'";
  				Statement statement3 = connection.createStatement();
  				ResultSet resultSet3 = statement3.executeQuery(query3);
  				JSONArray array3 = new JSONArray();
  				JSONObject jsonObject3=null;
  				if(resultSet3.next()){
  					jsonObject3 = new JSONObject();
  					jsonObject3.put("suriety3", String.valueOf(resultSet3.getInt("ThriftBalance")));
  					array3.put(jsonObject3);
  				}
  				
  				
  				jsonObject = new JSONObject();
  				jsonObject.put("SURIETY1", array);
  				jsonObject.put("SURIETY2", array1);
  				jsonObject.put("SURIETY3", array3);
  				response.getWriter().write(jsonObject.toString());
  				}
              
              if(incomingRequest.equalsIgnoreCase("saveloanrecovery")){
            	  String ipaddress=request.getRemoteHost();
            	  String option  = request.getParameter("option");
            	  String receiptno  = request.getParameter("receiptno");
            	  String memAccNo  = request.getParameter("memAccNo");
            	  String loanaccno  = request.getParameter("loanaccno");
//            	  String opendate  = request.getParameter("opendate");
            	  String opendate  = new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("MM/dd/yyyy").parse(request.getParameter("opendate")));
            	  float Loaninterest  =Float.parseFloat(request.getParameter("Loaninterest"));
            	  System.out.println("Loaninterest "+Loaninterest);
            	  String loantype  = request.getParameter("loantype");
            	  int noofinstallments  =Integer.parseInt(request.getParameter("noofinstallments"));
            	  String loansancamt  = request.getParameter("loansancamt");
            	  String loansanctiondate  = request.getParameter("loansanctiondate");
            	  String noofinstallpaid  = request.getParameter("noofinstallpaid");
            	  int principalbal  =Integer.parseInt(request.getParameter("principalbal"));
            	  String interestrate  = request.getParameter("interestrate");
            	  String modeOfPay  = request.getParameter("modeOfPay");
            	  int principalamt  =Integer.parseInt(request.getParameter("principalamt"));
            	  float interestamt  =Float.parseFloat(request.getParameter("interestamt"));
//            	  System.out.println("interestamt "+interestamt);
            		String userId = (String) session.getAttribute("EMPLOYEECODE");
            		
            		if(option.equals("SAVE")){
            		
  				String query="{call speccs.SP_LoanRecovery ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
  				
				 cStatement = connection.prepareCall(query);
				 
				cStatement.setString(1, option);
				cStatement.setString(2, loanaccno);
				cStatement.setString(3, loantype);
				cStatement.setString(4, opendate);
				cStatement.setFloat(5, Loaninterest);
				cStatement.setInt(6, noofinstallments);
				cStatement.setString(7, loansancamt);
				cStatement.setString(8, loansanctiondate);
				cStatement.setString(9, noofinstallpaid);
				cStatement.setInt(10, principalbal);
				cStatement.setString(11, interestrate);
				cStatement.setString(12, modeOfPay);
				cStatement.setInt(13, principalamt);
				cStatement.setFloat(14, interestamt);
				cStatement.setString(15, receiptno);
				cStatement.setString(16, userId);
				cStatement.setString(17, memAccNo);
				cStatement.setString(18, ipaddress);
				cStatement.setInt(19, (Integer.parseInt(loansancamt)-principalamt));
				cStatement.registerOutParameter(20, Types.VARCHAR);
				cStatement.executeUpdate();
				
				String memaccNonewrecovery = cStatement.getString(20);
				
				cStatement.close();
				
				jsonObject = new JSONObject();
				jsonObject.put("memaccNonew", memaccNonewrecovery);
				jsonObject.put("success", "y");
				response.getWriter().write(jsonObject.toString());
  				}else{
  					String query="{call speccs.SP_LoanRecovery ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
  	  				
  					 cStatement = connection.prepareCall(query);
  					cStatement.setString(1, option);
  					cStatement.setString(2, loanaccno);
  					cStatement.setString(3, loantype);
  					cStatement.setString(4, opendate);
  					cStatement.setFloat(5, Loaninterest);
  					cStatement.setInt(6, noofinstallments);
  					cStatement.setString(7, loansancamt);
  					cStatement.setString(8, loansanctiondate);
  					cStatement.setString(9, noofinstallpaid);
  					cStatement.setInt(10, principalbal);
  					cStatement.setString(11, interestrate);
  					cStatement.setString(12, modeOfPay);
  					cStatement.setInt(13, principalamt);
  					cStatement.setFloat(14, interestamt);
  					cStatement.setString(15, receiptno);
  					cStatement.setString(16, userId);
  					cStatement.setString(17, memAccNo);
  					cStatement.setString(18, ipaddress);
  					cStatement.setInt(19, 0);
  					cStatement.registerOutParameter(20, Types.VARCHAR);
  					cStatement.executeUpdate();
  					
  					String memaccNonewrecovery = cStatement.getString(20);
  					
  					cStatement.close();
  					
  					jsonObject = new JSONObject();
  					jsonObject.put("memaccNonew", memaccNonewrecovery);
  					jsonObject.put("success", "u");
  					response.getWriter().write(jsonObject.toString());
  				}
              }
  				
  			
              
              
              
              
              
		}
			 catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally{
			
			try {
				if(connection != null)
				connection.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		// TODO Auto-generated method stub
	}


	private int ValueOf(String parameter) {
		// TODO Auto-generated method stub
		return 0;
	}

}
