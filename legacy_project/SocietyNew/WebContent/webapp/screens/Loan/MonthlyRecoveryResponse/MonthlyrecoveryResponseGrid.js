var dsOption = {
		fields :[ 
		       
		],
		recordType : 'object'
	}
	var colsOption = [
		{id : 'chk',isCheckColumn:true},
		{id:'MemAccNo',header:"MemAccNo",width:120,},
		{id : 'Emp',header : "Member Name",/*editor:{type:"text"},*/width : 300}, 	
		{id: 'Refid',header : "Reference Id",width : 150},
		{id:'Paycode',header:"Pay Code",/*editor:{type:"text"},*/width:100},
		{id:'Salcode',header:"Sal Code",/*editor:{type:"text"},*/width:120},
		{id:'amount',header:"Amount",/*editor:{type:"text"},*/width:140},
		{id:'recamount',header:"RecoveredAmount",/*editor:{type:"text"},*/width:120},
		{id:'status',header:"Status",/*editor:{type:"text"},*/width:120}
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
		height : 260,
		width : 1180,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			if(record.MemAccNo =="" ){
				alert("No Records");
				return;
			}
			
		},
		beforeEdit:function(){
	}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));


	



