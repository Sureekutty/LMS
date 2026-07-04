var dsOption = {
		fields :[ 
			{name : 'memEmpCode'},
			{name : "memAccno"},
			{name : 'employee'},
			{name : "memName"},
			{name : "mailId"},
			{name : "designation"},
			{name  : 'division'},
			{name :"phoneNumber"},
			{name : "officeNumber"},
			{name : "bankNumber"},			 
			{name : "ifscCode"},
			{name : "bankName"},
			{name : "bankBranch"},
			{name :"basicPay"},
			{name :"dateOfBirth"},
			{name : "retirementDate"},
			{name : "careOf"},
			{name : 'membershipDate'},
			{name : "panNumber"},
			{name : "aadharNumber"},
			{name : "regStatus"},
			{name : "nomName"},
			{name : "nomRelation"},
			{name : 'thriftAmount'},
			],
			recordType : 'object'
}
var colsOption = [
	{id:'VIEW',header:"Option",width:70,	renderer:render_view}, 
	{id : 'memAccno',header : "ACCNO",	width : 120}, 
	{id: 'receiptno',header : "Receipt No",width : 150},	
	{id: 'memName',header : "EMPLOYEE",width : 260},
	{id:'modeofpayment',header:"ModeOfPayment",width:170},
	{id:'purposecode',header:"PurposeCode",width:120}
	];

var gridOption= {
		id : "grid",
		container : 'containerGrid',
		dataset : dsOption,
		columns : colsOption,
		toolbarPosition : false,
		// toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : false,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : true,
		pageSize : 30000,
		height : 270,
		width : 890,

		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			$('#receiptno').val(record.receiptno)
			$('#memAccno1').val((record.memAccno).split("-")[1])
			$('#actBtn').prop("disabled" ,false);
			$('#btnPrint').prop("disabled" ,false);
			$('#delBtn').prop("disabled" ,false);
			$('#Remarks').val("");
			$('#receiptno').text(record.receiptno);	
			var regStatus = record.regStatus;
			var deposittype = record.deposittype;
			var openDate = record.openDate;
			$('#amount').text(record.amount);
			var duration = record.duration;			
			var interestrate = record.interestrate;
			$('#purposecode').text(record.purposecode);
			var phoneNumber = record.phoneNumber;
			
			$('#receiptdate').text(record.receiptdate);
			var MailId = record.mailId;

			if(record.memAccno=="" ||record.memAccno===undefined){
				alert("No Records");
				return;
			}
			
			despositDetails(record);
			
			
			if(record.purposecode=='D08' ||record.purposecode=='M03' ||record.purposecode=='D20')
				$('#tableid').show();
			else
				$('#tableid').hide();
			
			if(record.purposecode=='D08' || record.purposecode=='M03' || record.purposecode=='D20')
				$('.hideviewdependsonpurspono').show();
			else
				$('.hideviewdependsonpurspono').hide();


			if(regStatus == '')
				regStatus = '-';
			$('#status').text(record.regStatus);
			
			if(deposittype == '')
				deposittype = '-';
			$('#DepositType').text(record.modeofpayment);
			
			if(openDate == '')
				openDate = '-';
			$('#OpenDate').text(record.openDate);

			if(duration == '')
				duration = '-';
			$('#Duration').text(record.duration);
			
			if(interestrate == '')
				interestrate = '-';
			
			if(phoneNumber == '')
				phoneNumber = '-';
			$('#phoneNum').text(record.phoneNumber);
			
			if(MailId == '')
				MailId = 'NA';
			$('#MailId').text(record.mailId)
			$('#Designation').text(record.designation);
			$('#Division').text(record.division);
			//$('#accNo').val(record.memAccno);
			$('#empCode').val(record.memEmpCode);
			$('#employeeDetails').text((record.memAccno).split("-")[1]+" -"+record.memEmpCode+" - "+record.memName);

			if(aadharNumber == '-')
				aadharNumber = 'NA';
			$('#aadharNumber').text(aadharNumber);

			$('#viewTable').find(':text').prop('disabled',true);
			$('#myModal').find(':button').not('[id = closeButton]').hide();
			$('#remarksTR').show();

			if(typeOfSearch=='SUBMIT'){
				var Role = $('#Role').val();
				if(Role==1){
					$('#actBtn').hide();
					$('#delBtn').hide();
					$('#remarksTR').hide();
					$('#editBtn').show();
					$('#editBtn').prop("disabled" ,false);
				}else{
					$('#actBtn,#delBtn,#remarksTR').show();
					$('#editBtn').hide();
				}
			}else{
				$('#delBtn').hide();
				$('#actBtn').hide();
				$('#remarksTR').hide();
			}

			var loginMode = $('#LOGINMODE').val();
			return;
		},
		beforeEdit:function(){
		}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));



function render_view(value ,record,columnObj,grid,colNo,rowNo){
	return "<a href='#' id='viewDetails' name='viewDetails' data-toggle='modal' data-target='#myModal' onclick='deleteRowNom(this.id)'>View</a>";
//	return " <a href='#' data-toggle='modal' id = 'viewClick' data-target='#myModal' onclick = 'setAccountNumber('"+record.memAccno+"') return true;' >View</a> ";
}


function despositDetails(Details) {
	$('#Depositty').text('');
	$('#month').text('');
	$('#closingbal').text('');
	$('#openingbal').text('');
	var purposecode = Details.receiptno;
	var req = 'deposittypes';
	$.ajax({
		url :"/SocietyNew/RecieptController?",
		type : 'POST',
		data : {
			req : req, purposecode : purposecode
		},
		success : function(data) {
			var pop_data = eval("("+data+")");
			$('#Depositty').text(pop_data.depositdetails[0].deposittypecode);
			$('#month').text(pop_data.depositdetails[0].month);
			$('#closingbal').text(pop_data.depositdetails[0].closingbal);
			$('#openingbal').text(pop_data.depositdetails[0].openingbal);
		}
	});
}


