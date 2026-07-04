var elgAmount =0;
var joiningdate;

checkEmp=function(){
	var receiptno=$('#receiptno').val();

	var memAccno=$('#memAccno').val();
	var purposecode=$('#purposecode').val();

	if(receiptno=='null' || receiptno==""){
		receiptno="";
		return;
	}

	$.post('/SocietyNew/RecieptController',{
		req:'getRecieptInfo',
		receiptno : receiptno,
		memAccno : memAccno,
		purposecode :purposecode,
	},function (data) {


		try {
			var pop_data = eval("("+data+")");

			$('#Amount').val(pop_data.ReceiptDetails[0].Amount);
			$('#recieptDate').val(pop_data.ReceiptDetails[0].ReceiptDate);
			$('#ReceiptNo').text(pop_data.ReceiptDetails[0].ReceiptNo);

			var month=pop_data.ReceiptDetails[0].Month;
			var mon=month.split("/")[0];

			var year=month.split("/")[1];

			$('#recieptMonth').val(mon);
			$('#recieptYear').val(year);
			getmonth(mon);
			getyear(year);
			getMemberCodeListacc(pop_data.ReceiptDetails[0].MemAccNo);
			getReceiptsPurpose(pop_data.ReceiptDetails[0].PurposeCode);
			var refnumber=pop_data.ReceiptDetails[0].PurposeCode;
			if(refnumber=='D08' || refnumber=='M03' || refnumber=='D20' ){
				//getLoanRefNumbers(pop_data.ReceiptDetails[0].MemAccNo,pop_data.ReceiptDetails[0].PurposeCode,pop_data.ReceiptDetails[0].RefNo);
				$("#monthfield").show();
			}else{
				$("#appNumber").prop('disabled',true).trigger("chosen:updated")
				$("#monthfield").hide();

			}
			getModeOfPayments(pop_data.ReceiptDetails[0].ModeOfPayment);
		} catch (e) {
			alert('Exception in checkEmp ' +e.message)
		}
	});

}



$(document).ready(function() {
	$(".chosen-select").chosen();
	displayScreenDetails("Reciept ");
	getMemberCodeList = function(type) {

		$.post('/SocietyNew/genericsDetails',{
			type : type,req:'employeeList',regstatus : 'R',
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
	getReceipts = function() {
		$.post('/SocietyNew/genericsDetails',{
			req : 'receiptsAndPayments',
			recordType : 'RECEIPTS',
		},function(data){

			try {
				var pop_data = eval("("+data+")");

				var arr = new Array();
				arr = pop_data.payment;
				var sel = document.getElementById("purpose");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					option.text=arr[i].DESCRIPTION;
					option.value=arr[i].PAYMENTCODE;

					sel.add(option);
				}
				$("#purpose").trigger("chosen:updated");
			} catch (e) {
				// TODO: handle exception
				alert('Exception in receiptsAndPayments ' +e.message)
			}
		});
	}

	/*	getLoanRefNumber = function(memcode,purpose) {
			//clearRefNuList();
			$.post('/SocietyNew/RecieptController',{
				req : 'getReferenceNumber',
				memcode : memcode,
				purpose:purpose,
				},
				function(data){

					try {
						var pop_data = eval("("+data+")");
						if(pop_data.ERROR = 'NO'){
							var arr = new Array();
							arr = pop_data.ReferenceDetails;
							if(arr.length <= 0){
								alert('Reference  Application Number not found')
								    $("#appNumber").prop('disabled',true).trigger("chosen:updated");
									$("#modeOfPay").prop('disabled',true).trigger("chosen:updated");
									 $('#recieptDate').prop('disabled',true)
									 	$("#recieptMonth").prop('disabled',true).trigger("chosen:updated");
										$("#recieptyear").prop('disabled',true).trigger("chosen:updated");
		                            $('#Amount').prop('disabled',true)
		                             $('#SaveBtn').prop('disabled',true)
								return;
							}

							var sel = document.getElementById("appNumber");
							var option=document.createElement("option");
							var options=sel.options;
							for(var i=options.length-1;i>0;i--){
								sel.remove(i);
							}
							var sel = document.getElementById("appNumber");
							for(var i=0;i<arr.length;i++){	
								var option=document.createElement("option");
								option.text=arr[i].refNum;
								option.value=arr[i].refNum;
								sel.add(option);
							}
							$("#appNumber").trigger("chosen:updated").prop('disabled',false);
						}

					} catch (e) {
						// TODO: handle exception
						alert('Error in loadind reference numbers ' +e.message)
					} 

				});
		}*/




	$("#Link").click(function(){
		var PurposeCode=$('#purpose').val()

		if(PurposeCode=="M03"){
			var MemAccNO = (($('#memCode').val()).split(","))[0];
			var PurposeCode=$('#purpose').val()
			var ReceiptNo=$('#ReceiptNo').text()
			var req="Genpdfform";
			var frm = document.createElement("form");
			frm.method="POST";
			frm.name="GenPDF_FORM";
			frm.action="/SocietyNew/RecieptController";
			document.body.appendChild(frm);

			var in1 = document.createElement("input");
			in1.type='hidden';in1.name='PurposeCode';in1.value=PurposeCode;

			var in2 = document.createElement("input");
			in2.type='hidden';in2.name='MemAccNO';in2.value=MemAccNO;

			var in3 = document.createElement("input");
			in3.type='hidden';in3.name='req';in3.value=req;

			var in4 = document.createElement("input");
			in4.type='hidden';in4.name='ReceiptNo';in4.value=ReceiptNo;


			frm.appendChild(in1); 
			frm.appendChild(in2);
			frm.appendChild(in3);
			frm.appendChild(in4);
			frm.submit();
		}else{
			var MemAccNO = (($('#memCode').val()).split(","))[0];
			var req="MemGenpdfform";
			var frm = document.createElement("form");
			frm.method="POST";
			frm.name="GenPDF_FORM";
			frm.action="/SocietyNew/RecieptController";
			document.body.appendChild(frm);

			var in2 = document.createElement("input");
			in2.type='hidden';in2.name='MemAccNO';in2.value=MemAccNO;

			var in3 = document.createElement("input");
			in3.type='hidden';in3.name='req';in3.value=req;

			frm.appendChild(in2);
			frm.appendChild(in3);
			frm.submit();
		}


	});


	$("#SaveBtn").click(function() {
		var option="";
		var recieptMonth="";
		var ReceiptNo=$('#ReceiptNo').text();
		if(ReceiptNo=="" || ReceiptNo== null)
		{
			option='SAVE';
		}
		else
		{
			option='UPDATE';
		}
		var MemAccNO = (($('#memCode').val()).split(","))[0];
		var PurposeCode=$('#purpose').val()
		var referenceNumber = $('#appNumber').val();
		if(PurposeCode=='L34' || PurposeCode=='L35')
			referenceNumber=referenceNumber.split("~")[0];
		if(referenceNumber == undefined || referenceNumber == ''){
			referenceNumber = MemAccNO;
		}
		/*else{
		 referenceNumber  =referenceNumber.split("-")[0]
		 }*/
		var ModeOfPayment=$('#modeOfPay').val()
		var ReceiptDate =$('#recieptDate').val()
		var recieptyear=$('#recieptyear').val()


		recieptMonth =$('#recieptMonth').val()

		if(recieptMonth == undefined || recieptMonth == ''){
			recieptMonth="";
		}else{
			if(recieptyear == undefined || recieptyear == ''){
				alert("Receipt Year")
			}

			var month=recieptMonth+"/"+recieptyear;
			recieptMonth=month;
		}

		var Amount=$('#Amount').val()

		var Remarks=$('#Remarks').val()
		if(Remarks == undefined || Remarks == ''){
			alert("Enter Remarks")
		}

//		alert(ReceiptNo +" option "+option)
		if(validateSave()){
			var check=confirm("click ok to continue");
			if(check){
				$.post('/SocietyNew/RecieptController', {
					req : 'SaveReciept',
					option:option,
					MemAccNO : MemAccNO,
					PurposeCode : PurposeCode ,	
					recieptMonth : recieptMonth,
					referenceNumber : referenceNumber,
					ModeOfPayment: ModeOfPayment,
					ReceiptDate : ReceiptDate  ,
					Amount      : Amount ,
					ReceiptNo :ReceiptNo,
					Remarks:Remarks,
				},function(data){
					try {

						var pop_data = eval("("+data+")");
						if(pop_data.SUCCESS == "Y"){
							alert('Saved successfully' );
							$('#ReceiptNo').text(pop_data.ReceiptNumber);
							if(PurposeCode=="M03"){
								var str = "Thrift Ledger";
								document.getElementById("Link").innerHTML = str;
								$('#Link').show();
							}
							$('#btnSave').prop('disabled',true);
							$(':input:not([id=btnClearAll])').prop('disabled',true);
							$('#memCode,#purpose,#modeOfPay').prop('disabled',true).trigger("chosen:updated");
						}
						if(pop_data.success == 'y')
							alert('Updated successfully' );						 


					} catch (e) {
						// TODO: handle exception
						alert("Error in parsing data "+e);
					}
				});
			}
		}




	});

	getMemberCodeList("SOCIETYMEM");


	var dt_obj= new Date();
	var current_month=dt_obj.getMonth()+1;
	var month = new Array("","January","February","March","April","May","June","July","August","September","October","November","December");
	for (var i=1; i < month.length;++i){
		var sel = document.getElementById("recieptMonth");
		var option=document.createElement("option");
		var temp = month[i];
		option.text=temp;	
		option.value=i;
		sel.add(option);
	}
	$("#recieptMonth").trigger("chosen:updated");


	var current_year=dt_obj.getFullYear();


	var year = new Array(current_year-1,current_year,current_year+1,current_year+2);

	for (var i=0; i < year.length;++i){
		var se = document.getElementById("recieptyear");
		var option=document.createElement("option");
		var temp = year[i];
		option.text=temp;	
		option.value=temp;
		se.add(option);
	}
	/*	


	var se = document.getElementById("recieptyear");
	var option=document.createElement("option");
	option.text=current_year;
	option.value=current_year;
	se.add(option);
	$("#recieptyear").val(current_year);*/
	$("#recieptyear").trigger("chosen:updated");	

});


clearScreens = function() {

}
clearScreens();
//........................................

function getmonth(monthval){
	var dt_obj= new Date();
	var current_month=dt_obj.getMonth()+1;
	var month = new Array("","January","February","March","April","May","June","July","August","September","October","November","December");
	for (var i=1; i < month.length;++i){
		var sel = document.getElementById("recieptMonth");
		var option=document.createElement("option");
		var temp = month[i];
		option.text=i;	

		if(monthval==i){
			option.value=i;
			sel.add(option);
			$("#recieptMonth").val(i);
			$("#recieptMonth").trigger("chosen:updated");
		}
		option.value=i;
		sel.add(option);
	}
	$("#recieptMonth").trigger("chosen:updated");
}


function getyear(yearval){
	var dt_obj= new Date();
	var current_year=dt_obj.getFullYear();
	var next_year=current_year+1;

	var year = new Array(current_year,next_year);
	for (var i=0; i < year.length;++i){
		var sel = document.getElementById("recieptyear");
		var option=document.createElement("option");
		var temp = year[i];
		option.text=temp;	
		if(yearval==temp){
			option.value=temp;
			sel.add(option);
			$("#recieptyear").val(temp);
			$("#recieptyear").trigger("chosen:updated");
		}
		option.value=temp;
		sel.add(option);
	}
	$("#recieptyear").trigger("chosen:updated");
}






//..................................
function getMemberCodeListacc(memAccNo) {
	alert("inside getMember function")
	$.post('/SocietyNew/genericsDetails',{
		type : 'SOCIETYMEM',
		req:'employeeList',
		regstatus : 'ACTIVE',
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
				var string = temp.split('-')[0];

				if(memAccNo==string){

					$("#memCode").val(string);
					option.value=string;
					sel.add(option);
					$("#memCode").trigger("chosen:updated").prop("disabled" ,true);
				}
				option.value=string;
				sel.add(option);
			}
			$("#memCode").trigger("chosen:updated").prop("disabled" ,true);


		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
	});
}
//---------------------------------------------------

getReceiptsPurpose = function(purpose) {
	$.post('/SocietyNew/genericsDetails',{
		req : 'receiptsAndPayments',
		recordType : 'RECEIPTS',
	},function(data){
		try {
			var pop_data = eval("("+data+")");

			var arr = new Array();
			arr = pop_data.payment;
			var sel = document.getElementById("purpose");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				option.text=arr[i].DESCRIPTION;
				//option.value=arr[i].PAYMENTCODE;
				if(purpose==arr[i].PAYMENTCODE)
				{
					option.value=arr[i].PAYMENTCODE;
					sel.add(option);
					$("#purpose").val(arr[i].PAYMENTCODE);
					$("#purpose").trigger("chosen:updated").prop("disabled" ,true);
				}
				option.value=arr[i].PAYMENTCODE;
				sel.add(option);
			}
			$("#recieptMonth,#recieptYear").trigger("chosen:updated").prop('disabled',false);
			$("#purpose").trigger("chosen:updated").prop("disabled" ,true);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in receiptsAndPayments ' +e.message)
		}
	});
}
//---------------------------------------------------------
/*getLoanRefNumbers = function(memcode,purpose,RefNo) {
	$.post('/SocietyNew/RecieptController',{
		req : 'getReferenceNumber',
		memcode : memcode,
		purpose:purpose,
		},
		function(data){

			try {
				var pop_data = eval("("+data+")");
				if(pop_data.ERROR = 'NO'){
					var arr = new Array();
					arr = pop_data.ReferenceDetails;

					var sel = document.getElementById("appNumber");
					var option=document.createElement("option");
					var options=sel.options;
					for(var i=options.length-1;i>0;i--){
						sel.remove(i);
					}
					var sel = document.getElementById("appNumber");
					for(var i=0;i<arr.length;i++){	
						var option=document.createElement("option");
						var string=arr[i].refNum.split("-")
						option.text=arr[i].refNum;

						if(RefNo==string[0])
						{
						option.value=arr[i].refNum;
		 				sel.add(option);
						$("#appNumber").val(arr[i].refNum);
						$("#appNumber").trigger("chosen:updated").prop("disabled" ,false);
						}
						option.value=arr[i].refNum;
						sel.add(option);
					}
					$("#modeOfPay").trigger("chosen:updated").prop("disabled" ,false);			
					$("#appNumber").trigger("chosen:updated").prop('disabled',false);
					$("#recieptDate").trigger("chosen:updated").prop('disabled',false);
					$("#Amount").trigger("chosen:updated").prop('disabled',false);
				}

			} catch (e) {
				// TODO: handle exception
				alert('Error in loadind appNumber ' +e.message)
			} 

		});
}*/
//---------------------------------------------------------
function  getModeOfPayments(ModeOfPayment)
{
	var sel = document.getElementById("modeOfPay");
	var option=document.createElement("option");
	//option.text=ModeOfPayment;
	option.value=ModeOfPayment;
	sel.add(option);
	$("#modeOfPay").val(ModeOfPayment);
	$("#modeOfPay").trigger("chosen:updated").prop("disabled" ,false);			
}
//---------------------------------------------------------
function getMemberInfo(memAccNo,code){
	$.post('/SocietyNew/Membership',{
		req:'memInfo',memAccNo : memAccNo,code : code,
	},function (data) {
		try {
			var pop_data = eval("("+data+")");
			//alert(" joining date "+pop_data.empInfo[0].MemDate+" mem acc no "+pop_data.empInfo[0].MemAccNo);
			if(pop_data.empInfo.length>0){
				joiningdate=pop_data.empInfo[0].MemDate;
				if(code=="M06")			// share capital
					$('#prvAmount').val(pop_data.empInfo[0].ShareAmount)
				if(code=="M43")			// thrift deposit
					$('#prvAmount').val(pop_data.empInfo[0].ThriftBalance)
				// for interest and part payment
				if(code == "L25" || code == "L26" || code == "L27" || code == "L30" || code == "L31" || code == "L32" ){		
				//	$('#appNumber').val(pop_data.empInfo[0].appNumber)
					var sel = document.getElementById("appNumber");
					var option=document.createElement("option");
					var options=sel.options;
					for(var i=options.length-1;i>0;i--){
						sel.remove(i);
					}
						$("#appNumber").append("<option value='"+pop_data.empInfo[0].appNumber+"'>"+pop_data.empInfo[0].appNumber+"</option>");
						$("#appNumber").val(pop_data.empInfo[0].appNumber).trigger("chosen:updated");
						$("#appNumber").prop("disabled" ,false);
					$('#prvAmount').val(pop_data.empInfo[0].prvAmount)
				}
				if(code =='L34' || code =='L34'){
					var sel = document.getElementById("appNumber");
					var option=document.createElement("option");
					var options = sel.options;
					for(var i=options.length; i> 0; i--){
						sel.remove(i);
					}	
					getFDLoan(memAccNo)
				}
			}
			else{
				alert("No loan data is available");
			}

		} catch (e) {
			// TODO: handle exception
			alert('Exception in getting member info ' +e.message)
		}		
	});
}



//----------------------------------------------------------
//get fd number of respected employee
 function getFDLoan(memAccNo) {
	$.post('/SocietyNew/LoanApplication',{
		req : 'FDLLoan',
		memAccNo:memAccNo,		
	},
	function(data) {		
		var pop_data = eval("("+data+")");
		if(pop_data.SUCCESS=="Y"){
		var arr = new Array();
		arr = pop_data.DEPOSITSDETAILS;
		
			if(arr.length > 0){
			var sel = document.getElementById("appNumber");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp =arr[i].LoanAccNo;				
				option.text=temp;
				option.value=arr[i].AmountNo;
				sel.add(option);
				}
			//$("#appNumber").chosen();
			$("#appNumber").trigger("chosen:updated");
			$("#appNumber").prop("disabled" ,false);
			}
		return;
		}
		else{
			
			alert('No Fixed Deposits for this member account ' + memAccNo)
			$("#appNumber").trigger("chosen:updated");
			$("#appNumber").prop("disabled" ,true);
			return;
		}		
	});
}
//--------------------------------------------------------------------------------------

function numericKey(e) {
	var evt_mozila = window.event || e;
	if (evt_mozila) {
		var charcode = evt_mozila.keyCode || evt_mozila.which;
		if ((charcode > 31) && (charcode < 46) || (charcode > 57)) {
			alert("Enter Number !!");
			return false;
		}
		return true;
	}
}