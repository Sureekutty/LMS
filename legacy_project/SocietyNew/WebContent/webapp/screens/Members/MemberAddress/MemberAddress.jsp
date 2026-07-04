
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
	src="../../../commonFiles/grid/gt_grid_all.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/grid/gt_msg_en.js"></script>
<link href="../../../commonFiles/grid/gt_grid.css" rel="stylesheet"
	type="text/css" />


<script type="text/javascript"
	src="../../../commonFiles/js/chosen.jquery.js"></script>
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript" src="../MemberAddress/MemberAddress.js"></script>
<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>
<!--  <script type="text/javascript" src="../MemberAddress/validateAddress.js"></script>  -->
<script type="text/javascript" src="../MemberAddress/Addressgrid.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<%-- <%
System.out.print(new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
%> --%>
	<input type="hidden" id="currDate" name="currDate"
		value=<%=new SimpleDateFormat("dd/MM/yyyy").format(new Date()) %>>
	<div>
		<%@include file="/../home1.html"%>
	</div>

	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>


	<div class="main">
		<br style="line-height: 40px;">

		<div align="center">
			<br style="line-height: 35px;">
			<table align="center" id="nameFont" width="auto" border="0" bgcolor="pink">


				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td><label>Member Account Number:</label><select id='empCode'
						class="chosen-select" data-placeholder='Select User'
						style='width: 390px; height: 28px;'>
							<option value=" "></option>
					</select></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<!-- <td align="right" >Date:&nbsp; </td>
<td><input type="text" id="date" name="date" class="form-control" style="width:220px;"  maxlength="10" readonly="readonly" ></td>       
    -->

				</tr>

				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td colspan="20" align="left" style="border-bottom: 2px solid grey"><b>Member
							Address</b> <!-- <input  name="btnAddAddress" class="button1" id="btnAddAddress" type="button"  VALUE="AddAddress" /> -->
						<a href='#' id='Addaddress' name='Addaddress' data-toggle='modal'
						data-target='#addressdiv'>AddAddress </a></td>
				</tr>

				<tr>
					<td colspan="20">

						<div class="main1" style="margin-top: 5px;">
							<div id="Addresscontainer"
								style="width: 1175px; height: 200px; margin-top: 10px; margin-right: auto; margin-left: auto;"></div>
						</div>
					</td>
				</tr>









				<!-- 
<tr>
<td align="right" >Address1:&nbsp; </td>
<td><input type="text" id="address1" name="address1" class="form-control" style="width:220px; text-transform: uppercase;"  maxlength="15" ></td>
</tr>
<tr><td height= 10px></td></tr>
<tr>
<td align="right" >Address2:&nbsp;</td>
<td><input type="text" id="address2" name="address2" class="form-control" style="width:220px; text-transform: uppercase;" maxlength="15" ></td>
</tr>

<tr><td height= 10px></td></tr>
<tr >
			
<td align="right">City:&nbsp;</td>
<td><input type="text" id= 'city' name = 'city' class="form-control" style="width:220px; text-transform: uppercase;" maxlength="15" ></td>
	</tr>
	<tr><td height= 10px></td></tr>
	<tr>
						
<td align="right" >District:&nbsp;</td>
<td><input type="text" id="district" name="district" class="form-control" style="width:220px; text-transform: uppercase;" maxlength="15" ></td>

						
</tr>
				
<tr><td height= 10px></td></tr>
<tr>
<td align="right">Pincode:&nbsp;</td>
<td ><input type="text" class="form-control" id="pincode" name="pincode" style="width: 220px;text-transform: uppercase;"  maxlength="6S" onkeypress='return numericKey(event)'></td>
</tr>

<tr><td height= 10px></td></tr>
<tr>
<td align="right">State:&nbsp;</td>
<td><input type="text" id="state" name="state" class="form-control" style="width:220px; text-transform: uppercase;" maxlength="25" ></td>
</tr>
<tr>
<tr><td height= 10px></td></tr>
<td align="right">Remarks:&nbsp;</td>
<td ><textarea type="text" class="form-control" id="remarks" style="width: 300px; height:50px; text-transform: uppercase;"  name="remarks"  maxlength="250" ></textarea></td>
</tr>
 -->
			</table>

			<div class="modal fade" id="addressdiv" role="dialog">
				<div class="modal-dialog">


					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h3 class="modal-title">New Address</h3>
						</div>
						<div class="modal-body">
							<table>
								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">Address1 <label style="color: red;">*</label>&nbsp;
									</td>
									<td><input type="text" id="address1" name="address1"
										class="form-control"
										style="min-width: 200px; text-transform: uppercase;"></td>
								</tr>


								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">Address2 <label style="color: red;">*</label>:&nbsp;
									</td>
									<td><input type="text" id="address2" name="address2"
										class="form-control"
										style="min-width: 200px; text-transform: uppercase;"></td>
									<td>&emsp;&emsp;</td>

								</tr>

								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">City <label style="color: red;">*</label>&nbsp;
									</td>
									<td><input type="text" id="city" name="city"
										class="form-control"
										style="min-width: 200px; text-transform: uppercase;"></td>
									<td>&emsp;&emsp;</td>

								</tr>

								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">District <label style="color: red;">*</label>&nbsp;
									</td>
									<td><input type="text" id="Distr" name="Distr"
										class="form-control"
										style="min-width: 200px; text-transform: uppercase;"></td>
									<td>&emsp;&emsp;</td>

								</tr>

								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">Pincode <label style="color: red;">*</label>&nbsp;
									</td>
									<td><input type="text" id="pincode" name="pincode"
										class="form-control" style="min-width: 200px;"></td>
									<td>&emsp;&emsp;</td>

								</tr>

								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">State <label style="color: red;">*</label>&nbsp;
									</td>
									<td><input type="text" id="state" name="state"
										class="form-control"
										style="min-width: 200px; text-transform: uppercase;"></td>
									<td>&emsp;&emsp;</td>

								</tr>
								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">Remarks <label style="color: red;">*</label>&nbsp;
									</td>
									<td><input type="text" id="Remarks" name="Remarks"
										class="form-control"
										style="min-width: 200px; text-transform: uppercase;"></td>
									<td>&emsp;&emsp;</td>

								</tr>
							</table>
						</div>
						<div class="modal-footer">
							<button type="button" class="button1" id='addButton'
								onclick="Addaddress()" data-dismiss="modal">Add</button>
							<button type="button" class="button1" id='closeButton'
								data-dismiss="modal">Close</button>
						</div>


					</div>
				</div>

			</div>

		</div>
	</div>
	<br style="line-height: 35px;">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button"
			VALUE="Save" /> <input name="btnClearAll" class="button1"
			id="btnClearAll" type="button" VALUE="Clear" />

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