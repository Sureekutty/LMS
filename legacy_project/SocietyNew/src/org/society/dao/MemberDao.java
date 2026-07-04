package org.society.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import java.util.Map;

import org.society.dto.MembershipDto;
import org.society.dto.ReceiptDto;
import org.society.service.GenericDetailsService;
import org.society.util.DataBaseConnectionForNewDB;

public class MemberDao {

	public LinkedList<String> getMemAddress(String fetch, String empCode) throws Exception {

		LinkedList<String> memberAddress = new LinkedList<>();
		 Connection connection = null;
		try {
			 connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			Statement statement = connection.createStatement();
			String sqlQuery = "EXEC speccs.SP_MemAddress '"+fetch+"','"+empCode+"','','','','','','','',''";
		
			ResultSet rs1= statement.executeQuery(sqlQuery);
			while(rs1.next()){
				memberAddress.add(rs1.getString("Address1"));
		        memberAddress.add(rs1.getString("Address2"));
			    memberAddress.add(rs1.getString("City"));
			    memberAddress.add(rs1.getString("District"));
				memberAddress.add(rs1.getString("Pincode"));
				memberAddress.add(rs1.getString("Remarks"));
			}
			if(connection!=null){
				connection.close();
			}
		}
		catch (SQLException e) {
			 e.printStackTrace();
			throw e;
		}
		return memberAddress ;
	}
	
	//----------------------------------------------------------------------deposit info for deposit view --------------------------------------------//
	
	public  LinkedList<MembershipDto> getDepositInformation(String memEmployeeCode,String recordType,String regStatus,String memAccountNumber) throws Exception {
		
		
		LinkedList<MembershipDto> listOfMemDetails = new LinkedList<MembershipDto>();
		 Connection connection1 = null;
		try{
		
		connection1 = DataBaseConnectionForNewDB.getConnectionForSyBase();
		String sqlQuery ="exec speccs.SP_DepositsView ?,?,?,?,?,?";
		
		CallableStatement cs1 = connection1.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		

		cs1.setString(1,regStatus );//
		cs1.setString(2,recordType);//SHAREMP
		cs1.setString(3,memEmployeeCode);//New
		cs1.setString(4, memAccountNumber);//""
		cs1.setString(5, "");
		cs1.setString(6, "");
		
		ResultSet rsMembersDetails = cs1.executeQuery();
		
		MembershipDto view = null;
		
		while (rsMembersDetails.next()) {
			view  = new MembershipDto();
			
	if(regStatus.equals("FRESH")){
		view.setApplicatstatus("FRESH");
	}else{
		view.setApplicatstatus("");
	}
			
			
			view.setMemAccno(rsMembersDetails.getString("MemAccNo").trim());
			view.setMemName(rsMembersDetails.getString("MemName").trim());
			view.setDesignation(rsMembersDetails.getString("Designation").trim());
			view.setDivision(rsMembersDetails.getString("Division").trim());
			view.setMemEmpCode(rsMembersDetails.getString("MemEmpCode").trim());
			view.setDepositnumber(rsMembersDetails.getString("DepositNo").trim());
			String AadharNo = rsMembersDetails.getString("AadharNo").trim();
		   if(AadharNo==null || AadharNo==""){
			   AadharNo="-"; 
		   }
		    view.setAadharNumber(AadharNo);
		    
		    String MailId = rsMembersDetails.getString("MailId").trim();
		    if(MailId==null ||MailId==""){
		    	MailId="-";
		    }
		    view.setMailId(MailId);
		    
		    String Phone = rsMembersDetails.getString("Phone").trim();
		    if(Phone==null ||Phone==""){
		    	Phone="-"; 
		    }
		    view.setPhoneNumber(Phone);
		    
		    
		    String BankAccNo = rsMembersDetails.getString("BankAccNo").trim();
		    if(BankAccNo==null ||BankAccNo==""){
		    	BankAccNo="-"; 
		    }
		    view.setBankNumber(BankAccNo);
		    
		    String IfscCode = rsMembersDetails.getString("IfscCode").trim();
		    if(IfscCode==null ||IfscCode==""){
		    	IfscCode="-"; 
		    }
		    view.setIfscCode(IfscCode);
		    
		    
		    String BankName = rsMembersDetails.getString("BankName").trim();
		    if(BankName==null ||BankName==""){
		    	BankName="-"; 
		    }
		    view.setBankName(BankName);
		    
		    
		    String BasicPay = rsMembersDetails.getString("BasicPay").trim();
		    if(BasicPay==null ||BasicPay==""){
		    	BasicPay="-"; 
		    }
		    view.setBasicPay(Integer.parseInt(BasicPay));
		    
		
			
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy");
			String strFmtDate = simpleDateFormat.format(rsMembersDetails.getDate("Dob"));
			view.setDateOfBirth(strFmtDate);
			
			
			 String Status = rsMembersDetails.getString("Status").trim();
			    if(Status==null ||Status==""){
			    	Status="-"; 
			    }
			    view.setRegStatus(Status);
			
			
			 String DepositType = rsMembersDetails.getString("DepositType");
			    if(DepositType==null ||BasicPay==""){
			    	DepositType="-"; 
			    }
			    view.setDeposittype(DepositType);
			
			
			
			String opendate = rsMembersDetails.getString("OpenDate").substring(0, 10);
			
			if(opendate==null || opendate==""){
				opendate="-";
			}
			view.setOpenDate(opendate);
			
			
			String Duration = rsMembersDetails.getString("Duration");
			if(Duration==null || Duration==""){
				Duration="-";
			}
			view.setDuration(Duration);
			String IntRate = rsMembersDetails.getString("IntRate");
			if(IntRate==null || IntRate==""){
				IntRate="-";
			}
			view.setInterestrate(IntRate);
			
			
			
			String Subscription = rsMembersDetails.getString("Subscription");
			if(Subscription==null || Subscription==""){
				Subscription="-";
			}
			view.setSubscription(Subscription);
			
			
			
			String CloseDate = rsMembersDetails.getString("CloseDate");
			if(CloseDate==null || CloseDate==""){
				CloseDate="NA";
			}
			view.setClosedate(CloseDate);
			
			String Statusinfo = rsMembersDetails.getString("depositstatus").trim();
			if(Statusinfo==null || Statusinfo==""){
				Statusinfo="NA";
			}
			view.setStatusinfo(Statusinfo);
			
			
			String MaturityAmount = rsMembersDetails.getString("MaturityAmount");
			if(MaturityAmount==null || MaturityAmount==""){
				MaturityAmount="-";
			}
			view.setMaturityAmount(MaturityAmount);
			String Remarks = rsMembersDetails.getString("Remarks");
			if(Remarks==null || Remarks==""){
				Remarks="-";
			}
			view.setRemarks(Remarks);
			
			listOfMemDetails.add(view);
		}
		if(connection1!=null){
			connection1.close();
		}
		}catch(Exception e){
			e.printStackTrace();
			
		}
		
		return listOfMemDetails;
		
		
	}
	
	public  LinkedList<ReceiptDto> getDepositInformationReceipt(String fromDate,String toDate,String memEmployeeCode,String recordType,String regStatus,String memAccountNumber) throws Exception {
		
		
		LinkedList<ReceiptDto> listOfReceiptDetails = new LinkedList<ReceiptDto>();
		Connection connection2 = null;
		try{
		
		connection2 = DataBaseConnectionForNewDB.getConnectionForSyBase();
		String sqlQuery ="exec speccs.SP_ReceiptView ?,?,?,?,?,?";
		
		CallableStatement cs1 = connection2.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		

		cs1.setString(1,regStatus );//
		cs1.setString(2,recordType);//SHAREMP
		cs1.setString(3,memEmployeeCode);//New
		cs1.setString(4, memAccountNumber);//""
		cs1.setString(5, fromDate);
		cs1.setString(6, toDate);
		
		ResultSet rsMembersDetails = cs1.executeQuery();
		
		ReceiptDto view = null;
		
		while (rsMembersDetails.next()) {
			view  = new ReceiptDto();
		view.setReceiptno(rsMembersDetails.getString("ReceiptNo").trim());
		view.setMemAccno(rsMembersDetails.getString("MemAccNo").trim());
		view.setMemEmpCode(rsMembersDetails.getString("MemEmpCode").trim());
		view.setDesignation(rsMembersDetails.getString("Designation").trim());
		view.setDivision(rsMembersDetails.getString("Division").trim());
		view.setMemName(rsMembersDetails.getString("MemName").trim());
		
		String AadharNo = rsMembersDetails.getString("AadharNo").trim();
		   if(AadharNo==null || AadharNo==""){
			   AadharNo="-"; 
		   }
		    view.setAadhar(AadharNo);
		
		    
		    String MailId = rsMembersDetails.getString("MailId").trim();
		    if(MailId==null ||MailId==""){
		    	MailId="-";
		    }
		    view.setMailId(MailId);
		    
		    String Phone = rsMembersDetails.getString("Phone").trim();
		    if(Phone==null ||Phone==""){
		    	Phone="-"; 
		    }
		    view.setPhoneNumber(Phone);
		    
		    String BankAccNo = rsMembersDetails.getString("BankAccNo").trim();
		    if(BankAccNo==null ||BankAccNo==""){
		    	BankAccNo="-"; 
		    }
		    view.setBankNumber(BankAccNo);

		    String BasicPay = rsMembersDetails.getString("BasicPay").trim();
		    if(BasicPay==null ||BasicPay==""){
		    	BasicPay="-"; 
		    }
		    view.setBasicPay(Integer.parseInt(BasicPay));
		
		    
		
			view.setReceiptdate(rsMembersDetails.getString("ReceiptDate").substring(0, 10));
		    
	String purposrcode=rsMembersDetails.getString("PurposeCode").trim();
		view.setPurposecode(purposrcode);
		view.setAmount(rsMembersDetails.getInt("Amount"));
		view.setModeofpayment(rsMembersDetails.getString("ModeOfPayment").trim());
		
		listOfReceiptDetails.add(view);
		}
		if(connection2!=null){
		connection2.close();
		}
		
		}catch(Exception e){
			e.printStackTrace();
			
		}
		return listOfReceiptDetails;
	}
	//------------------------------------------------------------------------------------------------------------------------------------//	
	
	public  LinkedList<MembershipDto> getMemberInformation(String memEmployeeCode,String recordType,String regStatus,String memAccountNumber) throws Exception {
		
		
		LinkedList<MembershipDto> listOfMemDetails = new LinkedList<MembershipDto>();
		Connection connection3 = null;
		try{
		
		connection3 = DataBaseConnectionForNewDB.getConnectionForSyBase();
		String sqlQuery ="exec speccs.SP_MemberDetails ?,?,?,?";
		
		CallableStatement cs1 = connection3.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
	
		cs1.setString(1, memEmployeeCode);//
		cs1.setString(2,recordType);//SHAREMP
		cs1.setString(3,regStatus);//New
		cs1.setString(4, memAccountNumber);//""
		
		ResultSet rsMembersDetails = cs1.executeQuery();
		
		MembershipDto view = null;
		while (rsMembersDetails.next()) {
			
			view  = new MembershipDto();
			
			view.setMemEmpCode(rsMembersDetails.getString("MemEmpCode").trim());
			String AadharNo = rsMembersDetails.getString("AadharNo");
			
		    AadharNo=(null!=AadharNo?AadharNo.trim():AadharNo); 
		    view.setAadharNumber(AadharNo);
		    
			view.setBasicPay(rsMembersDetails.getInt("BasicPay"));
			
			String CareOf = rsMembersDetails.getString("CareOf");
		    CareOf=(null!=CareOf?CareOf.trim():CareOf); 
		    view.setCareOf(CareOf);
	
		    String MemName = rsMembersDetails.getString("MemName");
		    MemName=(null!=MemName?MemName.trim():MemName); 
		    view.setMemName(MemName);
			view.setEmployee(rsMembersDetails.getString("MEMEMPCODE").trim() +"-" + rsMembersDetails.getString("MEMNAME").trim());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy");
			String strFmtDate = simpleDateFormat.format(rsMembersDetails.getDate("Dob"));
			
			
			view.setDateOfBirth(strFmtDate);
	
			String Designation = rsMembersDetails.getString("Designation");
		    Designation=(null!=Designation?Designation.trim():Designation); 
		    view.setDesignation(Designation);
		
		    String Division = rsMembersDetails.getString("Division");
		    Division=(null!=Division?Division.trim():Division); 
		    view.setDivision(Division);

		
		    String MailId = rsMembersDetails.getString("MailId");
		    MailId=(null!=MailId?MailId.trim():MailId);
		    view.setMailId(MailId);
			
		
		    String OffPhone = rsMembersDetails.getString("OffPhone");
		    OffPhone=(null!=OffPhone?OffPhone.trim():OffPhone);
		    view.setOfficeNumber(OffPhone);
		
		    String PanNo = rsMembersDetails.getString("PanNo");
		    PanNo=(null!=PanNo?PanNo.trim():PanNo);
		    view.setPanNumber(PanNo);
		
		    String Phone = rsMembersDetails.getString("Phone");
		    Phone=(null!=Phone?Phone.trim():Phone); 
		    view.setPhoneNumber(Phone);
			strFmtDate = simpleDateFormat.format(rsMembersDetails.getDate("RetiredDate")); // chnaged by pn on 28/04/2025
			view.setRetirementDate(strFmtDate);
			
			GenericDetailsService genericDetailsService = new GenericDetailsService();
			
				String Status = rsMembersDetails.getString("Status").trim();
				
			
				if(null!=Status){
				Status=Status.trim();
				}
				
				if("CANCELED".equals(Status)||"SETTLED".equals(Status)||"CANCELLED".equals(Status)){
					int membershipFee = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("109","Value" ));
					view.setEntranceAmount(membershipFee);
					
					
					
				}else{
				
				}
			
			if(recordType.equalsIgnoreCase("SOCIETYMEM")){
				
				view.setMemAccno(rsMembersDetails.getString("MEMACCNO"));
				view.setShareAmount(rsMembersDetails.getInt("ShareAmount"));
				view.setEntranceAmount(rsMembersDetails.getInt("MembershipFee"));
				view.setMemAccno(rsMembersDetails.getString("MEMACCNO"));
				strFmtDate = simpleDateFormat.format(rsMembersDetails.getDate("MemDate"));
				view.setMembershipDate(strFmtDate);
				view.setTotalShares(rsMembersDetails.getInt("NoOfShares"));
				view.setThriftSubsAmt(rsMembersDetails.getInt("ThriftSubscriptionAmount"));
				
				view.setRegisteredDate(strFmtDate);
				view.setRegStatus(rsMembersDetails.getString("STATUS").trim());
				view.setThriftAmount(rsMembersDetails.getInt("ThriftBalance"));
			}
			listOfMemDetails.add(view);
		}
		
		if(connection3!= null){
			connection3.close();
		}
		
		
		}catch(Exception e){
			e.printStackTrace();
		
		}
		
		
		return listOfMemDetails;
		
		
	}
	
		
	public  LinkedList<MembershipDto> getApplicationInformation(String EmployeeCode,String recordType,String regStatus,String ApplNo) throws Exception {
		
		LinkedList<MembershipDto> listOfMemDetails = new LinkedList<MembershipDto>();
		Connection connection4 = null;
		try{
		connection4 = DataBaseConnectionForNewDB.getConnectionForSyBase();
		String sqlQuery ="exec speccs.SP_getMemberDetails ?,?,?,?";
		CallableStatement cs1 = connection4.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

		cs1.setString(1, EmployeeCode);//
		cs1.setString(2,recordType);//SHAREMP
		cs1.setString(3,regStatus);//SUBMIT
		cs1.setString(4, ApplNo);//""
		
		ResultSet rsMembersDetails = cs1.executeQuery();
		
		MembershipDto view = null;
		while (rsMembersDetails.next()) {
			view  = new MembershipDto();
			view.setMemEmpCode(rsMembersDetails.getString("MemEmpCode").trim());
			String AadharNo = rsMembersDetails.getString("AadharNo");
		    AadharNo=(null!=AadharNo?AadharNo.trim():AadharNo); view.setAadharNumber(AadharNo);
			view.setBasicPay(rsMembersDetails.getInt("BasicPay"));
	
			String CareOf = rsMembersDetails.getString("CareOf");
		    CareOf=(null!=CareOf?CareOf.trim():CareOf); view.setCareOf(CareOf);
		
		    String MemName = rsMembersDetails.getString("MemName");
		    MemName=(null!=MemName?MemName.trim():MemName); view.setMemName(MemName);
			view.setEmployee(rsMembersDetails.getString("MemEmpCode").trim() +"-" + rsMembersDetails.getString("MemName").trim());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy");
			String strFmtDate = simpleDateFormat.format(rsMembersDetails.getDate("Dob"));
			
			view.setDateOfBirth(strFmtDate);
	
			String Designation = rsMembersDetails.getString("Designation");
		    Designation=(null!=Designation?Designation.trim():Designation); view.setDesignation(Designation);
		
		    String Division = rsMembersDetails.getString("Division");
		    Division=(null!=Division?Division.trim():Division); view.setDivision(Division);

		    
		  

		    String MailId = rsMembersDetails.getString("MailId");
		    MailId=(null!=MailId?MailId.trim():MailId); view.setMailId(MailId);
			
	
		    String OffPhone = rsMembersDetails.getString("OffPhone");
		    OffPhone=(null!=OffPhone?OffPhone.trim():OffPhone); view.setOfficeNumber(OffPhone);

		    String PanNo = rsMembersDetails.getString("PanNo");
		    PanNo=(null!=PanNo?PanNo.trim():PanNo); view.setPanNumber(PanNo);

		    String Phone = rsMembersDetails.getString("Phone");
		    Phone=(null!=Phone?Phone.trim():Phone); view.setPhoneNumber(Phone);
			strFmtDate = simpleDateFormat.format(rsMembersDetails.getDate("MemDate"));
			view.setRetirementDate(strFmtDate);
			
			GenericDetailsService genericDetailsService = new GenericDetailsService();
			
				String Status = rsMembersDetails.getString("Status");
				
				
				if(null!=Status){
				Status=Status.trim();
				}
				
				if("CANCELED".equals(Status)||"SETTLED".equals(Status)||"CANCELLED".equals(Status)){
					int membershipFee = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("109","Value" ));
					view.setEntranceAmount(membershipFee);
				
					
				}
				else{
				int membershipFee = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("108","Value" ));
				view.setEntranceAmount(membershipFee);
				
				
				}
			
		
			int sharePrice = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("104", "Value"));
			view.setSharePrice(sharePrice);
			
			int minimumShares = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("110", "Value"));
			view.setTotalShares(minimumShares);
			
			if(recordType.equalsIgnoreCase("SOCIETYMEM")){
				view.setMemAccno(rsMembersDetails.getString("MemAccNo"));

				view.setShareAmount(rsMembersDetails.getInt("ShareAmount"));
	
				view.setMembershipDate(strFmtDate);
				view.setTotalShares(rsMembersDetails.getInt("NoOfShares"));
				view.setThriftSubsAmt(rsMembersDetails.getInt("ThriftSubscriptionAmount"));
				view.setRegisteredDate(strFmtDate);
				view.setRegStatus(rsMembersDetails.getString("Status"));
				view.setRemarks(rsMembersDetails.getString("Remarks"));
				view.setThriftAmount(rsMembersDetails.getInt("ThriftBalance"));
			}
			listOfMemDetails.add(view);
			
		}
		if(connection4!=null){
		connection4.close();
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return listOfMemDetails;
	}
	
public  LinkedList<MembershipDto> getApplicationInformationstaff(String EmployeeCode,String recordType,String regStatus,String ApplNo) throws Exception {
		
	
		LinkedList<MembershipDto> listOfMemDetails = new LinkedList<MembershipDto>();
		Connection connection4 = null;
		try{
		connection4 = DataBaseConnectionForNewDB.getConnectionForSyBase();
		String sqlQuery ="exec speccs.SP_getMemberDetails ?,?,?,?";
		CallableStatement cs1 = connection4.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

		cs1.setString(1, EmployeeCode);//
		cs1.setString(2,recordType);//SHAREMP
		cs1.setString(3,regStatus);//SUBMIT
		cs1.setString(4, ApplNo);//""
		
		ResultSet rsMembersDetails = cs1.executeQuery();
		
		MembershipDto view = null;
		while (rsMembersDetails.next()) {
			view  = new MembershipDto();
		
			String AadharNo = rsMembersDetails.getString("AdhaarNo");
		    AadharNo=(null!=AadharNo?AadharNo.trim():AadharNo); view.setAadharNumber(AadharNo);
			view.setBasicPay(rsMembersDetails.getInt("BasicPay"));
	
			String CareOf = rsMembersDetails.getString("CareOf");
		    CareOf=(null!=CareOf?CareOf.trim():CareOf); view.setCareOf(CareOf);
		
		    String MemName = rsMembersDetails.getString("SEmpName");
		    MemName=(null!=MemName?MemName.trim():MemName); view.setMemName(MemName);
			view.setEmployee(rsMembersDetails.getString("SEmpName").trim());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy");
			String strFmtDate = simpleDateFormat.format(rsMembersDetails.getDate("Dob"));
//			String strFmtDate1 = simpleDateFormat.format(rsMembersDetails.getDate("RegDate"));
			
			view.setDateOfBirth(strFmtDate);

		    String MailId = rsMembersDetails.getString("MailId");
		    MailId=(null!=MailId?MailId.trim():MailId); view.setMailId(MailId);
			
	
		    String OffPhone = rsMembersDetails.getString("OfficePhone");
		    OffPhone=(null!=OffPhone?OffPhone.trim():OffPhone); view.setOfficeNumber(OffPhone);

		    String PanNo = rsMembersDetails.getString("PanNo");
		    PanNo=(null!=PanNo?PanNo.trim():PanNo); view.setPanNumber(PanNo);

		    String Phone = rsMembersDetails.getString("Phone");
		    Phone=(null!=Phone?Phone.trim():Phone); view.setPhoneNumber(Phone);
			
			
			GenericDetailsService genericDetailsService = new GenericDetailsService();
			
				String Status = rsMembersDetails.getString("RegStatus");
				
				
				if(null!=Status){
				Status=Status.trim();
				}
				
				if("CANCELED".equals(Status)||"SETTLED".equals(Status)||"CANCELLED".equals(Status)){
					int membershipFee = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("109","Value" ));
					view.setEntranceAmount(membershipFee);
				
					
				}
				else{
				int membershipFee = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("108","Value" ));
				view.setEntranceAmount(membershipFee);
				
				
				}
			
		
			int sharePrice = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("104", "Value"));
			view.setSharePrice(sharePrice);
			
			int minimumShares = (int) Double.parseDouble( genericDetailsService.getSocietyRuleValue("110", "Value"));
			view.setTotalShares(minimumShares);
			
			if(recordType.equalsIgnoreCase("STAFFMEM")){
				view.setMemAccno(rsMembersDetails.getString("SMemAccNo"));

				view.setShareAmount(rsMembersDetails.getInt("ShareAmount"));
	
				view.setMembershipDate(strFmtDate);
				view.setTotalShares(rsMembersDetails.getInt("NoOfShares"));
				view.setThriftSubsAmt(rsMembersDetails.getInt("ThriftSubscriptionAmount"));
				view.setRegisteredDate(strFmtDate);
				view.setRegStatus(rsMembersDetails.getString("RegStatus"));
				view.setRemarks(rsMembersDetails.getString("Remarks"));
				view.setThriftAmount(rsMembersDetails.getInt("ThriftBalance"));
			}
			listOfMemDetails.add(view);
		}
		
		
		
		
		
		
		
		
		if(connection4!=null){
		connection4.close();
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return listOfMemDetails;
	}
	
}
