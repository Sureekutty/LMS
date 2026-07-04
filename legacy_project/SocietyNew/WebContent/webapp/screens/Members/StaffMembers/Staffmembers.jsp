<%@page import="org.society.dao.GenericsDetailsDAO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"
	autoFlush="true" session="true"%>

<%
	if(session.getAttribute("EMPLOYEECODE") == null) {
		response.sendRedirect("/SocietyNew/Login.jsp");

	}
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta content="0" http-equiv="expires">
<meta content="NO-CACHE" http-equiv="PRAGMA">
<meta content="NO-CACHE" http-equiv="CACHE-CONTROL">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript"
	src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>

<script type="text/javascript"
	src="../../../commonFiles/js/bootstrap.min.js"></script>
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"
	type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet"
	type="text/css" />

<script type="text/javascript"
	src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet"
	type="text/css" />


<!-- chosen  plugin for select -->

<link href="../../../commonFiles/css/chosen.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript"
	src="../../../commonFiles/js/chosen.jquery.js"></script>

<!-- <!-- select plugin for select -->
<!-- <script type="text/javascript" src="../../../commonFiles/js/select2.min.js"></script>
<link href="../../../commonFiles/css/select2.min.css" rel="stylesheet" type="text/css"/> 
 -->
<script type="text/javascript" src="../../screenFucntions.js"></script>
<script type="text/javascript" src="../StaffMembers/smembers.js"></script>
<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>

<script type="text/javascript" src="../Membership/setValues.js"></script>
<script type="text/javascript" src="../StaffMembers/validate.js"></script>
<script type="text/javascript" src="../StaffMembers/Addressgrid.js"></script>
<script type="text/javascript" src="../StaffMembers/Bankdetailgrid.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body onload='checkEmp()'>
	<input type="hidden" id='memAccnountNumber'
		value=<%=request.getParameter("memAccnountNumber")%>>
	<input type="hidden" id='remarks'
		value=<%=request.getParameter("remarks")%>>
	<input type="hidden" id='typeOfSearch'
		value=<%=request.getParameter("typeOfSearch")%>>
	<input type="hidden" id="appnum" />
	<input type="hidden" id="currDate" name="currDate"
		value=<%=new SimpleDateFormat("dd/MM/yyyy").format(new Date()) %>>

	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<%String empcode=(String)session.getAttribute("EMPLOYEECODE"); %>



	<div class="main">

		<div>

			<br style="line-height: 7px;">
			<div id="tabs" align="center">
				<input type="hidden" id='empCode' value=<%=empcode %>>

				<table id="nameFont" width="1000px" class=MsoTableGrid cellspacing=2
					cellpadding=2
					style='border-collapse: collapse; border: none; margin-left: auto; margin-right: auto;'>
					<thead align="center">

						<tr>
							<td align="left" colspan="20"
								style="border-bottom: 2px solid grey"><b>Application
									Number &nbsp;&nbsp;&nbsp;: <label id='applNumber'></label>
							</b></td>
						</tr>
					</thead>


					<tr>
						<td align="left" colspan="20"
							style="border-bottom: 2px solid grey"><b>Member Details</b></td>
					</tr>
					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td width="170px" align="right"><span>Member
								Name:&nbsp;</span></td>
						<td><input type="text" id="memberName" name="memberName"
							class="form-control" style="width: 300px;" maxlength="70"></td>

						<td align="right" width="450px">Basic Pay:&nbsp;</td>
						<td><input type="text" id="basicpay" name="basicpay"
							class="form-control" style="width: 300px;"
							onkeypress='return numericKey(event)' maxlength="70"></label></td>

					</tr>



					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td align="right">Date Of Birth:&nbsp;</td>
						<td><input type="text" id='Dateofbirth' class="form-control"
							style="width: 300px;" readonly="readonly"></td>

						<td align="right">&nbsp;</td>
						<td></td>
					</tr>
					<tr>
						<td height="5px" />
					</tr>

					<tr>
						<td align="left" colspan="20"
							style="border-bottom: 2px solid grey"><b>Personal
								Details </b></td>
					</tr>
					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td align="right">Mail Id <label style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="mailId" name="mailId"
							class="form-control" style="width: 300px;"50" ></td>

						<td align="right" style="width: 500px;">Pan No <label
							style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="panNumber" name="panNumber"
							class="form-control"
							style="width: 300px; text-transform: uppercase;" maxlength="10"></td>
					</tr>
					<tr>
						<td height="5px" />
					</tr>
					<tr>

						<td align="right">Aadhar No<label style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="aadharNumber" name="aadharNumber"
							class="form-control" style="width: 300px;" maxlength="12"
							onkeypress='return numericKey(event)'></td>

						<td align="right">Phone/ Cell <label style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="phoneNumber" name="phoneNumber"
							class="form-control" style="width: 300px;" maxlength="12"
							onkeypress='return numericKey(event)'
							onchange="checkForlengthCell()"></td>
					</tr>
					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td align="right">Office Ph No<label style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="officeno" name="officeno"
							class="form-control" style="width: 300px;" maxlength="12"
							onkeypress='return numericKey(event)'
							onchange="checkForlengthOffice()"></td>
						<td align="right">Parents/Husband Name <label
							style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="careOf" name="careOf"
							class="form-control"
							style="width: 300px; text-transform: uppercase;" maxlength="25"></td>
					</tr>

					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td colspan="20" align="left"
							style="border-bottom: 2px solid grey"><b>Society Details</b></td>
					</tr>
					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td align="right">Shares Req <label style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="sharesallot" name="sharesallot"
							class="form-control"
							style="width: 300px; text-transform: uppercase;" maxlength="4"
							onkeypress='return numericKey(event)'></td>

						<td align="right">Thrift Subscription Amt <label
							style="color: red;">*</label></td>
						<td><input type="text" id="thriftSubAmt" name="thriftSubAmt"
							class="form-control" style="width: 300px;" maxlength="5"
							onkeypress='return numericKey(event)'></td>

					</tr>

					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td align="right">Share Amount <label style="color: red;">*</label>&nbsp;
						</td>

						<td><input type="text" id="shareamt" name="shareamt"
							class="form-control" style="width: 300px;" maxlength="7"
							onkeypress='return numericKey(event)'></td>


						<td align="right">Thrift Deposit <label style="color: red;">*</label>&nbsp;
						</td>
						<td><input type="text" id="thriftAmount" name="thriftAmount"
							class="form-control" style="width: 300px;" maxlength="7"
							onkeypress='return numericKey(event)'></td>

					</tr>


					<tr>
						<td height=5px></td>
					</tr>
					<tr>
						<td align="right">Remarks<label style="color: red;">*</label>&nbsp;
						</td>
						<td><textarea type="text" class="form-control"
								id="memremarks"
								style="width: 300px; height: 50px; text-transform: uppercase;"
								name="remarks" maxlength="95"></textarea></td>
					</tr>

					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td colspan="20" align="left"
							style="border-bottom: 2px solid grey"><b>Bank Details</b> <!-- <input  name="AddNominee" class="button1" id="AddNominee" type="button"  VALUE="AddNominee" onclick="dataview()"/> -->
							<a href='#' id='Addbankdetail' name='Addbankdetail'
							data-toggle='modal' data-target='#bankdiv'>AddBankDetails </a></td>
					</tr>
					<tr>
						<td colspan="20">
							<div class="main" style="margin-top: 5px;">
								<div id="Bankcontainer"
									style="width: 1000px; height: 150px; margin-top: 10px; margin-right: auto; margin-left: auto;"></div>
							</div>
						</td>
					</tr>

					<tr>
						<td height="5px" />
					</tr>
					<tr>
						<td colspan="20" align="left"
							style="border-bottom: 2px solid grey"><b>Member Address</b>
							<!-- <input  name="btnAddAddress" class="button1" id="btnAddAddress" type="button"  VALUE="AddAddress" /> -->
							<a href='#' id='Addaddress' name='Addaddress' data-toggle='modal'
							data-target='#addressdiv'>AddAddress </a></td>
					</tr>

					<tr>
						<td colspan="20">
							<div class="main1" style="margin-top: 5px;">
								<div id="Addresscontainer"
									style="width: 1150px; height: 150px; margin-top: 10px; margin-right: auto; margin-left: auto;"></div>
							</div>
						</td>
					</tr>



				</table>

				<div class="modal fade" id="bankdiv" role="dialog">
					<div class="modal-dialog">


						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h3 class="modal-title">Bank Details</h3>
							</div>
							<div class="modal-body">
								<table>
									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">Bank Account No <label
											style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="bankaccno" name="bankaccno"
											class="form-control"
											style="min-width: 250px; text-transform: uppercase;"></td>
									</tr>


									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">IFSC Code <label style="color: red;">*</label>:&nbsp;
										</td>
										<td><input type="text" id="ifsccode" name="ifsccode"
											class="form-control"
											style="min-width: 250px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>

									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">Bank Name<label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="bankname" name="bankname"
											class="form-control"
											style="min-width: 250px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>

									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">Bank Place <label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="bankplace" name="bankplace"
											class="form-control"
											style="min-width: 250px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>

								</table>
							</div>
							<div class="modal-footer">
								<button type="button" class="button1" id='addButton'
									onclick="AddBank()" data-dismiss="modal">Add</button>
								<button type="button" class="button1" id='closeButton'
									data-dismiss="modal">Close</button>
							</div>


						</div>
					</div>

				</div>
				<div class="modal fade" id="addressdiv" role="dialog">
					<div class="modal-dialog">


						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h3 class="modal-title">New Address</h3>
							</div>
							<div class="modal-body">
								<table>
									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">Address1 <label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="address1" name="address1"
											class="form-control"
											style="min-width: 200px; text-transform: uppercase;"></td>
									</tr>


									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">Address2 <label style="color: red;">*</label>:&nbsp;
										</td>
										<td><input type="text" id="address2" name="address2"
											class="form-control"
											style="min-width: 200px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>

									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">City <label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="city" name="city"
											class="form-control"
											style="min-width: 200px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>

									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">District <label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="District" name="District"
											class="form-control"
											style="min-width: 200px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>
									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">Pincode <label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="pincode" name="pincode"
											class="form-control" style="min-width: 200px;"></td>
										<td>&emsp;&emsp;</td>

									</tr>

									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">State <label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="state" name="state"
											class="form-control"
											style="min-width: 200px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>

									<tr>
										<td height=5px></td>
									</tr>
									<tr>
										<td align="left">Remarks <label style="color: red;">*</label>&nbsp;
										</td>
										<td><input type="text" id="Remarks" name="Remarks"
											class="form-control"
											style="min-width: 200px; text-transform: uppercase;"></td>
										<td>&emsp;&emsp;</td>

									</tr>
								</table>
							</div>
							<div class="modal-footer">
								<button type="button" class="button1" id='addButton'
									onclick="Addaddress()" data-dismiss="modal">Add</button>
								<button type="button" class="button1" id='closeButton'
									data-dismiss="modal">Close</button>
							</div>


						</div>
					</div>

				</div>


				<div>
					<br style="height: 20px;">
					<center>

						<input name="SbtnSaveAndSubmit" class="button1"
							id="SbtnSaveAndSubmit" type="button" VALUE="Save/Submit" /> <input
							name="SbtnClearAll" class="button1" id="SbtnClearAll"
							type="button" VALUE="Clear" /> <input name="btnPrint"
							class="button1" id="btnPrint" type="button" VALUE="PRINT" /> <input
							name="btnPrint1" class="button1" id="btnPrint1" type="button"
							VALUE="PRINT1" />
					</center>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
function onback(){
	window.history.back();
}
var config = {
		'.chosen-select' : {},
		'.chosen-select-deselect'  : {allow_single_deselect:true},
		'.chosen-select-no-single' : {disable_search_threshold:6},
		'.chosen-select-no-results': {no_results_text:'No results  found!'},
		'.chosen-select-width': {width:"95%"}
		}
		for (var selector in config) {
		$(selector).chosen(config[selector]);
		}
</script>


</body>
<script type="text/javascript"
	src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css"
	rel="stylesheet" type="text/css" />

<script type="text/javascript">
var picker = new Pikaday({
    field: document.getElementById('membershipDate'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});
var picker = new Pikaday({
    field: document.getElementById('Dateofbirth'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});


 var picker = new Pikaday({
    field: document.getElementById('nomineedob'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});


</script>
</html>