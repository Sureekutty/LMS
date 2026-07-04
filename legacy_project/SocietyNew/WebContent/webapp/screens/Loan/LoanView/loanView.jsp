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
<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"	type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="./loanView.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>

<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css"	rel="stylesheet" type="text/css" />

<script type="text/javascript" src="./loanViewGrid.js"></script>
<title>Co-Operative Society</title>
<script>
$(document).ready(function(){
  $("#searchMember").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    //$("#containerGrid").find('tr').not(':first').filter(function() {
      $("#containerGrid tr").not(':first').filter(function(){  
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});
$(function() {
	
	$('#dialog').dialog({
		autoOpen: false,
	dialogClass: 'no-close',
	closeOnEscape:false,
	   position:['CENTER','top+100'],
		show: 'blind',
		hide: 'explode',
		height: 250,
		width: 450,
       modal:true,
	buttons: [{
	id: "close-button",
	text: "OK",
	click: function() {
$(this).dialog('close');

}
}],
open: function() {
	//alert("vinayjing");
	setTimeout(function(){
	$("#close-button").focus();
	},500);
}

});
	});


</script>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
<div>
<%@include file="/../home1.html"%>
</div>
<div id="dialog1" name="dialog1" class="dialog1" style="margin-top:100%">
	<center><img alt="" src="loading.gif" height="50px" width="50px"></center>
	</div>
<div align="center">
<%@include file="../../ScreenDetails/screenDetails.jsp"%>
</div>
<div id="dialog" title="Message From Server &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"></div>
<div class="main">

<br style="line-height: 45px">
<div>
<br style="line-height: 5px;" />

<table hidden>
<tr>
<td><input type="hidden" id='LOGINMODE'	value=<%=session.getAttribute("LOGINMODE") %>></td>
<td><input type="hidden" id='userId' value=<%=session.getAttribute("EMPLOYEECODE") %>></td>
<td><input type="hidden" id='timeStamp'	value=<%=session.getAttribute("TIMESTAMP") %>></td>
<td><input type="hidden" id='Role' value=<%=session.getAttribute("ROLE") %>></td>
</tr>
</table>

<table align="center">
<TR>
<td align="right"><label>Search Loan:</label>
<input id="searchMember" type="text" placeholder="Search.."></td>
<td width="40px" />
<!-- <td><button type="button"  class="btn btn-primary"   id="all">ALL</button> </td><td width="25px"/> -->
<td><button type="button" class="btn btn-primary" id="FRESH">FRESH LOAN</button></td>
<td width="25px" />
<td><button type="button" class="btn btn-primary" id="SANCTION">SANCTIONED LOAN</button></td>
<td width="25px" />
<td><button type="button" class="btn btn-primary" id="RELINIT">RELEASEINITIATE LOAN</button></td>
<td width="25px" />
<td><button type="button" class="btn btn-primary" id="RELEASE">RELEASED	LOAN</button></td>
<td width="25px" />
<td><button type="button" class="btn btn-primary" id="REJECT">REJECTED REQUEST</button></td>
<td width="25px" />
<td><button type="button" class="btn btn-primary" id="SETTLED">SETTLED LOAN</button></td>
<td width="25px" />
<td width="25px" />
<TD hidden><label>Sort By</label> <select>
		<option value="">--select--</option>
		<option value="memcode">EMPCODE</option>
		<option value="name">NAME</option>
</select></TD>
</TR>
</table>

<br style="line-height: 10px;">
<div align="center" id="containerGrid" onload='getChequedAmount()'></div>
<div align="center" id="load" style="display: none; position: absolute; margin-top: -200px; margin-left: 650px">Please wait....</div></div>
		
<table class="hideTable" hidden>
<tr align=center>
<td>Remarks/Cheque Number: <input type="text" id="chequeNumber" name="chequeNumber" placeholder="Enter remarks..."></input></td>
</tr>

<tr height="10px"></tr>

<tr align="center">
<td width="10px">Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
<input type="date" id="idate" name="idate" ></input></td>
</tr>

<tr height="10px"></tr>

<tr align=center>
<td width="10px">Total Amount&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;
<input type="text" id="totalAmount" name="totalAmount" placeholder="Total Amount"></input></td>
</tr>

<tr height="10px"></tr>

<tr align="right">
<td width="800px"></td>
<td><button type="button" class="btn btn-primary"  id="PRINT" name="PRINT">PRINT</button></td>
<td width="10px"></td>
<td><button type="button" class="btn btn-primary" id="approvalRelease" name="approvalRelease" disabled="true">RELEASE APPROVAL</button></td>
</tr>
</table>
<!-- just statrts  -->
<div class="container">
<!-- Trigger the modal with a button -->
<!-- Modal -->
<div class="modal fade" id="myModal" role="dialog">
<div class="modal-dialog">

		<!-- Modal content-->		
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal">&times;</button>
<h3 class="modal-title">Loan Details</h3>
</div>

<div class="modal-body">

<table cellpadding="4" id='loanDetails' width="75%"	align="center">
<tr>
<td><input type="hidden" id='memAccNo1' /></td>
<td><input type="hidden" id='emplcode' /></td>
<td><input type="hidden" id='loantype' /></td>
<td><input type="hidden" id='surity1'></td>
<td><input type="hidden" id='surity2'></td>
<td><input type="hidden" id='surity3'></td>
<td><input type="hidden" id='funidnum'></td>
<td><input type="hidden" id='loanstatus'></td>
<td><input type="hidden" id='bankAccNo'></td>
</tr>

<tr>
<td colspan="2"	style="font-size: large; text-decoration: underline;">
<span id='TypeOfLoan'></span></td>
</tr>

<tr>
<td>Member:</td>
<td><a href="#"><span id="employeeDetails"></span></a></td>
</tr>

<tr>
<td>Application Date:</td>
<td><span id="LoanAppDate"></span></td>
</tr>

<tr>
<td>No. Of Installment:</td>
<td><span id="NoOfInst"></span></td>
</tr>

<tr class="hideRefnotFD">
<td>Reference number(FD):</td>
<td><span id='RefNumber'></span></td>
</tr>

<tr>
<td>No. Of Shares:</td>
<td><span id="NoOfShares"></span></td>
</tr>

<!-- <tr id= 'dateupdate'>
<td>Date</td>
<td><input type="text" id="updationDate" name="updationDate" class="form-control" style="width:220px;"  maxlength="10" readonly="readonly" ></td>
</tr> -->

<tr id='sanctionDetail1'>
<td>Sanctioned Amt:</td>
<td><span id="LoanSanctionAmt"></span></td>
</tr>

<tr id='sanctionDetail1'>
<td>Sanctioned Date:</td>
<td><span id='LoanSanctionDate'></span></td>
</tr>

<tr id='sanctionDetail3'>
<td>Thrift Available Amount:</td>
<td><span id='ThriftBalance'></span></td>
</tr>

<tr id='sanctionDetail3'>
<td>Thrift Deducted Amount:</td>
<td><span id="ThriftDedAmt"></span></td>
</tr>

<tr>
<td>Monthly Installement paid:</td>
<td><span id='monthlyInsPaid'></span></td>
</tr>

<tr>
<td>Cheque Amount:</td>
<td><span id='LoanAmount'></span></td>
</tr>

<tr>
<td>Interest Rate:</td>
<td><span id='Interest'></span></td>
</tr>

<tr>
<td>Share Amount:</td>
<td><span id='ShareAmount'></span></td>
</tr>

<tr id='recove'>
<td>Recovery From Date:</td>
<td><input type="text" id="recFromDate" name="recFromDate" class="form-control" style="width: 200px;" maxlength="10" readonly="readonly"></td>
</tr>

<tr>
<td height="5px" />
</tr>

<tr id='remarksTR'>
<td>Remarks/Cheque number:</td>
<td><textarea id='Remarks' name="Remarks" style="width: 300px; height: 40px;"></textarea></td>
</tr>

</table>


<br />
<div align="left" style="padding-left: 13%">
<input name="btnedit" align="center" class="button1" id="btnedit" type="button" VALUE="Edit" /> 
<input name="btnSanction" align="center" class="button1" id="btnSanction" type="button" VALUE="Sanction" /> 
<input name="btnReject" align="center" class="button1" id="btnReject" type="button" VALUE="Reject" /> 
<input name="btnPrint" align="center" class="button1" id="btnPrint" type="button" VALUE="Print" />
 <input name="btnRelInitiative" align="center" class="button1" id="btnRelInitiate" type="button" VALUE="Release Initiate" />  
 <input name="btnApproveRel" align="center" class="button1" id="btnApproveRel" type="button" VALUE="Approve Release" />
</div>

<div class="modal-footer">
<button type="button" class="button1" id='closeButton' data-dismiss="modal">Close</button>
</div>

</div>
</div>
</div>
</div>
<!-- endsss  -->
</div>
<script type="text/javascript">

function onback(){
	window.history.back();
}

</script>
</body>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css"	rel="stylesheet" type="text/css" />
<script>
var picker = new Pikaday({
    field: document.getElementById('updationDate'),
    format: 'DD/MM/YYYY',
  //minDate: new Date(),
    maxDate: new Date(),
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