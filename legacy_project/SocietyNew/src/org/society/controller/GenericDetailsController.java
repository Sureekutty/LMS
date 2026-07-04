package org.society.controller;

import static org.society.util.ReturnJsonObject.returnJsonObject;

import java.io.IOException;
import java.net.InetAddress;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.society.service.GenericDetailsService;
import org.society.util.ConvertListToJSONArray;
import org.society.util.DataBaseConnectionForNewDB;

import com.google.gson.JsonObject;
import com.sun.jmx.snmp.Timestamp;

@WebServlet("/genericsDetails")
public class GenericDetailsController extends HttpServlet{
	private static final long serialVersionUID = 1L;
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);

		JSONObject  object=null;
		// TODO Auto-generated method stub
		String incomingRequest = request.getParameter("req");
		GenericDetailsService genericDetailsService  = null;
		try {

			if("employeeList".equalsIgnoreCase(incomingRequest)){
				String type = request.getParameter("type");
				String regstatus  = request.getParameter("regstatus");

				genericDetailsService = new GenericDetailsService();
				LinkedList<String> employeeCodeList = genericDetailsService.getEmployeeCodeListByType(type,regstatus);
				Collection collection = employeeCodeList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "EMPLOYEELIST");
				returnJsonObject(jsonObject, response);
			}


			if("employeeListsurety".equalsIgnoreCase(incomingRequest)){
				String type = request.getParameter("type");
				String regstatus  = request.getParameter("regstatus");
				String MEMACCNO  = request.getParameter("MEMACCNO");
				String LOANACCNO  = request.getParameter("LOANACCNO");

				genericDetailsService = new GenericDetailsService();
				LinkedList<String> employeeCodeList = genericDetailsService.getEmployeeCodeListByTypesurety(type,regstatus,MEMACCNO,LOANACCNO);
				Collection collection = employeeCodeList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "EMPLOYEELIST");
				returnJsonObject(jsonObject, response);
			}


			if("payvouchersList".equalsIgnoreCase(incomingRequest)){
				String option = request.getParameter("option");

				genericDetailsService = new GenericDetailsService();
				LinkedList<String> payvouchersList = genericDetailsService.getpayvoucherslist(option);
				Collection collection = payvouchersList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "PAYVOUCHERSLIST");
				returnJsonObject(jsonObject, response);
			}
			if("jvouchersList".equalsIgnoreCase(incomingRequest)){
				String option = request.getParameter("option");

				genericDetailsService = new GenericDetailsService();
				LinkedList<String> jvouchersList = genericDetailsService.getjvoucherslist(option);
				Collection collection = jvouchersList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "JOURNALSENTRYSLIST");
				returnJsonObject(jsonObject, response);
			}
			if("gettingjournaldata".equalsIgnoreCase(incomingRequest)){
				String option = request.getParameter("option");

				genericDetailsService = new GenericDetailsService();
				LinkedList<String> journalsList = genericDetailsService.getbilljournalslist(option);
				Collection collection = journalsList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "JOURNALSLIST");
				returnJsonObject(jsonObject, response);
			}

			if("surityList".equalsIgnoreCase(incomingRequest)){
				String type = request.getParameter("type");
				String memaccno  = request.getParameter("memaccno");

				genericDetailsService = new GenericDetailsService();
				LinkedList<String> employeeCodesurityList = genericDetailsService.getEmployeeCodesurityList(type,memaccno);
				Collection collection = employeeCodesurityList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "SURITYEMPLOYEELIST");
				returnJsonObject(jsonObject, response);
			}
			if("surityListload".equalsIgnoreCase(incomingRequest)){
				String type = request.getParameter("type");


				genericDetailsService = new GenericDetailsService();
				LinkedList<String> employeeCodesurityList = genericDetailsService.getEmployeeCodesurityListload(type);
				Collection collection = employeeCodesurityList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "SURITYEMPLOYEELIST");
				returnJsonObject(jsonObject, response);
			}

			//-------------------getall memebers---------------------//
			if("getAllMembers".equalsIgnoreCase(incomingRequest)){ 

				String option = request.getParameter("option").trim();
				genericDetailsService = new GenericDetailsService();
				LinkedList<String> allemployeeCodeList = genericDetailsService.getAllEmployeeCodeList(option);
				Collection collection = allemployeeCodeList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "ALLEMPLOYEELIST");
				returnJsonObject(jsonObject, response);

			}
			if("getpurposecodes".equalsIgnoreCase(incomingRequest)){ 
				
				String option = request.getParameter("option").trim();
				genericDetailsService = new GenericDetailsService();
				LinkedList<String> allemployeeCodeList = genericDetailsService.getPurposeCodeList(option);
				Collection collection = allemployeeCodeList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "ALLPURPOSECODELIST");
				returnJsonObject(jsonObject, response);

			}

			//----------------------------end get all members----------------//

			if("receiptsAndPayments".equalsIgnoreCase(incomingRequest)){
				String recordType = request.getParameter("recordType");



				genericDetailsService = new GenericDetailsService();

				object=new JSONObject();
				object.put("payment", genericDetailsService.getPaymentAndRecieprs(recordType));
				returnJsonObject(object, response);
			}

			if("societyRules".equalsIgnoreCase(incomingRequest)){
				String userID =(String)session.getAttribute("EMPLOYEECODE"); 
				String fetch = request.getParameter("Option");


				genericDetailsService = new GenericDetailsService();
				LinkedList<Map> societyRulesList = genericDetailsService.getSocietyRulesList(userID,fetch);

				Collection collection = societyRulesList;
				JSONObject	jsonObject = ConvertListToJSONArray.convertCollection(collection, "RULESLIST");
				returnJsonObject(jsonObject, response);
			}
			if("societyRuleValue".equalsIgnoreCase(incomingRequest)){
				String RuleCode = request.getParameter("ruleCode");
				String Value = request.getParameter("Option");
				genericDetailsService = new GenericDetailsService();
				String societyRuleValue = genericDetailsService.getSocietyRuleValue(RuleCode,Value);

				JSONObject jsonObj =new JSONObject();
				jsonObj.put("RULEVALUE", societyRuleValue);

				response.getWriter().write(jsonObj.toString());
			}
			if("societyUpdateValue".equalsIgnoreCase(incomingRequest)){

				String RuleCode = request.getParameter("ruleCode");
				int value= Integer.parseInt(request.getParameter("value"));
				String update = request.getParameter("Option");
				String userID =(String)session.getAttribute("EMPLOYEECODE"); 
				String ipaddress=request.getRemoteHost();

				genericDetailsService = new GenericDetailsService();
				int updated = genericDetailsService.getSocietyUpdateValue(RuleCode,update,value,userID,ipaddress);
				JSONObject jsonObj  =new JSONObject();
				if(updated>0){
					jsonObj.put("success", "y");

				}
				else{
					jsonObj.put("success", "n");
				}
				response.getWriter().write(jsonObj.toString());
			}
			if("fetchtinginterest".equalsIgnoreCase(incomingRequest)){

				String fetch= request.getParameter("type");
				genericDetailsService = new GenericDetailsService();
				LinkedList<Map<String, String>> linkedList = genericDetailsService.getInterestDescription(fetch);

				JSONObject jsonObject= new JSONObject();
				jsonObject.put("interest", linkedList);
				returnJsonObject(jsonObject, response);
				// response.getWriter().write(jsonObject.toString());

			}


			if("interestvalues".equalsIgnoreCase(incomingRequest)){

				String code=request.getParameter("code").trim();
				int serialNo = Integer.parseInt( request.getParameter("serialNo").trim());
				//System.out.println("serial no "+serialNo);
				genericDetailsService = new GenericDetailsService();
				LinkedList<Map<String, String>> interestValues = genericDetailsService.getInterestValues(code, serialNo);
				object=new JSONObject();
				object.put("IntValues", interestValues);
				response.getWriter().write(object.toString());	
			}

			if("loanProcessType".equalsIgnoreCase(incomingRequest)){

				String fetch = request.getParameter("type");
				genericDetailsService = new GenericDetailsService();

				LinkedList<Map<String, String>> loanprocesslist = genericDetailsService.getLoanProcessType(fetch);

				JSONObject jsonObject= new JSONObject();
				jsonObject.put("loanprocess", loanprocesslist);
				returnJsonObject(jsonObject, response);


			}


			if("updateValues".equalsIgnoreCase(incomingRequest)){

				String Option = request.getParameter("Option");
				String intCode = request.getParameter("intCode");
				String EffFromDate = request.getParameter("effectedfromdate");
				String typeofinterest = request.getParameter("typeofinterest");
				String interestterm = request.getParameter("interestterm");





				int serialNo = Integer.parseInt( request.getParameter("serialNo"));
				String userID =(String)session.getAttribute("EMPLOYEECODE");

				String ipaddress=request.getRemoteHost();
				double rateofinterest=0.0;
				String rateofintst=request.getParameter("rateofinterest");
				if(rateofintst.isEmpty()||rateofintst==null||rateofintst=="")
				{
					rateofintst="0.0";
					rateofinterest=Double.parseDouble(rateofintst);
				}
				else {rateofinterest=Double.parseDouble(rateofintst);}





				String minAmt = request.getParameter("minAmount");
				double minAmount;

				if(minAmt.isEmpty()||minAmt==null||minAmt=="")
				{
					minAmt="0.0";
					minAmount=Double.parseDouble(minAmt);
				}else{
					minAmount=Double.parseDouble(minAmt);
				}



				String maxAmt = request.getParameter("maxAmount");
				double maxAmount ; 
				if(maxAmt.isEmpty()||maxAmt==null||maxAmt=="")
				{
					maxAmt="0.0";
					maxAmount=Double.parseDouble(maxAmt);
				}else{
					maxAmount=Double.parseDouble(maxAmt);
				}


				String durationFromMonth = request.getParameter("durationfrommonth");
				int durFromMonth =0; 
				if(durationFromMonth.isEmpty()||durationFromMonth==null||durationFromMonth=="")
				{
					durationFromMonth="0";
					durFromMonth=Integer.parseInt(durationFromMonth);
				}else{
					durFromMonth=Integer.parseInt(durationFromMonth);
				}


				String durationToMonth = request.getParameter("durationToMonth");
				int durToMonth =0; 
				if(durationToMonth.isEmpty()||durationToMonth==null||durationToMonth=="")
				{
					durationToMonth="0";
					durToMonth=Integer.parseInt(durationToMonth);
				}else{
					durToMonth=Integer.parseInt(durationToMonth);
				}

				genericDetailsService = new GenericDetailsService();

				int updated = genericDetailsService.updateInterestDetails(Option,rateofinterest,intCode,serialNo,minAmount,maxAmount,userID,ipaddress,EffFromDate,typeofinterest,interestterm,durFromMonth,durToMonth);

				JSONObject jsonObject= new JSONObject();
				if(updated>0)
					jsonObject.put("success", "Y");
				returnJsonObject(jsonObject, response);	
			}




		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
