package org.society.controller;



import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.society.service.GenericDetailsService;
import org.society.util.DataBaseConnectionForNewDB;



@SuppressWarnings("serial")
@WebServlet("/DailyAccountsProcessing")
public class DailyAccountsProcessing extends HttpServlet {

	@SuppressWarnings("resource")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection connection = null;
		CallableStatement cs1 = null;
		
		JSONObject jsonObject = null;
		HttpSession session = request.getSession();
		PrintWriter out=response.getWriter();
		String userID = (String) session.getAttribute("EMPLOYEECODE");
		try {
	
			String incomingRequest = request.getParameter("req");
			
               if(incomingRequest.equals("acountsprocessing")){
            	   try {
				connection  = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String porocessdate = request.getParameter("porocessdate");
				String option = request.getParameter("option");
				
	                String 	sqlQuery1 =	"{call speccs.SP_DailyAccountsProcessing(?,?,?,?,?,?,?)}";
				
				CallableStatement cStatement1 = connection.prepareCall(sqlQuery1);
				cStatement1.setString(1, option);
				cStatement1.setString(2, porocessdate);
				cStatement1.setInt(3, 5);
				cStatement1.setFloat(4, 547);
				cStatement1.setString(5, userID);
				cStatement1.setString(6, "");
				cStatement1.setString(7, "");
				cStatement1.executeUpdate();
			
				jsonObject = new JSONObject();
				jsonObject.put("success", "y");
				response.getWriter().write(jsonObject.toString());
				if(connection!=null){
		     		connection.close();
		     	}
            	}catch (Exception e) {
       				e.printStackTrace();
    				if(connection!=null){
    		     		connection.close();
    		     	}
    			}
				}
				
				 if (incomingRequest.equals("regreport")) {
					
						String processsdate = request.getParameter("processsdate");
					
						ServletContext ctx=getServletContext();
						 String header=ctx.getInitParameter("HEADER");
						 String number=ctx.getInitParameter("NUMBERS");
						 
						 DailyAccountsProcessingpdf.getPDF(processsdate,header,number);
						String fileName = "Dailyaccountsprocesspdf.pdf";
						response.setContentType("application/pdf");

						File file1 = new File(fileName);
						response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
						response.setContentLength((int) file1.length());
						FileInputStream fis = new FileInputStream(file1);
						out.flush();
						int temp;

						while ((temp = fis.read()) != -1) {
							out.write(temp);
							out.flush();

						}

						out.close();
						fis.close();
						return;

					}
				
				
				
			
		} catch (Exception e) {
			e.printStackTrace();
			
			
		} finally {
			try {
			} catch (Exception e1) {

				e1.printStackTrace();
			}
		}
	
		}
}
