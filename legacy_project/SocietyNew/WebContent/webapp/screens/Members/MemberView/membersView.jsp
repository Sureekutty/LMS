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


<script type="text/javascript" src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="./membersGrid.js"></script>
<script type="text/javascript" src="./membersView.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
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
</script>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>

	<div id="dialog1" name="dialog1" class="dialog1" style="margin-top:100%">
	<center><img alt="" src="loading.gif" height="50px" width="50px"></center>
	</div>
	<div>
		<%@include file="/../home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<div class="main" align="center">
		<br style="line-height: 60px;">
		<div>
			<br style="line-height: 5px;" />

			<table>
				<tr>
					<td><input type="hidden" id='LOGINMODE'
						value=<%=session.getAttribute("LOGINMODE") %>></td>
					<td><input type="hidden" id='userId'
						value=<%=session.getAttribute("EMPLOYEECODE") %>></td>
					<td><input type="hidden" id='timeStamp'
						value=<%=session.getAttribute("TIMESTAMP") %>></td>
					<td><input type="hidden" id='Role'
						value=<%=session.getAttribute("ROLE") %>></td>
					<td><input type="hidden" id='memempcode'></td>
				</tr>
			</table>
			<table align="center">
				<TR>
					<td align="right"><label>Search Member:</label> <input
						id="searchMember" type="text" placeholder="Search.."></td>
					<td width="50px" />
					<!-- <td><button type="button"  class="btn btn-primary"   id="all">ALL</button> </td><td width="25px"/> -->
					<td><button type="button" class="btn btn-primary"
							id="activeMem">ACTIVE MEMBERS</button></td>
					<td width="25px" />
					<td><button type="button" class="btn btn-primary"
							id="pendAppl">PENDING APPLICATIONS</button></td>
					<td width="25px" />
					<td><button type="button" class="btn btn-primary"
							id="cancAppl">CANCELED APPLICATIONS</button></td>
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
			<div align="center" id="containerGrid"></div>
			<div align="center" id="load"
				style="display: none; position: absolute; margin-top: -200px; margin-left: 650px">Please
				wait....</div>
		</div>
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
							<h3 class="modal-title">Members Details</h3>
						</div>
						<div class="modal-body">

							<table cellpadding="4" width="75%" id='viewDetails'
								align="center" border="1">
								<tr id='basicInfo'>
									<td><input type="hidden" id='accNo'></td>
									<td><input type="hidden" id='empCode'></td>
									<!-- <td>Bank Acc No. </td><td><span id="bankAccNo"></span> </td> -->
								</tr>
								<tr>
									<td colspan="2" align="center">Personal Information</td>
									<td colspan="2" align="center">Bank Information</td>
								</tr>
								<tr>
									<td>Employee:</td>
									<td><span id="employeeDetails"></span></td>
									<td>Bank Acc No.</td>
									<td><span id="bankAccNo"></span></td>
								</tr>

								<tr>
									<td>Basic Pay:</td>
									<td><span id="basicPay"></span></td>
									<td>IFSC Code:</td>
									<td><span id="ifscCode"></span></td>
								</tr>

								<tr>
									<td>Contact Info:</td>
									<td><span id="phoneNum"></span></td>
									<td>Bank Name:</td>
									<td><span id="bankName"></span></td>
								</tr>

								<tr>
									<td>DOB / Retirement Date:</td>
									<td><span id="dateOfBirthRetireDate"></span></td>
									<td>Bank Place:</td>
									<td><span id="bankPlace"></span></td>
								</tr>

								<tr>
									<td>Aadhar / Pan Number:</td>
									<td><span id="aadharNumber"></span></td>
								</tr>
							</table>
							<table cellpadding="4" width="75%" id='viewDetails'
								align="center" border="1">

								<tr>
									<td colspan="2" width="60%" align="center">Society
										Information</td>
									<!-- <td colspan="2" width="40%" align="center"> Nominee Information</td> -->
								</tr>

								<tr>
									<td>Membership Date:</td>
									<td><span id="membershipDate"></span></td>
									<!-- <td>Nominee Name: </td><td><span id="nomineeName"></span> </td> -->
								</tr>

								<tr>
									<td>Share Amount / No. Of Shares:</td>
									<td><span id="shares"></span></td>
									<!-- <td>Relation With Member: </td><td><span id="relationWithMem"></span> </td> -->
								</tr>
								<tr>
									<td>Membership Fee:</td>
									<td><span id="entranceAmount"></span></td>

								</tr>
								<tr>
									<td>Thrift Amount:</td>
									<td><span id="thriftAmount"></span></td>

								</tr>

							</table>

							<br style="line-height: 5px;">
							<table>
								<tr id='remarksTR'>
									<td>Remarks</td>
									<td><textarea id='Remarks' name="Remarks"
											style="width: 300px; height: 40px;"></textarea></td>

								</tr>

							</table>

							<br style="line-height: 5px;">
							<center>
								<input name="btnEdit" class="button1" id="btnEdit" type="button"
									VALUE="Edit" /> <input name="btnPrint" align="center"
									class="button1" id="btnPrint" type="button" VALUE="Print" /> <input
									name="btnApprove" align="center" class="button1"
									id="btnApprove" type="button" VALUE="Approve" />
								<!-- <input  name="btnMemship" align="center" class="button1" id="btnMemship" type="button"  VALUE="Membership Details" /> -->
								<!-- 	<input  name="btnCancel" align="center" class="button1" id="btnCancel" type="button"  VALUE="Cancel Membership" /> -->
							</center>
						</div>
						<div class="modal-footer">
							<button type="button" class="button1" id='closeButton'
								data-dismiss="modal">Close</button>
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
</html>