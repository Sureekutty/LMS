$(document).ready(function() {

	displayScreenDetails("ReceiptProcess");

	getMemberCodeList = function(type) {

		$.post('/SocietyNew/genericsDetails',{

			type : type,req:'employeeList',regstatus : 'ACTIVE',
		},function (data) {
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.EMPLOYEELIST;

				var sel = document.getElementById("memCode");
				var option=document.createElement("option");
				var options=sel.options;

				for(var i=options.length-1;i>0;i--){
					sel.remove(i);
				}


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
	getMemberCodeList("SOCIETYMEM");

	$('#memCode').change(function() {
		$("#ModeOfPay,#amount,#PurposeDesc").text("");
		$("#ModeOfPayTR,#amountTR,#PurposeDescTR").hide();
		$("#recNo").prop('disabled',false);

		var memCode=(($('#memCode').val()).split("-"))[0];

		if(null!=memCode){

			$.post('/SocietyNew/recieptController',{
				memCode:memCode,
				req:'recieptList',
				status : 'ACTIVE',
			},function (data) {
				try {
					var pop_data = eval("("+data+")");
					var arr = new Array();
					arr = pop_data.reciept;

					var sel = document.getElementById("recNo");
					var option=document.createElement("option");
					var options=sel.options;

					for(var i=options.length-1;i>0;i--){
						sel.remove(i);
					}

					for(var i=0;i<arr.length;i++){	
						var option=document.createElement("option");
						var temp = arr[i].reciept;
						option.text=temp;
						option.value=arr[i].PurposeCode;

						sel.add(option);

					}	
					$("#recNo").trigger("chosen:updated");

				} catch (e) {
					// TODO: handle exception
					alert('Exception in RecieptList ' +e.message)
				}

			});
		}
	});
	var recieptNo=""
		$('#recNo').change(function(){
			$("#ModeOfPay,#amount,#PurposeDesc").text("");
			recieptNo=(($("#recNo option:selected").text()).split("-"))[0];
			var memCode=$('#memCode').val();
			var paycode=$("#recNo").val();

			if(null!=recieptNo||""!=recieptNo){
				$.post('/SocietyNew/recieptController',{
					recieptNo:recieptNo,
					memCode:memCode,
					req:'recieptDetail',
					paycode:paycode,
				},function (data) {
					try {
						var pop_data = eval("("+data+")");
						if(pop_data.success=="Y"){
							var arr = new Array();
							arr = pop_data.ReciDetail;

							$("#ModeOfPay").text(arr[0]);
							$("#amount").text(arr[1]);
							$("#PurposeDesc").text(arr[2]);
							$("#ModeOfPayTR,#amountTR,#PurposeDescTR").show();
							$("#btnCancel").prop('disabled',false)
						}
					} catch (e) {
						alert('Exception in getEmployeeCodeList ' +e.message)
					}

				});
			}
		});

	$("#btnCancel").click(function(){
		var recieptNo=(($("#recNo option:selected").text()).split("-"))[0];
		var memCode=$('#memCode').val();
		if(recieptNo==null||recieptNo==""){
			alert("select reciept number")
			return;}
		var check=confirm("click ok to continue");
		if(check){
			$.post('/SocietyNew/recieptController',{
				recieptNo:recieptNo,
				memCode : memCode,
				option :'Cancel',
				req:'Cancellation',

			},function (data) {

				try {
					var pop_data=eval("("+data+")");
					if(pop_data.success=="Y"){
						alert("Successfully Cancelled")
						$("#ModeOfPayTR,#amountTR,#PurposeDescTR").hide();
						$("#recNo").prop('disabled',true).trigger("chosen:updated");
						$("#btnCancel").prop('disabled',true)
						//clearScreens();
					}else{alert("Not Saved")}

					//$("#recNo,#memCode").trigger("chosen:updated");
				} catch (e) {

					alert('Exception in Cancelling ' +e.message)
				}

			});
		}

	});



})