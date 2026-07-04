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


@WebServlet("/NomineeController")
public class NomineeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String incomingRequest = request.getParameter("req");
	
		Connection connection = null;

		
		HttpSession session = request.getSession();
		String sqlQuery = "";
		JSONObject jsonObject = null;
		try {
			if(incomingRequest.equalsIgnoreCase("saveNominee")){
				try{
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
		
				String savewithid = request.getParameter("option1");
				String savewithoutid = request.getParameter("option2");
			
				String memAccNo = request.getParameter("memAccNo");
				String memCode = request.getParameter("memCode");
				String status = request.getParameter("status");
				String igrid=request.getParameter("igrid").trim();
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				JSONArray jarr=new JSONArray(igrid);
				
				JSONObject jobj=null;
				
				for(int i=0;i<jarr.length();i++){
					 jobj=jarr.getJSONObject(i);
					 
					 	String NomineeId=jobj.getString("NomineeId");
				
					 	String ipaddress=request.getRemoteHost();
						if(NomineeId.equals("")){
							String sqlQuery1 = "speccs.SP_Nominee '"+savewithoutid+"','"+memAccNo+"','"+jobj.getString("NomineeName").trim()+"','"+jobj.getString("Dob").trim()+"','"+jobj.getString("Relation").trim()+"','"+jobj.getString("Gender").trim()+"','"+jobj.getString("Address").trim()+"','"+status+"','"+userId+"','','"+ipaddress+"',''";
							
							 PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
								ps1.executeUpdate();
						}else{
							String 	sqlQuery2 = "speccs.SP_Nominee '"+savewithid+"','"+memAccNo+"','"+jobj.getString("NomineeName").trim()+"','"+jobj.getString("Dob").trim()+"','"+jobj.getString("Relation").trim()+"','"+jobj.getString("Gender").trim()+"','"+jobj.getString("Address").trim()+"','"+status+"','"+userId+"','"+NomineeId+"','"+ipaddress+"',''";
							
							 PreparedStatement  ps2 = connection.prepareStatement(sqlQuery2); 
								ps2.executeUpdate();	
						}
					
		
				}
				
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
			if(incomingRequest.equalsIgnoreCase("deletegrid")){
				try{
					int flag=0;
					connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
				String nomid = request.getParameter("nomid");
				String nomname = request.getParameter("nomname");
				String nomdob = request.getParameter("nomdob");
				String nomrelation = request.getParameter("nomrelation");
				String nomgender = request.getParameter("nomgender");
				String nomaddress = request.getParameter("nomaddress");
				String igrid=request.getParameter("igrid").trim();
				String sqlQuery1 = "speccs.SP_NomineeRef 'GETNOMI','','"+nomid+"','','','','',''";
				
				PreparedStatement ps2 = connection.prepareStatement(sqlQuery1);
				ResultSet res = ps2.executeQuery();
				while (res.next()) {
					flag=1;
				}
				if(flag==1){
					jsonObject = new JSONObject();
					jsonObject.put("nomineeref", "ref");
					response.getWriter().write(jsonObject.toString());
				}else{

				JSONArray jarr=new JSONArray(igrid);
				JSONObject jobj=null;
				JSONArray array2 = new JSONArray();
				String gridNomineeId;
				String gridRelation;
			 	String gridDob;
			 	String gridNomineeName;
			 	String gridGender;
			 	String gridAddress;
				for(int i=0;i<jarr.length();i++){
					 jobj=jarr.getJSONObject(i);
					 
					 	 gridNomineeId=jobj.getString("NomineeId");
					 	 gridRelation=jobj.getString("Relation");
					 	 gridDob=jobj.getString("Dob");
					 	 gridNomineeName=jobj.getString("NomineeName");
					 	 gridGender=jobj.getString("Gender");
					 	 gridAddress=jobj.getString("Address");
				
if(nomid.equals(gridNomineeId) && nomname.equals(gridNomineeName) && nomdob.equals(gridDob) && nomrelation.equals(gridRelation) && nomgender.equals(gridGender)) {
}else{
	jsonObject = new JSONObject();
	jsonObject.put("NomineeId", gridNomineeId);
	jsonObject.put("NomineeName", gridNomineeName);
	jsonObject.put("Dob", gridDob);
	jsonObject.put("Relation", gridRelation);
	jsonObject.put("Gender", gridGender);
	jsonObject.put("Address", gridAddress);
	array2.put(jsonObject);	
			}				
		}
				jsonObject = new JSONObject();
				jsonObject.put("nomDetails", array2);
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
					
			if(incomingRequest.equalsIgnoreCase("deleteNominee")){
				try{
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
				String option = request.getParameter("option");
			
				String memAccNo = request.getParameter("memAccNo");
	
		
	                sqlQuery = "speccs.SP_Nominee '"+option+"','"+memAccNo+"','','','','','','','','','',''";
						 PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
							ps3.executeUpdate();
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
			
			

	if(incomingRequest.equalsIgnoreCase("gettinggriddata")){
		
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
		String memAccNo = request.getParameter("memAccNo");
		String option = request.getParameter("option");
		
		
		sqlQuery = "speccs.SP_Nominee '"+option+"','"+memAccNo+"','','','','','','','','','',''";
		
		PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
		ResultSet res = ps2.executeQuery();
		
		JSONArray array2 = new JSONArray();
		
	
		while (res.next()) {
			
			jsonObject = new JSONObject();
			String NomineeId=res.getString("NomineeId").trim();
			String NomineeName=res.getString("NomName").trim();
			String Dob=res.getString("NomDOB").trim();
			String Relation=res.getString("Relationship");
			String Gender=res.getString("Gender");
			String Address=res.getString("Address");
			jsonObject.put("NomineeId", NomineeId.trim());
			jsonObject.put("NomineeName", NomineeName.trim());
			jsonObject.put("Dob", Dob.trim());
			jsonObject.put("Relation", Relation.trim());
			jsonObject.put("Gender", Gender.trim());
			jsonObject.put("Address", Address.trim());
			array2.put(jsonObject);	
		}
		jsonObject = new JSONObject();
		jsonObject.put("nomDetails", array2);
		response.getWriter().write(jsonObject.toString());
		
		if(connection!=null){
			connection.close();
		}
			}
				

			
			
			if(incomingRequest.equalsIgnoreCase("deletebankgrid")){
				try{
			
				String BankaccNo = request.getParameter("bankaccno");
				String Ifsccode = request.getParameter("ifsccode");
				String bankname = request.getParameter("bankname");
				String bankplace = request.getParameter("bankplace");
				String igrid=request.getParameter("igrid").trim();

				JSONArray jarr=new JSONArray(igrid);
				JSONObject jobj=null;
				JSONArray array2 = new JSONArray();
				String gridbankaccno;
				String gridifsccode;
			 	String gridbankname;
			 	String gridbankplace;
			 	
				for(int i=0;i<jarr.length();i++){
					 jobj=jarr.getJSONObject(i);
					 
					 gridbankaccno=jobj.getString("BankAccNo");
					 gridifsccode=jobj.getString("Ifsccode");
					 gridbankname=jobj.getString("Bankname");
					 gridbankplace=jobj.getString("Bankplace");
					 
				
if(BankaccNo.equals(gridbankaccno) && Ifsccode.equals(gridifsccode)) {
}else{
	jsonObject = new JSONObject();
	jsonObject.put("BankAccNo", gridbankaccno);
	jsonObject.put("Ifsccode", gridifsccode);
	jsonObject.put("Bankname", gridbankname);
	jsonObject.put("Bankplace", gridbankplace);
	
	array2.put(jsonObject);	
			}				
	     	}
				jsonObject = new JSONObject();
				jsonObject.put("bankDetails", array2);
				response.getWriter().write(jsonObject.toString());
				
				
			}catch(Exception e){
					e.printStackTrace();
				}
					
				}

	}
		catch(SQLException | JSONException | InstantiationException | IllegalAccessException | ClassNotFoundException e){
			e.printStackTrace();
		}
		
	
	

}
}

