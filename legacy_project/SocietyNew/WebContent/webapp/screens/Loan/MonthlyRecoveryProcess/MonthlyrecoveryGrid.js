var dsOption = {
		fields :[ 
		         {name : 'MemEmpCode'},
		         {name :'MemAccNo'},
		         {name :'loanAccno'},
		         {name : 'ShareAmount'},
		         {name :'ThriftBalance'},
		         {name : 'ThriftDedAmt'},
		         {name :'NoOfShares'},
		         {name : 'MemName'},
		         {name :'LoanAppDate'},
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
{
	id:'MemAccNo',
	header:"MemAccNo",
	width:100,
}, {
		id : 'Emp',
		header : "Member Name",
		//editor:{type:"text"},
		width : 290
	}, 	{
		id: 'Refid',
		header : "Reference Id",
		width : 200
	},
	{
		id:'Paycode',
		header:"Pay Code",
		//editor:{type:"text"},
		width:100
	},
	{
		id:'Salcode',
		header:"Sal Code",
		//editor:{type:"text"},
		width:130
	},
	
	{
		id:'amount',
		header:"Amount",
		//editor:{type:"text"},
		width:130
	}
	
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
		height : 350,
		width : 1000,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			if(record.MemAccNo =="" ){
				alert("No Records ");
				return;
			}
			
		},
		beforeEdit:function(){
	}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));


	



