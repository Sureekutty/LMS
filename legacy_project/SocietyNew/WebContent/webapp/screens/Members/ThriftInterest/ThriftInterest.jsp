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
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="./ThriftInterest.js"></script>



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
			<td align="right"><label style="margin-right: 90px;">Date Interval  &nbsp;&nbsp;&nbsp;&nbsp;: </label> From :</td>
			<td><input type="text" id="fromDate" name="fromDate" class="form-control" style="width: 190px;" maxlength="10" readonly="readonly"></td>
			<td style="width: 15px;"></td>
			<td >To :</td>
			<td><input type="text" id="toDate" name="toDate" class="form-control" style="width: 190px;" maxlength="10" readonly="readonly"></td>
		</tr>
			<tr><td style="height: 10px;"></td></tr>
			<tr>
		<td><label>Interest Rate &nbsp;&nbsp;&nbsp;&nbsp;:</label></td>
		<td><input type="text" name="intRate" id="intRate"></td>
		</tr>
		</table>
	</div>
	<br style="line-height: 20px">
	<center>
		<!-- <input name="btnSave" class="button1" id="btnSave" type="button" value="Process" /> -->
		 <input  name="btnPrint" class="button1" id="btnPrint" type="button"  VALUE="Print"  /> 
		 <input  name="btnPrint" class="button1" id="thriftPoll" type="button"  VALUE="Thrift Poll"  /> 
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
    field: document.getElementById('fromDate'),
    format: 'DD/MM/YYYY',
    //minDate: new Date(),
    maxDate: new Date(),
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});

var picker = new Pikaday({
    field: document.getElementById('toDate'),
    format: 'DD/MM/YYYY',
    //minDate: new Date(),
    maxDate: new Date(),
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});
</script>

</html>