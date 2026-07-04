
$(document).ready(function() {
	
	displayScreenDetails("Reports");
	var picker = new Pikaday({
	    field: document.getElementById('recefromDate'),
	    format: 'DD/MM/YYYY',
	    //minDate: new Date(),
	    maxDate: new Date(),
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	});

	var picker = new Pikaday({
	    field: document.getElementById('recetoDate'),
	    format: 'DD/MM/YYYY',
	    //minDate: new Date(),
	    maxDate: new Date(),
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	});
	var picker = new Pikaday({
	    field: document.getElementById('payfromDate'),
	    format: 'DD/MM/YYYY',
	    //minDate: new Date(),
	    maxDate: new Date(),
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	});

	var picker = new Pikaday({
	    field: document.getElementById('paytoDate'),
	    format: 'DD/MM/YYYY',
	    //minDate: new Date(),
	    maxDate: new Date(),
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	});
	
	var picker = new Pikaday({
	    field: document.getElementById('cashfromDate'),
	    format: 'DD/MM/YYYY',
	    //minDate: new Date(),
	    maxDate: new Date(),
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	});

	var picker = new Pikaday({
	    field: document.getElementById('cashtoDate'),
	    format: 'DD/MM/YYYY',
	    //minDate: new Date(),
	    maxDate: new Date(),
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	});
		
	$('#RecePrintbtn').click(function(){
		var recfromdate=$('#recefromDate').val();
		var rectodate=$('#recetoDate').val();
		var purCode = $('#purCode').val();
		
		var purDesc =  $('#purCode').find('option:selected').text();
		if(purCode=='' || purCode==undefined){
			alert("Select Purpose Code")
			return;
		}
		if(recfromdate=='' || recfromdate==undefined){
			alert("Select Receipt From Date")
			return;
		}
		if(rectodate=='' || rectodate==undefined){
			alert("Select Receipt To Date")
			return;
		}
		
		var recfromdate1 = recfromdate.split('/')[0];
		var recfromdate2=recfromdate.split('/')[1];
		var recfromdate3=recfromdate.split('/')[2];
		var receiptfromdate =recfromdate2.trim()+"/"+recfromdate1.trim()+"/"+recfromdate3.trim();
		
		var rectodate1 = rectodate.split('/')[0];
		var rectodate2=rectodate.split('/')[1];
		var rectodate3=rectodate.split('/')[2];
		var receipttodate =rectodate2.trim()+"/"+rectodate1.trim()+"/"+rectodate3.trim();
			
			var daterecfrom = new Date(""+receiptfromdate+"");
			var daterecto = new Date(""+receipttodate+"");
			if(daterecfrom.getTime() >daterecto.getTime()){
				$('#recefromDate').val('');
				$('#recetoDate').val('');
				alert("InValid Selected Dates")
				return;
			}
		
		var req="regreport";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/RecieptController";
		frm.target = "_blank";
		document.body.appendChild(frm);

		
		var in1 = document.createElement("input");
		in1.type='hidden';in1.name='receiptfromdate';in1.value=receiptfromdate;
		
		var in2 = document.createElement("input");
		in2.type='hidden';in2.name='receipttodate';in2.value=receipttodate;
		
		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='req';in3.value=req;
		
		var in4 = document.createElement("input");
		in4.type='hidden';in4.name='purCode';in4.value=purCode+"-"+purDesc;
		
		frm.appendChild(in1);
		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.appendChild(in4);
		
		frm.submit();
	});
	
	
	$('#payPrintBtn').click(function(){
	
		var payfromDate=$('#payfromDate').val();
		var paytoDate=$('#paytoDate').val();
		var purCode = $('#purCode').val();
		var purDesc =  $('#purCode').find('option:selected').text();
	
		if(purCode=='' || purCode==undefined){
			alert("Select Purpose Code")
			return;
		}
		
		if(payfromDate=='' || payfromDate==undefined){
			alert("Select Payment From Date")
			return;
		}
		if(paytoDate=='' || paytoDate==undefined){
			alert("Select Payment To Date")
			return;
		}
		
		var payfromdate1 = payfromDate.split('/')[0];
		var payfromdate2=payfromDate.split('/')[1];
		var payfromdate3=payfromDate.split('/')[2];
		var paymentfromdate =payfromdate2.trim()+"/"+payfromdate1.trim()+"/"+payfromdate3.trim();
		
		var paytodate1 = paytoDate.split('/')[0];
		var paytodate2=paytoDate.split('/')[1];
		var paytodate3=paytoDate.split('/')[2];
		var paymenttodate =paytodate2.trim()+"/"+paytodate1.trim()+"/"+paytodate3.trim();
						
		var datepayfrom = new Date(""+paymentfromdate+"");
		var datepayto = new Date(""+paymenttodate+"");
		if(datepayfrom.getTime() >datepayto.getTime()){
			$('#payfromDate').val('');
			$('#paytoDate').val('');
			alert("InValid Selected Dates")
			return;			
		}
	
		var req="paymentregreport";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/PaymentController";
		document.body.appendChild(frm);
		
		var in1 = document.createElement("input");
		in1.type='hidden';in1.name='paymentfromdate';in1.value=paymentfromdate;
		
		var in2 = document.createElement("input");
		in2.type='hidden';in2.name='paymenttodate';in2.value=paymenttodate;
		
		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='req';in3.value=req;

		var in4 = document.createElement("input");
		in4.type='hidden';in4.name='purCode';in4.value=purCode+"-"+purDesc;
		
		frm.appendChild(in1);
		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.appendChild(in4);
		frm.submit();
	});
	
	$('#cashPrintbtn').click(function(){		
		var cashfromDate=$('#cashfromDate').val();
		var cashtoDate=$('#cashtoDate').val();
		var purCode = $('#purCode').val();
		var purDesc =  $('#purCode').find('option:selected').text();
		
		if(cashfromDate=='' || cashfromDate==undefined){
			alert("Select CashBook From Date")
			return;
		}
		if(cashtoDate=='' || cashtoDate==undefined){
			alert("Select CashBook To Date")
			return;
		}
		
		var cashfromdate1 = cashfromDate.split('/')[0];
		var cashfromdate2=cashfromDate.split('/')[1];
		var cashfromdate3=cashfromDate.split('/')[2];
		var cashfromdate =cashfromdate2.trim()+"/"+cashfromdate1.trim()+"/"+cashfromdate3.trim();		
		var cashtodate1 = cashtoDate.split('/')[0];
		var cashtodate2=cashtoDate.split('/')[1];
		var cashtodate3=cashtoDate.split('/')[2];
		var cashtodate =cashtodate2.trim()+"/"+cashtodate1.trim()+"/"+cashtodate3.trim();
		
		var datecashfrom = new Date(""+cashfromdate+"");
		var datecashto = new Date(""+cashtodate+"");
		if(datecashfrom.getTime() >datecashto.getTime()){
			$('#cashfromDate').val('');
			$('#cashtoDate').val('');
			alert("InValid Selected Dates")
			return;		
		}
	
		var req="cashregreport";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/PaymentController";
		document.body.appendChild(frm);
	
		var in1 = document.createElement("input");
		in1.type='hidden';in1.name='cashfromdate';in1.value=cashfromdate;
		
		var in2 = document.createElement("input");
		in2.type='hidden';in2.name='cashtodate';in2.value=cashtodate;
		
		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='req';in3.value=req;

		var in4 = document.createElement("input");
		in4.type='hidden';in4.name='purCode';in4.value=purCode+"-"+purDesc;
		
		frm.appendChild(in1);
		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.appendChild(in4);
		
		frm.submit();
	});

});
