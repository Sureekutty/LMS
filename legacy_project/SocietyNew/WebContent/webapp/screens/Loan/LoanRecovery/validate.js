$(document).ready(function(){
	
	$("#receiptno").val('');
	$("#principalamt,#interestamt").val('');
	
	
	$("#modeOfPay").val("").selected;
	$("#modeOfPay").trigger("chosen:updated");
	
	
	
	$('#btnClearAll').click(function() {
		onload();
		$("#empCode").prop('disabled',false).trigger("chosen:updated");
	});
	
	$("#empCode").change(function() {	
	
		$("#receiptno").val('');
		$("#principalamt,#interestamt").val('');
		
		
	var empCode = this.value;
	var loanAccno=empCode.split('-')[0];
	$("#loanaccNumber").text(loanAccno);

		$.post('/SocietyNew/ApplicationForLoan',{
			req : 'getsanctionloandata',
			loanAccno :loanAccno,
	},function (data) {
		
		try {
			
			var pop_data = eval("("+data+")");

			$("#loansancamt").text(pop_data.SANCLOANDETAILS[0].LoanSanctionAmount);
			$("#noofinstallments").text(pop_data.SANCLOANDETAILS[0].NoOfInstallments);
			$("#loansanctiondate").text(pop_data.SANCLOANDETAILS[0].LoanSanctionDate);
			$("#interestrate").text(pop_data.SANCLOANDETAILS[0].InterestRate);
			$("#loanappdate").text(pop_data.SANCLOANDETAILS[0].Opendate);
			$("#noofinstallpaid").text(pop_data.SANCLOANDETAILS[0].installmentspaid);
			$("#Loantype").val(pop_data.SANCLOANDETAILS[0].loantype);
			//$("#receiptno").val(pop_data.SANCLOANDETAILS[0].Receiptno);
		
			//$("#principalamt").val(pop_data.SANCLOANDETAILS[0].principleamount);
			//$("#interestamt").val(pop_data.SANCLOANDETAILS[0].intrestamount);
			var pribal=pop_data.SANCLOANDETAILS[0].LoanSanctionAmount - pop_data.SANCLOANDETAILS[0].principleamount;
			
			$("#principalbal").text(pribal);
			
			
			//$("#initreceiptno").val(pop_data.SANCLOANDETAILS[0].initreceiptno);
			var mop=pop_data.SANCLOANDETAILS[0].Modeofpay;
			
			$("#modeOfPay").val(mop).selected;
			$("#modeOfPay").trigger("chosen:updated");

			}catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeLoanDetails ' +e.message)
			}
		});
	
		
		
	});
	
	
	$("#principalamt").change(function() {	
		var opendate=$('#loanappdate').text();
		var memAccNo = $("#empCode").val();
		var loantype = $("#Loantype").val();
		var principleamount=Number($('#principalbal').text());
		//alert(" Principal Amount "+principleamount+" opendate "+opendate)
		if(principleamount=='' || principleamount==undefined){
			alert("Enter Principal Amount")
			return;
		}
		
		getInterestRate(opendate,memAccNo,loantype,principleamount)
	});
	

	 
});

	
 
	
 

