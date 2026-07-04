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
<script type="text/javascript" src="../../../commonFiles/js/jquery-1.12.4.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../LoanProcess/loanProcess.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>

<style type="text/css">
span {
	margin-left: 10px;
}
</style>

<title>Co-Operative Society</title>

</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<input id="RuleValue" type="hidden" />
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<br style="line-height: 30px">
	<div class="main" id='main'>
		<br style="line-height: 35px">
		<table align="center">

			<tr>
				<td align="right"><label>Member Code:</label></td>
				<td><select id='memCode' name="memCode" class="chosen-select" style='width: 390px;' data-placeholder="Select User">
						<option value=""></option>
				</select></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr>
				<td align="right"><label>Loan App No:</label></td>
				<td><select id='LoanAppNo' name="LoanAppNo" class="chosen-select" style='width: 390px;' data-placeholder="Select LoanProcess">
						<option value=""></option>
				</select></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr id="FDLdate" hidden>
				<td align="right"><label id=''>FDL Process Date :</label></td>
				<td><input type="text" id="processdate" name="processdate" class="form-control" style="width: 220px;" maxlength="10" readonly="readonly"></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr>
				<td align="right"><label>Process:</label></td>
				<td><select id='Process' name="Process" class="chosen-select" style='width: 390px;' data-placeholder="Select Process">
						<option value=""></option>
						<option value="cngOfInst">Change of Installments</option>
						<option value="monthlyInst">Monthly Installment Amount</option>
						<option value="slmtAmt">Settlement Amount</option>
				</select></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr id="chngInst">
				<td align="right"><label>Number Of Installments :</label></td>
				<td><input type="text" name="NumOfInst" id="NumOfInst" style='width: 300px;'></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr id="monthlyInstAmnt">
				<td align="right"><label id=''>Monthly Installment amount :</label></td>
				<td><input type="text" name="InstAmnt" id="InstAmnt" style='width: 300px;' ></td>
			</tr>
			<tr> <td height=10px></td> </tr>			
			<tr id="priBalTR">
				<td align="right"><label>Principal Bal :</label></td>
				<td><span name="priBal" id="priBal"></span></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr id="IntrBalTR">
				<td align="right"><label>Interest Bal :</label></td>
				<td><span name="IntrBal" id="IntrBal"></span></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr id="settlAmtTR">
				<td align="right"><label>Total Settlement Amount :</label></td>
				<td><span name="settlAmt" id="settlAmt"></span></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr id="RecieptNoTR">
				<td align="right"><label>Reciept No :</label></td>
				<td><span id="RecieptNo"></span></td>
			</tr>
			<tr> <td height=10px></td> </tr>
			<tr id="remarks">
				<td align="right"><label>Bank Name :</label></td>
				<td><input type="text" id="bankName" name="bankName" /></td>
			</tr>
		</table>
	</div>
	<br style="line-height: 20px">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button" VALUE="Process" />
		<!-- <input  name="btnPrint" class="button1" id="btnPrint" type="button"  onclick="btnPrintClick();" VALUE="Print"  /> -->
		<input name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear" />
	</center>


</body>
<script>var config = {
		'.chosen-select' : {},
		'.chosen-select-deselect'  : {allow_single_deselect:true},
		'.chosen-select-no-single' : {disable_search_threshold:6},
		'.chosen-select-no-results': {no_results_text:'No results  found!'},
		'.chosen-select-width': {width:"95%"}
		}
		for (var selector in config) {
		$(selector).chosen(config[selector]);
		}
		
var picker = new Pikaday({
    field: document.getElementById('processdate'),
    format: 'DD/MM/YYYY',
    //minDate: new Date(),
    //maxDate: new Date(),
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});
</script>

</html>