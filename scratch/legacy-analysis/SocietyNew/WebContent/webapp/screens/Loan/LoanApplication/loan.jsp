<%-- <%@page import="org.society.dao.GenericsDetailsDAO"%> --%>
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
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../LoanApplication/loan.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<!-- <script type="text/javascript" src="../LoanApplication/setValues.js"></script> -->
<script type="text/javascript" src="../LoanApplication/validation.js"></script>

<title>Co-Operative Society</title>

</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body onload='checkEmp()'>

	<input type="hidden" id='Loanappno' value=<%=request.getParameter("Loanappno")%>>
	<input type="hidden" id='thriftavailbleamount' value=<%=request.getParameter("thriftavailbleamount")%>>
	<input type="hidden" id='thriftdudamt' value=<%=request.getParameter("thriftdudamt")%>>
	<input type="hidden" id='empcode' value=<%=request.getParameter("empcode")%>>
	<input type="hidden" id='loantypee' value=<%=request.getParameter("loantypee")%>>
	<input type="hidden" id='memAccNo' value=<%=request.getParameter("memAccNo")%>>
	<input type="hidden" id='loanamount' value=<%=request.getParameter("loanamount")%>>
	<input type="hidden" id='surity1' value=<%=request.getParameter("surity1")%>>
	<input type="hidden" id='surity2' value=<%=request.getParameter("surity2")%>>
	<input type="hidden" id='surity3' value=<%=request.getParameter("surity3")%>>
	<input type="hidden" id='fdnum' value=<%=request.getParameter("funidnum")%>>
	<input type="hidden" id='currentDate' value=<%=new SimpleDateFormat("dd/MM/yyyy").format(new Date())%>>
	<input type="hidden" id="MinLoanEligibilyAmount" />
	<input type="hidden" id="RuleValue1" />
	<input type="hidden" id="prevloanamount" />
	<input type="hidden" id="prvAmt" />
	<input type="hidden" id="retdDate" />

	<div>

		<%@include file="/../home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<div class="main" id='main'></div>
	<br style="line-height: 40px;">



	<div>
		<!-- <table align="center" id = "nameFont" id = 'memberDetails' border="1" width="1000px;">

</table> -->


		<table id="nameFont" width="1000px" class=MsoTableGrid cellspacing=2 cellpadding=2 style='border-collapse: collapse; border: none; margin-left: auto; margin-right: auto;'>
			<thead align="center">
				<tr>
					<td align="left" colspan="20"><b>Member Code:</b>&nbsp;
					<select id='empCode' name="empCode" class="chosen-select" style='width: 390px;' data-placeholder='Select Member'>
					<option></option>
					</select></td>
				</tr>
				<tr>
				<td align="left" colspan="20" style="border-bottom: 2px solid grey">
				<b>Loan	Application No&nbsp;&nbsp;&nbsp;:<label id="LoanAppNo"></label></b>
				</td>
				</tr>
			</thead>


			<tr>
				<td align="center" colspan="20" style="border-bottom: 2px solid grey"><b>Member Details</b></td>
			</tr>
			<tr><td height="10px" /></tr>
			<tr>
				<td width="170px" ><b>Basic Pay:&nbsp;</b></td>
				<td><input id="basicPay" style="width: 160px;font-weight:bold" disabled="disabled" /></td>

				<td align="right" width="450px"><b>No Share/Amount:&nbsp;</b></td>
				<td><input id="shareAmount" style="width: 160px;font-weight:bold" disabled="disabled" /></td>

			</tr>
			<tr><td height="5px" /></tr>
			<tr>
				<td width="150px" ><b>Type of Loan:</b></td>
				<td align="left"><select id='loanType' name="loanType" class="chosen-select" style='width: 160px;' data-placeholder='Select Loan Type'>
				<option></option>
				</select></td>
				<td align="right"><b>Eligibility Amount:&nbsp;</b></td>
				<td><input id="loanEligibleAmount" style="width: 160px;font-weight:bold" disabled="disabled"/></td>
			</tr>
			
			<tr><td height="5px" /></tr>
			
			<tr>
				<td width="200px" >Previous Loan Balance: &nbsp;</td>
				<td><input id="prvLoan" style="width: 160px;font-weight:bold" disabled="disabled"/></td>
				<td align="right">Loan Balance:&nbsp;</td>
				<td><input id="loanBalance" style="width: 160px;font-weight:bold" disabled="disabled"/></td>
			</tr>
			<tr><td height="5px" /></tr>
			<tr>
				<td >Interest:</td>
				<td><input id="interest" style="width: 160px;font-weight:bold" disabled="disabled"/></td>

				<td align="right" width="450px">Loan App Date:</td>
				<td align="left"><input type="text" id='loanApplicationDate' class="form-control" readonly="readonly"></td>
			</tr>
			<tr><td height="5px" /></tr>
			<tr>
			<td colspan="20" style="border-bottom: 2px solid grey"></td>
			</tr>

			<tr>
				<td align="center" colspan="20" style="border-bottom: 2px solid grey"><b>Loan	Details </b></td>
			</tr>
			
			<tr><td height="5px" /></tr>

			<tr id='FDLoanDiv'>
				<td >&nbsp;&nbsp;&nbsp;FD Numbers :&nbsp;</td>
				<td><select id='FDNumbers' class="chosen-select" style='width: 160px;font-weight:bold' data-placeholder='Select FD No.'>
				<option value=""></option>
				</select></td>

				<td align="right" style="width: 400px;">FD Amount:&nbsp;</td>
				<td><input type="text" id='FDAmount' name='FDAmount' style='width: 160px; font-weight:bold' disabled="disabled" /></td>
			</tr>
			
			<tr><td height="5px" /></tr>
			
			<tr>
				<td >Applied Loan Amount:&nbsp;</td>
				<td><input type="text" id='loanAmount' name='loanAmount' maxlength="7" style='width: 160px;' onkeypress="return numericKey(event)"/></td>	<!-- onchange="changeLoan()" --> 
				<td id="hfd" align="right" style="width: 500px;">No. of Loan Installment :&nbsp;</td>
				<td id="hfd1"><input type="text" id='installmentNumber' name='installmentNumber' maxlength="7" style='width: 160px;' /></td>
			</tr>
			
			<tr><td height="5px" /></tr>
			
			<tr>
				<td  id="hfd2">Cheque Amount :&nbsp;</td>
				<td id="hfd3"><input type="text" id='chequeAmount' name='chequeAmount' maxlength="7" style='width: 160px;' disabled="disabled"/></td>
				<td id="hfd4" align="right" style="width: 500px;">Monthly Principle Installment Amount:&nbsp;</td>
				<td id="hfd5"><input id='intsallmentAmount' style='width: 160px;' disabled="disabled"></input></td>
			</tr>
			<!-- <tr>

<td align="right" id="hfd">Cheque Amount :</td>
<td ><input type="hidden" id="chequeAmount" name="" class="form-control" style="width: 300px;"'></td>

<td id="hfd2" align="right">Monthly Installment Amount:&nbsp;</td>
<td  id="hfd3"><span id = 'intsallmentAmount' ></span></td>

</tr>  -->
		</table>
	</div>
	<br style="line-height: 5px;">
	<!-- <div id= 'FDLoanDiv'>
<table id = "nameFont" width="1000px" class=MsoTableGrid  cellspacing=2 cellpadding=2 style='border-collapse:collapse;border:none; margin-left: auto; margin-right: auto;'>


<tr>
<td align="right" >&nbsp;&nbsp;&nbsp;FD Numbers :&nbsp;</td>
	<td><select id='FDNumbers' class="chosen-select" style="width: 160px;" data-placeholder='Select FD No.'>
			<option value=""></option>
        </select> </td>
	
<td align="right" style="width:400px;">FD Amount:&nbsp;</td>
<td width="200px" ><span id = 'FDAmount'> </span></td>
</tr>
</table>

</div> -->
	<br>

	<div id='loanDetails'>
		<table id="nameFont" width="1000px" class=MsoTableGrid cellspacing=2 cellpadding=2 style='border-collapse: collapse; border: none; margin-left: auto; margin-right: auto;'>

			<tr>
				<td>Thrift Available Amount: </td><!-- <span id = 'thrfiAvailableAmount' ></span> -->
					<td ><input type="text" id='thrfiAvailableAmount' name='thrfiAvailableAmount' style='margin-right: 10rem;width: 160px;' disabled="disabled" />
				</td>

				<td align="right" >Thrift Deducted Amount	:&nbsp;&nbsp;</td>
				<!-- <td width="200px" ><span id = 'thriftDedAmount'> </span></td> -->
				<td ><input type="text" id='thriftDedAmount' name='thriftDedAmount' style='width: 160px;' disabled="disabled" /></td>
			</tr>
			
			<tr><td height="5px" /></tr>

			<tr>
				<td >Loan Purpose&nbsp;:</td>
					<td><textarea id='loanPuropse' name='loanPuropse' style="height: 30px; width: 160px;"></textarea>
				</td>

				<td align="right" >Prv Loan Details (Loan No./Outstanding):</td>
				<td ><input type="text" id='prvLoanNum' name='prvLoanNum' style='width: 160px;' disabled="disabled" /></td>
				<!-- <td><span id = 'prvLoanNum' name= 'prvLoanNum' style="width: 200px;" ></span></td> -->
			</tr>
		</table>
		<div id="suretyDetails">
			<table id="nameFont" width="1000px" class=MsoTableGrid cellspacing=2 cellpadding=2 style='border-collapse: collapse; border: none; margin-left: auto; margin-right: auto;'>
				<tr><td height="5px" /></tr>
				<tr><td colspan="20" style="border-bottom: 2px solid grey"></td></tr>
				<tr>
					<td align="center" colspan="4" style="border-bottom: 2px solid grey"><label>Surety	Details</label></td>
				</tr>
				
				<tr><td height="5px" /></tr>
				
				<tr>
					<td align="right" colspan="2" width="40%">Surety Details 1:&nbsp;</td>
					<td colspan="2"><select id='surityDetails1'	name="surityDetails1" class="chosen-select" style='width: 340px;' data-placeholder='Select Surety1.'>
						<option></option>
					</select></td>
				</tr>
				
				<tr><td height="5px" /></tr>
				
				<tr>
					<td align="right" colspan="2">Surety Details 2:&nbsp;</td>
					<td colspan="2"><select id='surityDetails2'	name="surityDetails2" class="chosen-select" style='width: 340px;' data-placeholder='Select Surety2.'>
							<option></option>
					</select></td>
				</tr>
				<tr><td height="5px" /></tr>
				<tr>
					<td align="right" colspan="2">Surety Details 3:&nbsp;</td>
					<td colspan="2"><select id='surityDetails3' name="surityDetails3" class="chosen-select" style='width: 340px;' data-placeholder='Select Surety3.'>
						<option></option>
					</select></td>
				</tr>
				<tr><td height="5px" /></tr>
			</table>
		</div>

		<%-- <div id = 'loanDetails'>

<%@include file="../LoanApplication/loans/LTLLoan.html" %>
</div> --%>
	</div>

	<table align="center">
		<tr id='expressSurety'>
			<td align="right" colspan="2" width="40%">Surety Details :&nbsp;</td>
			<td colspan="2"><select id='surityDetail'	name="surityDetail" class="chosen-select" style='width: 340px;' data-placeholder='Select Surety1.'>
				<option></option>
			</select></td>
		</tr>
		<tr><td height="5px" /></tr>
		<tr id='remarksTR'>
			<td align="right" colspan="2">Remarks:&nbsp;</td>
			<td><textarea id='Remarks' name="Remarks" style="width: 338px; height: 40px;"></textarea></td>
		</tr>
	</table>
	
	<br>
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button" VALUE="Save" />
		<!-- <input  name="btnPrint" class="button1" id="btnPrint" type="button"  onclick="btnPrintClick();" VALUE="Print"  /> -->
		<input name="btnClearAll" class="button1" id="btnClearAll"	type="button" VALUE="Clear" />
	</center>
</body>

<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

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
    field: document.getElementById('loanApplicationDate'),
    format: 'DD/MM/YYYY',
    //minDate: new Date(),
    maxDate: new Date(),
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});

function numericKey(e)
{
	var evt_mozila=window.event||e;
	if(evt_mozila)
	{
		var charcode = evt_mozila.keyCode||evt_mozila.which;
		if((charcode>31) && (charcode<46) || (charcode>57))
		{
			alert("enter number!!");
			return false;
		}
		return true;
	}
}

</script>

<script type="text/javascript" src="../../../commonFiles/js/common.js"></script>
</html>