var typeOfSearch = '';
var ApplicationSearch='';
var memAccnountNumber = '';
var ApplicationNumber='';
var save_update = '';
var memActive = '';
$(document).ready(function(){
	cleardepositstatus = function() {
		var sel = document.getElementById("depositstatus");
		var options = sel.options;
		for (var i = options.length; i > 0; i--) {
			sel.remove(i);
		}
	}

	getdepositstatuslist = function() {
		cleardepositstatus();
		$.post('/SocietyNew/DepositView', {
			req : 'depositstatuslist',
		}, function(data) {
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				var error = pop_data.ERROR;
				if(error == 'NO'){
					arr = pop_data.DEPOSITSSTATUS;
					var sel = document.getElementById("depositstatus");
					for(var i=0;i<arr.length;i++){	
						var option=document.createElement("option");
						var temp =arr[i].DepositStatus;
						option.text=temp;
						option.value=temp;
						sel.add(option);
					}
					$("#depositstatus").trigger("chosen:updated");
					$("#depositstatus").prop("disabled" ,false);
				}
				else{
					alert(error);
				}
			}
			catch (e) {
				// TODO: handle exception
				alert('Exception in processTypes ' +e.message)
			}
		});
	}
	onLoad = function() {
		cleardepositstatus();
		getdepositstatuslist();
	}
	onLoad();

	displayScreenDetails(" Deposit view");

	$('#searchMember').val("").prop('disabled',true);
	/* $('#fresh').click(function() {
		 typeOfSearch = 'FRESH';
		 getMemberDetails(typeOfSearch)
	});
	 $('#active').click(function() {
		 typeOfSearch = 'SANCTION';
		 getMemberDetails(typeOfSearch)
	}); 
	 $('#cancel').click(function() {
		 typeOfSearch = 'CANCEL';
		 getMemberDetails(typeOfSearch)
	});
	 */
	$('#go').click(function() {
		typeOfSearch = $('#depositstatus').val();
		if(typeOfSearch==''){
			alert("Select Status ")
			return;
		}
		getMemberDetails(typeOfSearch)
	});

	getMemberDetails = function(typeOfSearch) {
		$('#searchMember').val("").prop('disabled',false);
		memAccnountNumber  = '';
		findgrid.cleanContent();
		$.post( '/SocietyNew/DepositView',{
			req : 'gettingdata',
			typeOfSearch : typeOfSearch,
		},
		function(data){
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.MEMBERS;
				if(arr==''){
					alert("NO DATA")
				}
				findgrid.setContent(arr);
			} catch (e) {
				alert('INSIDE CATCH BLOCK ' + e.message);
			}
		});
	}

	$('#delBtn').click(function() {
		if(confirm("Do you want reject the Record")){
			var accNo  = $('#depositnum').val();
			var emplcode = $('#emplcode').val();
			var remarks = $('#Remarks').val();
			if(remarks==""||remarks==undefined){
				alert("Enter Remarks")
				return;
			}
			$.post( '/SocietyNew/deposits',{
				req : 'rejectmember',
				accNo : accNo,
				emplcode:emplcode,
				remarks:remarks,
				type : 'REJECT',
			},
			function(data){
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.success == "y"){
						alert("REJECTED THIS RECORD SUCCESSFULLY");
						$('#actBtn,#delBtn').prop("disabled" ,true);
					}
					else{
						alert("FAILED TO REJECTED")
					}
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Deposit reject ' +e.message)
				}
			});
		}
	});

	$('#actBtn').click(function() {
		if(confirm("Do you want approve the Record")){
			var accNo  = $('#depositnum').val();
			var emplcode = $('#emplcode').val();
			var remarks = $('#Remarks').val();
			if(remarks==""||remarks==undefined){
				alert("Enter Remarks")
				return;
			}
			$.post( '/SocietyNew/deposits',{
				req : 'activemember',
				accNo : accNo,
				emplcode:emplcode,
				remarks:remarks,
				type : 'APPROVE',
			},
			function(data){
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.success == "y"){
						alert("THIS RECORD HAS BEEN APPROVED ");
						$('#actBtn,#delBtn').prop("disabled" ,true);
					}
					else{
						alert("FAILED TO APPROVE")
					}
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Deposit approved ' +e.message)
				}
			});
		}
	});


	$('#depositstatus').change(function(){
		findgrid.cleanContent();
	});


	$('#btnPrint').click(function(){
		var accNo=$('#accNo').val();
		var depositno=$('#DepositNo').text();
		var depositcode=$('#DepositType').text();
		var req="DepositDetails";
		var frm = document.createElement("form");
		frm.method="POST";
		frm.name="GenPDF_FORM";
		frm.action="/SocietyNew/deposits";
		document.body.appendChild(frm);

		var in1 = document.createElement("input");
		in1.type='hidden';in1.name='depositno';in1.value=depositno;

		var in2 = document.createElement("input");
		in2.type='hidden';in2.name='accNo';in2.value=accNo;

		var in3 = document.createElement("input");
		in3.type='hidden';in3.name='req';in3.value=req;

		var in4 = document.createElement("input");
		in4.type='hidden';in4.name='depositcode';in4.value=depositcode;

		frm.appendChild(in1);
		frm.appendChild(in2);
		frm.appendChild(in3);
		frm.appendChild(in4);
		frm.submit();
	});

	$('#actEdit').click(function() {
		if(confirm("Do you want to edit the record..??")){
			var depositnum=$('#depositnum').val();
			var memAccno=$('#accNo').val();
			var frm = document.createElement("form");
			frm.method="POST";
			frm.name="Deposit";
			frm.action="/SocietyNew/webapp/screens/Deposits/Deposits/Deposits.jsp";
			document.body.appendChild(frm);

			var in1 = document.createElement("input");
			in1.type='hidden';in1.name='depositnum';in1.value=depositnum;

			var in2 = document.createElement("input");
			in2.type='hidden';in2.name='memAccno';in2.value=memAccno;

			frm.appendChild(in1);
			frm.appendChild(in2);

			frm.submit();
		}
	});	 

	$('#btnDepositProcess').click(function() {
		if(confirm("Do you want to Process this record..??")){
			var depositno=$('#DepositNo').text();
			var memAccno=$('#accNo').val();
			var deposittype=$('#DepositType').text();
			var frm = document.createElement("form");
			frm.method="POST";
			frm.name="Deposit";
			frm.action="/SocietyNew/webapp/screens/Deposits/Depositsprocessing/depositsProcessing.jsp";
			document.body.appendChild(frm);

			var in1 = document.createElement("input");
			in1.type='hidden';in1.name='depositno';in1.value=depositno;

			var in2 = document.createElement("input");
			in2.type='hidden';in2.name='memAccno';in2.value=memAccno;

			var in3 = document.createElement("input");
			in3.type='hidden';in3.name='deposittype';in3.value=deposittype;

			frm.appendChild(in1);
			frm.appendChild(in2);
			frm.appendChild(in3);

			frm.submit();
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
			});
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
		var accNo=$('#memAccNo1').val();
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
});

