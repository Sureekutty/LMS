var dsOption = {
		fields :[ 
			{name : 'DepositDetails'},
			{name : "SettlementAmount"},
			{name : 'OpenDate'},
			{name : "SettlementAmount"},
			{name : 'Duration'},
			{name : "MaturityAmount"},
			{name : "MemAccNo"},				
		],
		recordType : 'object'
	}
	var colsOption = [
		{id : 'chk',isCheckColumn:true},
		{id : 'DepositDetails',header : "Deposit Details.",	/*editor:{type:"text"},*/	width : 180},
		{id: 'SettlementAmount',header : "Value(Rs)",	width : 100},
		{id:'VIEW',header:"Option",width:100,renderer:render_viewdeposit}	
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
		pageSize : 200,
		height : 200,
		width : 420,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			if(record.DepositDetails=="" ||record.DepositDetails===undefined){
				alert("No Records");
				return;
			}		
			var number=record.DepositDetails;			
			$('#depositno').val(record.DepositNo)
			var selected=findgrid.getSelectedRecords();
			var totalDeposit=0;
			for(var j=0;j<selected.length;j++){
				totalDeposit=totalDeposit+Number(selected[j].SettlementAmount);
			}
			var totalLoan=Number($('#loantotal').val());
			//alert(totalDeposit+" -- "+totalLoan)
			$('#SettlementAmount').text(totalDeposit-totalLoan)	
		/*	$('#DepositDetails').text(record.DepositDetails);
			$('#ValueInRs').text(record.SubscriptionAmount);
			$('#DepositType').text(record.DepositType);
			$('#OpenDate').text(record.OpenDate);
			$('#Duration').text(record.Duration);
			$('#MaturityAmount').text(record.MaturityAmount);*/
			$('#memAccNo').val(record.MemAccNo);
			return;
		},
		beforeEdit:function(){
	}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));


function render_viewdeposit(value ,record,columnObj,grid,colNo,rowNo){

	return "<a href='#' id='"+record.DepositNo+"-"+record.MemAccNo+"-"+record.DepositType+"' name='"+record.DepositNo+"-"+record.MemAccNo+"-"+record.DepositType+"' onclick='Depositprint(this.id)'>View</a>";
//	return " <a href='#' data-toggle='modal' id = 'viewClick' data-target='#myModal' onclick = 'setAccountNumber('"+record.memAccno+"') return true;' >View</a> ";
}
function Depositprint(depositnoandacc){	
	alert("attr "+depositnoandacc)
var depositno=depositnoandacc.split("-")[0];
var accNo=depositnoandacc.split("-")[1];
var depositcode=depositnoandacc.split("-")[2];
	var req="DepositDetails";
	var frm = document.createElement("form");
	frm.method="POST";
	frm.name="GenPDF_FORM";
	frm.action="/SocietyNew/deposits";
	document.body.appendChild(frm);

	
	var in1 = document.createElement("input");
	in1.type='hidden';in1.name='depositno';in1.value=depositno;
	
	var in2 = document.createElement("input");
	in2.type='hidden';in2.name='accNo';in2.value=accNo;
	
	var in3 = document.createElement("input");
	in3.type='hidden';in3.name='req';in3.value=req;
	
	var in4 = document.createElement("input");
	in4.type='hidden';in4.name='depositcode';in4.value=depositcode;
	
	frm.appendChild(in1);
	frm.appendChild(in2);
	frm.appendChild(in3);
	frm.appendChild(in4);
	
	frm.submit();
}




/**************************************************************************/
var dsOption1 = {
		fields :[ 
			{name : 'LiabilitiesDetails'},
			{name : "ValueInRs"},		
		],
		recordType : 'object'
	}
	
var colsOption1 = [
		{id : 'LiabilitiesDetails',header : "Liabilities Details.",/*editor:{type:"text"},*/width :180},
		{id: 'LoanAmount',header : "Value(Rs)",width : 150},
		{id:'VIEW',header:"Option",width:100,renderer:render_viewloan}	
	];

var gridOption1= {		
		id : "grid1",
		container : 'containerGrid1',
		dataset : dsOption1,
		columns : colsOption1,
		toolbarPosition : false,
		// toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : false,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : true,
		pageSize : 200,
		height : 150,
		width : 440,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid1){
			if(record.LoanAccNo=="" ||record.LoanAccNo===undefined){
				alert("No Records");
				return;
			}
			
			$('#DepositDetails').val(record.memAccno);
			$('#ValueInRs').val(record.LoanAccNo);

			return;
		},
		beforeEdit:function(){
	}
};
var findgrid1 = new Sigma.Grid(gridOption1);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid1));

function render_viewloan(value ,record,columnObj,grid1,colNo,rowNo){
	
     return "<a href='#' id='"+record.LoanAccNo+"' name='"+record.LoanAccNo+"' onclick='loanprint(this.id)' >View</a>";
//	return " <a href='#' data-toggle='modal' id = 'viewClick' data-target='#myModal' onclick = 'setAccountNumber('"+record.memAccno+"') return true;' >View</a> ";
}
	
function loanprint(LoanAppNo){
	 var accNo=$('#memAccNo').val();
	 alert('accNo-->'+accNo);
	var req="MemGenpdfformLoanDetails";
	var frm = document.createElement("form");
	frm.method="POST";
	frm.name="GenPDF_FORM";
	frm.action="/SocietyNew/LoanApplication";
	document.body.appendChild(frm);

	
	var in1 = document.createElement("input");
	in1.type='hidden';in1.name='LoanAppNo';in1.value=LoanAppNo;
	
	var in2 = document.createElement("input");
	in2.type='hidden';in2.name='accNo';in2.value=accNo;
	
	var in3 = document.createElement("input");
	in3.type='hidden';in3.name='req';in3.value=req;
	frm.appendChild(in1);
	frm.appendChild(in2);
	frm.appendChild(in3);
	
	frm.submit();
}


/*********************************************************/
var esOption = {
		fields :[
			{name : 'MemAccNo'},
			{name : 'MemEmpCode'},
			{name : "MemName"},							
		],
		recordType : 'object'
	}
	var colOption = [
		{id : 'MemAccNo',header : "Member Acc No.",	/*editor:{type:"text"},*/	width : 110},
		{id: 'MemEmpCode',header : "Member Code",	width : 100},
		{id:'MemName',header:"Member Name",width:200}	
	];

var surityGridOption= {		
		id : "SurityGrid",
		container : 'surity',
		dataset : esOption,
		columns : colOption,
		toolbarPosition : false,
		// toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : false,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : true,
		pageSize : 200,
		height : 200,
		width : 420,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, SurityGrid){
				
		},
		beforeEdit:function(){
	}
};


var findgrid2 = new Sigma.Grid(surityGridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid2));
