$(document).ready(function() {
	var loantypee=$('#loantypee').val();
     if(loantypee!='null'){
	 var fdNumber = '';
	 var fdAmount = '';
	 var empcode=$('#empcode').val();
	 var memAccNo=$('#memAccNo').val();
	 var fdnum=$('#fdnum').val();
	
	 if(loantypee == 'FDL'){
		$('#FDAmount').val();
		clearFDNumbersList();
		getFDNumbersload(fdnum,memAccNo);
		$('#loanAmount,#installmentNumber').prop('disabled',true);
	}
	
	if(loantypee == 'LTL'){	
		getNoOfInst();
		showAllFields();
		$('#thrfiAvailableAmount').val(thriftAvailableAmount);
	}
	
	if(loantypee == 'LTL' || loantypee == 'EXL'){
		//checkInLoan(loantypee);
		calculateLoanEligibilityAmount(memAccNo,loantypee,fdNumber,fdAmount);
		MinLoanEligibilyAmount(loantypee);
		$('#loanAmount,#installmentNumber').prop('disabled',false);
	}
	   getRulesOfLoans(loantypee);	
	
	$('#empCode').change(function() {
	   window.location="/SocietyNew/webapp/screens/Loan/LoanApplication/loan.jsp";
	});
	
	$('#FDNumbers').change(function() {
		var fdAmount = this.value;
		fdAmount = fdAmount.split("~")[1]
		$('#FDAmount').val(fdAmount);
		var fdNumber = '';
		var memAccNo=$('#memAccNo').val();
		calculateLoanEligibilityAmount(memAccNo,'FDL',fdNumber,fdAmount) 
	});
	
	    var loanAmount=$('#loanamount').val();
		clearSuretyLists();
		var minLoanEligAmt=parseInt($('#MinLoanEligibilyAmount').val());
		$('#installmentNumber').val('');
		$('#intsallmentAmount').text('');
		$('#thriftDedAmount').val('');
		var memAccNo =$('#memAccNo').val();
		var loanType =$('#loantypee').val();
		var loanAmount =loanAmount;
	
	if(loanType == 'LTL'){
        var surity1  = $('#surity1').val();
		var surity2  = $('#surity2').val();
		var surity3  = $('#surity3').val();
		var memAccNo  = $('#memAccNo').val();
		
		suritydetails4(memAccNo,surity1);
		suritydetails5(surity1,surity2);
		suritydetails6(surity2,surity3);
	}
	}

$('#loanType').change(function() {
	clearOnChangeOfLoanType();
	var fdNumber = '';
	var fdAmount = '';
	
	clearSuretyLists();
	$('#loanAmount,#installmentNumber,#loanApplicationDate,#Remarks').prop('disabled',false);
	$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1,#FDNumbers,#loanType').prop('disabled',false);
	$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1,#FDNumbers,#loanType').trigger("chosen:updated");
	var loanType = this.value;
	getinterest(loanType)
	var empCode = $('#empCode').val();
	
	if(loanType == ''){
		alert('Select loan type');
		return;
	}
	
	if(loanType == 'EXL'){
		hideAllFields();
		hideFDLoanDiv();
		showEXPLoanDiv();
	}
	
	if(loanType == 'FDL'){
		$('#hfd,#hfd1').hide();
		$('#FDAmount').val();
		clearFDNumbersList();
		hideAllFields();
		hideEXPLoanDiv();
		showFDLoanDiv();
		getFDNumbers(empCode);
		$('#loanAmount,#installmentNumber').prop('disabled',true);
	}else{
		$('#hfd,#hfd1,#hfd2,#hfd3,#hfd4,#hfd5').show();
	}
	
	if(loanType == 'LTL'){	
		getNoOfInst();
		showAllFields();
		$('#thrfiAvailableAmount').val(thriftAvailableAmount);
		//calculateLoanEligibilityAmount(empCode,loanType,fdNumber,fdAmount);
		hideEXPLoanDiv();
		hideFDLoanDiv();
	}
	
	if(loanType == 'LTL' || loanType == 'EXL'){
		//checkInLoan(loanType);
		calculateLoanEligibilityAmount(empCode,loanType,fdNumber,fdAmount);
		MinLoanEligibilyAmount(loanType);
		$('#loanAmount,#installmentNumber').prop('disabled',false);
	}
	
	getRulesOfLoans(loanType);	
	
});


var loantypee=$('#loantypee').val();
if(loantypee=='null'){
$('#FDNumbers').change(function() {
	$('#interest').val(interest);
	var prvInt = $('#interest').val();
	var fdAmount = this.value;
	var fdInt=fdAmount.split("~")[2];
	fdAmount = fdAmount.split("~")[1]
	$('#FDAmount').val(fdAmount);	
	$('#interest').val(Number(prvInt)+Number(fdInt));
	var fdNumber = '';
	var empCode = $('#empCode').val();
	calculateLoanEligibilityAmount(empCode,'FDL',fdNumber,fdAmount) 
});
}

$('#loanAmount').change(function() {
	
	var loanAmount = parseInt($('#loanAmount').val());
	var minLoanEligAmt=parseInt($('#MinLoanEligibilyAmount').val());
	var prvAmt=parseInt($('#prvLoan').val());
	var loanBalance=parseInt($('#loanBalance').val());
	var totalamount = loanAmount;
	if(loanAmount>eligibleAmount){
		$('#loanAmount').val(0);
		alert("not possible to request loan more than "+loanBalance);
		return;
	}
	if(loanAmount<prvAmt){
		$('#loanAmount').val(0);
		alert("loan amount should be more than previous loan "+prvAmt);
		return;
	}
	
	var thriftedAmount=0;
	$('#installmentNumber').val('');
	$('#intsallmentAmount').text('');
	var memAccNo = $('#empCode').val();
	if(memAccNo == '' || memAccNo == undefined){
		alert('Select member');
		this.value = '';
		return;
		}
	
		var loanType = $('#loanType').val();
		if(loanType == ''){
			alert('Select loan type');
			this.value = '';
			return;
		}
		
		//var loanAmount = parseInt(this.value, 10);
		
		if(serviceMonths<84) // 84 means 7 years
			noOfInstallment=serviceMonths;
		else
			noOfInstallment=noOfInstallment;
		
		$('#installmentNumber').val(noOfInstallment);
		changeInstallmentAmount();
		
		if(loanType == 'FDL'){							// For FD loan
		var fdNumbers = $('#FDNumbers').val();
		 $('#chequeAmount').val(Math.abs(loanAmount));
		if(fdNumbers == undefined || fdNumbers == ''){
			alert('Select Fixed deposit number');
			return;
			}
		    }
		if(loanType == 'EXL'){							// For FD loan
			expressSuritydetails(memAccNo);
		}
		
		var previousLoanOutstanding = 0;
		var loanEligibleAmount = parseInt($('#loanEligibleAmount').val(), 10);
		//alert("loan-prv "+Math.abs(loanAmount-prvAmt))
		 $('#chequeAmount').val(Math.abs(loanAmount-prvAmt));
		if(isNaN(loanAmount) || loanAmount == 0){
			alert('Enter loan amount')
			return
		}

			if((loanAmount >loanEligibleAmount) && loanAmount > minLoanEligAmt){
			alert('Loan eligibility amount is ' + loanEligibleAmount);
			this.value = '';
			$('#thriftDedAmount,#installmentNumber').val('');
			$('#intsallmentAmount').text('');
			
			return;
		}
			
		if(loanType == 'LTL'){
			var loanPurpose= $('#loanPuropse').val();
			var remarks=$('#Remarks').val();
			//var prvAmount = Number($('#prvLoan').val())
			$('#loanPuropse,#Remarks').prop('disabled',false);	
		    $('#loanPuropse').val('PERSONAL');
		    var minimumThriftAmount = (totalamount * thriftPerc )/100;
		    //minimumThriftAmount = Math.ceil(minimumThriftAmount/100)*100;
		    var thriftAmount = Number($('#thrfiAvailableAmount').val());
		    var balance =  Math.ceil(minimumThriftAmount - thriftAmount);
//		    var chequeAmt=parseInt(loanAmount-balance-prvAmt);
			if(loanAmount<=thriftAmount){
				alert("No Surety required")
				$('#suretyDetails').hide();
			}else{
				suretyRequired = 3;
				$('#suretyDetails').show();
			}
		    var requiredLoanAmount = balance;
//		var installmentAmount = Math.ceil((loanamt/installments)/100)*100;
		
		if(balance > 0){
			alert('Rs. '+ balance + ' Will  be deducted in loan amount as THRIFT Amount');
			var thriftAmt=balance;
			 $('#chequeAmount').val(Math.abs(loanAmount-thriftAmt-prvAmt));
			$('#thriftDedAmount').val(thriftAmt);
		}
		if(balance<0){
			//$('#chequeAmount').val(Math.abs(loanAmount-prvAMount));
			 $('#thriftDedAmount').val(0);
		}
		
		if(!isNewLoan){
			$('#prvLoanNum').val(prvLoanApNum+" / "+prvOutstanding);
			if(loanAmount < prvOutstanding){
				this.value = '';
				return;
			}
			
			if(prvLoanStatus == 'SANCTION'){
				alert('Rs. ' + prvOutstanding + ' will be deducted in loan amount as PREVIOUS LOAN BALANCE');
				requiredLoanAmount  += prvOutstanding;
			}
		    }
		
		if(loanAmount < requiredLoanAmount){
			alert('Loan amount should be more than ' +requiredLoanAmount);
			return;
		}
		
	/*	if(thriftAmount >= loanAmount){
			alert('No surety required ');
		}
		else{
			suretyRequired = 3;
			var _7timesBasicPay = loanAmount * 7;
			if(_7timesBasicPay <= loanAmount || loanAmount <= 300000){
				suretyRequired = 2
			}
			else{
				suretyRequired = 3;
			   }
		       }*/
		var memAccNo  = $('#empCode').val();
		suritydetails(memAccNo);
		
		}	
	    });	

	$('#installmentNumber').change(function() {
		var NoOfInst=parseInt($("#installmentNumber").val());
		//alert('NoOfInst--> '+NoOfInst)
		var RuleValue=parseInt($('#RuleValue1').val());
     if(NoOfInst>RuleValue){
		alert("Number of installments should be 100 or less than 100")
		$('#installmentNumber').val('');
		return;
		}
		changeInstallmentAmount();
	    });
	changeInstallmentAmount = function() {
		var loanAmount = parseInt($('#loanAmount').val(), 10);		
		var installmentNumber =parseInt($('#installmentNumber').val());
		var installmentAmount = Math.ceil((loanAmount/installmentNumber)/100)*100;
		$('#intsallmentAmount').val(installmentAmount);
	}
	
	 function changeInstallmentAmountload(loanAmount) {
		var loanAmount = parseInt(loanAmount);
		var installmentNumber =$('#installmentNumber').val();
		var installmentAmount = Math.ceil((loanAmount/installmentNumber)/100)*100;
		$('#intsallmentAmount').val(installmentAmount);
	}
	 
//	 function chequeAmount(loanAmount) {
//			var loanAmount = parseInt(loanAmount);
//			var installmentNumber =$('#installmentNumber').val();
//			var installmentAmount = Math.ceil((loanAmount/installmentNumber)/100)*100;
//			$('#intsallmentAmount').text("  "+installmentAmount);
//		}
		 
	$('#surityDetails1').change(function() {
		clearSuretyList2();
		var suritymemAccNo = this.value;
		var id=this.id;
		suritydetails2(suritymemAccNo);	
		surityElg(suritymemAccNo,id);
		/*loadSuretiesList(2);*/
	});
	
	$('#surityDetails2').change(function() {
		clearSuretyList3();
		var suritymemAccNo2 = this.value;
		var id=this.id;
		suritydetails3(suritymemAccNo2);
		surityElg(suritymemAccNo2,id);
		/*loadSuretiesList(3);*/
	});
	
	$('#surityDetails3').change(function() {
		var suritymemAccNo3 = this.value;
		var id=this.id;
		surityElg(suritymemAccNo3,id);
		//validateSurietiesThriftAmt();
		
		
	});
	// to get thrift deducted amount based on loan app date start added by pn on 07/04/2025 told by kannan sir
	
	$('#loanApplicationDate').change(function() {
		var loanType =$('#loanType').val();
		if(loanType=='LTL'){
		$('#thrfiAvailableAmount').val(curThrift);
		var loanAppDate = this.value;
		var currDate=$("#currentDate").val();
		var memAccNo = $('#empCode').val();
		
		var thrfiAvailableAmount=Number($('#thrfiAvailableAmount').val())
		
			alert(thrfiAvailableAmount+"--- "+currDate+"  "+loanAppDate)
		if(thrfiAvailableAmount>0 && loanAppDate<=currDate){
			$.post('/SocietyNew/LoanApplication',{
				req:'thriftAmount',
				memAccNo : memAccNo,
				loanAppDate : loanAppDate,
				loanType : loanType,
		},function (data) {
			try {
				var pop_data = eval("("+data+")");
				if(pop_data.SUCCESS=='Y'){
					$('#thrfiAvailableAmount').val(thrfiAvailableAmount-Number(pop_data.thrftamnt));
					$('#prvLoan').val(pop_data.prvamnt);
					var loanEligibleAmount = parseInt($('#loanEligibleAmount').val(), 10);
					$('#loanBalance').val(loanEligibleAmount-Number(pop_data.prvamnt));
				}
				else
					$('#thrfiAvailableAmount').val(thrfiAvailableAmount);
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeCodesurityList1 ' +e.message)
			}
		});
		}
		else{
			$('#thrfiAvailableAmount').val(thrfiAvailableAmount);
			alert(" first select loan type")
			return;
		}
		
		}
				
	});
	// end
	
	function suritydetails(memAccNo) {
		var memaccno=memAccNo;
	$.post('/SocietyNew/genericsDetails',{
			type : 'SURITYLIST',
			req:'surityList',
			memaccno : memaccno,
	},function (data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.SURITYEMPLOYEELIST;
			var sel = document.getElementById("surityDetails1");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				var string = temp.split('-')[0];
				option.value=string;
				sel.add(option);
			}
			$("#surityDetails1").trigger("chosen:updated").prop("disabled" ,false);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodesurityList1 ' +e.message)
		}
	});
	}
	
	
	function suritydetails2(suritymemAccNo) {
		var suritymemAccNo=suritymemAccNo;
		var memAcNo  = $('#empCode').val();
	$.post('/SocietyNew/genericsDetails',{
		type : 'SURITYLIST',
		req:'surityList',
		memaccno : suritymemAccNo,
	},function (data) {
		
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.SURITYEMPLOYEELIST;
			var sel = document.getElementById("surityDetails2");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				var string = temp.split('-')[0];
				if(memAcNo!=string){
				option.value=string;
				sel.add(option);
				}
			}
			$("#surityDetails2").trigger("chosen:updated").prop("disabled" ,false);
		
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodesurityList2 ' +e.message)
		}
	});
	}
	
	
	function suritydetails3(suritymemAccNo2) {
		var suritymemAccNo2=suritymemAccNo2;
		var memAcNo  = $('#empCode').val();
		var surityDetails1  = $('#surityDetails1').val();
		
	$.post('/SocietyNew/genericsDetails',{
		type : 'SURITYLIST',
		req:'surityList',
		memaccno : suritymemAccNo2,
	},function (data) {
		
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.SURITYEMPLOYEELIST;
			var sel = document.getElementById("surityDetails3");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				var string = temp.split('-')[0];
				if(memAcNo==string){
				}else if(surityDetails1==string){
				}else{
					option.value=string;
					sel.add(option);
				}				
				}
			
			$("#surityDetails3").trigger("chosen:updated").prop("disabled" ,false);
		
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodesurityList3 ' +e.message)
		}
	});
	}
	

	
	//save 
	validateSave = function() {
		var memAccNo = $('#empCode').val();
		if(memAccNo == '' || memAccNo == undefined){
			alert('Select member');
			this.value = '';
			return false;
		}
		var loanAmount = parseInt($('#loanAmount').val(), 10);
		if(loanAmount == 0 || isNaN(loanAmount) || loanAmount == undefined){
			alert('Enter Loan amount ');
			return false;
		}
		
		var installmentNumber = $('#installmentNumber').val();
		if(installmentNumber == '' || installmentNumber == undefined){
			alert('Select Number Of installment');
			this.value = '';
			return false;
		}
		
		var loanType = $('#loanType').val();
		if(loanType == 'LTL'){
	
			if(suretyRequired > 0){
				var surityDetails1 = $('#surityDetails1').val();
				if(surityDetails1 == ''){
					alert('Select Surety 1')
					return false;
				}
				var surityDetails2 = $('#surityDetails2').val();
				if(surityDetails2 == ''){
					alert('Select Surety 2')
					return false;
				}
				if(suretyRequired == 3){
				var surityDetails3 = $('#surityDetails3').val();
				if(surityDetails3 == ''){
					alert('Select Surety 3')
					return false;
				}
				}
				//return validateSurietiesThriftAmt();
			    }
		        }
	            	return true;
	            }
                })

                
                
                
	validateSave = function() {

		var memAccNo = $('#empCode').val();
		if(memAccNo == '' || memAccNo == undefined){
			alert('Select member');
			this.value = '';
			return false;
		}
		
		var loanAmount = parseInt($('#loanAmount').val(), 10);
		
		if(loanAmount == 0 || isNaN(loanAmount) || loanAmount == undefined){
			alert('Enter Loan amount ');
			return false;
		}
		
		var installmentNumber = $('#installmentNumber').val();
		if(installmentNumber == '' || installmentNumber == undefined){
			alert('Select Number Of installment');
			this.value = '';
			return false;
		}

		var loanType = $('#loanType').val();
		if(loanType == 'LTL'){
			if(suretyRequired > 0){
				var surityDetails1 = $('#surityDetails1').val();
				if(surityDetails1 == ''){
					alert('Select Surety 1')
					return false;
				}
				var surityDetails2 = $('#surityDetails2').val();
				if(surityDetails2 == ''){
					alert('Select Surety 2')
					return false;
				}
				if(suretyRequired == 3){
				var surityDetails3 = $('#surityDetails3').val();
				if(surityDetails3 == ''){
					alert('Select Surety 3')
					return false;
				}
				}
				//return validateSurietiesThriftAmt();
			    }
		        }
		        return true;
	            }
//surety validation based on thrift start
/*function validateSurietiesThriftAmt() {
	var suriety1=$('#surityDetails1').val();
	var suriety2=$('#surityDetails2').val();
	var suriety3=$('#surityDetails3').val();
		$.post('/SocietyNew/ApplicationForLoan',{
		req : 'getsurietythr',
		suriety1:suriety1,
		suriety2:suriety2,
		suriety3:suriety3,
		},function (data) {
			
				var pop_data = eval("("+data+")");
				var thriftAmount1=parseInt(pop_data.SURIETY1[0].suriety1);
				var thriftAmount2=parseInt(pop_data.SURIETY2[0].suriety2);
				var thriftAmount3 =parseInt(pop_data.SURIETY3[0].suriety3);
				
				var totalThriftAmount = thriftAmount1+thriftAmount2+thriftAmount3;
				var loanAmount = parseInt($('#loanAmount').val(), 10);
				
				var minimumThriftAmount = (loanAmount * thriftPerc )/100;
				
				
				
				if(totalThriftAmount < minimumThriftAmount){
					var requiredAmount = minimumThriftAmount - totalThriftAmount;
					alert('Insufficient of thrift amount of Rs. '+requiredAmount+'\n All surities combined should have '+minimumThriftAmount +' as THRIFT amount Rejected due to Insufficient combined Thrift Amount of All surities ');
						//window.location="/SocietyNew/webapp/screens/Loan/LoanApplication/loan.jsp";
		           $("#surityDetails1").val('');
	   	           $("#surityDetails1").trigger("chosen:updated");
	               $("#surityDetails2").val('');
	   	           $("#surityDetails2").trigger("chosen:updated");
		           $("#surityDetails3").val('');
	               $("#surityDetails3").trigger("chosen:updated");
					return false;
				}
				
				
				if(suretyRequired == 2){
					var totalThriftAmount = thriftAmount1+thriftAmount2;
					var thriftAmount3 =parseInt(pop_data.SURIETY3[0].suriety3);
					if(!isNaN(suretyRequired)){
						totalThriftAmount += thriftAmount3; 
					}
				    }		
		            });
	              	return true;
                    }*/
//surety validation end
// express surity list start
function expressSuritydetails(memAccNo) {
	var memaccno=memAccNo;
	alert(memaccno)
$.post('/SocietyNew/genericsDetails',{
		type : 'SURITYLIST',
		req:'surityList',
		memaccno : memaccno,
},function (data) {
	try {
		var pop_data = eval("("+data+")");
		var arr = new Array();
		arr = pop_data.SURITYEMPLOYEELIST;
		var sel = document.getElementById("surityDetail");
		for(var i=0;i<arr.length;i++){	
			var option=document.createElement("option");
			var temp = arr[i];
			option.text=temp;
			var string = temp.split('-')[0];
			option.value=string;
			sel.add(option);
		}
		$("#surityDetail").trigger("chosen:updated").prop("disabled" ,false);
	} catch (e) {
		// TODO: handle exception
		alert('Exception in getEmployeeCodesurityList1 ' +e.message)
	}
});
}
// express surity list end




/*function changeLoan(){
	var previousAmt=document.getElementById("prvLoan").innerHTML;
	//alert('previous amount---->'+previousAmt);
}
 function changeloan() {
	
	var loantypee=$('#loantypee').val();
	
	if(loantypee!='null'){
		alert("loan amount change loan type is not null")
	var minLoanEligAmt=parseInt($('#MinLoanEligibilyAmount').val());
	
	$('#installmentNumber').val('');
	$('#thriftDedAmount,#intsallmentAmount').text('');
		var memAccNo =$('#memAccNo').val();
		var loanType =$('#loantypee').val();;
		var loanAmount=parseInt($('#loanamount').val());
		$('#installmentNumber').val(noOfInstallment);
	
			var loanAmountt = parseInt(loanAmount);
		
			var installmentNumber =$('#installmentNumber').val();
			alert(loanAmountt)
			var installmentAmount = Math.ceil((loanAmountt/installmentNumber)/100)*100;
		alert(installmentAmount)
			$('#intsallmentAmount').text("  "+installmentAmount);
		
		if(loantypee == 'FDL'){
			var fdNumbers = $('#FDNumbers').val();
			if(fdNumbers == undefined || fdNumbers == ''){
				alert('Select Fixed deposit number');
				return;
			}
		}
	
	
		var previousLoanOutstanding = 0;
		var loanEligibleAmount = parseInt($('#loanEligibleAmount').text(), 10);
		if(isNaN(loanAmount) || loanAmount == 0){
			alert('Enter loan amount')
			return
		}


			if((loanAmount >loanEligibleAmount) && loanAmount > minLoanEligAmt){
			alert('Loan eligibility amount is ' + loanEligibleAmount);
			this.value = '';
			$('#thriftDedAmount,#installmentNumber').val('');
			$('#intsallmentAmount').text('');
			return;
			
		}
			
		if(loantypee == 'LTL'){
			
			
		$('#loanPuropse').val('PERSONAL');
		var minimumThriftAmount = (loanAmount * thriftPerc )/100;
		minimumThriftAmount = Math.ceil(minimumThriftAmount/100)*100
		var thriftAmount = parseInt($('#thrfiAvailableAmount').text(), 10);
		var balance =  minimumThriftAmount - thriftAmount;
		
		var requiredLoanAmount = balance;			
		if(balance > 0){
			alert('Rs. '+ balance + ' Will  be deducted in loan amount as THRIFT Amount');
			$('#thriftDedAmount').text(balance);
		}
		if(!isNewLoan){
			
			$('#prvLoanNum').text(prvLoanApNum+" / "+prvOutstanding);
			if(loanAmount < prvOutstanding){
				alert('Previous loan outstanding is ' + prvOutstanding);
				this.value = '';
				return;
			}
			if(prvLoanStatus == 'SANCTION'){
				alert('Rs. ' + prvOutstanding + ' will be deducted in loan amount as PREVIOUS LOAN BALANCE');
				requiredLoanAmount  += prvOutstanding;
			}
			
		}
		
		if(loanAmount < requiredLoanAmount){
			alert('Loan amount should be more than ' +requiredLoanAmount);
			return;
		}
		if(thriftAmount >= loanAmount){
			alert('No surety required ');
		}
		else{
			suretyRequired = 3;
			var _7timesBasicPay = loanAmount * 7;
			if(_7timesBasicPay <= loanAmount || loanAmount <= 300000){
				suretyRequired = 2
			}
			else{
				suretyRequired = 3;
			}
		}
		}
	
		}	
	}*/



function surityElg(memAccNo,id){
	$.post('/SocietyNew/LoanApplication',{
		req:'surityElg',
		memaccno : memAccNo,
	},function (data) {
		
		try {
			var pop_data = eval("("+data+")");
			if(pop_data.success=='n'){
				alert( pop_data.msg);
				$("#"+id).val('');
				$("#"+id).trigger("chosen:updated").prop("disabled" ,false);
				return ;
			}
		
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodesurityList3 ' +e.message)
		}
	});
	return false;
}