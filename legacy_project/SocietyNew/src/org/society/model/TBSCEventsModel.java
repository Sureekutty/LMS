package org.society.model;

import java.sql.Timestamp;

public class TBSCEventsModel {
	private String sessionId;
	private String eventId;
	private String eventName;
	private String eventDesc;
	private String eventGenBy;
	private Timestamp eventOccrdTime;
	private String eventType;
	private String eventSrcModule;
	private String eventIPAddress;

	public String getEventIPAddress() {
		return eventIPAddress;
	}
	public void setEventIPAddress(String eventIPAddress) {
		this.eventIPAddress = eventIPAddress;
	}
	public String getSessionId() {
		return sessionId;
	}
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	public String getEventId() {
		return eventId;
	}
	public void setEventId(String eventId) {
		this.eventId = eventId;
	}
	public String getEventName() {
		return eventName;
	}
	public void setEventName(String eventName) {
		this.eventName = eventName;
	}
	public String getEventDesc() {
		return eventDesc;
	}
	public void setEventDesc(String eventDesc) {
		this.eventDesc = eventDesc;
	}
	public String getEventGenBy() {
		return eventGenBy;
	}
	public void setEventGenBy(String eventGenBy) {
		this.eventGenBy = eventGenBy;
	}
	public Timestamp getEventOccrdTime() {
		return eventOccrdTime;
	}
	public void setEventOccrdTime(Timestamp eventOccrdTime) {
		this.eventOccrdTime = eventOccrdTime;
	}
	public String getEventType() {
		return eventType;
	}
	public void setEventType(String eventType) {
		this.eventType = eventType;
	}
	public String getEventSrcModule() {
		return eventSrcModule;
	}
	public void setEventSrcModule(String eventSrcModule) {
		this.eventSrcModule = eventSrcModule;
	}
	
	

}
