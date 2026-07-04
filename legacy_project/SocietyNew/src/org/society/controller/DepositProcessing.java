package org.society.controller;

import static org.society.util.ReturnJsonObject.returnJsonObject;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.society.service.GenericDetailsService;

@WebServlet("/depositProcessing")
public class DepositProcessing extends HttpServlet{


	private static final long serialVersionUID = 1L;
	
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String incomingRequest = request.getParameter("req");
		JSONObject jsonObject = null;
		Statement statement = null;
		
		GenericDetailsService genericDetailsService = null;
		try {
			if(incomingRequest.equalsIgnoreCase("processTypes")){
				genericDetailsService = new GenericDetailsService();
				String depositMode = "deposit";
				LinkedList<Map<String,String>> deposits = genericDetailsService.getDeposits(depositMode );
				jsonObject = new JSONObject();
				jsonObject.put("DEPOSITS", deposits);
				jsonObject.put("ERROR", "NO");
			}
			if(incomingRequest.equalsIgnoreCase("processloanNumbers")){
				genericDetailsService = new GenericDetailsService();
				String MemAccNO=request.getParameter("memaccno").trim();
				String loannumbers = "LOANPROCESSINFO";
				LinkedList<Map<String,String>> processloannumbers = genericDetailsService.getLoanNumbers(MemAccNO );
				jsonObject = new JSONObject();
				jsonObject.put("LOANNUMBERS", processloannumbers);
				jsonObject.put("ERROR", "NO");
			}
			
			if(incomingRequest.equals("getDepositNumbers")){
				
				String depositprocessTypes = request.getParameter("depositprocessTypes");
				
				genericDetailsService = new GenericDetailsService();
				LinkedList<Map<String,String>> depositDetails = genericDetailsService.getDepositDetails("all", depositprocessTypes, "SANCTION",null, null);
		
				jsonObject = new JSONObject();
				jsonObject.put("DEPOSITSDETAILS", depositDetails);
				jsonObject.put("ERROR", "NO");
			}
	      if(incomingRequest.equals("getDepositProcessReq")){
				
				String option = request.getParameter("option");
				
				genericDetailsService = new GenericDetailsService();
				LinkedList<Map<String,String>> asstproreq = genericDetailsService.getDepositAsstReq(option);
		
				jsonObject = new JSONObject();
				jsonObject.put("ASSTPROREQ", asstproreq);
				jsonObject.put("ERROR", "NO");
			}
			
			
			
		
		}
		catch(SQLException sqlException){
			sqlException.printStackTrace();
		}
		catch (Exception exception) {
			// TODO: handle exception
			exception.printStackTrace();
		}
		finally{
			if(null !=statement)
				try {
					statement.close();
					
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		returnJsonObject(jsonObject, response);
	}
	

}
