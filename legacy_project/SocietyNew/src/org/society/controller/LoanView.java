package org.society.controller;

import static org.society.util.ReturnJsonObject.returnJsonObject;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.society.dao.LoanApplicationDAO;
import org.society.dto.LoanAppDto;
import org.society.dto.MembershipDto;
import org.society.service.MemberService;
import org.society.util.ConvertListToJSONArray;
import org.society.util.DataBaseConnectionForNewDB;
import org.society.util.TimeDifference;

@WebServlet("/LoanView")
public class LoanView  extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String incomingRequest = request.getParameter("req");
		
		LoanApplicationDAO applicationDAO = null;
		
		JSONObject jsonObject = null;
		HttpSession session = request.getSession();
		try {
		
			if(incomingRequest.equals("searchAll")){
				
				String type = request.getParameter("typeOfSearch");
			
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> loanDetails = applicationDAO.getLoanDetailsactive("", "", "LOANSOCIETYMEM", type);
				jsonObject = new JSONObject();
				jsonObject.put("LoanDetails", loanDetails);
			}
        if(incomingRequest.equals("searchViewAll")){
				
				String type = request.getParameter("type");
//				System.out.println(type);
			if(type.equals("FRESH")){
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> loanDetails = applicationDAO.getLoanDetailsactive("", "", "LOANVIEW", "");
//				for(LoanAppDto l:loanDetails) {
//					System.out.println(l.getBankaccno());
//				}
				jsonObject = new JSONObject();
				jsonObject.put("LoanDetails", loanDetails);
			}else if(type.equals("SANCTION")){
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> loanDetails = applicationDAO.getLoanDetailsactive("", "", "LOANVIEWSANCTION", "");
				jsonObject = new JSONObject();
				jsonObject.put("LoanDetails", loanDetails);
			}else if(type.equals("RELINIT")){
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> loanDetails = applicationDAO.getLoanDetailsactive("", "", "LOANVIEWRELINIT", "");
				jsonObject = new JSONObject();
				jsonObject.put("LoanDetails", loanDetails);
			}
			else if(type.equals("REJECT")){
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> loanDetails = applicationDAO.getLoanDetailsactive("", "", "LOANVIEWREJECTED", "");
				jsonObject = new JSONObject();
				jsonObject.put("LoanDetails", loanDetails);
			}else if(type.equals("RELEASE")){
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> loanDetails = applicationDAO.getLoanDetailsactive("", "", "LOANVIEWRELEASED", "");
				jsonObject = new JSONObject();
				jsonObject.put("LoanDetails", loanDetails);
			}
			else if(type.equals("SETTLED")){
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> loanDetails = applicationDAO.getLoanDetailsactive("", "", "LOANVIEWSETTLED", "");
				jsonObject = new JSONObject();
				jsonObject.put("LoanDetails", loanDetails);
			}
			}
			
			if(incomingRequest.equals("searchAppl")){
				String typeOfSearch = request.getParameter("typeOfSearch").toUpperCase();
				
				applicationDAO = new LoanApplicationDAO();
				List<LoanAppDto> applicationInformation = applicationDAO.getApplicationInformation("","LOANSOCIETYMEM",typeOfSearch,"");
				jsonObject = new JSONObject();
				jsonObject.put("LoanApplDetails", applicationInformation);
				
			}
		
						
		} 
		catch(SQLException sqlException){
			sqlException.printStackTrace();
			jsonObject = new JSONObject();
			try {
				jsonObject.put("ERROR", sqlException.getMessage());
				System.out.println("sqlException.getMessage()  "+sqlException.getMessage());
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			try {
				jsonObject.put("ERROR", e.getMessage());
				System.out.println("e.getMessage()  "+e.getMessage());
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		response.getWriter().write(jsonObject.toString());
	}
}
