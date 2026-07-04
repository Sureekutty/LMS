var dsOption = {
		fields :[ 
			 {name : 'SuretyGivenTo'},//name should be same as controller mapped name
			{name : "LoanAppNo"},		
		],
		recordType : 'object'
	}
	var colsOption = [
		{
		id : 'Memaccno',
		header : "MemAccNo",
		//editor:{type:"text"},
		width : 160
	}, {
		id: 'Empcode',
		header : "EmpCode",
		width : 90
	},	{
		id: 'MemName',
		header : "Name",
		width : 280
	},
	{
		id:'DELETE',
		header:"Option",
		width:100,
		renderer:show_delNom
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
		pageSize : 200,
		height : 250,
		width : 650,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			if(record.Memaccno=="" ||record.Memaccno===undefined){
				alert("No Records");
				return;
			}
			
			
			
			return;
		},
		beforeEdit:function(){
	}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));


function show_delNom(value ,record,columnObj,grid,colNo,rowNo){
	var memdetails=record.Memaccno;
	
		return "<img alt='DEL' id='"+memdetails+"' src='/SocietyNew/images/delete.gif' height='18px' width='20px' onclick='deleteRowNom(this.id)'>";
		
	}

/**************************************************************************/
function deleteRowNom(val){
    var grid2data=findgrid.dataset.data;
    var empCode=$('#empCode').val();
    if(grid2data.length==3){
		alert('Maximum 3 Suretys Required..');
		return;
	}
		
		var k=confirm('Do You Want To Delete The Surety ?');
		if(k){
			var SMemaccno = val;
		
			var grid=Sigma.$grid("grid");
			var igrid=JSON.stringify(grid.dataset.data);
			alert("igrid "+SMemaccno)
			if(igrid == ''|| igrid =="[]"){
				alert('Empty Grid Data');
				return false;
			}
			
			
			$.post('/SocietyNew/SuretyReplacement',{
				req : 'deletegrid',
				empCode:empCode,
				SMemaccno:SMemaccno,
				igrid:igrid,
			},function(data){
		
				try {
					var pop_data = eval("("+data+")");
					findgrid.cleanContent();
					findgrid.setContent(pop_data.suretyDetails);
				} catch (e) {
					
					alert('Exception in Surety Details ' +e.message)
				}
				
			});
		
			
		}else{
			return;
		}
	}

