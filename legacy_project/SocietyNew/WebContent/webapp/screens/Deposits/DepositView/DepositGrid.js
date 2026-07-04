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
		{id:'VIEW',header:"Option",width:70,renderer:render_view},
		{id : 'memEmpCode',header : "Employee Code",width : 110},
		{id: 'depositnumber',header : "DEPOSIT NO",width : 110},
		{id: 'memName',header : "EMPLOYEE",width : 260},
		{id:'designation',header:"DESIGNATION",width:240},
		{id:'division',header:"DIVISION",width:240}	
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
		width : 1030,		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){			
			if(record.memAccno=="" ||record.memAccno===undefined){
				alert("NO RECORDS PRESENT");
				return;
			}			
			$('#actBtn').prop("disabled" ,false);
			$('#delBtn').prop("disabled" ,false);
			$('#Remarks').val("");			
			$('#depositnum').val(record.depositnumber);
			$('#memAccno').val(record.memAccno);
			$('#employee').val(record.memName);
			$('#DepositNo').text(record.depositnumber);
			$('#memAccNo1').val(record.memAccno);			
			var bankNumber = record.bankNumber;
			if(bankNumber == '')
				bankNumber = '-';
			$('#bankAccNo').text(record.bankNumber)
			
			var ifscCode = record.ifscCode;
			if(ifscCode == '')
				ifscCode = '-';
			$('#ifscCode').text(record.ifscCode);
			
			
			var bankName = record.bankName;
			if(bankName == '')
				bankName = '-';
			$('#bankName').text(record.bankName);
			
			var basicPay = record.basicPay;
			if(basicPay == '')
				basicPay = '-';
			$('#basicPay').text(record.basicPay);
			
			var dateOfBirth = record.dateOfBirth;
			if(dateOfBirth == '')
				dateOfBirth = '-';
			$('#dateOfBirth').text(record.dateOfBirth);

			var regStatus = record.regStatus;
			if(regStatus == '')
				regStatus = '-';
			$('#status').text(record.regStatus);
			
			var deposittype = record.deposittype;
			if(deposittype == '')
				deposittype = '-';			
			$('#DepositType').text(record.deposittype);			
			var openDate = record.openDate;		
			if(openDate == '')
				openDate = '-';			
			$('#OpenDate').text(record.openDate);			
			var duration = record.duration;
			if(duration == '')
				duration = '-';
			$('#Duration').text(record.duration);			
			var interestrate = record.interestrate;
			if(interestrate == '')
				interestrate = '-';
			$('#IntRate').text(record.interestrate);
			var subscription = record.subscription;
			if(subscription == '')
				subscription = '-';
			$('#Subscription').text(record.subscription);	
			var maturityAmount = record.maturityAmount;
			if(maturityAmount == '')
				maturityAmount = '-';
			$('#MaturityAmount').text(record.maturityAmount);
			var phoneNumber = record.phoneNumber;
			if(phoneNumber == '')
				phoneNumber = '-';
			$('#phoneNum').text(record.phoneNumber);			
			var MailId = record.mailId;			
			if(MailId == '')
				MailId = 'NA';
			$('#MailId').text(record.mailId)			
			var Remarks = record.remarks;
			if(Remarks == '')
				Remarks = 'NA';
			$('#Remarks').val(record.remarks);			
			$('#Designation').text(record.designation);
			$('#Division').text(record.division);			
			$('#accNo').val(record.memAccno);			
			$('#empCode').val(record.memEmpCode);			
			$('#emplcode').val(record.memAccno);			
			$('#employeeDetails').text(record.memAccno+" - "+record.depositnumber+"-"+record.memEmpCode+" - "+record.memName);		
			var aadharNumber = record.aadharNumber;
			if(aadharNumber == '-')
				aadharNumber = 'NA';			
			$('#aadharNumber').text(aadharNumber);
			$('#Shortclosedate').text(record.closedate);
			$('#Statusinfo').text(record.statusinfo);		
			$('#viewTable').find(':text').prop('disabled',true);			
			$('#myModal').find(':button').not('[id = closeButton]').hide();			
			$('#remarksTR').show();			
	
			var Role = $('#Role').val();
			if(typeOfSearch=='FRESH'){				
				$('#btnPrint').show();				
				$('#actBtn,#delBtn,#actEdit,#btnPrint').prop("disabled" ,false);				
				if(Role==1){
					$('#actEdit').show();
					$('#delBtn').hide();
					$('#actBtn').hide();
					$('#remarksTR').hide();
				}else{
					$('#delBtn').show();
					$('#actBtn').show();
					$('#remarksTR').show();
					$('#actEdit').hide();
				}				
			}			
			var Role = $('#Role').val();
			typeOfSearch = $('#depositstatus').val();
			if(typeOfSearch=='ACTIVE'){					
					if(Role==1){
						$('#actEdit').hide();
						$('#delBtn').hide();
						$('#actBtn').hide();
						$('#remarksTR').hide();
						$('#btnDepositProcess').show();
						$('#btnPrint').show();						
					}else{
						$('#delBtn').hide();
						$('#actBtn').hide();
						$('#remarksTR').hide();
						$('#actEdit').hide();
						$('#btnDepositProcess').hide();
						$('#btnPrint').show();
					}
				}			
			if(typeOfSearch=='REJECTED' ||typeOfSearch=='EXPIRING' ||typeOfSearch=='CLOSED' ){				
				$('#delBtn').hide();
				$('#actBtn').hide();
				$('#remarksTR').hide();
				$('#actEdit').hide();
				$('#btnDepositProcess').hide();
				$('#btnPrint').show();
				$('#btnPrint').prop("disabled" ,false);
			}			
	if(typeOfSearch=='UNDER PROCESS'){				
				$('#actBtn,#delBtn,#actEdit,#btnPrint').prop("disabled" ,false);			
				if(Role==1){
					$('#btnPrint').show();
					$('#actEdit').hide();
					$('#delBtn').hide();
					$('#actBtn').hide();
					$('#remarksTR').hide();
					$('#btnDepositProcess').hide();
				}else{
					
					$('#btnDepositProcess').show();
					$('#actEdit').hide();
					$('#delBtn').hide();
					$('#actBtn').hide();
					$('#remarksTR').hide();					
					$('#btnPrint').show();
					$('#btnDepositProcess').show();			
				}				
			}			
			var loginMode = $('#LOGINMODE').val();
			//alert(loginMode)
			/*$('#btnApprove,#btnEdit').prop('disabled',true);*/
			
		/*	if(loginMode == 'OFFICER' || loginMode == 'DIRECTOR'){
				if(typeOfSearch == 'Active' || typeOfSearch == 'ACTIVE'){
					$('#btnCancel,#btnEdit').prop('disabled',false);	
					
				}
				if(typeOfSearch == 'SUBMIT'){
				$('#btnEdit,#btnApprove,#remarksTR').show();
				$('#btnApprove,#btnEdit').prop('disabled',false);
				}*/
			/*} 
			else{
				$('#btnApprove,#btnEdit').prop('disabled',true);
			}*/	
			return;
		},
		beforeEdit:function(){
	}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));

function render_view(value ,record,columnObj,grid,colNo,rowNo){
	return "<a href='#' id='viewDetails' name='viewDetails' data-toggle='modal' data-target='#myModal'>View</a>";
//	return " <a href='#' data-toggle='modal' id = 'viewClick' data-target='#myModal' onclick = 'setAccountNumber('"+record.memAccno+"') return true;' >View</a> ";
}

	



