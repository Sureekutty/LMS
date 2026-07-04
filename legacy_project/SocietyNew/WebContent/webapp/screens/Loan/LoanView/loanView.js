var option = '';
$(document).ready(function() {
			var picker = new Pikaday({
				field : document.getElementById('recFromDate'),
				format : 'DD/MM/YYYY',
				// maxDate: new Date(),
				onSelect : function() {

					console.log(this.getMoment().format('DD/MM/YYYY'));
				}
			});
			displayScreenDetails(" Loan View");
			
			var Role = $('#Role').val();
			
			onLoad = function() {
				$('#searchMember').val("").prop('disabled', false);
				findgrid.cleanContent();
				$(':button').not('[id = FRESH],[id =REJECT],[id =SANCTION],[id =RELINIT],[id =RELEASE],[id =SETTLED],[id =closeButton],[id=PRINT],[id=approvalRelease], [id=relinit]').prop('disabled', true).hide();
				$('#FRESH,#REJECT,#SANCTION,#RELEASE,#SETTLED,#closeButton').prop('disabled', false);
				typeOfButton = '';
				var Role = $('#Role').val();
				if(Role==2){
					$('#SANCTION').hide();
						$('#PRINT').css("background-color","green");
					$('#approvalRelease').prop('disabled',false);
					
				}
				if(Role==1){
					$('#RELINIT').hide();
					$('#approvalRelease').prop('disabled',false);
					
				}
			}

			onLoad();
			$('#FRESH').click(function() {
				$('#updationDate').val();
				$('#TypeOfLoan').text('FRESH LOAN DETAILS');
				typeOfButton = this.id;
				getLoanDetails(typeOfButton);
				$('.hideTable').hide();

			});
			$('#SANCTION').click(function() {
				clearFields();
				$('#TypeOfLoan').text('SANCTIONED LOAN DETAILS');
				typeOfButton = this.id;
				getLoanDetails(typeOfButton);
				$('.hideTable').show();
				

			});
			$('#RELINIT').click(function() {
				clearFields();
				$('#TypeOfLoan').text('RELEASE INITIATED LOAN DETAILS');
				typeOfButton = this.id;
				getLoanDetails(typeOfButton);
				$('.hideTable').show();
				

			});
			$('#REJECT').click(function() {
				$('#TypeOfLoan').text('REJECTED LOAN DETAILS');
				typeOfButton = this.id;
				getLoanDetails(typeOfButton);
				$('.hideTable').hide();
			});

			$('#RELEASE').click(function() {
				$('#TypeOfLoan').text('RELEASED LOAN DETAILS');
				typeOfButton = this.id;
				getLoanDetails(typeOfButton);
				$('.hideTable').hide();
			});
			$('#SETTLED').click(function() {
				$('#TypeOfLoan').text('SETTLED LOAN DETAILS');
				typeOfButton = this.id;
				getLoanDetails(typeOfButton);
				$('.hideTable').hide();
			});

			getLoanDetails = function(type) {

				option = '';
				findgrid.cleanContent();
				$('#dialog1').dialog('open');
				$.post('/SocietyNew/LoanView', {
					req : 'searchViewAll',
					type : type,
				}, function(data) {
					$('#dialog1').dialog('close');
					try {
						var pop_data = eval("(" + data + ")");
						var arr = new Array();
						arr = pop_data.LoanDetails;
						
						findgrid.setContent(arr);
						
					} catch (e) {
						// TODO: handle exception
						alert('Exception in searchAll ' + e.message)
					}
					
				});
			}

			$('#btnReject').click(function() {
				option = 'REJECT';
				var Remarks = $('#Remarks').val();
				if (Remarks == '' || Remarks == undefined) {
					alert('Enter Remarks')
					return;
				}
				updateLoanreject(option);
			});

			$('#btnSanction').click(function() {

				option = 'SANCTION';
				var Remarks = $('#Remarks').val();
				if (Remarks == '' || Remarks == undefined) {
					alert('Enter Remarks')
					return;
				}
				updateLoan(option);
			});
			dateDif = function(date1, date2) {

				var date1 = date1.split("/")[1] + "/"
				+ date1.split("/")[0] + "/"
				+ date1.split("/")[2];
				var date2 = date2.split("/")[1] + "/"
				+ date2.split("/")[0] + "/"
				+ date2.split("/")[2];

				date1 = new Date(date1);
				date2 = new Date(date2);
				var timeDiff = (date1.getTime() - date2.getTime());
				var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
				return diffDays;

			}
			$('#updationDate').change(function() {
						var date1 = $("#updationDate").val();
						var date2 = $("#LoanAppDate").text();
						var dif = dateDif(date1, date2);
						if (dif < 0) {
							alert("Sanctione date should be greater than applied date or same date")
							$("#updationDate").val("");
						}
					});

			$('#btnPrint').click(function() {
				var accNo = $('#memAccNo1').val();
				var LoanAppNo = $('#employeeDetails').text();
				LoanAppNo = LoanAppNo.split("-")[2];
				var req = "MemGenpdfformLoanDetails";
				var frm = document.createElement("form");
				frm.method = "POST";
				frm.name = "GenPDF_FORM";
				frm.action = "/SocietyNew/LoanApplication";
				document.body.appendChild(frm);

				var in1 = document.createElement("input");
				in1.type = 'hidden';
				in1.name = 'LoanAppNo';
				in1.value = LoanAppNo;

				var in2 = document.createElement("input");
				in2.type = 'hidden';
				in2.name = 'accNo';
				in2.value = accNo;

				var in3 = document.createElement("input");
				in3.type = 'hidden';
				in3.name = 'req';
				in3.value = req;
				frm.appendChild(in1);
				frm.appendChild(in2);
				frm.appendChild(in3);

				frm.submit();
			});
			
			$('#PRINT').click(function() {
				var selected = findgrid.getSelectedRecords();
				var JsonData = JSON.stringify(selected);
				
				var chequeNumber = $('#chequeNumber').val();
				var totalAmount = $('#totalAmount').val();
				var date = $('#idate').val();
				 if (chequeNumber == ""|| chequeNumber == undefined ) {
						alert("Enter Remarks or cheque number")
						return;
					}				 
				 if(totalAmount == "" || totalAmount == undefined){
					 alert("select members for total amount")
					 return;
				 }
				 if(date == "" || date == undefined){
					 alert("select date")
					 return;
				 }
				var req = "MemGenpdfformSanctionRelease";
				var frm = document.createElement("form");
				frm.method = "POST";
				frm.name = "GenPDF_FORM";
				frm.action = "/SocietyNew/LoanApplication";
				frm.target = "_blank";
				document.body.appendChild(frm);

				var in1 = document.createElement("input");
				in1.type = 'hidden';
				in1.name = 'req';
				in1.value = req;
				
				var in2 = document.createElement("input");
				in2.type = 'hidden';
				in2.name = 'totalAmount';
				in2.value = totalAmount;

				var in3 = document.createElement("input");
				in3.type = 'hidden';
				in3.name = 'JsonData';
				in3.value = JsonData;
				
				var in4 = document.createElement("input");
				in4.type = 'hidden';
				in4.name = 'chequeNumber';
				in4.value = chequeNumber;
				
				var in5 = document.createElement("input");
				in5.type = 'hidden';
				in5.name = 'idate';
				in5.value = date;
				
				
				frm.appendChild(in1);
				frm.appendChild(in2);
				frm.appendChild(in3);
				frm.appendChild(in4);
				frm.appendChild(in5);
				frm.submit();
				//clearFields();
				
			});
							

			$('#btnedit').click(function() {
						if (confirm("Do you want to edit the record..??")) {
							var Loanappno = $('#employeeDetails').text();
							LoanAppNo = LoanAppNo.split("-")[2];
//							alert('Loanappno-->' + Loanappno);
							var thriftavailbleamount = $('#LoanAppNo').text();
//							alert('thriftavailbleamount-->'+ thriftavailbleamount);
							var thriftavailbleamount = $('#ThriftBalance').text();
							var thriftdudamt = $('#ThriftDedAmt').text();
							var empcode = $('#emplcode').val();
							var loantypee = $('#loantype').val();
							var memAccNo = $('#memAccNo1').val();
							var loanamount = $('#LoanSanctionAmt').text();
							var surity1 = $('#surity1').val();
							var surity2 = $('#surity2').val();
							var surity3 = $('#surity3').val();
							var funidnum = $('#funidnum').val();

							var frm = document.createElement("form");
							frm.method = "POST";
							frm.name = "Loan";
							frm.action = "../LoanApplication/loan.jsp";
							document.body.appendChild(frm);

							var in1 = document.createElement("input");
							in1.type = 'hidden';
							in1.name = 'Loanappno';
							in1.value = Loanappno;

							var in2 = document.createElement("input");
							in2.type = 'hidden';
							in2.name = 'thriftavailbleamount';
							in2.value = thriftavailbleamount;

							var in3 = document.createElement("input");
							in3.type = 'hidden';
							in3.name = 'thriftdudamt';
							in3.value = thriftdudamt;

							var in4 = document.createElement("input");
							in4.type = 'hidden';
							in4.name = 'empcode';
							in4.value = empcode;
							var in5 = document.createElement("input");
							in5.type = 'hidden';
							in5.name = 'loantypee';
							in5.value = loantypee;

							var in6 = document.createElement("input");
							in6.type = 'hidden';
							in6.name = 'memAccNo';
							in6.value = memAccNo;

							var in7 = document.createElement("input");
							in7.type = 'hidden';
							in7.name = 'loanamount';
							in7.value = loanamount;

							var in8 = document.createElement("input");
							in8.type = 'hidden';
							in8.name = 'surity1';
							in8.value = surity1;
							var in9 = document.createElement("input");
							in9.type = 'hidden';
							in9.name = 'surity2';
							in9.value = surity2;

							var in10 = document.createElement("input");
							in10.type = 'hidden';
							in10.name = 'surity3';
							in10.value = surity3;

							var in11 = document.createElement("input");
							in11.type = 'hidden';
							in11.name = 'funidnum';
							in11.value = funidnum;
							
							frm.appendChild(in1);
							frm.appendChild(in2);
							frm.appendChild(in3);
							frm.appendChild(in4);
							frm.appendChild(in5);
							frm.appendChild(in6);
							frm.appendChild(in7);
							frm.appendChild(in8);
							frm.appendChild(in9);
							frm.appendChild(in10);
							frm.appendChild(in11);
							frm.submit();
						}
					});

			$('#btnRelInitiate').click(function() {
				//alert("inside relinit button")
						if (confirm("Do you want to Release Initiate the record..??")) {
							var LoanAppNo = $('#employeeDetails').text();
							LoanAppNo = LoanAppNo.split("-")[2];
							 //alert('LoanAppNo-->'+LoanAppNo)
							var recFromDate = $('#recFromDate').val();
							var emplcode = $('#emplcode').val();
							var Remarks = $('#Remarks').val();

							if (Remarks == ""|| Remarks == undefined) {
								alert("Enter Remarks")
								return;
							}

							if (recFromDate == ""|| recFromDate == null|| recFromDate == undefined) {
								alert("Select Date ")
								return;
							}

							$.post('/SocietyNew/LoanApplication',{
										req : 'relinitiate',
										recFromDate : recFromDate,
										Remarks : Remarks,
										LoanAppNo : LoanAppNo,
										emplcode : emplcode,
										recFromDate : recFromDate,

									},function(data) {

										try {
											var pop_data = eval("("+ data+ ")");
											if (pop_data.success == 'Y') {
												alert('Loan has been Initiated  ');
												$('#btnRelInitiate').prop('disabled',true);
											}

										} catch (e) {
											// TODO:
											// handle
											// exception
											alert('Exception in UPDATE '+ e.message)
										}
									});

						}
					});

			$('#btnApproveRel').click(function() {
						if (confirm("Do you want to Release the record..??")) {
							var LoanAppNo = $('#employeeDetails').text();
							LoanAppNo = LoanAppNo.split("-")[2];
							var emplcode = $('#emplcode').val();
							var recFromDate = $('#recFromDate').val();
							alert(recFromDate)
							if (recFromDate == ""|| recFromDate == undefined) {
								alert("Enter date ")
								return;
							}
							var Remarks = $('#Remarks').val();
							//var selected=findgrid.getSelectedRecords();	
							
							var bankaccno = $('#bankAccNo').val();
							if (Remarks == ""|| Remarks == undefined) {
								alert("Enter Remarks ")
								return;
							}

							$.post('/SocietyNew/LoanApplication',{
										req : 'released',
										Remarks : Remarks,
										LoanAppNo : LoanAppNo,
										emplcode : emplcode,
										bankaccno : bankaccno,
										recFromDate : recFromDate,
										

									},function(data){
										try {
											var pop_data = eval("("+ data+ ")");
											if (pop_data.success == 'Y') {
												alert('Loan has been Released');
												$('#btnApproveRel').prop('disabled',true);
											}

										} catch (e) {
											// TODO: handle exception
											alert('Exception in UPDATE '+ e.message)
										}
									});

						}
					});

			updateLoan = function(option) {
				var LoanAppNo = $('#employeeDetails').text();
				LoanAppNo = LoanAppNo.split("-")[2];
				/*
				 * var updationDate = $('#updationDate').val();
				 * if(updationDate==""||updationDate==null||updationDate==undefined){
				 * alert("Select Date ") return; }
				 */
				var Remarks = $('#Remarks').val();
				var emplcode = $('#emplcode').val();

				if (confirm("Are you sure click 'OK' to continue")) {
					$.post('/SocietyNew/LoanApplication', {
						req : 'update',
						option : option,
						LoanAppNo : LoanAppNo,
						emplcode : emplcode,
						Remarks : Remarks,
					}, function(data) {

						try {
							var pop_data = eval("(" + data + ")");
							if (pop_data.success == 'Y') {
								alert('Loan has been sanctioned  ');
								$('#btnReject,#btnSanction').prop('disabled', true);
							}

						} catch (e) {
							// TODO: handle exception
							alert('Exception in UPDATE ' + e.message)
						}
					});
				}

			}
			updateLoanreject = function(option) {

				var LoanAppNo = $('#employeeDetails').text();
				var memAccNo = LoanAppNo.split("-")[0];
				LoanAppNo = LoanAppNo.split("-")[2];
				var emplcode = $('#emplcode').val();
				var Remarks = $('#Remarks').val();
				var memAccNo = LoanAppNo.split("-")[2];
				/*
				 * var updationDate = $('#updationDate').val();
				 * if(updationDate==""||updationDate==null||updationDate==undefined){
				 * alert("Select Date ") return; }
				 */
				if (confirm("Are you sure click 'OK' to continue")) {
					$.post('/SocietyNew/LoanApplication', {
						req : 'reject',
						option : option,
						memAccNo : memAccNo,
						LoanAppNo : LoanAppNo,
						emplcode : emplcode,
						Remarks : Remarks,
					}, function(data) {
						alert(data);
						try {
							var pop_data = eval("(" + data + ")");
							if (pop_data.REJECT == 'Y') {
								alert('Loan has been rejected  ');
								$('#btnReject,#btnSanction').prop('disabled', true);
							}

						} catch (e) {
							// TODO: handle exception
							alert('Exception in UPDATE ' + e.message)
						}
					});
				}

			}

			// --LOAN-> FRESH LOAN DETAILS DIALOGUE PROMPT "EMPLOYEE"
			// LINK CLICK CODE (SHIVA)--//
			$("#employeeDetails").click(function() {

				var accNo = $('#memAccNo1').val();
				var req = "MemGenpdfformDetails";
				var frm = document.createElement("form");
				frm.method = "POST";
				frm.name = "GenPDF_FORM";
				frm.action = "/SocietyNew/MembersView";
				document.body.appendChild(frm);

				var in2 = document.createElement("input");
				in2.type = 'hidden';
				in2.name = 'accNo';
				in2.value = accNo;

				var in3 = document.createElement("input");
				in3.type = 'hidden';
				in3.name = 'req';
				in3.value = req;

				frm.appendChild(in2);
				frm.appendChild(in3);

				frm.submit();

			});			
			
			 $('#approvalRelease').click(function() {
				 var role = $('#Role').val(); 
//				 alert("role "+role)
				if(role==1 && typeOfButton == 'SANCTION'){
					var selected=findgrid.getSelectedRecords();					
					getReleaseInitiate(selected);					
				}
				if(role==2 && typeOfButton == 'RELINIT'){
					//var all=findgrid.dataset.data;
					//alert("all value is "+all)
					var selected=findgrid.getSelectedRecords();	
					getApprovalrelease(selected);					
				}				
			 });

//			AJAX call to give release initiate to the loan			
			getReleaseInitiate = function(data) {
				var JsonData = JSON.stringify(data);				
				 var chequeNumber = $('#chequeNumber').val();					
				 if (chequeNumber == ""|| chequeNumber == undefined ) {
						alert("Enter Remarks or cheque number")
						return;
					}				 				
				 var date = $('#idate').val();
//				 alert("date is  "+date);				 
				 if(date == "" || date == undefined){
					 alert("select date")
					 return;
				 }
				if (confirm("Do you want to Release Initiate all the record..??")) {
					$.post('/SocietyNew/LoanApplication',{
								'req' : 'bulkRelinitiate',
								'date' : date,
								'chequeNumber' : chequeNumber,
								'JsonData' : JsonData								
							},function(data) {								
								try {									
									var pop_data = eval("("+ data+ ")");
									if (pop_data.success == 'Y') {										
										alert('Loan has been Initiated  ');
										clearFields();
									}
								} catch (e) {
									// TODO: handle exception
									alert('Exception in UPDATE '+ e.message)
								}
							});
				}
			}
//			AJAX call to give approval release the loan
			getApprovalrelease = function(data) {
//				 var grid=Sigma.$grid("grid");
//				 var data = findgrid.dataset.data;	
				 
				 var gridData = JSON.stringify(data);				 
				 var chequeNumber = $('#chequeNumber').val();				
				 if (chequeNumber == ""|| chequeNumber == undefined ) {
						alert("Enter Remarks or Cheque number")
						return;
					}
				 var date = $('#idate').val();
//				 alert("date is  "+date);
				 $('#Releaseddate').val(date);
				 if(date == "" || date == undefined){
					 alert("select date")
					 return;
				 }
				if (confirm("Do you want to Release all the record..??")) {					
					$.post('/SocietyNew/LoanApplication',{
								'req' : 'bulkApprovalReleased',
								'chequeNumber' : chequeNumber,
								'date' : date,
								'gridData':gridData
							},function(data) {								
								try {									
									var pop_data = eval("("+ data+ ")");
									if (pop_data.success == 'Y') {										
										alert('Loan has been  appproved');
										clearFields();
									}
								} catch (e) {
									// TODO: handle exception
									alert('Exception in UPDATE '+ e.message)
								}
							});
					}
			}
			clearFields = function() {
				$('#chequeNumber,#idate,#totalAmount').val('');
			}
		});
//			function to get all chequed amount by clicking master checkbox	
	function getChequedAmount() {	
	var selected = findgrid.getSelectedRecords();	
	var sum = 0;
	for (var j = 0; j < selected.length; j++) {		
		sum = sum + selected[j].chequeAmount;
	}	
	$('#totalAmount').val(sum);
}
//get load icon
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
		
		
		
//	==========================ajax call to request page for fetch json data==================================================
//	var url='/SocietyNew/LoanApplication';
//					alert('after url');
//					$.ajax({
//						type:'POST',
//						url:url,
//						data:{
//							'req':'bulkApprovalReleased',
//							'LoanAppNo' : LoanAppNo,
//							'Remarks' : Remarks,
//							'emplcode' : emplcode,
//							'dataJSON':dataJSON,
//						},function(data) {
//							try {
//							alert("inside ajax call");
//							var pop_data = eval("("+ data+ ")");
//							if (pop_data.SANCTION == 'Y') {
//								alert('Loan has been Released');
//							}
//
//						} catch (e) {
//							// TODO: handle exception
//							alert('Exception in UPDATE '+ e.message)
//						}
//					}
//					});	