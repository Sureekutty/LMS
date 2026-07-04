$(document).ready(function(){

	onload = function(){
		$(':input:not([type=button])').val('');
		$('#Duration,#MinMaxAmount').hide();
		$("#rateofinterest,#effectedfromdate,#effectedtodate").prop("disabled" ,true);
		$("#interestterm,#typeofinterest").prop('disabled',true).trigger("chosen:updated");
		$('#btnUpdate,#btnEdit,#btnClearAll').prop('disabled',true);
	}
	onload();

	$('#btnClearAll').click(function() {
		//callThis();
		$("#interest").val("");
		$("#rateofinterest").prop('disabled',true).trigger("chosen:updated");
		$("#interest").prop('disabled',false).trigger("chosen:updated");
		$('#btnUpdate,#btnEdit,#btnClearAll,#interestterm,#typeofinterest').prop('disabled',true);
	});
	
	$('#interest').change(function() {
		var interest=this.value;
		if(null==interest||""==interest||undefined==interest){return;}
		$('#btnEdit,#btnClearAll').prop('disabled',false);
	})
	
	$('#btnEdit').click(function() {
	$(':input:not([id=interestterm],[id=typeofinterest])').prop('disabled',false);
	$('#btnUpdate').prop('disabled',false)
	$('#btnEdit').prop('disabled',true)
	})
	

	$('#deposit').change(function() {
		var deposit = this.value;
		if(deposit == ''){
			alert('Select deposit');
			return;
		}
	
	});

	$('#interest').change(function(){
		$("#rateofinterest,#effectedfromdate,#effectedtodate,#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").val("");
		$("#interestterm,#typeofinterest").val('').trigger("chosen:updated");
		$("#effectedfromdate,#effectedtodate,#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").prop('disabled',true);
		$("#interestterm,#typeofinterest").prop('disabled',true).trigger("chosen:updated");	
		if(this.value  == null||this.value  == "")
			{
				$("#rateofinterest").prop('disabled',true);
			}
			else{
				$("#rateofinterest").prop('disabled',false);
			}
	 })
	 
	 $('#rateofinterest').change(function(){
		  $("#effectedfromdate,#effectedtodate,#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").val("");
		  $("#interestterm,#typeofinterest").val('').trigger("chosen:updated");
		  $("#effectedtodate,#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").prop('disabled',true);
			$("#interestterm,#typeofinterest").prop('disabled',true).trigger("chosen:updated");	
		
			if(this.value  == null||this.value  == "")
			{
				$("#effectedfromdate").prop('disabled',true);
			}
			else{
				$("#effectedfromdate").prop('disabled',false);
			}
	 })
	$('#effectedfromdate').change(function(){
		  $("#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").val("");
		  $("#interestterm,#typeofinterest").val('').trigger("chosen:updated");
		  $("#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").prop('disabled',true);
			$("#interestterm,#typeofinterest").prop('disabled',true).trigger("chosen:updated");	
			if(this.value  == null||this.value  == "")
			{
				$("#interestterm").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#interestterm").prop('disabled',false).trigger("chosen:updated");
			}
	 })
	 	 $('#interestterm').change(function(){
		
	 		 $("#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").val("");
	 		$("#typeofinterest").val('').trigger("chosen:updated");
	 		$("#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").prop('disabled',true);
			
			if(this.value  == null||this.value  == "")
			{
				$("#typeofinterest").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#typeofinterest").prop('disabled',false).trigger("chosen:updated");
			}
	 })

	 $('#typeofinterest').change(function(){
		
		 $("#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").val("");
		 $("#durationtomonth,#minAmount,#maxAmount").prop('disabled',true);
		  
			if(this.value  == null||this.value  == "")
			{
				$("#durationfrommonth").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#durationfrommonth").prop('disabled',false).trigger("chosen:updated");
			}
	 })
	 
	 $('#durationfrommonth').change(function(){
		
		 $("#durationtomonth,#minAmount,#maxAmount").val("");
		 $("#minAmount,#maxAmount").prop('disabled',true);
		  
			if(this.value  == null||this.value  == "")
			{
				$("#durationtomonth").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#durationtomonth").prop('disabled',false).trigger("chosen:updated");
			}
	 })
	 
	 $('#durationtomonth').change(function(){
		
		 $("#minAmount,#maxAmount").val("");
		 $("#maxAmount").prop('disabled',true);
		
			if(this.value  == null||this.value  == "")
			{
				$("#minAmount").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#minAmount").prop('disabled',false).trigger("chosen:updated");
			}
	 })
	 
	 
	 $('#minAmount').change(function(){
		
		 $("#maxAmount").val("");
		 
			if(this.value  == null||this.value  == "")
			{
				$("#maxAmount").prop('disabled',true).trigger("chosen:updated");
			}
			else{
				$("#maxAmount").prop('disabled',false).trigger("chosen:updated");
			}
	 })
	 
});
	 
	
 

