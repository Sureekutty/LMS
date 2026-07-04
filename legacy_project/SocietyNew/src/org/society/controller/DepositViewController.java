package org.society.controller;

import static org.society.util.ReturnJsonObject.returnJsonObject;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.society.dto.MembershipDto;
import org.society.service.DepositService;
import org.society.service.GenericDetailsService;
import org.society.util.ConvertListToJSONArray;
import org.society.util.DataBaseConnectionForNewDB;
@SuppressWarnings("serial")
@WebServlet("/DepositView")
public class DepositViewController extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("EMPLOYEECODE");
	
		
		String incoming_Request = request.getParameter("req");
		Connection connection = null;
	
		JSONObject jsonObject3 = null;
		GenericDetailsService genericDetailsService = null;
		try {
			DepositService depositService = null;
			
			
			if(incoming_Request.equalsIgnoreCase("gettingdata")){
				
			String typeOfSearch = request.getParameter("typeOfSearch").toUpperCase();
			depositService = new DepositService();
			LinkedList<MembershipDto> memberInformation = depositService.getMemberInformation("", "",typeOfSearch,"");
			@SuppressWarnings("rawtypes")
			Collection collection = memberInformation;
			@SuppressWarnings("unchecked")
			JSONObject jsonObject = ConvertListToJSONArray.convertCollection(collection, "MEMBERS");
			returnJsonObject(jsonObject, response);
		  }
		
			
			if(incoming_Request.equalsIgnoreCase("depositstatuslist")){
				genericDetailsService = new GenericDetailsService();
				String depositMode = "depositstatus";
				LinkedList<Map<String,String>> depositstatus = genericDetailsService.getDepositstatus(depositMode );
				jsonObject3 = new JSONObject();
				jsonObject3.put("DEPOSITSSTATUS", depositstatus);
				jsonObject3.put("ERROR", "NO");
				returnJsonObject(jsonObject3, response);
			}
	    
		
		}
			catch(SQLException | JSONException | InstantiationException | IllegalAccessException | ClassNotFoundException e){
				e.printStackTrace();
			}
			
			catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
			finally {
				if(connection != null){
					try {
						connection.close();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		
		
		
}
}
