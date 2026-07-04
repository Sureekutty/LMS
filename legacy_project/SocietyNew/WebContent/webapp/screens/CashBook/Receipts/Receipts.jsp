
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

<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />

<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../Receipts/Receipts.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../Receipts/validate.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>


<title>Co-Operative Society</title>
</head>
<%@include file="../../../commonFiles/ver/logotitleforInnerScreens"%>
<body onload='checkEmp()'>
	<input type="hidden" id='receiptno'	value=<%=request.getParameter("receiptno")%>>
	<input type="hidden" id='memAccno'	value=<%=request.getParameter("memAccno")%>>
	<input type="hidden" id='purposecode' value=<%=request.getParameter("purposecode")%>>
	<input type="hidden" id='currentDate' value=<%=new SimpleDateFormat("dd/MM/yyyy").format(new Date())%>>
	<div>
		<%@include file="/../home1.html"%>
	</div>

	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<br style="line-height: 30px;">
	<div class="main">

		<br style="line-height: 5rem">


		<div align="center">

			<table align="center" id="nameFont">
				<tr>
				<tr>
					<td align="right"><label>Member Code:</label>&nbsp;</td>
					<td><select id='memCode' name="memCode" data-placeholder='Select Member' class="chosen-select" style='width: 300px;'>
							<option></option>
					</select></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td align="right"><label>Purpose:</label>&nbsp;</td>
					<td><select name="purpose" id='purpose' data-placeholder='Select purpose' class="chosen-select" style='width: 300px;'>
							<option></option>
					</select></td>
				</tr>

				<tr class="hideappno">
					<td height=10px></td>
				</tr>
				<tr >
					<td align="right"><label>App Number:</label>&nbsp;</td>
					<td>
						 <select name="appNumber" id="appNumber" data-placeholder='Select App Number' class="chosen-select" style='width: 300px;'>
							<option value=""></option></select> 
					</td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td align="right"><label>Previous Amount:</label>&nbsp;</td>
					<td><input type="text" id="prvAmount" name="prvAmount" class="form-control" style="width: 220px;" maxlength="10"
						onkeypress='return numericKey(event)' disabled="disabled"></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td align="right"><label>Mode of payment:</label>&nbsp;</td>
					<td><select name="modeOfPay" class="chosen-select"
						id='modeOfPay' style='width: 150px;'>
							<option value=""></option>
							<option value="Cash">Account Transfer</option> <!-- Changed by pn on 24/01/2025 from cash to account transfer  -->
							<option value="Cheque">Cheque</option>
					</select></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td align="right"><label>Receipt Date:</label>&nbsp;</td>
					<td><input type="text" id="recieptDate" name="recieptDate"
						class="form-control" style="width: 220px;" maxlength="10"
						readonly="readonly"></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr id='monthfield'>
					<td align="right"><label>Month:</label></td>
					<td><select id='recieptMonth' name="recieptMonth" class="chosen-select" style='width: 120px;' data-placeholder="Month">
							<option value=""></option>
					</select> &nbsp;&nbsp;&nbsp;<label>Year:</label>
					<SELECT id='recieptyear' name="recieptyear" class="chosen-select" style='width: 90px;' data-placeholder="Year">
							<Option value=""></option>
					</SELECT>
					<td>
				</tr>

				<!-- <tr><td height= 10px></td></tr>
<tr id='monthfield'>
<td align="right" >Month:&nbsp; </td>
<td><input type="text" id="recieptMonth" name="recieptMonth" class="form-control" style="width:220px;"  maxlength="10" readonly="readonly" ></td>
</tr> -->

				<tr>
					<td height=10px></td>
				</tr>
				<!-- <tr id="sharesTr"><td  >No. of Shares &nbsp;</td><td> <input type="text" class="form-control" id="NoOfShares" name="NoOfShares"  maxlength="10" style="width: 100px;"></td></tr>
<tr><td height= 10px></td></tr> -->
				<tr>
					<td align="right"><label>Amount:</label>&nbsp;</td>
					<td><input type="text" id="Amount" name="Amount"
						class="form-control" style="width: 220px;" maxlength="10"
						onkeypress='return numericKey(event)'></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr id='remarksTR'>
					<td align="right"><label>Remarks:</label>&nbsp;</td>
					<td><textarea id='Remarks' name="Remarks"
							style="width: 300px; height: 50px;" disabled="true"></textarea></td>
				</tr>

				<tr>
					<td align="right"><label>Receipt No:</label>&nbsp;</td>
					<td><span color="red" id="ReceiptNo"></span></td>
				</tr>
			</table>
		</div>
	</div>

	<br style="line-height: 10px">
	<center>
		<input name="btnSave" class="button1" id="SaveBtn" type="button" VALUE="Save" /> 
		<input name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear" /> 
		<a href="#" id="Link"></a>
	</center>

	<script type="text/javascript">
		function onback() {
			window.history.back();
		}
	</script>

</body>
<script type="text/javascript" src="../../../commonFiles/js/common.js"></script>

</html>