function loadLeaveReportDetails(docid) {
	var flowExecutionUrl = document.getElementById('_flowExecutionUrl').value;
	var userId = document.getElementById("login_id").value;
	document.reportForm.docId.value=docid;
	document.reportForm.userId.value=userId;
	document.reportForm.file.value="getFile";
	document.reportForm.submit();	
}


