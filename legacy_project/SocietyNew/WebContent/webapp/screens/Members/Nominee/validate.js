$(document).ready(function(){

	
	onload = function(){
		$(':input:not([type=button])').val('');
		//$('#Duration,#MinMaxAmount').hide();
		//$("#nomineename,#nomineedob,#nomineerefno").prop("disabled" ,true);
		//$("#relationship,#gender").prop('disabled',true).trigger("chosen:updated");
		
	}
	onload();
	
	
	/*$('#btnClearAll').click(function() {
		
		$("#empcode").val("");
		$("#relationship,#gender").val("").trigger("chosen:updated");
		$("#nomineename,#nomineedob,#nomineerefno").prop("disabled" ,true);
		$("#relationship,#gender").prop('disabled',true).trigger("chosen:updated");
		$("#empcode").prop('disabled',false).trigger("chosen:updated");
		
	})*/
	
	
	
	
	$('#empcode').change(function(){
		/*$("#nomineename,#nomineedob,#nomineerefno").val("");
		$("#relationship,#gender").val('').trigger("chosen:updated");
		$("#nomineename,#nomineedob,#nomineerefno").prop('disabled',true);
		$("#relationship,#gender").prop('disabled',true).trigger("chosen:updated");	
		if(this.value  == null||this.value  == "")
			{
				$("#nomineename").prop('disabled',true);
			}
			else{
				$("#nomineename").prop('disabled',false);
			}
		*/
			var memAccNo = (($("#empcode").val()).split("-"))[0];
			
			/*var nomineeName = $('#nomineename').val();
			var nomineeDob = $('#nomineedob').val();
			var relationShip = $('#relationship').val();
			var gender = $('#gender').val();
			*/
			$.post('/SocietyNew/NomineeController',{
				req : 'gettinggriddata',
				option:"GRIDDATA",
				memAccNo:memAccNo,
				
			},function(data){
				
				try {
					var pop_data = eval("("+data+")");
					findgrid.cleanContent();
					findgrid.setContent(pop_data.nomDetails);
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Nominee ' +e.message)
				}
				
			});
		
	});
		

	 
	 /*$('#nomineename').change(function(){
		//alert("Deposit alert")
		  //$("#nomineedob,#nomineerefno").val("");
		  //$("#relationship,#gender").val('').trigger("chosen:updated");
		 // $("#nomineedob,#nomineerefno").prop('disabled',true);
			//$("#relationship,#gender").prop('disabled',true).trigger("chosen:updated");	
		  //$("#Amount,#duration,#interest").prop('disabled',true).trigger("chosen:updated");
		  //$("#Amount").prop('disabled',true);
			if(this.value  == null||this.value  == "")
			{
				$("#nomineedob").prop('disabled',true);
			}
			else{
				$("#nomineedob").prop('disabled',false);
			}
	 })*/
/*	$('#nomineedob').change(function(){
		//alert("Deposit alert")
		 // $("#nomineerefno").val("");
		 // $("#relationship,#gender").val('').trigger("chosen:updated");
		 // $("#nomineerefno").prop('disabled',true);
			//$("#relationship,#gender").prop('disabled',true).trigger("chosen:updated");	
		  //$("#duration,#interest").prop('disabled',true).trigger("chosen:updated");
		  //$("#Amount").prop('disabled',true);
			if(this.value  == null||this.value  == "")
			{
				$("#relationship").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#relationship").prop('disabled',false).trigger("chosen:updated");
			}
	 })*/
	 
	 
 
	/* 	 $('#relationship').change(function(){
		//alert("Deposit alert")
	 		// $("#nomineerefno").val("");
	 		$("#gender").val('').trigger("chosen:updated");
	 		//$("#nomineerefno").prop('disabled',true);
			
		  //$("#Amount").prop('disabled',true);
			if(this.value  == null||this.value  == "")
			{
				$("#gender").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#gender").prop('disabled',false).trigger("chosen:updated");
			}
	 })*/

	 
	/* 
	 $('#gender').change(function(){
		//alert("Deposit alert")
		 //$("#nomineerefno").val("");
		 //$("#durationtomonth,#minAmount,#maxAmount").prop('disabled',true);
		  //$("#Amount").prop('disabled',true);
			if(this.value  == null||this.value  == "")
			{
				$("#nomineerefno").prop('disabled',true);
			}
			else{
				$("#nomineerefno").prop('disabled',false);
			}
	 })*/
	 
	
	 
	 
	
	 
});



validateSave = function() {
	
	var nomineeName = $('#nomineename').val();
	if(nomineeName == ''|| nomineeName == undefined){
		alert('Select nomineeName');
		return false;
	}
	var nomineeDob = $('#nomineedob').val();
	if(nomineeDob == ''|| nomineeDob == undefined){
		alert('Select nomineeDob');
		return false;
	}
	var relationShip = $('#relationship')
	if(relationShip =='' || relationShip == undefined){
		alert('Select relationship');
		return false;
	}
	
	var gender = $('#gender').val();
	if(gender =='' || gender == undefined){
		alert('Select gender');
		return false;
	}
	return true
} 




	
	/*validateSave = function() {
		var memCode = $("#memCode").val();
		if(memCode == 'Select'){
			alert('Select employee ');
			return;
		}
		getReceipts();
		
		var purpose = $('#purpose').val();
		if(purpose == 'Select'){
			alert('Select purpose');
			return;
		}
		
		var recieptDate = $('#recieptDate').val();
		var amount = parseInt($('#Amount').val(), 10);
		if(amount == 0 || isNaN(amount.toString())){
		alert('Enter Amount ');
		return;
		}
		return true
	} */
	
 

