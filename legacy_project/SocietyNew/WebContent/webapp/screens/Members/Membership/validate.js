$(document).ready(function() {
	$('#thriftAmount').val(0);
	
	$('#phoneNumber,#bankNumber,#typeOfRelation,#aadharNumber,#sharesallot,#thriftSubAmt').change(function() {
		var id = this.id ;
		if(id == 'phoneNumber'){
			return validatePhoneNumber(this.value);
			
		}
		if(id == 'sharesallot'){
			var noOfShares=parseInt(this.value, 10);
			return validateSharesDetails(noOfShares);
			
		}
		
		if(id == 'thriftSubAmt'){
			
			if(this.value % 100 != 0 ){
				alert('Amount should be multiples of 100 ');
				this.value = '';
				return;
			}
			if(this.value < 200 ){
				alert('Amount should be equal or greater than 500');
				this.value = '';
				return;
			}
		}
		

		if(id == 'bankNumber'){
			validateBankAccNumber(this.value);
		}
		if(id == 'typeOfRelation'){
			validateRelationWithMember(this.value);
		}
		if(id == 'aadharNumber'){
			validateAadharNumber(this.value);
		}
	});
	
	validateSharesDetails = function(noOfShares) {
		
		if(noOfShares == '' || noOfShares == undefined || isNaN(noOfShares)){
			alert('Enter shares');
			$('#shareamt,#sharesallot').val('');
			return;
		}
		
		if(noOfShares < minimumShares){
			alert('Member Should have minimum '+minimumShares+' shares ');
			$('#shareamt,#sharesallot').val('');
			return;
		}
		if(noOfShares < 50){
			alert('Minimum Share is 50 ');
			$('#sharesallot').val('');
			return;
		}
		if(noOfShares > 600){
			alert('Maximum Share is 600 ');
			$('#sharesallot').val('');
			return;
		}
		$('#shareamt').val(noOfShares*sharePrice);
		$('#btnSave').prop('disabled',false);
		return true;
	}	
});

function validateAadharNumber(aadharNo) {
	if(aadharNo == '-'){
		return true;
	}
	
	if(aadharNo.length != 12){
		alert('Aadhar Number length should be 12 digits');
		return; 
	}
	return true;
}

function validatePhoneNumber(phoneNumber) {
	if(phoneNumber.length != 10 && phoneNumber.length != 12){
		alert('Phone Number Length Should Be 10 or 12 Digits');
		return; 
	}
	return true;
	
}


function validateRelationWithMember(memRelation)
{
	if(memRelation == 'select'){
		alert('Select Relation With Member');
		$('#relationWithMember').val('');
		return false;
	}
	if(memRelation=="other")
		{
		$('#relationWithMember').prop('disabled',false);
		$('#relationWithMember').show();
		$('#relationWithMember').val('');
		}
	else{
		$('#relationWithMember').val(memRelation);
	//	$('#relationWithMember').hide();
	}
	var relWithMeme = $('#relationWithMember').val();
	if(relWithMeme == '' ){
		alert('Select Relation With Member');
		return false;
	}
	return true;
}

function validateBankAccNumber(bankAccountNumber) {
	if(bankAccountNumber.length != 11 || bankAccountNumber == ""){
		alert('Bank Account Number Length Should Be 11 Digits');
		return;
	}
	return true;
	
}
function validateIFSCCode(ifscCode) {
	if(ifscCode == "" || ifscCode == undefined){
		alert('Enter IFSC Code Number');
		return ;
	}
	return true;
}

function validateSave() {
	
	/*var mailId = $('#mailId').val();
	if(mailId == '' || mailId == undefined){
		alert('Enter MailId');
		return;
	}
	var panNumber = $('#panNumber').val();
	if(panNumber == '' || panNumber == undefined){
		alert('Enter Pan Number');
		return;
	}
	
	var phoneNumber = $('#phoneNumber').val();
	if(!validatePhoneNumber(phoneNumber)){
		return false;
	}
		
	var aadharNumber = $('#aadharNumber').val();
	if(!validateAadharNumber(aadharNumber)){
		return false;
	}*/
	var careOf = $('#careOf').val();
	if(careOf == '' || careOf == undefined){
		alert('Enter Parent or Husband number');
		return;
	}
	
var sharesallot = $('#sharesallot').val();
	
	if(sharesallot == '' || sharesallot== undefined){
		alert('Enter Shares Requested');
		return;
	}
var thriftSubAmt = $('#thriftSubAmt').val();
	
	if(thriftSubAmt == '' || thriftSubAmt== undefined){
		alert('Enter thriftSubscription amount');
		return;
	}
	
var thriftAmount = $('#thriftAmount').val();
	
	if(thriftAmount == '' || thriftAmount== undefined){
		alert('Enter thriftAmount');
		return;
	}

	var shareamt = $('#shareamt').val();
	if(shareamt == '' || shareamt== undefined){
		alert('Enter Share Amount');
		return;
	}
	
	
	
	var grid=Sigma.$grid("grid");
	grid.endEdit();
	
	var grid1=Sigma.$grid("grid1");
	grid1.endEdit();

	var grid2=Sigma.$grid("gridbank");
	grid2.endEdit();
	
	return true;
}


