
$(document).ready(function() {
	
	displayScreenDetails("Update Thrift Subscription")
	
	

getMemberCodeList = function(type) {
		
		$.post('/SocietyNew/genericsDetails',{
				type : type,
				req:'employeeList',
				regstatus : 'R',
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
					option.value=temp.split("-")[0];
					sel.add(option);
				}
				$("#memCode").trigger("chosen:updated");
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeCodeList ' +e.message)
			}
			
		});
	}		

getMemberCodeList("SOCIETYMEM");


$('#memCode').change(function() {
	var memAccNo=this.value;
	if(memAccNo!=null||memAccNo!=''){
		$("#Process").val('').trigger("chosen:updated");
		$("#Process").prop('disabled',false).trigger("chosen:updated");
		$('#ThriftAmnt').prop('disabled',false);
		$('#btnSave,#btnClearAll').prop('disabled',true);
	}else{
		$("#Process").val('').trigger("chosen:updated");
		$("#Process").prop('disabled',true).trigger("chosen:updated");
		$('#ThriftAmnt').prop('disabled',true);
	}
	
})


	
	
	$('#Process').change(function() {
		
		var Process=this.value;
		var MemAccNo=$('#memCode').val();
		if(Process=="monthlyThrift")
		{
			$('#ThriftAmnt').prop('disabled',false);
			getThriftAmnt(MemAccNo);
			$('#btnSave').prop('disabled',false);
			$('#btnClearAll').prop('disabled',false);
		}
		else{$('#ThriftAmnt').prop('disabled',true);}
	})
	

getThriftAmnt = function(MemAccNo) {
		$.post('/SocietyNew/Membership',{
			MemAccNo:MemAccNo,
			req:"getThriftAmount",
		},function (data) {
	
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.ThriftAmnt;
				
					$('#ThriftAmnt').val(arr[0]);
					$('#RuleValue').val(arr[1]);
					
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getting Thrift Amount ' +e.message)
			}
		});
	}

	
  $('#btnSave').click(function() {
	  
	  
	  var check=confirm("click ok to continue");
      if(check){
			var MemAccNo=$('#memCode').val();
			var ThriftAmount=$('#ThriftAmnt').val();
			var RuleValue=$('#RuleValue').val();
		 $.post('/SocietyNew/Membership',{		
				Option:'update',
				MemAccNo:MemAccNo,
				ThriftAmount:ThriftAmount,
				req:'UpdateThriftSubscription',
				 },function (data) {
				try {
					var pop_data = eval("("+data+")");
					var arr = new Array();
					arr = pop_data;
					if(pop_data.Success=="Y"){
						alert("Data Updated")
					}
					if(pop_data.Success=="N"){
						alert("Data Not Updated")
					}
					
				} catch (e) {
					// TODO: handle exception
					alert('Exception in updating Thrift subscription ' +e.message)
				}
	      });

	
  }
});	
  // save end
});


