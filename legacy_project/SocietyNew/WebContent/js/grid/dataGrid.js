

var dsOption = {
		fields : [ {
		
			name : "name"
		}, {
			mobile : "mobile"
		}, {
			english : "english"
		},{
			hindi : "hindi"
		},{
			maths : "maths"
		},{
			science : "science"
		}
		],
		recordType : 'object'
	}


	var colsOption = [ {
		 
		id : 'name',   //database col names
		header : "NAME",
		width : 240
	},{
		id : 'mobile',
		header :  "MOBILE NO.",
		width : 150
	}, {
		id : 'english',
		header : "ENGLISH",
		width : 80
	}, 
	{
		id : 'hindi',
		header : "HINDI",
		width : 80
	}, 
	{
		id : 'maths',
		header : "MATHS",
		width : 80
	}, 
	{
		id : 'science',
		header : "SCIENCE",
		width : 80
	}
	
	];

var gridOption ={
		id : "grid",
		container : 'container',
		dataset : dsOption,
		columns : colsOption,
		toolbarPosition : false,
		//toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : true,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : true,
		pageSize : 30000,
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			
			//alert("24")
			
			/*var ROLLNO=record.ROLLNO;
			var REGNO=record.REGNO;	
			var SCODE=record.SCODE;
			var NAME=record.NAME;			
			
			document.getElementById('rollNo').value=ROLLNO;*/
			
			/*setSearchButton(STAGEID);
			var REGSTATUS=record.REGSTATUS;
			$("#btnSave").hide();
			document.getElementById('checkListId1').value=CHECKLISTID;
			document.getElementById('clItemId2').value=ITEMID;	
			document.getElementById('clItemSlno3').value=ITEMSLNO;
			document.getElementById('itemDescrptn4').value=ITEMDESC;
			document.getElementById('printOrd6').value=PRINTORDER;
			document.getElementById('status5').value=STATUS;*/
				},
		beforeEdit:function(){
			
		}
	};

	var findgrid = new Sigma.Grid(gridOption);
	Sigma.Util.onLoad(Sigma.Grid.render(findgrid));
		
	