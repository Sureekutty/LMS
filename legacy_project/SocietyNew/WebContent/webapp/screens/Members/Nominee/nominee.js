$(document).ready(function() {
	displayScreenDetails(" Nominee");
//alert("memcode..")
	//$(':input:not([type=button],[id=depositDate])').val('');
	$("#empcode").val('');

	
	
	//$('#Duration,#MinMaxAmount').hide();
	$("#btnClearAll").click(function() {
		
		clearAllTheFields();
		
	});

getMemberCodeList = function(type) {
	
		$.post('/SocietyNew/genericsDetails',{
				type : type,
				req:'employeeList',
				regstatus : 'NEW',
		},function (data) {
			
			try {
				
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.EMPLOYEELIST;
				var sel = document.getElementById("empcode");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
					option.text=temp;
					option.value=temp;
					sel.add(option);
				}
				$("#empcode").trigger("chosen:updated");
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeCodeList ' +e.message)
			}
			
		});
	}		

getMemberCodeList("SOCIETYMEM");

Addnominee = function(){
	
    var nomineeName=$('#nomineeName').val();
		if(nomineeName==''||nomineeName==undefined){
			alert('Enter Nominee Name')
			return;
	
		}
		var name= $('#nomineeName').val().toUpperCase();
		
		
		var nomdob=$('#nomineedob').val();
		 
			if(nomdob==''||nomdob==undefined){
				alert('Select Date')
				return;
		
			}
			 var rel=$('#relation').val();
				if(rel==''||rel==undefined){
					alert('Select relation')
					return;
			
				}
		var rel=$('#relation').val().toUpperCase();
		
		
		
		 var gender=$('#gender').val();
			if(gender==''||gender==undefined){
				alert('Select gender')
				return;
		
			}
		var gender=$('#gender').val().toUpperCase();
		
			 var addr=$('#nomAddress').val();
				if(addr==''||addr==undefined){
					alert('Enter Address ')
					return;
			
				}
				var addr=$('#nomAddress').val().toUpperCase();
		
		var data={'NomineeName':name,'Dob':nomdob, 'Relation':rel,'Gender':gender,'Address':addr,'NomineeId':""};
		
		var nomlist=findgrid.dataset.data;
		
		nomlist.push(data);
		
		findgrid.setContent(nomlist);
		findgrid.refresh();
			
	}




/*getRelations = function(){
	$.post('/SocietyNew/NomineeController',{
		req:"getRelation",
	},function(data){
		
		try{
        	var pop_data = eval("("+data+")")
        	var arr = new Array();
        	arr = pop_data.Relations;
        	if(arr.length > 0){
        	var sel = document.getElementById("relationship");
    		for(var i=0;i<arr.length;i++){	
    			var option=document.createElement("option");
    			var temp = arr[i];
    			option.text=temp;
    			option.value=temp;
    			sel.add(option);
    		}
    		$("#relationship").trigger("chosen:updated").prop("disabled" ,false);
    		}
        	}
        	catch (e) {
				// TODO: handle exception
        		alert("Exception in getEmployeeList " +e.message)
			}
	})
	
	
}*/

/*getRelations();*/
	
	clearAllTheFields = function(){
		$("#empcode").val('').trigger("chosen:updated");
		findgrid.cleanContent();
	}
	
	clearAllTheFields();
	
	$("#btnSave").click(function(){
		
		var memAccNo = $('#empcode').val();
		if(memAccNo == ''|| memAccNo =="Select"){
			alert('Select Employee Code');
			return false;
		}
		
			var memAccNo = (($("#empcode").val()).split("-"))[0];
			var memCode = (($("#empcode").val()).split("-"))[1];
			var grid=Sigma.$grid("grid");
			var igrid=JSON.stringify(grid.dataset.data);
			
			if(igrid == ''|| igrid =="[]"){
				alert('Empty Grid Data');
				return false;
			}
			
		
			deletefun();
			
			$.post('/SocietyNew/NomineeController',{
				req : 'saveNominee',
			
				option1:"SAVEWITHID",
				option2:"SAVEWITHOUTID",
				
				memAccNo:memAccNo,
				memCode:memCode,
				 igrid:igrid,
				status:"ACTIVE",
				
			},function(data){
				
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.success == "y"){
						alert("Details Saved Successfully");
						
					}
					else{
						alert("Failed To Save The Details")
					}

				} catch (e) {
					// TODO: handle exception
					alert('Exception in Nominee ' +e.message)
				}
				
			});
			
	
	
			
		
	});
	
	
	
	
});

deletefun = function(){
	var UserEmpcode = $('#emplcode').val();
	var memAccNo = $('#empcode').val();
	if(memAccNo == ''|| memAccNo =="Select"){
		alert('Select Employee Code');
		return false;
	}
		var memAccNo = (($("#empcode").val()).split("-"))[0];
		var memCode = (($("#empcode").val()).split("-"))[1];
		var grid=Sigma.$grid("grid");
		var igrid=JSON.stringify(grid.dataset.data);
		if(igrid == ''|| igrid =="[]"){
			alert('Empty Grid Data');
			return false;
		}
		$.post('/SocietyNew/NomineeController',{
			req : 'deleteNominee',
			option:"DELETE",
			memAccNo:memAccNo,

			
		},function(data){
			
		});
}


/*$(document).ready(function() {
	
	
	clearMemberCodeList = function() {
		var sel = document.getElementById("empCode");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}
	getMemberCodeList = function() {
		clearMemberCodeList();
		$.post('/SocietyNew/genericsDetails',{
				type : 'SOCIETYMEM',req:'employeeList',
		},function (data) {
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.EMPLOYEELIST;
				var sel = document.getElementById("empCode");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
					option.text=temp;
					option.value=temp;
					sel.add(option);
				}
				$("#empCode").trigger("chosen:updated");
				$("#empCode").prop("disabled" ,false);
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeCodeList ' +e.message)
			}
		});
	}
	onLoad();
	getMemberCodeList();
	
	$('#empCode').change(function() {
		enableInputFileds();
	})
	
})*/