$(document).ready(function() {

	displayScreenDetails(" Interest ");
	$(':input:not([type=button],[id=depositDate])').val('');
	$("#interest").val('');

	
	$('#Duration,#MinMaxAmount').hide();
	$("#btnClearAll").click(function() {
		
		clearAllTheFields();
		
	});
	

	
	//var intCode=null;
	$("#interest").change(function(){
		var intCodeArr=$("#interest").val().split("-");
		alert(intCodeArr)
		 intCode=intCodeArr[0];
		 var serialNo=intCodeArr[1];
		 alert("serial no "+serialNo)
		 fetchInterestvalues(intCode,serialNo)
	});
	

	clearAllTheFields = function(){
		$(':input:not([type=button])').val('');
		$('#Duration,#MinMaxAmount').hide();
		$("#rateofinterest,#effectedfromdate,#effectedtodate,#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").val('');
		$("#interest,#interestterm,#typeofinterest").val('').trigger("chosen:updated");
	}
	clearAllTheFields();
	
	
	$("#interest").change(function() {
			if(intCode=="FXD"||intCode=="RCD"){
				$('#Duration,#MinMaxAmount').show();
				$("#durationfrommonth,#durationtomonth,#minAmount,#maxAmount").prop('disabled',true);
			}
			else{$('#Duration,#MinMaxAmount').hide();}
	});
	fetchInterestDescription = function(type) {
		
	$.post('/SocietyNew/genericsDetails',{
			type :type ,req:'fetchtinginterest',
	},function (data) {
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.interest;
			
			var sel = document.getElementById("interest");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i].IntDescription;
				option.text=temp;
				var value=arr[i].IntCode+"-"+arr[i].SlNo;
				option.value=value;
				sel.add(option);
			}
			$("#interest").trigger("chosen:updated");
			$("#interest").prop("disabled" ,false);
			
			$('#interest').change(function() {
			});
		
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeList ' +e.message)
		}
	});
}
	
	fetchInterestDescription('fetch');
	
	
	fetchInterestvalues = function(code,serialNo){
	
		$.post('/SocietyNew/genericsDetails',{
			code :code,serialNo:serialNo ,req:'interestvalues',
		},function (data) {
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr=pop_data.IntValues;
				$("#rateofinterest").val(arr[0].RateOfInterest);
				$("#durationfrommonth").val(arr[0].MinMonth);
				$("#durationtomonth").val(arr[0].MaxMonth);
				$("#effectedfromdate").val(arr[0].EffFromDate);
				
				$("#interestterm").val(arr[0].InterstCalcTerm);
				$("#interestterm").trigger("chosen:updated");
				
				
				$("#typeofinterest").val(arr[0].InterestType);
				$("#typeofinterest").trigger("chosen:updated");
				$("#interestterm,typeofinterest,#rateofinterest").prop("disabled" ,true);
				
				$("#minAmount").val(arr[0].MinAmount);
				$("#maxAmount").val(arr[0].MaxAmount);
				
				$('#btnUpdate').prop('disabled',false);
				}
				
			
			 catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeCodeList ' +e.message)
			}
		});
	}
	
	$('#btnUpdate').click(function() {
		var confm=confirm("click OK to continue");
		var intCodeArr=$("#interest").val().split("-");
		
		var intCode=intCodeArr[0];
		
		var serialNo=intCodeArr[1];
	
		var minAmount =$("#minAmount").val();
	
		var maxAmount=$("#maxAmount").val();
		
		var rateofinterest=$("#rateofinterest").val();
		
		var effectedfromdate=$("#effectedfromdate").val();
		
		var typeofinterest=$("#typeofinterest").val();
		
		var interestterm=$("#interestterm").val();

		
		var durationfrommonth=$("#durationfrommonth").val();
		
		var durationToMonth  =$("#durationtomonth").val();
	
		
		if(confm){
	updateValues(intCode,serialNo,minAmount,maxAmount,rateofinterest,effectedfromdate,typeofinterest,interestterm,durationfrommonth,durationToMonth);
		
		}	
	})
	
	
	updateValues = function(intCode,serialNo,minAmount,maxAmount,rateofinterest,effectedfromdate,typeofinterest,interestterm,durationfrommonth,durationToMonth) {
		
		$.post('/SocietyNew/genericsDetails',{
			req:'updateValues',
			Option:'update',
			intCode:intCode,
			serialNo:serialNo,
			minAmount:minAmount,
			maxAmount:maxAmount,
			rateofinterest:rateofinterest,
			effectedfromdate:effectedfromdate,
			typeofinterest:typeofinterest,
			interestterm:interestterm,
			durationfrommonth:durationfrommonth,
			durationToMonth:durationToMonth,
		}, function(data) {
			try {
				var pop_data=eval("("+data+")");
				
				if(pop_data.success=="Y")
					{
					alert("Updated Successfully")
					//fetchInterestvalues(intCode,serialNo);
					$('#btnUpdate').prop('disabled',true);
					}
				else
					{
						alert("Failed to update")
					}
			} catch (e) {
				alert("Exception in Interest updateValues "+e.message);
			}
		})
	}
});






function numericKey(e) {
	var evt_mozila = window.event || e;
	if (evt_mozila) {
		var charcode = evt_mozila.keyCode || evt_mozila.which;
		if ((charcode > 31) && (charcode < 46) || (charcode > 57)) {
			alert("Enter Number!!");
			return false;
		}
		return true;
	}
}
