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

<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../Depositsprocessing/depositsProcessing.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../Depositsprocessing/validate.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body onload='checkDeposit()'>
	<input type="hidden" id='depositno' value=<%=request.getParameter("depositno")%>>
	<input type="hidden" id='memAccno' value=<%=request.getParameter("memAccno")%>>
	<input type="hidden" id='deposittype' value=<%=request.getParameter("deposittype")%>>
	<input type="hidden" id="currDate" name="currDate" value=<%=new SimpleDateFormat("MM/dd/yyyy").format(new Date()) %>>
	<input type="hidden" id='Role' value=<%=session.getAttribute("ROLE") %>>
	<input type="hidden" id='paymentnum'>
	
	<div><%@include file="/../home1.html"%></div>

	<div align="center"><%@include file="../../ScreenDetails/screenDetails.jsp"%></div>


	<div class="main">
		<br style="line-height: 25px;">
		<div align="center">
			<br style="line-height: 35px;">
			<table align="center" id="nameFont" width="auto" border="0" bgcolor="pink">
				<tr><td height=10px></td></tr>

				<tr>
					<td align="right"><label>Member Details:</label>&nbsp;</td>
					<td><textarea id='memberDetails' name="memberDetails" style="width: 300px; height: 50px;" readonly="readonly"></textarea></td>
				</tr>

				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Deposit Process Types:</label>&nbsp;</td>
					<td><select class="chosen-select" id='depositprocessTypes' style='width: 300px; height: 30px;' data-placeholder='Select Deposit Type'>
							<option value="Select"></option>
					</select></td>
				</tr>

				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Deposit Number:</label>&nbsp;</td>
					<td><input type="text" id='depositNumber'style='width: 300px; height: 28px;' readonly="readonly"></td>
				</tr>

				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Maturity Amount:</label>&nbsp;</td>
					<td><span id='maturityamount'> </span></td>
				</tr>
				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Maturity Date:</label>&nbsp;</td>
					<td><span id='maturitydate'> </span></td>
				</tr>
				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Deposit Process Request:</label>&nbsp;</td>
					<td><select class="chosen-select" id='depositprocessreq' style='width: 300px; height: 30px;' data-placeholder='Select Deposit Request'>
						<option></option>
					</select></td>
				</tr>
				<tr><td height=10px></td>
				</tr>
				<tr id="adjloanref">
					<td align="right"><label>Loan Reference No:</label>&nbsp;</td>
					<td><select class="chosen-select" id='loanrefno' style='width: 300px; height: 30px;' data-placeholder='Select Loan Reference Number'>
						<option></option>
					</select></td>
				</tr>
				<tr> <td height=10px></td> </tr>
				<tr id="adjloanamt">
					<td align="right"><label>Loan Adjustment Amount:</label>&nbsp;
					</td>
					<td><input type="text" id="loanadjamt" name="loanadjamt" class="form-control" style="width: 300px;"></td>
				</tr>
				<tr> <td height=10px></td></tr>
				<tr>
					<td align="right"><label>Process Date:</label>&nbsp;</td>
					<td><input type="text" id="processDate" name="processDate" class="form-control" style="width: 300px;" maxlength="10" readonly="readonly"></td>
				</tr>
				<tr> <td height=10px></td></tr>
				<tr id="adjloanamt">
					<td align="right"><label>Settlement Amount:</label>&nbsp;
					</td>
					<td><input type="text" id="settleAmnt" name="settleAmnt" class="form-control" style="width: 300px;" disabled="disabled"></td>
				</tr>
				<tr> <td height=10px></td></tr>
				<tr>
					<td align="right"><label>Remarks:</label>&nbsp;</td>
					<td><textarea type="text" class="form-control" id="remarks" style="width: 300px; height: 50px; text-transform: uppercase;" name="remarks" maxlength="250"></textarea></td>
				</tr>
			</table>
		</div>
	</div>
	<br style="line-height: 10px">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button" VALUE="Save" /> <input name="btnApproval" class="button1" id="btnApproval" type="button" value="Approval" />
		<!-- <input  name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear"  /> -->
	</center>

	<script type="text/javascript">
function onback(){
	window.history.back();
}
</script>
</body>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

<script>
var picker = new Pikaday({
    field: document.getElementById('processDate'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('MM/DD/YYYY'));
    }
});
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

</html>