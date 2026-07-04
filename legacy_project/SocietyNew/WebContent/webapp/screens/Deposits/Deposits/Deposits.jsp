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
<script type="text/javascript" src="../Deposits/Deposits.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../Deposits/validate.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body onload='checkEmp()'>
	<input type="hidden" id='depositnum' value=<%=request.getParameter("depositnum")%>>
	<input type="hidden" id='memAccno' value=<%=request.getParameter("memAccno")%>>
	<%-- <%
System.out.print(new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
%> --%>
	<input type="hidden" id="currDate" name="currDate" value=<%=new SimpleDateFormat("dd/MM/yyyy").format(new Date()) %>>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<div class="main">
		<br style="line-height: 35px;">
		<div align="center">
			<br style="line-height: 35px;">
			<table align="center" id="nameFont" width="auto" border="0" bgcolor="pink">
				<tr><td height=10px></td></tr>
				<tr>
					<td><label>Member Account Number:</label></td>
					<td><select id='empCode' class="chosen-select" style='width: 350px; height: 28px;' data-placeholder='Select Member'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Type of Deposit:</label>&nbsp;</td>
					<td><select class="chosen-select" id='deposit' style='width: 350px; height: 28px;'data-placeholder='Select Deposit Types'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Deposit Date:</label>&nbsp;</td>
					<td><input type="text" id="depositDate" name="depositDate"class="form-control" style="width: 220px;" maxlength="10" readonly="readonly"></td>
				</tr>
				<tr><td height=10px></td></tr>
				
				<tr>
					<td align="right"><label>Amount:</label>&nbsp;</td>
					<td><input type="text" id="Amount" name="Amount" class="form-control"  style="width: 220px; text-transform: uppercase;" maxlength="10" onkeypress='return numericKey(event)'></td>
					<td>&emsp;<a href="#" id="link"></a>
					</td>
				</tr>

				<tr><td height=10px></td></tr>

				<tr>
					<td align="right"><label>Duration  (Months):</label>&nbsp;</td>
					<td><input type="text" id='duration' name='duration' class="form-control" style="width: 220px; text-transform: uppercase;" maxlength="10" onkeypress='return numericKey(event)'></td>
				</tr>
				
				<tr><td height=10px></td></tr>
				<tr id="mtDate">
					<td align="right"><label>Maturity Date:</label>&nbsp;</td>
					<td><input type="text" id="maturityDate" name="maturityDate"class="form-control" style="width: 220px;" maxlength="10" readonly="readonly"></td>
				</tr>
				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Interest:</label>&nbsp;</td>
					<td><input type="text" id="interest" name="interest" class="form-control" style="width: 220px; text-transform: uppercase;" maxlength="10" onkeypress='return numericKey(event)'></td>
					<td>&emsp;<a href="#" id="link"></a>
					</td>
				</tr>
				
				<tr><td height=10px></td></tr>
				<tr id="mtAmount">
					<td align="right"><label>Maturity Amount:</label>&nbsp;</td>
					<td><input type="text" id="maturityAmnt" name="maturityAmnt"class="form-control" style="width: 220px;" maxlength="10" readonly="readonly" onkeypress='return numericKey(event)'></td>
				</tr>
				<tr><td height=10px></td></tr>
				<tr>
					<td align="right"><label>Nominee Details:</label>&nbsp;</td>
					<td><select class="chosen-select" id='nomineeRefNu' style='width: 350px; height: 28px;' data-placeholder='Select Nominee'>
							<option value=""></option>
					</select></td>
					<!-- 	<td align="right">Nominee Details:&nbsp;</td>
			<td><span id ='nomineeDetails'></span></td> -->
				</tr>
				
				<tr><td height=10px></td></tr>
				
				<tr>
					<td align="right"><label>Remarks:</label>&nbsp;</td>
					<td><textarea type="text" class="form-control" id="remarks" style="width: 300px; height: 50px; text-transform: uppercase;" name="remarks" maxlength="250"></textarea></td>
				</tr>

				<tr><td height=10px></td></tr>
				
				<tr>
					<td align="right"><label>Deposit Number:</label>&nbsp;</td>
					<td><span id='depositNumber' style="color: red;"></span></td>
				</tr>
			</table>

		</div>
	</div>
	<br style="line-height: 10px">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button" VALUE="Save" /> 
		<input name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear" />

	</center>
	<center>
		<br />
		<tr><td height=25px></td></tr>
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
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

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