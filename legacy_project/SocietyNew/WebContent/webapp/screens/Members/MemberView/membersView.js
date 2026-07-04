var typeOfSearch = '';
var ApplicationSearch='';
var memAccnountNumber = '';
var ApplicationNumber='';
var save_update = '';
var memActive = '';
var load = false;
$(document).ready(function(){
	
	displayScreenDetails(" Members view");
	
	$('#searchMember').val("").prop('disabled',true);
	
	
	$('#pendAppl').click(function() {
		typeOfSearch = 'SUBMIT';
		getApplicationDetails(typeOfSearch)
		
	});
	
	
	
	 $('#all').click(function(){
		 typeOfSearch = 'ALL';
		 getMemberDetails(typeOfSearch)
	 });
	 
	 $('#activeMem').click(function() {
		 typeOfSearch = 'ACTIVE';
		 getApplicationDetails(typeOfSearch)
	});
	 $('#cancAppl').click(function() {
		 typeOfSearch = 'CANCEL';
		 getMemberDetails(typeOfSearch)
	}); 

	 
	 getMemberDetails = function(typeOfSearch) {
		 $('#dialog1').dialog('open');
		 $('#searchMember').val("").prop('disabled',false);
		memAccnountNumber  = '';
		findgrid.cleanContent();
		
		$.post( '/SocietyNew/MembersView',{
				req : 'searchAll',
				typeOfSearch : typeOfSearch,
			},
			function(data){
				$('#dialog1').dialog('close');
				try {
					var pop_data = eval("("+data+")");
					var arr = new Array();
		    		arr = pop_data.MEMBERS;
		    		if(arr == ''){
		    			alert("    NO DATA   ");
		    		}
		    		
		    		findgrid.setContent(arr);
				} catch (e) {
					alert('Inside Catch Block ' + e.message);
				}
				
			}
	    );
	}
	 
	 getApplicationDetails = function(typeOfSearch) {
		 
		 $('#dialog1').dialog('open');
		 $('#searchMember').val("").prop('disabled',false);
		ApplicationNumber  = '';
		findgrid.cleanContent();
		$.post( '/SocietyNew/MembersView',{
				req : 'searchAppl',
				datatype:'JSON',
				typeOfSearch : typeOfSearch,
			},
			function(data){
				
				try {
					var pop_data = eval("("+data+")");
					var arr = new Array();
		    		arr = pop_data.APPLICATION;
		    		if(arr == ''){
		    			alert("    NO DATA   ");
		    		}
		    		findgrid.setContent(arr);
		    		
		    		$('#dialog1').dialog('close');
				} catch (e) {
					alert('Inside Catch Block ' + e.message);
				}				
			});
	}
	 
	$('#btnCancel').click(function() {
		if(confirm("Do you want to cancel the Membership..?")){
				updateMembership('CANCEL');
		 }
	});	$('#btnApprove').click(function() {
		if(confirm("Do you want to Approve the Membership..?")){
			
			
			var Rmarks  = $('#Remarks').val();
			if(Rmarks==""||Rmarks==undefined){
				alert("Enter Remarks")
				return;
			}
			updateMembership('REGISTER');
		}
	 });
	
	updateMembership = function(Option) {
		var  memAccnountNumber = $('#accNo').val();
		
		var userId  = $('#userId').val();
		var memcode=$('#memempcode').val();
		var Remarks  = $('#Remarks').val();
		alert(memAccnountNumber+" memaccno "+memcode)
		$.post('/SocietyNew/MembersView',{
			req : 'updateMembership',
			Option:Option,
			memAccnountNumber:memAccnountNumber,
			Remarks:Remarks,
			userId:userId,
			memcode :memcode,
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
	$('#btnPrint').click(function(){
		 var accNo=$('#accNo').val();

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
	
	$("#btnMemship").click(function(){

			 var accNo=$('#accNo').val();
			var req="MemGenpdfform";
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
	
	
	
	
	
	
	 $('#btnEdit').click(function() {
		 
	
		 
		 //alert('typeOfSearch '+ typeOfSearch)
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

