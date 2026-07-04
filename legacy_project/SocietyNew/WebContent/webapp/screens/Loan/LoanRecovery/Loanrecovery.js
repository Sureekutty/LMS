var currDate = '';
var minDepositDuration = 0;
var maxDepositDuration = 0;
var ruleDescriptionForMin = '';
var ruleDescriptionForMax = '';
var durationForMIS = 0;
var durationDescription = '';
var ruleValue = 0;
var minAmount = 0;
var maxAmount = 0;
var multipleFactorDesc = '';
var multipleFactorValue = 0;
$(document).ready(function() {
	
	displayScreenDetails(" Loan Recovery");
	
	clearMemberCodeList = function() {
		var sel = document.getElementById("empCode");
		
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
	getMemberCodeList();

	
	$("#btnClearAll").click(function() {
		window.location="/SocietyNew/webapp/screens/Loan/LoanRecovery/Loanrecovery.jsp";
	});
	

	
	

	$("#btnSave").click(function() {
		if(confirm("Do you want save the Recovery Data")){
			var receiptno;
			var option;
			receiptno = $("#receiptno").val();
			
			if(receiptno =='' || receiptno ==undefined || receiptno=='null' )
				option='SAVE'
			else
				option='UPDATE'
					
			var empcode = $("#empCode").val();
			var memAccNo = empcode.split('-')[3];
			var loanaccno=empcode.split('-')[0];
				if(memAccNo == 'Select' ||memAccNo==''||memAccNo==undefined ){
					alert('Select member');
					return ;
				}
				var principalamt = $('#principalamt').val();
				if(principalamt == 0 || principalamt == undefined){
					alert('Enter Principal Amount ');
					return ;
				}
				var modeOfPay = $('#modeOfPay').val();
				
				if(modeOfPay =='' || modeOfPay == undefined){
					alert('Select ModeOfPay');
					return ;
				}
			
			var Loaninterest = $("#Loanint").val();
			
			var opendate = $('#loanappdate').text();
			var noofinstallments = $('#noofinstallments').text();
			var loansancamt = $('#loansancamt').text();
			var loansanctiondate = $('#loansanctiondate').text();
			var noofinstallpaid = $('#noofinstallpaid').text();
			var principalbal = $('#principalbal').text();
			var interestrate = $('#interestrate').text();
			
			var principalamt = $('#principalamt').val();
			var interestamt = $('#interestamt').val();
			alert("interestamt "+interestamt)
			var loantype = $('#Loantype').val();
			$.post('/SocietyNew/ApplicationForLoan',{
				req : 'saveloanrecovery',
				memAccNo:memAccNo,
				loanaccno:loanaccno,
				Loaninterest:Loaninterest,
				opendate:opendate,
				noofinstallments:noofinstallments,
				loansancamt:loansancamt,
				loansanctiondate:loansanctiondate,
				noofinstallpaid : noofinstallpaid,
				principalbal:principalbal,
				interestrate:interestrate,
				modeOfPay:modeOfPay,
				principalamt :principalamt,
				interestamt :interestamt,
				loantype:loantype,
				receiptno:receiptno,
				option:option,
			},function(data){
				
				try {
					var popData = eval("("+data+")");
					if(popData.success == 'y'){
						alert("Loan Recovery No is :"+popData.memaccNonew + "\n  Loan Recovery Details Saved Successfully");
						$('#btnSave').prop('disabled',true);
					}else if(popData.success == 'u'){
						alert("Loan Recovery Details Saved Successfully");
						$('#btnSave').prop('disabled',true);
					}
					
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Recovery Saved Details ' +e.message)
				}
				
			});
	
		}
	})
	
});

getInterestRate = function(opendate,memeaccno,loantype,principleamount) {
	
	
	
	var date1 = opendate.split('/')[0];
	var date2=opendate.split('/')[1];
	var date3=opendate.split('/')[2];
	var tanscdate =date2.trim()+"/"+date1.trim()+"/"+date3.trim();
	
	 var d = new Date();
	 var presedate = d.toLocaleDateString();
		var presedate1 = presedate.split('/')[0];
		var presedate2=presedate.split('/')[1];
		var presedate3=presedate.split('/')[2];
		var currdate =presedate2.trim()+"/"+presedate1.trim()+"/"+presedate3.trim();
		
		var datetrnsc = new Date(""+tanscdate+"");
		var datecurr = new Date(""+currdate+"");
		var timeDiff = Math.abs(datecurr.getTime() - datetrnsc.getTime());
		//alert("datetrnsc "+datetrnsc+" datecurr "+datecurr)
		var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
		
		$.post('/SocietyNew/LoanApplication',{
		req : 'getInterestRateloan',
		opendate:opendate,
		memeaccno:memeaccno,
		loantype:loantype,
		},function (data) {
	
			try {
		
				var popData = eval("("+data+")");
				var interestRate = (popData.INTERESTRATELOAN);
				$('#Loanint').val(interestRate.toFixed(1));
				var interest=$('#Loanint').val();
				//var interestamount=(parseInt(principleamount)*((interestRate))*diffDays)/36500;
				var interestamount=parseInt((principleamount*interestRate)/1200);
				interestamount=parseInt((interestamount*diffDays)/31);
				$('#interestamt').val(parseInt(interestamount));
				$('#interestamt').prop('disabled',true);
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getInterestRateloan ' +e.message)
			}
		});
		}


function getMemberCodeList() {
	clearMemberCodeList();
	$.post('/SocietyNew/genericsDetails',{
			type : 'SANCTION',
			req:'employeeList',
			regstatus : 'R',
			
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
				//var valueOfAccNo = temp.split('-')[0];
				var valueOfAccNo = temp;
				option.value=valueOfAccNo;
				sel.add(option);
			}
			$("#empCode").trigger("chosen:updated");
			//$("#empCode").prop("disabled" ,false);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
	});
}


// I have to ask with sir how that numericKey is working.

function numericKey(e) {
	var evt_mozila = window.event || e;
	if (evt_mozila) {
		var charcode = evt_mozila.keyCode || evt_mozila.which;
		if ((charcode > 31) && (charcode < 46) || (charcode > 57)) {
			alert("Enter Number!!");
			return false;
		}
		return true;
	}
}
