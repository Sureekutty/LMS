package org.society.controller;
import static org.society.util.ReturnJsonObject.returnJsonObject;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.society.util.DataBaseConnectionForNewDB;

@WebServlet("/recieptController")
public class RecieptProcessController extends HttpServlet {

	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException ,IOException {
	
		String IncomingReq=request.getParameter("req");
		HttpSession session = request.getSession();
		
		try {
			if(IncomingReq.equalsIgnoreCase("recieptList")) {
				
				String memCode = request.getParameter("memCode");
				String status=request.getParameter("status");
				
				
				
				Connection con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				CallableStatement call=con.prepareCall("{call SP_RecieptProcess (?,?,?,?,?,?,?)}");
			
				call.setString(1, "Reciept");
				call.setString(2, "");
				call.setString(3, "");
				call.setString(4, memCode );
				call.setString(5, status);
				call.setString(6, "");
				call.setString(7, "");
				
				
				ResultSet result = call.executeQuery();
				Map<String , String> map=null;
				LinkedList<Map<String, String>> list=new LinkedList<Map<String, String>>();
				while(result.next()) {
					map=new HashMap<String, String>();
					map.put("reciept", result.getString("ReceiptNo")+"-"+result.getString("ReceiptDate"));
					map.put("PurposeCode", result.getString("PurposeCode"));
					list.add(map );
				}
				JSONObject jsonObject=new JSONObject();
				jsonObject.put("reciept", list);
				returnJsonObject(jsonObject, response);
				if(con!=null){
				con.close();
				}
			}
			
			if(IncomingReq.equalsIgnoreCase("recieptDetail")) {
				
				String recieptNo = request.getParameter("recieptNo");
				String paycode = request.getParameter("paycode");
				String memCode=request.getParameter("memCode");
				
				Connection con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				CallableStatement call=con.prepareCall("{call SP_RecieptProcess (?,?,?,?,?,?,?)}");
				
				call.setString(1, "ReciDetail");
				call.setString(2, "");
				call.setString(3, paycode);
				call.setString(4, memCode );
				call.setString(5, "");
				call.setString(6, recieptNo);
				call.setString(7, "");
			
				ResultSet result = call.executeQuery();
				
				LinkedList list=new LinkedList();
				while(result.next()) {
					list.add(result.getString("ModeOfPayment"));
					list.add(result.getDouble("Amount"));
					list.add(result.getString("RuleDescription"));						
				}
				
				JSONObject jsonObject=new JSONObject();
				jsonObject.put("success", "Y");
				jsonObject.put("ReciDetail", list);
				returnJsonObject(jsonObject, response);
				if(con!=null){
					con.close();
				}
				
			}
			
			
			if(IncomingReq.equalsIgnoreCase("Cancellation")) {
				
				String recieptNo=request.getParameter("recieptNo");
				String Option=request.getParameter("option");
				String memCode=request.getParameter("memCode");
				String userId = (String) session.getAttribute("EMPLOYEECODE");
				
				
				String ipaddress=request.getRemoteHost();
				
				Connection con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				CallableStatement call=con.prepareCall("{call SP_RecieptProcess (?,?,?,?,?,?,?)}");
				
				call.setString(1, Option);
				call.setString(2, userId);
				call.setString(3, "");
				call.setString(4, memCode);
				call.setString(5, "");
				call.setString(6, recieptNo);
				call.setString(7, ipaddress);
				
				int update=call.executeUpdate();
				if(update>0) {
					JSONObject jsonObject=new JSONObject();
					jsonObject.put("success", "Y");
					returnJsonObject(jsonObject, response);
				}
				if(con!=null){
					con.close();
				}
				
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		
	}
	
	
}
