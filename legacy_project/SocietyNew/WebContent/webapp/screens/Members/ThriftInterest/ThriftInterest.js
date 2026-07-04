

$(document).ready(function() {
	
	displayScreenDetails(" Thrift Interest")
	
	
	$("#btnPrint").click(function() {

		var intRate = $('#intRate').val();
		var fromDate = $('#fromDate').val();
		var toDate = $('#toDate').val();
		var req = "MemThriftIntDetails";
		var frm = document.createElement("form");
		frm.method = "GET";
		frm.name = "GenPDF_FORM";
		frm.action = "/SocietyNew/downloadExcel";
		document.body.appendChild(frm);

		var in1 = document.createElement("input");
		in1.type = 'hidden';
		in1.name = 'intRate';
		in1.value = intRate;
		
		var in2 = document.createElement("input");
		in2.type = 'hidden';
		in2.name = 'fromDate';
		in2.value = fromDate;

		var in3 = document.createElement("input");
		in3.type = 'hidden';
		in3.name = 'toDate';
		in3.value = toDate;
		
		var in4 = document.createElement("input");
		in4.type = 'hidden';
		in4.name = 'req';
		in4.value = req;

		frm.appendChild(in1);
		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.appendChild(in4);

		frm.submit();

	});		
	
	
	$("#thriftPoll").click(function() {

		
		var req = "MemThriftPoll";
		var frm = document.createElement("form");
		frm.method = "GET";
		frm.name = "GenPDF_FORM";
		frm.action = "/SocietyNew/downloadExcel";
		document.body.appendChild(frm);

		var in1 = document.createElement("input");
		in1.type = 'hidden';
		in1.name = 'req';
		in1.value = req;
		
		
		frm.appendChild(in1);
		

		frm.submit();

	});		

});
