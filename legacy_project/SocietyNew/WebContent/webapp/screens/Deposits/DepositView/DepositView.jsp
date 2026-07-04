<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"
	autoFlush="true" session="true"%>

<%
	if (session.getAttribute("EMPLOYEECODE") == null) {
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

<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_msg_en.js"></script>
<script type="text/javascript" src="./DepositGrid.js"></script>
<script type="text/javascript" src="./DepositView.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>

<title>Co-Operative Society</title>
<script>
	$(document).ready(function() {
				$("#searchMember").on("keyup",function() {
					var value = $(this).val().toLowerCase();
					//$("#containerGrid").find('tr').not(':first').filter(function() {
					$("#containerGrid tr").not(':first').filter(function() {
					$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
					});
				});
			});
</script>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<input type="hidden" id='memAccNo1' />
	<div><%@include file="/../home1.html"%></div>
	<div align="center"><%@include file="../../ScreenDetails/screenDetails.jsp"%></div>

	<div class="main" align="center">
		<br style="line-height: 60px;">
		<div>
			<br style="line-height: 5px;" />
			<table hidden>
				<tr>
					<td><input type="hidden" id='LOGINMODE' value=<%=session.getAttribute("LOGINMODE")%>></td>
					<td><input type="hidden" id='userId' value=<%=session.getAttribute("EMPLOYEECODE")%>></td>
					<td><input type="hidden" id='timeStamp' value=<%=session.getAttribute("TIMESTAMP")%>></td>
					<td><input type="hidden" id='emplcode'></td>
					<td><input type="hidden" id='Role' value=<%=session.getAttribute("ROLE")%>></td>
				</tr>
			</table>

			<table align="center" id="nameFont" width="auto" border="0" bgcolor="pink">
				<TR>
					<td align="right"><label>Search Member:</label> <input id="searchMember" type="text" placeholder="Search.."></td>
					<td width="50px" />

					<td align="right"><label>Status :</label>
					<td><select class="chosen-select" id='depositstatus' style='width: 200px; height: 30px;' data-placeholder='Select status'>
						<option></option>
					</select></td>
					<td width="35px" />
					<td><button type="button" class="btn btn-primary" style='width: 60px;' id="go">GO</button></td>
					<td width="40px" />

					<!-- <td><button type="button"  class="btn btn-primary"  id="fresh">FRESH</button></td><td width="25px"/>
<td><button type="button"  class="btn btn-primary" id="active">ACTIVE</button></td><td width="25px"/>
<td><button type="button"  class="btn btn-primary"  id="cancel">CANCELED</button></td><td width="25px"/> -->
					<td width="25px" />
					<TD hidden><label>Sort By</label> <select>
							<option value="">--select--</option>
							<option value="memcode">EMPCODE</option>
							<option value="name">NAME</option>
					</select></TD>
				</TR>
			</table>
			<br style="line-height: 30px;">
			<div align="center" id="containerGrid"></div>

		</div>
		<!-- just statrts  -->


		<div class="container">
			<!-- Trigger the modal with a button -->
			<!-- Modal -->
			<div class="modal fade" id="myModal" role="dialog">
				<div class="modal-dialog">

					<!-- Modal content-->
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h3 class="modal-title">Deposit Details</h3>
						</div>
						<div class="modal-body">

							<table cellpadding="4" width="75%" id='viewDetails' align="center" border="0">
								<tr id='basicInfo'>
									<td><input type="hidden" id='accNo'></td>
									<td><input type="hidden" id='empCode'> <input type="hidden" id='depositnum'></td>
								</tr>
								<tr>
									<td colspan="2" style="font-size: large; text-decoration: underline;"> Personal Information</td>
								</tr>
								<tr>
									<td>Member</td>
									<td><a href="#"><span id="employeeDetails"></span></a></td>
								</tr>

								<!-- <tr>
<td>Designation  </td><td><span id="Designation"></span> </td>
</tr>
<tr>
<td>Division </td><td><span id="Division"></span> </td>
</tr>
<tr>
<td>Contact Info </td><td><span id="phoneNum"></span> </td>
</tr>

<tr>
<td>DOB  </td><td><span id="dateOfBirth"></span> </td>
</tr>

<tr>
<td>Status </td><td><span id="status"></span> </td>
</tr>
<tr>
<td>Mail Id </td><td><span id="MailId"></span> </td>
</tr>

<tr>
<td>Bank Acc No. </td><td><span id="bankAccNo"></span> </td>
</tr>

<tr>
<td>Basic Pay </td><td><span id="basicPay"></span> </td>
</tr>
<tr>
<td>IFSC Code </td><td><span id="ifscCode"></span> </td>
</tr>
<tr>
<td>Bank Name </td><td><span id="bankName"></span> </td>
</tr> -->

			</table>
			<br>
			<table cellpadding="4" width="75%" id='viewDetails_2' border="0">

				<tr>
					<td colspan="2" style="font-size: large; text-decoration: underline;"> Deposit Information</td>
				</tr>
				<tr>
					<td>Deposit No.</td>
					<td><a href="#"><span id="DepositNo"></span></a></td>
				</tr>
				<tr>
					<td>DepositType</td>
					<td><span id="DepositType"></span></td>
				</tr>
				<tr>
					<td>IntetrestRate</td>
					<td><span id="IntRate"></span></td>
				</tr>
				<tr>
					<td>OpenDate</td>
					<td><span id="OpenDate"></span></td>
				</tr>
				<tr>
					<td>Duration</td>
					<td><span id="Duration"></span></td>
				</tr>

				<!-- <tr>
<td>Aadhar  </td><td><span id="aadharNumber"></span> </td>
</tr> -->
				<tr>
					<td>MaturityAmount</td>
					<td><span id="MaturityAmount"></span></td>
				</tr>
				<tr>
					<td>Subscription</td>
					<td><span id="Subscription"></span></td>
				</tr>
				<!-- <tr>
					<td>Settlement Amount</td>
					<td><span id="settlementAmount"></span></td>
				</tr> -->
				<tr>
					<td><label>Close Date </label></td>
					<td><label><span id="Shortclosedate"></span></label></td>
				</tr>
				<tr>
					<td><label>Status Info </label></td>
					<td><label><span id="Statusinfo"></span></label></td>
				</tr>
			</table>

			<br style="line-height: 5px;">
			<table cellpadding="4" width="75%" id='viewDetails_3' border="0">
				<tr id='remarksTR'>
					<td>Remarks</td>
					<td><textarea id='Remarks' name="Remarks" style="width: 300px; height: 40px;"></textarea></td>
				</tr>
			</table>
			<br style="line-height: 5px;">

			<div align="left" style="padding-left: 13%">
				<input type="submit" class="button1" id='actEdit' value="Edit" />
				<input type="submit" class="button1" id='actBtn' value="Approve" />
				<input type="submit" class="button1" id='delBtn' value="Reject" />
				<input name="btnPrint" align="center" class="button1" id="btnPrint" type="button" VALUE="Print" /> 
				<input name="btnDepositProcess" align="center" class="button1" id="btnDepositProcess" type="button" VALUE="Deposit Processing" />
			</div>
		</div>
			<div class="modal-footer">
				<button type="button" class="button1" id='closeButton'data-dismiss="modal">Close</button>
			</div>
			</div>

		</div>
	</div>

</div>


		<!-- endsss  -->
	</div>

	<script type="text/javascript">
		function onback() {
			window.history.back();
		}
		var config = {
			'.chosen-select' : {},
			'.chosen-select-deselect' : {
				allow_single_deselect : true
			},
			'.chosen-select-no-single' : {
				disable_search_threshold : 6
			},
			'.chosen-select-no-results' : {
				no_results_text : 'No results  found!'
			},
			'.chosen-select-width' : {
				width : "95%"
			}
		}
		for ( var selector in config) {
			$(selector).chosen(config[selector]);
		}
	</script>

</body>
</html>