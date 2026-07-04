var dsOption = {
		fields :[ 
			
		],
		recordType : 'object'
	}
	var colsOption = [
{
	id:'CHECK',
	header:"CHECK",
	width:70,
	renderer:render_view
}, {
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
		
		id : "grid1",
		container : 'payvoucherasstGrid',
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
		width : 980,
		
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
var findgrid1 = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid1));



function render_view(value ,record,columnObj,grid,colNo,rowNo){
	var id_val = record.billnum+"-"+ record.amount;
	return "<input type=\"checkbox\" class=\"largecheck\" value=\"0\"  name=\"checkbox\" id='" +id_val+ "' />";
}

	



