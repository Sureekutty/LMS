package org.society.controller;

import static org.society.util.ReturnJsonObject.returnJsonObject;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Collection;
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
import org.society.dto.MembershipDto;
import org.society.dto.ReceiptDto;
import org.society.service.DepositService;
import org.society.util.ConvertListToJSONArray;
import org.society.util.DataBaseConnectionForNewDB;
@SuppressWarnings("serial")
@WebServlet("/ReceiptView")
public class ReceiptViewController extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("EMPLOYEECODE");
		
		String incoming_Request = request.getParameter("req");
		Connection connection = null;
		
		try {
			DepositService depositService = null;
			
			
			if(incoming_Request.equalsIgnoreCase("gettingdata")){
				
			String typeOfSearch = request.getParameter("typeOfSearch").toUpperCase();			
			String fromDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("recfromdate").trim()));
			
			String toDate =new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("rectodate").trim()));
			depositService = new DepositService();
			LinkedList<ReceiptDto> memberInformation = depositService.getMemberInformationReceipt(fromDate,toDate,"", "",typeOfSearch,"");
			//new ReceiptDto().setMemAccno(memberInformation.get(1)+"-"+memberInformation.get(2));
			@SuppressWarnings("rawtypes")
			Collection collection = memberInformation;
			@SuppressWarnings("unchecked")
			JSONObject jsonObject = ConvertListToJSONArray.convertCollection(collection, "RECEIPTS");
			returnJsonObject(jsonObject, response);
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
