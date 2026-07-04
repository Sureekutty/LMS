var eligibleAmount=0;
var prvAmount = 0;
var interest;
var serviceMonths=0;
	checkEmp=function(){
		
		$('#btnSave').prop('disabled',false);
		$('#loanApplicationDate').prop('disabled',false);
		var memAccNo=$('#memAccNo').val();
		
		var Loanappno=$('#Loanappno').val();
		
		if(Loanappno=='null'){
			return;
		}
		$('#LoanAppNo').text(Loanappno);
		
		
		$.post('/SocietyNew/LoanApplication',{
			req:'getLoanInfo',
			Loanappno : Loanappno,
	},function (data) { 
		
		
		try {
			var pop_data = eval("("+data+")");
			
			var loantype=pop_data.LoanDetails[0].LoanType;
			//loantypedata(loantype)
			getinterest(loantype)
			$('#LoanAppNo').text(pop_data.LoanDetails[0].LoanAccNo);
			$('#basicPay').val(pop_data.LoanDetails[0].BasicPay);
			$('#shareAmount').val(pop_data.LoanDetails[0].NoOfShares+"/"+pop_data.LoanDetails[0].ShareAmount);
			$('#loanApplicationDate').val(pop_data.LoanDetails[0].Loanappdate);
			var loanAmt=$('#loanAmount').val(pop_data.LoanDetails[0].LoanSanctionAmount);
			$('#installmentNumber').val(pop_data.LoanDetails[0].NoOfInstallments);
			$('#intsallmentAmount').val(pop_data.LoanDetails[0].MonthlyInstallments);
			$('#Remarks').val(pop_data.LoanDetails[0].Remarks);
			
			if(loantype=="FDL"){
				$('#FDLoanDiv').show();
				$('#loanDetails').hide();
				$('#hfd,#hfd1,#hfd2,#hfd3,#hfd4,#hfd5').hide();
			
			}else if(loantype=="EXL"){
				$('#loanDetails').hide();
				$('#FDLoanDiv').hide();
				$('#hfd,#hfd1,#hfd2,#hfd3,#hfd4,#hfd5').show();
			}else if(loantype=="LTL"){
				$('#hfd,#hfd1,#hfd2,#hfd3,#hfd4,#hfd5').show();
				$('#FDLoanDiv').hide();
				$('#loanDetails').show();
				$('#loanPuropse').val(pop_data.LoanDetails[0].LoanPurpose);
				var loamprvamount=pop_data.PRVLoanDetails[0].prvLoanSanctionAmount;
				$('#prevloanamount').val(loamprvamount);
				$('#prvLoanNum').val(pop_data.PRVLoanDetails[0].prvLoanAccNo+"/"+pop_data.PRVLoanDetails[0].prvLoanSanctionAmount);
			
				$('#thrfiAvailableAmount').val(pop_data.LoanDetails[0].thriftavailbleamount);
				$('#thriftDedAmount').val(pop_data.LoanDetails[0].Thriftdudamt);
				$('#prvAmt').val(loamprvamount);
			}
			
		
			
			getloantypeload(loantype)
			getMemberCodeListacc(memAccNo)
			
			
		} catch (e) {
			alert('Exception in getLoanDetails ' +e.message)
		}
	});		
}
	
var noOfInstallment = 0;
var thriftPerc = 0;
var prvSanctionDate = '';
var prvLoanApNum = '';
var prvLoanStatus = '';
var prvOutstanding = 0;
var isNewLoan = false;
var thriftAvailableAmount = 0;
var curThrift=0;
var suretyRequired = 0;

$(document).ready(function() {	
	displayScreenDetails(" Loan Request ");		
	var setValue = '';
	var thriftAmountRequired = 0;
	var noOfInstalmentMonths = 0;
	var isDataSaved = false;
	var thriftPercentage  = 0;	
	clearSubValues = function() {
		$('#loanCommonDetails').find(':input').val("");
		$('prvLoanNum,#loanPuropse,#FDAmount,#loanApplicationDate,#Remarks').val('');
		$('#basicPay,#shareAmount,#loanEligibleAmount,#installmentNumber,#intsallmentAmount,#LoanAppNo').val('');
	}
	
	clearOnLoadEmployee = function() {
		$('#basicPay,#shareAmount,#loanApplicationDate,#loanEligibleAmount,#LoanAppNo,#chequeAmount').val('');
	}
	
	clearOnChangeOfLoanType = function() {
		$('#loanEligibleAmount,#FDAmount,#intsallmentAmount,#LoanAppNo,#interest, #chequeAmount,#prvLoan,#loanBalance').val('');
		$('#prvLoanNum,#loanPuropse,#installmentNumber,#intsallmentAmount,#loanAmount,#chequeAmount,#loanApplicationDate,#Remarks').val('');
	}
	
	clearMemberCodeList = function() {
		var sel = document.getElementById("empCode");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
	
	clearSuretyList3 = function() {
		var sel = document.getElementById('surityDetails3');
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
	
	clearSuretyList2 = function() {
		var sel = document.getElementById('surityDetails2');
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
	
	clearSuretyList1 = function() {		
		var sel = document.getElementById('surityDetails1');
		var options = sel.options;		
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
			
	clearloanTypeList = function() {
		var sel = document.getElementById("loanType");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
	
	clearFDNumbersList = function() {
		var sel = document.getElementById("FDNumbers");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
	
	clearAllSelectBox = function() {
		clearloanTypeList();
		clearFDNumbersList();
	}
	
	clearSuretyLists = function() {
		
		clearSuretyList1();
		clearSuretyList2();
		clearSuretyList3();
	}	
	
getMemberCodeList = function() {		
	clearMemberCodeList();
	clearAllSelectBox();
	clearSuretyLists();		
	$.post('/SocietyNew/genericsDetails',{
			type : 'SOCIETYMEM',
			req:'employeeList',
			regstatus : 'ACTIVE',
			},function (data) {		
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.EMPLOYEELIST;
				var sel = document.getElementById("empCode");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
					option.text=temp;
					var string = temp.split('-')[0];
					option.value=string;
					sel.add(option);
				}
				$("#empCode").trigger("chosen:updated").prop("disabled" ,false);
			
			} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
	});
}
						
hideAllFields = function() {
	$('.mainLoanDetails,#suretyDetails,#loanDetails').hide();
}

showAllFields = function() {
	$('.mainLoanDetails,#suretyDetails,#loanDetails,#chequeAmount').show();
}

hideEXPLoanDiv = function() {
	$('#expressSurety').hide();
	
}

showEXPLoanDiv = function() {
	$('#expressSurety').show();
}

hideFDLoanDiv = function() {
	$('#FDLoanDiv').hide();
}

showFDLoanDiv = function() {
	$('#FDLoanDiv').show();
}

clearScreen = function () {
	clearOnLoadEmployee();
	clearOnChangeOfLoanType();
	getMemberCodeList();
	hideAllFields();
	hideEXPLoanDiv();
	hideFDLoanDiv();
	$('#loanAmount,#chequeAmount,#installmentNumber,#loanApplicationDate').prop('disabled',true);
	//$('#loanApplicationDate').val('');
}

clearScreen();
$('#btnClearAll').click(function() {
	window.location="/SocietyNew/webapp/screens/Loan/LoanApplication/loan.jsp"
	/*$("#loanType").val('').trigger("chosen:updated");
	clearScreen();*/
});
	
$('#empCode').change(function() {
	thriftAmountRequired = 0;
	clearAllSelectBox();
	hideAllFields();
	hideFDLoanDiv();
	hideEXPLoanDiv();
	
	setValue = '';
	clearOnLoadEmployee();
	clearOnChangeOfLoanType();
	thriftAvailableAmount = 0;
	
	$('#loanDetails :text').val('');
	$('#basicPayTD,#thriftAmountTD').show();
	var memAccountNumber = this.value;

	
	$.post('/SocietyNew/LoanApplication',{
		req : 'getMemberDetails',
		memAccountNumber : memAccountNumber,
		},function(data){
			try {
			var eval_Data = eval("("+data+")");
			var memberdetails  = eval_Data.MEMBERDETAILS;
			var status = memberdetails[0].regStatus;
			if(status==='ACTIVE'){
				$('#basicPay').val(memberdetails[0].basicPay);
				$('#shareAmount').val(memberdetails[0].totalShares +"/"+ memberdetails[0].shareAmount);
				$('#loanPuropse').val('personal'.toLocaleUpperCase());
				thriftAvailableAmount = memberdetails[0].thriftAmount;
				curThrift=memberdetails[0].thriftAmount;
				$("#retdDate").val(memberdetails[0].retirementDate);					
				getLoanTypes();
				getServiceMonths();
			}
			else{
				$('#basicPay').val(0);
				/*$("#loanType").text("Fixed Deposit Loan");
				$("#loanType").val("FDL");
				$("#loanType").trigger("chosen:updated");
				$("#loanType").prop("disabled" ,false);*/
				var sel = document.getElementById("loanType");
					var option=document.createElement("option");
					//var temp = arr[i].LoanTypeDescription;
					option.text="Fixed Deposit Loan";
					option.value="FDL";
					sel.add(option);

				$("#loanType").trigger("chosen:updated");
				$("#loanType").prop("disabled" ,false);
			}
			
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getMemberDetails ' + e.message);
			}
	});	
});
	
getLoanTypes = function() {
	$.post('/SocietyNew/LoanApplication',{
		req : 'getLoanTypes',
	},
	function(data) {
		var pop_data = eval("("+data+")");
		var arr = new Array();
		arr = pop_data.LOANTYPES;
		var sel = document.getElementById("loanType");
		for(var i=0;i<arr.length;i++){	
			var option=document.createElement("option");
			var temp = arr[i].LoanTypeDescription;
			option.text=temp;
			option.value=arr[i].LoanTypeCode;
			sel.add(option);
			}
		$("#loanType").trigger("chosen:updated");
		$("#loanType").prop("disabled" ,false);
	});
}
	
getFDNumbers = function(empCode) {
	$.post('/SocietyNew/LoanApplication',{
		req : 'depositNumbers',
		empCode:empCode,		
	},
	function(data) {		
		var pop_data = eval("("+data+")");
		var arr = new Array();
		arr = pop_data.DEPOSITSDETAILS;
		if(arr.length > 0){
		var sel = document.getElementById("FDNumbers");
		for(var i=0;i<arr.length;i++){	
			var option=document.createElement("option");
			var temp =arr[i].DepositNo;				
			option.text=temp;
			option.value=arr[i].AmountNo;
			sel.add(option);
			}
		$("#FDNumbers").trigger("chosen:updated");
		$("#FDNumbers").prop("disabled" ,false);
		$('#loanAmount,#installmentNumber,#Remarks').prop('disabled',false);
		}
		else{
			
			alert('No Fixed Deposits for this member account ' + empCode)
			$("#FDNumbers").trigger("chosen:updated");
			$('#loanAmount,#chequeAmount,#installmentNumber,#Remarks').prop('disabled',true);
			$("#FDNumbers").prop("disabled" ,true);
			return;
		}		
	});
}

calculateLoanEligibilityAmount = function(empCode,loanType,fdNumber,fdAmount) {
	$('#loanEligibleAmount').text('')
	var thrfiAvailableAmount=Number($('#thrfiAvailableAmount').val())
	$.post('/SocietyNew/LoanApplication',{
		req : 'calulateLoanEligibilyAmount',
		empCode:empCode,
		loanType:loanType,
		fdNumber:fdNumber,
		fdAmount:fdAmount
		},function(data){
			try {
				var amount  = eval("("+data+")");
				eligibleAmount=parseInt(amount.loanEligbleAmount);
				if(thrfiAvailableAmount>eligibleAmount && loanType=='LTL'){
					$('#loanEligibleAmount').text(thrfiAvailableAmount);
					$('#loanEligibleAmount').val(thrfiAvailableAmount);
					eligibleAmount=thrfiAvailableAmount;
				}
				else{
					$('#loanEligibleAmount').text(eligibleAmount);
					$('#loanEligibleAmount').val(eligibleAmount);
				}
				
				//$('#loanBalance').text(eligibleAmount-prvAmount);
				checkInLoan(loanType);
			} catch (e) {
				// TODO: handle exception
				alert('Error in calulateLoanEligibilyAmount ' + e.message)
			}
	});
}
	
MinLoanEligibilyAmount = function (loanType){
	$('loanEligibleAmount').val('');
	$.post('/SocietyNew/LoanApplication',{
		req : 'MinLoanEligibilyAmount',
		loanType:loanType
	},function(data){
			try {
				var amount  = eval("("+data+")");
				$('#MinLoanEligibilyAmount').val(amount.minLoanEligibleAmt);
			} catch (e) {
				// TODO: handle exception
				alert('Error in calulateLoanEligibilyAmount ' + e.message)
			}
	});
}
	
getinterest = function(loanType) {
	
	$.post('/SocietyNew/LoanProcessController',{
		loanType:loanType,
		req:'getInterest',
	},function (data) {
		try {
			var pop_data = eval("("+data+")");
			interest=pop_data.Interest;
			$('#interest').val(interest);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getloaninterest ' +e.message)
		}
	});
}

getNoOfInst = function() {	
	$.post('/SocietyNew/LoanProcessController',{		
		req:'getNoOfInst',
		},function (data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.NoOfInst;
			//alert('Rulevalue1--> '+arr[0])
			$('#RuleValue1').val(arr[0]);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in loanprocesstypelist ' +e.message)
		}
	});
}

getRulesOfLoans = function(loanType){	
	thriftPerc = 0;
	noOfInstallment = 0;
	$.post('/SocietyNew/LoanApplication',{
		req : 'getRulesOfLoans',
		loanType:loanType,
		asynch:false,
		},function(data) {			
			try {
				var eval_Data = eval("("+data+")");
				thriftPerc = parseFloat(eval_Data.thriftPerc);				
				noOfInstallment = parseInt(eval_Data.noOfInstallment,0);
		} catch (e) {
			// TODO: handle exception
			alert('Error in getRulesOfLoans ' +e.message);
		}
	});
}	

checkInLoan = function(loanType) {
	 prvSanctionDate = '';
	 prvLoanApNum = '';
	 prvLoanStatus = '';
	 prvOutstanding = 0;
	 isNewLoan = false;
	 var fdNumber;
	 if(loanType == 'LTL' ||loanType == 'EXL')
		 fdNumber = '';
	if(loanType == 'FDL' )
		 fdNumber = $('#FDNumbers').val();
	var memAccountNumber = $('#empCode').val();
	//$('#loanEligibleAmount').text('');
	$.post('/SocietyNew/LoanApplication',{
		req : 'checkInLoanBoth',
		memAccountNumber:memAccountNumber,
		fdNumber:fdNumber,
		loanType:loanType,
		},function(data){

	try {
		var eval_Data = eval("("+data+")");
		
		prvAmount=parseInt(eval_Data.MYOBJECT.previousLoan, 10);
		$('#prvLoan').val(prvAmount);
		$('#loanBalance').val(eligibleAmount-prvAmount);
		if(eval_Data.MYOBJECT == 'NEWLOAN'){
			isNewLoan = true;
			prvLoanApNum = 'NA';
			prvLoanStatus = 'NA';
			prvOutstanding = 0;
			prvSanctionDate = 'NA';
		}
		else{
		isNewLoan = false;
		if(eval_Data.MYOBJECT.LoanStatus == 'FRESH'|| eval_Data.MYOBJECT.LoanStatus == 'SANCTION'|| eval_Data.MYOBJECT.LoanStatus == 'RELINIT'){		// eval_Data.MYOBJECT.LoanStatus == 'RELEASED' removed as per Kannan Sir & Rama Rao Sir order
			alert('Previous Loan is in '+eval_Data.MYOBJECT.LoanStatus+ ' State \n Loan Number is: ' +eval_Data.MYOBJECT.LoanAppNo+'\n Loan Amount is :'+eval_Data.MYOBJECT.OutstandingAmt+'\n Not Possible to Request New Loan');
			$('#loanAmount,#installmentNumber,#loanPuropse,#Remarks').prop('disabled',true);
			$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1').prop('disabled',true);
			$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1').trigger("chosen:updated");
			return;
			}
		/*if(eval_Data.MYOBJECT.LoanStatus == 'SETTLED'){
			alert('Previous Loan is '+eval_Data.MYOBJECT.LoanStatus+ ' \n Not Possible to Request New Loan');
			$('#loanAmount,#installmentNumber,#loanPuropse,#Remarks').prop('disabled',true);
			$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1').prop('disabled',true);
			$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1').trigger("chosen:updated");
			return;
			}*/
			prvLoanApNum = eval_Data.MYOBJECT.LoanAppNo;
			prvLoanStatus = eval_Data.MYOBJECT.LoanStatus;
			prvOutstanding = parseInt(eval_Data.MYOBJECT.OutstandingAmt, 10);
			prvSanctionDate = eval_Data.MYOBJECT.LoanSanctionDate;
			}
		} catch (e) {
		// TODO: handle exception
		alert('error Check in loan ' + e.message);
	}
	});
}

loadSuretiesList = function(surNum){
	var memAccNo  = $('#empCode').val();
	$.post('/SocietyNew/LoanApplication',{
		req:'loadSurety',
		memAccNo:memAccNo,
		},function(data){
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.SURDETAILS;
				//alert("Surnum is "+surNum)
					if(surNum == 1){
						var sel = document.getElementById("surityDetails1");
						for(var i=0;i<arr.length;i++){	
							var temp = arr[i].detail;
							var option=document.createElement("option");
							option.text=temp;
							option.value=arr[i].memAccNo+'~'+arr[i].thriftAmt;
							sel.add(option);
						}
						$('#surityDetails1').trigger("chosen:updated");
						$('#surityDetails1').prop("disabled" ,false);
					}
					if(surNum == 2){
						var sel = document.getElementById("surityDetails2");
						var memAccNo1 = $('#surityDetails1').val();
						memAccNo1 = memAccNo1.split("~")[0];
					
						for(var i=0;i<arr.length;i++){	
						var temp = arr[i].detail;
						var memAccNo2 = arr[i].memAccNo;
						if(memAccNo2 != memAccNo1){
//								alert(memAccNo2 + '  ' + memAccNo1);
							var option=document.createElement("option");
							option.text=temp;
							option.value=arr[i].memAccNo+'~'+arr[i].thriftAmt;
							sel.add(option);
						}
						}
						$('#surityDetails2').trigger("chosen:updated");
						$('#surityDetails2').prop("disabled" ,false);
					}
					if(surNum == 3){
						var sel = document.getElementById("surityDetails3");
						var memAccNo1 = $('#surityDetails1').val();
						memAccNo1 = memAccNo1.split("~")[0];
						var memAccNo2 = $('#surityDetails2').val();
						memAccNo2 = memAccNo2.split("~")[0];
						for(var i=0;i<arr.length;i++){	
						var memAccNo3 = arr[i].memAccNo;
						if(memAccNo2 != memAccNo3 && memAccNo1 != memAccNo3){
							var option=document.createElement("option");
							var temp = arr[i].detail;
							option.text=temp;
							option.value=arr[i].memAccNo+'~'+arr[i].thriftAmt;
							sel.add(option);
						}
						}
						$('#surityDetails3').trigger("chosen:updated");
						$('#surityDetails3').prop("disabled" ,false);
					}
			} catch (e) {
					// TODO: handle exception
					alert('Exception in loadSurety ' +e.message);
		}
	});
}

$('#btnSave').click(function() {
		var option;
		var loanappnum;
		var Loanappno=$('#Loanappno').val();
		//alert("loanappnum "+Loanappno)
		loanappnum=Loanappno;
		if(Loanappno=='null'){
			 option = 'SAVE';
			 loanappnum="";
		}else{
			 option = 'UPDATE';
		}			
		if(validateSave()){			
			var confim=confirm("Are You Sure \n" +	"click OK to continue")
			 
		    if(confim){
				var loanPuropse = '';
				var thrfiAvailableAmount = 0;
				var thriftdudamt =0;
				var chequeAmount=0;
				var FDNumbers = '';
				var prvLoanNum = '';
				var surityDetails1 = null;
				var surityDetails2 = null;
				var surityDetails3 = null;		
				var memAccNo = $('#empCode').val();
				var loanType = $('#loanType').val();
				var loanAmount =parseInt($('#loanAmount').val());
				var installmentNumber=0;
				var installmentNumbermonthly=0;			
				 installmentNumber = $('#installmentNumber').val();
				 installmentNumbermonthly = $('#intsallmentAmount').val().trim();
				var loanApplicationDate = $('#loanApplicationDate').val();
				 var emplcode = $('#emplcode').val();
				if(loanApplicationDate==""){
					alert("Select date");
					return;
				}			
				if(loanType=='EXL'){
					chequeAmount = $('#chequeAmount').val();
					surityDetails1 = $('#surityDetail').val();
				}
				if(loanType == 'FDL'){
					FDNumbers = $('#FDNumbers').val();
					FDNumbers = FDNumbers.split("~")[0];
					chequeAmount = $('#chequeAmount').val();
						installmentNumbermonthly=0;
						installmentNumber=0;
				}
				if(loanType == 'LTL'){				
					loanPuropse = $('#loanPuropse').val();
					thriftdudamt = $('#thriftDedAmount').val();
					alert("thriftdudamt "+thriftdudamt )
					chequeAmount = $('#chequeAmount').val();
					prvLoanNum = $('#prvLoanNum').val().split("/")[0];
					surityDetails1 = $('#surityDetails1').val();
					surityDetails2 = $('#surityDetails2').val();
					surityDetails3 = $('#surityDetails3').val();
				}			
				var Remarks = $('#Remarks').val();			
				/*if(Remarks=="" || Remarks==undefined){
					alert("Enter Remarks");
					return;
				}	*/					
				if(thriftdudamt=="")
					thriftdudamt=0;			
				$.post('/SocietyNew/LoanApplication',{
				req : 'saveApplication',
				option:option,
				memAccNo:memAccNo,
				loanType:loanType,
				loanPuropse :loanPuropse,
				installmentNumber:installmentNumber,
				installmentNumbermonthly : installmentNumbermonthly,
				thriftdudamt : thriftdudamt,
				interest : $('#interest').val(),
				chequeAmount : chequeAmount,
				FDNumbers : FDNumbers,
				loanAmount:loanAmount,
				loanApplicationDate:loanApplicationDate,
				surityDetails1:surityDetails1,
				surityDetails2:surityDetails2,
				surityDetails3:surityDetails3,
				loanappnum:loanappnum,
				emplcode:emplcode,
				Remarks:Remarks,
				},function (data) {
					try {
						var pop_data = eval("("+data+")");
						if(pop_data.SUCCESS == 'Y'){
							if(pop_data.loanAppNum == null){
								alert("Loan application has been Successfully submitted ")
							}
							else{
							alert(pop_data.msg);
							$('#LoanAppNo').text(pop_data.loanAppNum);
							$('#loanAmount,#chequeAmount,#installmentNumber').prop('disabled',true);
							$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1,#FDNumbers,#loanType').prop('disabled',true);
							$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1,#FDNumbers,#loanType').trigger("chosen:updated");
	//						$('#btnSave,#surityDetails3,#surityDetails2,#surityDetails1,#FDNumbers,#loanType').prop("disabled" ,true);
							}
						}
						else{
							alert(pop_data.msg);
							return;
						}
					} catch (e) {
						// TODO: handle exception
						alert('Exception in saveLoanApplication ' +e.message)
					}
				});						
		}
		}
	})	
});

 function getloantypeload(loantype){
	var loanty=loantype;
	$.post('/SocietyNew/LoanApplication',{
		req : 'getLoanTypesload',
	},
	function(data) {
		try {
		var pop_data = eval("("+data+")");
		var arr = new Array();
		arr = pop_data.LOANTYPECODE;
		var sel = document.getElementById("loanType");
		for(var i=0;i<arr.length;i++){
			var option=document.createElement("option");
			var temp = arr[i].LoanTypeCode;
			option.text=temp.split('-')[1];
			var desc=temp.split('-')[1];
			var string = temp.split('-')[0];			
			if(loanty.trim()==string.trim()){
				option.value=string;
				sel.add(option);
				$("#loanType").val(string);
				$("#loanType").trigger("chosen:updated").prop("disabled" ,true);				
			}			
			option.value=string;
			sel.add(option);
			}
		$("#loanType").trigger("chosen:updated").prop("disabled" ,true);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getLoanTypes ' +e.message)
		}
	});
}
 
function getMemberCodeListacc(memAccNo) {
	$.post('/SocietyNew/genericsDetails',{
		type : 'SOCIETYMEM',
		req:'employeeList',
		regstatus : 'ACTIVE',
		},function (data) {
	
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.EMPLOYEELIST;
			var sel = document.getElementById("empCode");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				var string = temp.split('-')[0];
				
				if(memAccNo==string){				
				
					$("#empCode").val(string);
					option.value=string;
					sel.add(option);
					$("#empCode").trigger("chosen:updated").prop("disabled" ,false);
				}
				option.value=string;
				sel.add(option);
			}
			
			$("#empCode").trigger("chosen:updated").prop("disabled" ,false);
		
		} catch (e) {
		// TODO: handle exception
		alert('Exception in getEmployeeCodeList ' +e.message)
	}
});
}

function suritydetails4(memAccNo,surity) {			
		var memaccno=memAccNo;
		$.post('/SocietyNew/genericsDetails',{
				type : 'SURITYLIST',
				req:'surityList',
				memaccno : memaccno,
		},function (data) {
			
		
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.SURITYEMPLOYEELIST;
				var sel = document.getElementById("surityDetails1");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
					option.text=temp;
					var string = temp.split('-')[0];
					if(surity==string){
						
						option.value=string;
						sel.add(option);
						$("#surityDetails1").val(string);
						$("#surityDetails1").trigger("chosen:updated").prop("disabled" ,false);
					}
					option.value=string;
					sel.add(option);
				}
				$("#surityDetails1").trigger("chosen:updated").prop("disabled" ,false);
			
			
		});
}

function suritydetails5(memAccNo,surity) {
var memaccno=memAccNo;
$.post('/SocietyNew/genericsDetails',{
	type : 'SURITYLIST',
	req:'surityList',
	memaccno : memaccno,
	},function (data) {
	var pop_data = eval("("+data+")");
	var arr = new Array();
	arr = pop_data.SURITYEMPLOYEELIST;
	var sel = document.getElementById("surityDetails2");
	for(var i=0;i<arr.length;i++){	
		var option=document.createElement("option");
		var temp = arr[i];
		option.text=temp;
		var string = temp.split('-')[0];
		if(surity==string){			
			option.value=string;
			sel.add(option);
			$("#surityDetails2").val(string);
			$("#surityDetails2").trigger("chosen:updated").prop("disabled" ,false);
		}
		option.value=string;
		sel.add(option);
	}
	$("#surityDetails2").trigger("chosen:updated").prop("disabled" ,false);
});
}

function suritydetails6(memAccNo,surity) {
var memaccno=memAccNo;
$.post('/SocietyNew/genericsDetails',{
	type : 'SURITYLIST',
	req:'surityList',
	memaccno : memaccno,
	},function (data) {
	var pop_data = eval("("+data+")");
	var arr = new Array();
	arr = pop_data.SURITYEMPLOYEELIST;
	var sel = document.getElementById("surityDetails3");
	for(var i=0;i<arr.length;i++){	
		var option=document.createElement("option");
		var temp = arr[i];
		option.text=temp;
		var string = temp.split('-')[0];
		if(surity==string){
			
			option.value=string;
			sel.add(option);
			$("#surityDetails3").val(string);
			$("#surityDetails3").trigger("chosen:updated").prop("disabled" ,false);
		}	
		option.value=string;
		sel.add(option);
	}
	
	$("#surityDetails3").trigger("chosen:updated").prop("disabled" ,false);
});
}
getFDNumbersload = function(funid,empCode) {
	$.post('/SocietyNew/LoanApplication',{
		req : 'depositNumbersload',
		funid:funid,
	},
	function(data) {		
		var pop_data = eval("("+data+")");
		var arr = new Array();
		arr = pop_data.DEPOSITSDETAILSLOAD;
		
		if(arr.length > 0){
		var sel = document.getElementById("FDNumbers");
		for(var i=0;i<arr.length;i++){	
			var option=document.createElement("option");
			var temp =arr[i].DepositNo;
			var temp1 =arr[i].AmountNo;			
			var amount= temp1.split("~")[1];			
			option.text=temp;			
			if(temp==funid){
				$('#FDAmount').val(amount);				
				option.value=temp;
				sel.add(option);
				$("#FDNumbers").val(temp);
				$("#FDNumbers").trigger("chosen:updated").prop("disabled" ,false);
				calculateLoanEligibilityAmount(empCode,'FDL',funid,amount) 
			}	
			option.value=temp;
			sel.add(option);
		}
		$("#FDNumbers").trigger("chosen:updated");
		$("#FDNumbers").prop("disabled" ,false);
		$('#loanAmount,#installmentNumber').prop('disabled',false);
		}else{
			
			alert('No Fixed Deposits for this member account  ' + empCode)			
		}		
	});
}

function getServiceMonths(){
	var retdDate=$("#retdDate").val();
	var currDate=$("#currentDate").val();					
	var months=Math.abs(currDate.split("/")[2]-retdDate.split("/")[2])*12;	
	months-=Number(currDate.split("/")[1]);
	months+=Number(retdDate.split("/")[1]);
	serviceMonths = (months<=0)?0:months;
}
 
 
 
 