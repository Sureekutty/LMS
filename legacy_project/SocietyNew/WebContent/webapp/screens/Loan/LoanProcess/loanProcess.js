



$(document).ready(function() {
	
	displayScreenDetails(" Loan Process");

	$("#btnClearAll").click(function() {
		
		clearAllTheFields();
		
	});
	
	
	isValidSettlement =function(){
		var memCode=$('#memCode').val();
		if(null==memCode||""==memCode||undefined==memCode){
			alert("Select Member Code");
			return false;
		}
		var LoanAppNo=$('#LoanAppNo').val();
		if(null==LoanAppNo||""==LoanAppNo||undefined==LoanAppNo)
			{
			alert("select Loan Application Number")
			return false;
			}
		var Process=$('#Process').val();
		if(null==Process||""==Process||undefined==Process)
		{
			alert("select Process type")
			return false;
		}
		var priBal=$('#priBal').text();
		if(null==priBal||""==priBal||undefined==priBal)
		{
			return false;
		}
		var IntrBal=$('#IntrBal').text();
		if(null==IntrBal||""==IntrBal||undefined==IntrBal)
		{
			return false;
		}
		var settlAmt=$('#settlAmt').text();
		if(null==settlAmt||""==settlAmt||undefined==settlAmt)
		{
			return false;
		}
		return true;
	
	 }

getMemberCodeList = function(type) {
		
		$.post('/SocietyNew/genericsDetails',{
				type : type,
				req:'employeeList',
				regstatus : 'R',
		},function (data) {
			
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.EMPLOYEELIST;
				
				var sel = document.getElementById("memCode");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
					option.text=temp;
					option.value=temp.split("-")[0];
					sel.add(option);
				}
				$("#memCode").trigger("chosen:updated");
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeCodeList ' +e.message)
			}
			
		});
	}		

getMemberCodeList("SOCIETYMEM");


$('#memCode').change(function() {
	var memAccNo=this.value;
	fetchLoanAppNo(memAccNo);
	if(memAccNo!=null||memAccNo!=''){
		$("#LoanAppNo").prop('disabled',false);
		$("#Process").val('').trigger("chosen:updated");
		$("#Process").prop('disabled',true).trigger("chosen:updated");
		$('#priBal,#IntrBal,#settlAmt').text("");
		$('#priBalTR,#IntrBalTR,#settlAmtTR,#chngInst,#monthlyInstAmnt,#RecieptNoTR,#remarks').hide();
		$('#btnSave,#btnClearAll').prop('disabled',true);
	}else{$("#LoanAppNo").prop('disabled',false);}
	
})

	
	clearAllTheFields = function(){
	$('#priBalTR,#IntrBalTR,#settlAmtTR,#chngInst,#monthlyInstAmnt,#RecieptNoTR,#remarks').hide();
		$(':input:not([type=button])').val('');
		$("#LoanAppNo,#Process,[type=button]").prop('disabled',true)
		$("#memCode,#LoanAppNo,#Process").val('').trigger("chosen:updated");


}
	//clearAllTheFields();
	
	
	
	fetchLoanAppNo = function(memAccNo) {
		
	$.post('/SocietyNew/LoanProcessController',{
		memAccNo :memAccNo ,
		req:'loanAppNo',
	},function (data) {
	
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.loanAppNo;
			var sel = document.getElementById("LoanAppNo");
			var option=document.createElement("option");
			var options=sel.options;
			
			for(var i=options.length-1;i>0;i--){
				sel.remove(i);
			}

			var sel = document.getElementById("LoanAppNo");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				var value=arr[i];
				option.value=value;
				sel.add(option);
			}
			
			$("#LoanAppNo").trigger("chosen:updated");
			$("#LoanAppNo").prop("disabled" ,false);
			
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getting loan app no ' +e.message)
		}
	});
}
	$('#LoanAppNo').change(function() {
		
		var AppNo=this.value;
		
		if(AppNo!=null){
			$("#Process").prop('disabled',false).trigger("chosen:updated");			
			if(AppNo.substring(0,3) ==='FDL')
				$('#FDLdate').show();
			else
				$('#FDLdate').hide();
		}
		else{
			$("#Process").prop('disabled',true).trigger("chosen:updated");
		}
	});
	
	
	$('#Process').change(function() {
		
		var Process=this.value;
//		alert("process "+Process)
		if(Process=="slmtAmt"){
			$('#priBalTR,#IntrBalTR,#settlAmtTR,#remarks').show();
			$('#chngInst,#monthlyInstAmnt').hide();
			var LoanAppNo=$('#LoanAppNo').val();
			var date = $('#processdate').val();
			fetchSettlementAmt(LoanAppNo,date);
			
			$('#btnSave').prop('disabled',false);
			$('#btnClearAll').prop('disabled',false);
		
		}
		/*else{
			$('#priBalTR,#IntrBalTR,#settlAmtTR').hide();
		}*/
		
		if(Process=="cngOfInst")
		{			
			$('#chngInst').show();
			$('#priBalTR,#IntrBalTR,#settlAmtTR,#monthlyInstAmnt,#remarks').hide();
			var LoanAppNo=$('#LoanAppNo').val();
			getNoOfInst(LoanAppNo);
			$('#btnSave').prop('disabled',false);
			$('#btnClearAll').prop('disabled',false);
		}
		/*else{	
			$('#chngInst,#monthlyInstAmnt').hide();
			}*/
		if(Process=="monthlyInst")
		{
			$('#chngInst,#priBalTR,#IntrBalTR,#settlAmtTR,#remarks').hide();
			$('#monthlyInstAmnt').show();
			var LoanAppNo=$('#LoanAppNo').val();
			getNoOfInst(LoanAppNo);
			$('#btnSave').prop('disabled',false);
			$('#btnClearAll').prop('disabled',false);
		}
//		else{$('#chngInst,#monthlyInstAmnt').hide();}
	});
	

getNoOfInst = function(LoanAppNo) {
		var MemAccNo=$('#memCode').val();
		var Process=$('#Process').val();
		var id;
		if(Process=="cngOfInst")
			id="getNoOfInst";
		else
			id=	"getInstAmnt";
		$.post('/SocietyNew/LoanProcessController',{
			LoanAppNo :LoanAppNo ,
			MemAccNo:MemAccNo,
			req:id,
		},function (data) {
	
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.NoOfInst;
				if(Process=="cngOfInst")
					{
					$('#NumOfInst').val(arr[0]);
					$('#RuleValue').val(arr[1]);
					}
				else
					{
					$('#InstAmnt').val(arr[0]);
					$('#RuleValue').val(arr[1]);
					}
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getting number of interest ' +e.message)
			}
		});
	}

	
  $('#btnSave').click(function() {
	  
	  
	  var check=confirm("click ok to continue");
      if(check){
	  
		   var Process=$('#Process').val();
		  // alert("process "+Process);
		   var LoanAppNo= $('#LoanAppNo').val();
			var MemAccNo=$('#memCode').val();
			var NoOfInst;
			var RuleValue=$('#RuleValue').val();
			var pribalance = $('#priBal').text();
			var intAmount = $('#IntrBal').text();
			alert(pribalance+" -- "+intAmount)
			var date = $('#processdate').val();
			
			var bankName = $('#bankName').val()
		 if(Process=="cngOfInst" || Process=="monthlyInst"){
			 var option;
			 if(Process=="cngOfInst"){
				 NoOfInst=$('#NumOfInst').val()
				 option="update";
			 }
			 // added by pn on 19/05/2025 for Monthly Installment amount told by Rama Rao
			 if(Process=="monthlyInst"){
				 NoOfInst=$('#InstAmnt').val()
				 option="UpdateMonInstAmnt";
				 if(NoOfInst<RuleValue){
					 alert("Monthly Installment Amount should be more than "+RuleValue+" "+option );
					 return;
				 }
			 }
		 $.post('/SocietyNew/LoanProcessController',{		
				Option:option,
				LoanAppNo :LoanAppNo ,
				MemAccNo:MemAccNo,
				NoOfInst:NoOfInst,
				RuleValue:RuleValue,
				pribalance : pribalance,
				intAmount : intAmount,
				date : date,
				req:'UpdateInstallment',
				 },function (data) {
				try {
					var pop_data = eval("("+data+")");
					var arr = new Array();
					arr = pop_data;
					if(pop_data.error=="Y"){
						alert("Number of installments should be 100 or less than 100")
						$('#NumOfInst').val('');
					}else if(pop_data.success=="Y"){
						alert("Data Updated")
					}
					else{
						alert("Data not Updated")
					}
					
				} catch (e) {
					// TODO: handle exception
					alert('Exception in updating loanprocesstypelist ' +e.message)
				}
	      });
     }
		 
		 if(Process=="slmtAmt"){
			 if(isValidSettlement){
				 MemAccNo=MemAccNo+"-"+bankName 
				 alert(MemAccNo)
			 var confim=confirm("Are You Sure \n" +
			 		"click OK to continue")
			 if(confim){
			 $.post('/SocietyNew/LoanProcessController',{
					
					Option:"settle",
					LoanAppNo :LoanAppNo ,
					MemAccNo:MemAccNo,
					//NoOfInst:NoOfInst,
					pribalance : pribalance,
					intAmount : intAmount,
					date : date,
					req:'Settlement',
				},function (data) {
					
					try {
						var pop_data = eval("("+data+")");
						
						if(pop_data.success=="Y"){
						//	$('#priBalTR,#IntrBalTR,#settlAmtTR,#remarks').hide();
							$('#priBal,#IntrBal,#settlAmt,#remarks').text("");
							
							$("#LoanAppNo,#Process").prop('disabled',true).trigger("chosen:updated");;
							alert("Settlement done")
							$('#btnSave').prop('disabled',true);
							
						}
						else{
							
							alert("Settlement not done")
						}
						
					} catch (e) {
						// TODO: handle exception
						alert('Exception in loanprocesstypelist ' +e.message)
					}
				      });
			 
			 }
			 }
			 
		 }
  }
});
	
	
	fetchSettlementAmt = function(LoanAppNo,date) {
		$.post('/SocietyNew/LoanProcessController',{
			LoanAppNo :LoanAppNo ,
			req:'SettlementAmt',
			date:date,
		},function (data) {
			
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.loanAppNo;
				//alert("arr "+arr)
			if(pop_data.ERROR=="N"){
				var priBal=JSON.parse(JSON.stringify(arr[0]));
				var IntrBal=JSON.parse(JSON.stringify(arr[1]));
				
				var priBlnce=$('#priBal').text(priBal);
				var IntrBlnce=$('#IntrBal').text(IntrBal);
			
				var total=(parseFloat(priBal)+parseFloat(IntrBal));

				$('#settlAmt').text(total);
				//alert("pribal "+priBal)
			}
			else{
				alert(pop_data.ERROR);
			}
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in doing loan settlement ' +e.message)
			}
		});
	}	
	
	
	
});


