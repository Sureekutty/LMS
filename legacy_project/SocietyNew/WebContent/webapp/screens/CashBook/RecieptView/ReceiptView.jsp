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
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/jquery-1.12.4.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_msg_en.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<script type="text/javascript" src="./ReceiptGrid.js"></script>
<script type="text/javascript" src="./ReceiptView.js"></script>
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
	<input type="hidden" id='receiptnum'>
	<input type="hidden" id='memAccno1'>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div id="dialog1" name="dialog1" class="dialog1" style="margin-top: 100%">
		<center>
			<img alt="" src="loading.gif" height="50px" width="50px">
		</center>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

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
			<div>
			<table>
			<tr>
				<td align="right"><label style="margin-right: 90px;">Date Interval: </label> From :</td>
				<td><input type="text" id="recefromDate" name="recefromDate" class="form-control" style="width: 190px;" maxlength="10" readonly="readonly"></td>
				<td >To :</td>
				<td><input type="text" id="recetoDate" name="recetoDate" class="form-control" style="width: 190px;" maxlength="10" readonly="readonly"></td>
			</tr>
			</table>
			<br style="line-height: 20px;" />
			<table align="center">
			
				<TR>
					<td align="right"><label>Search Member:</label><input id="searchMember" type="text" placeholder="Search.."></td>
					<td width="50px" />
					<!-- <td><button type="button"  class="btn btn-primary"   id="all">ALL</button> </td><td width="25px"/> -->
					<td><button type="button" class="btn btn-primary" id="fresh">FRESH</button></td>
					<td width="40px" />
					<td><button type="button" class="btn btn-primary" id="active">ACTIVE</button></td>
					<td width="40px" />
					<td><button type="button" class="btn btn-primary" id="cancel">CANCEL</button></td>
					<td width="40px" />
					<td width="30px" />
					<TD hidden><label>Sort By</label> <select>
							<option value="">--select--</option>
							<option value="memcode">EMPCODE</option>
							<option value="name">NAME</option>
					</select></TD>
				</TR>
			</table>
			</div>
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
							<h3 class="modal-title">Receipt Details</h3>
						</div>
						<div class="modal-body">
							<table cellpadding="4" width="75%" id='viewDetails'
								align="center" border="0">
								<tr id='basicInfo'>
									<td><input type="hidden" id='accNo'></td>
									<td><input type="hidden" id='empCode'> <input
										type="hidden" id='depositnum'></td>
								</tr>
								<tr>
									<td colspan="2" style="font-size: large; text-decoration: underline;"> Personal Information</td>
								</tr>
								<tr>
									<td>Employee:</td>
									<td><a href="#"><span id="employeeDetails"></span> </a></td>
								</tr>

								<!-- <tr>
<td>Designation : </td><td><span id="Designation"></span> </td>
</tr>

<tr>
<td>Division: </td><td><span id="Division"></span> </td>
</tr>

<tr>
<td>Contact Info: </td><td><span id="phoneNum"></span> </td>
</tr>

<tr>
<td>Aadhar:  </td><td><span id="aadharNumber"></span> </td>
</tr>

<tr>
<td>Mail Id :</td><td><span id="MailId"></span> </td>
</tr>

<tr>
<td>Basic Pay: </td><td><span id="basicPay"></span> </td>
</tr>

<tr>
<td>Bank Acc No. </td><td><span id="bankAccNo"></span> </td>
</tr> -->

							</table>

							<br />
							<table cellpadding="4" width="75%" id='viewDetails_2' align="center" border="0">

								<tr>
									<td colspan="2" style="font-size: large; text-decoration: underline;">Receipt Information</td>
								</tr>
								<tr>
									<td>Receipt No.</td>
									<td><a href="#"><span id="receiptno"></span></a></td>
								</tr>
								<tr>
									<td>Receiptdate:</td>
									<td><span id="receiptdate"></span></td>
								</tr>
								<tr>
									<td>amount:</td>
									<td><span id="amount"></span></td>
								</tr>
								<tr>
									<td>purposecode :</td>
									<td><span id="purposecode"></span></td>
								</tr>
								<tr>
									<td>ModeOfPayment :</td>
									<td><span id="DepositType"></span></td>
								</tr>
								<tr class="hideviewdependsonpurspono">
									<td>Deposit Type :</td>
									<td><span id="Depositty"></span></td>
								</tr>
								<tr class="hideviewdependsonpurspono">
									<td>Month :</td>
									<td><span id="month"></span></td>
								</tr>
								<tr class="hideviewdependsonpurspono">
									<td>Opening Balance :</td>
									<td><span id="openingbal"></span></td>
								</tr>
								<tr class="hideviewdependsonpurspono">
									<td>Closing Balance :</td>
									<td><span id="closingbal"></span></td>
								</tr>
								<tr id='remarksTR'>
									<td>Remarks:</td>
									<td><textarea id='Remarks' name="Remarks" style="width: 300px; height: 50px;"></textarea></td>
								</tr>
							</table>

							<br style="line-height: 5px;">

							<div align="left" style="padding-left: 13%">
								<input type="submit" class="button1" id='editBtn' value="Edit" />
								<input type="submit" class="button1" id='actBtn' value="Approve" />
								<input type="submit" class="button1" id='delBtn' value="Reject" />
								<input type="submit" class="button1" id='btnPrint' value="Print" />
							</div>

						</div>

						<div class="modal-footer">
							<button type="button" class="button1" id='closeButton' data-dismiss="modal">Close</button>
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
	</script>

</body>
</html>