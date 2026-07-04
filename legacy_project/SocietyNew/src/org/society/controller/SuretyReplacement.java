package org.society.controller;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

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

@WebServlet("/SuretyReplacement")
public class SuretyReplacement extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) {

		String IncomingRequest = request.getParameter("req");
		Connection con=null;
		HttpSession session = request.getSession();
		CallableStatement prepareCall=null;
		Map<String, String> hashMap;
		List<Map<String, String>> list=new ArrayList<Map<String,String>>();
		JSONObject jsonObj=null;
		JSONObject jsonObject=null;

		try {
			con = DataBaseConnectionForNewDB.getConnectionForSyBase();
			
			if (IncomingRequest.equals("FetchSureties")) {
				String memAccNo = request.getParameter("memacc");
				String loanno = request.getParameter("loanno");
				
				String sqlQuery = "{CALL speccs.SP_FetchSurety(?,?,?)}";
				 
				 prepareCall = con.prepareCall(sqlQuery);
				 prepareCall.setString(1,"SURETYLIST");
				 prepareCall.setString(2,memAccNo);
				 prepareCall.setString(3,loanno);
				 ResultSet result = prepareCall.executeQuery();
				 jsonObj= new JSONObject();
				 
				 while(result.next()){
					 hashMap=new HashMap<>();
					 hashMap.put("Memaccno", result.getString("MemAccNo"));
					 hashMap.put("Empcode",result.getString("MemEmpCode"));
					 hashMap.put("MemName",result.getString("MemName"));
					 hashMap.put("Thriftamt",""+result.getInt("ThriftBalance"));
					 list.add(hashMap);
					 
				 }
				 jsonObj.put("ERROR","NO");
				 jsonObj.put("SURETYDETAIL",list);
				 response.getWriter().write(jsonObj.toString());
				 if(con!=null){
					 con.close();
				 }
			}
			if(IncomingRequest.equalsIgnoreCase("deletegrid")){
				try{
				
				String memAccNo = request.getParameter("empCode");
				String smemAccNo = request.getParameter("SMemaccno");
				String employeecode[]=smemAccNo.split("-");
				String igrid=request.getParameter("igrid").trim();
				
		         jsonObject = new JSONObject();
					
				JSONArray jarr=new JSONArray(igrid);
				JSONObject jobj=null;
				JSONArray array2 = new JSONArray();
				String gridEmpcode;
				String gridMemaccno;
				String gridMemName;
				String gridThriftamt;
				for(int i=0;i<jarr.length();i++){
					 jobj=jarr.getJSONObject(i);
					 
					 gridEmpcode=jobj.getString("Empcode");
					 gridMemaccno=jobj.getString("Memaccno");
					 gridThriftamt=jobj.getString("Thriftamt");
					 gridMemName=jobj.getString("MemName");
				
                 if(!employeecode[0].trim().equals(gridMemaccno.trim())) {
	
					jsonObject = new JSONObject();
					jsonObject.put("Empcode", gridEmpcode);
					jsonObject.put("Memaccno", gridMemaccno);
					jsonObject.put("MemName", gridMemName);
					jsonObject.put("Thriftamt", gridThriftamt);
					array2.put(jsonObject);	
				}
                 else {		//added by pn on 21/05/2025 to remove Surety on delete
                	 String sqlQuery = "DELETE FROM speccs.Surety WHERE SMemAccNo = '"+smemAccNo+" ' AND MemAccNo='"+memAccNo.split("-")[0]+"'"; 					
 					CallableStatement cStatement = con.prepareCall(sqlQuery);
 					cStatement.executeUpdate();
                 }
				}
				jsonObject = new JSONObject();
				jsonObject.put("suretyDetails", array2);
				response.getWriter().write(jsonObject.toString());
				
				

			}catch(Exception e){
					e.printStackTrace();
					
				
				}
					
				}
			if(IncomingRequest.equalsIgnoreCase("suretycheck")){
				try{
				
				String loanamount = request.getParameter("loanamount");
				String loannum = request.getParameter("loannum");
				String memacc = request.getParameter("memacc");
				
				String igrid=request.getParameter("igrid").trim();
				
		         jsonObject = new JSONObject();
				JSONArray jarr=new JSONArray(igrid);
				JSONObject jobj=null;
				JSONObject jobj1=null;
				JSONObject jobj2=null;
				JSONObject jobj3=null;
				JSONObject jobj4=null;
				JSONArray array2 = new JSONArray();
			
				String gridThriftamt;
			    Float totalthriftamount = (float) 0;
				Float emploanamount=Float.parseFloat(loanamount);
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				
				GenericDetailsService genericDetailsService  = new GenericDetailsService();
				int thriftPerc = genericDetailsService.getSocietyRuleValuesurety("102", "Value");
				for(int i=0;i<jarr.length();i++){
					 jobj=jarr.getJSONObject(i);
					 Float threeamount=Float.parseFloat(gridThriftamt=jobj.getString("Thriftamt"));
					 totalthriftamount=totalthriftamount+threeamount;	
				}
				Float  minimumThriftAmount = (emploanamount * thriftPerc )/100;
		
				String message=null;
				//commented by pn on 26/05/2025 told by Rama Rao
				/*if(totalthriftamount < minimumThriftAmount){
				Float requiredAmount = minimumThriftAmount - totalthriftamount;
			 message="Insufficient of thrift amount of Rs. "+requiredAmount+" \n All surities combined should have "+minimumThriftAmount + "  as THRIFT amount \n Rejected due to Insufficient combined Thrift Amount of All surities ";
			
			    jsonObject = new JSONObject();
			    jsonObject.put("ERROR", "YES");
				jsonObject.put("errormsg", message);
				response.getWriter().write(jsonObject.toString());
				}else{*/
						 jobj1=jarr.getJSONObject(0);
						 String surety1=jobj1.getString("Memaccno");
						 jobj2=jarr.getJSONObject(1);
						 String surety2=jobj2.getString("Memaccno");
						 jobj3=jarr.getJSONObject(2);
						 String surety3=jobj3.getString("Memaccno");
						/* jobj4=jarr.getJSONObject(3);
						 String surety4=jobj4.getString("Memaccno");*/
						 String ipaddress=request.getRemoteHost();
					
					String sqlQuery = "{call speccs.SP_Surety(?,?,?,?,?,?,?,?,?,?)}";
					
					CallableStatement cStatement = con.prepareCall(sqlQuery);
					cStatement.setString(1, "UPDATESURETY");
					cStatement.setString(2,memacc);
					cStatement.setString(3,loannum);
					cStatement.setInt(4, 0);
					cStatement.setString(5, surety1);
					cStatement.setString(6, surety2);
					cStatement.setString(7, surety3);
					cStatement.setString(8, "");
					cStatement.setString(9,ipaddress );
					cStatement.setString(10, userId);				
					cStatement.executeUpdate();
					
					
					jsonObject = new JSONObject();
				    jsonObject.put("SUCCESS", "Y");
					response.getWriter().write(jsonObject.toString());
					
			//	}
				
			}catch(Exception e){
					e.printStackTrace();
				}	
				}
		}
		catch(SQLException e){
			try {
				boolean message=e.getMessage().contains("Number :SP_FetchSurety");
				String ErrorMsg="Member not given any Surety";
				String msg=null;
				if(message){
					msg=ErrorMsg;
				}
				JSONObject json1=new JSONObject();
				json1.put("ERROR",msg);
				response.getWriter().write(json1.toString());
			} catch (JSONException | IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		catch (InstantiationException | IllegalAccessException
				| ClassNotFoundException   | JSONException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
