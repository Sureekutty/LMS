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
<script type="text/javascript" src="../SocietyRules/SocietyRules.js"></script>


<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>


<title>Co-Operative Society</title>
</head>
<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<%request.getSession(false);
String userId=(String)session.getAttribute("EMPLOYEECODE");


%>
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

			<table align="center" id="nameFont" border="0">
				<tr>
				<tr>
					<td><label>Rules/Description:</label>&nbsp;&nbsp;</td>
					<td><select id='rulesDesc' name="rulesDesc"
						class="chosen-select" style='width: 300px;'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr>
					<td height=20px></td>
				</tr>
				<!-- 				<tr >
					<td align="left">Description:&nbsp;</td>
					<td><input type="text" id="description" name="description" class="form-control" style="width: 300px;"  maxlength="11" onkeypress='return numericKey(event)'></td>
				</tr>
		<tr><td height= 10px></td></tr>
	<tr> -->
				<tr>
					<td align="right"><label>Value:</label>&nbsp;</td>
					<td><input type="text" id="value" name="value"
						class="form-control" style="width: 300px;" maxlength="11"
						onkeypress='return numericKey(event)'></td>
				</tr>





			</table>
		</div>
	</div>
	<input type="hidden" id="userId" name="userId" value=<%=userId %>>
	<br style="line-height: 25px">

	<center>

		<button type="button" class="button1" id="btnEdit" name="btnEdit">Edit</button>
		<button type="button" class="button1" id="btnUpdate" name="btnUpdate">Update</button>
		<!-- <button type="button" class="btn" id="btnClear" name="btnClear">Clear</button> -->

	</center>

	<script type="text/javascript">
function onback(){
	window.history.back();
}


var config = {
		'.chosen-select' : {},
		'.chosen-select-deselect'  : {allow_single_deselect:true},
		'.chosen-select-no-single' : {disable_search_threshold:6},
		'.chosen-select-no-results': {no_results_text:'No results  found!'},
		'.chosen-select-width': {width:"95%"},
		'.chosen-select-height':{height:"120%"}
		}
		for (var selector in config) {
		$(selector).chosen(config[selector]);
		}
</script>

</body>


</html>













