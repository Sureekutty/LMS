package org.society.dao.eventlogger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.society.model.TBSCEventsModel;
import org.society.util.DataBaseConnectionForNewDB;

public class EventLoggerDAO  {
	
	
	public boolean logEvent(TBSCEventsModel tbscEventsModel) throws SQLException  {
		boolean logEventResult = false;
	
		
		try {
			PreparedStatement preparedStatement=null;
			Connection	connection = DataBaseConnectionForNewDB.getConnectionForSyBase();
			String sqlQuery = "INSERT INTO TBSC_EVENTS(SESSION_ID,EVENT_ID,EVENT_NAME,EVENT_DESC,EVENT_GEN_BY,EVENT_OCCRD_TIME,EVENT_TYPE,EVENT_SRC_MODULE,EVENT_IPADDRESS) VALUES(?,?,?,?,?,?,?,?,?)";
			
			//System.out.println("logger...SQL..1");
			
			preparedStatement = connection.prepareStatement(sqlQuery);
			preparedStatement.setString(1, tbscEventsModel.getSessionId());
		
			preparedStatement.setString(2, tbscEventsModel.getEventId());
	
			preparedStatement.setString(3, tbscEventsModel.getEventName());
	
			preparedStatement.setString(4, tbscEventsModel.getEventDesc());
		
			preparedStatement.setString(5, tbscEventsModel.getEventGenBy());
	
			preparedStatement.setTimestamp(6, tbscEventsModel.getEventOccrdTime());
		
			preparedStatement.setString(7, tbscEventsModel.getEventType());
			
			preparedStatement.setString(8, tbscEventsModel.getEventSrcModule());
	
			preparedStatement.setString(9, tbscEventsModel.getEventIPAddress());
			int rowsAffected= preparedStatement.executeUpdate();
			
			//System.out.println("logger...SQL..2");
			if(rowsAffected==0)
			{
				logEventResult = false;
				
			}
			
		else{
			
			logEventResult = true;
			
		    }
			if(null!=preparedStatement)
			{
				preparedStatement.close();
				
			}
			if(connection!=null){
				connection.close(); 
				}
			
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		finally{
			
	
		}
	
		return logEventResult;
	}
	
	public static void main(String[] args) {
		String string = "Minimum shares required to get long term loan is 300:SP_Loans";
		
	}
	
}
