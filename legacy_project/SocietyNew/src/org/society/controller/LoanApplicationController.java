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
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
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
import org.society.dto.MembershipDto;
import org.society.service.GenericDetailsService;
import org.society.service.LoanApplicationService;
import org.society.util.ConvertListToJSONArray;
import org.society.util.DataBaseConnectionForNewDB;

@SuppressWarnings("serial")
@WebServlet("/LoanApplication")
public class LoanApplicationController extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String inComingRequest = request.getParameter("req");
		LoanApplicationService loanApplicationService = null;
		JSONObject jsonObject = null;
		PrintWriter out = response.getWriter();
		GenericDetailsService genericDetailsService  = null;
		Connection connection = null;
		Statement  statement5 = null;
		HttpSession session = request.getSession();
		try {


			if("getMemberDetails".equalsIgnoreCase(inComingRequest)){


				String memAccountNumber = request.getParameter("memAccountNumber").trim();

				loanApplicationService = new LoanApplicationService();

				LinkedList<MembershipDto> memberInformation = loanApplicationService.getMemberInformation("", "SOCIETYMEM", "ACTIVE", memAccountNumber);

				Collection collection = memberInformation;
				MembershipDto membershipDto = memberInformation.get(0);

				jsonObject = ConvertListToJSONArray.convertCollection(collection, "MEMBERDETAILS");
				response.getWriter().write(jsonObject.toString());


			}

			if(inComingRequest.equalsIgnoreCase("getInterestRateloan")){
				String opendate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("opendate").trim()));
				String loantype = request.getParameter("loantype");
				String memeaccno = request.getParameter("memeaccno");
				genericDetailsService = new GenericDetailsService();
				float interestRateloan = genericDetailsService.getInterestRatesloan(opendate,loantype,memeaccno);
//				System.out.println("interest rate "+interestRateloan);
				jsonObject = new JSONObject();
				jsonObject.put("INTERESTRATELOAN", interestRateloan);
				response.getWriter().write(jsonObject.toString());

			}




			if(inComingRequest.equals("getLoanInfo")){



				String LoanType = null;
				String MemAccNo = null;
				String Loanappno = request.getParameter("Loanappno");


				try{
					connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
					Statement statement = connection.createStatement();
					String sqlQuery="speccs.SP_Loans 'GETLOANINFO','','"+Loanappno+"'";
					//String sqlQuery="speccs.SP_Loans 'GETLOANINFO','','"+memEmployeeCode+"','','',0,0,0,0,'',0,'',0,'','','','','','','',''";
					//			System.out.println("sqlQuery"+sqlQuery);
					ResultSet rsEmployeeCodeList = statement.executeQuery(sqlQuery);


					JSONArray array = new JSONArray();

					if(rsEmployeeCodeList.next()){
						jsonObject = new JSONObject();
						String BasicPay=rsEmployeeCodeList.getString("BasicPay");
						String NoOfShares=rsEmployeeCodeList.getString("NoOfShares");
						String ShareAmount=rsEmployeeCodeList.getString("ShareAmount");
						MemAccNo=rsEmployeeCodeList.getString("MemAccNo");
						String LoanAccNo=rsEmployeeCodeList.getString("LoanAccNo");
						LoanType=rsEmployeeCodeList.getString("LoanType");
						String LoanPurpose=rsEmployeeCodeList.getString("LoanPurpose");
						String NoOfInstallments=rsEmployeeCodeList.getString("NoOfInstallments");
						String MonthlyInstallments=rsEmployeeCodeList.getString("MonthlyInstallments");
						String Thriftdudamt=rsEmployeeCodeList.getString("Thriftdudamt");
						int ThriftBalance=rsEmployeeCodeList.getInt("ThriftBalance");
						String FundId=rsEmployeeCodeList.getString("FundId");
						String LoanSanctionAmount=rsEmployeeCodeList.getString("LoanSanctionAmount");
						String InterestMethod=rsEmployeeCodeList.getString("InterestMethod");
						String InterestRate=rsEmployeeCodeList.getString("InterestRate");
						String LoanSanctionDate=rsEmployeeCodeList.getString("LoanSanctionDate");
						String Surety1=rsEmployeeCodeList.getString("Surety1");
						String Surety2=rsEmployeeCodeList.getString("Surety2");
						String Surety3=rsEmployeeCodeList.getString("Surety3");
						String Loanappdate=rsEmployeeCodeList.getString("Loanappdate");
						String Loanrejecteddate=rsEmployeeCodeList.getString("Loanrejecteddate");
						String Remarks=rsEmployeeCodeList.getString("Remarks");


						if(BasicPay==null) BasicPay="";
						if(NoOfShares==null) NoOfShares="";
						if(ShareAmount==null) ShareAmount="";
						if(MemAccNo==null) MemAccNo="";
						if(LoanAccNo==null) LoanAccNo="";
						if(LoanType==null) LoanType="";
						if(LoanPurpose==null) LoanPurpose="";
						if(NoOfInstallments==null) NoOfInstallments="";
						if(MonthlyInstallments==null) MonthlyInstallments="";
						if(Thriftdudamt==null) Thriftdudamt="";
						if(FundId==null) FundId="";
						if(LoanSanctionAmount==null) LoanSanctionAmount="";
						if(InterestMethod==null) InterestMethod="";
						if(InterestRate==null) InterestRate="";
						if(Surety1==null) Surety1="";
						if(Surety2==null) Surety2="";
						if(Surety3==null) Surety3="";
						if(Remarks==null) Remarks="";
						if(LoanSanctionDate==null) LoanSanctionDate="";
						else LoanSanctionDate=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("LoanSanctionDate"));
						if(Loanappdate==null) Loanappdate="";
						else Loanappdate=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("Loanappdate"));
						if(Loanrejecteddate==null) Loanrejecteddate="";
						else Loanrejecteddate=new SimpleDateFormat("dd/MM/yyyy").format(rsEmployeeCodeList.getDate("Loanrejecteddate"));


						jsonObject.put("BasicPay", BasicPay);
						jsonObject.put("NoOfShares", NoOfShares);
						jsonObject.put("ShareAmount", ShareAmount);
						jsonObject.put("MemAccNo", MemAccNo);
						jsonObject.put("LoanAccNo", LoanAccNo);
						jsonObject.put("LoanType", LoanType);
						jsonObject.put("LoanPurpose", LoanPurpose);
						jsonObject.put("NoOfInstallments", NoOfInstallments);
						jsonObject.put("MonthlyInstallments", MonthlyInstallments);
						jsonObject.put("Thriftdudamt", Thriftdudamt);
						jsonObject.put("FundId", FundId);
						jsonObject.put("LoanSanctionAmount", LoanSanctionAmount);
						jsonObject.put("InterestMethod", InterestMethod);
						jsonObject.put("InterestRate", InterestRate.trim());
						jsonObject.put("Surety1", Surety1);
						jsonObject.put("Surety2", Surety2);
						jsonObject.put("Surety3", Surety3);
						jsonObject.put("LoanSanctionDate", LoanSanctionDate);
						jsonObject.put("Loanappdate", Loanappdate);
						jsonObject.put("Loanrejecteddate", Loanrejecteddate);
						jsonObject.put("thriftavailbleamount", ThriftBalance);
						jsonObject.put("Remarks", Remarks);

						array.put(jsonObject);
						//				

					}
					sqlQuery  = "{CALL speccs.SP_LoanDetails (?,?,?,?,?,?,?,?,?,?)}";
					CallableStatement cs1 = connection.prepareCall(sqlQuery);
					cs1.setString(1, "PRVLOAN");
					cs1.setString(2, MemAccNo);
					cs1.setString(3, "");
					cs1.setString(4,LoanType);
					cs1.setString(5,"");
					cs1.setString(6,"");
					cs1.setString(7,"");
					cs1.setString(8,"");
					cs1.setString(9,"");
					cs1.setString(10,"");
					ResultSet executeQuery = cs1.executeQuery();
					JSONArray array1 = new JSONArray();

					String prvLoanAccNo="";
					String prvLoanSanctionAmount="";

					if(executeQuery.next()){
						jsonObject = new JSONObject();
						String string = executeQuery.getString("LoanAccNo");
						boolean contains = string.contains(LoanType);
						if(contains){
							prvLoanAccNo=rsEmployeeCodeList.getString("LoanAccNo");
							prvLoanSanctionAmount=rsEmployeeCodeList.getString("LoanSanctionAmount");
							if(prvLoanAccNo==null) prvLoanAccNo="";
							if(prvLoanSanctionAmount==null) prvLoanSanctionAmount="";
							jsonObject.put("prvLoanAccNo", prvLoanAccNo);
							jsonObject.put("prvLoanSanctionAmount", prvLoanSanctionAmount);
							array1.put(jsonObject);
						}
					}else{
						jsonObject = new JSONObject();
						prvLoanAccNo="0";
						prvLoanSanctionAmount="0";
						jsonObject.put("prvLoanAccNo", prvLoanAccNo);
						jsonObject.put("prvLoanSanctionAmount", prvLoanSanctionAmount);
						array1.put(jsonObject);
					}



					jsonObject = new JSONObject();
					jsonObject.put("LoanDetails", array);
					jsonObject.put("PRVLoanDetails", array1);
					jsonObject.put("success", "y");
					response.getWriter().write(jsonObject.toString());

					if(connection !=null){
						connection.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection !=null){
						connection.close();	
					}
				}

			}





			if("getLoanTypes".equalsIgnoreCase(inComingRequest)){
				loanApplicationService = new LoanApplicationService();
				List<Map<String,String>> loanTypes = loanApplicationService.getLoanTypes();
				jsonObject = new   JSONObject();
				jsonObject.put("LOANTYPES", loanTypes);
				response.getWriter().write(jsonObject.toString());
			}

			if("getLoanTypesload".equalsIgnoreCase(inComingRequest)){
				loanApplicationService = new LoanApplicationService();
				List<Map<String,String>> loanTypes = loanApplicationService.getLoanTypesload();
				jsonObject = new   JSONObject();
				jsonObject.put("LOANTYPECODE", loanTypes);
				for(int i=0;i<loanTypes.size();i++) {
					//System.out.println(loanTypes(i));
				}
				response.getWriter().write(jsonObject.toString());
			}

			if("depositNumbers".equalsIgnoreCase(inComingRequest)){
				Connection	connection2 =null;


				try{
					connection2=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String empCode = request.getParameter("empCode");

					genericDetailsService = new GenericDetailsService();
					String sqlQuery="speccs.SP_DepositsDetails 'DEPOSITNUM','','','','"+empCode+"'";
					PreparedStatement ps2 = connection2.prepareStatement(sqlQuery);
					ResultSet rsDeposits = ps2.executeQuery();
					Map<String,String> depositDetails  = null;
					LinkedList<Map<String, String>> depositDetailsList = new LinkedList<>();
					while(rsDeposits.next()){

						depositDetails = new HashMap<>();
						depositDetails.put("DepositNo", rsDeposits.getString("DepositNo"));
						depositDetails.put("Subscription", String.valueOf(rsDeposits.getDouble("Subscription")));
						depositDetails.put("AmountNo", rsDeposits.getString("DepositNo")+"~"+String.valueOf(rsDeposits.getDouble("Subscription"))+"~"+String.valueOf(rsDeposits.getDouble("IntRate")));
						depositDetailsList.add(depositDetails);
					}
					jsonObject = new JSONObject();
					jsonObject.put("DEPOSITSDETAILS", depositDetailsList);
					jsonObject.put("ERROR", "NO");
					response.getWriter().write(jsonObject.toString());
					if(connection2 !=null){
						connection2.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection2 !=null){
						connection2.close();	
					}
				}

			}

			if("depositNumbersload".equalsIgnoreCase(inComingRequest)){
				Connection	connection3=null;

				try{
					connection3 = DataBaseConnectionForNewDB.getConnectionForSyBase();
					String funid = request.getParameter("funid");

					genericDetailsService = new GenericDetailsService();
					String sqlQuery="speccs.SP_DepositsDetails 'DEPOSITNUMLOAD','','','"+funid+"',''";
					PreparedStatement ps2 = connection3.prepareStatement(sqlQuery);
					ResultSet rsDeposits = ps2.executeQuery();
					Map<String,String> depositDetails  = null;
					LinkedList<Map<String, String>> depositDetailsList = new LinkedList<>();


					while(rsDeposits.next()){

						depositDetails = new HashMap<>();
						depositDetails.put("DepositNo", rsDeposits.getString("DepositNo"));
						depositDetails.put("AmountNo", rsDeposits.getString("DepositNo")+"~"+String.valueOf(rsDeposits.getDouble("Subscription")));
						depositDetailsList.add(depositDetails);
					}
					jsonObject = new JSONObject();
					jsonObject.put("DEPOSITSDETAILSLOAD", depositDetailsList);
					jsonObject.put("ERROR", "NO");
					response.getWriter().write(jsonObject.toString());
					if(connection3 !=null){
						connection3.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection3 !=null){
						connection3.close();	
					}
				}

			}

			if("calulateLoanEligibilyAmount".equalsIgnoreCase(inComingRequest)){

				String fdNumber = request.getParameter("fdNumber");
				String memAccountNumber = request.getParameter("empCode");

				String loanType = request.getParameter("loanType");
				int remainingbal=0;

				loanApplicationService = new LoanApplicationService();
				/*try {
					Map<String, String> rembal = loanApplicationService.getLoanDetails(memAccountNumber, loanType, fdNumber);

					//			System.out.println("----1111---rembal"+rembal.get("OutstandingAmt"));

					remainingbal=(int)Double.parseDouble(rembal.get("OutstandingAmt"));
				}*/
					LinkedList<MembershipDto> memberInformation = loanApplicationService.getMemberInformation("", "SOCIETYMEM", "ACTIVE", memAccountNumber);
					MembershipDto membershipDto = memberInformation.get(0);
					genericDetailsService = new GenericDetailsService();
					double loanEligbleAmount = 0;
					//System.out.println("outside "+loanEligbleAmount);
					if(loanType.equals("LTL")){

						int noOfTimesLoanElgAmt = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("101", "Value"));
						int basicPay = membershipDto.getBasicPay();
						int thriftAmnt = membershipDto.getThriftAmount();
						int thriftRule = (int)  Double.parseDouble(genericDetailsService.getSocietyRuleValue("102", "Value"));
						if(thriftAmnt>(noOfTimesLoanElgAmt*basicPay*thriftRule*0.01))
							loanEligbleAmount=(noOfTimesLoanElgAmt*basicPay)+(thriftAmnt-(noOfTimesLoanElgAmt*basicPay*thriftRule*0.01));
						else
							loanEligbleAmount = noOfTimesLoanElgAmt*basicPay;
						
						int maxLoanAmtAddedSocietyRule = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("106", "Value"));
						int maxLoanAmtSocietyRule = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("107", "Value"));
						if(loanEligbleAmount > maxLoanAmtSocietyRule) {
							loanEligbleAmount = maxLoanAmtSocietyRule;
							//					System.out.println(loanEligbleAmount+" loan eligible amount in LTL");
						}
						if(loanEligbleAmount < maxLoanAmtAddedSocietyRule) {
							loanEligbleAmount = maxLoanAmtAddedSocietyRule;
							//					System.out.println(loanEligbleAmount+" loan eligible amount in LTL");
						}
					}


					if(loanType.equals("EXL")){

						int noOfTimesLoanElgAmt = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("125", "Value"));

						int totalShares = membershipDto.getShareAmount();


						loanEligbleAmount = (totalShares * noOfTimesLoanElgAmt ) ;

						//				System.out.println(loanEligbleAmount+" loan eligible amount in EXL");

					}

					if(loanType.equalsIgnoreCase("FDL")){
						int fdLoanElg = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("126", "Value"));
						int fdAmount = (int) Double.parseDouble(request.getParameter("fdAmount"));
						loanEligbleAmount = (fdAmount * fdLoanElg ) / 100;
						//				System.out.println(loanEligbleAmount+" loan eligible amount in FDL");

					}



					jsonObject = new JSONObject();
					jsonObject.put("loanEligbleAmount", loanEligbleAmount);
//					jsonObject.put("OutstandingAmt", remainingbal);
					response.getWriter().write(jsonObject.toString());
				
			}



			if("LoanEligibilyAmountCalulation".equalsIgnoreCase(inComingRequest)){
				String ApplNo = request.getParameter("empCode");


				String loanType = request.getParameter("loanType");



				loanApplicationService = new LoanApplicationService();
				LinkedList<MembershipDto> memberInformation = loanApplicationService.getApplicationInformation("", "SOCIETYMEM", "DRAFT", "");
				MembershipDto membershipDto = memberInformation.get(1);
				genericDetailsService = new GenericDetailsService();
				double loanEligbleAmount = 0;
				if(loanType.equals("LTL")){
					int noOfTimesLoanElgAmt = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("101", "Value"));
					int basicPay = membershipDto.getBasicPay();
					loanEligbleAmount = noOfTimesLoanElgAmt*basicPay;	

					int maxLoanAmtAddedSocietyRule = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("106", "Value"));
					int maxLoanAmtSocietyRule = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("107", "Value"));

					if(loanEligbleAmount > maxLoanAmtSocietyRule)
						loanEligbleAmount = maxLoanAmtSocietyRule;
					if(loanEligbleAmount < maxLoanAmtAddedSocietyRule)
						loanEligbleAmount = maxLoanAmtAddedSocietyRule;
				}


				if(loanType.equals("EXL")){
					int noOfTimesLoanElgAmt = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("125", "Value"));
					int totalShares = membershipDto.getShareAmount();
					loanEligbleAmount = (totalShares * noOfTimesLoanElgAmt ) ;


				}

				if(loanType.equalsIgnoreCase("FDL")){
					int fdLoanElg = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("126", "Value"));
					int fdAmount = (int) Double.parseDouble(request.getParameter("fdAmount"));
					loanEligbleAmount = (fdAmount * fdLoanElg ) / 100;


				}



				jsonObject = new JSONObject();
				jsonObject.put("EligbleAmountForLoan", loanEligbleAmount);

				response.getWriter().write(jsonObject.toString());
			}

			if("MinLoanEligibilyAmount".equalsIgnoreCase(inComingRequest)){

				String loanType = request.getParameter("loanType");
				genericDetailsService = new GenericDetailsService();
				double minLoanEligibleAmt = 0;
				if(loanType.equals("LTL")){

					minLoanEligibleAmt=Double.parseDouble(genericDetailsService.getSocietyRuleValue("106", "Value"));

				}
				jsonObject = new JSONObject();
				jsonObject.put("minLoanEligibleAmt", minLoanEligibleAmt);
				response.getWriter().write(jsonObject.toString());
			}



			if("getRulesOfLoans".equalsIgnoreCase(inComingRequest)){

				String loanType = request.getParameter("loanType");

				genericDetailsService = new GenericDetailsService();
				int noOfInstallment = 0;
				String thriftPerc = "";
				if(loanType.equals("EXL")){
					noOfInstallment = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("116", "Value"));
				}
				if(loanType.equals("FDL")){
					noOfInstallment = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("129", "Value"));
				}
				if(loanType.equals("LTL")){

					noOfInstallment = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("111", "Value"));
					thriftPerc = genericDetailsService.getSocietyRuleValue("102", "Value");
				}
				jsonObject = new JSONObject();
				jsonObject.put("noOfInstallment", noOfInstallment);
				jsonObject.put("thriftPerc", thriftPerc);
				response.getWriter().write(jsonObject.toString());
			}


			if("checkInLoanBoth".equalsIgnoreCase(inComingRequest)){

				String memAccountNumber = request.getParameter("memAccountNumber");

				String fdNumber = request.getParameter("fdNumber");
				String loanType = request.getParameter("loanType");

				loanApplicationService = new LoanApplicationService();
				Map<String, String> loanDetails = loanApplicationService.getLoanDetails(memAccountNumber, loanType, fdNumber);
//				System.out.println("-------loanDetails  "+loanDetails.toString()+" SIZE "+loanDetails.size());
				
				if(loanDetails.size()==0){
					loanDetails.put("previousLoan",""+0);
					loanDetails.put("LoanStatus","NEWLOAN");
				}
				jsonObject = new JSONObject();

				if(loanDetails.size() == 5){
					jsonObject.put("MYOBJECT", loanDetails);
				}
				else{
					jsonObject.put("MYOBJECT",loanDetails);
					//jsonObject.put("previousLoan", "NEWLOAN");
				}
//				System.out.println("-------loanDetails is "+jsonObject.toString());
				response.getWriter().write(jsonObject.toString());
			}


			if("loadSurety".equalsIgnoreCase(inComingRequest)){
				Connection	connection4 =null;

				try{
					connection4=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String memAccountNumber = request.getParameter("memAccNo");
					System.out.println("memAccountNumber  "+memAccountNumber);
					String option="";
					if(!memAccountNumber.equals("")||memAccountNumber!=""){
						option="MEMELGTOBSURETY";						
					}
					else
					{
						
						option="MEMSURETYDETAIL";
						System.out.println(option);
					}

					Statement statement = connection4.createStatement();	

					String sqlQuery = "{CALL speccs.SP_Surety(?,?,?,?,?,?)}";
					CallableStatement cs1 = connection4.prepareCall(sqlQuery);

					cs1.setString(1, option);
					cs1.setString(2, memAccountNumber);
					cs1.setString(3, null);
					cs1.setInt(4, 0);
					cs1.setString(5, null);
					cs1.setString(6, null);
					ResultSet executeQuery = cs1.executeQuery();

					LinkedList<Map<String, String>> list = new LinkedList<>();
					Map<String, String> details= null;
					while (executeQuery.next()) {
						details = new HashMap<String, String>();
						String surety = executeQuery.getString(1)+"-"+executeQuery.getInt(2);

						String memAccno = surety.split("-")[0];
						String thriftAmt = surety.split("-")[2];

						details.put("memAccNo", memAccno);
						details.put("detail", surety);
						details.put("thriftAmt", thriftAmt);
						list.add(details);
					}
					jsonObject = new JSONObject();
					jsonObject.put("SURDETAILS", list);

					response.getWriter().write(jsonObject.toString());
					if(connection4 !=null){
						connection4.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection4 !=null){
						connection4.close();	
					}
				}
			}



			if("getSurety".equalsIgnoreCase(inComingRequest)){
				String EmpCode = request.getParameter("memAccNo");


				Connection connection5 =null;
				try{
					connection5 =DataBaseConnectionForNewDB.getConnectionForSyBase();
					Statement statement = connection5.createStatement();
					JSONArray array = new JSONArray();

					String sqlQuery = "SELECT mem.MemAccNo,mem.MemName,acc.ThriftBalance FROM speccs.Members mem LEFT JOIN speccs.MemberAccount acc ON mem.MemAccNo = acc.MemAccNo ";
					CallableStatement cs1 = connection.prepareCall(sqlQuery);
					ResultSet rs = cs1.executeQuery();

					while(rs.next()){
						jsonObject = new JSONObject();

						String MemAccNo=rs.getString("MemAccNo");
						String MemName=rs.getString("MemName");
						String ThriftBalance=rs.getString("ThriftBalance");


						if(MemAccNo==null) MemAccNo="";
						if(MemName==null) MemName="";
						if(ThriftBalance==null) ThriftBalance="";



						jsonObject.put("MemAccNo", MemAccNo.trim());
						jsonObject.put("MemName", MemName.trim());
						jsonObject.put("ThriftBalance", ThriftBalance.trim());


						array.put(jsonObject);
					}

					jsonObject = new JSONObject();
					jsonObject.put("GETSURDETAILS", array);

					response.getWriter().write(jsonObject.toString());
					if(connection5 !=null){
						connection5.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection5 !=null){
						connection5.close();	
					}
				}
			}



			if("saveApplication".equalsIgnoreCase(inComingRequest)){
				Connection connection6 =null;
				try{
					connection6=DataBaseConnectionForNewDB.getConnectionForSyBase();

					String option = request.getParameter("option").toUpperCase();
					String loanappnum = request.getParameter("loanappnum");
					//System.out.println("loan number is "+loanappnum);
					String memAccNo = request.getParameter("memAccNo");
					String loanType = request.getParameter("loanType");
					//System.out.println("loanType number is "+loanType);
					String loanPuropse = request.getParameter("loanPuropse");
					int installmentNumber = Integer.parseInt(request.getParameter("installmentNumber"));
					String installmentNumbermonthly = request.getParameter("installmentNumbermonthly");
					String thriftdudamt = request.getParameter("thriftdudamt");
					String chequeAmount = request.getParameter("chequeAmount");
					String FDNumbers = request.getParameter("FDNumbers");
					String loanAmount = request.getParameter("loanAmount").trim();
					String loanApplicationDate = request.getParameter("loanApplicationDate");
					String surityDetails1 = request.getParameter("surityDetails1");
					String surityDetails2 = request.getParameter("surityDetails2");
					String surityDetails3 = request.getParameter("surityDetails3");
					loanApplicationDate = loanApplicationDate.split("/")[1]+"/"+loanApplicationDate.split("/")[0]+"/"+loanApplicationDate.split("/")[2];
					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String Remarks = request.getParameter("Remarks");
					String ipaddress=request.getRemoteHost();



					int installmentmonth=Integer.parseInt(installmentNumbermonthly);
					int thriftduamt = Integer.parseInt(thriftdudamt);
					int chequeAmt=Integer.parseInt(chequeAmount);
					int loanAmt = Integer.parseInt(loanAmount);
					float interestRate=Float.parseFloat(request.getParameter("interest"));

					statement5 = connection6.createStatement();
					if(loanType.equals("LTL") || loanType.equals("EXL")) {
					String query ="{CALL speccs.Sp_getInterestRates (?,?,?,?,?)}";
					CallableStatement cs1 = connection6.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
					cs1.setString(1, "Value");
					cs1.setString(2, loanType);
					cs1.setInt(3, 0);
					cs1.registerOutParameter(4, Types.NUMERIC);
					cs1.setString(5, "");
					int rs2 = cs1.executeUpdate();

					interestRate = cs1.getFloat(4);
					}
					//System.out.println("interestRate is "+interestRate);
					
					if(option.equals("UPDATE")){

						String sqlQuery = "{call speccs.SP_Loans(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";

						CallableStatement cStatement = connection6.prepareCall(sqlQuery);
						cStatement.setString(1, option);
						cStatement.setString(2,memAccNo);
						cStatement.setString(3,loanappnum);
						cStatement.setString(4, loanType);
						cStatement.setString(5, loanPuropse);
						cStatement.setInt(6, installmentNumber);
						cStatement.setInt(7, installmentmonth);
						cStatement.setInt(8, thriftduamt);
						//System.out.println("-=----chequeAmount"+chequeAmount);
						cStatement.setLong(9, chequeAmt);
						cStatement.setString(10,FDNumbers );
						cStatement.setInt(11, loanAmt);
						cStatement.setString(12, loanApplicationDate);
						cStatement.setFloat(13, interestRate);
						cStatement.setString(14, surityDetails1);
						cStatement.setString(15, surityDetails2);
						cStatement.setString(16, surityDetails3);
						cStatement.setString(17,userId);
						//System.out.println("user id is  "+userId);
						cStatement.setString(18,Remarks);
						cStatement.setString(19,ipaddress);
						cStatement.registerOutParameter(20, Types.VARCHAR);

						cStatement.executeUpdate();

						String loanAppNum = null;
						String msg = "Failed to update";
						if(option.equalsIgnoreCase("UPDATE")){
							loanAppNum = cStatement.getString(20);

							msg = "Successfully Updated";
						}
						else{
							msg =  msg;
						}


						jsonObject = new JSONObject();
						jsonObject.put("loanAppNum", loanAppNum);
						jsonObject.put("SUCCESS", "Y");
						jsonObject.put("msg", msg);
						//jsonObject.put("SUCCESS", "TRUE");
						response.getWriter().write(jsonObject.toString());
						if(connection6 !=null){
							connection6.close();	
						}
					}else{

						String sqlQuery = "{call speccs.SP_Loans(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
						//System.out.println("interest rate inside else "+interestRate);
						CallableStatement cStatement = connection6.prepareCall(sqlQuery);
						cStatement.setString(1, option); 
						cStatement.setString(2,memAccNo); 
						cStatement.setString(3,"");   
						cStatement.setString(4, loanType);
						cStatement.setString(5, loanPuropse);  
						cStatement.setInt(6, installmentNumber);  
						cStatement.setInt(7, installmentmonth); 
						cStatement.setInt(8, thriftduamt);
						cStatement.setLong(9, chequeAmt);
						cStatement.setString(10,FDNumbers);  
						cStatement.setInt(11, loanAmt);   
						cStatement.setString(12, loanApplicationDate); 
						cStatement.setFloat(13, interestRate);  
						cStatement.setString(14, surityDetails1); 
						cStatement.setString(15, surityDetails2); 
						cStatement.setString(16, surityDetails3); 
						cStatement.setString(17,userId); 
						//			System.out.println("user id is  "+userId);
						cStatement.setString(18,Remarks); 
						cStatement.setString(19,ipaddress); 
						//			System.out.println("--------ipaddress"+ipaddress);
						//			System.out.println("---------Types.VARCHAR"+Types.VARCHAR);
						cStatement.registerOutParameter(20, Types.VARCHAR);

						cStatement.executeUpdate();

						String loanAppNum = null;
						String msg = "Failed to save";
						if(option.equalsIgnoreCase("SAVE")){
							loanAppNum = cStatement.getString(20);
							System.out.println("loanAppNum "+loanAppNum);
							/*if(loanAppNum.equals(null))		// added by pn on 15/05/2025 for previously existing loan
								msg = "Loan application has been Successfully submitted " ;
							else*/
								msg = "New Loan application for "+loanAppNum+" Successfully submitted " ;
						}
						else{
							msg =  msg;
						}


						jsonObject = new JSONObject();
						jsonObject.put("loanAppNum", loanAppNum);
						jsonObject.put("SUCCESS", "Y");
						jsonObject.put("msg", msg);
						//jsonObject.put("SUCCESS", "TRUE");
						response.getWriter().write(jsonObject.toString());
						if(connection6 !=null){
							connection6.close();	
						}
					}

				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection6 !=null){
						connection6.close();
					}
				}
			}


			if("approve".equalsIgnoreCase(inComingRequest)){

				Connection connection7 =null;
				try{
					connection7=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String loanAccno = request.getParameter("loanAccno").trim();

					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String ipaddress=request.getRemoteHost();
					String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

					CallableStatement cStatement = connection7.prepareCall(sqlQuery);
					cStatement.setString(1, "STATUSUPDATE");
					cStatement.setString(2,loanAccno);
					cStatement.setString(3,userId);
					cStatement.setString(4, "");
					cStatement.setString(5, "ACTIVE");
					cStatement.setString(6, "");
					cStatement.setString(7, "");
					cStatement.setString(8, ipaddress);
					cStatement.setString(9,"");
					cStatement.setString(10,"");
					cStatement.executeUpdate();

					jsonObject = new JSONObject();
					jsonObject.put("SUCCESS", "Y");
					response.getWriter().write(jsonObject.toString());
					if(connection7 !=null){
						connection7.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection7 !=null){
						connection7.close();	
					}
				}
			}
			if("cancel".equalsIgnoreCase(inComingRequest)){

				Connection connection8 =null;
				try{
					connection8=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String loanAccno = request.getParameter("loanAccno").trim();

					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String ipaddress=request.getRemoteHost();
					String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

					CallableStatement cStatement = connection8.prepareCall(sqlQuery);
					cStatement.setString(1, "STATUSUPDATE");
					cStatement.setString(2,loanAccno);
					cStatement.setString(3,userId);
					cStatement.setString(4, "");
					cStatement.setString(5, "CANCELED");
					cStatement.setString(6, "");
					cStatement.setString(7, "");
					cStatement.setString(8, ipaddress);
					cStatement.setString(9,"");
					cStatement.setString(10,"");
					cStatement.executeUpdate();

					jsonObject = new JSONObject();
					jsonObject.put("SUCCESS", "Y");
					response.getWriter().write(jsonObject.toString());
					if(connection8 !=null){
						connection8.close();
					}

				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection8 !=null){
						connection8.close();
					}
				}
			}

			if(inComingRequest.equals("update")){
				Connection connection9 =null;
				try{

					connection9=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String option = request.getParameter("option");

					String LoanAppNo = request.getParameter("LoanAppNo");
					String Remarks = request.getParameter("Remarks");
					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String emplcode = request.getParameter("emplcode");


					String ipaddress=request.getRemoteHost();


					String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

					CallableStatement cStatement = connection9.prepareCall(sqlQuery);
					cStatement.setString(1, option);
					cStatement.setString(2,LoanAppNo);
					cStatement.setString(3,userId);
					cStatement.setString(4, emplcode);
					cStatement.setString(5, "SANCTION");
					cStatement.setString(6, "");
					cStatement.setString(7, Remarks);
					cStatement.setString(8, ipaddress);
					cStatement.setString(9,"");
					cStatement.setString(10,"");
					cStatement.executeUpdate();
					jsonObject = new JSONObject();
					jsonObject.put("success", "Y");
					response.getWriter().write(jsonObject.toString());
					if(connection9 !=null){
						connection9.close();
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection9 !=null){
						connection9.close();
					}
				}
			}


			if(inComingRequest.equals("relinitiate")){

				Connection connection10 =null;
				try{
					connection10=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String LoanAppNo = request.getParameter("LoanAppNo");
					String Remarks = request.getParameter("Remarks");
					String recFromDate =  request.getParameter("recFromDate");
					
					String userId = (String) session.getAttribute("EMPLOYEECODE");
					
					String emplcode = request.getParameter("emplcode");
					


					String ipaddress=request.getRemoteHost();

					recFromDate = recFromDate.split("/")[1]+"/"+recFromDate.split("/")[0]+"/"+recFromDate.split("/")[2];
					//			System.out.println("current date "+ recFromDate);
					while(LoanAppNo!=null) {
						String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

						CallableStatement cStatement = connection10.prepareCall(sqlQuery);

						cStatement.setString(1, "RELINIT");
						cStatement.setString(2,LoanAppNo);
						cStatement.setString(3,userId);
						cStatement.setString(4,emplcode);
						cStatement.setString(5,"RELINITE");
						cStatement.setString(6, recFromDate);
						cStatement.setString(7,Remarks);
						cStatement.setString(8,ipaddress);
						cStatement.setString(9,"");
						cStatement.setString(10,"");
						cStatement.executeUpdate();

						jsonObject = new JSONObject();
						jsonObject.put("success", "Y");
						response.getWriter().write(jsonObject.toString());
					}
					if(connection10 !=null){
						connection10.close();
					}

				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection10 !=null){
						connection10.close();
					}
				}
			}

			if(inComingRequest.equals("bulkRelinitiate")) {
				Connection connection2 = null;
				//			System.out.println("bulk release initiate");
				try {
					connection2 = DataBaseConnectionForNewDB.getConnectionForSyBase();

					String Remarks = request.getParameter("Remarks");
					String date = request.getParameter("date");
					String JsonData = request.getParameter("JsonData").trim();
					JSONArray jarr=new JSONArray(JsonData); 
					
					for(int i=0;i<jarr.length();i++) {
						JSONObject jobj=jarr.getJSONObject(i);
						String LoanAppNo = jobj.getString("loanAccno");
						String userId = (String) session.getAttribute("EMPLOYEECODE");
						String emplcode = jobj.getString("memempcode");
						String ipaddress=request.getRemoteHost();

						String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

						CallableStatement cStatement = connection2.prepareCall(sqlQuery);

						cStatement.setString(1, "RELINIT");
						cStatement.setString(2,LoanAppNo);
						cStatement.setString(3,userId);
						cStatement.setString(4,emplcode);
						cStatement.setString(5,"RELINITE");
						cStatement.setString(6, date);
						cStatement.setString(7,Remarks);
						cStatement.setString(8,ipaddress);
						cStatement.setString(9,"");
						cStatement.setString(10,"");
						cStatement.executeUpdate();
					}
						jsonObject = new JSONObject();
						jsonObject.put("success", "Y");
						response.getWriter().write(jsonObject.toString());
					
					if(connection2 !=null){
						connection2.close();
					}
				}
				catch(Exception e) {
					System.out.println("  EXCEPTION     "+e);
					e.printStackTrace();
					if(connection2 !=null){
						connection2.close();
					}
				}
			}

			if(inComingRequest.equals("bulkApprovalReleased")){

				Connection connection11 =null;
				//System.out.println("bulk approval release");

				try{
					connection11=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String chequeNumber = request.getParameter("chequeNumber");
					String date = request.getParameter("date");
					String gridData=request.getParameter("gridData").trim();
					JSONArray jarr=new JSONArray(gridData);
					for(int i=0;i<jarr.length();i++) {
						JSONObject jobj=jarr.getJSONObject(i);
					String LoanAppNo = jobj.getString("loanAccno");
					
					String bankaccno = jobj.getString("bankaccno");
					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String emplcode = jobj.getString("memempcode");
					System.out.println(LoanAppNo+" -- "+emplcode);
					String ipaddress=request.getRemoteHost();

					String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

					CallableStatement cStatement = connection11.prepareCall(sqlQuery);

					cStatement.setString(1, "RELEASE");
					cStatement.setString(2,LoanAppNo);
					cStatement.setString(3,userId);
					cStatement.setString(4, emplcode);
					cStatement.setString(5, "RELEASED");
					cStatement.setString(6, date);
					cStatement.setString(7,chequeNumber.contains("-")?chequeNumber.split("-")[0]:chequeNumber);
					cStatement.setString(8,ipaddress);
					cStatement.setString(9,bankaccno);
					cStatement.setString(10,chequeNumber.contains("-")?chequeNumber.split("-")[1]:chequeNumber);
					int count =	cStatement.executeUpdate();
					System.out.println(" i "+i +" count " +count);
					}
					jsonObject = new JSONObject();
					jsonObject.put("success", "Y");
					response.getWriter().write(jsonObject.toString());
					if(connection11 !=null){
						connection11.close();
					}
					
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection11 !=null){
						connection11.close();
					}
				}
			}

			if(inComingRequest.equals("released")){
			//	System.out.println("request "+inComingRequest);

				Connection connection11 =null;
				try{
					connection11=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String LoanAppNo = request.getParameter("LoanAppNo");
					String recFromDate = request.getParameter("recFromDate");
					recFromDate = recFromDate.split("/")[1]+"/"+recFromDate.split("/")[0]+"/"+recFromDate.split("/")[2];
					String Remarks = request.getParameter("Remarks");
					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String emplcode = request.getParameter("emplcode");					
					String bankaccno = request.getParameter("bankaccno");
					String ipaddress=request.getRemoteHost();

					String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

					CallableStatement cStatement = connection11.prepareCall(sqlQuery);

					cStatement.setString(1, "RELEASE");
					cStatement.setString(2,LoanAppNo);
					cStatement.setString(3,userId);
					cStatement.setString(4, emplcode);
					cStatement.setString(5, "RELEASED");
					cStatement.setString(6, recFromDate);
					cStatement.setString(7,Remarks);
					cStatement.setString(8,ipaddress);
					cStatement.setString(9,bankaccno);
					cStatement.setString(10,Remarks);
					int i=cStatement.executeUpdate();
					System.out.println(recFromDate+"  "+i);
					jsonObject = new JSONObject();
					jsonObject.put("success", "Y");
					response.getWriter().write(jsonObject.toString());
					if(connection11 !=null){
						connection11.close();
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection11 !=null){
						connection11.close();
					}
				}
			}


			if(inComingRequest.equals("reject")){

				Connection connection12 =null;
				try{
					connection12=DataBaseConnectionForNewDB.getConnectionForSyBase();
					String option = request.getParameter("option");

					String LoanAppNo = request.getParameter("LoanAppNo");
					String Remarks = request.getParameter("Remarks");
					String userId = (String) session.getAttribute("EMPLOYEECODE");
					String emplcode=request.getParameter("emplcode");
					String memAccNo = request.getParameter("memAccNo");

					String ipaddress=request.getRemoteHost();

					String sqlQuery ="exec speccs.SP_LoanDetails ?,?,?,?,?,?,?,?,?,?";

					CallableStatement cStatement = connection12.prepareCall(sqlQuery);
					cStatement.setString(1, option);
					cStatement.setString(2,LoanAppNo);
					cStatement.setString(3,userId);
					cStatement.setString(4,emplcode);
					cStatement.setString(5, "REJECT");
					cStatement.setString(6,"");
					cStatement.setString(7, Remarks);
					cStatement.setString(8, ipaddress);
					cStatement.setString(9,"");
					cStatement.setString(10,memAccNo);
					cStatement.executeUpdate();
					jsonObject = new JSONObject();
					jsonObject.put("REJECT", "Y");
					response.getWriter().write(jsonObject.toString());
					if(connection12 !=null){
						connection12.close();
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection12 !=null){
						connection12.close();
					}
				}
			}
			// thrift amount start added by pn on 07/04/2025
			if("thriftAmount".equalsIgnoreCase(inComingRequest)){
				String memAccNo = request.getParameter("memAccNo");
				String loanAppDate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("loanAppDate").trim()));
				String loanType = request.getParameter("loanType");
				Connection connection5 =null;
				jsonObject = new JSONObject();
				try{
					connection5 =DataBaseConnectionForNewDB.getConnectionForSyBase();
					//Statement statement = connection5.createStatement();
					if(loanType.equals("LTL")) {
					String sqlQuery = "SELECT sum(Amount) AS amnt FROM speccs.ThriftTransactions WHERE MemAccNo='"+memAccNo+"' and TransactionDate BETWEEN '"+loanAppDate+"' AND getdate() ";
					String sqlQuery1="SELECT TOP 1 ClosingBal FROM speccs.LoanTransactions WHERE LoanAccNo=(SELECT LoanAccNo FROM speccs.Loans WHERE MemAccNo='"+memAccNo+"' AND LoanType='LTL' AND LoanStatus='RELEASED')" + 
							" AND TransactionDate<='"+loanAppDate+"' AND P_I='P' ORDER BY TransactionDate DESC";
					CallableStatement cs1 = connection5.prepareCall(sqlQuery);
					ResultSet rs = cs1.executeQuery();
					int thrftAmnt = 0;
					if(rs.next()){						
						thrftAmnt=rs.getInt("amnt");
					}
					if(thrftAmnt>0) {
					
					jsonObject.put("thrftamnt", thrftAmnt);
					jsonObject.put("SUCCESS", "Y");
					}
					cs1 = connection5.prepareCall(sqlQuery1);
					rs = cs1.executeQuery();
					int prvAmnt = 0;
					if(rs.next()){						
						prvAmnt=rs.getInt("ClosingBal");
					}
					if(thrftAmnt>0) {
						jsonObject.put("prvamnt", prvAmnt);
					}
					else {
						jsonObject.put("SUCCESS", "N");
					}
					}
					else {
						jsonObject.put("SUCCESS", "N");
					}
					response.getWriter().write(jsonObject.toString());
					if(connection5 !=null){
						connection5.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection5 !=null){
						connection5.close();	
					}
				}
			}
			// end
			if (inComingRequest.equals("MemGenpdfformLoanDetails")) {
				String LoanAppNo = request.getParameter("LoanAppNo");
				String accNo = request.getParameter("accNo");

				ServletContext ctx=getServletContext();
				String header=ctx.getInitParameter("HEADER");
				String number=ctx.getInitParameter("NUMBERS");


				LoanDetailspdf.getPDF(accNo,LoanAppNo,header,number);
				String fileName = "LoanDetailspdf.pdf";
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
			
			
			if (inComingRequest.equals("MemGenpdfformSanctionRelease")) {
				

				
				SanctionReleasedPDF.getPDF(request, response);
				String fileName = "SanctionReleasedPDF.pdf";
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
			
			if(inComingRequest.equals("surityElg")){
				
				try{
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String memAccNo = request.getParameter("memaccno");
				jsonObject = new JSONObject();
				String sqlQuery = "{CALL speccs.SP_Surety(?,?,?,?,?,?,?,?,?,?)}";
				CallableStatement cs1 = connection.prepareCall(sqlQuery);

				cs1.setString(1, "MEMELGTOBSURETY");
				cs1.setString(2, memAccNo);
				cs1.setString(3, null);
				cs1.setInt(4, 0);
				cs1.setString(5, null);
				cs1.setString(6, null);
				cs1.setString(7, null);
				cs1.setString(8, null);
				cs1.setString(9, null);
				cs1.setString(10, null);
				ResultSet rs = cs1.executeQuery();
				if(rs!=null && rs.next()){	
					jsonObject.put("success", "y");
					jsonObject.put("elgCount", rs.getString("sureties"));
					jsonObject.put("NOOFSURETY", (rs.getString("NOOFSURETY")==null)?0:rs.getString("NOOFSURETY"));
				}
				else{
					jsonObject.put("success", "n");
					jsonObject.put("msg", "Not eligible to give surety");
				}
				response.getWriter().write(jsonObject.toString());
				if(connection !=null){
					connection.close();
				}
			}catch(Exception e2){
				System.out.println("  EXCEPTION     "+e2);
				e2.printStackTrace();
				if(connection !=null){
					connection.close();
				}
			}
			}
			// FDL Loan account start added by pn on 20/05/2025
			if("FDLLoan".equalsIgnoreCase(inComingRequest)){
				String memAccNo = request.getParameter("memAccNo");
				Connection connection5 =null;
				jsonObject = new JSONObject();
				try{
					connection5 =DataBaseConnectionForNewDB.getConnectionForSyBase();
					//Statement statement = connection5.createStatement();

					String sqlQuery = "SELECT LoanAccNo,LoanSanctionAmount FROM speccs.Loans WHERE MemAccNo='"+memAccNo+"' AND LoanType='FDL' AND LoanStatus='RELEASED'";
					CallableStatement cs1 = connection5.prepareCall(sqlQuery);
					ResultSet rs = cs1.executeQuery();
					Map<String,String> depositDetails  = null;
					LinkedList<Map<String, String>> depositDetailsList = new LinkedList<>();
					while(rs.next()){

						depositDetails = new HashMap<>();
						depositDetails.put("LoanAccNo", rs.getString("LoanAccNo"));
						depositDetails.put("AmountNo", rs.getString("LoanAccNo")+"~"+String.valueOf(rs.getDouble("LoanSanctionAmount")));
						depositDetailsList.add(depositDetails);
					}
					
					if(depositDetailsList.size()>0) {
					
						jsonObject = new JSONObject();
						jsonObject.put("DEPOSITSDETAILS", depositDetailsList);
						jsonObject.put("SUCCESS", "Y");
					}
					else {
						jsonObject.put("SUCCESS", "N");
					}

					response.getWriter().write(jsonObject.toString());
					if(connection5 !=null){
						connection5.close();	
					}
				}catch(Exception e2){
					System.out.println("  EXCEPTION     "+e2);
					e2.printStackTrace();
					if(connection5 !=null){
						connection5.close();	
					}
				}
			}
			// end
		}
		catch (SQLException e) {
			// TODO: handle exception
			jsonObject = new JSONObject();
			try {
				String message = e.getMessage();

				boolean contains = message.contains(":");
				String errorMsg = "SOME TECHNICAL ERROR";
				if(contains){
					errorMsg = message.substring(0,message.indexOf(":"));

				}
				jsonObject.put("ERROR",errorMsg);
				e.printStackTrace();
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			try {
				jsonObject.put("ERROR", e.getMessage());
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}


	}

}
