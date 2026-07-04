package org.society.controller;

import static org.society.util.ReturnJsonObject.returnJsonObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.LinkedList;

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
import org.society.dto.MembershipDto;
import org.society.service.MemberService;
import org.society.util.ConvertListToJSONArray;
import org.society.util.DataBaseConnectionForNewDB;
@SuppressWarnings("serial")
@WebServlet("/MembersView")
public class MembersViewController extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("EMPLOYEECODE");
	
		String incoming_Request = request.getParameter("req");
		PrintWriter out = response.getWriter();

		try {
			MemberService memberService = null;
			
			if(incoming_Request.equalsIgnoreCase("searchAppl")){
				String typeOfSearch = request.getParameter("typeOfSearch").toUpperCase();
				
				memberService = new MemberService();
				LinkedList<MembershipDto> applicationInformation = memberService.getApplicationInformation("","SOCIETYMEM",typeOfSearch,"");
				@SuppressWarnings("rawtypes")
				Collection collection = applicationInformation;
				@SuppressWarnings("unchecked")
				JSONObject jsonObject = ConvertListToJSONArray.convertCollection(collection, "APPLICATION");
				returnJsonObject(jsonObject, response);
			  }
			if(incoming_Request.equalsIgnoreCase("staffsearchAppl")){
				String typeOfSearch = request.getParameter("typeOfSearch").toUpperCase();
				
				memberService = new MemberService();
				LinkedList<MembershipDto> applicationInformation = memberService.getApplicationInformationstaff("","STAFFMEM",typeOfSearch,"");
				@SuppressWarnings("rawtypes")
				Collection collection = applicationInformation;
				@SuppressWarnings("unchecked")
				JSONObject jsonObject = ConvertListToJSONArray.convertCollection(collection, "APPLICATION");
				returnJsonObject(jsonObject, response);
			  }
			
			
			
			if(incoming_Request.equalsIgnoreCase("searchAll")){
				
			
				
			String typeOfSearch = request.getParameter("typeOfSearch").toUpperCase();
			memberService = new MemberService();
			LinkedList<MembershipDto> memberInformation = memberService.getMemberInformation("NONE", "SOCIETYMEM",typeOfSearch,"");
			@SuppressWarnings("rawtypes")
			Collection collection = memberInformation;
			@SuppressWarnings("unchecked")
			JSONObject jsonObject = ConvertListToJSONArray.convertCollection(collection, "MEMBERS");
			returnJsonObject(jsonObject, response);
		  }
			
			
			
			
			
			if(incoming_Request.equals("updateMembership")){
				String Option = request.getParameter("Option");
				String Remarks = request.getParameter("Remarks");
				String memAccnountNumber = request.getParameter("memAccnountNumber");
				String memcode = request.getParameter("memcode");
				Connection connection = null;
				String ipaddress=request.getRemoteHost();
				String sqlQuery = "{call speccs.SP_MembersViewOperation(?,?,?,?,?,?)}";
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				CallableStatement cStatement = connection.prepareCall(sqlQuery);
				cStatement.setString(1, Option);
				cStatement.setString(2, memAccnountNumber);
				cStatement.setString(3, userId);
				cStatement.setString(4, Remarks);
				cStatement.setString(5, memcode);
				cStatement.setString(6, ipaddress);
				
				int executeUpdate = cStatement.executeUpdate();
			
				JSONObject jsonObject =new JSONObject();
				String msg = "ERROR WHILE UPDATION";
				if(executeUpdate > 0){
					
					if(Option.equalsIgnoreCase("CANCEL"))
						msg = memAccnountNumber+" Membership has been canceled";
					if(Option.equalsIgnoreCase("REGISTER"))
						msg = memAccnountNumber+" Membership has been Activated";
				}
				jsonObject.put("Updation", msg);
				returnJsonObject(jsonObject, response);
				if(connection!=null){
					connection.close();
				}
			 
			}
			
			
	          if (incoming_Request.equals("MemGenpdfform")) {
				String membersonly="MEM";
				String MemAccNO = request.getParameter("accNo");

				ServletContext ctx=getServletContext();
				 String header=ctx.getInitParameter("HEADER");
				 String number=ctx.getInitParameter("NUMBERS");
				
				
				MemberDetailspdf.getPDF(MemAccNO,membersonly,header,number);
				String fileName = "MemberDetailspdf.pdf";
				response.setContentType("application/pdf");

				File file1 = new File(fileName);
				response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
				response.setContentLength((int) file1.length());
				FileInputStream fis = new FileInputStream(file1);
				int len = (int) file1.length();

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
	 		 if (incoming_Request.equals("MemGenpdfformDetails")) {
			
					String accNo = request.getParameter("accNo");
					ServletContext ctx=getServletContext();
					 String header=ctx.getInitParameter("HEADER");
					 String number=ctx.getInitParameter("NUMBERS");

					MemDetailspdf.getPDF(accNo,header,number);
					String fileName = "MemDetailspdf.pdf";
					response.setContentType("application/pdf");

					File file1 = new File(fileName);
					response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
					response.setContentLength((int) file1.length());
					FileInputStream fis = new FileInputStream(file1);
					int len = (int) file1.length();

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
	 		 if (incoming_Request.equals("staffmemDetails")) {
	 			
					String accNo = request.getParameter("accNo");
					ServletContext ctx=getServletContext();
					 String header=ctx.getInitParameter("HEADER");
					 String number=ctx.getInitParameter("NUMBERS");

					StaffMemDetailspdf.getPDF(accNo,header,number);
					String fileName = "StaffMemDetailspdf.pdf";
					response.setContentType("application/pdf");

					File file1 = new File(fileName);
					response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
					response.setContentLength((int) file1.length());
					FileInputStream fis = new FileInputStream(file1);
					int len = (int) file1.length();

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
	 		
	 		 if (incoming_Request.equals("bankinfo")) {
	 			Connection connection1 = null;
					String memaccno = request.getParameter("memaccno");
					JSONObject jsonObject1 = new JSONObject();
					String sqlQuery = "speccs.SP_MemberDetails '','BANKINFO','','"+memaccno+"'";
					connection1 = DataBaseConnectionForNewDB.getConnectionForSyBase();
					PreparedStatement ps2 = connection1.prepareStatement(sqlQuery);
					ResultSet res = ps2.executeQuery();
					JSONArray array = new JSONArray();
                           if(res.next()){
                        	String Bankaccno=res.getString("Bankaccno");
               				String Ifsccode=res.getString("Ifsccode");
               				String Bankname=res.getString("Bankname");
               				String Bankplace=res.getString("Bankplace");
               				if(Bankaccno==null) Bankaccno="";
            				if(Ifsccode==null) Ifsccode="";
            				if(Bankname==null) Bankname="";
            				if(Bankplace==null) Bankplace="";
            				
            				jsonObject1.put("Bankaccno", Bankaccno);
            				jsonObject1.put("Ifsccode", Ifsccode);
            				jsonObject1.put("Bankname", Bankname);
            				jsonObject1.put("Bankplace", Bankplace);
            				array.put(jsonObject1);  
                           }
                       	jsonObject1 = new JSONObject();
            			jsonObject1.put("Bankinfo", array);
//            			System.out.println("Bankinfo "+jsonObject1.toString());
            			response.getWriter().write(jsonObject1.toString());
            			if(connection1!=null){
            				connection1.close();
            			}
            			
            			
				           }
	 		
			
			
		}
		catch(SQLException e){
			boolean b=e.getMessage().contains("Canceling member present in surety table");
			String errMsg="Cancelling Member is not Possible because \n he has given surety to a person for taking loan";
		String msg=null;
		if(b){
			msg=errMsg;
		}
		JSONObject json=new JSONObject();
		try {
			json.put("Updation", msg);
			returnJsonObject(json, response);
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		
		}
			catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
		
		
		
		
}
}
