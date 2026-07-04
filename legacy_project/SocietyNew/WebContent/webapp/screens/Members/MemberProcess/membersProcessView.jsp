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

<script type="text/javascript" src="../../../commonFiles/js/jquery-1.12.4.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="./membersProcessGrid.js"></script>
<script type="text/javascript" src="./membersProcessView.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
<div>
<%@include file="/../home1.html"%>
</div>
<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>
	<br >
	<br> 
<div class="main">

<br style="line-height: 5px;" /> 

<table align="center" cellspacing=3 cellpadding=3>
<tr>
<td><input type="hidden" id='LOGINMODE'	value=<%=session.getAttribute("LOGINMODE") %>></td>
<td><input type="hidden" id='userId' value=<%=session.getAttribute("EMPLOYEECODE") %>></td>
<td><input type="hidden" id='timeStamp'	value=<%=session.getAttribute("TIMESTAMP") %>></td>
<td><input type="hidden" id="deposittotal">
<input type="hidden" id="loantotal"> 
<input type="hidden" id="depositno"> 
<input type="hidden" id="memAccNo"></td>
</tr> 

<tr>
<td><label>Date:</label></td><td><input type="text" id='memSettDate' class="form-control" readonly="readonly" style="width: 150px" ></td>
<td><label>Member Acc No</label></td>
<td><select id="memCode" name="memCode" class="chosen-select" style='width: 300px;'>
<option value=""></option></select></td>
</tr>
</table>
<table align="center" width="auto" >
<tr style="display:flex">
<td align="center" >
<h3 align="center">Deposit</h3>
<br style="line-height: 10px;">
<div align="center" id="containerGrid" ></div>
</td>
<td align="right" >
<h3 align="center">Surities</h3>
<br style="line-height: 10px;">
<div align="right" id="surity"></div>
</td>
</tr>
<tr >
<td >
<h3 style="margin-left:180px">Liabilities</h3>
<div style="display:flex"><div align="center" id="containerGrid1"></div>
<div style="display:flex">


</div></div></td>
</tr>

<tr>
<td align="left" width="250px"><b>Settlement Amount:&nbsp;&nbsp;&nbsp;&nbsp;(RS)&nbsp;</b><span id="SettlementAmount"></span>
<button style="margin-left:300px" type="button" class="btn btn-primary" id="memSettlement" onclick="onClick()" >Member Settlement</button></td>

</tr>
</table>


<!-- 	<div class="container">		Trigger the modal with a button	Modal				
<div class="modal fade" id="myModal" role="dialog">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal">&times;</button>
<h3 class="modal-title">Deposits Details</h3>
</div>
<div class="modal-body">
<table><tr><td>Member Acc No &emsp;</td><td ><b><span id="memAccNo"></span></b></td></tr></table>
<table cellpadding="2" width="50%" id='viewDetails'	align="center" border="1">
<tr>
<td>Deposite No/ Date of Deposite</td><td><span id="DepositDetails"></span></td>
</tr>

<tr>
<td>Subscription Amount(Rs)</td><td><span id="ValueInRs"></span></td>
</tr>

<tr>
<td>Deposit Type </td><td><span id="DepositType"></span></td>
</tr>

<tr>
<td>Open Date</td><td><span id="OpenDate"></span></td>
</tr>

<tr>
<td>Duration </td><td><span id="Duration"></span></td>
</tr>

<tr>
<td>Maturity Amount</td><td><span id="MaturityAmount"></span></td>
</tr>
</table>
</div>

<div class="modal-footer">
<button type="button" class="button1" id='closeButton' data-dismiss="modal">Close</button>
</div>
</div>
</div>
</div>
</div> -->
</div>


	<script type="text/javascript">

function onback(){
	window.history.back();
}
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
		
var picker = new Pikaday({
    field: document.getElementById('memSettDate'),
    format: 'DD/MM/YYYY',
    //minDate: new Date(),
    maxDate: new Date(),
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});		

</script>

</body>

</html>