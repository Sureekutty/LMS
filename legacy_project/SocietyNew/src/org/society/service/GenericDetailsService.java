package org.society.service;

import java.util.LinkedList;
import java.util.Map;

import org.society.dao.GenericsDetailsDAO;

public class GenericDetailsService {
	GenericsDetailsDAO genericsDetailsDAO = null;
	public LinkedList<String> getEmployeeCodeListByType(String type,String regstatus) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> employeeCodeList = genericsDetailsDAO.getEmployeeCodeList(type,regstatus);
		return employeeCodeList;
	}
	
	public LinkedList<String> getEmployeeCodeListByTypesurety(String type,String regstatus,String memeaccno,String loanaccno) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> employeeCodeList = genericsDetailsDAO.getEmployeeCodeListsurety(type,regstatus,memeaccno,loanaccno);
		return employeeCodeList;
	}
	
	public LinkedList<String> getpayvoucherslist(String option) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> payvoucherslist = genericsDetailsDAO.getpayvoucherslist(option);
		return payvoucherslist;
	}
	public LinkedList<String> getjvoucherslist(String option) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> jvoucherslist = genericsDetailsDAO.getjvoucherslist(option);
		return jvoucherslist;
	}
	
	public LinkedList<String> getbilljournalslist(String option) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> journalslist = genericsDetailsDAO.getjournalslist(option);
		return journalslist;
	}
	
	
	public LinkedList<String> getEmployeeCodesurityList(String type,String memaccno) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> employeeCodesurityList = genericsDetailsDAO.getEmployeeCodesurityList(type,memaccno);
		return employeeCodesurityList;
	}
	public LinkedList<String> getEmployeeCodesurityListload(String type) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> employeeCodesurityList = genericsDetailsDAO.getEmployeeCodesurityListload(type);
		return employeeCodesurityList;
	}
	
	public LinkedList<String> getAllEmployeeCodeList(String option) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> employeeCodeList = genericsDetailsDAO.getAllEmployeeCodeList(option);
		return employeeCodeList;
	}
	
	public LinkedList<String> getPurposeCodeList(String option) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<String> employeeCodeList = genericsDetailsDAO.getPurposeCodeList(option);
//		System.out.println(option);
		return employeeCodeList;
	}
	public LinkedList<Map<String,String>> getPaymentAndRecieprs(String recordType) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<Map<String,String>> paymentAndRecieprs = genericsDetailsDAO.getPaymentAndRecieprs(recordType);
		return paymentAndRecieprs;
		
	}

	public LinkedList<Map> getSocietyRulesList(String UserId, String fetch) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		LinkedList<Map>  societyRulesList = genericsDetailsDAO.getSocietyRulesList(UserId,fetch);
		return societyRulesList;
		
	}

	public String getSocietyRuleValue(String RuleCode, String Value)throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		String societyRuleValue =genericsDetailsDAO.getSocietyRuleValue(RuleCode,Value);
		return societyRuleValue;
	}
	public int getSocietyRuleValuesurety(String RuleCode, String Value)throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		int societyRuleValue =genericsDetailsDAO.getSocietyRuleValuesurety(RuleCode,Value);
		return societyRuleValue;
	}
	public int getSocietyUpdateValue(String RuleCode, String update,int value,String userID,String ipaddress) throws Exception {
		genericsDetailsDAO = new GenericsDetailsDAO();
		int Updated =genericsDetailsDAO.getSocietyUpdateValue(RuleCode,update,value,userID,ipaddress);
		return Updated;
	}

	public Map<String, String> getRuleDetails(String ruleCode) throws Exception{
		
		genericsDetailsDAO = new GenericsDetailsDAO();
		Map<String, String> ruleDetails = genericsDetailsDAO.getRuleDetails(ruleCode);
		return ruleDetails;
	}
	
	public float getInterestRates(String intCode,String duration,String date) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		float interestRate = genericsDetailsDAO.getInterestRates(intCode,duration,date);
		return interestRate;
	}
	public float getInterestRatesloan(String opendate,String loantype,String memcode) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		float interestRateloan = genericsDetailsDAO.getInterestRatesloans(opendate,loantype,memcode);
//		System.out.println("int rate "+interestRateloan);
		return interestRateloan;
	}
	public LinkedList<Map<String,String>> getDeposits(String depositMode) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		return genericsDetailsDAO.getDeposits(depositMode);
	}
	public LinkedList<Map<String,String>> getLoanNumbers(String MemAccNO) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		return genericsDetailsDAO.getLoannumbers(MemAccNO);
	}
	public LinkedList<Map<String,String>> getDepositstatus(String depositMode) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		return genericsDetailsDAO.getDepositstatus(depositMode);
	}
	public LinkedList<Map<String,String>> getDepositDetails	(String option,String depositType,String status,String depositNumber,String memAccNo) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		return genericsDetailsDAO.getDepositDetails(option, depositType, status, depositNumber, memAccNo);
	}
	public LinkedList<Map<String,String>> getDepositAsstReq	(String option) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		return genericsDetailsDAO.getDepositAsstReq(option);
	}
	
	
	
	public LinkedList<Map<String, String>> getInterestDescription(String fetch) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		
		LinkedList<Map<String, String>> interestDescription = genericsDetailsDAO.getInterestDescription(fetch);
		return interestDescription;
	}
	
	public LinkedList<Map<String, String>> getInterestValues(String code,int serialNo) throws Exception{
		genericsDetailsDAO = new GenericsDetailsDAO();
		
		LinkedList<Map<String, String>> interestDescription = genericsDetailsDAO.getInterestValues(code,serialNo);
		return interestDescription;
	}
	
	public static void main(String[] args) throws Exception {
		GenericsDetailsDAO dao = new GenericsDetailsDAO();
		System.out.println(dao.getInterestRates("SRB", null,""));
	}
	
	

	public LinkedList<Map<String, String>> getLoanProcessType(String fetch) throws Exception{
		
		genericsDetailsDAO = new GenericsDetailsDAO();
		
		return genericsDetailsDAO.getLoanProcessType(fetch);
		
	}
	
	
	public int updateInterestDetails(String Option,double rateofinterest, String intCode,int serialNo,double minAmount,double maxAmount,String userID,String ipaddress,String EffFromDate,String typeofinterest,String interestterm,int durFromMonth,int durToMonth) throws Exception{
		
		genericsDetailsDAO = new GenericsDetailsDAO();
		
		return genericsDetailsDAO.updateInterestDetails(Option,rateofinterest, intCode,serialNo,minAmount,maxAmount,userID,ipaddress,EffFromDate,typeofinterest,interestterm,durFromMonth,durToMonth);
		
	}
	
}
