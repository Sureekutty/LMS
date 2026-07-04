$(document).ready(function(){

	/*	clearRefNuList = function() {
		var sel = document.getElementById("memCode");
		  var option=document.createElement("option");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}

		var sel = document.getElementById("appNumber");
		var option=document.createElement("option");
		var options=sel.options;

		for(var i=options.length-1;i>0;i--){
			sel.remove(i);
		}
	}*/
	/*
	clearRefNuList = function() {
		var sel = document.getElementById("appNumber");
		var option=document.createElement("appNumber");
		var options=sel.options;

		for(var i=options.length-1;i>0;i--){
			sel.remove(i);
		}	
	}
	 */
	$("#appNumber").prop('disabled',true);
	cleargetReceiptsList = function() {
		var sel = document.getElementById("purpose");
		var option=document.createElement("option");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}	
	}
	onload = function(){
		//clearRefNuList();
		$(':input:not([type=button])').val('');
		$('#sharesTr,#loanRefNoTr').hide(); 
		$("#recieptDate,#Amount,#btnSave").prop("disabled" ,true);
		$("#purpose,#modeOfPay").prop('disabled',true).trigger("chosen:updated");

	}
	onload();

	callThis = function() {
		$("#appNumber").val("");
		$("#modeOfPay").val("");
		$("#purpose").prop('disabled',false).trigger("chosen:updated");
		$("#modeOfPay").prop('disabled',true).trigger("chosen:updated");
		$("#appNumber").prop('disabled',true).trigger("chosen:updated");
		$('#recieptDate,#Amount').val('');
		$("#recieptDate,#Amount").prop("disabled" ,true);
		$('#sharesTr,#loanRefNoTr').hide();

	}

	$('#btnClearAll').click(function() {
		window.location="/SocietyNew/webapp/screens/CashBook/Receipts/Receipts.jsp"
			/*callThis();
		$("#ReceiptNo").text("");
		$("#memCode,#purpose,#modeOfPay").val("");
		$("#purpose,#modeOfPay").prop('disabled',true).trigger("chosen:updated");
		$("#memCode").prop('disabled',false).trigger("chosen:updated");

		$('#ledgerLink').text("");*/
	});


	$("#memCode").change(function() {

		callThis();
		//clearRefNuList();
		var memCode = (this.value).split(",")[0];
		if(memCode == ''){
			alert('Select employee ');
			return;
		}
	});
	$('#purpose').change(function() {
		$("#appNumber").val("");
		$("#appNumber").prop('disabled',false).trigger("chosen:updated");
		$("#modeOfPay").prop('disabled',false).trigger("chosen:updated");
		$('#recieptDate').prop('disabled',false);
		$("#recieptMonth").prop('disabled',false).trigger("chosen:updated");
		$("#recieptyear").prop('disabled',false).trigger("chosen:updated");
		$('#Amount,#prvAmount').prop('disabled',false);
		$('#SaveBtn').prop('disabled',false);	
		$('#Remarks').prop('disabled',true);

		var purpose = this.value;
		if(purpose == ''){
			alert('Select purpose');
			return;
		}
		var memCode =($('#memCode').val()).split(",")[0];

		if(purpose == 'D08' || purpose == 'M03' ||purpose == 'D20'){
			$("#monthfield").show();
		}else{
			$("#monthfield").hide();
		}

		if(purpose == 'D08' ||purpose == 'D20'){
			$("#appNumber").prop('disabled',false).trigger("chosen:updated");
		}
		if(purpose == 'D08' ||purpose == 'D20'){
			$("#appNumber").prop('disabled',false).trigger("chosen:updated");
		}
		if(purpose == "L25" || purpose == "L26" || purpose == "L27" || purpose == "L30" || purpose == "L31" || purpose == "L32"||purpose == 'L34' ||purpose=='L34'){
				$("#appNumber").prop('disabled',false).trigger("chosen:updated");

			//getLoanRefNumber(memCode,purpose);
		}else {
			var sel = document.getElementById("appNumber");
			var option=document.createElement("option");
			var options=sel.options;
			for(var i=options.length-1;i>0;i--){
				sel.remove(i);
			}
			$("#appNumber").val("");
			$("#appNumber").prop('disabled',true).trigger("chosen:updated");
		}
		$('#referenceNumber').text(memCode);

	});
	$('#memCode').change(function(){
		$("#appNumber").val("");
		if($('#modeOfPay').val()=="")callThis();
		if($('#modeOfPay').val()!="")callThis();
		if ($('#Amount').val()!="")callThis();
		if($('#Amount').val()=="")callThis();
		if($('#recieptDate').val()!="")callThis();
		if($('#recieptDate').val()=="")callThis();
		cleargetReceiptsList()
		$('#purpose').val('');
		if(this.value == ''||this.value  == null)
		{
			$("#purpose").prop('disabled',true).trigger("chosen:updated")
		}
		else{
			getReceipts();

			$("#purpose").prop('disabled',false).trigger("chosen:updated")
		}
	})


	$('#purpose').change(function(){

		//$("#appNumber").val("");
		var memAccNo = $('#memCode').val();
		var code=((this.value).split("-"))[0];

		/*      if(code=="M03"){
				var str = "Thrift Ledger";
			    document.getElementById("Link").innerHTML = str;
			    $('#Link').show();
			}else{
				$('#Link').hide();
			}*/
		getMemberInfo(memAccNo,code);

		$("#modeOfPay,#recieptDate,#Amount,#prvAmount").val("");
		$("#recieptDate,#Amount,#prvAmount,#Remarks").prop("disabled" ,true); 
		if(this.value == ''||this.value  == null)
		{
			$("#modeOfPay").prop('disabled',true).trigger("chosen:updated");
		}
		else{
			$("#modeOfPay").prop('disabled',false).trigger("chosen:updated");
		}

		var code=((this.value).split("-"))[0];
		if(code=="M08")
		{
			$('#sharesTr').show();
			$('#NoOfShares').prop('disabled',true);
		}
		else{
			$('#sharesTr').hide();
		}
		if(code=="L24"||code=="L25"||code=="L26"||code=="L27"||code=="L29"||code=="L30"||code=="L31"||code=="L32"||code=="L34"||code=="L35")
		{
			var str = "Loan Ledger";
			document.getElementById("Link").innerHTML = str;
			$('#Link').show();
		}
		else {
			$('#Link').show();
		}

		if(code=="M01"||code=="M02"||code=="M06"||code=="M08"||code=="M12"){

			var str = "View Member";
			document.getElementById("Link").innerHTML = str;
			$('#Link').show();
		}else{
			$('#Link').hide();
		}
	});

	$('#modeOfPay').change(function(){
		$("#recieptDate").val("");

		if(this.value  == null||this.value  == "")
		{
			$("#recieptDate").prop('disabled',true);
		}
		else{
			$("#recieptDate").prop('disabled',false);
		}
	})

	$('#recieptDate').change(function(){

		var purpose=$('#purpose').val();
		if(purpose == 'D08' ||purpose == 'D20'){
		}
		else{
			$("#Amount").val("");

			$("#Amount").prop('disabled',false);
		}

	});

	$('#appNumber').change(function() {
		var purpose = $('#purpose').val();
		if(purpose == ''){
			alert('Select purpose');
			return;
		}

		if(purpose == 'L35' || purpose == 'L34'){
			var refNum = $('#appNumber').val();
			//alert(refNum+" "+refNum.split("~")[1])
			 var prvAmnt=refNum.split("~")[1];
			 $("#prvAmount").val(prvAmnt);
		}else{
			
			 $("#prvAmount").val('');
		}
		 
		});


	/*$('#Amount').change(function() {
		// verifyAmount();
	});*/

	/*	verifyAmount = function() {
		 var Amount = parseInt($('#Amount').val(), 10);
			var refNum = $('#appNumber').val();
			var orgAmt = parseInt(refNum.split("-")[1], 10);
			//alert(refNum.split("-")[1])
			if(Amount != orgAmt){
				alert('Amount should be equal to ' + orgAmt);
				$('#btnSave').prop('disabled',true);
				return false;
			}
			$('#btnSave').prop('disabled',false);
			return true;
	}*/
	//getReceipts();

	validateSave = function() {
		var memCode = ($("#memCode").val()).split(",")[0];
		if(memCode == 'Select'){
			alert('Select employee ');
			return false;
		}


		var purpose = $('#purpose').val();
		if(purpose == 'Select'){
			alert('Select purpose');
			return false;
		}

		var recieptDate = $('#recieptDate').val();
		if(recieptDate==undefined||recieptDate==""||recieptDate==null){
			alert('Select Date');
			return false;
		}

		var amount = parseInt($('#Amount').val(), 10);
		if(amount == 0 || isNaN(amount.toString())){
			alert('Enter Amount ');
			return false;
		}
		return true;
	} 

	$('#Amount').change(function(){
		var date = new Date();
		var currDate=date.getFullYear();					//$('#currentDate').val()
		var year=Math.abs(currDate-joiningdate.split("/")[2]);	
		var amount=Number($('#Amount').val());		
		var code=$('#purpose').val();	
		//Share Capital
		if(code=="M06"){						
			var prvAmount = Number($('#prvAmount').val());
			elgAmount=7500;
			if((prvAmount+amount)<=elgAmount){
				if(amount>=7000){
					if(year>=8)
						$('#Remarks').prop('disabled',false);					
					else{
						$('#Remarks').prop('disabled',true);
						alert("minimum 8 years of service is required");
						return;
					}
				}
				if(amount<elgAmount)
					$('#Remarks').prop('disabled',false);				
			}
			else{
				$('#Remarks').prop('disabled',true);
				alert("Share Capital can not be more than "+elgAmount);
				return;
			}
		}
		//Loan amounts
		if(code=="L45" || code=="L46" || code=="L26" || code=="L31"){						
			var prvAmount =Number($('#prvAmount').val());
			elgAmount=3000000;
			if( amount<=prvAmount){
			if((prvAmount+amount)<=elgAmount){
				if(amount <= elgAmount)
					$('#Remarks').prop('disabled',false);					
				else
					$('#Remarks').prop('disabled',true);
			}
			else{
				$('#Remarks').prop('disabled',true);
				alert("Amount can not be more than "+elgAmount);
				return;
			}	
			}
			else{
				$('#Remarks').prop('disabled',true);
				$('#Amount').val('');
				alert("Amount should not be more than previous balance "+prvAmount);
				return;
			}
		}
		//Thrift Deposit
		if(code=="M43"){						
			var prvAmount = Number($('#prvAmount').val());
			elgAmount=3500000;
			if((prvAmount+amount)<=elgAmount)				
				$('#Remarks').prop('disabled',false);				
			else{
				$('#Remarks').prop('disabled',true);
				alert("Thrift amount can not be more than "+elgAmount);
				return;
			}	
		}
		//FDL Loan
		if(code=="L35" || code=="L34"){
			elgAmount=Number($('#prvAmount').val());
			if((amount)<=elgAmount)				
				$('#Remarks').prop('disabled',false);				
			else{
				$('#Remarks').prop('disabled',true);
				alert("FDL payment amount can not be more than "+elgAmount);
				return;
			}	
		}
		else{
			$('#Remarks').prop('disabled',false);
		}
	});	
});			//end of document.ready function

