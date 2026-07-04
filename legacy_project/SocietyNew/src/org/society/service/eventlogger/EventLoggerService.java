package org.society.service.eventlogger;

import java.sql.SQLException;

import org.society.dao.eventlogger.EventLoggerDAO;
import org.society.model.TBSCEventsModel;

public class EventLoggerService {

	public boolean logEvent(TBSCEventsModel tbscEventsModel) throws SQLException{
          EventLoggerDAO eventLoggerDAO =new EventLoggerDAO();
          boolean isEventLogged = eventLoggerDAO.logEvent(tbscEventsModel);
          return isEventLogged;
	}
}
