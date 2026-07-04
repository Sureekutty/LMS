$(document).ready(function() {
	
	$('#depositprocessTypes').change(function() {
		var depositprocessTypes = this.value;
		if(depositprocessTypes == 'Select'){
			alert('Select deposit process types');
			return;
		}
		$('#memberDetails').text('');
		$('#remarks').val('');		
		loadDepositNumber(depositprocessTypes);
		$('#depositNumber').prop('disabled',false);
	});
	
	
	$('#depositprocessreq').change(function() {
		var depositproreq = this.value;		
		if(depositproreq.includes("ADJ")){			
			$('#adjloanref').show();
			$('#adjloanamt').show();
		}else{
			$('#adjloanref').hide();
			$('#adjloanamt').hide();
		}		
	});		
	
	
	$('#processDate').change(function() {
		var processDate = this.value;
		var depositprocessreq = $('#depositprocessreq').val();
		
		/*if(depositproreq.includes("ADJ")){			
			$('#adjloanref').show();
			$('#adjloanamt').show();
		}else{
			$('#adjloanref').hide();
			$('#adjloanamt').hide();
		}	*/	
		var depositprocesstypes = $('#depositprocessTypes').val();
		var depositNumber = $('#depositNumber').val();
		
		$.post('/SocietyNew/DepositProcessingController',{
			req : 'getClosingBal',
			depositprocesstypes:depositprocesstypes,
			depositNumber:depositNumber,
			processDate:processDate,
		},function(data){
			try {
				var pop_data = eval("("+data+")");
				if(pop_data.success == "y"){
					if(depositprocessreq =="SCLOSE_INIT")
						$('#settleAmnt').val(pop_data.bal);
					else
						$('#settleAmnt').val($('#maturityamount').text());
				}
				else{
					alert("FAILED TO FETCH CLOSING BALANCE")
				}
			} catch (e) {
				// TODO: handle exception
				alert(' ' +e.message)
			}
		});
	});		
})


validateSave = function() {	
	var depositprocesstypes = $('#depositprocessTypes').val();	
	if(depositprocesstypes == ''|| depositprocesstypes == undefined){
		alert('Select Deposit Process Type');
		return false;
	}	
	var depositNumber = $('#depositNumber').val();
	if(depositNumber == ''|| depositNumber == undefined){
		alert('Empty Deposit Number');
		return false;
	}	
	var depositprocessreq = $('#depositprocessreq').val();
	if(depositprocessreq == ''|| depositprocessreq == undefined){
		alert('Select Deposit Process Request');
		return false;
	}	
	var remarks = $('#remarks').val();
	if(remarks == ''|| remarks == undefined){
		alert('Enter Remarks');
		return false;
	}
	var depositprocessreq = $('#depositprocessreq').val();	
	if(depositprocessreq.includes("ADJ")){
		var loanrefno = $('#loanrefno').val();
		if(loanrefno == ''|| loanrefno == undefined){
			alert('Select Loan Reference Number');
			return false;
	}		
	var loanadjamt = $('#loanadjamt').val();
	if(loanadjamt == ''|| loanadjamt == undefined){
		alert('Enter Loan Adjustment Amount');
		return false;
	}	
	var loanrefno = $('#loanrefno').val();
	var maturityamt = $('#maturityamount').text();	
	if(depositprocesstypes!='MIS'){
	if(parseInt(loanadjamt)>=parseInt(maturityamt)){
		alert("Loan Adjustment Amount should be less then Maturity Amount");
		return false;
	}
	}
	}else{
		$('#loanadjamt').val("");
		$('#loanrefno').val("");
	}	
	return true
} 



