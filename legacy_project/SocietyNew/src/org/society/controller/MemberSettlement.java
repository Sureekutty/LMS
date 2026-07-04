package org.society.controller;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;

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


@WebServlet("/MemebershipSettlement")
public class MemberSettlement extends HttpServlet {


	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String incomingRequest = request.getParameter("req");
		Connection con=null;
		CallableStatement call=null,cs=null;
		JSONObject object=new JSONObject();
		HttpSession session = request.getSession();
		if(incomingRequest.equals("memSettlement")){
		try {
			String option=request.getParameter("option");
			String MemAccNo=request.getParameter("memAccNo");
			int settlementAmount=Integer.parseInt(request.getParameter("settlementAmount"));
			String settlementDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("date").trim()));
			String userId = (String) session.getAttribute("EMPLOYEECODE");
			String JsonData = request.getParameter("gridData").trim();
			System.out.println(JsonData);
			JSONArray jarr=new JSONArray(JsonData); 
			String depositno = "";
			for(int i=0;i<jarr.length();i++) {
				JSONObject jobj=jarr.getJSONObject(i);
				String deposit = jobj.getString("DepositNo");
				if(deposit.contains("FD") || deposit.contains("RD") || deposit.contains("MS"))
					depositno = deposit+","+depositno;
			}
			//System.out.println(depositno.substring(0, depositno.length()-1));
			if(depositno.length()>0)
				depositno=depositno.substring(0, depositno.length()-1);
			String querry="{call speccs.SP_MemberSettlement(?,?,?,?,?,?,?)}";
			//System.out.println(option+" "+MemAccNo+" "+settlementDate+" "+settlementAmount+" "+userId);
			   con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				call = con.prepareCall(querry);
				call.setString(1,"PROCESS");
	            call.setString(2,MemAccNo);
	            call.setString(3,settlementDate);
	            call.setString(4,depositno);
	            call.setString(5,userId);
	            call.setInt(6,settlementAmount);
	            call.registerOutParameter(7,java.sql.Types.VARCHAR);
	            
	            call.executeUpdate();
	            String receiptNo=call.getString(7);
	            /*ResultSet rs = call.executeQuery();
	            while(rs.next()){
	            	 receiptNo = call.getString(7);
	            	 if(receiptNo.contains("P"))
	            	object.put("msg", "Your Account is settled and Payment of "+settlementAmount+"  amount is generated with payment number "+receiptNo);
	            if(receiptNo.contains("R"))
	            	object.put("msg", "Your Account is settled and Receipt of "+settlementAmount+"  amount is generated with receipt number "+receiptNo);
	            
	            }*/
	            
	            object = new JSONObject();
	            object.put("receiptNo",receiptNo);
	            if(receiptNo.contains("P"))
	            	object.put("msg", "Your Account is settled and  payment number is generated with "+receiptNo);
	            if(receiptNo.contains("R"))
	            	object.put("msg", "Your Account is settled and  receipt number is generated with  "+receiptNo);
	            object.put("SUCCESS","Y");
		 
		}catch( Exception e){
			// TODO: handle exception
			object = new JSONObject();
			try {
				object.put("ERROR", e.getMessage());
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		finally{
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
		response.getWriter().write(object.toString());
        
	}

}
