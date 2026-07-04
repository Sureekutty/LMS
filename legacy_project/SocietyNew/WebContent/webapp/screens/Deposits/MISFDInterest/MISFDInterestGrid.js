var dsOption = {
		fields :[ 
		         
		         {name :'MemAccNo'},
		         {name : 'Emp'},
		         {name :'depositNo'},
		         {name : 'amount'},
		         {name :'month'},
		],
		recordType : 'object'
	}
	var colsOption = [
		{id:'MemAccNo',header:"MemAccNo",width:100,},
		{id : 'Emp',header : "Member Name",width : 290}, 
		{id : 'openDate',header : "Open Date",width : 100},
		{id: 'depositNo', header : "Deposit Number", width : 100 },
		{id: 'accNo', header : "Bank Acc. Number", width : 150 },
		{id:'amount', header:"Amount", width:150 } ,
		{id:'month', header:"Month", width:150 }		
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
		width : 1050,
		
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


	



