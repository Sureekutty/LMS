package org.society.model;

public class TBSCLogin {
	
	private String socEmpCode;
	private String password;
	private String active;
	private String expiryDate;
	private String recTime;
	
	public String getSocEmpCodel() {
		return socEmpCode;
	}
	public void setSocEmpCode(String socEmpCode) {
		this.socEmpCode = socEmpCode;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getActive() {
		return active;
	}
	public void setActive(String active) {
		this.active = active;
	}
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
	public String getRecTime() {
		return recTime;
	}
	public void setRecTime(String recTime) {
		this.recTime = recTime;
	}
	
	
}
