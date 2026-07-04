var ifUpdate=true;

	checkEmp=function(){
		var memAccnountNumber=$('#memAccnountNumber').val();
	
		if(memAccnountNumber=='' || memAccnountNumber=='null' ||memAccnountNumber==undefined){
			$('#applNumber').text("");
			$('#btnPrint,#btnPrint1').prop('disabled',true);
			
		}else{
		$('#applNumber').text(memAccnountNumber);
		$('#btnPrint').prop('disabled',false);
		}
		//getAllMemberCodeList()
		
		if(memAccnountNumber=='null'){
			return;
		}
		
		$.post('/SocietyNew/Membership',{
			req:'staffgetMemberInfo',
			sel : memAccnountNumber,
			option : 'STAFFLOADEMPDATA',
	},function (data) { 
		
		try {
			var pop_data = eval("("+data+")");
			
		//--------MemberDetails-----------//
			$('#memberName').val(pop_data.empDetails[0].EMPLOYEENAME);
			$('#basicpay').val(pop_data.empDetails[0].BASICPAY);
			$('#Dateofbirth').val(pop_data.empDetails[0].DATEOFBIRTH);
			
		//---------Personal Details------------//	
			$('#mailId').val(pop_data.empDetails[0].MAILOID);
			$('#panNumber').val(pop_data.empDetails[0].PANNO);
			$('#aadharNumber').val(pop_data.empDetails[0].AADHAR);
			$('#phoneNumber').val(pop_data.empDetails[0].PHONE);
			$('#officeno').val(pop_data.empDetails[0].OFFICEPHONE);
			$('#careOf').val(pop_data.empDetails[0].CAREOF);
			$('#memremarks').val(pop_data.empDetails[0].REMARKS);
			//--------Society Details------------------//
			$('#sharesallot').val(pop_data.societyDetails[0].NoOfShares);
			$('#thriftSubAmt').val(pop_data.societyDetails[0].ThriftSubscriptionAmount);
			$('#shareamt').val(pop_data.societyDetails[0].ShareAmount);
			$('#thriftAmount').val(pop_data.societyDetails[0].ThriftBalance);
			//-------BankDetails--------//
			findgrid2.setContent(pop_data.bankDetails);
			//----------MemberAddress--------//
			findgrid1.setContent(pop_data.addDetails);
			
		} catch (e) {
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
	});
		
	}
	
	
	

$(document).ready(function(){
	
	
	$('#SbtnClearAll').click(function() {
	
		clearAllValues();
	});

	clearAllValues = function() {

		window.location = "/SocietyNew/webapp/screens/Members/StaffMembers/Staffmembers.jsp";
	
	}
	
	AddBank = function(){
		
		var bankaccno=$('#bankaccno').val();
		if(bankaccno==''||bankaccno==undefined)
			{
			alert("Enter Bank Account No")
			return;
			}
		
		var ifsccode=$('#ifsccode').val();
		if(ifsccode==''||ifsccode==undefined)
			{
			alert("Enter IFSC Code")
			return;
			}
		
		var bankname=$('#bankname').val();
		if(bankname==''||bankname==undefined)
			{
			alert("Enter Bank Name")
			return;
			}
		
		var bankplace=$('#bankplace').val();
		if(bankplace==''||bankplace==undefined)
			{
			alert("Enter Bank Place")
			return;
			}
		
		var bankaccno=$('#bankaccno').val().toUpperCase();
		var ifsccode=$('#ifsccode').val().toUpperCase();
		var bankname=$('#bankname').val().toUpperCase();
		var bankplace=$('#bankplace').val().toUpperCase();
		
		
		 var GridData=Sigma.$grid("gridbank");
		 var data3=GridData.dataset.data;
		 var val=JSON.stringify(data3);
		 var str=val;
		if(str.includes(bankaccno)){
			alert("Bank Account No :"+bankaccno+"  Already Inserted ,Change Bank Account Details");
			return;
		}else{
		var data={'BankAccNo':bankaccno,'Ifsccode':ifsccode,'Bankname':bankname,'Bankplace':bankplace};
		
		var addlist=findgrid2.dataset.data;
		
		addlist.push(data);
		
		findgrid2.setContent(addlist);
		findgrid2.refresh();
		}
	}
	
	
	Addaddress = function(){
		
		var add1=$('#address1').val();
		if(add1==''||add1==undefined)
			{
			alert("Enter 1st Address")
			return;
			}
		
		var add2=$('#address2').val();
		if(add2==''||add2==undefined)
			{
			alert("Enter 2nd Address")
			return;
			}
		
		var addcity=$('#city').val();
		if(addcity==''||addcity==undefined)
			{
			alert("Enter city")
			return;
			}
		
		var adddistrict=$('#District').val();
		if(addcity==''||addcity==undefined)
			{
			alert("Enter District")
			return;
			}
		
		var addpin=$('#pincode').val();
		if(addpin==''||addpin==undefined)
			{
			alert("Enter pincode")
			return;
			}
		var addstate=$('#state').val();
		if(addstate==''||addstate==undefined)
			{
			alert("Enter state")
			return;
			}
		var Remarks=$('#Remarks').val();
		if(Remarks=='')
			{
			alert("Enter Remarks")
			return;
			}
		var Remarks=$('#Remarks').val().toUpperCase();
		var address1=$('#address1').val().toUpperCase();
		var address2=$('#address2').val().toUpperCase();
		var city=$('#city').val().toUpperCase();
		var pincode=$('#pincode').val().toUpperCase();
		var state=$('#state').val().toUpperCase();
	
		
		var data={'Address1':address1,'Address2':address2,'City':city,'District':adddistrict,'Pincode':pincode,'State':state,'Remarks':Remarks,'AddressId' :""};
		
		var addlist=findgrid1.dataset.data;
		
		addlist.push(data);
		
		findgrid1.setContent(addlist);
		findgrid1.refresh();
		
	}
	

//------------------------save and submit----------------------//


$('#SbtnSaveAndSubmit').click(function() {
	
	var memAccnountNumber = $('#memAccnountNumber').val();
	var  option;
	if(memAccnountNumber=='' || memAccnountNumber=='null' ||memAccnountNumber==undefined){
			 option="SSUBMIT"
	}else{
		 option="SSUBMITUPDATE"
	}
	
	
if(confirm("Do you want submit the Record")){
	
		if(svalidateSave()){	
	    var nameOfTheMember = $('#memberName').val();
	    var basicpay = $('#basicpay').val();
		var Dateofbirth = $('#Dateofbirth').val();
		var mailId = $('#mailId').val();
		var panNumber = $('#panNumber').val();
		var aadharNumber = $('#aadharNumber').val();
		var officeno = $('#officeno').val();
		var careOf = $('#careOf').val();
		var phoneNumber = $('#phoneNumber').val(); 
		// Society Details
	
		var sharesallot = $('#sharesallot').val();
		
		var thriftSubAmt = $('#thriftSubAmt').val();
		if(thriftSubAmt == '' || thriftSubAmt == undefined)
			thriftSubAmt = 0;
		
		var shareamt = $('#shareamt').val();
		
		var remarks = $('#memremarks').val();
		
		var thriftAmount = $('#thriftAmount').val();
		if(thriftAmount >1500000){
		alert("Thrift Amount should not be greater than 1500000")
		return;
		}
		if(thriftAmount == '' || thriftAmount == undefined  )
			thriftAmount = 0;
		
		
		
		// bank Details
		var grid2=Sigma.$grid("gridbank");
			
			var igrid2=JSON.stringify(grid2.dataset.data);
			
			if(igrid2 == ''|| igrid2=="[]"){
				alert('Enter Bank Details');
				return ;
			}
			

//Address details
		
		var grid1=Sigma.$grid("grid1");
		var igrid1=JSON.stringify(grid1.dataset.data);
		
		if(igrid1 == ''|| igrid1 =="[]"){
				alert('Enter Address  Data');
				return ;
			}
		
		$.post('/SocietyNew/Membership',{
			req : 'ssubmitMember', 
			memAccnountNumber : memAccnountNumber,
			 option: option,
			 nameOfTheMember : nameOfTheMember,
			 basicpay : basicpay , 
			 Dateofbirth : Dateofbirth , 
			 mailId : mailId ,
			 panNumber : panNumber, 
			 aadharNumber : aadharNumber,
			 officeno : officeno,
			 careOf :careOf,
			 phoneNumber : phoneNumber, 			 
			 shareamt : shareamt,
			 sharesallot : sharesallot,
			 thriftSubAmt:thriftSubAmt,
			 thriftAmount:thriftAmount,
			 igrid1:igrid1, 
			 igrid2:igrid2,
			 remarks :remarks,
		},function(data){
			
			try {
				eval_Data = eval("("+data+")");
				if(eval_Data.updated == 'y'){
					alert("Details  Updated Successfully");
					$('#SbtnSaveAndSubmit').prop('disabled',true);
				}else if(eval_Data.success == 'y'){
						alert("Details Submitted Successfully");
						$('#applNumber').text(eval_Data.memaccNonew)
						$('#btnPrint,#btnPrint1').prop('disabled',false);
						$('#SbtnSaveAndSubmit').prop('disabled',true);
				}
					
			
			} catch (e) {
				// TODO: handle exception
				alert('Exception in ' + option + " " + e.message);
			}
		});
		}
		}		
});
//----------------------end-----------------------------\\



displayScreenDetails("Staff Membership");

$("#btnPrint").click(function(){
var EmplCode = (($("#empCodeFromView").val()).split("-"))[0];

var applNumber=document.getElementById("applNumber").value;
if(applNumber=='' || applNumber==undefined){
	
	alert('Application Number Null');
	return ;
}


var req="Genpdfform";
var frm = document.createElement("form");
frm.method="POST";
frm.name="GenPDF_FORM";
frm.action="/SocietyNew/Membership";
document.body.appendChild(frm);

var in1 = document.createElement("input");
in1.type='hidden';in1.name='applNumber';in1.value=applNumber;


var in2 = document.createElement("input");
in2.type='hidden';in2.name='req';in2.value=req;


frm.appendChild(in1); 
frm.appendChild(in2);

frm.submit();


});



$("#btnPrint1").click(function(){
	

	var EmplCode = (($("#empCodeFromView").val()).split("-"))[0];

	var applNumber=document.getElementById("applNumber").value;
	if(applNumber=='' || applNumber==undefined){
		
		alert('Application Number Null');
		return ;
	}
	var req="Genpdfformmonthly";
	var frm = document.createElement("form");
	frm.method="POST";
	frm.name="GenPDF_FORM";
	frm.action="/SocietyNew/Membership";
	document.body.appendChild(frm);

	var in1 = document.createElement("input");
	in1.type='hidden';in1.name='applNumber';in1.value=applNumber;


	var in2 = document.createElement("input");
	in2.type='hidden';in2.name='req';in2.value=req;


	frm.appendChild(in1); 
	frm.appendChild(in2);

	frm.submit();
	});
});

	var sharePrice = 10;
	var minimumShares = 0;
	var save_update = '';
	var regStatus = "";
	var memAccnountNumber = $('#memAccnountNumber').val();
	
	var empCodeFromView = $('#empCodeFromView').val();
	
	regStatus = $('#typeOfSearch').val();
	
	remarks = $('#remarks').val();
	var remarks = '';
	clearMemberCodeList = function() {
		var sel = document.getElementById("empCode");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
		
			sel.remove(i);
		}
	}
	if(memAccnountNumber != undefined){
	if(memAccnountNumber.length == 5){
		
		save_update = '';
		clearMemberCodeList();
		
		 $.post('/SocietyNew/Membership',{
	        	req : 'getMemberDetailsForEditing',
	        	memAccnountNumber : memAccnountNumber,
	        	empCodeFromView : empCodeFromView,regStatus:regStatus,
	        	
	        },function(data){
	        	
	        	try {
					var evan_Data = eval("("+data+")");
					var memberdetails  = evan_Data.MEMBERDETAILS;
	        		$('#group6,#memberName').show();
	        		regStatus = $('#typeOfSearch').val();
	        		remarks = $('#remarks').val();
	        		save_update = 'UPDATE';
	        		$('#typeOfRelation,#btnSave').prop('disabled',false)
	        		setValuesToFields(memberdetails,"ExistingMember");
				} catch (e) {
					// TODO: handle exception
					alert('Exception in getMemberDetailsForEditing ' +e.message);
				}
	        });
		
	}
	}
	
	
	var eval_Data ;
	var memFind = false;
	$(function() {
		$( "#tabs" ).tabs();
	});

	clearLableValues = function(){
		$('#group6').find('.label').val("");
	}
	
	enablenomineeDetailsFields = function() {
		$('#nomineeDetails').find(':text').not('[id =relationWithMember]').prop('disabled',false);
		$('#nomineeGender,#namineeDOB,#typeOfRelation').prop('disabled',false);
	}
	
	enablesocietyDetailsFields = function() {
		$('#societyDetails').find(':text').not('[id = membershipDate],[id = entranceAmount]').prop('disabled',false);
		$('#membershipDate').prop('disabled',false);
	}


	
	
	clearAllValues();
	
	clearValues = function() {
	//alert("alert")
		$('#group6').hide();
		$('#bankNumber,#memberAccountNumberBank,#ifscCode,#bankName,#bankAddress').val("");
		$('#membershipDate,#entranceAmount,#sharesallot,#shareamt,#thriftSubAmt,#thriftAmount').val("");
		$('#nomineeName,#typeOfRelation').val("");
		//$('#empCode').prop('disabled',false);
		
	
	}
	
	  
    GetMemberDeatails=function(memAccNo,empCode,regStatus,remarks){
    	
    	//$('#memberAccountNumberNom,#memberAccountNumberSociety,#memberAccountNumberBank').text("");
    	
    	clearMemberCodeList = function() {
    		
    		var sel = document.getElementById("empCode");
    		var options = sel.options;
    		for(var i=options.length; i> 0; i--){
    			sel.remove(i);
    		}
    	}
    	$.post('/SocietyNew/Membership',{
    		req:'getMemberDetailsForEditing',
    		memAccnountNumber : memAccNo,
        	empCodeFromView : empCode,regStatus:regStatus,remarks:remarks,
    	},function(data){
        	try {
				var evan_Data = eval("("+data+")");
				var memberdetails  = evan_Data.MEMBERDETAILS;
        		$('#group6,#memberName').show();
        	
//        		$('#typeOfRelation,#btnSave').prop('disabled',true)
        		setValuesToFields(memberdetails,"ExistingMember");
        		$(':input').prop("disabled",true);
        		
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getMemberDetailsForEditing ' +e.message);
			}
        })
    };
	

	
	$('#bankDetails,#personalDetails,#nomineeDetails').find(':text').change(function() {
		if(save_update == 'UPDATE'){
			$('#btnSave').prop('disabled',false);
		}
	});

	
	