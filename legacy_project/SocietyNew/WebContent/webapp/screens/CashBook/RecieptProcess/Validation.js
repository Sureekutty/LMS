$(document).ready(function() {
	clearScreens();
	$('#btnClearAll').click(function() {
		clearScreens();
	});

	var valid = function(){

		var memCode=($("#memCode").val().split("-"))[0]
		var recNo=($("#recNo").val().split("-"))[0]

		if(memCode==null||memCode=="")
		{
			alert("select Account Number");
			return;
		}
		else{$("#recNo").prop('disabled',false);}

		if(recNo==null||recNo=="")
		{
			alert("select Reciept Number");
			$("#ModeOfPay,#amount,#PurposeDesc").text("");
			return;
		}
		//else{$("#ModeOfPay,#amount,#PurposeDesc").text("");}
		return true;
	}	
});




clearScreens = function() {

	$(':input').not('[type=button]').val('');
	$("#recNo").prop('disabled',true);
	$("#recNo").trigger("chosen:updated");
	$("#ModeOfPayTR,#amountTR,#PurposeDescTR").hide();
	getMemberCodeList("SOCIETYMEM");
}





