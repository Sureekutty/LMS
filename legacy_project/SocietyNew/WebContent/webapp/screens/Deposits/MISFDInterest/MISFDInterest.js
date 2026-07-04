$(document).ready(function() {	
	displayScreenDetails(" MIS FD Interest ");	
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
		});
	var role = $('#Role').val();
	if(role==2){
		$('#btnProcess').val('ProcessApproval');
		$('#btnProcess').css({'width':'150px'});
	}
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
		$.post('/SocietyNew/DepositProcessingController',{
			month: month,
			datatype:'JSON',
			year :year,
			role: role,
			req:'processMIS',
		},function(data){
			
			$('#dialog1').dialog('close');
			try {
				var pop_data = eval("(" + data + ")");	

				if(pop_data.MISDETAILS=="N"){
					findgrid.cleanContent()
					alert("NO DATA")
				}else{
					if(role==2)
						alert(pop_data.msg);
				findgrid.setContent(pop_data.MISDETAILS);
				}
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getting mis list ' +e.message)
			}
			
		});
		
	});
	
	$('#PRINT').click(function() {
		var all=findgrid.dataset.data;
		var JsonData = JSON.stringify(all);
		
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
		//var monandyear = "01/"+month+"/"+year;
		var req = "MemGenpdfforMISPayments";
		var frm = document.createElement("form");
		frm.method = "POST";
		frm.name = "GenPDF_FORM";
		frm.action = "/SocietyNew/DepositProcessingController";
		//frm.target = "_blank";
		document.body.appendChild(frm);

		var in1 = document.createElement("input");
		in1.type = 'hidden';
		in1.name = 'req';
		in1.value = req;
		
		var in2 = document.createElement("input");
		in2.type = 'hidden';
		in2.name = 'month';
		in2.value = month;

		var in3 = document.createElement("input");
		in3.type = 'hidden';
		in3.name = 'JsonData';
		in3.value = JsonData;
		
		var in4 = document.createElement("input");
		in4.type = 'hidden';
		in4.name = 'year';
		in4.value = year;
		
	
		
		
		frm.appendChild(in1);
		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.appendChild(in4);

		frm.submit();
		//clearFields();
		
	});
		
});

