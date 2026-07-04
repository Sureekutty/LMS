package org.society.dao;

import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.society.util.DataBaseConnectionForNewDB;

import com.google.gson.JsonObject;
import com.sun.javafx.scene.control.skin.FXVK.Type;

public class GenericsDetailsDAO {


	private Statement  statement = null;
	CallableStatement prepareCall=null;

	public LinkedList<String> getEmployeeCodeList(String employeecodeType,String regStatus) throws Exception {

		LinkedList<String> employeeCodeList = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection	connection1 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection1.createStatement();
			//System.out.println("type "+employeecodeType);
			if(employeecodeType.equalsIgnoreCase("SANCTION")){
				sqlQuery = "EXEC SP_LoanRecovery '"+employeecodeType+"','','','',0,0,'','','',0,'','',0,0,'','','','',0,''";

			}else{


				sqlQuery = "EXEC speccs.SP_EMPLOYEECODELIST '"+employeecodeType+"','"+regStatus+"'";

			}

			ResultSet rsEmployeeCodeList = statement.executeQuery(sqlQuery);



			while(rsEmployeeCodeList.next()){
				if(employeecodeType.equalsIgnoreCase("ALL")){
					String memAccountNumber = rsEmployeeCodeList.getString("MemAccNo");

					if (memAccountNumber == null)
						memAccountNumber = "New";
					employeeCodeList.add(rsEmployeeCodeList.getString("MEMEMPCODE")+"-"+rsEmployeeCodeList.getString("MEMNAME")+"-"+memAccountNumber);
				}


				if(employeecodeType.equalsIgnoreCase("SOCIETYMEM")){
					employeeCodeList.add(rsEmployeeCodeList.getString("MEMACCNO") +"-"+ rsEmployeeCodeList.getString("MEMEMPCODE")+"-"+rsEmployeeCodeList.getString("MEMNAME"));
				}
				if(employeecodeType.equalsIgnoreCase("SANCTION")){
					employeeCodeList.add(rsEmployeeCodeList.getString("LoanAccNo")+"-"+rsEmployeeCodeList.getString("MemEmpCode") +"-"+ rsEmployeeCodeList.getString("MemName")+"-"+rsEmployeeCodeList.getString("MemAccNo"));
				}

			}
			rsEmployeeCodeList.close();
			connection1.close();
		} catch (Exception e) {
			throw e;
		}

		return employeeCodeList;
	}
	//------------------------------------------------------------------------------------------------//
	public LinkedList<String> getEmployeeCodeListsurety(String employeecodeType,String regStatus,String memaccno,String loanno) throws Exception {

		LinkedList<String> employeeCodeList = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection	connection1 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection1.createStatement();

			sqlQuery = "EXEC speccs.SP_FetchSurety '"+employeecodeType+"','"+memaccno+"','"+loanno+"'";
			System.out.println(sqlQuery);

			ResultSet rsEmployeeCodeList = statement.executeQuery(sqlQuery);

			while(rsEmployeeCodeList.next()){
				if(employeecodeType.equalsIgnoreCase("SURETYACTIVE")){
					employeeCodeList.add(rsEmployeeCodeList.getString("MemAccNo") +"-"+ rsEmployeeCodeList.getString("MemEmpCode")+"-"+rsEmployeeCodeList.getString("MemName")+"-"+rsEmployeeCodeList.getInt("ThriftBalance"));
				}
			}
			rsEmployeeCodeList.close();
			connection1.close();
		} catch (Exception e) {
			throw e;
		}

		return employeeCodeList;
	}
	//--------------------------------------------------------------------------------------------//
	public LinkedList<String> getEmployeeCodesurityList(String employeecodeType,String memaccno) throws Exception {

		LinkedList<String> employeeCodesurityList = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection	connection2 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection2.createStatement();

			sqlQuery = "EXEC speccs.SP_EMPLOYEECODELIST '"+employeecodeType+"','"+memaccno+"'";


			ResultSet rsEmployeeCodesurityList = statement.executeQuery(sqlQuery);

			while(rsEmployeeCodesurityList.next()){

				employeeCodesurityList.add(rsEmployeeCodesurityList.getString("MEMACCNO") +"-"+ rsEmployeeCodesurityList.getString("MEMEMPCODE")+"-"+rsEmployeeCodesurityList.getString("MEMNAME"));
			}
			rsEmployeeCodesurityList.close();
			connection2.close();
		} catch (Exception e) {
			throw e;
		}

		return employeeCodesurityList;
	}
	//--------------------------------------------------------------------------------------------------------\\
	public LinkedList<String> getpayvoucherslist(String option) throws Exception {

		LinkedList<String> payvoucherslist = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection	connection2 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection2.createStatement();

			sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','','',0,'','','','','','','','',''";
			ResultSet rsPayvoucherslist = statement.executeQuery(sqlQuery);

			while(rsPayvoucherslist.next()){

				payvoucherslist.add(rsPayvoucherslist.getString("PayVoucherNo"));
			}
			rsPayvoucherslist.close();
			connection2.close();
		} catch (Exception e) {
			throw e;
		}

		return payvoucherslist;
	}
	public LinkedList<String> getjvoucherslist(String option) throws Exception {

		LinkedList<String> jvoucherslist = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection	connection2 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection2.createStatement();

			sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','','',0,'','','','','','','','',''";
			ResultSet rsJayvoucherslist = statement.executeQuery(sqlQuery);

			while(rsJayvoucherslist.next()){

				jvoucherslist.add(rsJayvoucherslist.getString("JVoucherNo"));
			}
			rsJayvoucherslist.close();
			connection2.close();
		} catch (Exception e) {
			throw e;
		}

		return jvoucherslist;
	}
	public LinkedList<String> getjournalslist(String option) throws Exception {

		LinkedList<String> journalslist = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection	connection2 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection2.createStatement();

			sqlQuery = "speccs.SP_Paymentsbills '"+option+"','','','',0,'','','','','','','','',''";

			ResultSet rsJournallist = statement.executeQuery(sqlQuery);

			if(option.equals("JOURNALBILLS")){
				while(rsJournallist.next()){

					journalslist.add(rsJournallist.getString("DestinationRef"));
				}
			}
			while(rsJournallist.next()){

				journalslist.add(rsJournallist.getString("BillNo"));
			}

			rsJournallist.close();
			connection2.close();
		} catch (Exception e) {
			throw e;
		}

		return journalslist;
	}

	//-----------------------------------------------------------------------------------\\
	public LinkedList<String> getEmployeeCodesurityListload(String employeecodeType) throws Exception {

		LinkedList<String> employeeCodesurityList = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection connection3 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection3.createStatement();

			sqlQuery = "EXEC speccs.SP_EMPLOYEECODELIST '"+employeecodeType+"',''";


			ResultSet rsEmployeeCodesurityList = statement.executeQuery(sqlQuery);

			while(rsEmployeeCodesurityList.next()){

				employeeCodesurityList.add(rsEmployeeCodesurityList.getString("MEMACCNO") +"-"+ rsEmployeeCodesurityList.getString("MEMEMPCODE")+"-"+rsEmployeeCodesurityList.getString("MEMNAME"));
			}
			rsEmployeeCodesurityList.close();
			connection3.close();
		} catch (Exception e) {
			throw e;
		}

		return employeeCodesurityList;
	}
	public LinkedList<String> getAllEmployeeCodeList(String optionType) throws Exception {

		LinkedList<String> employeeCodeList = new LinkedList<String>();
		String sqlQuery = "";
		try {
			Connection	connection4 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection4.createStatement();
//			System.out.println("option type is "+optionType);
			sqlQuery = "EXEC speccs.SP_EMPLOYEECODELIST '"+optionType+"',''";
			ResultSet rsEmployeeCodeList = statement.executeQuery(sqlQuery);
			while(rsEmployeeCodeList.next()){


				employeeCodeList.add(rsEmployeeCodeList.getString("empcode"));


			}
			rsEmployeeCodeList.close();
			connection4.close();
		} catch (Exception e) {
			throw e;
		}

		return employeeCodeList;
	}

	public LinkedList<String> getPurposeCodeList(String option) throws Exception {

		LinkedList<String> employeeCodeList = new LinkedList<String>();
		String sqlQuery = "";

		Connection connection5 =null ;
		try {
			connection5=DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection5.createStatement();

			sqlQuery = "speccs.SP_MonthlyProcess '"+option+"','','','',0,'','',''";

			ResultSet rsEmployeeCodeList = statement.executeQuery(sqlQuery);
			String salCode = "";
			while(rsEmployeeCodeList.next()){
				salCode = rsEmployeeCodeList.getString("SalaryCode");
				if( salCode == null) {
					salCode="";
				}
				employeeCodeList.add(rsEmployeeCodeList.getString("PayCode").trim()+"-"+rsEmployeeCodeList.getString("Description").trim()+"-"+salCode);	
				//			+"~"+rsEmployeeCodeList.getString("SalaryCode") I have to add in purpose code
			}
//			for(String s:employeeCodeList) {
//				System.out.println("purpose is  "+s);
//			}
//			JsonObject json = new JsonObject();
//			json.put(salCode,"salaryCode");
			rsEmployeeCodeList.close();
			if(connection5!=null){
				connection5.close();
			}
		} catch (Exception e) {
			throw e;
		}

		return employeeCodeList;
	}


	public  LinkedList<Map<String,String>> getPaymentAndRecieprs(String recordType) throws Exception {
		Map<String,String> paymentReciept = null;
		LinkedList<Map<String,String>> paymentRecieptList=null;
		try {
			Connection	connection6 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection6.createStatement();

			String query="{CALL speccs.SP_PaymentAndReceipts(?)}";


			CallableStatement cs1 = connection6.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, recordType);
			paymentRecieptList = new LinkedList<>();
			ResultSet payment = cs1.executeQuery();
			while(payment.next()){
				paymentReciept = new HashMap<String, String>();
				paymentReciept.put("PAYMENTCODE", payment.getString("PayCode"));
				paymentReciept.put("DESCRIPTION", payment.getString("Description"));
				paymentRecieptList.add(paymentReciept);
			}
			connection6.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}


		return paymentRecieptList;
	}

	public  LinkedList<Map> getSocietyRulesList(String UserId, String fetch ) throws Exception {
		LinkedList<Map> societyRulesList =  new LinkedList<Map>();
		try {

			Connection connection7 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection7.createStatement();	


			String query ="{CALL speccs.SP_Rules (?,?,?,?,?)}";
			CallableStatement cs1 = connection7.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, fetch);
			cs1.setString(2, UserId);
			cs1.setString(3,"");
			cs1.setString(4, "");
			cs1.setInt(5,0);

			ResultSet rs2 = cs1.executeQuery();
			Map map=null;


			while(rs2.next()){
				map=new HashMap();
				map.put("RuleDescription", rs2.getString("RuleDescription"));
				map.put("RuleCode", rs2.getString("RuleCode"));
				societyRulesList.add(map);
			}
			connection7.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return societyRulesList;
	}

	public  String getSocietyRuleValue(String ruleCode, String value) throws Exception {
		String RuleValue="";
		try {
			Connection connection8 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection8.createStatement();	

			String query ="{CALL speccs.SP_Rules(?,?,?,?,?)}";

			CallableStatement cs1 = connection8.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, value);
			cs1.setString(2,"");
			cs1.setString(3,ruleCode);
			cs1.setString(4, "");
			cs1.setInt(5, 0);
			ResultSet rs2 = cs1.executeQuery();

			while(rs2.next()){
				RuleValue = rs2.getString("RuleValue");


			}
			connection8.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return RuleValue;
	}
	public  int getSocietyRuleValuesurety(String ruleCode, String value) throws Exception {
		int RuleValue=0;
		try {
			Connection connection8 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection8.createStatement();	

			String query ="{CALL speccs.SP_Rules(?,?,?,?,?)}";

			CallableStatement cs1 = connection8.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, value);
			cs1.setString(2,"");
			cs1.setString(3,ruleCode);
			cs1.setString(4, "");
			cs1.setInt(5, 0);
			ResultSet rs2 = cs1.executeQuery();

			while(rs2.next()){
				RuleValue = rs2.getInt("RuleValue");


			}
			connection8.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return RuleValue;
	}
	public int getSocietyUpdateValue(String RuleCode, String update, int value,String userID,String ipaddress) throws Exception {


		int updated=0;
		Connection	 connection9 = DataBaseConnectionForNewDB.getConnectionForSyBase();
		statement = connection9.createStatement();	
		try {

			String query ="{CALL speccs.SP_Rules(?,?,?,?,?)}";
			CallableStatement cs1 = connection9.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

			cs1.setString(1, update);
			cs1.setString(2,userID);
			cs1.setString(3,RuleCode);
			cs1.setString(4, ipaddress);
			cs1.setInt(5, value);


			updated=cs1.executeUpdate();
			connection9.close();
		} catch (Exception e) {
			throw e;
		}

		return updated;

	}	
	public  Map<String,String> getRuleDetails(String ruleCode) throws Exception {
		Map<String,String> ruleDetails  = null;
		try {



			Connection connection10 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection10.createStatement();	

			String query ="{CALL speccs.SP_Rules (?,?,?,?,?)}";

			CallableStatement cs1 = connection10.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, "all");
			cs1.setString(2, "");
			cs1.setString(3,ruleCode);
			cs1.setString(4,"");
			cs1.setInt(5, 0);

			ruleDetails = new HashMap<>();
			ResultSet rs2 = cs1.executeQuery();
			while(rs2.next()){

				ruleDetails.put("RuleCode", rs2.getString("RuleCode"));
				ruleDetails.put("RuleDescription", rs2.getString("RuleDescription"));
				ruleDetails.put("RuleValue", rs2.getString("RuleValue"));
			}
			connection10.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return ruleDetails;
	}


	public float getInterestRates(String intCode,String duration,String date) throws Exception {
		float interestRate = 0.0f;
		try {

			Connection	connection11 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection11.createStatement();

			String query ="{CALL speccs.Sp_getInterestRates (?,?,?,?,?)}";
			CallableStatement cs1 = connection11.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, "Value");
			cs1.setString(2, intCode);
			if (duration == null || duration.length() == 0)
				duration = "0";

			cs1.setInt(3, Integer.parseInt(duration));
			cs1.registerOutParameter(4, Types.NUMERIC);
			cs1.setString(5, date);

			int rs2 = cs1.executeUpdate();

			interestRate = cs1.getFloat(4);


			connection11.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return interestRate;
	}

	public float getInterestRatesloans(String opendate,String loantype,String memcode) throws Exception {
		float interestRateloan = 0.0f;
		try {

			Connection	connection13 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection13.createStatement();
			opendate = new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(opendate));
			String query ="{CALL speccs.Sp_getInterestRates (?,?,?,?,?)}";
//			System.out.println("opendate "+opendate+" loan type "+loantype+" duration "+memcode );
			CallableStatement cs1 = connection13.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, opendate);
			cs1.setString(2, loantype);
			String duration = "0";
			cs1.setInt(3, Integer.parseInt(duration));
			cs1.registerOutParameter(4, Types.NUMERIC);
			cs1.setString(5, opendate);
			int rs2 = cs1.executeUpdate();

			interestRateloan = cs1.getFloat(4);
//			System.out.println("int rate "+interestRateloan);

			connection13.close();
		} catch (Exception e) {

			throw e;
		}

		return interestRateloan;
	}



	public LinkedList<Map<String,String>> getDeposits(String depositMode) throws Exception{

		Map<String,String> depositTypes  = null;
		LinkedList<Map<String, String>> depositList = null;
		try {
			Connection	connection12 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection12.createStatement();	
			String sqlQuery ="{CALL speccs.SP_DepositsLoad(?)}";
			CallableStatement cs1 = connection12.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, depositMode);
			ResultSet rsDeposits = cs1.executeQuery();
			depositList = new LinkedList<>();
			while (rsDeposits.next()) {
				depositTypes = new HashMap<>();
				depositTypes.put("DepositTypeCode", rsDeposits.getString("DepositTypeCode"));
				depositTypes.put("DepositTypeDescription", rsDeposits.getString("DepositTypeDescription"));
				depositList.add(depositTypes);
			}
			connection12.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return depositList;

	}
	public LinkedList<Map<String,String>> getLoannumbers(String memacc) throws Exception{

		Map<String,String> loannumbers  = null;
		LinkedList<Map<String, String>> loannumbersList = null;
		try {
			Connection	connection12 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection12.createStatement();	
			String sqlQuery ="{CALL speccs.SP_DepositsView(?,?,?,?,?,?)}";
			CallableStatement cs1 = connection12.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, "LOANPROCESSINFO");
			cs1.setString(2, memacc);
			cs1.setString(3, "");
			cs1.setString(4, "");
			cs1.setString(5, "");
			cs1.setString(6, "");


			ResultSet rsDeposits = cs1.executeQuery();
			loannumbersList = new LinkedList<>();
			while (rsDeposits.next()) {

				loannumbers = new HashMap<>();
				loannumbers.put("LoanNumbers", rsDeposits.getString("LoanAccNo"));
				loannumbersList.add(loannumbers);
			}
			connection12.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return loannumbersList;

	}
	public LinkedList<Map<String,String>> getDepositstatus(String depositMode) throws Exception{

		Map<String,String> depositstatus  = null;
		LinkedList<Map<String, String>> depositstatusList = null;
		try {
			Connection	connection17 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection17.createStatement();	
			String sqlQuery ="{CALL speccs.SP_DepositsLoad(?)}";
			CallableStatement cs1 = connection17.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, depositMode);
			ResultSet rsDeposits = cs1.executeQuery();
			depositstatusList = new LinkedList<>();
			while (rsDeposits.next()) {
				depositstatus = new HashMap<>();
				depositstatus.put("DepositStatus", rsDeposits.getString("STATUS"));
				depositstatusList.add(depositstatus);
			}
			connection17.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return depositstatusList;

	}
	public LinkedList<Map<String,String>> getDepositDetails
	(String option,String depositType,String status,String depositNumber,String memAccNo) throws Exception{

		Map<String,String> depositDetails  = null;
		LinkedList<Map<String, String>> depositDetailsList = null;
		try {
			Connection	connection13 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection13.createStatement();	
			String sqlQuery ="{CALL speccs.SP_DepositsDetails(?,?,?,?,?)}";
			CallableStatement cs1 = connection13.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			//System.out.println(option+"--"+depositType+"--"+status+"--"+depositNumber+"--"+memAccNo);

			cs1.setString(1, option);
			cs1.setString(2, depositType);
			cs1.setString(3, status);
			cs1.setString(4, depositNumber);
			cs1.setString(5, memAccNo);
			ResultSet rsDeposits = cs1.executeQuery();
			depositDetailsList = new LinkedList<>();
			while (rsDeposits.next()) {
				depositDetails = new HashMap<>();
				depositDetails.put("MemAccNo", rsDeposits.getString("MemAccNo"));
				depositDetails.put("DepositNo", rsDeposits.getString("DepositNo"));
				depositDetails.put("MemEmpCode", rsDeposits.getString("MemEmpCode"));
				depositDetails.put("Designation", rsDeposits.getString("Designation"));
				depositDetails.put("MemName", rsDeposits.getString("MemName"));
				if(!option.equalsIgnoreCase("depositnumbers")){
					depositDetails.put("DepositType", rsDeposits.getString("DepositType"));
					Date date = rsDeposits.getDate("OpenDate");
					SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
					String format = dateFormat.format(date);
					depositDetails.put("OpenDate", format);
					date = rsDeposits.getDate("PreCloseDate");
					format = "-";
					if(date != null){
						format = dateFormat.format(date);
					}
					depositDetails.put("PreCloseDate", format);

					depositDetails.put("IntRate", rsDeposits.getString("IntRate"));
					depositDetails.put("Subscription", rsDeposits.getString("Subscription"));
					depositDetails.put("PenalIntRate", rsDeposits.getString("PenalIntRate"));
					depositDetails.put("ClosingBl", rsDeposits.getString("ClosingBl"));
					depositDetails.put("MaturityAmount", rsDeposits.getString("MaturityAmount"));
					depositDetails.put("PreviousDepositNo", rsDeposits.getString("PreviousDepositNo"));
					depositDetails.put("Status", rsDeposits.getString("Status"));
					depositDetails.put("Remarks", rsDeposits.getString("Remarks"));
				}
				depositDetailsList.add(depositDetails);
			}
			connection13.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return depositDetailsList;

	}

	public LinkedList<Map<String,String>> getDepositAsstReq(String depositoption) throws Exception{

		Map<String,String> depositasstreq  = null;
		LinkedList<Map<String, String>> depositasstreqList = null;
		try {
			Connection	connection18 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			statement = connection18.createStatement();	
			String sqlQuery ="{CALL speccs.SP_DepositsLoad(?)}";
			CallableStatement cs1 = connection18.prepareCall(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			cs1.setString(1, depositoption);
			ResultSet rsDeposits = cs1.executeQuery();
			depositasstreqList = new LinkedList<>();
			while (rsDeposits.next()) {
				depositasstreq = new HashMap<>();
				depositasstreq.put("DepositAsstReq", rsDeposits.getString("ASSTREQ"));
				depositasstreqList.add(depositasstreq);
			}
			connection18.close();
		} catch (Exception e) {
			// TODO: handle exception
			throw e;
		}

		return depositasstreqList;

	}

	public LinkedList<Map<String, String>> getInterestDescription(String fetch) throws Exception{



		LinkedList<Map<String, String>> list= null;
		try {
			Connection connecti14 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			String Querry="{call speccs.SP_getInterestDescription(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
			prepareCall = connecti14.prepareCall(Querry);
			prepareCall.setString(1, fetch);
			prepareCall.setString(2, null);
			prepareCall.setString(3, null);
			prepareCall.setInt(4, 0);
			prepareCall.setInt(5, 0);
			prepareCall.setInt(6, 0);
			prepareCall.setString(7, null);
			prepareCall.setString(8, null);
			prepareCall.setInt(9, 0);
			prepareCall.setInt(10, 0);
			prepareCall.setString(11, null);
			prepareCall.setInt(12, 0);
			prepareCall.setString(13, null);



			ResultSet resultSet = prepareCall.executeQuery();

			list = new LinkedList<Map<String,String>>();

			while(resultSet.next()){

				Map<String, String> map =new HashMap<String, String>();

				map.put("IntDescription", resultSet.getString("IntDescription"));
				map.put("IntCode",resultSet.getString("IntCode"));
				map.put("SlNo",resultSet.getString("SlNo"));
				list.add(map);

			}
			connecti14.close();
		} catch (Exception e) {
			throw e;
		}

		return list;
	}


	public LinkedList<Map<String, String>> getInterestValues(String code,int serialNo) throws Exception{



		LinkedList<Map<String, String>> list= null;
		try {
			Connection connection15 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			String Querry="{call speccs.SP_getInterestDescription(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
			prepareCall = connection15.prepareCall(Querry);
			prepareCall.setString(1, "value");
			prepareCall.setString(2, null);
			prepareCall.setString(3, code);
			prepareCall.setInt(4, serialNo);
			prepareCall.setInt(5, 0);
			prepareCall.setInt(6, 0);
			prepareCall.setString(7, null);
			prepareCall.setString(8, null);
			prepareCall.setInt(9, 0);
			prepareCall.setInt(10, 0);
			prepareCall.setString(11, null);
			prepareCall.setInt(12, 0);
			prepareCall.setString(13, null);
			ResultSet resultSet = prepareCall.executeQuery();

			list = new LinkedList<Map<String,String>>();

			while(resultSet.next()){

				Map<String, String> map =new HashMap<String, String>();

				map.put("MinAmount", resultSet.getString("MinAmount"));
				map.put("MaxAmount", resultSet.getString("MaxAmount"));
				map.put("MinMonth", resultSet.getString("MinMonth"));
				map.put("MaxMonth", resultSet.getString("MaxMonth"));
				map.put("EffFromDate", resultSet.getString("EffFromDate"));
				map.put("InterestType", resultSet.getString("InterestType"));
				map.put("RateOfInterest", resultSet.getString("RateOfInterest"));
				map.put("InterstCalcTerm", resultSet.getString("InterstCalcTerm"));
				list.add(map);

			}
			connection15.close();
		} catch (Exception e) {
			throw e;
		}

		return list;
	}




	public LinkedList<Map<String, String>> getLoanProcessType(String fetch) throws Exception{

		LinkedList<Map<String, String>> list= null;
		try {
			Connection connection16 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			String Query="SELECT * FROM speccs.LoanProcessType";
			prepareCall = connection16.prepareCall(Query);

			ResultSet resultSet = prepareCall.executeQuery();
			list = new LinkedList<Map<String,String>>();

			while(resultSet.next()){

				Map<String, String> map =new HashMap<String, String>();

				map.put("IntDescription", resultSet.getString("IntDescription"));
				map.put("IntCode",resultSet.getString("IntCode"));
				map.put("Type",resultSet.getString("Type"));
				list.add(map);

			}
			connection16.close();
		} catch (Exception e) {
			throw e;
		}

		return list;

	}



	public int updateInterestDetails(String Option,double rateofinterest, 
			String intCode,int serialNo,double minAmount,double maxAmount,String userID,String ipaddress,String EffFromDate,String typeofinterest,String interestterm,int durFromMonth,int durToMonth) 
					throws Exception{

		int update=0;

		try {
			Connection connection17 = DataBaseConnectionForNewDB.getConnectionForSyBase();
			String Query="{call speccs.SP_getInterestDescription(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
			prepareCall = connection17.prepareCall(Query);
			prepareCall.setString(1, Option);
			prepareCall.setString(2, userID);
			prepareCall.setString(3, intCode);
			prepareCall.setInt(4, serialNo);
			prepareCall.setDouble(5, minAmount);
			prepareCall.setDouble(6, maxAmount);
			prepareCall.setString(7, typeofinterest);
			prepareCall.setString(8, interestterm);
			prepareCall.setInt(9, durFromMonth);
			prepareCall.setInt(10, durToMonth);
			prepareCall.setString(11,EffFromDate);
			prepareCall.setDouble(12, rateofinterest);
			prepareCall.setString(13, ipaddress);




			update = prepareCall.executeUpdate();	
			connection17.close();
		} catch (Exception e) {
			throw e;
		}

		return update;

	}
}







