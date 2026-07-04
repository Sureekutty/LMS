var typeOfSearch = '',memAccnountNumber = '';
var save_update = '',memActive = '',empCode='',count=0;


$(document).ready(function(){
	displayScreenDetails(" Membership Settlement");
	clearscreen= function() {
		$('#memCode').val("");
		$('#memCode').prop('disabled',false).trigger('chosen:updated');
	}	 
	 
	 $('#memCode').change(function() {
		 $('#SettlementAmount').text('');
		 var memSettDate=$('#memSettDate').val();
		 if(memSettDate=='' || memSettDate == undefined){
			 alert("Select Date");
			 return;
		 }
		 $('#memSettlement').prop('disabled',false);
		 	empCode=((this.value).split("-"))[0];
			getDepositeDetails(empCode);
			getSuritiesList(empCode);
			
		});
	    getMemberCodeList("SOCIETYMEM");	 
});				//end of ready function

getMemberCodeList = function(type) {
	
	$.post('/SocietyNew/genericsDetails',{
			type : type,req:'employeeList',regstatus : 'NEW',
	},function (data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.EMPLOYEELIST;
			
			var sel = document.getElementById("memCode");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				option.value=temp;
				sel.add(option);
			}
			$("#memCode").trigger("chosen:updated");
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
		
	});
}
getDepositeDetails = function(memAccNo) {

	 $('#SettlementAmount').text('');
	 var memSettDate=$('#memSettDate').val();
	findgrid.cleanContent();
	$.post( '/SocietyNew/MemeberProcessViewController',{
			req : 'getDepositeDetails',
			memAccNo : memAccNo,
			type:'Deposits',
			memSettDate : memSettDate,
		},
		function(data){
			
			try {
				var pop_data = eval("("+data+")");
				if(pop_data.SUCCESS == 'Y'){
					$('#deposittotal').val(pop_data.DepositeTotal)
					var arr = new Array();
		    		arr = pop_data.Deposite;	    		
	    			findgrid.setContent(arr);
	    			getLiabilityDetails(empCode);
	    			return;
				}
				else {
					findgrid.cleanContent();
					clearscreen();
					if(pop_data.SUCCESS == 'N'){
						alert("No Deposit Data")
					}
					return;
				}
			} catch (e) {
				alert('Inside getDepositeDetails BLOCK ' + e.message);
			}
		});
}



getLiabilityDetails = function(memAccNo) {
	$('#SettlementAmount').text('');
	var memSettDate=$('#memSettDate').val();
	 findgrid1.cleanContent();
		$.post( '/SocietyNew/MemeberProcessViewController',{
				req : 'getLiabilityDetails',
				memAccNo : memAccNo,
				type : 'Liability',
				memSettDate : memSettDate,
			},
			function(data){			
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.SUCCESS == 'Y'){
						var arr = new Array();
			    		arr = pop_data.Liability;
			    		$('#loantotal').val(pop_data.LoanTotal)		
			    		findgrid1.setContent(arr);
			    		//var deposit=$('#deposittotal').val();			    		
			    		var loan=$('#loantotal').val();	
			    		$('#SettlementAmount').text(loan)	
			    		
		    			return;
					}
					else {
						findgrid1.cleanContent();
						if(pop_data.SUCCESS == 'N'){
							var deposit=$('#deposittotal').val();
							//$('#SettlementAmount').text(Math.abs(deposit))
							alert("No Liabilities Data")
						}
						return;
					}
				} catch (e) {
					alert('Inside getLiabilityDetails BLOCK ' + e.message);
				}
			});
	}

getSuritiesList = function(memAccNo) {

	var memSettDate=$('#memSettDate').val();
	 findgrid2.cleanContent();
	$.post( '/SocietyNew/MemeberProcessViewController',{
			req : 'SurityList',
			memAccNo : memAccNo,
			type:'Surity',
			memSettDate : memSettDate,
		},
		function(data){
			
			try {
				var pop_data = eval("("+data+")");
				if(pop_data.SUCCESS == 'Y'){
					count=1;
					if(count ==1)
						$('#memSettlement').prop('disabled',true);				
						
					var arr = new Array();
		    		arr = pop_data.Surities;
		    		
		    		findgrid2.setContent(arr);
	    			return;
				}
				else {
					count=0;
					findgrid2.cleanContent();
					if(pop_data.SUCCESS == 'N'){
						alert("No Surity Data")
					}
					return;
				}
			} catch (e) {
				alert('Inside getSuritiesList BLOCK ' + e.message);
			}
		});
}

function onClick(){	
	var date = $('#memSettDate').val();
	var settlementAmount = $('#SettlementAmount').text();	
	//var selected = findgrid.dataset.data;
	var selected=findgrid.getSelectedRecords();
	var JsonData = JSON.stringify(selected);
	//alert(JsonData)
	$.post( '/SocietyNew/MemebershipSettlement',{
		req : 'memSettlement',
		memAccNo : empCode,
		option : 'PROCESS',
		date : date,
		gridData : JsonData,
		settlementAmount : settlementAmount
	},
	function(data){	
		try {
			var pop_data = eval("("+data+")");
			if(pop_data.SUCCESS == 'Y'){
				alert(pop_data.msg)
				//$('#memSettlement').prop('disabled',true);
    			return;
			}
			else {
				alert("failed to settle account");
				return;
			}
		} catch(e) {
			alert('Inside memSettlement BLOCK ' + e.message);
		}
	});
	
}


