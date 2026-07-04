var dsOption = {
		fields :[ 
		         {name : 'MemEmpCode'},
		         {name :'MemAccNo'},
		         {name :'loanAccno'},
		         {name : 'ShareAmount'},
		         {name :'thriftbalance'},
		         {name : 'ThriftDedAmt'},
		         {name : 'ChequeAmount'},
		         {name : 'bankname'},
		         {name : 'bankaccno'},
		         {name : 'NoOfShares'},
		         {name : 'MemName'},
		         {name :'LoanAppDate'},
		         {name :'releaseddate'},
		         {name :'LoanAmount'},
		         {name :'LoanPurpose'},
		         {name :'NoOfInst'},
		         {name :'Interest'},
		         {name :'PenIntrest'},
		         {name :'IntType'},
		         {name :'PrvLoanAppNo'},
		         {name :'RefNumber'},
		         {name :'LoanStatus'},
		         {name :'LoanSanctionAmt'},
		         {name :'LoanSanctionDate'},
		         {name :'PrincipalCB'},
		         {name :'interestLeft'},
		         {name :'ClosedDate'},
		],
		recordType : 'object'
	}
	var colsOption = [
		{id : 'chk',isCheckColumn:true},
		{id:'VIEW',header:"Option",width:60,renderer:render_view},
		{id : 'memAccno',sortable:true,header : "Acc No",width : 65},
		{id: 'memempcode',header : "EmpCode",width : 70},
		{id: 'memname',header : "Name",width : 200},
		{id: 'loanAccno',header : "App No",width : 80},
		{id:'loansancamt',header:"Amount",width:100},
		{id:'chequeAmount',header:"Cheque Amount",width:100},
		{id:'thriftbalance',header:"Thrift Deducted",width:100},
		{id:'bankaccno',header:"Account Number",width:120},
		{id:'loanstatus',header:"Loan Status",width:90},
		{id:'loanappldate',header:"App Date",width:80},
		{id:'releaseddate',header:"Released Date",width:100},
		{id:'loansancdate',header:"Sanction Date",width:100},
		{id:'interests',header:"Interest",width:70}	
	];
var gridOption= {		
		id : "grid",
		container : 'containerGrid',
		dataset : dsOption,
		columns : colsOption,
		toolbarPosition : false,
		// toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : true,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : true,
		pageSize : 30000,
		height : 300,
		width : 1400,		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			if(record.MemAccNo =="" ){
				alert("No Records");
				return;
			}			
			var selected=findgrid.getSelectedRecords();
			var sum=0;
			for(var j=0;j<selected.length;j++){
				sum=sum+selected[j].chequeAmount;
			}				
			$('#totalAmount').val(sum); 			
			$('#btnSanction').prop("disabled" ,false);			
			$('#btnReject').prop("disabled" ,false);			
			$('#btnPrint').prop("disabled" ,false);			
			$('#btnRelInitiate').prop("disabled" ,false);			
			$('#btnApproveRel').prop("disabled" ,false);	
			$('#Remarks').val("");			
			var fd=record.loanAccno.substring(0,2);
			if(fd=='FD')
				$('.hideRefnotFD').show();
			else
				$('.hideRefnotFD').hide();

			$('#surity1').val(record.surity1)
			$('#surity2').val(record.surity2)
			$('#surity3').val(record.surity3)
			$('#funidnum').val(record.fundid)
			$('#emplcode').val(record.memempcode)
			$('#memAccNo1').val(record.memAccno)
			$('#employeeDetails').text(record.employee);
			$('#monthlyInsPaid').text(record.monthlyinstall)
			var loanappdate=record.loanappldate;
			$('#LoanAppDate').text(loanappdate.substring(0,10))
			$('#LoanAmount').text(record.chequeAmount)
			$('#NoOfInst').text(record.noofinstallments)
			$('#Interest').text(record.interests)
			
	/*		$('#NoOfInst').text(record.NoOfInst)
			$('#Interest').text(record.Interests)*/
			/*$('#PrvLoanAppNo').text(record.PrvLoanAppNo)*/
			$('#RefNumber').text(record.fundid)		
			$('#sanctionDetail1,#sanctionDetail1,#sanctionDetail3,#dateupdate').show();			
			if(typeOfButton == 'FRESH'){
				$('#sanctionDetail1,#sanctionDetail2,#sanctionDetail3').hide();
			}
			if(typeOfButton == 'SANCTION'){		
			//	$('#btnRelInitiative,#remarksTR').show();
				$('#dateupdate,#btnedit').hide();
			}
			if(typeOfButton == 'REJECT'){
				$('#btnRelInitiate,#remarksTR,#btnApproveRel,#recove').hide();
				$('#dateupdate').hide();
			}
			if(typeOfButton == 'RELEASE'){
				$('#remarksTR,#btnApproveRel,#recove').hide();				
			}
			/*$('#outstanding').text(record.outstanding);
			$('#interestLeft').text(record.interestLeft)*/
			$('#NoOfShares').text(record.noofshares);
			$('#ShareAmount').text(record.shareamount);
			$('#loanstatus').text(record.loanstatus)			
			$('#LoanSanctionAmt').text(record.loansancamt)
			var sanctiondate=record.loansancdate;
			$('#LoanSanctionDate').text(sanctiondate.substring(0,10))			
			$('#loantype').val(record.loantype)			
			$('#ThriftBalance').text(record.thriftbalance)
			$('#ThriftDedAmt').text(record.thriftdudamt)
			$('#ChequeAmount').text(record.ChequeAmount)
			$('#BankName').text(record.BankName)
			$('#bankAccNo').val(record.bankaccno);
			$('#btnSanction,#btnReject').hide();
			$('#btnPrint').prop('disabled',false).show();
			if(typeOfButton == 'FRESH'){				
				var Role = $('#Role').val();				
				if(Role==1){					
					$('#btnSanction,#btnReject,#btnRelInitiate,#remarksTR,#btnApproveRel,#recove').hide();
					$('#btnedit,#btnprint,#approvalRelease').prop('disabled',false).show();
					$('#btnedit').show();					
				}else{				
					$('#btnRelInitiative,#btnApproveRel,#recove').hide();
					$('#btnSanction,#btnReject,#remarksTR,#btnedit,#btnPrint').prop('disabled',false).show();
					$('#btnedit').hide();
				}				
			}
			 if(typeOfButton == 'SANCTION'){
				 var Role = $('#Role').val();
				 if(Role==1){
					 $('#btnedit').hide();
						$('#btnApproveRel').hide();
						$('#btnprint,#remarksTR,#recFromDate,#btnRelInitiate,#recove,#relinit,#approvalRelease').prop('disabled',false).show();						
					}else{
						$('#btnedit').hide();
						$('#btnRelInitiative,#recove').hide();
						$('#btnPrint,#Remarks,#btnApproveRel,#remarksTR,#relinit').prop('disabled',false).show();						
						if(record.loanstatus=='SANCTION'){
							$('#btnApproveRel').prop('disabled',false).hide();
						}else{
							$('#btnApproveRel,#relinit').prop('disabled',false).show();
						}						
					} 
				 
			}
			 if(typeOfButton == 'RELINIT'){
				 var Role = $('#Role').val();
				 if(Role  == 1){
					 $('#btnApproveRel,#recove,#remarksTR,#btnRelInitiate').hide();
				 }
				 else{
					 $('#btnApproveRel').prop('disabled',false).show();
				 }
			 }
			 if(typeOfButton == 'RELEASE'){									 
						$('#btnRelInitiate').hide(); 
			}			 
			return;
		},
		beforeEdit:function(){
			/*
			if(role==2 && tab==releaseinit){
				return true;
			}
			else
				return false;*/
	}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));

function render_view(value ,record,columnObj,grid,colNo,rowNo){
	return "<a href='#' id='viewDetails' name='viewDetails' data-toggle='modal' data-target='#myModal'>View</a>";
//	return " <a href='#' data-toggle='modal' id = 'viewClick' data-target='#myModal' onclick = 'setAccountNumber('"+record.memAccno+"') return true;' >View</a> ";
}






