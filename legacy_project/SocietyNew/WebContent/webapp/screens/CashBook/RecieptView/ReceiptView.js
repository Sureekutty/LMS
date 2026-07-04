var typeOfSearch = '';
var ApplicationSearch='';
var memAccnountNumber = '';
var ApplicationNumber='';
var save_update = '';
var memActive = '';
$(document).ready(function(){

	displayScreenDetails(" Receipt view");
	$('#searchMember').val("").prop('disabled',true);
	
	$('#fresh').click(function() {
		typeOfSearch = 'SUBMIT';
		getMemberDetails(typeOfSearch)
	});

	$('#active').click(function() {
		var recfromdate=$('#recefromDate').val();
		if(recfromdate==''||recfromdate==undefined){
			alert("Enter From Date")
			return;
		}
		typeOfSearch = 'ACTIVE';
		$('#editBtn').hide();
		getMemberDetails(typeOfSearch)
	}); 

	$('#cancel').click(function() {
		typeOfSearch = 'CANCEL';
		$('#editBtn').hide();
		getMemberDetails(typeOfSearch)
	});

	getMemberDetails = function(typeOfSearch) {
		if(typeOfSearch == 'CANCEL' || typeOfSearch == 'SUBMIT'){
			var recfromdate='14/05/2025';
			var rectodate='14/05/2025';
		}
		else{
			var recfromdate=$('#recefromDate').val();
			var rectodate=$('#recetoDate').val();
		}
		$('#searchMember').val("").prop('disabled',false);
		memAccnountNumber  = '';
		
		findgrid.cleanContent();
		$('#dialog1').dialog('open');
		$.post('/SocietyNew/ReceiptView',{
			req : 'gettingdata',
			typeOfSearch : typeOfSearch,
			recfromdate : recfromdate,
			rectodate : rectodate,
		},
		function(data){
			$('#dialog1').dialog('close');
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				for(var i=0;i<pop_data.RECEIPTS.length;i++){
					pop_data.RECEIPTS[i].memAccno=pop_data.RECEIPTS[i].memEmpCode+"-"+pop_data.RECEIPTS[i].memAccno;
				}				
				arr = pop_data.RECEIPTS;
				findgrid.setContent(arr);
			}catch (e) {
				alert('Inside Catch Block ' + e.message);
			}
		});
	}


	$('#delBtn').click(function() {
		if(confirm("Do you want reject the Record")){
			var accNo  = $('#receiptno').text();
			var emplcode= $('#memAccno1').val();
			var Remarks=$('#Remarks').val();
			if(Remarks==''||Remarks==undefined){
				alert("Enter Remarks")
				return;
			}
			$.post( '/SocietyNew/RecieptController',{
				req : 'rejectmember',
				accNo : accNo,
				emplcode: emplcode,
				Remarks:Remarks,
				type : 'CANCEL',
			},
			function(data){
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.success == "y"){
						alert("Rejected Record Successfully");
						$('#actBtn,#delBtn').prop("disabled" ,true);
					}
					else{
						alert("Rejected Failed")
					}
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Deposit reject ' +e.message)
				}
			});
		}
	});

	$('#btnPrint').click(function(){
		var accNo=$('#memAccno1').val();
		var receiptno=$('#receiptno').text();
		var req="MemGenpdfReceiptLedger";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/RecieptController";
		document.body.appendChild(frm);

		var in1 = document.createElement("input");
		in1.type='hidden';in1.name='accNo';in1.value=accNo;

		var in2 = document.createElement("input");
		in2.type='hidden';in2.name='receiptno';in2.value=receiptno;

		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='req';in3.value=req;

		frm.appendChild(in1);
		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.submit();
	});

	$('#actBtn').click(function() {
		if(confirm("Do you want approve the Record")){
			var accNo  = $('#receiptno').text();
			var emplcode=$('#memAccno1').val();
			var Remarks=$('#Remarks').val();
			if(Remarks==''||Remarks==undefined){
				alert("Enter Remarks")
				return;
			}

			$.post( '/SocietyNew/RecieptController',{
				req : 'activemember',
				accNo : accNo,
				emplcode : emplcode,
				Remarks:Remarks,
				type : 'ACTIVE',
			},
			function(data){
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.success == "y"){
						alert("This Record Activated ");
						$('#actBtn,#delBtn').prop("disabled" ,true);
					}
					else{
						alert(" Activate Failed")
					}
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Deposit approved ' +e.message)
				}
			});
		}
	});

	/* getApplicationDetails = function(typeOfSearch) {
		 $('#searchMember').val("").prop('disabled',false);
		ApplicationNumber  = '';
		findgrid.cleanContent();
		$.post( '/SocietyNew/MembersView',{
				req : 'searchAppl',
				typeOfSearch : typeOfSearch,
			},
			function(data){
				try {
					var pop_data = eval("("+data+")");
					var arr = new Array();
		    		arr = pop_data.APPLICATION;
		    		findgrid.setContent(arr);
				} catch (e) {
					alert('INSIDE CATCH BLOCK ' + e.message);
				}
			}
	    );
	}

	$('#btnCancel').click(function() {
		if(confirm("Do you want to cancel the Membership..?")){
				updateMembership('CANCEL');
		 }
	});
	$('#btnApprove').click(function() {
		if(confirm("Do you want to Approve the Membership..?")){
			updateMembership('REGISTER');
		}
	 });

	updateMembership = function(Option) {
		var  memAccnountNumber = $('#accNo').val();
		var remarks = $('#remarks').val();
		var userId  = $('#userId').val();
		$.post('/SocietyNew/MembersView',{
			req : 'updateMembership',Option:Option,memAccnountNumber:memAccnountNumber
			,remarks:remarks,userId:userId,
		},function(data){
			try {
				var pop_data = eval("("+data+")");
				alert(pop_data.Updation);
				if(Option == 'REGISTER' )
					$('#btnApprove').prop('disabled',true);
				if(Option == 'CANCEL' )
					$('#btnCancel').prop('disabled',true);

				getMemberDetails(typeOfSearch);
				getApplicationDetails(typeOfSearch);
			} catch (e) {
				// TODO: handle exception
				alert('Exception in updateMembership ' +e.message)
			}
		})
	}

	 $('#btnEdit').click(function() {

//		 alert('typeOfSearch '+ typeOfSearch)
		 if(confirm("Do you want to edit the record..??")){
		 memAccnountNumber = $('#accNo').val();
		 var empCode = $('#empCode').val();

		 var remarks = $('#remarks').val();
			var frm = document.createElement("form");
			frm.method="POST";
			frm.name="Membership";
			frm.action="../Membership/members.jsp";
			document.body.appendChild(frm);

			var in1 = document.createElement("input");
			in1.type='hidden';in1.name='memAccnountNumber';in1.value=memAccnountNumber;

			var in2 = document.createElement("input");
			in2.type='hidden';in2.name='empCodeFromView';in2.value=empCode;

			var in3 = document.createElement("input");
			in3.type='hidden';in3.name='remarks';in3.value=remarks;

			var in4 = document.createElement("input");
			in4.type='hidden';in4.name='typeOfSearch';in4.value=typeOfSearch;

			frm.appendChild(in1);
			frm.appendChild(in2);
			frm.appendChild(in3);
			frm.appendChild(in4);

			frm.submit();
		 }
	 });
	 */
	$("#employeeDetails").click(function(){
		var accNo=$('#memAccno1').val();
		var req="MemGenpdfformDetails";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/MembersView";
		document.body.appendChild(frm);

		var in2 = document.createElement("input");
		in2.type='hidden';in2.name='accNo';in2.value=accNo;

		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='req';in3.value=req;

		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.submit();

	});	 

	$('#editBtn').click(function() {
		if(confirm("Do you want to edit the record..??")){
			var receiptno=$('#receiptno').val();
			var memAccno=$('#memAccno1').val();
			var purposecode=$('#purposecode').text();
			var frm = document.createElement("form");
			frm.method="POST";
			frm.name="Receipt";
			frm.action="/SocietyNew/webapp/screens/CashBook/Receipts/Receipts.jsp";
			document.body.appendChild(frm);

			var in1 = document.createElement("input");
			in1.type='hidden';in1.name='receiptno';in1.value=receiptno;

			var in2 = document.createElement("input");
			in2.type='hidden';in2.name='memAccno';in2.value=memAccno;

			var in3 = document.createElement("input");
			in3.type='hidden';in3.name='purposecode';in3.value=purposecode;

			frm.appendChild(in1);
			frm.appendChild(in2);
			frm.appendChild(in3);
			frm.submit();
		}
	});	 
});

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
