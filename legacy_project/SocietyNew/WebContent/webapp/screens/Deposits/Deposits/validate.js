$(document).ready(function(){


	$('#btnClearAll').click(function() {
		window.location="/SocietyNew/webapp/screens/Deposits/Deposits/Deposits.jsp";
		/*document.getElementById("depositNumber").innerHTML = "";
		document.getElementById("succalert").innerHTML = "";
		onload();
		$("#deposit").prop('disabled',true).trigger("chosen:updated");
		$("#empCode").prop('disabled',false).trigger("chosen:updated");*/
	});

	$("#empCode").change(function() {	
		cleardepositList();
		var empCode = this.value;
		if(empCode == ''){
			alert('Select employee ');
			return;
		}
		$("#deposit").prop('disabled',false).trigger("chosen:updated");
		getDepositsTypes();
	});
	/*	$('#empCode').change(function(){

		  $("#deposit,#depositDate,#Amount,#duration,#interest").val("");
			if(this.value  == null||this.value  == "")
			{
				$("#deposit").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#deposit").prop('disabled',false).trigger("chosen:updated");
			}
	 })*/

	$('#deposit').change(function(){
		$("#depositDate,#Amount,#duration,#interest,#fixDeposits1").val("");
		$("#Amount,#duration,#interest").prop('disabled',true).trigger("chosen:updated");
		if(this.value  == null||this.value  == "")
			$("#depositDate").prop('disabled',true);
		else
			$("#depositDate").prop('disabled',false);
		var deposit = this.value;
		if(deposit == 'Select'){
			alert('Select deposit');
			return;
		}
		$('#depositDate').val(currDate);
		if(deposit =='SRB' ){
			$('#depositDate,#Amount,#duration,#interest,#nomineeRefNu,#remarks,#btnSave').prop('disabled',false).trigger("chosen:updated");
			//checkInDeposits(deposit);
		}
		else{
			getRulesOfDeposits(deposit);
			$('#depositDate,#Amount,#duration,#interest,#nomineeRefNu,#remarks,#btnSave').prop('disabled',false).trigger("chosen:updated");
		}
	})

	$('#depositDate').change(function(){
		$("#interest").prop('disabled',true).trigger("chosen:updated");
		if(this.value  == null||this.value  == "")
			$("#Amount").prop('disabled',true).trigger("chosen:updated");
		else 
			$("#Amount").prop('disabled',false).trigger("chosen:updated");
	})

	$('#Amount').change(function(){
		
		$("#duration,#interest").val("");
		var depositDate = $('#depositDate').val();
		$("#interest").prop('disabled',true).trigger("chosen:updated");
		if(this.value  == null||this.value  == "")
			$("#duration").prop('disabled',true);
		else
			$("#duration").prop('disabled',false);

		var Amount = parseInt(this.value, 10);
		var deposit = $('#deposit').val();
		// commented by pn on 24/01/2025 informed by Society
		/*if(Amount % 100 != 0){       
			alert('Amount should be multiples of 100');
			this.value = '';
			return;
		}*/
		if(deposit == 'MIS'){
			$('#mtDate').show();
			$('#mtAmount').show();
			if(Amount < minAmount){
				alert(minDepositDuration+' is ' + minAmount );
				this.value = '';
				return ;
			}
			if(Amount % multipleFactorValue != 0){
				alert(multipleFactorDesc + ' ' +multipleFactorValue);
				this.value = '';
				return;
			}
			$('#duration').val(ruleValue);
			getInterestRate(deposit,ruleValue,depositDate);
			$('#nomineeRefNu').prop('disabled',false).trigger("chosen:updated");
			var empCode = $('#empCode').val();
			$('#maturityAmnt').val(Amount);
			loadNomineeRefNumbers(empCode);
		}

		if(deposit == 'SRB'){
			$('#duration').val('NA');
			getInterestRate(deposit,null,depositDate);
			$('#nomineeRefNu').prop('disabled',false).trigger("chosen:updated");
			var empCode = $('#empCode').val();
			loadNomineeRefNumbers(empCode);
		}
		$('#remarks').prop('disabled',false);
	});

	$('#duration').change(function(){
		$('#mtDate').show();
		$('#mtAmount').show();
		$("#interest").val("").prop('disabled',true);
		var duration = this.value;
		var deposit = $('#deposit').val();
		var depositDate = $('#depositDate').val();
		var duration  = parseInt(duration);
		if(deposit == 'FXD' || deposit == 'RCD'){
			maturityDetail(empCode,deposit,duration);
			if(duration < minDepositDuration){
				alert(ruleDescriptionForMin + ' is ' + minDepositDuration + ' months');
				this.value = '';
				return;
			}
			if(duration > maxDepositDuration){
				alert(ruleDescriptionForMax+ ' is ' + maxDepositDuration + ' months');
				this.value = '';
				return;
			}
		}
		if(deposit == 'MIS'){
			if(duration < ruleValue){
				alert(durationDescription + ' is ' + ruleValue + ' months');
				this.value = '';
				return;
			}
		}
		/*var depositDate = $('#depositDate').val();
		depositDate=depositDate.split('/')[1]+"/"+depositDate.split('/')[0]+"/"+depositDate.split('/')[2];
		//maturity date calculation start
		var maturityDate = new Date(depositDate);
		alert(Number(maturityDate.getMonth())+duration+1)
		maturityDate.setMonth((Number(maturityDate.getMonth())+duration+1));
		//alert(maturityDate+" -- "+(maturityDate.getMonth()+2))
		var month=(maturityDate.getMonth()+1);
		if(month>12){
			month=1;
		}
		var day=(maturityDate.getDate());
		var year=maturityDate.getFullYear();
		maturityDate="01"+"/"+(month>=10?month:"0"+month)+"/"+year;		
		$('#maturityDate').val(maturityDate);		
		//maturity date calculation start end
*/		getInterestRate(deposit,duration,depositDate);
		$('#nomineeRefNu').prop('disabled',false).trigger("chosen:updated");
		$('#remarks').prop('disabled',false);
		var empCode = $('#empCode').val();
		loadNomineeRefNumbers(empCode);
		
	});

});


validateSave = function() {
	var empCode = $("#empCode").val();
	if(empCode == 'Select'){
		alert('Select member');
		return false;
	}
	var deposit = $('#deposit').val();
	if(deposit == 'Select'){
		alert('Select deposit');
		return false;
	}
	var depositDate = $('#depositDate').val();
	var amount = parseInt($('#Amount').val(), 10);
	if(amount == 0 || amount == undefined){
		alert('Enter amount ');
		return false;
	}
	var amount =$('#Amount').val();
	if(amount == 0 || amount == undefined ||amount=='' ){
		alert('Enter amount ');
		return false;
	}
	var amount = parseInt($('#Amount').val(), 10);
	if(amount == 0 || amount == undefined ){
		alert('Enter amount ');
		return false;
	}
	var duration = $('#duration').val();
	if(duration == '' || duration == undefined){
		alert('Enter duration of the deposits');
		return false;
	}
//	var interest = $('#interest').val();
//	var remarks = $('#remarks').val();
	return true
} 



