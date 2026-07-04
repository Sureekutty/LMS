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
	src="../../../commonFiles/js/jquery-1.8.3.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>

<script type="text/javascript"
	src="../../../commonFiles/js/bootstrap.min.js"></script>
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"
	type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet"
	type="text/css" />

<link href="../../../commonFiles/css/chosen.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript"
	src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../Interests/Interest.js"></script>

<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>

<script type="text/javascript" src="../Interests/validate.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<div>
		<%@include file="/home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>


	<div class="main">
		<br style="line-height: 30px;">
		<div align="center">
			<br style="line-height: 35px;">
			<table>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Interest:</label>&nbsp;</td>
					<td><select class="chosen-select" id='interest'
						style='width: 260px; height: 28px;'
						data-placeholder='Select Interest'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Rate Of Interest:</label>&nbsp;</td>
					<td><input type="text" id="rateofinterest"
						name="rateOfInterest" class="form-control" style="width: 150px;"
						maxlength="10" onkeypress='return numericKey(event)'></td>
				</tr>


				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Effected From Date:</label>&nbsp;</td>
					<td><input type="text" id="effectedfromdate"
						name="effectedFromDate" class="form-control" style="width: 220px;"
						maxlength="10" readonly="readonly"></td>
					<td>&emsp;&emsp;</td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Interest Calculation Term:</label>&nbsp;</td>
					<td><input type="text" id="interestterm"></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Type Of Interest:</label>&nbsp;</td>
					<td><input type="text" id="typeofinterest"></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr id="Duration">
					<td align="left"><label>Duration From Month:</label>&nbsp;</td>
					<td><input type="text" id="durationfrommonth"
						name="durationFromMonth" class="form-control"
						style="width: 220px;" maxlength="10"
						onkeypress='return numericKey(event)'></td>
					<td>&emsp;&emsp;</td>
					<td align="left"><label>Duration To Month:</label>&nbsp;</td>
					<td><input type="text" id="durationtomonth"
						name="durationToMonth" class="form-control" style="width: 220px;"
						maxlength="10" onkeypress='return numericKey(event)'></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr id="MinMaxAmount">
					<td align="left"><label>Minimum Amount:</label>&nbsp;</td>
					<td><input type="text" id="minAmount" name="minAmount"
						class="form-control"
						style="width: 220px; text-transform: uppercase;" maxlength="10"
						onkeypress='return numericKey(event)'></td>
					<td>&emsp;&emsp;</td>
					<td align="left"><label>Maximum Amount:</label>&nbsp;</td>
					<td><input type="text" id="maxAmount" name="maxAmount"
						class="form-control"
						style="width: 220px; text-transform: uppercase;" maxlength="10"
						onkeypress='return numericKey(event)'></td>
					<td>&emsp;<a href="#" id="link"></a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<br style="line-height: 10px">
	<center>
		<input name="btnEdit" class="button1" id="btnEdit" type="button" VALUE="Edit" />
		 <input name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear" /> 
		 <input name="btnUpdate" class="button1" id="btnUpdate" type="button" VALUE="Update" />
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
	    field: document.getElementById('effectedfromdate'),
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