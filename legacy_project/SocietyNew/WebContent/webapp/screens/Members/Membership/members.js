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
		getAllMemberCodeList()
		var sel= document.getElementById('empCodeFromView').value;
//		alert("sel is "+sel)
		if(sel=='null'){
			return;
		}
	
		$.post('/SocietyNew/Membership',{
			req:'getMemberInfo',
			sel : sel,
			option : 'LOADEMPDATA',
		},function (data) { 
		
		try {
			var pop_data = eval("("+data+")");
			
		//--------MemberDetails-----------//
			$('#nameOfTheMember').text(pop_data.empDetails[0].EMPLOYEENAME);
			$('#division').text(pop_data.empDetails[0].DIVNFULLNAME);
			$('#designation').text(pop_data.empDetails[0].DESGFULLNAME);
			$('#basicPay').text(pop_data.empDetails[0].BASICPAY);
			$('#dateOfBirth').text(pop_data.empDetails[0].DATEOFBIRTH);
			$('#retirementDate').text(pop_data.empDetails[0].RETIREDDATE);
		//---------Personal Details------------//	
			
			$('#applNumber').val(pop_data.personalDetails[0].ApplNo);
			$('#mailId').val(pop_data.personalDetails[0].MailId);
			$('#panNumber').val(pop_data.personalDetails[0].PanNo);
			$('#aadharNumber').val(pop_data.personalDetails[0].AadharNo);
			$('#phoneNumber').val(pop_data.personalDetails[0].Phone);
			$('#officeno').val(pop_data.personalDetails[0].OffPhone);
			$('#careOf').val(pop_data.personalDetails[0].CareOf);
			$('#memremarks').val(pop_data.personalDetails[0].Remarks);
			//--------Society Details------------------//
			
			if(pop_data.societyDetails.length>0){
			$('#sharesallot').val(pop_data.societyDetails[0].NoOfShares);
			$('#thriftSubAmt').val(pop_data.societyDetails[0].ThriftSubscriptionAmount);
			$('#shareamt').val(pop_data.societyDetails[0].ShareAmount);
			$('#thriftAmount').val(pop_data.societyDetails[0].ThriftBalance);
			}else{
			$('#sharesallot').val('');
			$('#thriftSubAmt').val('');
			$('#shareamt').val('');
			$('#thriftAmount').val('');
			}
			
			//-------NomineeeDetails--------//
			findgrid.setContent(pop_data.nomineeDetails);
			//----------MemberAddress--------//
			findgrid1.setContent(pop_data.addDetails);
			//-------BankDetails--------//
			findgrid2.setContent(pop_data.bankDetails);
			
		} catch (e) {
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
	});
		
	}
	
	
	

$(document).ready(function(){
	
	$('#btnClearAll').click(function() {
	
		clearAllValues();
	});

	clearAllValues = function() {

		window.location = "/SocietyNew/webapp/screens/Members/Membership/members.jsp";
		

	}
	
	//----------------Empleonchange------------//
	$('#emplcode').change(function(){
		
		$('#memAccnountNumber').val("");
		$('#applNumber').text("");
		
			var empcode = (($("#emplcode").val()).split("-"))[0];
			var empname = (($("#emplcode").val()).split("-"))[1];
			
			$.post('/SocietyNew/Membership',{
				req : 'gettingempdata',
				empcode:empcode,
				option:'EMPDATA',
			},function(data){
				
				try {
					var pop_data = eval("("+data+")");
					
					$('#sharesallot,#thriftSubAmt,#shareamt').val("");
					
					$('#nameOfTheMember,#division,#designation,#basicPay,#dateOfBirth,#retirementDate').text("");
					
					$('#mailId,#panNumber,#aadharNumber,#phoneNumber,#officeno,#careOf').val("");
					$('#memremarks').val("");
					//$('#bankNumber,#ifscCode,#bankName,#bankAddress,#memremarks').val("");
					
					findgrid.cleanContent();
					findgrid1.cleanContent();
					findgrid2.cleanContent();
					
					$('#nameOfTheMember').text(pop_data.emplDetails[0].EMPLOYEENAME);
					$('#division').text(pop_data.emplDetails[0].DIVNFULLNAME);
					$('#designation').text(pop_data.emplDetails[0].DESGFULLNAME);
					$('#basicPay').text(pop_data.emplDetails[0].BASICPAY);
					$('#dateOfBirth').text(pop_data.emplDetails[0].DATEOFBIRTH);
					$('#retirementDate').text(pop_data.emplDetails[0].RETIREMENTDATE);
					
					$('#mailId').val(pop_data.emplDetails[0].EMAILID);
					$('#panNumber').val(pop_data.emplDetails[0].PANNUM);
					$('#aadharNumber').val(pop_data.emplDetails[0].AADHARNO);
					$('#phoneNumber').val(pop_data.emplDetails[0].PHONE);
					$('#officeno').val(pop_data.emplDetails[0].PHONEOFFC);
					$('#careOf').val(pop_data.emplDetails[0].CAREOF);
					
					$('#bankNumber').val(pop_data.emplDetails[0].BANKACCNO);
					$('#ifscCode').val(pop_data.emplDetails[0].IFSCCODE);
					$('#bankName').val(pop_data.emplDetails[0].BANKNAME);
					$('#bankAddress').val(pop_data.emplDetails[0].BANKPLACE);
					
				} catch (e) {
					// TODO: handle exception
					alert('Exception in getEmployeeCodeList ' +e.message)
				}
				
			});
		
	});
	

	
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
		//alert("Inside address")
		
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
	
	
	
	
	
	Addnominee = function(){
		
	      var nomineeName=$('#nomineeName').val();
			
			if(nomineeName==''||nomineeName==undefined){
				alert('Enter Nominee Name')
				return;
		
			}
			
			var name= $('#nomineeName').val().toUpperCase();
			
			var date= $('#nomineedob').val().toUpperCase();
			if(date==''||date==undefined){
				alert('Select Date')
				return;
		
			}
			var gender=$('#gender').val();
			if(gender==''||gender=='Select'){
				alert('Select gender')
				return;
			}
			var rel=$('#relation').val();
			if(rel==''||rel=='Select'){
				alert('Select Relation')
				return;
			}
			var addr=$('#nomAddress').val().toUpperCase();
			/*if(addr==''){
				alert('Enter Address')
				return;
			}*/
			var data={'NomineeName':name, 'Dob':date,'Relation':rel,'Gender':gender,'Address':addr,'NomineeId':""};
			
			var nomlist=findgrid.dataset.data;
			
			nomlist.push(data);
			
			findgrid.setContent(nomlist);
			findgrid.refresh();
				
		}

deletememebfun = function(){
	
	var userid = $('#empCodeFromView').val(); 
	var memAccNo = $('#memAccnountNumber').val();

		var grid=Sigma.$grid("grid1");
	var igrid1=JSON.stringify(grid.dataset.data);
	
if(igrid1 == ''|| igrid1 =="[]"){
		alert('Empty Grid Data');
		return false;
	}
		$.post('/SocietyNew/MemAddress',{
			req : 'deleteNomineemember',
			option:"DELETE",
			userid :userid,
			memAccNo:memAccNo,
			igrid1:igrid1,
		},function(data){
			
		});
}

deletefun = function(){

	var UserEmpcode = $('#emplcode').val();
	var memAccNo =$('#memAccnountNumber').val();
		var memCode = $('#empCodeFromView').val();
		
		var grid=Sigma.$grid("grid");
		var igrid=JSON.stringify(grid.dataset.data);
		if(igrid == ''|| igrid =="[]"){
			alert('Empty Grid Data');
			return false;
		}
		$.post('/SocietyNew/NomineeController',{
			req : 'deleteNominee',
			option:"DELETE",
			memAccNo:memAccNo,
		},function(data){
			
		});
}

//------------------------save and submit----------------------//


$('#btnSaveAndSubmit').click(function() {
	
	var memAccnountNumber = $('#memAccnountNumber').val();
	var  option;
	var emplcode;
	
	if(memAccnountNumber=='' || memAccnountNumber=='null' ||memAccnountNumber==undefined){
		
			 var emplcode = $('#emplcode').val();
			if(emplcode == 'Select'){
				alert('Select Employee Code');
				return;
			}
			 option="SUBMIT"
	}else{
		 option="SUBMITUPDATE"
			 emplcode=$('#empCodeFromView').val();
		 deletefun();
		 deletememebfun();
	}
	
	
if(confirm("Do you want submit the Record")){
	
		if(validateSave()){	
      
      
			var userid = $('#empCode').val();  
	    var emplycode = emplcode.split('-')[0];
	    
	    
	    var nameOfTheMember = $('#nameOfTheMember').text();
	    var division = $('#division').text();
		var designation = $('#designation').text();
		var basicPay = $('#basicPay').text();
		var dateOfBirth = $('#dateOfBirth').text();
		var retirementDate = $('#retirementDate').text();
		
		
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
			
		// nominee Details
		
var grid=Sigma.$grid("grid");
		
		var igrid=JSON.stringify(grid.dataset.data);
		
		if(igrid == ''|| igrid =="[]"){
			alert('Enter Nominee Details Data');
			return ;
		}
//Address details
		
		var grid1=Sigma.$grid("grid1");
		var igrid1=JSON.stringify(grid1.dataset.data);
		alert(igrid1)
		if(igrid1 == ''|| igrid1 =="[]"){
				alert('Enter Address  Data');
				return ;
			}
		
		$.post('/SocietyNew/Membership',{
			req : 'submitMember', 
			memAccnountNumber : memAccnountNumber,
			 option: option,
			 userid :userid,
			 emplycode : emplycode,
			 nameOfTheMember : nameOfTheMember,
			 division : division, 
			 designation :designation,
			 basicPay : basicPay , 
			 dateOfBirth : dateOfBirth , 
			 retirementDate :retirementDate,
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
			 igrid:igrid,
			 igrid1:igrid1, 
			 igrid2:igrid2,
			 remarks :remarks,
		},function(data){
			
			try {
				eval_Data = eval("("+data+")");
				if(eval_Data.updated == 'y'){
					alert("Details Updated Successfully");
					$('#btnSaveAndSubmit').prop('disabled',true);
				}else if(eval_Data.success == 'y'){
						alert("");
						alert("Details Submitted Successfully with application number  "+eval_Data.memaccNonew);
						$('#applNumber').text(eval_Data.memaccNonew)
						$('#applNumber').val(eval_Data.memaccNonew)
						$('#btnPrint,#btnPrint1').prop('disabled',false);
						$('#btnSaveAndSubmit').prop('disabled',true);
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



displayScreenDetails(" Membership");

$("#btnPrint").click(function(){
var EmplCode = (($("#empCodeFromView").val()).split("-"))[0];

var applNumber=$('#applNumber').val();
alert(applNumber)
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


getAllMemberCodeList = function(type) {
	
	$.post('/SocietyNew/genericsDetails',{
		req:'getAllMembers',
		option : 'ALLMEMEBERS',
	},function (data) {
		
		try {
			
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.ALLEMPLOYEELIST;
			var sel = document.getElementById("emplcode");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				option.value=temp;
				sel.add(option);
			}
			$("#emplcode").trigger("chosen:updated");
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
		
	});
}
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


	
	
	//clearAllValues();
	
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

	
	