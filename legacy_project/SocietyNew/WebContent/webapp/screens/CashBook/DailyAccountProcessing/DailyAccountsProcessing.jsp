
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

<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"	type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/js/datepicker/pikaday.css"	rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../DailyAccountProcessing/DailyAccountsProcessing.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>




<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>

	<input type="hidden" id="currDate" name="currDate" value=<%=new SimpleDateFormat("MM/dd/YYYY").format(new Date()) %>>
	<div><%@include file="/../home1.html"%></div>


	<div align="center"><%@include file="../../ScreenDetails/screenDetails.jsp"%></div>

	<br style="line-height: 30px;">
	<div class="main">
		<br style="line-height: 35px">
		<div align="center">
			<table width="700px" class=MsoTableGrid cellspacing=2 cellpadding=2 style='border-collapse: collapse; border: none; margin-left: auto; margin-right: auto;'>
				<tr>
					<td align="right"><label>Processing Date:</label></td>
					<td><input type="text" id="processsdate" name="processsdate" class="form-control" style="width: 190px;" maxlength="10" disabled="disabled"></td>
				</tr>
				<tr><td height="15px" /></tr>
			</table>
			<center>
				<input name="processbtn" class="button1" id="processbtn" type="button" VALUE="Process" />
				 <input name="printbtn"	class="button1" id="printbtn" type="button" VALUE="Print" />
			</center>
		</div>
	</div>
	<br style="line-height: 10px">
	<table align="center">
		<tr>
			<td></td>
		</tr>
	</table>

	<script type="text/javascript">
function onback(){
	window.history.back();
}
</script>

</body>
<script type="text/javascript" src="../../../commonFiles/js/common.js"></script>

</html>