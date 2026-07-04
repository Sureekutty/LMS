$(document).ready(function() {
	
		getSocietyRulesList = function(userID) {
			
		$.post('/SocietyNew/genericsDetails',{
				req:'societyRules',
				userID :userID,
				Option : "fetch"
		},function (data) {
			
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.RULESLIST;
				
				var sel = document.getElementById("rulesDesc");
				
				
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					
					var temp = arr[i];
					option.text=temp.RuleDescription;
					option.value=temp.RuleCode;
					sel.add(option);
				}
				$("#rulesDesc").trigger("chosen:updated");
				
				$("#rulesDesc").change(function(){
				 var code = this.value
	
					getSocietyRuleValue(code);
				 
				});
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getsocietyRulesList ' +e.message)
			}
			
		});
		
}		

		getSocietyRuleValue= function(RuleCode) {
			
			$.post('/SocietyNew/genericsDetails',{
					req:'societyRuleValue',
					ruleCode : RuleCode,
					Option : "Value"
			},function (data) {
				
				try {
					var pop_data = eval("("+data+")");
					
					var value=parseInt(pop_data.RULEVALUE);
					
					$("#value").val(value);
					$("#value").prop("disabled",true);
					$("#btnEdit").prop("disabled",false);
			
				} catch (e) {
					// TODO: handle exception
					alert('Exception in getsocietyValueList ' +e.message)
				}
				
			});
			
	}	
		
	//Save	
		
$("#btnEdit").click(function() {
	$("#value,#btnUpdate").prop("disabled",false);
	$("#btnEdit").prop("disabled",true);
	
})



$('#btnUpdate').click(function() {
	 var ruleCode='';
	 var value='';

	 ruleCode = $("#rulesDesc").val();
	 if(ruleCode==null||ruleCode==""){
	alert("Select Rule to Update")
	return ;}
	 
     value = $('#value').val();
     if(value==null||value==""){
	 alert("Enter value to Update")
	 return ;}
     
var confim=confirm("Are You Sure \n" +"click OK to continue")
if(confim){	
	$.post('/SocietyNew/genericsDetails',{
		req:'societyUpdateValue',
		ruleCode : ruleCode,
		value :value,
		Option : "Update"
},function (data) {
	
	try {
		var pop_data = eval("("+data+")");
		if(pop_data.success == "y"){
			alert("Value Saved Successfully");
			$("#value").prop("disabled",true);
		}
		else{
			alert("Failed To Save The Value")
		}

	} catch (e) {
		// TODO: handle exception
		alert('Exception in getSocietyUpdateValue ' +e.message)
	}
	
});
	
}
	
})
		
	clearScreens = function() {
			
			$("#btnEdit,#btnUpdate,#value").prop("disabled",true);
		    $("#value").val("");
			var userId= $('#userId').val();
			//alert(userId)
		getSocietyRulesList(userId);
	}
	clearScreens();
});
function numericKey(e) {
	var evt_mozila = window.event || e;
	if (evt_mozila) {
		var charcode = evt_mozila.keyCode || evt_mozila.which;
		if ((charcode > 31) && (charcode < 46) || (charcode > 57)) {
			//alert("ENTER NUMBER!!");
			return false;
		}
		return true;
	}
 }