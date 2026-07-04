

var dsOption = {
		fields : [ {
		
			name : "BankAccNo"
		}, {
			name : "IFSC Code"
		}, {
			name : "Bank Name"
		}, {
			name : "Bank Place"
		}
		
		],
		recordType : 'object'
	}


	var colsOption = [ 
	    {
		id : 'BankAccNo',
		header : "BankAccNo",
		width : 250
	},{
		id : 'Ifsccode',
		header : "IFSC Code",
		width : 190
	}, 
	{
		id : 'Bankname',
		header : "Bank Name",
		width : 240
	}, 
	{
		id : 'Bankplace',
		header : "Bank Place",
		width : 240
	},
	{
		id:'DELETE',
		header:"Option",
		width:80,
		renderer:show_delBank
	}

	
	];

var gridOption ={
		id : "gridbank",
		container : 'Bankcontainer',
		dataset : dsOption,
		columns : colsOption,
		toolbarPosition : false,
		//toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : true,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : false,
		pageSize : 30000,
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			
			
				},

		beforeEdit:function(){
			
		}
	};

	var findgrid2 = new Sigma.Grid(gridOption);
	Sigma.Util.onLoad(Sigma.Grid.render(findgrid2));
	

	/*function  setSearchButton(stageid)
	{
		if( stageid=='VERFD')
			{
			$("#btnSave").hide();
			$("#btnUpdate").hide();
			$("#btnDelete").hide(); 
			$("#btnRegister").hide();		
			$("#btnSearch").hide();	
			$("#btnAttachment").show();
			}
		else
			{
			 // document.getElementById('btnSave').disabled=true;
			
			$("#btnAttachment").show();
			$("#btnSave").show();
			$("#btnUpdate").show();
			$("#btnDelete").show();
			$("#btnRegister").show();
			}
	}*/

	

	

	function show_delBank(value ,record,columnObj,grid,colNo,rowNo){
		var bankdetails=record.BankAccNo+'-'+record.Ifsccode+'-'+record.Bankname+'-'+record.Bankplace;
			return "<img alt='DEL' id='"+bankdetails+"' src='/SocietyNew/images/delete.gif' height='18px' width='20px' onclick='deleteRowBank(this.id)'>";
			
		}
	
	
	function deleteRowBank(val){
var grid2data=findgrid2.dataset.data;
		
		if(grid2data.length==1){
			alert('All records can\'t be Deleted..');
			return;
		}
		var k=confirm('Do You Want To Delete The Bank?');
		
		if(k){
			var bankaccno = val.split("-")[0];
			var ifsccode = val.split("-")[1];
			var bankname = val.split("-")[2];
			var bankplace = val.split("-")[3];
			
			var grid=Sigma.$grid("gridbank");
			var igrid=JSON.stringify(grid.dataset.data);
			
			if(igrid == ''|| igrid =="[]"){
				alert('Empty Grid Data');
				return false;
			}
			
			$.post('/SocietyNew/NomineeController',{
				req : 'deletebankgrid',
				bankaccno : bankaccno,
				ifsccode : ifsccode,
				bankname : bankname,
				bankplace : bankplace,
			    igrid:igrid,

			},function(data){
				
				try {
					var pop_data = eval("("+data+")");
					findgrid2.cleanContent();
					findgrid2.setContent(pop_data.bankDetails);
				} catch (e) {
					
					alert('Exception in BankDetails ' +e.message)
				}
				
			});
			
		}else{
			return;
		}
	}