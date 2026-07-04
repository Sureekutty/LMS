checkEmp = function() {
	
	var depositnum = $('#depositnum').val();
	var memAccno = $('#memAccno').val();

	if (depositnum == 'null' || depositnum == "") {
		depositnum = "";
		return;
	}

	$.post('/SocietyNew/deposits', {
		req : 'getDepositInfo',
		depositnum : depositnum,
		memAccno : memAccno,
	}, function(data) {
		try {
			$('#mtDate').show();
			$('#mtAmount').show();
			var pop_data = eval("(" + data + ")");			
			//alert(pop_data.DepositDetails[0].MaturityDate+"-"+pop_data.DepositDetails[0].MaturityAmount)
			$('#Amount').val(pop_data.DepositDetails[0].Subscription);
			$('#depositDate').val(pop_data.DepositDetails[0].OpenDate);
			$('#duration').val(pop_data.DepositDetails[0].Duration);
			$('#interest').val(pop_data.DepositDetails[0].IntRate)
			$('#remarks').val(pop_data.DepositDetails[0].Remarks)
			$('#depositNumber').text(pop_data.DepositDetails[0].DepositNo);
			$('#maturityDate').val(pop_data.DepositDetails[0].MaturityDate);
			$('#maturityAmnt').val(pop_data.DepositDetails[0].MaturityAmount);
			getMemberCodeListacc(pop_data.DepositDetails[0].MemAccNo);
			getDepositsType(pop_data.DepositDetails[0].DepositType);
			loadNomineeRefNo(pop_data.DepositDetails[0].MemAccNo,pop_data.DepositDetails[0].NomineeId)
		} catch (e) {
			alert('Exception in checkEmp ' + e.message)
		}
	});

}

var currDate = '';
var minDepositDuration = 0;
var maxDepositDuration = 0;
var ruleDescriptionForMin = '';
var ruleDescriptionForMax = '';
var durationForMIS = 0;
var durationDescription = '';
var ruleValue = 0;
var minAmount = 0;
var maxAmount = 0;
var multipleFactorDesc = '';
var multipleFactorValue = 0;
$(document).ready(function() {

					displayScreenDetails(" Deposits");
					$('#mtDate').hide();
					$('#mtAmount').hide();
					onload = function() {
						currDate = $('#currDate').val();
						$(':input:not([type=button],[id =currDate])').val('');
						$("#depositDate,#Amount,#interest,#remarks").prop("disabled", true);
						$("#deposit,#duration").prop('disabled', true).trigger("chosen:updated");
						$('#btnSave').prop("disabled", false)
						clearMemberCodeList();
						getMemberCodeList();
						clearReferenceList();
					}

					clearMemberCodeList = function() {
						var sel = document.getElementById("empCode");
						var options = sel.options;
						for (var i = options.length; i > 0; i--) {
							sel.remove(i);
						}
					}
					clearReferenceList = function() {
						var sel = document.getElementById("nomineeRefNu");
						var options = sel.options;
						for (var i = options.length; i > 0; i--) {
							sel.remove(i);
						}
					}
					cleardepositList = function() {
						var sel = document.getElementById("deposit");
						var options = sel.options;
						for (var i = options.length; i > 0; i--) {
							sel.remove(i);
						}
					}
					getMemberCodeList = function(type) {
						clearMemberCodeList();
						cleardepositList();
						clearReferenceList();
						$.post('/SocietyNew/genericsDetails', {
							type : 'SOCIETYMEM',
							req : 'employeeList',
							regstatus : 'R',
						}, function(data) {
							try {
								var pop_data = eval("(" + data + ")");
								var arr = new Array();
								arr = pop_data.EMPLOYEELIST;
								var sel = document.getElementById("empCode");
								for (var i = 0; i < arr.length; i++) {
									var option = document.createElement("option");
									var temp = arr[i];
									option.text = temp;
									var valueOfAccNo = temp.split('-')[0];
									option.value = valueOfAccNo;
									sel.add(option);
								}
								$("#empCode").trigger("chosen:updated");
								$("#empCode").prop("disabled", false);
							} catch (e) {
								// TODO: handle exception
								alert('Exception in getEmployeeCodeList ' + e.message)
							}
						});
					}

					getDepositsTypes = function() {

						$.post('/SocietyNew/deposits',{
							req : 'getDepositsTypes',
						},function(data) {
										try {
											var pop_data = eval("(" + data+ ")");
											var arr = new Array();
											var error = pop_data.ERROR;
											if (error == 'NO') {
												arr = pop_data.DEPOSITS;
												var sel = document.getElementById("deposit");
												for (var i = 0; i < arr.length; i++) {
													var option = document.createElement("option");
													if (arr[i].DepositTypeCode != 'THR') {
														var temp = arr[i].DepositTypeDescription;
														option.text = temp;
														option.value = arr[i].DepositTypeCode;
														sel.add(option);
													}
												}
												$("#deposit").trigger("chosen:updated");
												$("#deposit").prop("disabled", false);
											} else {
												alert("getDepositsTypes " + error);
											}
	
										} catch (e) {
											// TODO: handle exception
											alert('Exception in getEmployeeCodeList '+ e.message)
										}
									});
						}
					onload();
					checkInDeposits = function(deposit) {
						var empCode = $('#empCode').val();

						$.post('/SocietyNew/deposits',{
								req : 'checkInDeposits',
								deposit : deposit,
								empCode : empCode,
							},
							function(data) {
								try {
									var eval_Data = eval("(" + data+ ")");
									var depositDetails = new Array();
									depositDetails = eval_Data.DEPOSIT;
									if (depositDetails.length > 0) {
									if (deposit == 'SRB') {
									alert('Only One serb account is for one member ');
									return;
									}
									alert('Already ' + deposit+ ' is active \n go to process screen for further operations');
									return;
									}
									getRulesOfDeposits(deposit);
								} catch (e) {
												// TODO: handle exception
											}
								});
					}

					getRulesOfDeposits = function(deposit) {
						$.post('/SocietyNew/deposits',{
							req : 'getRulesOfDeposits',
							deposit : deposit,
						},function(data) {
							try {
								var popData = eval("(" + data + ")");

								if (deposit == 'FXD') {
									var myArr = new Array();
									myarr = popData.MYARR;
									// max amount description
									// and values from data base
									ruleDescriptionForMin = popData.MIN[0].RuleDescription;
									minDepositDuration = parseInt(
											popData.MIN[0].RuleValue,
											10);
									// max amount description
									// and values from data base
									ruleDescriptionForMax = popData.MAX[0].RuleDescription;
									maxDepositDuration = parseInt(
											popData.MAX[0].RuleValue,
											10);
								}
								if (deposit == 'MIS') {
									var myArr = new Array();
									myarr = popData.MYARR;
									// min duration description
									// and values from data base
									durationDescription = popData.MINDURATION[0].RuleDescription;
									ruleValue = parseInt(
											popData.MINDURATION[0].RuleValue,
											10);
									// min amount description
									// and values from data base
									minAmount = popData.MINAMT[0].RuleValue;
									minDepositDuration = popData.MINAMT[0].RuleDescription;
									// Multiple factor
									// description and values
									// from data base
									multipleFactorDesc = popData.MULTIPLE[0].RuleDescription;
									multipleFactorValue = popData.MULTIPLE[0].RuleValue;
								}
								if (deposit == 'RCD') {
									var myArr = new Array();
									myarr = popData.MYARR;
									// max amount description
									// and values from data base
									ruleDescriptionForMin = popData.MIN[0].RuleDescription;
									minDepositDuration = parseInt(
											popData.MIN[0].RuleValue,
											10);
									// max amount description
									// and values from data base
									ruleDescriptionForMax = popData.MAX[0].RuleDescription;
									maxDepositDuration = parseInt(
											popData.MAX[0].RuleValue,
											10);
								}

								$('#Amount').prop('disabled', false);
							} catch (e) {
								// TODO: handle exception
								alert('Exception in getRulesOfDeposits '
										+ e.message)
							}
						});
					}

					loadNomineeRefNumbers = function(memCode) {
						$.post('/SocietyNew/deposits', {
							req : 'loadNominees',
							memCode : memCode,
							option : 'GETNOMINEES',
						}, function(data) {
							try {
								var pop_data = eval("(" + data + ")");
								var arr = new Array();
								var error = pop_data.ERROR;
								if (error == 'NO') {
									arr = pop_data.DETAILS;
									var sel = document.getElementById("nomineeRefNu");
									for (var i = 0; i < arr.length; i++) {
										var option = document.createElement("option");
										var temp = arr[i].NomDetails;
										/* option.text=temp; */
										var sel = $("#nomineeRefNu").val(temp);
										sel.append($("<option>").attr('value',temp).text(temp));
										/*
										 * option.value=arr[i].RefNo;
										 * sel.add(option);
										 */
									}
									$("#nomineeRefNu").trigger("chosen:updated");
								} else {
									alert("loadNominees " + error);
								}
							} catch (e) {
								// TODO: handle exception
							}
						});
						$("#nomineeRefNu").empty();
					}
					/*
					 * $('#empCode').change(function() { var memCode=this.value;
					 * alert("coming") $.post('/SocietyNew/deposits',{ req :
					 * 'loadNominees',memCode:memCode, },function(data){ try {
					 * alert("inside nominee") var popData = eval("("+data+")");
					 * var arr = new Array(); var error = pop_data.ERROR;
					 * alert(error) if(error == 'NO'){ arr = pop_data.DETAILS;
					 * var sel = document.getElementById("nomineeRefNu");
					 * alert(arr.length) for(var i=0;i<arr.length;i++){ var
					 * option=document.createElement("option"); var temp
					 * =arr[i].NomDetails; option.text=temp;
					 * option.value=arr[i].RefNo; sel.add(option); }
					 * $("#nomineeRefNu").trigger("chosen:updated");
					 * $("#nomineeRefNu").prop("disabled" ,false); } else{
					 * alert("zxczxc "+error); } } catch (e) { // TODO: handle
					 * exception } });
					 * 
					 * alert("going") })
					 */

					getInterestRate = function(deposit, duration,date) {
						alert(date)
						$.post('/SocietyNew/deposits', {
							req : 'getInterestRate',
							deposit : deposit,
							duration : duration,
							date : date,
						}, function(data) {

							try {

								var popData = eval("(" + data + ")");
								var interestRate = popData.INTERESTRATE;
								$('#interest').val(interestRate.toFixed(2));

							} catch (e) {
								// TODO: handle exception
								alert('Exception in getInterestRate ' + e.message)
							}
						});
					}

	$("#btnSave").click(function() {
		var option = "";
		var depositNumber = $('#depositNumber').text();
		if (depositNumber == ""|| depositNumber == null) {
			option = 'SAVE';
		} else {
			option = 'UPDATE';
		}
		if (confirm("Do you want save the Record")) {
			if (validateSave()) {
				var memAccNo = $("#empCode").val();

				var deposit = $('#deposit').val();
				var depositDate = $('#depositDate').val();
				var amount = parseInt($('#Amount').val(), 10);
				var duration;
				duration = $('#duration').val();
				var interest = $('#interest').val();
				var maturityDate = $('#maturityDate').val();
				var maturityAmnt = $('#maturityAmnt').val();
				if(maturityAmnt==0){
					//alert(maturityAmnt)
					return;
				}
				var remarks = $('#remarks').val();
				var nomineeRefNu = $('#nomineeRefNu').val();
				if (nomineeRefNu == 'null'|| nomineeRefNu == undefined) {
					alert('Select Nominee ');
					return false;
				}

				if (duration == 'NA')
					duration = 0;

				$.post('/SocietyNew/deposits',{
					req : 'saveDeposit',
					deposit : deposit,
					duration : duration,
					depositDate : depositDate,
					amount : amount,
					interest : interest,
					depositNumber : depositNumber,
					nomineeRefNu : nomineeRefNu,
					remarks : remarks,
					maturityDate:maturityDate,
					maturityAmnt:maturityAmnt,
					memAccNo : memAccNo,
					option : option,
					},function(data) {
						try {
							var popData = eval("("+ data+ ")");
							if (popData.success == "y") {
								$('#succalert').text("Updated Successfully");
								return;
							} else {
									$('#depositNumber').text(popData.DEPOSITNUMBER);
									$(':input:not([id=btnClearAll])').prop('disabled',true);
									$('#deposit').prop('disabled',true).trigger("chosen:updated");
									nomineerefSave(popData.DEPOSITNUMBER);
								}
							} catch (e) {
										// TODO:// handle// exception
										alert('Exception in getInterestRate '+ e.message)
									}

							});
						}
					}
				});

			});

function nomineerefSave(depositnumber) {
	var memAccNo = $("#empCode").val();
	var nomineeRefNu = $('#nomineeRefNu').val();
	$.post('/SocietyNew/deposits', {
		req : 'savenomineeref',
		memAccNo : memAccNo,
		nomineeRefNu : nomineeRefNu,
		option : 'SAVE',
		depositnumber : depositnumber,
	}, function(data) {
		try {
			var pop_data = eval("(" + data + ")");
			if (pop_data.success == "y") {
				$('#succalert').text("Saved Successfully");
			} else {
				alert("Failed To Save The Details")
			}
		} catch (e) {
			// TODO: handle exception
			alert('Exception in Nominee ' + e.message)
		}
	});
}

function getMemberCodeListacc(memAccNo) {
	$.post('/SocietyNew/genericsDetails', {
		type : 'SOCIETYMEM',
		req : 'employeeList',
		regstatus : 'ACTIVE',
	}, function(data) {
		try {
			var pop_data = eval("(" + data + ")");
			var arr = new Array();
			arr = pop_data.EMPLOYEELIST;
			var sel = document.getElementById("empCode");
			for (var i = 0; i < arr.length; i++) {
				var option = document.createElement("option");
				var temp = arr[i];
				option.text = temp;
				var string = temp.split('-')[0];
				if (memAccNo == string) {
					$("#empCode").val(string);
					option.value = string;
					sel.add(option);
					$("#empCode").trigger("chosen:updated").prop("disabled",true);
				}
				option.value = string;
				sel.add(option);
			}
			$("#empCode").trigger("chosen:updated").prop("disabled", true);

		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeList ' + e.message)
		}
	});
}

function numericKey(e) {
	var evt_mozila = window.event || e;
	if (evt_mozila) {
		var charcode = evt_mozila.keyCode || evt_mozila.which;
		if ((charcode > 31) && (charcode < 46) || (charcode > 57)) {
			alert("Enter number!!");
			return false;
		}
		return true;
	}
}

function getDepositsType(depositType) {

	$.post('/SocietyNew/deposits', {
		req : 'getDepositsTypes',
	},
			function(data) {
				try {
					var pop_data = eval("(" + data + ")");
					var arr = new Array();
					var error = pop_data.ERROR;
					if (error == 'NO') {
						arr = pop_data.DEPOSITS;
						var sel = document.getElementById("deposit");
						for (var i = 0; i < arr.length; i++) {
							var option = document.createElement("option");
							if (arr[i].DepositTypeCode != 'THR') {
								var temp = arr[i].DepositTypeDescription;
								option.text = temp;
								if (depositType == arr[i].DepositTypeCode) {
									option.value = arr[i].DepositTypeCode;
									sel.add(option);
									$("#deposit").val(arr[i].DepositTypeCode);
								}
								option.value = arr[i].DepositTypeCode;
								sel.add(option);
							}
						}
						getRulesOfDeposits(depositType);
						$("#deposit").trigger("chosen:updated");
						$("#deposit").prop("disabled", false);
						$("#Amount").trigger("chosen:updated").prop("disabled",false);
						$("#depositDate").trigger("chosen:updated").prop("disabled", false);
						$("#duration").trigger("chosen:updated").prop("disabled", false);
						$("#remarks").trigger("chosen:updated").prop("disabled", false);
					} else {
						alert("getDepositsType " + error);
					}
				} catch (e) {
					// TODO: handle exception
					alert('Exception in getDepositsType ' + e.message)
				}
			});

}
loadNomineeRefNo = function(memCode, nomineeId) {
	$.post('/SocietyNew/deposits', {
		req : 'loadNominees',
		memCode : memCode,
		option : 'GETNOMINEES',
	}, function(data) {
		try {
			var pop_data = eval("(" + data + ")");
			var arr = new Array();
			var error = pop_data.ERROR;
			if (error == 'NO') {
				arr = pop_data.DETAILS;
				var sel = document.getElementById("nomineeRefNu");
				for (var i = 0; i < arr.length; i++) {
					var option = document.createElement("option");
					var temp = arr[i].NomDetails;
					var string = temp.split('-')[1];
					option.text = temp;
					if (nomineeId == string) {
						option.value = string;
						sel.add(option);
						$("#nomineeRefNu").val(string);
						$("#nomineeRefNu").trigger("chosen:updated").prop("disabled", false);
					}
					option.value = string;
					sel.add(option);
				}
				$("#nomineeRefNu").trigger("chosen:updated").prop("disabled",false);

			} else {
				alert("loadNominees " + error);
			}
		} catch (e) {
			// TODO: handle exception
		}
	});
	$("#nomineeRefNu").empty();

}

function maturityDetail(empCode,deposit,duration){
	
	var depositDate = $('#depositDate').val();
//	depositDate=depositDate.split('/')[1]+"/"+depositDate.split('/')[0]+"/"+depositDate.split('/')[2];
	var amount = $('#Amount').val();
	//alert(depositDate+" -- "+amount)
	$.post('/SocietyNew/deposits', {
		req : 'maturityDetail',
		empCode : empCode,
		deposit : deposit,
		duration : duration,
		depositDate : depositDate,
		amount : amount,
		option : 'maturityDetail',
	}, function(data) {
		try {
			var pop_data = eval("(" + data + ")");
			if (pop_data.SUCCESS == 'Y') {
				//alert(pop_data.maturityDate+" ~~ "+pop_data.maturityAmount)
				$('#maturityDate').val(pop_data.maturityDate);
				$('#maturityAmnt').val(pop_data.maturityAmount);

			} else {
				alert("Error while calculating maturity detail "+pop_data.ERROR);
			}
		} catch (e) {
			// TODO: handle exception
			alert("Error while fetching data "+e)
		}
	});
	
}
