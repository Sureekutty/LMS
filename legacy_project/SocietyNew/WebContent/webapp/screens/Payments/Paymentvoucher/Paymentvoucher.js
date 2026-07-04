
$(document).ready(function() {
	
	$("#hiddenrowid1").val('');
	
	displayScreenDetails("Payment Voucher");
	

	
	var role=$('#Role').val();
	if(role==1){
	
		$('#btnApprove').hide();
		$('#payvonumcombo').hide();
		asstpaymentvoucher();
		$('#payvoucherasstGrid').show();
		$('#payvoucheroffcGrid').hide();
	}else{
		
		$('#payvoucherasstGrid').hide();
		$('#payvoucheroffcGrid').show();
		$('#btnApprove').show();
		$('#payvonum').hide();
		$('#btnSave').hide();
		$('#payvonumcombo').show();
	
		getpayvouchers();
		
	}
	
	$('#modeofpay').val('');
	$('#accno').hide();
	$('#chqdate').hide();
	$('#chqno').hide();
	
	$('#modeofpay').change(function(){
		
		var modeofpay=this.value;
		if(modeofpay=='bank'){
			$('#accno').show();
			$('#chqdate').hide();
			$('#chqno').hide();
		}else{
			$('#accno').hide();
			$('#chqdate').show();
			$('#chqno').show();
		}
	});

	clearpayvouchersList = function() {
		var sel = document.getElementById("payvoucombo");
		var options = sel.options;
		for(var i=options.length; i> 0; i--){
			sel.remove(i);
		}
	}

	
	
	$("#btnSave").click(function() {
		
		if(confirm("Do you want save the Record")){
		if(validateSave()){
			
			var payvoucherdate=$('#payvoucherDate').val();
			var modeofpay=$('#modeofpay').val();
		    var accountnum=$('#accountno').val();
		    var Chequeno=$('#Chequeno').val();
		    var chequeDate=$('#chequeDate').val();
		    var remarks=$('#remarks').val();
		    
			$("#hiddenrowid1").val('')
			var obj = document.getElementById("hiddenrowid1");
			obj.value = '';
			
			var check = document.getElementsByName("checkbox");
			
			for (var i = 0; i < check.length; i++) {
				if (document.getElementById(check[i].id).checked) {
					obj.value = obj.value + check[i].id + "&";
				}
				
			}
			
			if(obj.value==""){
				alert("select  Bills")
				return;
			}
			$.post('/SocietyNew/PaymentsBills',{
				req : 'saveasst',
				payvoucherdate:payvoucherdate,
				modeofpay:modeofpay,
				accountnum:accountnum,
				Chequeno : Chequeno,
				chequeDate:chequeDate,
				remarks:remarks,
				griddata:obj.value,
			     option:'ASSTSAVE'
			},function(data){
				
				try {
					var popData = eval("("+data+")");
					if(popData.success == "y"){
						$('#Payvoucherno').val(popData.NewVoucherNo)
						$('#btnSave').prop('disabled',true);		
						}		
					
				} catch (e) {
					// TODO: handle exception
					alert('Exception in Saving Records of Bills ' +e.message)
				}
				
			});
		}
		}
	})
	
	
	
	
	$('#payvoucombo').change(function(){
		$('#payvoucherDate').val('')
		$('#modeofpay').val('');
		$('#accountno').val('');
		$('#Chequeno').val('');
		$('#chequeDate').val('');
		var payvouchernum=this.value;
		$.post('/SocietyNew/PaymentsBills',{
			req : 'payvouchersdata',
		    option:'PAYVOUCHERDATA',
		    payvouchernum:payvouchernum,
		},function(data){
			
			try {
				var popData = eval("("+data+")");
					var voucherdate=popData.VOUCHERDATA[0].VoucherDate;
					var modeofpay=popData.VOUCHERDATA[0].ModeOfPayment;
					var accno=popData.VOUCHERDATA[0].AccountNo;
					var chequeno=popData.VOUCHERDATA[0].ChequeNo;
					var chequedate=popData.VOUCHERDATA[0].ChequeDate;
					var remarks=popData.VOUCHERDATA[0].Remarks;
					$('#payvoucherDate').val(voucherdate).prop('disabled',true);
					$('#modeofpay').val(modeofpay).prop('disabled',true);
					$("#modeofpay").trigger("chosen:updated");
					$("#modeofpay").prop("disabled" ,true);
					if(modeofpay=='bank'){
						$('#accno').show();
						$('#chqno').hide();
						$('#chqdate').hide();
						$('#accountno').val(accno).prop('disabled',true);
					}else{
						$('#accno').hide();
						$('#chqno').show();
						$('#Chequeno').val(chequeno).prop('disabled',true);
						$('#chqdate').show();
						$('#chequeDate').val(chequedate).prop('disabled',true);
					}
				$('#remarks').val(remarks)
					
				if(popData.success=='y'){
					vouchergrid(payvouchernum)
				}
				
			} catch (e) {
				// TODO: handle exception
				alert('Exception in Saving  Voucher Records ' +e.message)
			}
			
		});
		
		
		
		
	});
	
	
	
		$("#btnApprove").click(function() {
	
			var payvoucombo = $("#payvoucombo").val();
			if(payvoucombo==''){
				alert("Select PayVoucher Number")
				return false;
			}
			
			var remarks = $("#remarks").val();
			if(remarks.trim() == ''){
				alert('Enter Remarks');
				return false;
			}
			$.post('/SocietyNew/PaymentsBills',{
				req : 'saveoffc',
				remarks:remarks,
				payvoucombo:payvoucombo,
			    option:'VOUCHERSUPDATE'
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

function asstpaymentvoucher() {
	
	findgrid1.cleanContent();
	$.post( '/SocietyNew/PaymentsBills',{
			req : 'gettingpaymentdata',
			option:'ASSTBILLS'
		},
		function(data){
		
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
	    		arr = pop_data.BILLDATA;
	    		if(arr==''){
	    			alert("NO DATA")
	    		}
	    		findgrid1.setContent(arr);
			} catch (e) {
				alert('INSIDE CATCH BLOCK ' + e.message);
			}
		}
  );
}
function offcpaymentvoucher() {
	
	findgrid2.cleanContent();
	$.post( '/SocietyNew/PaymentsBills',{
			req : 'gettingpaymentdataoffc',
			option:'OFFCBILLS'
		},
		function(data){
		
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
	    		arr = pop_data.PAYVOUCHERDATA;
	    		if(arr==''){
	    			alert("NO DATA")
	    		}
	    		findgrid2.setContent(arr);
			} catch (e) {
				alert('INSIDE CATCH BLOCK ' + e.message);
			}
		}
  );
}
function getpayvouchers(){
	
	//clearpayvouchersList();

	$.post('/SocietyNew/genericsDetails',{
			req:'payvouchersList',
			option:'PAYVOUCHERSLIST',
	},function (data) {
	
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.PAYVOUCHERSLIST;
			if(arr==''){
				alert("No PayVouchers List")
				return;
			}
			var sel = document.getElementById("payvoucombo");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp;
				option.value=temp;
				sel.add(option);
			}
			$("#payvoucombo").trigger("chosen:updated");
			$("#payvoucombo").prop("disabled" ,false);
		} catch (e) {
			// TODO: handle exception
			alert('Exception in Getting PayVouchers List ' +e.message)
		}
	});
	
}

function vouchergrid(payvouchernum) {
	
	findgrid2.cleanContent();
	$.post( '/SocietyNew/PaymentsBills',{
			req : 'gettingvoucherdata',
			option:'BILLS',
			payvouchernum:payvouchernum,
		},
		function(data){
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
	    		arr = pop_data.BILLVOUCHERDATA;
	    		if(arr==''){
	    			alert("NO DATA")
	    		}
	    		findgrid2.setContent(arr);
			} catch (e) {
				alert('INSIDE CATCH BLOCK ' + e.message);
			}
		}
  );
}