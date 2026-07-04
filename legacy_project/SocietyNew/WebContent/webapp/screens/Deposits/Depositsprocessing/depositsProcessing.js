checkDeposit=function(){

	$('#paymentnum').val('')
	var Role = $('#Role').val();
	if(Role==1){
		$('#btnApproval').hide();	
	}else{
		$('#btnSave').hide();
		$('#btnApproval').show();	
	}
	var depositno=$('#depositno').val();
	var memAccno=$('#memAccno').val();
	var deposittype=$('#deposittype').val();
	if(depositno=='null' || depositno==""){
		depositno="";
		DepositProcessReq(deposittype);
		return;
	}
	$.post('/SocietyNew/deposits',{
		req:'getProcessinfo',
		depositno : depositno,
		memAccno : memAccno,
	},function (data) {
		alert(data)
		try {
			var pop_data = eval("("+data+")");
			var memaccno=pop_data.DepositProcess[0].Memdetails.split('-')[0];
			$('#memberDetails').val(pop_data.DepositProcess[0].Memdetails);
			$('#depositNumber').val(pop_data.DepositProcess[0].DepositNo);
			$('#maturityamount').text(pop_data.DepositProcess[0].MaturityAmount);
			$('#maturitydate').text(pop_data.DepositProcess[0].MaturityDate);
			$('#remarks').val(pop_data.DepositProcess[0].Remarks);
			$('#processDate').prop('disabled',false);
			$('#remarks').prop('disabled',false);
			$('#processDate').val(currDate);
			$('#loanrefno').prop('disabled',false);
			$('#loanadjamt').prop('disabled',false);
			$('#settleAmnt').val(pop_data.DepositProcess[0].SettlementAmount);
			
			if(Role==1){
				getLoannumbers(memaccno);
				$('#btnApproval').hide();
				if(pop_data.DepositProcess[0].Status!='ACTIVE'){
					getprocessrequest(pop_data.DepositProcess[0].Status)
				}else{
					DepositProcessReq(deposittype);
				}
			}else{
				if(pop_data.DepositProcess[0].Status=='ACTIVE'){
					$('#btnApproval').hide();
					DepositProcessReq(deposittype);
				}else{
					getprocessrequest(pop_data.DepositProcess[0].Status)
					getpaymentnumber(memaccno,pop_data.DepositProcess[0].DepositNo);
				}
				$('#loanadjamt').prop('disabled',true);
			}

			if(pop_data.DepositProcess[0].Status.includes('ADJ')){
				$('#adjloanref').show();
				$('#adjloanamt').show();
				getDepositref(pop_data.DepositProcess[0].AdjustRefNo,memAccno);
				$('#loanadjamt').val(pop_data.DepositProcess[0].AdjustedAmount);
			}else{
				$('#adjloanref').hide();
				$('#adjloanamt').hide();
			}
			if(pop_data.DepositProcess[0].DepositType=='MIS'){
				$('#loanadjamt').val(0);
				$('#loanadjamt').prop('disabled',true);
			}else{
				$('#loanadjamt').prop('disabled',false);
			}
			getDepositsType(pop_data.DepositProcess[0].DepositType);
		} catch (e) {
			alert('Exception in checkEmp ' +e.message)
		}
	});

}
$(document).ready(function() {
	displayScreenDetails("Deposit Processing");
	/*	cleardepositprocessTypes = function() {
		var sel = document.getElementById("depositprocessTypes");
		var options = sel.options;
		for (var i = options.length; i > 0; i--) {
			sel.remove(i);
		}
	}*/

	/*	getdepositprocessTypes = function() {
		cleardepositprocessTypes();
		$.post('/SocietyNew/depositProcessing', {
			req : 'processTypes',
		}, function(data) {
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				var error = pop_data.ERROR;
				if(error == 'NO'){
				arr = pop_data.DEPOSITS;
				var sel = document.getElementById("depositprocessTypes");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp =arr[i].DepositTypeDescription;
					option.text=temp;
					option.value=arr[i].DepositTypeCode;
					sel.add(option);
				}
				$("#depositprocessTypes").trigger("chosen:updated");
				$("#depositprocessTypes").prop("disabled" ,false);
				}
				else{
					alert("zxczxc "+error);
				}
				}
				catch (e) {
					// TODO: handle exception
					alert('Exception in processTypes ' +e.message)
				}
		});
	}*/
	cleardepositprocessreq = function() {
		var sel = document.getElementById("depositprocessreq");
		var options = sel.options;
		for (var i = options.length; i > 0; i--) {
			sel.remove(i);
		}
	}
	onLoad = function() {
		$(':input').not('[type = button],[id = currDate]').val('');
		$(':input').not('[type = button],[id = currDate]').prop('disabled',true);
		$('#depositprocessTypes').prop('disabled',false);
		$('#depositprocessreq').prop('disabled',false);
		//cleardepositprocessTypes();
		//getdepositprocessTypes();
		currDate = $('#currDate').val();
	}
	onLoad();
	/*	$('#depositNumber').change(function() {
		var depositNumber = this.value;
		var remarks = depositNumber.split('&&')[1];
		var userinfo = depositNumber.split('&&')[0];
		if(depositNumber == 'Select'){
			alert('Select deposit number');
			return;
		}
		$('#memberDetails').text(userinfo);
		var remarks = $('#remarks').val(remarks);
	});*/
	$("#btnSave").click(function(){
		if(confirm("Do you want save the Record")){
			if(validateSave()){
				var loanrefno ;
				var loanadjamt;
				var depositprocesstypes = $('#depositprocessTypes').val();
				var depositNumber = $('#depositNumber').val();
				var depositprocessreq = $('#depositprocessreq').val();
				var remarks = $('#remarks').val();
				var memaccno = $('#memberDetails').val().split('-')[0];
				loanrefno =$('#loanrefno').val();
				loanadjamt= $('#loanadjamt').val();
				var processDate = $('#processDate').val();
				if(!depositprocessreq.includes('ADJ')){
					loanrefno ="0";
					loanadjamt= 0;
				}
				$.post('/SocietyNew/DepositProcessingController',{
					req : 'savedepositprocess',
					depositprocesstypes:depositprocesstypes,
					depositNumber:depositNumber,
					depositprocessreq:depositprocessreq,
					remarks:remarks,
					memaccno:memaccno,
					option :depositprocessreq,
					loanrefno:loanrefno,
					loanadjamt:loanadjamt,
					processDate:processDate,
				},function(data){
					try {
						var pop_data = eval("("+data+")");
						if(pop_data.success == "y"){
							alert("REQUEST SAVED SUCCESSFULLY WITH PAYMENT NO "+pop_data.paymentno);
							$('#btnSave').prop('disabled',true);
						}
						else{
							alert("FAILED TO SAVE THE REQUEST")
						}
					} catch (e) {
						// TODO: handle exception
						alert(' ' +e.message)
					}
				});
			}
		}

	});
	$("#btnApproval").click(function(){
		if(confirm("Do you want Approval this Record")){
			var memaccno = $('#memberDetails').val().split('-')[0];
			var depositNumber = $('#depositNumber').val();
			var paymentnum = $('#paymentnum').val();
			var depositprocessreq = $('#depositprocessreq').val();
			var remarks = $('#remarks').val();
			$.post('/SocietyNew/DepositProcessingController',{
				req : 'savedepositprocessoffc',
				depositNumber:depositNumber,
				depositprocessreq:depositprocessreq,
				remarks:remarks,
				memaccno:memaccno,
				paymentnum:paymentnum,
			},function(data){
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.success == "y"){
						alert("REQUEST APPROVE SUCCESSFULLY");
						$('#btnApproval').prop('disabled',true);
					}
					else{
						alert("FAILED TO APPROVE THE REQUEST")
					}
				} catch (e) {
					// TODO: handle exception
					alert(' ' +e.message)
				}
			});
		}
	});

	$('#btnClearAll').click(function() {
		window.location = "/SocietyNew/webapp/screens/Deposits/Depositsprocessing/depositsProcessing.jsp";

	});
});

function DepositProcessReq(deposittype){
	$.post('/SocietyNew/depositProcessing', {
		req : 'getDepositProcessReq', 
		option:'ASSTPROREQ',
	}, function(data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			var error = pop_data.ERROR;
			if(error == 'NO'){
				arr = pop_data.ASSTPROREQ;
				var sel = document.getElementById("depositprocessreq");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp =arr[i].DepositAsstReq;
					var textdesc=temp.split('&')[1];
					var textval=temp.split('&')[0];
					option.text=textdesc;
					option.value=textval;
					if(i%2==0 && (deposittype=="MIS" || deposittype=="RCD")){
					sel.add(option);
					}
					if(deposittype=="FXD"){
						sel.add(option);
					}
				}
				$("#depositprocessreq").trigger("chosen:updated");
				$("#depositprocessreq").prop("disabled" ,false);
/*	if(deposittype=="MIS"){
					
					var sel = document.getElementById("depositprocessreq");
					var options = sel.options;
					for (var i = options.length; i > 0; i--) {
						sel.remove(i);
						if(i%2==0){
							alert(i)
							
						}
					}
			}*/
			}
			else{
				alert(error);
			}
		
		}
		catch (e) {
			// TODO: handle exception
			alert('Exception in getDepositAsst ReqList ' +e.message)
		}
	});
}
function getDepositsType(depositType) {
	$.post('/SocietyNew/deposits',{
		req : 'getDepositsTypes',
	},function (data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			var error = pop_data.ERROR;
			if(error == 'NO'){
				arr = pop_data.DEPOSITS;
				var sel = document.getElementById("depositprocessTypes");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp1 =arr[i].DepositTypeDescription;
					var temp2 =arr[i].DepositTypeCode;
					option.text=temp1			
					if(depositType.trim()==temp2.trim()){
						option.value=temp2;
						sel.add(option);
						$("#depositprocessTypes").val(temp2);
						$("#depositprocessTypes").trigger("chosen:updated").prop("disabled" ,true);	
					}
					option.value=temp2;
					sel.add(option);
				}
				$("#depositprocessTypes").trigger("chosen:updated").prop("disabled" ,true);
			}
		}
		catch (e) {
			// TODO: handle exception
			alert('Exception in getDepositsType ' +e.message)
		}
	});
}

function  getprocessrequest(depositprocerequest){
	$.post('/SocietyNew/depositProcessing', {
		req : 'getDepositProcessReq', 
		option:'ASSTPROREQ',
	}, function(data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			var error = pop_data.ERROR;
			if(error == 'NO'){
				arr = pop_data.ASSTPROREQ;
				var sel = document.getElementById("depositprocessreq");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp =arr[i].DepositAsstReq;
					var textdesc=temp.split('&')[1];
					var textval=temp.split('&')[0];
					option.text=textdesc;
					if(depositprocerequest.trim()==textval.trim()){
						option.value=textval;
						sel.add(option);
						$("#depositprocessreq").val(textval);
						$("#depositprocessreq").trigger("chosen:updated").prop("disabled" ,true);	
					}
					option.value=textval;
					sel.add(option);
				}
				$("#depositprocessreq").trigger("chosen:updated");
				$("#depositprocessreq").prop("disabled" ,false);
			}else{
				alert(error);
			}
		}
		catch (e) {
			// TODO: handle exception
			alert('Exception in getDepositAsst ReqList ' +e.message)
		}
	});
}

function getLoannumbers(memaccno) {
	$.post('/SocietyNew/depositProcessing', {
		req : 'processloanNumbers',
		memaccno:memaccno,
	}, function(data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			var error = pop_data.ERROR;
			if(error == 'NO'){
				arr = pop_data.LOANNUMBERS;
				var sel = document.getElementById("loanrefno");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp =arr[i].LoanNumbers;
					option.text=temp;
					option.value=temp;
					sel.add(option);
				}
				$("#loanrefno").trigger("chosen:updated");
				$("#loanrefno").prop("disabled" ,false);
			}
			else{
				alert(""+error);
			}
		}
		catch (e) {
			// TODO: handle exception
			alert('Exception in process Loan Numbers ' +e.message)
		}
	});
}

function cleardepositrefnum() {
	var sel = document.getElementById("loanrefno");
	var options = sel.options;
	for (var i = options.length; i > 0; i--) {
		sel.remove(i);
	}
}

function getDepositref(refnum,memaccno) {

	$.post('/SocietyNew/depositProcessing', {
		req : 'processloanNumbers',
		memaccno:memaccno,
	}, function(data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			var error = pop_data.ERROR;
			if(error == 'NO'){
				arr = pop_data.LOANNUMBERS;
				var sel = document.getElementById("loanrefno");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp =arr[i].LoanNumbers;
					if(refnum.trim()==temp){
						option.value=temp;
						sel.add(option);
						$("#loanrefno").val(temp);
						$("#loanrefno").trigger("chosen:updated").prop("disabled" ,true);
					}
					option.text=temp;
					option.value=temp;
					sel.add(option);
				}
				$("#loanrefno").trigger("chosen:updated");
				$("#loanrefno").prop("disabled" ,false);
			}
			else{
				alert(""+error);
			}
		}
		catch (e) {
			// TODO: handle exception
			alert('Exception in process Loan Numbers ' +e.message)
		}
	});
}
function getpaymentnumber(memaccno,depositnum) {
	$.post('/SocietyNew/DepositProcessingController', {
		req : 'processbillsnumber',
		memaccno:memaccno,
		depositnum:depositnum,
	}, function(data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.PAYMENTNUMBER;
			$('#paymentnum').val(arr)
		}
		catch (e) {
			// TODO: handle exception
			alert('Exception in getBill  Number ' +e.message)
		}
	});
}