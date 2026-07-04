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
	src="../../../commonFiles/js/jquery-1.12.4.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/bootstrap.min.js"></script>
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"
	type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet"
	type="text/css" />

<script type="text/javascript"
	src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet"
	type="text/css" />

<script type="text/javascript"
	src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="./suretyReplace.js"></script>
<script type="text/javascript" src="./suretyReplaceGrid.js"></script>
<title>Co-Operative Society</title>

</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>
	<div class="main">


		<br style="line-height: 60px;">
		<div align="center">
			<br style="line-height: 5px;" />
			<table align="center">
				<tr>
					<td><input type="hidden" id='LOGINMODE'
						value=<%=session.getAttribute("LOGINMODE") %>></td>
					<td><input type="hidden" id='userId'
						value=<%=session.getAttribute("EMPLOYEECODE") %>></td>
					<td><input type="hidden" id='timeStamp'
						value=<%=session.getAttribute("TIMESTAMP") %>></td>
				</tr>
				<tr>
					<td><b>Member Acc No :</b></td>
					<td><select id="empCode" name="empCode" class="chosen-select"
						style='width: 400px;' data-placeholder="select Mem Acc No">
							<option value=""></option>
					</select></td>
				</tr>

				<tr>
					<td height="7px" />
				</tr>

				<tr>
					<td><b>Add Surety :</b></td>
					<td><select id="addempCode" name="addempCode"
						class="chosen-select" style='width: 400px;'
						data-placeholder="select Mem Acc No">
							<option value=""></option>
					</select></td>
				</tr>
			</table>
			<br style="line-height: 10px;">
			<div align="center" id="containerGrid"></div>
			<div class="container">
				<!-- Trigger the modal with a button -->
				<!-- Modal -->
				<div class="modal fade" id="myModal" role="dialog">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h3 class="modal-title">Deposits Details</h3>
							</div>
							<div class="modal-body">
								<table>
									<tr>
										<td>Member Acc No &emsp;</td>
										<td><b><span id="memAccNo"></span></b></td>
									</tr>
								</table>
								<table cellpadding="2" width="50%" id='viewDetails'
									align="center" border="1">

									<tr>

										<td>Deposite No/ Date of Deposite</td>
										<td><span id="DepositDetails"></span></td>
									</tr>
									<tr>
										<td>Subscription Amount(Rs)</td>
										<td><span id="ValueInRs"></span></td>
									</tr>
									<tr>
										<td>Deposit Type</td>
										<td><span id="DepositType"></span></td>
									</tr>
									<tr>
										<td>Open Date</td>
										<td><span id="OpenDate"></span></td>
									</tr>
									<tr>
										<td>Duration</td>
										<td><span id="Duration"></span></td>
									</tr>
									<tr>
										<td>Maturity Amount</td>
										<td><span id="MaturityAmount"></span></td>
									</tr>
								</table>
							</div>

							<div class="modal-footer">
								<button type="button" class="button1" id='closeButton'
									data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<br style="height: 20px;">
		<center>
			<input name="btnSave" class="button1" id="btnSave" type="button"
				VALUE="Save" /> <input name="btnClearAll" class="button1"
				id="btnClearAll" type="button" VALUE="Clear" />
		</center>
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

</html>