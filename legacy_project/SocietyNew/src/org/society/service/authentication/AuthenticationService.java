package org.society.service.authentication;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.society.dao.authentication.AuthenticationDAO;
import org.society.dao.eventlogger.EventLoggerDAO;
import org.society.exceptions.ThrowClassNotFoundException;
import org.society.exceptions.ThrowInstantiationException;
import org.society.model.RequestSourceModel;
import org.society.model.TBSCEventsModel;
import org.society.model.TBSCLogin;

public class AuthenticationService {
	
	TBSCEventsModel tbscEventsModel = null;
    EventLoggerDAO eventLoggerDAO= new EventLoggerDAO();
    AuthenticationDAO authenticationDAO=new AuthenticationDAO();
	
	public boolean isValidUSer(TBSCLogin tbsc_Login,RequestSourceModel requestSourceModel) throws ThrowInstantiationException, ThrowClassNotFoundException, IllegalAccessException, SQLException {
		
		//System.out.println("Authservice...1");
		
		tbscEventsModel=new TBSCEventsModel();
		tbscEventsModel.setSessionId(requestSourceModel.getSessionId());
		tbscEventsModel.setEventId("AUTH001");
		tbscEventsModel.setEventName("Validate User Login");
		tbscEventsModel.setEventDesc("User Validation Requested");
		tbscEventsModel.setEventGenBy(requestSourceModel.getRequestedUserId());
		tbscEventsModel.setEventIPAddress(requestSourceModel.getIPAddress());
		tbscEventsModel.setEventSrcModule("Authentication Module- Web");
		tbscEventsModel.setEventType("ACTION");

		Timestamp now=new Timestamp(Calendar.getInstance().getTimeInMillis());
		tbscEventsModel.setEventOccrdTime(now);
		eventLoggerDAO.logEvent(tbscEventsModel);
		
		//System.out.println("Authservice...2");
		boolean	 isValidUser =authenticationDAO.isValidUser(tbsc_Login);
//		System.out.println("isvalide use "+isValidUser);
		String returnMessage = isValidUser ==  true ? "VALID USER" : "INVALID USER" ;
		
		tbscEventsModel.setEventDesc(returnMessage);
		eventLoggerDAO.logEvent(tbscEventsModel);
		//System.out.println("Authservice...3 "+isValidUser+" msg "+returnMessage);
		return isValidUser;
	}
	
	public int isValidUSerRole(TBSCLogin tbsc_Login) throws ThrowInstantiationException, ThrowClassNotFoundException, IllegalAccessException, SQLException {
	

		int	 isValidUserRole =authenticationDAO.isValidUserRole(tbsc_Login);
			
		return isValidUserRole;
	}
	
	
	
	public Map<String ,Boolean> isValidUser(TBSCLogin tbsc_Login,RequestSourceModel requestSourceModel) throws SQLException
	{
		
		Map<String ,Boolean> resultMap = new HashMap<String, Boolean>();
		String returnMessage="";
		try{
		tbscEventsModel=new TBSCEventsModel();
		tbscEventsModel.setSessionId(requestSourceModel.getSessionId());
		tbscEventsModel.setEventId("AUTH001");
		tbscEventsModel.setEventName("Validate User Login");
		tbscEventsModel.setEventDesc("User Validation Requested");
		tbscEventsModel.setEventGenBy(requestSourceModel.getRequestedUserId());
		tbscEventsModel.setEventIPAddress(requestSourceModel.getIPAddress());
		tbscEventsModel.setEventSrcModule("Authentication Module- Web");
		tbscEventsModel.setEventType("ACTION");

		Timestamp now=new Timestamp(Calendar.getInstance().getTimeInMillis());
		tbscEventsModel.setEventOccrdTime(now);
		eventLoggerDAO.logEvent(tbscEventsModel);
		boolean	 isValidUser =authenticationDAO.isValidUser(tbsc_Login);
		
		if(true == isValidUser){
			returnMessage="Valid user";
			resultMap.put(returnMessage, true);
		}
		else{
			returnMessage="Invalid user";
			resultMap.put(returnMessage, false);
		}
		tbscEventsModel.setEventDesc(returnMessage);
		eventLoggerDAO.logEvent(tbscEventsModel);
		}
		catch(SQLException e){
			returnMessage="Some Error Occured.";
			resultMap.put(returnMessage, false);
			tbscEventsModel.setEventType("EXCEPTION");
			tbscEventsModel.setEventDesc(returnMessage);
			eventLoggerDAO.logEvent(tbscEventsModel);
		}
		catch(Exception e){
			returnMessage=e.getMessage();
			resultMap.put(returnMessage, false);
			tbscEventsModel.setEventType("EXCEPTION");
			tbscEventsModel.setEventDesc(returnMessage);
			eventLoggerDAO.logEvent(tbscEventsModel);
		}
		finally{
		return resultMap;
		}
	}
	

	
	
}
