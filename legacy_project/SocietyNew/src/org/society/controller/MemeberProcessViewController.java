package org.society.controller;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;
import org.society.util.DataBaseConnectionForNewDB;

import com.google.gson.JsonObject;

@WebServlet("/MemeberProcessViewController")
public class MemeberProcessViewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
	@SuppressWarnings("resource")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Connection con=null;
		CallableStatement call=null,cs=null;
		JSONObject object=new JSONObject();
		String IncomingReq=request.getParameter("req");
	
		if(IncomingReq.equals("getDepositeDetails")) {
			
			try {
				String type=request.getParameter("type");
				String MemAccNo=request.getParameter("memAccNo");
				String settlementDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("memSettDate").trim()));
			String querry="{call speccs.SP_MemberProcessView(?,?,?)}";
			   con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				call = con.prepareCall(querry,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
				call.setString(1,type);
	            call.setString(2,MemAccNo);
	            call.setString(3,settlementDate);
	            ResultSet result = call.executeQuery();
	           
	            List<Map<String, String>> listOfDepDetails=new ArrayList<Map<String,String>>();
			Map<String, String> map = null;
			int DepositTotal =0;
			while(result.next()) {
//				System.out.println("DATA "+result.getString("DepositNo"));
				map = new HashMap<String, String>();
				map.put("MemAccNo", result.getString("MemAccNo"));
				map.put("DepositDetails", result.getString("DepositNo")+"-"+result.getString("OpenDate"));
				map.put("DepositNo", result.getString("DepositNo"));
				map.put("DepositType", result.getString("DepositType"));
				map.put("OpenDate", result.getString("OpenDate"));
				map.put("SettlementAmount", result.getString("SettlementAmount"));
				map.put("Duration", result.getString("Duration"));
				map.put("SettlementAmount", result.getString("SettlementAmount"));
				String depositNo = result.getString("DepositNo");
				DepositTotal=DepositTotal+(depositNo.equals(MemAccNo)?result.getInt("SettlementAmount"):0);
				listOfDepDetails.add(map);
			}
//			System.out.println(listOfDepDetails.toString());
		    if(listOfDepDetails.size()>0) {
		    object.put("SUCCESS", "Y");	
			object.put("Deposite", listOfDepDetails);
			object.put("DepositeTotal", DepositTotal);
		    }else{
		    	object.put("SUCCESS", "N");
		    }
		   
			}
			catch (Exception e) {
				// TODO: handle exception
				String message = e.getMessage();
				boolean contains = message.contains(":");
				String errMsg  = "Some technical error";
				if(contains) {
					errMsg = message;
				}
				try {
				object = new JSONObject();
				
					object.put("SUCCESS", errMsg);
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			/*catch (InstantiationException | IllegalAccessException | ClassNotFoundException | JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				
			}*/
			response.getWriter().write(object.toString());
			if(con!=null){
				try {
					con.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		if(IncomingReq.equals("getLiabilityDetails")) {
		
			try {
				String type=request.getParameter("type");
				
				String MemAccNo=request.getParameter("memAccNo");
				String settlementDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("memSettDate").trim()));
				// System.out.println(settlementDate);
			String querry="{call speccs.SP_MemberProcessView(?,?,?)}";
			   con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				call = con.prepareCall(querry);
				call.setString(1,type);
	            call.setString(2,MemAccNo);
	            call.setString(3,settlementDate);		        
	            ResultSet result = call.executeQuery();
	            List<Map<String, String>> listOfLiabilities=new ArrayList<Map<String,String>>();
				Map<String, String> map = null;
				int LonaTotal =0;
			while(result.next()) {
				map = new HashMap<String, String>();
				map.put("MemAccNo", result.getString("MemAccNo"));
				map.put("LiabilitiesDetails", result.getString("LoanAccNo")+"-"+result.getString("OpenDate"));
				map.put("LoanAccNo", result.getString("LoanAccNo"));
				map.put("LoanType", result.getString("LoanType"));
				map.put("OpenDate", result.getString("OpenDate"));
				map.put("LoanAmount", result.getString("LoanSanctionAmount"));
				LonaTotal=LonaTotal+result.getInt("LoanSanctionAmount");
				listOfLiabilities.add(map);
			}
		    if(listOfLiabilities.size()>0) {
		    object.put("SUCCESS", "Y");	
			object.put("Liability", listOfLiabilities);
			object.put("LoanTotal", LonaTotal);
			System.out.println(object.toString());
		    }else{
		    	object.put("SUCCESS", "N");
		    }
		
			
			} 	catch (Exception e  ) {
				// TODO: handle exception
				String message = e.getMessage();
				boolean contains = message.contains(":");
				String errMsg  = "Some technical error";
				if(contains) {
					errMsg = message;
				}
				try {
				object = new JSONObject();
				
					object.put("SUCCESS", errMsg);
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			/*catch (InstantiationException | IllegalAccessException | ClassNotFoundException | JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				
			}*/
			response.getWriter().write(object.toString());
			if(con!=null){
				try {
					con.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		if(IncomingReq.equals("SurityList")){

			
			try {
				String type=request.getParameter("type");
				
				String MemAccNo=request.getParameter("memAccNo");
				String settlementDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("memSettDate").trim()));
				 
			String querry="{call speccs.SP_MemberProcessView(?,?,?)}";
			   con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				call = con.prepareCall(querry);
				call.setString(1,type);
	            call.setString(2,MemAccNo);
	            call.setString(3,settlementDate);
	            		        
	            ResultSet result = call.executeQuery();
	            List<Map<String, String>> listOfSurities=new ArrayList<Map<String,String>>();
				Map<String, String> map = null;
				
			while(result.next()) {
				map = new HashMap<String, String>();
				map.put("MemAccNo", result.getString("MemAccNo"));
				map.put("MemEmpCode", result.getString("MemEmpCode"));
				map.put("MemName", result.getString("MemName"));							
				
				listOfSurities.add(map);
			}
			//listOfSurities.stream().forEach((n) -> System.out.println(n));
		    if(listOfSurities.size()>0) {
		    object.put("SUCCESS", "Y");	
			object.put("Surities", listOfSurities);
		    }else{
		    	object.put("SUCCESS", "N");
		    }
		
			
			} 	catch (Exception e) {
				// TODO: handle exception
				String message = e.getMessage();
				boolean contains = message.contains(":");
				String errMsg  = "Some technical error";
				if(contains) {
					errMsg = message;
				}
				try {
				object = new JSONObject();
				
					object.put("SUCCESS", errMsg);
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			/*catch (InstantiationException | IllegalAccessException | ClassNotFoundException | JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				
			}*/
			response.getWriter().write(object.toString());
			if(con!=null){
				try {
					con.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		
		}		
		
	}

}
