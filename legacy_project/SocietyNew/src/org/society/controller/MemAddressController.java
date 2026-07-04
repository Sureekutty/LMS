package org.society.controller;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.society.service.MemberService;
import org.society.util.DataBaseConnectionForNewDB;

@SuppressWarnings("serial")
@WebServlet("/MemAddress")
public class MemAddressController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String IncomingRequest = request.getParameter("req");
		Connection connection = null;
		JSONObject jsonObject = null;

		try {
			if (IncomingRequest.equals("saveMemAddress")) {
				try{
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			
				String option1 = request.getParameter("option1");
				String option2 = request.getParameter("option2");
				/*String userid = request.getParameter("userid");*/
				String memAccNo = request.getParameter("memAccNo");
				
				String igrid1=request.getParameter("igrid1").trim();
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				String emplcode=request.getParameter("emplcode");
				JSONArray jarr=new JSONArray(igrid1);
				JSONObject jobj=null;

				for(int i=0;i<jarr.length();i++){
					 jobj=jarr.getJSONObject(i);
				
					 String memberaddressid=jobj.getString("AddressId").trim();
					 
					 String ipaddress=request.getRemoteHost();
					 
					 if(memberaddressid.equals("")){
					
	 String  sqlQuery = "speccs.SP_MemAddress '"+option1+"','"+memAccNo+"','"+jobj.getString("Address1").trim()+"','"+jobj.getString("Address2").trim()+"','"+jobj.getString("City").trim()+"','"+jobj.getString("District").trim()+"','"+jobj.getString("State").trim()+"','"+jobj.getString("Pincode").trim()+"','"+jobj.getString("Remarks").trim()+"','"+userId+"','','"+ipaddress+"',''";
	  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery); 
	ps1.executeUpdate();
		
					 }else{
						 
						 String  sqlQuery1 = "speccs.SP_MemAddress '"+option2+"','"+memAccNo+"','"+jobj.getString("Address1").trim()+"','"+jobj.getString("Address2").trim()+"','"+jobj.getString("City").trim()+"','"+jobj.getString("District").trim()+"','"+jobj.getString("State").trim()+"','"+jobj.getString("Pincode").trim()+"','"+jobj.getString("Remarks").trim()+"','"+userId+"','"+memberaddressid+"','"+ipaddress+"',''";
						    PreparedStatement  ps2 = connection.prepareStatement(sqlQuery1); 
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
			
			
			if(IncomingRequest.equalsIgnoreCase("deleteNomineemember")){
				try{
					
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
				String option = request.getParameter("option");
			
				String memAccNo = request.getParameter("memAccNo");
				
		
				String  sqlQuery1 = "speccs.SP_MemAddress '"+option+"','"+memAccNo+"','','','','','','','','','','',''";
				
				 PreparedStatement  ps3 = connection.prepareStatement(sqlQuery1); 
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
			
			if(IncomingRequest.equalsIgnoreCase("deletegridaddress")){
				try{
					
					
				String addid = request.getParameter("addid");
				String add1 = request.getParameter("add1");
				String add2 = request.getParameter("add2");
				String city = request.getParameter("city");
				String district = request.getParameter("district");
				String state = request.getParameter("state");
				String pincode = request.getParameter("pincode");
				
				
				String igrid1=request.getParameter("igrid1").trim();
				JSONArray jarr=new JSONArray(igrid1);
				
				JSONObject jobj=null;
				
				JSONArray array2 = new JSONArray();
				String gridAddressId;
				String gridAdd1;
			 	String gridAdd2;
			 	String gridCity;
			 	String griDistrict;
			 	String gridState;
				String gridPincode;
				String gridRemarks;
				for(int i=0;i<jarr.length();i++){
					 jobj=jarr.getJSONObject(i);
					 
				 gridAddressId=jobj.getString("AddressId");
					 gridAdd1=jobj.getString("Address1");
					 gridAdd2=jobj.getString("Address2");
					 gridCity=jobj.getString("City");
					 griDistrict=jobj.getString("District");
					 gridState=jobj.getString("State");
					 gridPincode=jobj.getString("Pincode");
					 gridRemarks=jobj.getString("Remarks");
if(addid.equals(gridAddressId) && add1.equals(gridAdd1) && add2.equals(gridAdd2) && city.equals(gridCity) && district.equals(griDistrict) && state.equals(gridState)  && pincode.equals(gridPincode)) {
}else{
	                jsonObject = new JSONObject();
	                jsonObject.put("AddressId", gridAddressId);
					jsonObject.put("Address1", gridAdd1);
					jsonObject.put("Address2", gridAdd2);
					jsonObject.put("City", gridCity);
					jsonObject.put("District", griDistrict);
					jsonObject.put("State", gridState);
					jsonObject.put("Pincode", gridPincode);
					jsonObject.put("Remarks", gridRemarks);
					array2.put(jsonObject);	
			}		
		}
				jsonObject = new JSONObject();
				jsonObject.put("addDetails", array2);
				response.getWriter().write(jsonObject.toString());
				}catch(Exception e){
					e.printStackTrace();
					
				}
					
				}
			
			
			
			
			
			if(IncomingRequest.equalsIgnoreCase("gettinggriddata")){
				try{
				connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
				String memAccNo = request.getParameter("memAccNo");
				String option = request.getParameter("option");
				
				
				String  sqlQuery2 = "speccs.SP_MemAddress '"+option+"','"+memAccNo+"','','','','','','','','','','',''";
				
				PreparedStatement ps2 = connection.prepareStatement(sqlQuery2);
				ResultSet res = ps2.executeQuery();
				
				JSONArray array2 = new JSONArray();
				
			
				while (res.next()) {
					jsonObject = new JSONObject();
					
					String AddressId=res.getString("MemberId");
					String Address1=res.getString("Address1").trim();
					String Address2=res.getString("Address2").trim();
					String City=res.getString("City");
					String District=res.getString("District");
					String State=res.getString("State");
					String Pincode=res.getString("Pincode");
					String Remarks=res.getString("Remarks");
					
			
					jsonObject.put("AddressId", AddressId.trim());
					jsonObject.put("Address1", Address1.trim());
					jsonObject.put("Address2", Address2.trim());
					jsonObject.put("City", City.trim());
					jsonObject.put("District", District.trim());
					jsonObject.put("State", State.trim());
					jsonObject.put("Pincode", Pincode.trim());
					jsonObject.put("Remarks", Remarks.trim());
					array2.put(jsonObject);	
				}
				jsonObject = new JSONObject();
				jsonObject.put("addDetails", array2);
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

			if (IncomingRequest.equals("getMemAddress")) {
			
				String fetch = request.getParameter("option");
				String empCode = request.getParameter("empCode");
				
				MemberService memberService = new MemberService();
				LinkedList<String> memAddress = memberService.getMemAddress(fetch, empCode);
            
				JSONObject jsonObj = new JSONObject();
				
				if(memAddress.size()>0){
				jsonObj.put("success", "Y");
				jsonObj.put("MemAddress", memAddress);
				
				
				}
				
				else{
					jsonObj.put("success", "N");
				}

				response.getWriter().write(jsonObj.toString());

			}

		}

		catch (Exception e) {
             System.out.println("Exception in getMemAddress "+e);
             e.printStackTrace();
		}

	}
}
