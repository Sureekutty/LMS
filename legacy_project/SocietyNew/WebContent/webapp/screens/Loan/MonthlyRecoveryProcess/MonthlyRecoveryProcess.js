 $(document).ready(function() {
	var dt_obj= new Date();
	
	$(function() {
		  $( "#dialog1" ).dialog({
			  autoOpen: false,
			  dialogClass: 'no-close',
			  position:['CENTER','top+5'],
			  closeOnEscape:false,
			  show: 'blind',
			  hide: 'explode',
			  modal:true,
			});
		} );
	
	var current_month=dt_obj.getMonth();
	var current_year=dt_obj.getFullYear();
	$("#monthproces").val(current_month+1);
	$("#monthproces").text(current_month+1);
	$("#yearproces").val(current_year);
	$("#yearproces").text(current_year);
//	alert("current_month "+current_month)
	/*var sel = document.getElementById("monthproces");
		var option=document.createElement("option");
		var temp =current_month+1;
		option.text=temp;	
		option.value=temp;
		sel.add(option);
		$("#monthproces").val(temp);
		$("#monthproces").text(temp);
	   $("#monthproces").trigger("chosen:updated");
	
	
	
	
		var se = document.getElementById("yearproces");
		var option=document.createElement("option");
			var temp = current_year;
			option.text=temp;	
			option.value=temp;
			se.add(option);
		$("#yearproces").val(temp);
		$("#yearproces").text(temp);
		$("#yearproces").trigger("chosen:updated");*/

/*	var se = document.getElementById("yearproces");
	var option=document.createElement("option");
	option.text=current_year;
	option.value=current_year;
	se.add(option);
	$("#yearproces").val(current_year);*/
	
	
	displayScreenDetails(" Monthly Recovery Advise Process");
	
	$("#btnClearAll").click(function() {
		
		window.location="/SocietyNew/webapp/screens/Loan/MonthlyRecoveryProcess/MonthlyRecoveryProcess.jsp";
		
	});
	
	$('#btnProcess').prop('disabled',false);
	$('#btnView').prop('disabled',true);
		getpurposeCodeList()
	
		
	
	$('#Purpose').change(function(){
		
		$('#btnView').prop('disabled',false);
		
		});

	
		$('#btnProcess').click(function(){
			var month=$('#monthproces').val();
			if(month==''){
				alert("Select Month")
				return;
			}
			
			var year=$('#yearproces').val();
			if(year==''){
				alert("Select Year")
				return;
			}
			$('#dialog1').dialog('open');
			$.post('/SocietyNew/MonthlyRecoveryProcess',{
				month: month,
				year :year,
				req:'recoveryprocess',
			},function(data){
				$('#dialog1').dialog('close');
				try {
					alert(data)
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Monthly Recovery process ' +e.message)
				}
				
			});
			
		});


	$('#btnView').click(function() {
		
		var month=$('#monthproces').val();
		if(month==''){
			alert("Select Month")
			return;
		}
		
		var year=$('#yearproces').val();
		if(year==''){
			alert("Select Year")
			return;
		}
		
		var Purpose=$('#Purpose').val();		
		$.post('/SocietyNew/MonthlyRecoveryProcess',{
			month: month,
			year :year,
			Purpose :Purpose,
			req:'monthlyrecoveryprocess',
		},function(data){			
			try {
				var pop_data = eval("("+data+")");	
				if(pop_data.PURPOSECODEDETAILS=="N"){
					findgrid.cleanContent()
					alert("NO DATA")
				}else{
				findgrid.setContent(pop_data.PURPOSECODEDETAILS);
				}
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in Monthly Recovery process ' +e.message)
			}
			
		});
		
	});
	
	
	
});

 function generateFile(id){
		var month=$('#monthproces').val();
		if(month==''){
			alert("Select Month")
			return;
		}
		var year=$('#yearproces').val();
		if(year==''){
			alert("Select Year")
			return;
		}		
		var Purpose=document.getElementById("Purpose");
		var i;
		var res="";
		for(i=1;i<Purpose.length;i++){			
//			alert("purpose option is  "+Purpose.options[i].value);
			res=res+""+Purpose.options[i].value+",";			
		}		
//		alert("id is  "+id)
		var req="";
		if(id === "text")
			req="monthlyrecoverytextfile";
		if(id === "excel")
			req="monthlyrecoveryexcelfile";
		
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/MonthlyRecoveryProcess";
		document.body.appendChild(frm);
/*		var in1 = document.createElement("input");
		in1.type='hidden';in1.name='val';in1.value=val;*/


		var in2 = document.createElement("input");
		in2.type='hidden';in2.name='req';in2.value=req;
		
		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='month';in3.value=month;
		
		var in4 = document.createElement("input");
		in4.type='hidden';in4.name='res';in4.value=res;
		
		var in5 = document.createElement("input");
		in5.type='hidden';in5.name='year';in5.value=year;
		
	
		

	/*	frm.appendChild(in1); */
		frm.appendChild(in2);
		frm.appendChild(in3);
	    frm.appendChild(in4);
		frm.appendChild(in5);
		frm.submit();


		}
 
getpurposeCodeList = function() {
	
	$.post('/SocietyNew/genericsDetails',{
		req:'getpurposecodes',
		option : 'PURPOSECODE',
	},function (data) {
		
		try {
			
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.ALLPURPOSECODELIST;
			var sel = document.getElementById("Purpose");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp.split('-')[1];
				var string = temp.split('-')[0];
				var purpose = string.split('~');
				option.value=purpose[0];
				sel.add(option);
			}
			$("#Purpose").trigger("chosen:updated");
		} catch (e) {
			// TODO: handle exception
			alert('Exception in purposeCodeList ' +e.message)
		}
		
	});
}


		