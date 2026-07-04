
$(document).ready(function() {
	
	displayScreenDetails("Journal Entries");
	var currDate=$('#currDate').val();
	$('#jvoucherDate').val(currDate)
	var role=$('#Role').val();
	if(role==1){
		$('#btnApprove').hide();
		$('#jvonumcombo').hide();
		asstjvoucher();
	}else{
		$('#btnApprove').show();
		$('#jvonum').hide();
		$('#btnSave').hide();
		$('#jvonumcombo').show();
		getjvouchers();
	}
	$('#Info').val('')
	$('#bills').change(function(){
		$('#amount').val('');
		$('#Info').val('')
		var bill=this.value;
		
		$.post('/SocietyNew/PaymentsBills',{
			req : 'billdata',
		    option:'BILLINFO',
		    bill:bill,
		},function(data){
			try {
				var popData = eval("("+data+")");
				var MemEmpCode=popData.billsDATA[0].MemEmpCode;
				var Name=popData.billsDATA[0].Name;
				var BillingDate=popData.billsDATA[0].BillingDate;
				var Amount=popData.billsDATA[0].Amount;
				var depositNo=popData.billsDATA[0].depositNo;
				var Remarks=popData.billsDATA[0].Remarks;
				$('#amount').val(Amount)
				$('#Info').val("EmpCode   :"+MemEmpCode+"\nName         :"+Name+"\nBill Date     :"+BillingDate+"\nAmount      :"+Amount+"\nDeposit No :"+depositNo);
				$('#remarks').val(Remarks)
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getting Bill Info ' +e.message)
			}
		});
	});
	
	$("#btnSave").click(function() {
		if(confirm("Do you want save the Record")){
			var jvoucherDate=$('#jvoucherDate').val();
			if(jvoucherDate==''){
				alert("Select Journal Date");
				return;
			}
			var bills=$('#bills').val();
			if(bills==''){
				alert("Select Bill");
				return;
			}
		    var remarks=$('#remarks').val();
		    if(remarks==''){
		    	alert("Enter Remarks");
		    	return;
		    }
		    var amount=$('#amount').val();
			$.post('/SocietyNew/PaymentsBills',{
				req : 'jsaveasst',
				jvoucherDate:jvoucherDate,
				bills:bills,
				remarks:remarks,
				amount:amount,
			    option:'JASSTSAVE'
			},function(data){
				try {
					var popData = eval("("+data+")");
					if(popData.success == "y"){
						$('#jvoucherno').val(popData.JNewVoucherNo)
						alert("Saved Successfully")
						$('#bills').prop('disabled',true);
						$('#btnSave').prop('disabled',true);		
						}		
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Saving Records of Bills ' +e.message)
				}
			});
		}
	})
	$('#jvoucombo').change(function(){
		var jvouchernum=this.value;
		$('#jvoucherDate').val('');
		$('#bills').val('');
		$('#remarks').val('');
		$('#Info').val('');
		
		$.post('/SocietyNew/PaymentsBills',{
			req : 'jvouchersdata',
		    option:'JOURNALSDATA',
		    jvouchernum:jvouchernum,
		},function(data){
			try {
				var popData = eval("("+data+")");
					var JVoucherNo=popData.JOURNALVOUCHERDATA[0].JVoucherNo;
					var VoucherDate=popData.JOURNALVOUCHERDATA[0].VoucherDate;
					var SourceRef=popData.JOURNALVOUCHERDATA[0].SourceRef;
					var amount=popData.JOURNALVOUCHERDATA[0].amount;
					var DestinationRef=popData.JOURNALVOUCHERDATA[0].DestinationRef;
					var Remarks=popData.JOURNALVOUCHERDATA[0].Remarks;
		
					$('#jvoucherDate').val(VoucherDate).prop('disabled',true);
					billsdata(DestinationRef);
					billinfo(DestinationRef)
				$('#remarks').val(Remarks)
			} catch (e) {
				// TODO: handle exception
				alert('Exception in Saving  Voucher Records ' +e.message)
			}
		});
	});
		$("#btnApprove").click(function() {
			var jvoucombo = $("#jvoucombo").val();
			if(jvoucombo==''){
				alert("Select JournalVoucher Number")
				return false;
			}
			var remarks = $("#remarks").val();
			if(remarks.trim() == ''){
				alert('Enter Remarks');
				return false;
			}
			$.post('/SocietyNew/PaymentsBills',{
				req : 'journalsaveoffc',
				remarks:remarks,
				jvoucombo:jvoucombo,
			    option:'OFFIJOURAPP'
			},function(data){
				try {
					var popData = eval("("+data+")");
					if(popData.success == "y"){
						alert("Successfully Approved")
						$('#btnApprove').prop('disabled',true);		
						}				
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Saving  Voucher Records ' +e.message)
				}	
			});
        	})
		
});

function asstjvoucher() {
	$.post( '/SocietyNew/genericsDetails',{
			req : 'gettingjournaldata',
			option:'ASSTJBILLS'
		},
		function(data){
		
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.JOURNALSLIST;
				if(arr==''){
					alert("No Bills List")
					return;
				}
				var sel = document.getElementById("bills");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
					option.text=temp;
					option.value=temp;
					sel.add(option);
				}
				$("#bills").trigger("chosen:updated");
				$("#bills").prop("disabled" ,false);
			} catch (e) {
				// TODO: handle exception
				alert('Exception in Getting journal bills List ' +e.message)
			}
		}
  );
}

function getjvouchers(){
	
	//clearpayvouchersList();

	$.post('/SocietyNew/genericsDetails',{
			req:'jvouchersList',
			option:'JOURNALSLIST',
	},function (data) {
	
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.JOURNALSENTRYSLIST;
			if(arr==''){
				alert("No Journal Entries List")
				return;
			}
			var sel = document.getElementById("jvoucombo");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				option.value=temp;
				sel.add(option);
			}
			$("#jvoucombo").trigger("chosen:updated");
			$("#jvoucombo").prop("disabled" ,false);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in Getting JournalVouchers List ' +e.message)
		}
	});
	
}



function billsdata(billno) {
	$.post( '/SocietyNew/genericsDetails',{
			req : 'gettingjournaldata',
			option:'JOURNALBILLS'
		},
		function(data){
		
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.JOURNALSLIST;
				if(arr==''){
					alert("No Bills List")
					return;
				}
				var sel = document.getElementById("bills");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
				
					option.text=temp;
					if(billno.trim()==temp){
		 				option.value=temp;
		 				sel.add(option);
		 				$("#bills").val(temp);
		 				$("#bills").trigger("chosen:updated").prop("disabled" ,true);
					}
					option.value=temp;
					sel.add(option);
				}
				$("#bills").trigger("chosen:updated");
				$("#bills").prop("disabled" ,true);
			} catch (e) {
				alert('Exception in Loading bills List ' +e.message)
			}
		}
  );
}



function billinfo(billnum){
	
	$.post('/SocietyNew/PaymentsBills',{
		req : 'billdata',
	    option:'BILLINFO',
	    bill:billnum,
	},function(data){
		
		try {
			var popData = eval("("+data+")");
				var MemEmpCode=popData.billsDATA[0].MemEmpCode;
				var Name=popData.billsDATA[0].Name;
				var BillingDate=popData.billsDATA[0].BillingDate;
				var Amount=popData.billsDATA[0].Amount;
				var depositNo=popData.billsDATA[0].depositNo;
				var loanNo=popData.billsDATA[0].LoanNo;
				var Remarks=popData.billsDATA[0].Remarks;
				
$('#Info').val("EmpCode   :"+MemEmpCode+"\nName         :"+Name+"\nBill Date     :"+BillingDate+"\nAmount      :"+Amount+"\nDeposit No :"+depositNo+"\nLoan No     :"+loanNo);
			
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getting Bill Info ' +e.message)
		}
		
	});
}