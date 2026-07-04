package org.society.model;

public class RequestSourceModel {

		private String IPAddress;
		private String requestedUserId;
		private String sessionId;
		private boolean isUserValidated=false;
		private TBSCSocStaffModel userDetails;
		
		
		
		
		public String getSessionId() {
			return sessionId;
		}
		public void setSessionId(String sessionId) {
			this.sessionId = sessionId;
		}
		public String getIPAddress() {
			return IPAddress;
		}
		public void setIPAddress(String iPAddress) {
			IPAddress = iPAddress;
		}
		public String getRequestedUserId() {
			return requestedUserId;
		}
		public void setRequestedUserId(String requestedUserId) {
			this.requestedUserId = requestedUserId;
		}
		
		public boolean isUserValidated() {
			return isUserValidated;
		}
		public void setUserValidated(boolean isUserValidated) {
			this.isUserValidated = isUserValidated;
		}
		public TBSCSocStaffModel getUserDetails() {
			return userDetails;
		}
		public void setUserDetails(TBSCSocStaffModel userDetails) {
			this.userDetails = userDetails;
		}
		
		
		
}
