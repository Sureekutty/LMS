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
	src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet"
	type="text/css" />

<script type="text/javascript" src="../LoanRecovery/Loanrecovery.js"></script>
<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../LoanRecovery/validate.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<%-- <%
System.out.print(new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
%> --%>
	<input type="hidden" id="currDate" name="currDate"
		value=<%=new SimpleDateFormat("dd/MM/yyyy").format(new Date()) %>>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<div class="main">
		<br style="line-height: 35px;"> 
		<input type="hidden" id="Loantype"> 
		<input type="hidden" id="Loanint">
		 <input	type="hidden" id="receiptno"> 
		 <input type="hidden" id="initreceiptno">
		<div align="center">
			<br style="line-height: 35px;">
			<table align="center" id="nameFont" bgcolor="pink">


				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td><label>Member Account Number &nbsp;&nbsp;&nbsp;: </label><select
						id='empCode' class="chosen-select"
						style='width: 450px; height: 28px;'
						data-placeholder='Select Member'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr>
					<td align="left" colspan="20" style="border-bottom: 2px solid grey"><b>LoanAccount
							Number &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <label
							id='loanaccNumber'></label>
					</b></td>
				</tr>
				<tr>
					<td align="center" colspan="20"
						style="border-bottom: 2px solid grey"><b>Loan Details
							&nbsp;&nbsp;&nbsp;</b></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Loan Open Date
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label>
						<label id='loanappdate'></label></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>No of
							Installments&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label>
						<label id='noofinstallments'></label></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Loan Sanction
							Amount&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label> <label
						id='loansancamt'></label></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Loan Sanction Date
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
					</label><label id='loansanctiondate'></label></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>No of Installment
							Paid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label>
						<label id='noofinstallpaid'></label></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Principal balance
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label>
						<label id='principalbal'></label></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Interest Rate
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label>
						<label id='interestrate'></label></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Mode of payment
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</label><select
						name="modeOfPay" class="chosen-select" id='modeOfPay'
						style='width: 150px;'>
							<option value=""></option>
							<option value="Cash">Cash</option>
							<option value="Cheque">Cheque</option>
					</select></td>
				</tr>



			</table>

		</div>

		<table align="center">
			<tr>
				<td height=10px></td>
			</tr>
			<tr>
				<td align="right"><label>Principal Amount&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<a></a></td>
				<td><input type="text" id="principalamt" name="principalamt"
					class="form-control"
					style="width: 170px; text-transform: uppercase;" maxlength="10"
					onkeypress='return numericKey(event)'></td>
				<td align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>Interest
						Amount &nbsp;&nbsp;&nbsp;:</label></td>
				<td><input type="text" id="interestamt" name="interestamt"
					class="form-control"
					style="width: 170px; text-transform: uppercase;" maxlength="10"
					onkeypress='return numericKey(event)'></td>
			</tr>
		</table>

	</div>
	<br style="line-height: 10px">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button"
			VALUE="Save" /> <input name="btnClearAll" class="button1"
			id="btnClearAll" type="button" VALUE="Clear" />

	</center>
	<center>
		<br />
		<tr>
			<td height=25px></td>
		</tr>
		<tr>
			<label id="succalert" style="color: red;" />
		</tr>
	</center>
	<script type="text/javascript">
function onback(){
	window.history.back();
}
</script>
</body>
<script type="text/javascript"
	src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css"
	rel="stylesheet" type="text/css" />

<script>
var picker = new Pikaday({
    field: document.getElementById('depositDate'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
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