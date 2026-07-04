var dsOption = {
		fields :[ 
			
		],
		recordType : 'object'
	}
	var colsOption = [
{
		id : 'billnum',
		header : "BILL NO",
		//editor:{type:"text"},
		width : 180
	}, 	{
		id: 'member',
		header : "MEMBER",
		width : 320
	},	{
		id: 'billdate',
		header : "BILL DATE",
		width : 100
	},
	{
		id:'purpose',
		header:"PURPOSE",
		//editor:{type:"text"},
		width:130
	},
	{
		id:'amount',
		header:"AMOUNT",
		//editor:{type:"text"},
		width:155
	}
	
	];


var gridOption= {
		
		id : "grid2",
		container : 'payvoucheroffcGrid',
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
		width : 910,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			
			if(record.billnum=="" ||record.billnum===undefined){
				alert("No Records");
				return;
			}
	
		
			return;
		},
		beforeEdit:function(){
	}
};
var findgrid2 = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid2));
