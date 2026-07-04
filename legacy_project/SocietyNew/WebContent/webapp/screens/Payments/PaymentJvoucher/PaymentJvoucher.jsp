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


<script type="text/javascript"
	src="../PaymentJvoucher/PaymentJvoucher.js"></script>
<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../PaymentJvoucher/validate.js"></script>

<title>Co-Operative Society</title>


<style type="text/css">
input.largecheck {
	width: 50px;
	hight: 50px;
}
</style>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>

	<%-- <%
System.out.print(new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
%> --%>
	<input type="hidden" id="currDate" name="currDate"
		value=<%=new SimpleDateFormat("MM/dd/yyyy").format(new Date()) %>>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<div class="main">
		<br style="line-height: 35px;">


		<div align="center">
			<br style="line-height: 35px;"> <br style="line-height: 5px;" />
			<table hidden>
				<tr>
					<td><input type="hidden" id='Role'
						value=<%=session.getAttribute("ROLE") %>></td>
					<td><input type="hidden" id='amount'></td>

				</tr>
			</table>
			<table id="nameFont" width="600px" class=MsoTableGrid cellspacing=2
				cellpadding=2
				style='border-collapse: collapse; border: none; margin-left: auto; margin-right: auto;'>
				<tr id="jvonum">
					<td align="right"><b>Journal Voucher No
							&nbsp;&nbsp;&nbsp;:</td>
					<td><input type="text" id="jvoucherno" class="form-control"
						style='width: 240px' ; disabled="disabled"></b></td>
				</tr>

				<tr id="jvonumcombo">
					<td align="right"><b>Journal Voucher No
							&nbsp;&nbsp;&nbsp;:</td>
					<td><select class="chosen-select" id='jvoucombo'
						style='width: 240px; height: 28px;'
						data-placeholder='Select JournalVoucher Number'>
							<option value=""></option>
					</select></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr id="jvodate">
					<td align="right"><b>Journal voucher Date &nbsp;:</td>
					<td><input type="text" id="jvoucherDate" name="jvoucherDate"
						class="form-control" style="width: 240px;" maxlength="10"
						readonly="readonly"></b></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="right"><b>Journal voucher BillNo:</td>
					<td><select class="chosen-select" id='bills'
						style='width: 240px; height: 28px;' data-placeholder='Select Bill'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr id="billinfo">
					<td align="right"><label>Bill Information:</label>&nbsp;</td>
					<td><textarea type="text" class="form-control" id="Info"
							style="width: 390px; height: 140px;" name="Info"
							disabled="disabled"></textarea></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td align="right"><label>Remarks:</label>&nbsp;</td>
					<td><textarea type="text" class="form-control" id="remarks"
							style="width: 390px; height: 50px; text-transform: uppercase;"
							name="remarks" maxlength="250"></textarea></td>
				</tr>
			</table>

		</div>
	</div>
	<br style="line-height: 10px">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button"
			VALUE="Save" /> <input name="btnSave" class="button1"
			id="btnApprove" type="button" VALUE="Approve" /> <input
			name="btnClearAll" class="button1" id="btnClearAll" type="button"
			VALUE="Clear" />

	</center>
	<center>
		<br />
		<tr>
			<td height=25px></td>
		</tr>
		<tr>
			<label id="succalert" style="color: red;" />
		</tr>
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
    field: document.getElementById('jvoucherDate'),
    format: 'MM/DD/YYYY',
    onSelect: function() {
    console.log(this.getMoment().format('MM/DD/YYYY'));
    }
});

/* var picker = new Pikaday({
    field: document.getElementById('chequeDate'),
    format: 'MM/DD/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('MM/DD/YYYY'));
    }
}); */

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