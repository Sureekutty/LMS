var context;

function namesVerificationToDoTrayAction(record, url){
	var url = url+'&_eventId=';
	var tray = getTray(url);
	if(record.taskid=='ORGREQ')
	{
		if (tray=="") {
			if (record.stageid == 'DRAFT' ||  record.stageid == 'ECLBK')
			{
				location.replace(url + 'viewOSAOrginsation&threadId='+ record.threadid + '&userDesignation=EMP'+'&requestId='+record.reqstid+'&stageId=DRAFT'+"&requestId="+record.reqstid);
			}
			else if(record.stageid == 'RJCTD'){
				location.replace(url + 'viewOSAOrginsation&threadId='+ record.threadid + '&userDesignation=RJCTD'+'&requestId='+record.reqstid+'&stageId=RJCTD'+"&requestId="+record.reqstid);
			}
			else if(record.stageid == 'APRVL'|| record.curstatus=='to_ao_approval' ||  record.curstatus=='to_ao_forward')
			{
				location.replace(url+'viewOSAOrginsation&threadId='+record.threadid+'&userDesignation=AO'+'&stageId=APRVL'+'&requestId='+record.reqstid+"&requestId="+record.reqstid);
		    }
			else if(record.stageid == 'APRVD')
			{
				location.replace(url+'viewOSAOrginsation&threadId='+record.threadid+'&userDesignation=END'+'&requestId='+record.reqstid+"&requestId="+record.reqstid);
		    }
			else if(record.stageid=='DLTRC'){

		    	location.replace(url + 'viewOSAOrginsation&threadId='+ record.threadid + '&userDesignation=DAO'+'&requestId='+record.reqstid+"&requestId="+record.reqstid);
		    	}
		}
		else
		{
			location.replace(url+'viewOSAOrginsation&threadId='+record.threadid+'&userDesignation=TRAY'+'&tray='+tray+"&requestId="+record.reqstid+'&taskId='+record.taskid);
		}
	}
}

function schedulerNoteAction(record, url){
	var url = url+'&_eventId=';

	var tray = getTray(url);
	if(record.processid=='SCHEDULER'){		
		if(record.taskid=='LVNOTE') {			
			if(tray==""){	
					location.replace(url+'noteView&threadId='+record.threadid+"&requestId="+record.reqstid+'&taskId='+record.taskid);
				}
			else{								
				location.replace(url+'noteView&threadId='+record.threadid+"&requestId="+record.reqstid+'&tray='+tray+'&taskId='+record.taskid);
			}
		}
	}
}

function defineRolesToDoTrayAction(record, url){
	var url = url+'&_eventId=';
	var tray = getTray(url);

	if(record.taskid=='RLDEFN') 
	{

		if (tray=="")
		{
			if (record.stageid == 'DRAFT' ||  record.curstatus == 'to_emp_callback') {
				location.replace(url + 'viewDefineRoles&threadID='+ record.threadid + '&userDesignation=EMP'+"&requestId="+record.reqstid);
			}else if(record.curstatus == 'to_ao_approval'|| record.curstatus == 'to_ao_forward') {
				location.replace(url+'viewDefineRoles&threadID='+record.threadid+'&userDesignation=AO');
			}else if(record.curstatus == 'to_roles_approved'|| record.curstatus=='to_role_define_rejected') 
				{
				location.replace(url+'viewDefineRoles&threadID='+record.threadid+'&userDesignation=END');
				} 
		} 
		else
		{
			location.replace(url+'viewDefineRoles&threadID='+record.threadid+'&userDesignation=TRAY'+'&tray='+tray);
		}
	}

}


	function viewHistoryPopup() {
		  if (xmlHttpReq.readyState == 4) {		
			  if (xmlHttpReq.status == 200) {			
				  var textResponse = trim(xmlHttpReq.responseText);			
				  		if(textResponse.length > 0) {
				  			popup_show(750,'History View',true, context);
							document.getElementById('pop_body').innerHTML=textResponse;
				  		} else {
				  			alert("Error in retrieve Comments");
				  		}
			  }
		  }
	}

function parameterDetailsTodoListTray(record,url){
	var url = url+'&_eventId=';
	var tray = getTray(url);
	if(record.taskid=='PRDTEN')
	{
		if (tray == ""){
			if (record.stageid == 'DRAFT' ||record.curstatus == 'emp_callback') {
			location.replace(url +'viewParameterDetails&threadID='+ record.threadid+'&userDesignation=EMP'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			}
			else if(record.curstatus == 'to_ao_approval'|| record.curstatus == 'to_ao_forward') {
				location.replace(url+'viewParameterDetails&threadID='+record.threadid+'&userDesignation=AO'+"&requestId="+record.reqstid+'&stageId='+record.stageid+"&taskId="+record.taskid);
			}
			else if(record.stageid=='RJCTD'||record.curstatus == 'to_ao_Rejected'){
				location.replace(url+'viewParameterDetails&threadID='+record.threadid+'&userDesignation=RJCTD'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			}
			else if(record.stageid == 'APRVD'||record.curstatus == 'to_ao_approved'){
				location.replace(url+'viewParameterDetails&threadID='+record.threadid+'&requestId='+record.reqstid+'&userDesignation=END'+"&taskid="+record.taskid);
		    }
			else if(record.stageid == 'ACKNW'||record.curstatus=='to_parameterReq_end'){
				location.replace(url+'viewParameterDetails&threadID='+record.threadid+'&userDesignation=END'+"&requestId="+record.reqstid+"&taskid="+record.taskid);
			}
			else if(record.stageid == 'DLTRC'){
				location.replace(url + 'viewParameterDetails&threadID='+ record.threadid + '&userDesignation=DAO'+'&requestId='+record.reqstid+"&requestId="+record.taskid);
			}
			
		}
		else
		{
			location.replace(url+'viewParameterDetails&threadID='+record.threadid+'&userDesignation=TRAY'+'&requestId='+record.reqstid+'&tray='+tray+"&taskId="+record.taskid);
		}
	}
}

//screen List related Code Added 15-10-2014
function replacetoscreenlocation(record,url)
{
	var screenID=trim(record.screenid);
	//TENDER PROCESSING
	//alert(screenID);
	if(screenID=="TEST"){
		location.replace(url+'viewTestScreen');
	}else if(screenID=="TEST1-"){
		location.replace(url+'viewTestScreen');
	}
	if(screenID=='PU03S')
	{
	location.replace(url+'viewindentregistration');	
	}
	else if(screenID=='PU51S')
	{
	location.replace(url+'viewsuggestedvendor');	
	}
	else if(screenID=='PU02S')
	{
	location.replace(url+'veiwIndentGeneration');	
	}
	else if(screenID=='PU65S')
	{
	location.replace(url+'veiwSuggestedVenPT');	
	}
	else if(screenID=='PU52S')
	{
	location.replace(url+'viewindGenFreeIssueOfMat');	
	}else if(screenID=="PU05S"){
		location.replace(url+'viewFileOpenRetendDue');
	}else if(screenID=="PU06S"){
		location.replace(url+'viewTenderEnq');
	}
	else if(screenID=='PU53S')
	{
		location.replace(url+'viewPurStsUp');	
	}else if(screenID=="PU61S"){
		location.replace(url+'viewTenEnqTdPtyOpt');
	}else if(screenID=="PU21S"){
		location.replace(url+'viewIndentsStatusDisplay');
	}
	//PURCHASE TENDOR PROCESSING
	else if(screenID=='PU10S')
	{
	location.replace(url+'viewPartiesResp');		
	}
	else if(screenID=="PU50S")
	{
		location.replace(url+'viewPurOrdAftVenChng');
	}
	//VENDOR REGISTRATION
	else if(screenID=="PU01S")
	{
		location.replace(url+'viewVendorRegistration');
	}
	else if(screenID=="PU54S")
	{
		location.replace(url+'viewVendorMatQuery');
	}
	
	//Purchase Order Processing
	else if(screenID=='PU26S')
	{
	location.replace(url+'viewpurorderrelease');		
	}
	else if(screenID=='PU32S')
	{
	location.replace(url+'viewPurchaseOrderCancellation');		
	}
	else if(screenID=='PU25S')
	{
	location.replace(url+'viewPreAuditStsUp');		
	}
	else if(screenID=="PU36S")
	{
	location.replace(url+'viewPurOrderRelReinstate');
	}
	else if(screenID=="PU62S")
	{
		location.replace(url+'viewPOLIC');
	}
	else if(screenID=="PU29S")
	{
		location.replace(url+'viewPurOrdAmendment');
	}
	else if(screenID=="PU34S")
	{
		location.replace(url+'viewPurOrderRemainder');
	}
	else if(screenID=="PU45S")
	{
		location.replace(url+'viewApplicationForLetterCredit');
	}
	// INDENTOR RECOMMENDATION
	else if(screenID=="PU19S"){
		location.replace(url+'viewIndentorRecommendation');
	}else if(screenID=="PU16S"){
		location.replace(url+'viewTendCCompareDE');
	}
	//Vendor Name Change
	else if(screenID=="PU60S"){
		location.replace(url+'viewVendoreNameChange');
	}
	else if(screenID=="PU22S"){
		location.replace(url+'viewPurchaseApprovalsDates');
	}
	//PURCHASE ORDER DUTY EXEMPTION
	else if(screenID=="PU37S"){
		location.replace(url+'viewPurOrdDutyExemption');
	}
	//PURCHASE CUSTOM CLEARENCE(DATES)
	else if(screenID=="PU38S"){
		location.replace(url+'viewPurOrdCustomClearence');
	}
	//PURCHASE CUSTOM CLEARENCE(CHECKLIST)
	else if(screenID=="PU39S"){
		location.replace(url+'viewPurOrdClearCheckList');
	}
}