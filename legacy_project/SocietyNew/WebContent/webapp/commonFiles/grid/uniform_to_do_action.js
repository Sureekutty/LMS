var context;
function getTray(url) {
		var url1 = location.href;
		if(url1.toLowerCase().indexOf('mytray') > -1) return 'mytray';
		if(url1.toLowerCase().indexOf('outtray') > -1) return 'outtray';
		if(url1.toLowerCase().indexOf('archive') > -1) return 'archive';
		if(url.indexOf('workflowadmin') > -1) return 'workflowadmin';
		return "";
	}

function uniformOrdGenAdmToDoTrayAction(record, url){
	var url = url+'&_eventId=';
	var tray = getTray(url);
	if(record.taskid=='UOGADM')
	{
		if (tray=="") {
			if (record.stageid == 'DRAFT' || record.curstatus == 'DRAFT'||  record.stageid == 'ECLBK' )
			{
				location.replace(url+'viewUniformOrdGenAdminRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=EMP');
			} 
			else if(record.stageid == 'APRVL'|| record.curstatus=='to_ao_approval')
			{
				location.replace(url+'viewUniformOrdGenAdminRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=AO');
		    }
			else if(record.curstatus == 'To_Ao_Reject') 
			{
				location.replace(url+'viewUniformOrdGenAdminRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=EMP');
		    }
			else if(record.stageid == 'APRVD' || record.curstatus=='ACKNW' ||record.subject=="ProcessUniformOrder") 
			{
				location.replace(url+'viewProcessUniformOrderStoresRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid);
		    }
			else if(record.curstatus == 'to_ao_forward') 
			{
				location.replace(url+'viewUniformOrdGenAdminRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=AO');
		    }
		}
		else{
				location.replace(url+'viewUniformOrdGenAdminRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=TRAY'+'&tray='+tray);
		}
	}
}	

function uniformIssueVoucherGeneration(record, url){
	var url = url+'&_eventId=';
	var tray = getTray(url);
	if(record.taskid=='UIVGEN')
	{
		if (tray=="") {
			if (record.stageid == 'DRAFT'|| record.stageid == 'ECLBK' || record.curstatus == 'DRAFT')
			{
				location.replace(url+'viewIssueVoucherGenerationRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=EMP');
			} 
			else if(record.stageid == 'APRVL'|| record.curstatus=='to_ao_approval')
			{
				location.replace(url+'viewIssueVoucherGenerationRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=AO');
		    }
			else if(record.curstatus == 'To_Ao_Reject') 
			{
				location.replace(url+'viewIssueVoucherGenerationRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=EMP');
		    }
			else if(record.stageid == 'APRVD' || record.curstatus=='ACKNW' ) 
			{
				location.replace(url+'viewIssueVoucherGenerationRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=END');
		    }
			else if(record.curstatus == 'to_ao_forward') 
			{
				location.replace(url+'viewIssueVoucherGenerationRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=END');
		    }
		}
		else{
				location.replace(url+'viewIssueVoucherGenerationRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=TRAY'+'&tray='+tray);
		}
	}
}
function uniformsIssuedToDoTrayAction(record, url){
	var url = url+'&_eventId=';
	var tray = getTray(url);
	if(record.taskid=='UOISSU')
	{
		if (tray=="") {
			if (record.stageid == 'DRAFT' || record.curstatus == 'DRAFT'|| record.stageid == 'ECLBK'||record.curstatus == 'emp_callback' )
			{
				location.replace(url+'viewUniformsIssuedRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=EMP');
			} 
			else if(record.stageid == 'APRVL'|| record.curstatus=='to_ao_approval')
			{
				location.replace(url+'viewUniformsIssuedRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=AO');
		    }
			else if(record.curstatus == 'To_Ao_Reject') 
			{
				location.replace(url+'viewUniformsIssuedRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=EMP');
		    }
			else if(record.stageid == 'APRVD' || record.curstatus=='ACKNW' ) 
			{
				location.replace(url+'viewUniformsIssuedRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=END');
		    }
			else if(record.curstatus == 'to_ao_forward') 
			{
				location.replace(url+'viewUniformsIssuedRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=END');
		    }
		}
		else{
				location.replace(url+'viewUniformsIssuedRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=TRAY'+'&tray='+tray);
		}
	}
}	
	function uniformAmendToDoTrayAction(record, url){
		var url = url+'&_eventId=';
		var tray = getTray(url);
		if(record.taskid=='AMDREQ')
		{
			if (tray=="") {
				if (record.stageid == 'DRAFT' || record.curstatus == 'emp_callback' )
				{
					location.replace(url+'viewUniformAmendmentRequestApply&threadId='+record.threadid+'&userDesignation=ECLBK');
				} 
				else if(record.stageid == 'APRVL'|| record.curstatus=='to_ao_approval')
				{
					location.replace(url+'viewUniformAmendmentRequestApply&threadId='+record.threadid+'&userDesignation=AO');
			    }
				else if(record.curstatus == 'To_Ao_Reject') 
				{
					location.replace(url+'viewUniformAmendmentRequestApply&threadId='+record.threadid+'&userDesignation=ECLBK');
			    }
				else if(record.curstatus == 'to_ao_forward') 
				{
					location.replace(url+'viewUniformAmendmentRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=AO');
			    }
				else if(record.stageid == 'APRVD'|| record.curstatus=='ACKNW')
				{
					location.replace(url+'viewUniformAmendmentRequestApply&threadId='+record.threadid+'&userDesignation=END');
			    }
			}
			else{
					location.replace(url+'viewUniformAmendmentRequestApply&threadId='+record.threadid+'&userDesignation=TRAY'+'&tray='+tray+"&taskId="+record.taskid);
				}
		}
	}
	function uniformPOCanclToDoTrayAction(record, url){
		var url = url+'&_eventId=';
		var tray = getTray(url);
		if(record.taskid=='POCANC')
		{
			if (tray=="") {
				if (record.stageid == 'DRAFT' || record.curstatus == 'emp_callback'|| record.curstatus=='ao_rejected')
				{
					location.replace(url+'viewPartialOrderCancellationRequestApply&threadId='+record.threadid+'&userDesignation=EMP'+'&curstatus='+record.curstatus+'&requestId='+record.reqstid);
				} 
				else if(record.stageid == 'APRVL'|| record.curstatus=='to_ao_approval' || record.curstatus=='to_ao_forward')
				{
					location.replace(url+'viewPartialOrderCancellationRequestApply&threadId='+record.threadid+'&userDesignation=AO'+'&curstatus='+record.curstatus+'&requestId='+record.reqstid);
			    }
				else if(record.curstatus == 'to_ao_forward') 
				{
					location.replace(url+'viewPartialOrderCancellationRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid+'&userDesignation=AO');
			    }
				else if(record.curstatus == 'ao_approved') 
				{
					location.replace(url+'viewPartialOrderCancellationRequestApply&threadId='+record.threadid+'&userDesignation=END'+'&curstatus='+record.curstatus+'&requestId='+record.reqstid);
			    }
			}
			else{
					location.replace(url+'viewPartialOrderCancellationRequestApply&threadId='+record.threadid+'&userDesignation=TRAY'+'&tray='+tray+'&requestId='+record.reqstid);
			}
		}
	}
	function processUniformToDoTrayAction(record, url){
		var url = url+'&_eventId=';
		var tray = getTray(url);
		if(record.taskid=='PUOSTR')
		{
			if (tray=="") {
				if (record.stageid == 'APRVD')
				{
					location.replace(url+'viewProcessUniformOrderStoresRequestApply&threadId='+record.threadid+"&requestId="+record.reqstid+"&taskId="+record.taskid);
				} 
				else if (record.stageid == 'APRVL')
				{
					location.replace(url+'viewProcessUniformOrderStoresRequestApply&requestId='+record.reqstid+'&threadId='+record.threadid+'&userDesignation=AO'+'&curstatus='+record.curstatus);
				}else if(record.stageid == 'ACKNW'|| record.curstatus=='to_request_end')
				{
					location.replace(url+'viewProcessUniformOrderStoresRequestApply&requestId='+record.reqstid+'&threadId='+record.threadid+'&userDesignation=END'+'&curstatus='+record.curstatus);
			    } 
			}
			else{
				location.replace(url+'viewProcessUniformOrderStoresRequestApply&requestId='+record.reqstid+'&threadId='+record.threadid+'&userDesignation=TRAY');
			}
			
		}
	}
	function uniformEmpClaimReimToDoTrayAction(record,url)
	{
		var url=url+'&_eventId=';
		var tray=getTray(url);
		if((record.taskid=='UECRVO')||(record.taskid=='UECRAO'))
		{
			if (tray=="") {
				if ((record.stageid == 'DRAFT' || record.curstatus == 'emp_callback') && (record.subject!='Uniform Emp Claim VO Consolidation' )&& (record.subject!='Uniform Emp Claim AO Consolidation' ) ){
					location.replace(url + 'viewEmpClaimsReimbursementRequestApply&threadId='+ record.threadid + '&userDesignation=EMP'+"&requestId="+record.reqstid);
					}
				else if	((record.stageid == 'DRAFT' ) && (record.subject!='Uniform Emp Claim AO Consolidation') && (record.residingwith=='UECRAO1'||record.residingwith=='UECRAO2') ){
					location.replace(url + 'viewEmpClaimsReimbursementRequestApply&threadId='+ record.threadid + '&userDesignation=EMP'+"&requestId="+record.reqstid);
					}
				else if(record.curstatus == 'to_vo_verify'|| record.curstatus == 'to_vo_forward' || record.subject =='Uniform Emp Claim VO Consolidation') {
					location.replace(url+'viewEmpClaimsReimbursementRequestApply&threadId='+record.threadid+'&userDesignation=VO');
					}
				else if(record.curstatus == 'to_vo_reject'||record.curstatus == 'to_ao_reject') {
					location.replace(url+'viewEmpClaimsReimbursementRequestApply&threadId='+record.threadid+'&userDesignation=RJCTD');
					}
				else if(record.curstatus == 'to_ao_reject1') {
					location.replace(url+'viewEmpClaimsReimbursementRequestApply&threadId='+record.threadid+'&userDesignation=VO');
					}
				else if(record.curstatus == 'to_ao_approval' || record.curstatus == 'to_ao_forward' || record.subject =='Uniform Emp Claim AO Consolidation' ) {
					location.replace(url+'viewEmpClaimsReimbursementRequestApply&threadId='+record.threadid+'&userDesignation=AO');
					}
				else if(record.curstatus=='ACKNW'){
					location.replace(url+'viewEmpClaimsReimbursementRequestApply&threadId='+record.threadid+'&userDesignation=END');
				}
			} 
			else
				location.replace(url+'viewEmpClaimsReimbursementRequestApply&threadId='+record.threadid+'&userDesignation=TRAY'+'&tray='+tray);
		}
	}

	function uniformIssueCancleToDoTrayAction(record, url){
		   		
	var url = url+'&_eventId=';
	var tray = getTray(url);
	if(record.taskid=='IVCREQ')
	{
		if (tray=="") {
			if (record.stageid == 'ECLBK' )	{
				location.replace(url+'viewIssueVoucherCancellationRequestApply&threadId='+record.threadid+'&userDesignation=EMP'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			} 
			if (record.stageid == 'APRVL'){
				location.replace(url+'viewIssueVoucherCancellationRequestApply&threadId='+record.threadid+'&userDesignation=AO'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			}
			if (record.stageid == 'FORWD'){
				location.replace(url+'viewIssueVoucherCancellationRequestApply&threadId='+record.threadid+'&userDesignation=AO'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			}
			if (record.stageid == 'APRVD'){
				location.replace(url+'viewIssueVoucherCancellationRequestApply&threadId='+record.threadid+'&userDesignation=END'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			}
			if (record.stageid == 'RJCTD'){
				location.replace(url+'viewIssueVoucherCancellationRequestApply&threadId='+record.threadid+'&userDesignation=EMP'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			}
			if (record.stageid == 'ACKNW'){
				location.replace(url+'viewIssueVoucherCancellationRequestApply&threadId='+record.threadid+'&userDesignation=END'+"&requestId="+record.reqstid+"&taskId="+record.taskid);
			}
		}else{
				location.replace(url+'viewIssueVoucherCancellationRequestApply&threadId='+record.threadid+'&userDesignation=TRAY'+'&tray='+tray+"&requestId="+record.reqstid+"&taskId="+record.taskid);
		}
			
	}
		   	
}
