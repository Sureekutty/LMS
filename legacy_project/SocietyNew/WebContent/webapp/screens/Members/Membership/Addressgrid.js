
var dsOption1 = {
		fields : [ 
			{name : "Address1"},
			{name : "Address2"},
			{name : "City"},
			{name : "Pincode"},
			{name : "State"},
		],
		recordType : 'object'
	}


	var colsOption1 = [
		{id : 'Address1',header : "Address1",editor:{type:"text"},width : 180},
		{id : 'Address2',header : "Address2",editor:{type:"text"},width : 180}, 
		{id : 'City',header : "City",editor:{type:"text"},width : 150},
		{id : 'District',header : "District",editor:{type:"text"},width : 150},
		{id : 'Pincode',header : "Pincode",editor:{type:"number"},width : 100},
		{id : 'State',header : "State",editor:{type:"text"},width : 150},
		{id : 'Remarks',header : "Remarks",editor:{type:"text"},width : 150},
		{id:'DELETE',header:"Option",width:80,renderer:show_deladd}
	];

var gridOption1 ={
		id : "grid1",
		container : 'Addresscontainer',
		dataset : dsOption1,
		columns : colsOption1,
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

	var findgrid1 = new Sigma.Grid(gridOption1);
	Sigma.Util.onLoad(Sigma.Grid.render(findgrid1));
	


	function show_deladd(value ,record,columnObj,grid,colNo,rowNo){
		var memdetails=record.AddressId+'-'+record.Address1+'-'+record.Address2+'-'+record.City+'-'+record.District+'-'+record.State+'-'+record.Pincode;
			return "<img alt='DEL' id='"+memdetails+"' src='/SocietyNew/images/delete.gif' height='18px' width='20px' onclick='deleteRowadd(this.id)'>";
			
		}
	
	function deleteRowadd(val){
var grid2data1=findgrid1.dataset.data;
		
		if(grid2data1.length==1){
			alert('All records can\'t be Deleted..');
			return;
		}
		var add=confirm('Do You Want To Delete The Address?');
		
		if(add){
			var addid = val.split("-")[0];
			var add1 = val.split("-")[1];
			var add2 = val.split("-")[2];
			var city = val.split("-")[3];
			var district = val.split("-")[4];
			var state =val.split("-")[5];
			var pincode =val.split("-")[6];
			var grid=Sigma.$grid("grid1");
			var igrid1=JSON.stringify(grid.dataset.data);
			
			if(igrid1 == ''|| igrid1 =="[]"){
				alert('Empty Grid Data');
				return false;
			}
			$.post('/SocietyNew/MemAddress',{
				req : 'deletegridaddress',
				 addid :addid,
				 add1 :add1,
				 add2 :add2,
				 city : city,
				 district : district,
				 state :state,
				 pincode :pincode,
				 igrid1:igrid1,

			},function(data){
				
				try {
					var pop_data = eval("("+data+")");
					findgrid1.cleanContent();
					findgrid1.setContent(pop_data.addDetails);
				} catch (e) {
					
					alert('Exception in Address ' +e.message)
				}
				
			});
			
		}else{
			return;
		}
	}