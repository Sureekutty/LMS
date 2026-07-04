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
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../ThriftSubscription/ThriftSubscription.js"></script>

<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>



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

			<!-- <tr>
<td>
<input>
<select>
<option id="empCode" value="">select</option>
</select>     
</td>
</tr> -->
			<tr>
				<td align="right"><label>Member Code:</label></td>
				<td><select id='memCode' name="memCode" class="chosen-select" style='width: 390px;' data-placeholder="Select User">
						<option value=""></option>
				</select></td>
			</tr>

			<tr>
				<td height=10px></td>
			</tr>

			<tr>
				<td align="right"><label>Process:</label></td>
				<td><select id='Process' name="Process" class="chosen-select" style='width: 390px;' data-placeholder="Select Process">
					<option value=""></option>
						<option value="monthlyThrift">Monthly Thrift Subscription</option>
				</select></td>
			</tr>
			<tr>
				<td height=10px></td>
			</tr>

			<tr id="monthlyThrift">
				<td align="right"><label>Amount :</label></td>
				<td><input type="text" name="ThriftAmnt" id="ThriftAmnt" style='width: 300px;' disabled="disabled"></td>
			</tr>

			
		</table>
	</div>
	<br style="line-height: 20px">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button" value="Process" />
		<!-- <input  name="btnPrint" class="button1" id="btnPrint" type="button"  onclick="btnPrintClick();" VALUE="Print"  /> -->
		<input name="btnClearAll" class="button1" id="btnClearAll" type="button" value="Clear" />
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
</script>

</html>