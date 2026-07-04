
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

<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />


<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../RecieptProcess/RecieptProcess.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../RecieptProcess/Validation.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>



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


	<br style="line-height: 30px;">
	<div class="main">

		<br style="line-height: 35px">


		<div align="center">
			<h4>Reciept Processing Screen</h4>
			<table align="center" id="nameFont" border="0">
				<tr>
				<tr>
					<td align="right"><label>Member Code:&nbsp;</label></td>
					<td><select id='memCode' name="memCode"
						data-placeholder="Select Account No" class="chosen-select"
						style='width: 300px;'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr><td height="8px"></td></tr>
				<tr>
					<td align="right"><label>Reciept No / Date:</label>&nbsp;</td>
					<td><select id='recNo' name="'recNo'" data-placeholder="Select Reciept No" class="chosen-select" style='width: 300px;'>
						<option value=""></option>
					</select></td>
				</tr>

<!-- <tr><td height= 10px></td></tr>
<tr >
<td id="dateOfReciept">Reciept Date:&nbsp;<span id="loanRefNo" ></span> </td>
</tr> -->

				<tr><td height=10px></td></tr>
				<tr id="PurposeDescTR">
					<td align="right"><label>Purpose :&nbsp;</label></td>
					<td><span id="PurposeDesc"></span></td>
				</tr>

				<tr><td height=10px></td></tr>
				
				<tr id="amountTR">
					<td align="right"><label>Amount:&nbsp;</label></td>
					<td><span id="amount"></span></td>
				</tr>

				<tr><td height=10px></td></tr>
				
				<tr id="ModeOfPayTR">
					<td align="right"><label>Mode Of Pay:&nbsp;</label></td>
					<td><span id="ModeOfPay"></span></td>
				</tr>

			</table>
		</div>
	</div>

	<br style="line-height: 10px">
	<center>
		<input name="btnCancel" class="button1" id="btnCancel" type="button"
			VALUE="Cancel" /> <input name="btnClearAll" class="button1"
			id="btnClearAll" type="button" VALUE="Clear" />
	</center>

	<script type="text/javascript">
function onback(){
	window.history.back();
}
</script>

</body>
<script type="text/javascript" src="../../../commonFiles/js/common.js"></script>

</html>