
$(document).ready(function() {
	
	displayScreenDetails("General Ledger");
	/*var sel = document.getElementById("purCode");
	var options = sel.options;
	for(var i=options.length;i>0;i--){
		sel.remove(i);
	}
	$('#purCode').trigger("chosen:updated");*/
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
	
	$('#Printbtn').click(function(){
		
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
		
		var req="generalLedgerReoprt";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/RecieptController";
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
	
	
	
	
	

});
