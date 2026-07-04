
var dsOption = {
		fields :[ 
		         {name : 'EmployeeCode'},
		         {name :'EmployeeName'},
		         {name :'mailID'},
		         {name : 'reportFile'},
		         {name : 'reportFileName'},
		         {name :'mailSentOn'},
		         {name : 'sendMail'},
		],
		recordType : 'object'
	}

		var colsOption = [			
			{id:'EmployeeCode',	header:"Employee Code",	width:100},
			{id : 'EmployeeName',sortable:true, header : "Employee Name",width : 150},
			{id: 'mailID',header : "Email id",width : 200},
			{id: 'reportFile',header : "Report File",width : 200,renderer:render_report},
			{id: 'reportFileName',header : "Report File name",width : 200, hidden:true},
			{id: 'mailSentOn',header : "Email Sent On",width : 100},
			{id: 'sendMail',header : "Send mail",width : 100,renderer:sendButton}
			];


var gridOption= {
		
		id : "grid",
		container : 'container',
		dataset : dsOption,
		columns : colsOption,
		toolbarPosition : false,
		// toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : true,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : true,
		pageSize : 30000,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			
			
		},
		beforeEdit:function(){
	}
		
};

var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));

/*function sendButton(data){
	var button = document.createElement('button');
	button.innerHTML = 'send';
	
	button.addEventListener('click',function(){
		alert("button created");
	});
}*/

function sendButton(value, record, cell, row, colNO, rowNO){
	
	return "<input type='button' id='"+rowNo+"' value='Del' >";
	
}

function render_report(value ,record,columnObj,grid,colNo,rowNo){
	return "<a href='#' id='"+record.reportFileName+"' name='"+record.reportFileName+"' >reportFile</a>";

}





