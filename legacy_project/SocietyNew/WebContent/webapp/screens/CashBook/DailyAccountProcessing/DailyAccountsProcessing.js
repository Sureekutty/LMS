
$(document).ready(function() {

	displayScreenDetails("Daily Accounts Processing");
	var currdate=$('#currDate').val();
	$('#processsdate').val(currdate);

	$('#printbtn').click(function(){
		var processsdate=$('#processsdate').val();

		var req="regreport";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/DailyAccountsProcessing";
		document.body.appendChild(frm);
		var in1 = document.createElement("input");
		in1.type='hidden';in1.name='processsdate';in1.value=processsdate;

		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='req';in3.value=req;

		frm.appendChild(in1);
		frm.appendChild(in3);

		frm.submit();
	});


	$('#processbtn').click(function(){

		var processdate=$('#processsdate').val();

		$.post('/SocietyNew/DailyAccountsProcessing',{
			req:'acountsprocessing',
			porocessdate:processdate,
			option:'processing',
		},function(data){

			try{
				var pop_data = eval("("+data+")");
				if(pop_data.success='Y'){
					alert("Process Successfully")
				}
			}catch(e){

				alert("Exception in DailyAccountsProcessing "+e)	
			}
		})
	});


});
