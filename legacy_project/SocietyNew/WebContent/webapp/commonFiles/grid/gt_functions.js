/*****************************************************************

	Sigma Grid 2.2
	Copyright (C) 2005-2009 Sigma Soft Ltd. All Rights Reserved. 
	http://www.sigmawidgets.com/

	WARNING: This software program is protected by copyright law 
	and international treaties. Unauthorized reproduction or
	distribution of this program, or any portion of it, may result
	in severe civil and criminal penalties, and will be prosecuted
	to the maximum extent possible under the law.

	You can use this softwareunder LGPL license, or you need to buy 
  a commercial license for a better tech support or non-LGPL usage.

*****************************************************************/
var flag = 0;

	if(record.STAGEID != '')
	{
		document.getElementById('stageId').value = record.STAGEID;
	}
	else
	{
		document.getElementById('stageId').value = '';
	}

function markForForward(chkbox, workflowname, reqstid, taskid, processid, threadid, curstatus, stageid) {
	var threadid = "'" + workflowname +  "~" + reqstid + "~" + taskid + "~" + processid + "~" + threadid + "~" + curstatus + "~" + stageid + "'";
	obj = document.getElementById('todorecords');
	var check = 0;
	if(!chkbox.checked) {
		obj.value = obj.value.replace(threadid +",",'');
		obj.value = obj.value.replace(threadid ,'');
	}
	else {
		if(obj.value.indexOf(threadid) > -1) return;
		if(obj.value != '') obj.value = obj.value + ",";
		obj.value = obj.value + threadid ;
	}
}
function headerAdminWrkflowClick() {
	var chkbox = document.getElementById('headerchk');
	chkbox.checked = !chkbox.checked;
	selectAdminWflow(chkbox, true);
}
function selectAdminWflow(obj, check) {
	var elms = document.forms[0].elements;
	var val = obj.checked;
	var i = 0;
	var id = '';
	var values = '';	
	for(i = 0; i < elms.length; i++) {
		if(elms[i].type == 'checkbox') {
			elms[i].checked = val;
			id=elms[i].id;
			if(id != null && id != undefined && id.indexOf('grid_chk_') > -1) {
				values = elms[i].id.split(',');
				markForForward(obj, values[1], values[2], values[3], values[4], values[5], values[6], values[7]);
			}
		}
	}
}
function markForArchive(chkbox, threadid, taskid, transid) {
	var threadid = "'" + threadid +  "-" + taskid + "-" + transid + "'";
	obj = document.getElementById('reqids');
	var check = 0;
	if(!chkbox.checked) {
		obj.value = obj.value.replace(threadid +",",'');
		obj.value = obj.value.replace(threadid ,'');
	}
	else {
		if(obj.value.indexOf(threadid) > -1) return;
		if(obj.value != '') obj.value = obj.value + ",";
		obj.value = obj.value + threadid ;
	}
}

function markForDelete(chkbox, alertid) {
	var threadid = "'" + alertid + "'";
	obj = document.getElementById('reqids');
	var check = 0;
	if(!chkbox.checked) {
		obj.value = obj.value.replace(threadid +",",'');
		obj.value = obj.value.replace(threadid ,'');
	}
	else {
		if(obj.value.indexOf(threadid) > -1) return;
		if(obj.value != '') obj.value = obj.value + ",";
		obj.value = obj.value + threadid ;
	}
}
function checkselection() {
	obj = document.getElementById('reqids');
	if(obj.value == '') {
		alert('Please select atleast one record');
		return false;
	}
	return true;
}

function headerDeleteClick() {
	var chkbox = document.getElementById('headerchk');
	chkbox.checked = !chkbox.checked;
	selectDelete(chkbox, true);
}

function headerArchiveClick() {
	var chkbox = document.getElementById('headerchk');
	chkbox.checked = !chkbox.checked;
	selectCB(chkbox, true);
}

function selectDelete(obj, check) {
	var elms = document.forms[0].elements;
	var val = obj.checked;
	var i = 0;
	var id = '';
	var values = '';	
	for(i = 0; i < elms.length; i++) {
		if(elms[i].type == 'checkbox') {
			elms[i].checked = val;
			id=elms[i].id;
			if(id != null && id != undefined && id.indexOf('grid_chk_') > -1) {
				values = elms[i].id.split(',');
				markForDelete(obj, values[1]);
			}
		}
	}
}

function selectCB(obj, check) {
	var elms = document.forms[0].elements;
	var val = obj.checked;
	var i = 0;
	var id = '';
	var values = '';	
	for(i = 0; i < elms.length; i++) {
		if(elms[i].type == 'checkbox') {
			elms[i].checked = val;
			id=elms[i].id;
			if(id != null && id != undefined && id.indexOf('grid_chk_') > -1) {
				values = elms[i].id.split(',');
				markForArchive(obj, values[1], values[2], values[3]);
			}
		}
	}
}

function selectConsolidateCB(obj, check) {
	var elms = document.forms[0].elements;
	var val = obj.checked;
	var i = 0;
	var id = '';
	var values = '';	
	for(i = 0; i < elms.length; i++) {
		if(elms[i].type == 'checkbox') {
			elms[i].checked = val;
			id=elms[i].id;
			// commented the following code for the selection of all the check boxes records in the GRID
			//if(id != null && id != undefined && id.indexOf('grid_chk_') > -1)
				if(id != null && id != undefined){
				values = elms[i].id.split(',');
				markForConsolidate(obj, values[1], values[2], values[3],values[4],values[5],values[6]);
			}
		}
	}
}

function headerConsolidateClick() {
	var chkbox = document.getElementById('headerchk');
	chkbox.checked = !chkbox.checked;
	selectConsolidateCB(chkbox, true);
}

function markForConsolidate(chkbox, reqstyear, reqstid, functionid ,empcode,empName,paymentMode) {
	var threadid = "'" + reqstyear +  "-" + reqstid + "-" + functionid + "'";
	var threadIdNew = reqstyear +  "-" + reqstid + "-" + functionid + "-"+empcode+ "-" +empName+ "-"+paymentMode;
	obj = document.getElementById('taskThreads');
	
	var check = 0;
	if(!chkbox.checked) {
		obj.value = obj.value.replace(threadid +",",'');
		obj.value = obj.value.replace(threadid ,'');
	}
	else {
		if(obj.value.indexOf(threadid) > -1) return;
		if(obj.value != '') obj.value = obj.value + ",";
		obj.value = obj.value + threadid ;
	}
	var taskThreads = obj.value;
	if(taskThreads.charAt(taskThreads.length-1) == ',')
		obj.value = taskThreads.substring(0, taskThreads.length-1);
	
	obj = document.getElementById('taskThreadsNew');
	
	var check = 0;
	if(!chkbox.checked) {
		obj.value = obj.value.replace(threadIdNew +",",'');
		obj.value = obj.value.replace(threadIdNew ,'');
	}
	else {
		if(obj.value.indexOf(threadIdNew) > -1) return;
		if(obj.value != '') obj.value = obj.value + ",";
		obj.value = obj.value + threadIdNew ;
	}
	var taskThreadsNew = obj.value;
	if(taskThreadsNew.charAt(taskThreadsNew.length-1) == ',')
		obj.value = taskThreadsNew.substring(0, taskThreadsNew.length-1);

}

function headerSelectClick() {
	var chkbox = document.getElementById('headerchk');
	chkbox.checked = !chkbox.checked;
	selectAll(chkbox, true);
}
