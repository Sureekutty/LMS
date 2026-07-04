$(document).ready(function(){
	
	var currdate=$('#currDate').val();
	$('#payvoucherDate').val(currdate);
	$('#chequeDate').val(currdate);
	
	
	$('#btnClearAll').click(function() {
		
		
		window.location="/SocietyNew/webapp/screens/Payments/PaymentJvoucher/PaymentJvoucher.jsp";

});

});	
	validateSave = function() {
		
		var modeofpay = $("#modeofpay").val();
		if(modeofpay == ''){
			alert('Select Mode Of Payment');
			return false;
		}
		
		if(modeofpay=='bank'){
			var accountno=$('#accountno').val();
			if(accountno.trim()==''){
				alert("Enter Account Number")
				return false;
			}
		}else{
			var Chequeno=$('#Chequeno').val();
			if(Chequeno.trim()==''){
				alert("Enter Cheque Number")
				return false;
			}
			var chequeDate=$('#chequeDate').val();
			if(chequeDate.trim()==''){
				alert("Select Cheque Date")
				return false;
			}
		}
		
		var remarks = $("#remarks").val();
		if(remarks.trim() == ''){
			alert('Enter Remarks');
			return false;
		}
		return true
	} 
	
 

