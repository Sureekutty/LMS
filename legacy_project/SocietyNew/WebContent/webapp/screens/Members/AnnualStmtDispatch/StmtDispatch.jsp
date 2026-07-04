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

<script type="text/javascript"	src="../../../commonFiles/js/jquery-1.8.3.js"></script>
<script type="text/javascript"	src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"	src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>

<script type="text/javascript"	src="../../../commonFiles/js/bootstrap.min.js"></script>
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"	type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet"	type="text/css" />

<script type="text/javascript"	src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript"	src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet"	type="text/css" />

<script type="text/javascript"	src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet"	type="text/css" />
<script type="text/javascript"	src="../AnnualStmtDispatch/StmtDispatch.js"></script>
<script type="text/javascript"	src="../AnnualStmtDispatch/gridoptions.js"></script>

<title>Co-Operative Society - Annual Statement mail dispatch</title>
</head>
  <%	Calendar calendar = Calendar.getInstance();
		int currentMonth=calendar.get(Calendar.MONTH),currentYear=calendar.get(Calendar.YEAR);
		int cyStart,cyEnd;
		int pyStart,pyEnd;
		int nyStart,nyEnd;
		if(currentMonth>=Calendar.APRIL){
			pyStart=currentYear-1;
			pyEnd=currentYear;
			cyStart=currentYear;
			cyEnd=currentYear+1;
			nyStart=currentYear+1;
			nyEnd=currentYear+2;
		}
		else{
			pyStart=currentYear-2;
			pyEnd=currentYear-1;
			cyStart=currentYear-1;
			cyEnd=currentYear;
			nyStart=currentYear;
			nyEnd=currentYear+1;
		}
%>  
<style type="text/css">
.modal {display: 'none';position: absolute;visibility: hidden;margin-top: 100%;margin-left: 100%;}
.modal img{position: relative;top: 50%; left: 50%;}

</style>
<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body >
<div><%@include file="/../home1.html"%></div>
<form id="frm1" name='frm1'>
<input type="hidden" name="req" id="req" value="uploadFile">
<table  align="center" id="nameFont" name="nameFont" width="auto" style="margin-top:50px; border-spacing: 10px;" bgcolor="pink">

<tr>
<td >
<label>Financial Year:</label></td>
<td>
<select id='financeyr' name='financeyr' class="chosen-select" data-placeholder='Select financial year...' style='width: 300px; height: 28px;' >
<option value=""></option>
<option value='<%= pyStart%>'><%=pyStart %>-<%=pyEnd %></option>
<option value='<%= cyStart%>'><%=cyStart %>-<%=cyEnd %></option>
<option value='<%= nyStart%>'><%=nyStart %>-<%=nyEnd %></option>


</select>
</td>
</tr>
<tr>
<td ><label>New File(TXT):</label></td>
<td><input type="file" id="xfile" name="xfile" accept=".xlsx,.xls">
<center><input type="button" id="btnUpload" name="btnUpload" value="Upload" onclick="upload()"></center></td>
</tr>
<tr>
<td ><label>Uploaded File:&nbsp;</label></td>
<td>
<input type="text" name="uploadedfile" id="uploadedfile" size=25>
</td>
</tr>
<tr>
<td>
<label>Entity  </label></td>
<td>
<select id="entity" name="entity" class="chosen-select" data-placeholder='Select Entities...' style='width: 300px; height: 28px;' >
<option value=""></option>
</select>
</td>
</tr>

<tr>
<td colspan="2" align="center">
<div id="container" style="width: 700px; height: 250px;" ></div>
<div id="load" style="border: 1px solid black; position: absolute; padding:10px;visibility: hidden; margin-left: 300px; margin-top: -150px"></div>

</td></tr> 

</table>

<center>
<input name="btnBulkSend" class="button1" id="btnBulkSend" type="button" VALUE="Save" />
<input name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear" onclick="btnClear()"/>
</center>
</form>


<script type="text/javascript">
function onback(){
	window.history.back();
}
</script>

</body>
<script type="text/javascript"	src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript"	src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css"	rel="stylesheet" type="text/css" />


<script>
var picker = new Pikaday({
    field: document.getElementById('date'),
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