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
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet" type="text/css" />

<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../MonthlyRecoveryResponse/MonthlyRecoveryResponse.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css"	rel="stylesheet" type="text/css" />
<script type="text/javascript" src="./MonthlyrecoveryResponseGrid.js"></script>

<title>Co-Operative Society</title>
<style type="text/css">
.ui-datepicker-calender {
	display: none;
}
</style>

</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body onload='checkFileAPI()'>
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
		<form name="TXT" method="post" action="MonthlyRecoveryResponse" enctype="multipart/form-data">
			<input type="hidden" id='Role' value=<%=session.getAttribute("ROLE") %>>
			<div class="modal fade" id="formatdiv" role="dialog">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h3 class="modal-title">File Data Format</h3>
						</div>
						<div class="modal-body"></div>
						<ol>
							<li>File First line is Sal code</li>
							<li>Data Reading from Second line</li>
							<li>Data should be in EmployeeCode : amount Format</li>
							<li>No need to Enter , and ; at end of the line</li>
							<li>Do Not Enter spaces at end of the data</li>
							<li>Below Format Should be maintain before uploading the file</li>
						</ol>
						Sal Code :XXXX <br> EmployeeCode : XXXXX<br>
						EmployeeCode : XXXXX<br> EmployeeCode : XXXXX<br>
						EmployeeCode : XXXXX
						<div class="modal-footer">

							<button type="button" class="button1" id='closeButton' data-dismiss="modal">Close</button>
						</div>


					</div>
				</div>

			</div>
<% Calendar calendar = Calendar.getInstance();				
calendar.add(Calendar.MONTH,-1);
calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));			
DateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
String lastDate = sdf.format(calendar.getTime());
	
%>

			<table align="center">

				<tr>
					<td align="right"><b>Processing Date:</b></td>
					<td><label id="monthproces" type="date"><%=lastDate%></label></td>

				</tr>
				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td align="right"><label>Purpose:</label></td>
					<td><select id='Purpose' name="Purpose" class="chosen-select" style='width: 320px;' data-placeholder="Select Purpose">
							<option value=""></option>
					</select></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td align="right"><label>File Upload(TXT):</label></td>
					<td><input type="file" value="Upload File" id="browse" name="browse" accept=".txt"></td>

					<td><a href='#' id='Fileformat' name='Fileformat' data-toggle='modal' data-target='#formatdiv'>File Format View</a>
					</td>
				</tr>


			</table>
		</form>

		<br style="line-height: 10px;">
		<div align="center" id="containerGrid"></div>
	</div>
	<table align="center">

		<tr>
			<td><input name="btnUpdate" class="button1" id="btnUpdate" type="button" VALUE="Update" /></td>
			<td width="10px"></td>
			<td><input name="btnApprove" class="button1" id="btnApprove" type="button" VALUE="Approve" hidden /></td>
			<td width="10px"></td>		
			<td><input name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear" /></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;<label id="updateinfo" style="color: red"></label>
			</td>
	</table>
<div id="dialog1" name="dialog1" class="dialog1" style="margin-top:100%">
	<center><img alt="" src="loading.gif" height="50px" width="50px"></center>
	</div>
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