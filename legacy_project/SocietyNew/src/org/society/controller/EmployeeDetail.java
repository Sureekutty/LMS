package org.society.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.society.service.GenericDetailsService;
import org.society.service.LoanApplicationService;
import org.society.util.DataBaseConnectionForNewDB;

@SuppressWarnings("serial")
@WebServlet("/EmployeeDetail")
public class EmployeeDetail extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String inComingRequest = request.getParameter("req");		
		JSONObject jsonObject = null;		
		Connection connection = null;
		Statement  statement5 = null;
		HttpSession session = request.getSession();
		
		if(inComingRequest.equals("Loan")) {
			
			String empCode = (String) session.getAttribute("EMPLOYEECODE");
			try {
				connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
				Statement statement = connection.createStatement();
				String sqlQuery="speccs.SP_Loans 'GETLTLINFO','"+empCode+"'";
			} catch (InstantiationException | IllegalAccessException | ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
