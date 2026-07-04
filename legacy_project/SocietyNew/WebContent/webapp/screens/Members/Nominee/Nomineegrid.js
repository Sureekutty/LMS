
var dsOption = {
		fields : [ {
		
			name : "NomineeName"
		}, {
			name : "Date of Birth"
		}, {
			name : "Relation"
		}, {
			name : "Gender"
		}, {
			name : "Address"
		}
		
		],
		recordType : 'object'
	}


	var colsOption = [ 
	    {
		id : 'NomineeName',
		header : "Name",
		width : 240
	},
	{
		id : 'Dob',
		header : "Date of Birth",
		width : 110
	}, 
	{
		id : 'Relation',
		header : "Relation",
		width : 120
	}, 
	{
		id : 'Gender',
		header : "Gender",
		width : 100
	},{
		id : 'Address',
		header : "Address",
		width : 350
	},	{
		id:'DELETE',
		header:"Option",
		width:100,
		renderer:show_delNom
	}

	
	];

var gridOption ={
		id : "grid",
		container : 'Nomineecontainergrid',
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

	var findgrid = new Sigma.Grid(gridOption);
	Sigma.Util.onLoad(Sigma.Grid.render(findgrid));
	


	function show_delNom(value ,record,columnObj,grid,colNo,rowNo){
		var memdetails=record.NomineeId+'-'+record.NomineeName+'-'+record.Dob+'-'+record.Relation+'-'+record.Gender+'-'+record.Address;
		
			return "<img alt='DEL' id='"+memdetails+"' src='/SocietyNew/images/delete.gif' height='18px' width='20px' onclick='deleteRowNom(this.id)'>";
			
		}
	
	
	
	
	
	function deleteRowNom(val){
     var grid2data=findgrid.dataset.data;
		
		if(grid2data.length==1){
			alert('All records can\'t be Deleted..');
			return;
		}
		var k=confirm('Do You Want To Delete The Nomineee?');
		if(k){
			var nomid = val.split("-")[0];
			var nomname = val.split("-")[1];
			var nomdob = val.split("-")[2];
			var nomrelation = val.split("-")[3];
			var nomgender =val.split("-")[4];
			var nomaddress =val.split("-")[5];
			var grid=Sigma.$grid("grid");
			var igrid=JSON.stringify(grid.dataset.data);
			
			if(igrid == ''|| igrid =="[]"){
				alert('Empty Grid Data');
				return false;
			}
			
			$.post('/SocietyNew/NomineeController',{
				req : 'deletegrid',
				 nomid : nomid,
				nomname : nomname,
				nomdob : nomdob,
				nomrelation : nomrelation,
			     nomgender :nomgender,
			     nomaddress : nomaddress,
				 igrid:igrid,

			},function(data){
				
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.nomineeref == "ref"){
						alert('Deposit Member Reference Nominee cannot be Deleted')
						return;
					}
					findgrid.cleanContent();
					findgrid.setContent(pop_data.nomDetails);
				} catch (e) {
					
					alert('Exception in Nominee ' +e.message)
				}
				
			});
		/*var grid2data=findgrid.dataset.data;
		
		if(grid2data.length==1){
			alert('All records can\'t be Deleted..');
			return;
		}
		
		grid2data.splice(val,1);//splice(positon,no.ofrecords to delete);
			findgrid.setContent(grid2data);
			findgrid.refresh();*/
			
		}else{
			return;
		}
	}