<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.society.util.DataBaseConnectionForNewDB"%>
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


<script type="text/javascript" src="../../../commonFiles/js/jquery-1.8.3.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>

<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../MiscellaneousPayments/MiscellaneousPayments.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>


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
<%
Connection con=null;
CallableStatement stmt = null;
ResultSet rs=null;
String empCode =(String) session.getAttribute("EMPLOYEECODE");


try{
String query="SELECT * FROM speccs.Members WHERE MemAccNo='M0000' AND MemEmpCode='SP00000'";
con = DataBaseConnectionForNewDB.getConnectionForSyBase();
stmt = con.prepareCall(query);

rs=stmt.executeQuery();


if(con!=null){
				 con.close();
				}
         }catch(Exception e){
				System.out.println("  EXCEPTION     "+e);
				e.printStackTrace();
				if(con!=null){
					 con.close();
					}
			
			}

			
%>

	<div class="main">
		<br style="line-height: 30px;">
		<div align="center">
			<br style="line-height: 35px;">
			<table>
				<tr><td height=10px></td></tr>
				<tr>
					<td><label>Member Account Number:</label></td>
					<td><select id='empCode' class="chosen-select" style='width: 350px; height: 28px;' data-placeholder='Select Member'>
							<option value=""></option>
					</select></td>
				</tr>
				<tr><td height=10px></td></tr>
				<tr>
					<td align="left"><label>Purpose :</label>&nbsp;</td>
					<td><input type="text" id="purpose" name="purpose" class="form-control" style="width: 150px;" ></td>
				</tr>


				<tr> <td height=10px></td> </tr>
				<tr>
					<td align="left"><label> Date:</label>&nbsp;</td>
					<td><input type="text" id="date" name="Date" class="form-control" style="width: 220px;" maxlength="10" readonly="readonly"></td>
					<td>&emsp;&emsp;</td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Amount:</label>&nbsp;</td>
					<td><input type="text" id="amnt" name="amnt" maxlength="10" onkeypress='return numericKey(event)'></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Cheque Number:</label>&nbsp;</td>
					<td><input type="text" id="chequeNo" name="chequeNo" ></td>
				</tr>
				<tr>
					<td height=10px></td>
				</tr>
				<tr>
					<td align="left"><label>Remarks:</label>&nbsp;</td>
					<td><textarea type="text" class="form-control" id="remarks" style="width: 300px; height: 50px; text-transform: uppercase;" name="remarks" maxlength="250"></textarea></td>
				</tr>

				<tr><td height=10px></td></tr>
				
				<tr>
					<td align="left"><label>Payment Number:</label>&nbsp;</td>
					<td><span id='depositNumber' style="color: red;"></span></td>
				</tr>
			</table>
		</div>
	</div>
	<br style="line-height: 10px">
	<center>
		 <input name="btnSubmit" class="button1" id="btnSubmit" type="button" VALUE="SUBMIT" />
		 <input name="btnClearAll" class="button1" id="btnClearAll" type="button" VALUE="CLEAR" /> 
		 
	</center>

	<script type="text/javascript">
function onback(){
	window.history.back();
}
</script>
</body>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

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