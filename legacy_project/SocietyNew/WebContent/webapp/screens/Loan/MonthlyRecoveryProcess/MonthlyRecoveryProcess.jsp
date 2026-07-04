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
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"	type="text/css" />
<script type="text/javascript" src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet"	type="text/css" />

<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../MonthlyRecoveryProcess/MonthlyRecoveryProcess.js"></script>

<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>


<script type="text/javascript" src="../../../commonFiles/js/datepickermonth/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepickermonth/pikaday.js"></script>
<link href="../../../commonFiles/js/datepickermonth/pikaday.css" rel="stylesheet" type="text/css" />


<script type="text/javascript" src="./MonthlyrecoveryGrid.js"></script>

<title>Co-Operative Society</title>

</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div id="dialog1" name="dialog1" class="dialog1" style="margin-top:100%">
	<center><img alt="" src="loading.gif" height="50px" width="50px"></center>
	</div>
	<input id="RuleValue" type="hidden" />
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<br style="line-height: 30px">
	<div class="main" id='main'>
		<br style="line-height: 35px">

		<table align="center">

			<tr align="left">
				<td align="left"><label> Month&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;</label>
					<input id='monthproces' name="monthproces" placeholder="month" style='border-radius: 5px;text-align: center;width: 70px;'/>&nbsp;&nbsp;&nbsp;<label>Year:</label>
					<input id='yearproces' name="yearproces" placeholder="year" style='border-radius: 5px;text-align: center;width: 70px;'/>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
					name="btnProcess" class="button1" id="btnProcess" type="button"
					style='width: 90px;' VALUE="Process" />
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp; <input name="text" class="button1" id="text" type="button" VALUE="Text File" onclick="generateFile(this.id)" />
					<input name="excel" class="button1" id="excel" type="button" VALUE="Excel File" onclick="generateFile(this.id)" />
				</td>
			</tr>

			<tr>
				<td height=10px></td>
			</tr>


			<tr align="left">
				<td align="left"><label>Purpose:</label> <select id='Purpose'
					name="Purpose" class="chosen-select" style='width: 320px;'
					data-placeholder="Select Purpose">
						<option value=""></option>
				</select></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input
					name="btnProcess" class="button1" id="btnView" type="button"
					style='width: 90px;' VALUE="View" />
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp; <input name="btnClearAll"
					class="button1" id="btnClearAll" type="button"
					style='width: 120px;' VALUE="Clear" />
				</td>
			</tr>
		</table>
		<table align="center">
			<tr>
				<td height=15px></td>
			</tr>
			<tr>
				<!-- <td>
<input  name="btnProcess" class="button1" id="btnProcess" type="button"  VALUE="Process" />
</td> -->
		</table>
		<br style="line-height: 10px;">
		<div align="center" id="containerGrid"></div>
	</div>
	<table align="center">
		<tr>
			<td height=2px></td>
		</tr>
		<tr>
			<!--  <td>
<input  name="btnGeneratetext" class="button1" id="btnGeneratetext" type="button"  VALUE="Generate  File" />
</td> -->
			<!-- <td>
<input  name="btnClearAll" class="button1" id="btnClearAll" type="button" style='width: 90px;' VALUE="Clear" />
</td> -->
	</table>
</body>
<script type="text/javascript" src="../../../commonFiles/js/common.js"></script>
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
</script>


</html>