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
	src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript"
	src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>

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

<!-- chosen  plugin for select -->

<link href="../../../commonFiles/css/chosen.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript"
	src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../../screenFucntions.js"></script>
<script type="text/javascript" src="../Nominee/nominee.js"></script>
<script type="text/javascript"
	src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../Nominee/validate.js"></script>
<script type="text/javascript" src="../Nominee/Nomineegrid.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body>
	<div>
		<%@include file="/home1.html"%>
	</div>
	<div align="center">
		<%@include file="../../ScreenDetails/screenDetails.jsp"%>
	</div>

	<div class="main">
		<br style="line-height: 45px;">
		<div align="center">

			<br style="line-height: 35px;"> <input type="hidden"
				id='nomineeid'>
			<%String userempcode=(String)session.getAttribute("EMPLOYEECODE");

%>

			<input type="hidden" id='userid' name='userid' value=<%=userempcode%>>

			<table>

				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Member Code:</label>&nbsp;<select
						class="chosen-select" id='empcode'
						style='width: 390px; height: 28px;'
						data-placeholder="Select employee">
							<option value="Select"></option>
					</select></td>
				</tr>

				<tr>
					<td height=10px></td>
				</tr>

				<tr>
					<td colspan="20" align="left" style="border-bottom: 2px solid grey"><b>Nominee
							Details</b> <!-- <input  name="AddNominee" class="button1" id="AddNominee" type="button"  VALUE="AddNominee" onclick="dataview()"/> -->
						<a href='#' id='Addnominee' name='Addnominee' data-toggle='modal'
						data-target='#nomdiv'>AddNominee </a></td>
				</tr>


				<tr>
					<td colspan="20">
						<div class="main" style="margin-top: 5px;">
							<div id="Nomineecontainergrid"
								style="width: 1020px; height: 150px; margin-top: 10px; margin-right: auto; margin-left: auto;"></div>
						</div>
					</td>
				</tr>


				<!-- <tr>
<td align="left" >Nominee Name:&nbsp; </td>
<td><input type="text" id="nomineename" name="nomineeName" class="form-control" style="width:150px;"  maxlength="15" ></td>
</tr>


<tr><td height= 10px></td></tr>
<tr>
<td align="left" >Nominee DOB:&nbsp; </td>
<td><input type="text" id="nomineedob" name="nomineeDob" class="form-control" style="width:220px;"  maxlength="10" readonly="readonly"></td><td>&emsp;&emsp;</td>
<td align="left" >Effected To Date:&nbsp; </td>
<td><input type="text" id="effectedtodate" name="effectedToDate" class="form-control" style="width:220px;"  maxlength="10" readonly="readonly"></td>

</tr>

<tr><td height= 10px></td></tr>
				<tr >
			
					<td align="left">Relation Ship:&nbsp;</td>
					<td><select  class="chosen-select" id='relationship' style='width: 220px; height: 28px;' data-placeholder="Select Relationship">
							<option value=""></option>
							
							
						</select></td>
				</tr>
				
<tr><td height= 10px></td></tr>
				<tr >
					<td align="left">Gender:&nbsp;</td>
					<td><select  class="chosen-select" id='gender' style='width: 220px; height: 28px;' data-placeholder="select gender">
							<option value="Select"></option>
							<option id="male" value="MALE">MALE</option>
							<option id="female" value="FEMALE">FEMALE</option>
							<option id="others" value="Others">Others</option>
						</select></td>
				</tr>
				<tr><td height= 10px></td></tr>
				<tr >
					<td align="left">Status:&nbsp;</td>
					<td><select  class="chosen-select" id='status' style='width: 220px; height: 28px;' data-placeholder="Select Status">
							<option value="Select"></option>
							<option id="active" value="Active">Active</option>
							<option id="inactive" value="InActive">InActive</option>
						</select></td>
				</tr>
				<tr><td height= 10px></td></tr>
<tr><td align="left">Address <label style="color: red;">*</label>&nbsp;</td>
<td ><textarea type="text" class="form-control" id="nomAddress" style="width: 300px; height:80px; text-transform: uppercase;"  name="remarks"  maxlength="100" ></textarea></td>
</tr>



				
<tr><td height= 10px></td></tr>
<tr>
<td align="left" >Nominee RefNo:&nbsp;</td>
<td><input type="text" id="nomineerefno" name="nomineeRefNo" class="form-control" style="width:220px; text-transform: uppercase;" maxlength="10" '></td>
</tr>

 -->

			</table>

			<div class="modal fade" id="nomdiv" role="dialog">
				<div class="modal-dialog">


					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h3 class="modal-title">New Nominee</h3>
						</div>
						<div class="modal-body">
							<table>
								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">Name <label style="color: red;">*</label>&nbsp;
									</td>
									<td><input type="text" id="nomineeName" name="nomineeName"
										class="form-control"
										style="min-width: 200px; text-transform: uppercase;"
										maxlength="30"></td>
								</tr>

								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">Nominee DOB:&nbsp;</td>
									<td><input type="text" id="nomineedob" name="nomineeDob"
										class="form-control" style="width: 300px;" maxlength="10"
										readonly="readonly"></td>
									<td>&emsp;&emsp;</td>


								</tr>

								<tr>
									<td height=5px></td>
								</tr>
								<tr>

									<td align="left">Relation <label style="color: red;">*</label>&nbsp;
									</td>
									<td><select id='relation'
										style='min-width: 300px; height: 28px;'
										data-placeholder="Select Relationship">
											<option value="Select"></option>
											<option id="mother" value="mother">MOTHER</option>
											<option id="father" value="father">FATHER</option>
											<option id="son" value="son">SON</option>
											<option id="daughter" value="daughter">DAUGHTER</option>
											<option id="wife" value="wife">SPOUSE</option>
									</select></td>
								</tr>

								<tr>
									<td height=5px></td>
								</tr>
								<tr>
									<td align="left">Gender <label style="color: red;">*</label>&nbsp;
									</td>
									<td><select id='gender'
										style='min-width: 300px; height: 28px;'
										data-placeholder="select gender">
											<option value="Select"></option>
											<option id="male" value="MALE">MALE</option>
											<option id="female" value="FEMALE">FEMALE</option>

									</select></td>
								</tr>
								<tr>
									<td height=5px></td>
								</tr>
								<td align="left">Address <label style="color: red;">*</label>&nbsp;
								</td>
								<td><textarea type="text" class="form-control"
										id="nomAddress"
										style="width: 300px; height: 80px; text-transform: uppercase;"
										name="remarks" maxlength="250"></textarea></td>
								</tr>
							</table>
						</div>
						<div class="modal-footer">
							<button type="button" class="button1" id='nomaddButton'
								onclick="Addnominee()" data-dismiss="modal">Add</button>
							<button type="button" class="button1" id='closeButton'
								data-dismiss="modal">Close</button>
						</div>


					</div>
				</div>

			</div>
		</div>
	</div>
	<br style="line-height: 10px">
	<center>
		<input name="btnSave" class="button1" id="btnSave" type="button"
			onclick="btnsave()" VALUE="Save" /> <input name="btnClearAll"
			class="button1" id="btnClearAll" type="button" VALUE="Clear" />
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
    field: document.getElementById('nomineedob'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
}); 
 /* 
 var picker = new Pikaday({
	    field: document.getElementById('effectedtodate'),
	    format: 'DD/MM/YYYY',
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	}); 
 
 var picker = new Pikaday({
	    field: document.getElementById('durationfrommonth'),
	    format: 'DD/MM/YYYY',
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	}); 
 
 var picker = new Pikaday({
	    field: document.getElementById('durationtomonth'),
	    format: 'DD/MM/YYYY',
	    onSelect: function() {
	  console.log(this.getMoment().format('DD/MM/YYYY'));
	    }
	});  */
	
	
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








<%-- <%@page import="org.society.dao.GenericsDetailsDAO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
	pageEncoding="ISO-8859-1" import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*" autoFlush="true" session="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta content="0" http-equiv="expires">
<meta content="NO-CACHE" http-equiv="PRAGMA">
<meta content="NO-CACHE" http-equiv="CACHE-CONTROL">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
	
	<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
	<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css"/>


<!-- chosen  plugin for select -->

	<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css"/> 
	<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
	<script type="text/javascript" src="../../screenFucntions.js"></script>

<script type="text/javascript" src="../Nominee/nominee.js"></script>
<!-- <script type="text/javascript" src="../../screenFucntions.js"></script>
<script type="text/javascript" src="../Membership/setValues.js"></script>
<script type="text/javascript" src="../Membership/validate.js"></script> -->
<title>Co-Operative Society </title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<body >	
 <div>
 <%@include file="/../home1.html" %>
 </div>
 
<div class="main">
<div>
<br style="line-height: 7px;">
<div id="tabs" class="container"  align="center">
  
<div id = "nomineeDetails"  >

<table align="center" id = "nameFont" width="auto" border="1" bgcolor="pink">
<tr>
	<td align="right" width="180px">Employee Code:&nbsp; </td>
	
	<td  >
	  <select id='empcode' class="chosen-select" style='width: 300px;' >
			<option value="Select">Select User</option>
        </select>  
</td>
</tr>
<tr><td height="5px"/></tr>
<tr>
<td align="right" >Nominee :&nbsp;</td>
<td ><input type="text" id="nomineeName" name="nomineeName" placeHolder="relatives" class="form-control" style="width: 300px; text-transform: uppercase;" maxlength="25"></td>
</tr>
<tr><td height="5px"/></tr>
<tr>
<td align="right" >Gender:&nbsp;</td>
<td ><input type="text" id="Gender" name="Gender" class="form-control" style="width: 300px; text-transform: uppercase;" maxlength="25"></td>
</tr>
<tr><td height="5px"/></tr>
<tr>
<td align="right">Relationship With Mem:&nbsp; </td>
<!-- <td><input type="text" id="relationWithMember" name="relationWithMember" placeHolder="relatives" class="form-control" style="width: 300px; text-transform: uppercase;" maxlength="25"></td> -->
<td>
<select id= "typeOfRelation" style="width: 130px;">
	<option value="select">--select--</option>
	<option value="FATHER">Father</option>
	<option value="MOTHER">Mother</option>
	<option value="SON">Son</option>
	<option value="DAUGHTER">Daughter</option>
	<option value="other">Others</option>
</select>
<input type="text" id="relationWithMember" name="otherRealationship" width="120px;">
</td>
</tr>
<tr><td height="5px"/></tr>
<tr>
<td align="right" >Nominee DOB:&nbsp;</td>
<td ><input type="text" id="namineeDOB" name="namineeDOB" class="form-control" style="width: 300px; text-transform: uppercase;" maxlength="25"></td>
</tr>

<tr><td height="5px"/></tr>
<tr>
<td align="right" >Nominee Address:&nbsp;</td>
<td ><textarea type="text" id="namineeAddress" name="namineeAddress" class="form-control" style="width: 300px; height:60px; text-transform: uppercase;" ></textarea></td>
</tr>

</table>
</div>

<div>
<table align="center">
<tr>
<td align="right"></td>
<%!
String currDate = new SimpleDateFormat("dd/MM/yyyy").format(new Date());
%>
<td><input type="hidden" id="currDate" name="currDate" value=<%=currDate %> ></td>
</tr>
<tr>
</tr>

 </table>
</div>
 </div>
<br style="height: 20px;"> 
<center >
<input  name="btnSave" class="button1" id="btnSave" type="button"  VALUE="Save" />
<input  name="btnPrint" class="button1" id="btnPrint" type="button"  onclick="btnPrintClick();" VALUE="Print"  />
<input  name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="Clear"  />
</center>
</div>
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
</script>

	
</body>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css"/>

<script type="text/javascript">
var picker = new Pikaday({
    field: document.getElementById('membershipDate'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});
var picker = new Pikaday({
    field: document.getElementById('namineeDOB'),
    format: 'DD/MM/YYYY',
    onSelect: function() {
  console.log(this.getMoment().format('DD/MM/YYYY'));
    }
});


</script>
</html> --%>