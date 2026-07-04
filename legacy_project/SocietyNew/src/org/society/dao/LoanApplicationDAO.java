package org.society.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.society.dto.LoanAppDto;
import org.society.dto.MembershipDto;
import org.society.service.GenericDetailsService;
import org.society.util.DataBaseConnectionForNewDB;

public class LoanApplicationDAO {
	
	
	
	HttpServletRequest request;
	
	private Statement  statement = null;
	String sqlQuery ;
	

	@SuppressWarnings("finally")
	public  List<Map<String, String>> getLoanTypes() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		Map<String, String> loanTypeMap = null;
		LinkedList<Map<String, String>> listOfLoans = new  LinkedList<>();
		Connection connection = null;
		try{
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			sqlQuery = "SELECT LoanTypeCode,LoanTypeDescription FROM speccs.LoanTypes";
			ResultSet executeQuery = connection.createStatement().executeQuery(sqlQuery);
			while (executeQuery.next()) {
				loanTypeMap = new HashMap<String, String>();
				loanTypeMap.put("LoanTypeCode", executeQuery.getString("LoanTypeCode"));
				loanTypeMap.put("LoanTypeDescription", executeQuery.getString("LoanTypeDescription"));
				listOfLoans.add(loanTypeMap);
			}
		if(connection!=null){
			connection.close();
			}
			}catch(Exception e){
				e.printStackTrace();
			}
		return listOfLoans;
	}
	public  List<Map<String, String>> getLoanTypesload() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		Map<String, String> loanTypeMap = null;
		LinkedList<Map<String, String>> listOfLoans = new  LinkedList<>();
		Connection connection = null;
		try{
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			sqlQuery = "SELECT LoanTypeCode,LoanTypeDescription FROM speccs.LoanTypes";
			ResultSet executeQuery = connection.createStatement().executeQuery(sqlQuery);
			while (executeQuery.next()) {
				loanTypeMap = new HashMap<String, String>();
				loanTypeMap.put("LoanTypeCode", executeQuery.getString("LoanTypeCode").trim()+"-"+executeQuery.getString("LoanTypeDescription"));
				
				listOfLoans.add(loanTypeMap);
			}
		
		if(connection!=null){
			connection.close();
			}
			}catch(Exception e){
				e.printStackTrace();
			}
		return listOfLoans;
	}
	public Map<String, String> getLoanDetails(String memAccNo,String loanType,String fdRefNum) throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		Map<String, String> loanDetails  = null;
		
		Connection connection = null;
		try {
			 loanDetails = new HashMap<>();
			sqlQuery  = "{CALL speccs.SP_LoanDetails (?,?,?,?,?,?,?,?,?,?)}";
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			CallableStatement cs1 = connection.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, "PRVLOANCHECK");
			cs1.setString(2, memAccNo);
			cs1.setString(3, fdRefNum);
			cs1.setString(4,loanType);
			cs1.setString(5,"");
			cs1.setString(6,"");
			cs1.setString(7,"");
			cs1.setString(8,"");
			cs1.setString(9,"");
			cs1.setString(10,"");
			ResultSet executeQuery = cs1.executeQuery();
				
			 
			while(executeQuery.next()){
				String string = executeQuery.getString("LoanAccNo");
				int amt=executeQuery.getInt("LoanSanctionAmount");	
//				System.out.println("amt "+amt+" app no. "+string);
				boolean contains = string.contains(loanType);
				if(contains){				
				loanDetails.put("LoanAppNo", executeQuery.getString("LoanAccNo"));
				loanDetails.put("LoanSanctionDate", executeQuery.getString("LoanSanctionDate"));
				loanDetails.put("LoanStatus", executeQuery.getString("LoanStatus"));
				loanDetails.put("OutstandingAmt", executeQuery.getString("LoanSanctionAmount"));						
				loanDetails.put("previousLoan",""+amt);				
			}
			}
//			 System.out.println(prvLoan);
			
		
		if(connection!=null){
			connection.close();
			}
			}catch(Exception e){
				e.printStackTrace();
			}
		
		return loanDetails;
	}
	public List<Map<String,String>> getLoanDetails(String memAccNo,String loanType,String fdRefNum,String status) throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		List<Map<String, String>> listOfLoans = new  LinkedList<>();
		Connection connection = null;
		try {
			sqlQuery  = "{CALL speccs.SP_LoanDetails (?,?,?,?)}";
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			CallableStatement cs1 = connection.prepareCall(sqlQuery);
			cs1.setString(1, memAccNo);
			cs1.setString(2, loanType);
			cs1.setString(3, fdRefNum);
			cs1.setString(4,status);
			Map<String, String> loanDetails  = null;
			ResultSet executeQuery = cs1.executeQuery();
			
			while(executeQuery.next()){
				loanDetails = new HashMap<>();
				loanDetails.put("MemEmpCode", executeQuery.getString("MemEmpCode"));
				loanDetails.put("MemAccNo", executeQuery.getString("MemAccNo"));
				loanDetails.put("MemName", executeQuery.getString("MemName"));
				loanDetails.put("LoanAppNo", executeQuery.getString("LoanAppNo"));
				loanDetails.put("ShareAmount", executeQuery.getString("ShareAmount"));
				loanDetails.put("ThriftBalance", executeQuery.getString("ThriftBalance"));
				loanDetails.put("NoOfShares", executeQuery.getString("NoOfShares"));
				loanDetails.put("PrincipalCB", executeQuery.getString("PrincipalCB"));
				loanDetails.put("ThriftDedAmt", executeQuery.getString("ThriftDedAmt"));
				SimpleDateFormat  dateFormat = new SimpleDateFormat("dd/MM/yyyy");
				 Date date = executeQuery.getDate("LoanAppDate");
				 String strDate = "NA";
				  strDate = dateFormat.format(date);
				 
				loanDetails.put("LoanAppDate", strDate);
				loanDetails.put("LoanAmount", executeQuery.getString("LoanAmount"));
				loanDetails.put("LoanPurpose", executeQuery.getString("LoanPurpose"));
				loanDetails.put("NoOfInst", executeQuery.getString("NoOfInst"));
				loanDetails.put("Interest", executeQuery.getString("Interests"));
				loanDetails.put("PenIntrest", executeQuery.getString("PenIntrest"));
				loanDetails.put("IntType", executeQuery.getString("IntType"));
				loanDetails.put("PrvLoanAppNo", executeQuery.getString("PrvLoanAppNo"));
				loanDetails.put("RefNumber", executeQuery.getString("RefNumber"));
				loanDetails.put("LoanStatus", executeQuery.getString("LoanStatus"));
				loanDetails.put("LoanSanctionAmt", executeQuery.getString("LoanSanctionAmt"));
				date = executeQuery.getDate("LoanSanctionDate");
				strDate = "NA";
				if(date != null)  
					strDate = dateFormat.format(date);
				loanDetails.put("LoanSanctionDate", strDate);
				loanDetails.put("outstanding", executeQuery.getString("PrincipalCB"));
//				System.out.println(executeQuery.getString("PrincipalCB"));
				loanDetails.put("interestLeft", executeQuery.getString("InterestCB"));
				loanDetails.put("ClosedDate", executeQuery.getString("ClosedDate"));
				loanDetails.put("InterestCarryOvr", executeQuery.getString("InterestCarryOvr"));
				listOfLoans.add(loanDetails);
			}
			if(connection!=null){
				connection.close();
				}
				}catch(Exception e){
					e.printStackTrace();
				}
		return listOfLoans;
		
	}
	
	public  LinkedList<LoanAppDto> getLoanDetailsactive(String EmployeeCode,String recordType,String regStatus,String type) throws Exception {
		
	
		
		LinkedList<LoanAppDto> listOfLoans = new LinkedList<LoanAppDto>();
		Connection connection = null;
		try{
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			
		
			String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";
		
			
			CallableStatement cs1 = connection.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
//			System.out.println("----beforetype----"+regStatus+"|"+type);

			cs1.setString(1, regStatus);//
			cs1.setString(2,"");//SHAREMP
			cs1.setString(3,"");//New
			cs1.setString(4, "");//""
			cs1.setString(5, type);//""
			cs1.setString(6, "");
			cs1.setString(7, "");
			cs1.setString(8, "");
			cs1.setString(9,"");
			cs1.setString(10,"");
//			System.out.println("----type----"+regStatus+"|"+type);
			ResultSet executeQuery = cs1.executeQuery();
		    LoanAppDto view = null;
		while(executeQuery.next()){
			view  = new LoanAppDto();
             String memeAccNo=executeQuery.getString("MemAccNo").trim();
             
             String memName=executeQuery.getString("MemName").trim();
           
             String memCode=executeQuery.getString("MemEmpCode").trim();
         
             String loanAccNo=executeQuery.getString("LoanAccNo").trim();
       
             view.setLoanAccno(loanAccNo);
			view.setMemAccno(memeAccNo);
			view.setMemempcode(memCode);
			view.setMemname(memName);
			view.setEmployee(memeAccNo+"-" +memCode+"-"+loanAccNo+"-"+memName);
			
			
			view.setLoantype(executeQuery.getString("LoanType").trim());
			String loanpurpose=executeQuery.getString("LoanPurpose");
			if(loanpurpose.equals(""))
				loanpurpose="-";
			view.setLoanpurpose(loanpurpose);
			view.setNoofinstallments(executeQuery.getInt("NoOfInstallments"));
			view.setMonthlyinstall(executeQuery.getInt("MonthlyInstallments"));
			view.setThriftdudamt(executeQuery.getInt("Thriftdudamt"));
			view.setChequeAmount(executeQuery.getInt("ChequeAmount"));
			view.setBankname(executeQuery.getString("BankName").trim());
			view.setBankaccno(executeQuery.getString("bankaccno").trim().equals("")?"-":executeQuery.getString("bankaccno").trim());
			view.setThriftbalance(executeQuery.getInt("ThriftBalance"));
			view.setLoanstatus(executeQuery.getString("LoanStatus").trim());
			String fundid=executeQuery.getString("FundId");
//			if(fundid.equals(""))
//				fundid="-";
			view.setFundid(fundid);
			view.setLoansancamt(executeQuery.getInt("LoanSanctionAmount"));
//			System.out.println("interest rate "+executeQuery.getFloat("InterestRate"));			
			view.setInterests(executeQuery.getFloat("InterestRate"));
			view.setLoanappldate(executeQuery.getString("Loanappdate"));
			String loanreleaseddate=executeQuery.getString("Releaseddate");
			if(loanreleaseddate==null)
				loanreleaseddate="-";
			view.setReleaseddate(loanreleaseddate);
				String loanrejecteddate=executeQuery.getString("Loanrejecteddate");
				if(loanrejecteddate==null)
					loanrejecteddate="-";
				view.setLoanrejected(loanrejecteddate);
			
			String loansancdate=executeQuery.getString("LoanSanctionDate");
			if(loansancdate==null)
				loansancdate="-";
			view.setLoansancdate(loansancdate);
		
			
			
			String surity1=executeQuery.getString("Surety1");
			if(surity1.equals(""))
				surity1="-";
			view.setSurity1(surity1);
			String surity2=executeQuery.getString("Surety2");
			if(surity2.equals(""))
				surity2="-";
			view.setSurity2(surity2);
			String surity3=executeQuery.getString("Surety3");
			if(surity3.equals(""))
				surity3="-";
			view.setSurity3(surity3);
			
			
			view.setThriftsubamt(executeQuery.getInt("ThriftSubscriptionAmount"));
			view.setThriftbalance(executeQuery.getInt("ThriftBalance"));
			view.setShareamount(executeQuery.getString("ShareAmount"));
			view.setNoofshares(executeQuery.getString("NoOfShares"));
			
			
			
			listOfLoans.add(view);
			
		}
		if(connection!=null){
			connection.close();
			}
			}catch(Exception e){
				e.printStackTrace();
			}
		
		return listOfLoans;
	}
	//------------------------------------------------------//
	
	
	public  LinkedList<LoanAppDto> getApplicationInformation(String EmployeeCode,String recordType,String regStatus,String ApplNo) throws Exception {
	
		
		
		LinkedList<LoanAppDto> listOfLoans = new LinkedList<LoanAppDto>();
		Connection connection = null;
		try{
			connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?";
						
			
			CallableStatement cs1 = connection.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			

			cs1.setString(1, recordType);//
			cs1.setString(2,EmployeeCode);//SHAREMP
			cs1.setString(3,ApplNo);//New
			cs1.setString(4, "");//""
			cs1.setString(5, regStatus);//""
			cs1.setString(6, "");
			cs1.setString(7, "");
			cs1.setString(8, "");
			ResultSet executeQuery = cs1.executeQuery();
		LoanAppDto view = null;
		while(executeQuery.next()){
			view  = new LoanAppDto();
             String memeAccNo=executeQuery.getString("MemAccNo").trim();
             String memName=executeQuery.getString("MemName").trim();
             String memCode=executeQuery.getString("MemEmpCode").trim();
             String loanAccNo=executeQuery.getString("LoanAccNo").trim();
             view.setLoanAccno(loanAccNo);
			view.setMemAccno(memeAccNo);
			view.setMemempcode(memCode);
			view.setMemname(memName);
			view.setEmployee(memeAccNo+"-" +memCode+"-"+loanAccNo+"-"+memName);
			String pannum=executeQuery.getString("PanNo");
			if(pannum.equals(""))
				pannum="-";
			view.setPan(pannum);
			
              String AadharNo = executeQuery.getString("AadharNo");
		      AadharNo=(null!=AadharNo?AadharNo.trim():AadharNo); 
		      view.setAadhar(AadharNo);
			
			String mailid=executeQuery.getString("MailId");
			if(mailid.equals(""))
				mailid="-";
			view.setMailid(mailid);
			
			view.setDesignation(executeQuery.getString("Designation").trim());
			view.setDivision(executeQuery.getString("Division").trim());
			
			String phonenum=executeQuery.getString("Phone");
			if(phonenum.contains(""))
				phonenum="-";
			view.setPhone(phonenum);
			String offcphonenum=executeQuery.getString("OffPhone");
			if(offcphonenum.equals(""))
				offcphonenum="-";
			view.setOffcphone(offcphonenum);
			
			view.setBankaccno(executeQuery.getString("BankAccNo").trim());
			view.setIfsccode(executeQuery.getString("IfscCode").trim());
			view.setBankname(executeQuery.getString("BankName").trim());
			view.setBankaddress(executeQuery.getString("BankAddress").trim());
			view.setBasicpay(executeQuery.getInt("BasicPay"));
			view.setDob(executeQuery.getString("Dob").trim());
			view.setRetirementdate(executeQuery.getString("RetiredDate").trim());
			String careof=executeQuery.getString("CareOf");
			if(careof.equals(""))
				careof="-";
			view.setCareof(careof);
			
			view.setLoantype(executeQuery.getString("LoanType").trim());
			String loanpurpose=executeQuery.getString("LoanPurpose");
			if(loanpurpose.equals(""))
				loanpurpose="-";
			view.setLoanpurpose(loanpurpose);
			view.setNoofinstallments(executeQuery.getInt("NoOfInstallments"));
			view.setMonthlyinstall(executeQuery.getInt("MonthlyInstallments"));
			view.setThriftdudamt(executeQuery.getInt("Thriftdudamt"));
			
			view.setLoanstatus(executeQuery.getString("LoanStatus").trim());
			String fundid=executeQuery.getString("FundId");
			if(fundid.equals(""))
				fundid="-";
			view.setFundid(fundid);
			view.setLoansancamt(executeQuery.getInt("LoanSanctionAmount"));
			view.setInterests(executeQuery.getFloat("InterestRate"));
			view.setLoanappldate(executeQuery.getString("Loanappdate").trim());
			String loansancdate=executeQuery.getString("LoanSanctionDate");
			if(loansancdate==null)
				loansancdate="-";
			view.setLoansancdate(loansancdate);
			String surity1=executeQuery.getString("Surety1");
			if(surity1.equals(""))
				surity1="-";
			view.setSurity1(surity1);
			String surity2=executeQuery.getString("Surety2");
			if(surity2.equals(""))
				surity2="-";
			view.setSurity2(surity2);
			String surity3=executeQuery.getString("Surety3");
			if(surity3.equals(""))
				surity3="-";
			view.setSurity3(surity3);
			view.setThriftsubamt(executeQuery.getInt("ThriftSubscriptionAmount"));
			view.setThriftbalance(executeQuery.getInt("ThriftBalance"));
			view.setShareamount(executeQuery.getString("ShareAmount"));
			view.setNoofshares(executeQuery.getString("NoOfShares"));
			
			listOfLoans.add(view);
			
		}
		if(connection!=null){
			connection.close();
			}
			}catch(Exception e){
				e.printStackTrace();
			}
		
		return listOfLoans;
	}
	
	
	
	
}
