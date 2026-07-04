package org.society.controller;

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
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

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

import org.society.controller.ApplicationforsharesandmembershipPdf;


@WebServlet("/Membership")
public class MembershipController extends HttpServlet{

	private static final long serialVersionUID = 1L;

	@SuppressWarnings({ "unchecked", "rawtypes", "resource" })
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, NumberFormatException {
		Connection connection = null;
	
		Statement  statement = null;
		JSONObject jsonObject = null;
		JSONObject jsonObject1 = null;
		CallableStatement cStatement=null;
		
		try{
		
			//connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		String memEmployeeCode=null;
		JSONArray array=null;
		String ApplNo="";
	
		String incoming_Request = request.getParameter("req");
		MemberService memberService = null;
		
			if(incoming_Request.equals("getMemberInfo")){
				try {
			 memEmployeeCode = request.getParameter("sel");
			String option = request.getParameter("option");
			 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection.createStatement();
			
			String sqlQuery= "speccs.SP_MemberDetails '"+memEmployeeCode+"','"+option+"','',''";
		
		PreparedStatement ps3 = connection.prepareStatement(sqlQuery);
		ResultSet rsEmployeeCodeList = ps3.executeQuery();
		
					 array = new JSONArray();
			
			if(rsEmployeeCodeList.next()){
				jsonObject = new JSONObject();
				String EMPLOYEECODE=rsEmployeeCodeList.getString("MemEmpCode");
				String EMPLOYEENAME=rsEmployeeCodeList.getString("MemName");
				String DIVNFULLNAME=rsEmployeeCodeList.getString("Division");
				String DESGFULLNAME=rsEmployeeCodeList.getString("Designation");
				int BASICPAY=rsEmployeeCodeList.getInt("BasicPay");
				String DATEOFBIRTH=rsEmployeeCodeList.getString("Dob").substring(0, 10);
				String RETIREDDATE=rsEmployeeCodeList.getString("RetiredDate").substring(0, 10);
				

				if(EMPLOYEECODE==null) EMPLOYEECODE="";
				if(EMPLOYEENAME==null) EMPLOYEENAME="";
				if(DIVNFULLNAME==null) DIVNFULLNAME="";
				if(DESGFULLNAME==null) DESGFULLNAME="";
				if(DATEOFBIRTH==null) DATEOFBIRTH="";
				else DATEOFBIRTH=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("Dob"));
				if(RETIREDDATE==null) RETIREDDATE="";
				else RETIREDDATE=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("RetiredDate"));
				

				jsonObject.put("EMPLOYEECODE", EMPLOYEECODE.trim());
				jsonObject.put("EMPLOYEENAME", EMPLOYEENAME.trim());
				jsonObject.put("DIVNFULLNAME", DIVNFULLNAME.trim());
				jsonObject.put("DESGFULLNAME", DESGFULLNAME.trim());
				jsonObject.put("BASICPAY", BASICPAY);
				jsonObject.put("DATEOFBIRTH", DATEOFBIRTH.trim());
				jsonObject.put("RETIREDDATE", RETIREDDATE.trim());
				array.put(jsonObject);
			}
			
			statement = connection.createStatement();
			String sqlQuery1="speccs.SP_MemberDetails '"+memEmployeeCode+"','MEMINFO','',''";
			
			
          
			PreparedStatement ps5 = connection.prepareStatement(sqlQuery1);
			ResultSet PrerslInfo = ps5.executeQuery();
		
			JSONArray array1 = new JSONArray();
			
			
			if(PrerslInfo.next()){
				
				jsonObject1 = new JSONObject();
				ApplNo=PrerslInfo.getString("MemAccNo");
				String EmpCode=PrerslInfo.getString("MemEmpCode");
				String PanNo=PrerslInfo.getString("PanNo");
				String AadharNo=PrerslInfo.getString("AadharNo");
				String MailId=PrerslInfo.getString("MailId");
				String Phone=PrerslInfo.getString("Phone");
				String OffPhone=PrerslInfo.getString("OffPhone");
			
				String CareOf=PrerslInfo.getString("CareOf");
				String Remarks=PrerslInfo.getString("Remarks");
				
			
				
				if(ApplNo==null) ApplNo="";
				if(EmpCode==null) EmpCode="";
				if(PanNo==null) PanNo="";
				if(AadharNo==null) AadharNo="";
				if(MailId==null) MailId="";
				if(Phone==null) Phone="";
				if(OffPhone==null) OffPhone="";
	
				if(CareOf==null) CareOf="";
				if(Remarks==null) Remarks="";
				
				
				jsonObject1.put("ApplNo", ApplNo.trim());
				jsonObject1.put("EmpCode", EmpCode.trim());
				jsonObject1.put("PanNo", PanNo.trim());
				jsonObject1.put("AadharNo", AadharNo.trim());
				jsonObject1.put("MailId", MailId.trim());
				jsonObject1.put("Phone", Phone.trim());
				jsonObject1.put("OffPhone", OffPhone.trim());
			
				jsonObject1.put("CareOf", CareOf.trim());
				jsonObject1.put("Remarks", Remarks);
				array1.put(jsonObject1);
			}
                 statement = connection.createStatement();
             	JSONArray array2 = new JSONArray();

			String sqlQuery2 ="speccs.SP_MemberDetails '','APPLINFO','','"+ApplNo+"'";
        
			ResultSet societyInfo=statement.executeQuery(sqlQuery2);
		
			if(societyInfo.next()){
				jsonObject = new JSONObject();
				
				int ThriftSubscriptionAmount=societyInfo.getInt("ThriftSubscriptionAmount");
				int ThriftBalance=societyInfo.getInt("ThriftBalance");
				int ShareAmount=societyInfo.getInt("ShareAmount");
				int NoOfShares=societyInfo.getInt("NoOfShares");
				
				
			
				jsonObject.put("ThriftSubscriptionAmount", ThriftSubscriptionAmount);
				jsonObject.put("ThriftBalance", ThriftBalance);
				jsonObject.put("ShareAmount", ShareAmount);
				jsonObject.put("NoOfShares", NoOfShares);
				array2.put(jsonObject);
			}
			
		    statement = connection.createStatement();
	
		    
		    
	sqlQuery = "speccs.SP_Bankdetails 'GRIDDATA','"+ApplNo+"','','','','','','',''";
	
			PreparedStatement ps6 = connection.prepareStatement(sqlQuery);
			ResultSet res2 = ps6.executeQuery();
			
			JSONArray array5 = new JSONArray();
			while (res2.next()) {
				
				jsonObject = new JSONObject();
				String Bankaccno=res2.getString("Bankaccno").trim();
				String Ifsccode=res2.getString("Ifsccode").trim();
				String Bankname=res2.getString("Bankname").trim();
				String Bankplace=res2.getString("Bankplace").trim();
				
				
				
				jsonObject.put("BankAccNo", Bankaccno.trim());
				jsonObject.put("Ifsccode", Ifsccode.trim());
				jsonObject.put("Bankname", Bankname.trim());
				jsonObject.put("Bankplace", Bankplace.trim());
				
				array5.put(jsonObject);	
			}
		    
		    
		    
			sqlQuery = "speccs.SP_Nominee 'GRIDDATA','"+ApplNo+"','','','','','','','','','',''";
			
			PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
			ResultSet res = ps2.executeQuery();
			
			JSONArray array3 = new JSONArray();
			while (res.next()) {
				
				jsonObject = new JSONObject();
				String NomineeId=res.getString("NomineeId").trim();
				String NomineeName=res.getString("NomName").trim();
				String Dob=res.getString("NomDOB").trim();
				String Relation=res.getString("Relationship");
				String Gender=res.getString("Gender");
				String Address=res.getString("Address");
				jsonObject.put("NomineeId", NomineeId.trim());
				jsonObject.put("NomineeName", NomineeName.trim());
				jsonObject.put("Dob", Dob.trim());
				jsonObject.put("Relation", Relation.trim());
				jsonObject.put("Gender", Gender.trim());
				jsonObject.put("Address", Address.trim());
				array3.put(jsonObject);	
			}
		
			
			
			String  sqlQuery4 = "speccs.SP_MemAddress 'GRIDDATA','"+ApplNo+"','','','','','','','','','','',''";
			
			PreparedStatement ps4 = connection.prepareStatement(sqlQuery4);
			ResultSet res1 = ps4.executeQuery();
			
			JSONArray array4 = new JSONArray();
			
			while (res1.next()) {
				jsonObject = new JSONObject();
				
				String AddressId=res1.getString("MemberId");
				String Address1=res1.getString("Address1").trim();
				String Address2=res1.getString("Address2").trim();
				String City=res1.getString("City");
				String District=res1.getString("District");
				String State=res1.getString("State");
				String Pincode=res1.getString("Pincode");
				String Remarks=res1.getString("Remarks");
				
		
				jsonObject.put("AddressId", AddressId.trim());
				jsonObject.put("Address1", Address1.trim());
				jsonObject.put("Address2", Address2.trim());
				jsonObject.put("City", City.trim());
				jsonObject.put("District", District.trim());
				jsonObject.put("State", State.trim());
				jsonObject.put("Pincode", Pincode.trim());
				jsonObject.put("Remarks", Remarks.trim());
				array4.put(jsonObject);	
			
			}
			
			jsonObject = new JSONObject();
		
			jsonObject.put("empDetails", array);
			jsonObject.put("personalDetails", array1);
			jsonObject.put("societyDetails", array2);
			jsonObject.put("bankDetails", array5);
			jsonObject.put("nomineeDetails", array3);
			jsonObject.put("addDetails", array4);
			jsonObject.put("success", "y");
			response.getWriter().write(jsonObject.toString());
			if(connection!=null){
			 connection.close();
			}
		
		}catch(Exception e2){
				System.out.println("  EXCEPTION     "+e2);
			
				e2.printStackTrace();
				if(connection!=null){
					 connection.close();
					}
			
			}
			}
			//-------------------------------------------------//
			if(incoming_Request.equals("staffgetMemberInfo")){
				try {
			 memEmployeeCode = request.getParameter("sel");
			String option = request.getParameter("option");
			 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection.createStatement();
			
			String sqlQuery= "speccs.SP_MemberDetails '','"+option+"','','"+memEmployeeCode+"'";
	
		PreparedStatement ps3 = connection.prepareStatement(sqlQuery);
		ResultSet rsEmployeeCodeList = ps3.executeQuery();
		
					 array = new JSONArray();
			
			if(rsEmployeeCodeList.next()){
				jsonObject = new JSONObject();
				ApplNo=rsEmployeeCodeList.getString("SMemAccNo");
				String EMPLOYEENAME=rsEmployeeCodeList.getString("SEmpName");
				int BASICPAY=rsEmployeeCodeList.getInt("BasicPay");
				String DATEOFBIRTH=rsEmployeeCodeList.getString("Dob").substring(0, 10);
				if(ApplNo==null) ApplNo="";
				if(EMPLOYEENAME==null) EMPLOYEENAME="";
				if(DATEOFBIRTH==null) DATEOFBIRTH="";
				else DATEOFBIRTH=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("Dob"));
				
				String PanNo=rsEmployeeCodeList.getString("PanNo");
				String AadharNo=rsEmployeeCodeList.getString("AdhaarNo");
				String MailId=rsEmployeeCodeList.getString("MailId");
				String Phone=rsEmployeeCodeList.getString("Phone");
				String OffPhone=rsEmployeeCodeList.getString("OfficePhone");
				String CareOf=rsEmployeeCodeList.getString("CareOf");
				String Remarks=rsEmployeeCodeList.getString("Remarks");
				
				jsonObject.put("PANNO", PanNo.trim());
				jsonObject.put("AADHAR", AadharNo.trim());
				jsonObject.put("MAILOID", MailId);
				jsonObject.put("PHONE", Phone.trim());
				jsonObject.put("OFFICEPHONE", OffPhone.trim());
				jsonObject.put("CAREOF", CareOf.trim());
				jsonObject.put("REMARKS", Remarks);
				jsonObject.put("EMPACCNO", ApplNo.trim());
				jsonObject.put("EMPLOYEENAME", EMPLOYEENAME.trim());
				jsonObject.put("BASICPAY", BASICPAY);
				jsonObject.put("DATEOFBIRTH", DATEOFBIRTH.trim());
				array.put(jsonObject);
			}
                 statement = connection.createStatement();
             	JSONArray array2 = new JSONArray();

			String sqlQuery2 ="speccs.SP_MemberDetails '','APPLINFO','','"+ApplNo+"'";
        
			ResultSet societyInfo=statement.executeQuery(sqlQuery2);
		
			if(societyInfo.next()){
				jsonObject = new JSONObject();
				
				int ThriftSubscriptionAmount=societyInfo.getInt("ThriftSubscriptionAmount");
				int ThriftBalance=societyInfo.getInt("ThriftBalance");
				int ShareAmount=societyInfo.getInt("ShareAmount");
				int NoOfShares=societyInfo.getInt("NoOfShares");
				jsonObject.put("ThriftSubscriptionAmount", ThriftSubscriptionAmount);
				jsonObject.put("ThriftBalance", ThriftBalance);
				jsonObject.put("ShareAmount", ShareAmount);
				jsonObject.put("NoOfShares", NoOfShares);
				array2.put(jsonObject);
			}
			
		    statement = connection.createStatement();
	sqlQuery = "speccs.SP_Bankdetails 'GRIDDATA','"+ApplNo+"','','','','','','',''";
		
			PreparedStatement ps6 = connection.prepareStatement(sqlQuery);
			ResultSet res2 = ps6.executeQuery();
			
			JSONArray array5 = new JSONArray();
			while (res2.next()) {
				
				jsonObject = new JSONObject();
				String Bankaccno=res2.getString("Bankaccno").trim();
				String Ifsccode=res2.getString("Ifsccode").trim();
				String Bankname=res2.getString("Bankname").trim();
				String Bankplace=res2.getString("Bankplace").trim();
				
				
				
				jsonObject.put("BankAccNo", Bankaccno.trim());
				jsonObject.put("Ifsccode", Ifsccode.trim());
				jsonObject.put("Bankname", Bankname.trim());
				jsonObject.put("Bankplace", Bankplace.trim());
				
				array5.put(jsonObject);	
			}
		    
			String  sqlQuery4 = "speccs.SP_MemAddress 'GRIDDATA','"+ApplNo+"','','','','','','','','','','',''";
			
			PreparedStatement ps4 = connection.prepareStatement(sqlQuery4);
			ResultSet res1 = ps4.executeQuery();
			
			JSONArray array4 = new JSONArray();
			
			while (res1.next()) {
				jsonObject = new JSONObject();
				
				String AddressId=res1.getString("MemberId");
				String Address1=res1.getString("Address1").trim();
				String Address2=res1.getString("Address2").trim();
				String City=res1.getString("City");
				String District=res1.getString("District");
				String State=res1.getString("State");
				String Pincode=res1.getString("Pincode");
				String Remarks=res1.getString("Remarks");
				
		
				jsonObject.put("AddressId", AddressId.trim());
				jsonObject.put("Address1", Address1.trim());
				jsonObject.put("Address2", Address2.trim());
				jsonObject.put("City", City.trim());
				jsonObject.put("District", District.trim());
				jsonObject.put("State", State.trim());
				jsonObject.put("Pincode", Pincode.trim());
				jsonObject.put("Remarks", Remarks.trim());
				array4.put(jsonObject);	
			
			}
			
			jsonObject = new JSONObject();
		
			jsonObject.put("empDetails", array);
			jsonObject.put("societyDetails", array2);
			jsonObject.put("bankDetails", array5);
			jsonObject.put("addDetails", array4);
			jsonObject.put("success", "y");
			response.getWriter().write(jsonObject.toString());
			if(connection!=null){
			 connection.close();
			}
		
		}catch(Exception e2){
				System.out.println("  EXCEPTION     "+e2);
				e2.printStackTrace();
				if(connection!=null){
					 connection.close();
					}
			
			}
			}
			
			//---------------------- getting member info ------------------------
			if(incoming_Request.equals("memInfo")){
				try{
					
				String memAccNo = request.getParameter("memAccNo");
				String code = request.getParameter("code");
				String loanType = "";//(code.equals("L25") || code.equals("L26"))?"":"";
				String query="";
				if(code.equals("L25") || code.equals("L26") || code.equals("L27")) {
						loanType = "LTL";
						query="Select mem.MemAccNo,convert(VARCHAR,mem.MemDate,103) AS Memdate,loan.LoanAccNo AS ShareAmount,loan.LoanSanctionAmount AS ThriftBalance FROM speccs.Members mem,speccs.Loans loan WHERE mem.MemAccNo='"+memAccNo+"' AND mem.MemAccNo=loan.MemAccNo AND  loan.LoanStatus='RELEASED' AND loan.LoanType LIKE '"+loanType+"%'";
				}
				else if(code.equals("L30") || code.equals("L31") || code.equals("L32")) {
						loanType = "EXL";
						query="Select mem.MemAccNo,convert(VARCHAR,mem.MemDate,103) AS Memdate,loan.LoanAccNo AS ShareAmount,loan.LoanSanctionAmount AS ThriftBalance FROM speccs.Members mem,speccs.Loans loan WHERE mem.MemAccNo='"+memAccNo+"' AND mem.MemAccNo=loan.MemAccNo AND  loan.LoanStatus='RELEASED' AND loan.LoanType LIKE '"+loanType+"%'";
				}
				else {
					query="Select mem.MemAccNo,convert(VARCHAR,mem.MemDate,103) AS Memdate,memAcc.ShareAmount,memAcc.ThriftBalance FROM speccs.Members mem,speccs.MemberAccount memAcc WHERE mem.MemAccNo='"+memAccNo+"' AND mem.MemAccNo=memAcc.MemAccNo";
				}
				//System.out.println("query "+query);
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				statement = connection.createStatement();
				
				
				PreparedStatement ps2 = connection.prepareStatement(query);
				
				ResultSet rs = ps2.executeQuery();
				
				 JSONArray arrayData = new JSONArray();
				if(rs.next()){
					jsonObject=new JSONObject();
					jsonObject.put("MemAccNo",rs.getString("MemAccNo"));
					jsonObject.put("MemDate",rs.getString("MemDate"));
					jsonObject.put((loanType.equals("LTL") || loanType.equals("EXL"))?"appNumber":"ShareAmount",rs.getString("ShareAmount"));
					jsonObject.put((loanType.equals("LTL") || loanType.equals("EXL"))?"prvAmount":"ThriftBalance",rs.getString("ThriftBalance"));	
					arrayData.put(jsonObject);
					
				}
//				System.out.println(arrayData.toString());
				jsonObject = new JSONObject();
				jsonObject.put("empInfo", arrayData);
				jsonObject.put("success", "y");
				
				response.getWriter().write(jsonObject.toString());
				if(connection!=null){
				 connection.close();
				}
				}
				catch(Exception e){
					System.out.println("  Exception in getting Member Info  "+e);
					e.printStackTrace();
					if(connection!=null){
						 connection.close();
						}				
					statement.close();				
				}
			
			}
			
			//---------------------- end of getting member info ------------------------
			
			//--------------------------------empldata----------------//
			if(incoming_Request.equals("gettingempdata")){
				try {
					String emplcode = request.getParameter("empcode");
					String option = request.getParameter("option");
					
					 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			String sqlQuery = "speccs.SP_MemberDetails '"+emplcode+"','"+option+"','',''";		
		
			PreparedStatement ps2 = connection.prepareStatement(sqlQuery);
			ResultSet rsEmployeeCodeList = ps2.executeQuery();
			JSONArray  arraydata = new JSONArray();
			
			if(rsEmployeeCodeList.next()){
				jsonObject = new JSONObject();
				
				
				String EMPLOYEENAME=rsEmployeeCodeList.getString("MemName");
				String DIVNFULLNAME=rsEmployeeCodeList.getString("Division");
				String DESGFULLNAME=rsEmployeeCodeList.getString("Designation");
				String BASICPAY=rsEmployeeCodeList.getString("BasicPay");
				String DATEOFBIRTH=rsEmployeeCodeList.getString("Dob").substring(0, 10);
				String RETIREMENTDATE=rsEmployeeCodeList.getString("RetiredDate");
				String EMAILID=rsEmployeeCodeList.getString("MailId");
				String PANNUM=rsEmployeeCodeList.getString("PanNo");
				String AADHARNO=rsEmployeeCodeList.getString("AadharNo");
				String PHONE=rsEmployeeCodeList.getString("Phone");
				String PHONEOFFC=rsEmployeeCodeList.getString("OffPhone");
				String CAREOF=rsEmployeeCodeList.getString("CareOf");
				String BANKACCNO=rsEmployeeCodeList.getString("BankAccNo");
				String IFSCCODE=rsEmployeeCodeList.getString("IfscCode");
				String BANKNAME=rsEmployeeCodeList.getString("BankName");
				String BANKPLACE=rsEmployeeCodeList.getString("BankPlace");
			
			
				if(EMPLOYEENAME==null) EMPLOYEENAME="";
				if(DIVNFULLNAME==null) DIVNFULLNAME="";
				if(DESGFULLNAME==null) DESGFULLNAME="";
				if(BASICPAY==null) BASICPAY="";
				if(DATEOFBIRTH==null) DATEOFBIRTH="";
				else DATEOFBIRTH=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("Dob"));
				if(RETIREMENTDATE==null) RETIREMENTDATE="";
				else RETIREMENTDATE=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("RetiredDate"));
				if(EMAILID==null) EMAILID="";
				if(PANNUM==null) PANNUM="";
				if(AADHARNO==null) AADHARNO="";
				if(PHONE==null) PHONE="";
				if(PHONEOFFC==null) PHONEOFFC="";
				if(CAREOF==null) CAREOF="";
				if(BANKACCNO==null) BANKACCNO="";
				if(IFSCCODE==null) IFSCCODE="";
				if(BANKNAME==null) BANKNAME="";
				if(BANKPLACE==null) BANKPLACE="";
				
	
				jsonObject.put("EMPLOYEENAME", EMPLOYEENAME.trim());
				jsonObject.put("DIVNFULLNAME", DIVNFULLNAME.trim());
				jsonObject.put("DESGFULLNAME", DESGFULLNAME.trim());
				jsonObject.put("BASICPAY", BASICPAY.trim());
				jsonObject.put("DATEOFBIRTH", DATEOFBIRTH.trim());
				jsonObject.put("RETIREMENTDATE", RETIREMENTDATE.trim());
				jsonObject.put("EMAILID", EMAILID.trim());
				jsonObject.put("PANNUM", PANNUM.trim());
				jsonObject.put("AADHARNO", AADHARNO.trim());
				jsonObject.put("PHONE", PHONE.trim());
				jsonObject.put("PHONEOFFC", PHONEOFFC.trim());
				jsonObject.put("CAREOF", CAREOF.trim());
				jsonObject.put("BANKACCNO", BANKACCNO.trim());
				jsonObject.put("IFSCCODE", IFSCCODE.trim());
				jsonObject.put("BANKNAME", BANKNAME.trim());
				jsonObject.put("BANKPLACE", BANKPLACE.trim());
				
				arraydata.put(jsonObject);
				
			}
			jsonObject = new JSONObject();
		
			jsonObject.put("emplDetails", arraydata);
			response.getWriter().write(jsonObject.toString());
			if(connection!=null){
			 connection.close();
			}
		
		}catch(Exception e2){
				System.out.println("  EXCEPTION IN EMPLOYEEDATA    "+e2);
				e2.printStackTrace();
				if(connection!=null){
					 connection.close();
					}
			
				statement.close();
			}
			}
			
			
			
			//-----------------------end empdata--------------------//
			
		
		
		if(incoming_Request.equals("submitMember")){ 
			try{
				
				String option = request.getParameter("option").trim();
//				System.out.println("OPTIONS  "+option);
				String memAccnountNumber = request.getParameter("memAccnountNumber").trim();
				String userid = request.getParameter("userid").trim();
				String emplycode = request.getParameter("emplycode").trim();
				String nameOfTheMember = request.getParameter("nameOfTheMember").trim();
				String division = request.getParameter("division").trim();
				String designation = request.getParameter("designation").trim();
				String strbasicPay = request.getParameter("basicPay");
				
				double basicPay = 0;
				if(strbasicPay !=null)
				basicPay =  Double.parseDouble(request.getParameter("basicPay").trim());
				
				String dateOfBirth = request.getParameter("dateOfBirth").trim();
				dateOfBirth = dateOfBirth.split("/")[1]+"/"+dateOfBirth.split("/")[0]+"/"+dateOfBirth.split("/")[2];
				String retirementDate = request.getParameter("retirementDate").trim();
				retirementDate = retirementDate.split("/")[1]+"/"+retirementDate.split("/")[0]+"/"+retirementDate.split("/")[2];

				String mailId = request.getParameter("mailId").trim();
				String panNumber = request.getParameter("panNumber").trim();
				String aadharNumber = request.getParameter("aadharNumber").trim();
				String officeno = request.getParameter("officeno").trim();
				String careOf = request.getParameter("careOf").trim();
				String phoneNumber = request.getParameter("phoneNumber").trim();
				
			/*	String bankNumber = "";
				String ifscCode = "";
				String bankName = "";
				String bankAddress ="";*/
				
				String remarks = request.getParameter("remarks").trim();
				
				 Double shareamt = Double.parseDouble(request.getParameter("shareamt").trim());
				 int sharesallot = Integer.parseInt(request.getParameter("sharesallot").trim());
				 Double thriftSubAmt = Double.parseDouble(request.getParameter("thriftSubAmt").trim());
				 Double thriftAmount = Double.parseDouble(request.getParameter("thriftAmount").trim());
				
				
				 String igrid=request.getParameter("igrid").trim();
				 String igrid1=request.getParameter("igrid1").trim();
				 String igrid2=request.getParameter("igrid2").trim();
				if(option.equals("SUBMITUPDATE")){

						JSONArray jarr2=new JSONArray(igrid2);
						List<String> list = new ArrayList<>();
						for(int i=0;i<jarr2.length();i++){
							JSONObject json = jarr2.getJSONObject(i);
							list.add(json.getString("BankAccNo"));
							list.add(json.getString("Ifsccode"));
							list.add(json.getString("Bankname"));
							list.add(json.getString("Bankplace"));
						}
						String ipaddress=request.getRemoteHost();
						String sqlQuery = "{call speccs.SP_MemberAppl(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
						
						 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
						 cStatement = connection.prepareCall(sqlQuery);
					
						cStatement.setString(1, option);
						cStatement.setString(2, memAccnountNumber);
						cStatement.setString(3, emplycode);
						cStatement.setString(4, nameOfTheMember);
						cStatement.setString(5, panNumber.toUpperCase());
						cStatement.setString(6, aadharNumber);
						cStatement.setString(7, mailId);
						cStatement.setString(8, designation);
						cStatement.setString(9, division);
						cStatement.setString(10, phoneNumber);
						cStatement.setString(11, officeno);
						cStatement.setString(12, list.get(0));
						cStatement.setString(13, list.get(1));	
						cStatement.setString(14, list.get(2));
						cStatement.setString(15, list.get(3));
						cStatement.setDouble(16,basicPay );
						cStatement.setString(17,"");
					    cStatement.setString(18,dateOfBirth );
						cStatement.setString(19, retirementDate);
						cStatement.setString(20,careOf );
						cStatement.setString(21,"");
						cStatement.setInt(22, sharesallot);
						cStatement.setDouble(23,thriftAmount);
						cStatement.setDouble(24,thriftSubAmt);
						cStatement.setDouble(25, shareamt);
						cStatement.setString(26, remarks);
						cStatement.setString(27, userid);
						cStatement.setString(28, ipaddress);
						cStatement.registerOutParameter(29, Types.VARCHAR);
						cStatement.executeUpdate();
						//String memaccNonew = cStatement.getString(29);
						cStatement.close();
											
						String sqlQuery9 = "speccs.SP_Bankdetails 'DELETE','"+memAccnountNumber+"','','','','','','',''";						
						PreparedStatement  ps9 = connection.prepareStatement(sqlQuery9); 
						ps9.executeUpdate();	
	
						JSONObject jobj2=null;
						for(int i=0;i<jarr2.length();i++){
							 jobj2=jarr2.getJSONObject(i);
							 String BankAccNo=jobj2.getString("BankAccNo");
							 String IfscCode=jobj2.getString("Ifsccode");
							 String BankName=jobj2.getString("Bankname");
							 String BankPlace=jobj2.getString("Bankplace");				
							 String sqlQuery3 = "speccs.SP_Bankdetails 'SAVE','"+memAccnountNumber+"','"+BankAccNo.trim()+"','"+IfscCode.trim()+"','"+BankName.trim()+"','"+BankPlace.trim()+"','"+userid+"','',''";						
							 PreparedStatement  ps3 = connection.prepareStatement(sqlQuery3); 
							 ps3.executeUpdate();																		         
						}
						
						JSONArray jarr=new JSONArray(igrid);
						JSONObject jobj=null;
						String savewithoutid="SAVEWITHOUTID";
						String savewithid="SAVEWITHID";
						String status="ACTIVE";
						for(int i=0;i<jarr.length();i++){
							 jobj=jarr.getJSONObject(i);
							 String NomineeId=jobj.getString("NomineeId");
							 
								if(NomineeId.equals("")){
									String sqlQuery1 = "speccs.SP_Nominee '"+savewithoutid+"','"+memAccnountNumber+"','"+jobj.getString("NomineeName").trim()+"','"+jobj.getString("Dob").trim()+"','"+jobj.getString("Relation").trim()+"','"+jobj.getString("Gender").trim()+"','"+jobj.getString("Address").trim()+"','"+status+"','"+userid+"','','"+ipaddress+"',''";
									 PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
										ps1.executeUpdate();
								}else{
									String sqlQuery1 = "speccs.SP_Nominee '"+savewithid+"','"+memAccnountNumber+"','"+jobj.getString("NomineeName").trim()+"','"+jobj.getString("Dob").trim()+"','"+jobj.getString("Relation").trim()+"','"+jobj.getString("Gender").trim()+"','"+jobj.getString("Address").trim()+"','"+status+"','"+userid+"','"+NomineeId+"','"+ipaddress+"',''";
						
									PreparedStatement  ps2 = connection.prepareStatement(sqlQuery1); 
										ps2.executeUpdate();	
								}
						}
						
						JSONArray  jarradd=new JSONArray(igrid1);
						String option1="SAVEWITHOUTID";
						String option2="SAVEWITHID";
						for(int i=0;i<jarradd.length();i++){
							JSONObject jobjadd=jarradd.getJSONObject(i);
							
							String memberaddressid=jobjadd.getString("AddressId");
							 
							 if(memberaddressid.equals("")){
							
								 String  sqlQuery1 = "speccs.SP_MemAddress '"+option1+"','"+memAccnountNumber+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userid+"','','"+ipaddress+"',''";
								  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
								ps1.executeUpdate();
				
							 }else{
								 
								 String  sqlQuery1 = "speccs.SP_MemAddress '"+option2+"','"+memAccnountNumber+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userid+"','"+memberaddressid+"','"+ipaddress+"',''";
								  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
								ps1.executeUpdate();
							 }
								
						}
		
						jsonObject = new JSONObject();
						jsonObject.put("updated", "y");
						response.getWriter().write(jsonObject.toString());
						if(connection!=null){
						 connection.close();
						}
						}else{
							String ipaddress=request.getRemoteHost();
					
							String sqlQuery = "{call speccs.SP_MemberAppl(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
							JSONArray jarr2=new JSONArray(igrid2);
							List<String> list = new ArrayList<>();
							for(int i=0;i<jarr2.length();i++){
								JSONObject json = jarr2.getJSONObject(i);
								list.add(json.getString("BankAccNo"));
								list.add(json.getString("Ifsccode"));
								list.add(json.getString("Bankname"));
								list.add(json.getString("Bankplace"));
							}
							//System.out.println(list.get(0)+" "+list.get(1)+" "+list.get(2)+" "+list.get(3));
							 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
							 cStatement = connection.prepareCall(sqlQuery);
				
							cStatement.setString(1, option);
							cStatement.setString(2, "");
							cStatement.setString(3, emplycode);
							cStatement.setString(4, nameOfTheMember);
							cStatement.setString(5, panNumber.toUpperCase());
							cStatement.setString(6, aadharNumber);
							cStatement.setString(7, mailId);
							cStatement.setString(8, designation);
							cStatement.setString(9, division);
							cStatement.setString(10, phoneNumber);
							cStatement.setString(11, officeno);
							cStatement.setString(12, list.get(0));
							cStatement.setString(13, list.get(1));	
							cStatement.setString(14, list.get(2));
							cStatement.setString(15, list.get(3));
							cStatement.setDouble(16,basicPay );
							cStatement.setString(17,"");
						    cStatement.setString(18,dateOfBirth );
							cStatement.setString(19, retirementDate);
							cStatement.setString(20,careOf );
							cStatement.setString(21,"");
							cStatement.setInt(22, sharesallot);
							cStatement.setDouble(23,thriftAmount);
							cStatement.setDouble(24,thriftSubAmt);
							cStatement.setDouble(25, shareamt);
							cStatement.setString(26, remarks);
							cStatement.setString(27, userid);
							cStatement.setString(28, ipaddress);
							cStatement.registerOutParameter(29, Types.VARCHAR);
							cStatement.executeUpdate();
							
							String memaccNonew = cStatement.getString(29);
							
							cStatement.close();
						
							JSONObject jobj2=null;
							for(int i=0;i<jarr2.length();i++){
								 jobj2=jarr2.getJSONObject(i);
								 String BankAccNo=jobj2.getString("BankAccNo");
								 String IfscCode=jobj2.getString("Ifsccode");
								 String BankName=jobj2.getString("Bankname");
								 String BankPlace=jobj2.getString("Bankplace");
					
								String sqlQuery3 = "speccs.SP_Bankdetails 'SAVE','"+memaccNonew+"','"+BankAccNo.trim()+"','"+IfscCode.trim()+"','"+BankName.trim()+"','"+BankPlace.trim()+"','"+userid+"','',''";
								PreparedStatement  ps3 = connection.prepareStatement(sqlQuery3); 
								ps3.executeUpdate();
								}
					
							JSONArray jarr=new JSONArray(igrid);
							
							JSONObject jobj=null;
							String savewithoutid="SAVEWITHOUTID";
							String savewithid="SAVEWITHID";
							String status="ACTIVE";
							for(int i=0;i<jarr.length();i++){
								 jobj=jarr.getJSONObject(i);
								 String NomineeId=jobj.getString("NomineeId");
								 
									if(NomineeId.equals("")){
										String sqlQuery1 = "speccs.SP_Nominee '"+savewithoutid+"','"+memaccNonew+"','"+jobj.getString("NomineeName").trim()+"','"+jobj.getString("Dob").trim()+"','"+jobj.getString("Relation").trim()+"','"+jobj.getString("Gender").trim()+"','"+jobj.getString("Address").trim()+"','"+status+"','"+userid+"','','"+ipaddress+"',''";
										 PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
											ps1.executeUpdate();
									}else{
										String sqlQuery1 = "speccs.SP_Nominee '"+savewithid+"','"+memaccNonew+"','"+jobj.getString("NomineeName").trim()+"','"+jobj.getString("Dob").trim()+"','"+jobj.getString("Relation").trim()+"','"+jobj.getString("Gender").trim()+"','"+jobj.getString("Address").trim()+"','"+status+"','"+userid+"','"+NomineeId+"','"+ipaddress+"',''";
										 PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
											ps1.executeUpdate();	
									}
								 				
							}
					
							JSONArray  jarradd=new JSONArray(igrid1);
					
							String option1="SAVEWITHOUTID";
							String option2="SAVEWITHID";
							for(int i=0;i<jarradd.length();i++){
								JSONObject jobjadd=jarradd.getJSONObject(i);
								
				                  String memberaddressid=jobjadd.getString("AddressId");
								 
								 if(memberaddressid.equals("")){
								
									 String  sqlQuery1 = "speccs.SP_MemAddress '"+option1+"','"+memaccNonew+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userid+"','','"+ipaddress+"',''";
									  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
									ps1.executeUpdate();
					
								 }else{
							 
								 String  sqlQuery1 = "speccs.SP_MemAddress '"+option2+"','"+memaccNonew+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userid+"','"+memberaddressid+"','"+ipaddress+"',''";
								  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
								ps1.executeUpdate();
							 }
				//			System.out.println("memaccNonew  "+memaccNonew);
							jsonObject = new JSONObject();
							jsonObject.put("memaccNonew", memaccNonew);
							jsonObject.put("success", "y");
							response.getWriter().write(jsonObject.toString());
							 
							}
							if(connection!=null){
								 connection.close();
								}
							}
		 
					}catch(Exception e2){
							System.out.println("  EXCEPTION     "+e2);
							e2.printStackTrace();
							if(connection!=null){
								 connection.close();
								}
						     
					}
			}
				if(incoming_Request.equals("ssubmitMember")){ 
					try{
						
						
						String userId = (String) session.getAttribute("EMPLOYEECODE");
						
						String option = request.getParameter("option").trim();
						
						String memAccnountNumber = request.getParameter("memAccnountNumber").trim();
					
						String nameOfTheMember = request.getParameter("nameOfTheMember").trim();
						
						String strbasicPay = request.getParameter("basicpay");
						
						double basicPay = 0;
						if(strbasicPay !=null)
						basicPay =  Double.parseDouble(request.getParameter("basicpay").trim());
						
						String dateOfBirth = request.getParameter("Dateofbirth").trim();
						dateOfBirth = dateOfBirth.split("/")[1]+"/"+dateOfBirth.split("/")[0]+"/"+dateOfBirth.split("/")[2];
						String mailId = request.getParameter("mailId").trim();
						String panNumber = request.getParameter("panNumber").trim();
						String aadharNumber = request.getParameter("aadharNumber").trim();
						String officeno = request.getParameter("officeno").trim();
						String careOf = request.getParameter("careOf").trim();
						String phoneNumber = request.getParameter("phoneNumber").trim();
						
						String bankNumber = "";
						String ifscCode = "";
						String bankName = "";
						String bankAddress ="";
						
						String remarks = request.getParameter("remarks").trim();
						
						 Double shareamt = Double.parseDouble(request.getParameter("shareamt").trim());
						 int sharesallot = Integer.parseInt(request.getParameter("sharesallot").trim());
						 Double thriftSubAmt = Double.parseDouble(request.getParameter("thriftSubAmt").trim());
						 Double thriftAmount = Double.parseDouble(request.getParameter("thriftAmount").trim());
						
						
					String igrid1=request.getParameter("igrid1").trim();
					String igrid2=request.getParameter("igrid2").trim();
					if(option.equals("SSUBMITUPDATE")){
						String ipaddress=request.getRemoteHost();
						String sqlQuery = "{call speccs.SP_MemberAppl(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
						
						 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
						 cStatement = connection.prepareCall(sqlQuery);
					
						cStatement.setString(1, option);
						cStatement.setString(2, memAccnountNumber);
						cStatement.setString(3, "");
						cStatement.setString(4, nameOfTheMember);
						cStatement.setString(5, panNumber);
						cStatement.setString(6, aadharNumber);
						cStatement.setString(7, mailId);
						cStatement.setString(8, "");
						cStatement.setString(9, "");
						cStatement.setString(10, phoneNumber);
						cStatement.setString(11, officeno);
						cStatement.setString(12, bankNumber);
						cStatement.setString(13, ifscCode);	
						cStatement.setString(14, bankName);
						cStatement.setString(15, bankAddress);
						cStatement.setDouble(16,basicPay );
						cStatement.setString(17,"");
					    cStatement.setString(18,dateOfBirth );
						cStatement.setString(19, "");
						cStatement.setString(20,careOf );
						cStatement.setString(21,"");
						cStatement.setInt(22, sharesallot);
						cStatement.setDouble(23,thriftAmount);
						cStatement.setDouble(24,thriftSubAmt);
						cStatement.setDouble(25, shareamt);
						cStatement.setString(26, remarks);
						cStatement.setString(27, userId);
						cStatement.setString(28, ipaddress);
						cStatement.registerOutParameter(29, Types.VARCHAR);
						cStatement.executeUpdate();
						//String memaccNonew = cStatement.getString(29);
						cStatement.close();
					
						
						String sqlQuery9 = "speccs.SP_Bankdetails 'DELETE','"+memAccnountNumber+"','','','','','','',''";
						
						PreparedStatement  ps9 = connection.prepareStatement(sqlQuery9); 
											ps9.executeUpdate();	
						
				
				JSONArray jarr2=new JSONArray(igrid2);
						
		
						JSONObject jobj2=null;
						for(int i=0;i<jarr2.length();i++){
							 jobj2=jarr2.getJSONObject(i);
							 String BankAccNo=jobj2.getString("BankAccNo");
							 String IfscCode=jobj2.getString("Ifsccode");
							 String BankName=jobj2.getString("Bankname");
							 String BankPlace=jobj2.getString("Bankplace");
				
					String sqlQuery3 = "speccs.SP_Bankdetails 'SAVE','"+memAccnountNumber+"','"+BankAccNo.trim()+"','"+IfscCode.trim()+"','"+BankName.trim()+"','"+BankPlace.trim()+"','"+userId+"','',''";
					
					PreparedStatement  ps3 = connection.prepareStatement(sqlQuery3); 
										ps3.executeUpdate();	
											
						         }
						
						
						JSONArray  jarradd=new JSONArray(igrid1);
						String option1="SAVEWITHOUTID";
						String option2="SAVEWITHID";
						for(int i=0;i<jarradd.length();i++){
							JSONObject jobjadd=jarradd.getJSONObject(i);
							
			 String memberaddressid=jobjadd.getString("AddressId");
							 
							 if(memberaddressid.equals("")){
							
								 String  sqlQuery1 = "speccs.SP_MemAddress '"+option1+"','"+memAccnountNumber+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userId+"','','"+ipaddress+"',''";
								  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
								ps1.executeUpdate();
				
							 }else{
								 
								 String  sqlQuery1 = "speccs.SP_MemAddress '"+option2+"','"+memAccnountNumber+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userId+"','"+memberaddressid+"','"+ipaddress+"',''";
								 
								 PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
								ps1.executeUpdate();
							 }
								
						}
		
						jsonObject = new JSONObject();
						jsonObject.put("updated", "y");
						response.getWriter().write(jsonObject.toString());
						if(connection!=null){
						 connection.close();
						}
						
					}else{
						String ipaddress=request.getRemoteHost();
					
					String sqlQuery = "{call speccs.SP_MemberAppl(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
					
					 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
					 cStatement = connection.prepareCall(sqlQuery);
				
					cStatement.setString(1, option);
					cStatement.setString(2, "");
					cStatement.setString(3, "");
					cStatement.setString(4, nameOfTheMember);
					cStatement.setString(5, panNumber);
					cStatement.setString(6, aadharNumber);
					cStatement.setString(7, mailId);
					cStatement.setString(8, "");
					cStatement.setString(9, "");
					cStatement.setString(10, phoneNumber);
					cStatement.setString(11, officeno);
					cStatement.setString(12, bankNumber);
					cStatement.setString(13, ifscCode);	
					cStatement.setString(14, bankName);
					cStatement.setString(15, bankAddress);
					cStatement.setDouble(16,basicPay );
					cStatement.setString(17,"");
				    cStatement.setString(18,dateOfBirth );
					cStatement.setString(19, "");
					cStatement.setString(20,careOf );
					cStatement.setString(21,"");
					cStatement.setInt(22, sharesallot);
					cStatement.setDouble(23,thriftAmount);
					cStatement.setDouble(24,thriftSubAmt);
					cStatement.setDouble(25, shareamt);
					cStatement.setString(26, remarks);
					cStatement.setString(27, userId);
					cStatement.setString(28, ipaddress);
					cStatement.registerOutParameter(29, Types.VARCHAR);
					cStatement.executeUpdate();
					String memaccNonew = cStatement.getString(29);
					
					cStatement.close();
				
					
					JSONArray jarr2=new JSONArray(igrid2);
					JSONObject jobj2=null;
					for(int i=0;i<jarr2.length();i++){
						 jobj2=jarr2.getJSONObject(i);
						 String BankAccNo=jobj2.getString("BankAccNo");
						 String IfscCode=jobj2.getString("Ifsccode");
						 String BankName=jobj2.getString("Bankname");
						 String BankPlace=jobj2.getString("Bankplace");
			
				String sqlQuery3 = "speccs.SP_Bankdetails 'SAVE','"+memaccNonew+"','"+BankAccNo.trim()+"','"+IfscCode.trim()+"','"+BankName.trim()+"','"+BankPlace.trim()+"','"+userId+"','',''";
				PreparedStatement  ps3 = connection.prepareStatement(sqlQuery3); 
									ps3.executeUpdate();	
										
					         }
					
					JSONArray  jarradd=new JSONArray(igrid1);
			
					String option1="SAVEWITHOUTID";
					String option2="SAVEWITHID";
					for(int i=0;i<jarradd.length();i++){
						JSONObject jobjadd=jarradd.getJSONObject(i);
						
		                  String memberaddressid=jobjadd.getString("AddressId");
						 
						 if(memberaddressid.equals("")){
						
							 String  sqlQuery1 = "speccs.SP_MemAddress '"+option1+"','"+memaccNonew+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userId+"','','"+ipaddress+"',''";
							  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
							ps1.executeUpdate();
			
						 }else{
							 
							 String  sqlQuery1 = "speccs.SP_MemAddress '"+option2+"','"+memaccNonew+"','"+jobjadd.getString("Address1").trim()+"','"+jobjadd.getString("Address2").trim()+"','"+jobjadd.getString("City").trim()+"','"+jobjadd.getString("District").trim()+"','"+jobjadd.getString("State").trim()+"','"+jobjadd.getString("Pincode").trim()+"','"+jobjadd.getString("Remarks").trim()+"','"+userId+"','"+memberaddressid+"','"+ipaddress+"',''";
							  PreparedStatement  ps1 = connection.prepareStatement(sqlQuery1); 
							ps1.executeUpdate();
						 }
					
					 
					}
					System.out.println("new application No: "+memaccNonew);
					jsonObject = new JSONObject();
					jsonObject.put("memaccNonew", memaccNonew);
					jsonObject.put("success", "y");
					response.getWriter().write(jsonObject.toString());
					if(connection!=null){
						 connection.close();
						}
					}
				 
					}catch(Exception e2){
							System.out.println("  EXCEPTION     "+e2);
							e2.printStackTrace();
							if(connection!=null){
								 connection.close();
								}
						     
					}
				}
				if ("getThriftAmount".equalsIgnoreCase(incoming_Request)) {

					String MemAccNo = request.getParameter("MemAccNo");
					
					LinkedList list1 = new LinkedList();
					try {
						
						connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
						if(null!=MemAccNo){
						
						String Query = "SELECT ThriftSubscriptionAmount FROM speccs.MemberAccount WHERE MemAccNo=?";

						
						java.sql.PreparedStatement pstmt = connection.prepareStatement(Query);
						pstmt.setString(1, MemAccNo);

						ResultSet resultSet = pstmt.executeQuery();

						while (resultSet.next()) {

							list1.add(resultSet.getString("ThriftSubscriptionAmount"));
							list1.add(resultSet.getString("ThriftSubscriptionAmount"));
						}
						}

						jsonObject = new JSONObject();
						jsonObject.put("ThriftAmnt", list1);
						response.getWriter().write(jsonObject.toString());
					}

					catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException
							| JSONException e) {
						e.printStackTrace();
					} finally {
						if (null != connection)
							try {
								connection.close();
							} catch (SQLException e) {
								e.printStackTrace();
							}
					}

				}
				//added by pn on 19/05/2025 for thrift subscription updation
				if (incoming_Request.equals("UpdateThriftSubscription")) {
		 			Connection connection1 = null;
						String memaccno = request.getParameter("MemAccNo");
						String ThriftAmount = request.getParameter("ThriftAmount");
						String Option = request.getParameter("Option");
						String sqlQuery = "UPDATE speccs.MemberAccount SET ThriftSubscriptionAmount="+ThriftAmount+" WHERE MemAccNo='"+memaccno+"'";
						connection1 = DataBaseConnectionForNewDB.getConnectionForSyBase();
						PreparedStatement ps2 = connection1.prepareStatement(sqlQuery);

						int count=ps2.executeUpdate();
						if(count>0) {
	                       	jsonObject1 = new JSONObject();
	            			jsonObject1.put("Success", "Y");
//	            			System.out.println("Bankinfo "+jsonObject1.toString());
	            			response.getWriter().write(jsonObject1.toString());
						}
						else {
							jsonObject1 = new JSONObject();
	            			jsonObject1.put("Success", "N");
//	            			System.out.println("Bankinfo "+jsonObject1.toString());
	            			response.getWriter().write(jsonObject1.toString());
						}
	            			if(connection1!=null){
	            				connection1.close();
	            			}
	            			
	            			
					           }
				
		
		if (incoming_Request.equals("Genpdfform")) {

			String applNumber = request.getParameter("applNumber");
			
			ServletContext ctx=getServletContext();
			 String header=ctx.getInitParameter("HEADER");
			 String number=ctx.getInitParameter("NUMBERS");
			 
			ApplicationforsharesandmembershipPdf.getPDF(applNumber,header,number);
			String fileName = "Applicationforsharesandmembership.pdf";
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
		
		if (incoming_Request.equals("Genpdfformmonthly")) {

			String applNumber = request.getParameter("applNumber");
			
			ServletContext ctx=getServletContext();
			 String header=ctx.getInitParameter("HEADER");
			 String number=ctx.getInitParameter("NUMBERS");
			 
			CompusoryMonthlyThriftDepositpdf.getPDF(applNumber,header,number);
			String fileName = "CompusoryMonthlyThriftDeposit.pdf";
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
		
		
		if(incoming_Request.equals("getMemberDetailsForEditing")){
		
			
			String memAccnountNumber = request.getParameter("memAccnountNumber");
			String empCodeFromView = request.getParameter("empCodeFromView");
			String regStatus = request.getParameter("regStatus");
			memberService = new MemberService();
			LinkedList<MembershipDto> memberInformation = memberService.getMemberInformation(empCodeFromView, "SOCIETYMEM", regStatus, memAccnountNumber);
			Collection collection = memberInformation;
			jsonObject = ConvertListToJSONArray.convertCollection(collection, "MEMBERDETAILS");
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
