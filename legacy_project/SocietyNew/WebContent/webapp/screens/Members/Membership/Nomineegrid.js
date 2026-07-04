

var dsOption = {
		fields : [
			{name : "NomineeName"},
			{name : "Relation"},
			{name : "Gender"}, 
			{name : "Address"}			
		],
		recordType : 'object'
	}

	var colsOption = [ 
				{id : 'NomineeName',header : "Name",width : 260,editor:{type:"text"}},
				{id : 'Dob',header : "Date of Birth",width : 120,editor:{type:"text"}},
				{id : 'Relation',header : "Relation",width : 130,editor:{type:"text"}},
				{id : 'Gender',header : "Gender",width : 100,editor:{type:"text"}},
				{id : 'Address',header : "Address",width : 310,editor:{type:"text"}},	
				{id:'DELETE',header:"Option",width:80,renderer:show_delNom}
				];

var gridOption ={
		id : "grid",
		container : 'Nomineecontainer',
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
					findgrid.cleanContent();
					findgrid.setContent(pop_data.nomDetails);
				} catch (e) {
					
					alert('Exception in Nominee ' +e.message)
				}
				
			});
			
		}else{
			return;
		}
	}