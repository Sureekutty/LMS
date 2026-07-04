<%@page import="java.sql.Connection"%>
<%@page import="org.society.util.DataBaseConnectionForNewDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.CallableStatement"%>
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

<link href="../../../commonFiles/js/bootstrap.min.css" rel="stylesheet"	type="text/css" />
<link href="../../../commonFiles/css/soc_styler.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/css/chosen.css" rel="stylesheet" type="text/css" />
<link href="../../../commonFiles/js/datepicker/pikaday.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../../../commonFiles/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/chosen.jquery.js"></script>
<script type="text/javascript" src="../GeneralLedger/GeneralLedger.js"></script>
<script type="text/javascript" src="../../ScreenDetails/screenDetails.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/moment.js"></script>
<script type="text/javascript" src="../../../commonFiles/js/datepicker/pikaday.js"></script>

<title>Co-Operative Society</title>
</head>

<%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%>
<%
Connection con=DataBaseConnectionForNewDB.getConnectionForSyBase();;
ArrayList<String> payCode=new ArrayList<String>();
ArrayList<String> desc=new ArrayList<String>();
CallableStatement cstmt=null;
ResultSet rset=null;
try {        
	 cstmt=con.prepareCall("SELECT * FROM speccs.TransactionType WHERE ScreenType=?");
	 cstmt.setString(1, "Y");
	 rset=cstmt.executeQuery();
	 while(rset.next()){
		 payCode.add(rset.getString("PayCode"));
		 desc.add(rset.getString("Description"));
	 }
}catch (Exception e){
	e.printStackTrace();
}finally{
	  con.close();
}

  %>
<body>

	<div><%@include file="/../home1.html"%></div>

	<div align="center"><%@include file="../../ScreenDetails/screenDetails.jsp"%></div>

	<br style="line-height: 30px;">
	<br style="line-height: 30px;">
	<div class="main">
		<br style="line-height: 35px">
		<div align="center">
		
		<table width="630px" class=MsoTableGrid cellspacing=2 cellpadding=2 style='border-collapse: collapse; border: none; margin-left: auto; margin-right: auto;'>
		<thead>
			<tr>
				<td align="left" colspan="20"><label>Purpose Code:</label>&nbsp;
				<select id='purCode' name="purCode" class="chosen-select" style='width: 300px;' data-placeholder='Select Purpose code'>
				<option value=""></option>
				 <%Iterator<String> i1=payCode.iterator();
				 Iterator<String> i2 = desc.iterator();
				 while(i1.hasNext() && i2.hasNext()){
					 String code=i1.next();
					 String description = i2.next();%>
				<option value="<%=code%>"><%=description%></option>
				<%} %>
				</select>
				</td>
			</tr>
		</thead>
		<tr><td height="20px" /></tr>
		<thead align="center">
					<tr>
						<td align="left" colspan="20" style="border-bottom: 2px solid grey">
						<b>General Ledger</b></td>
					</tr>
				</thead>
				<tr><td height="20px" /></tr>
				<tr>
					<td align="right">Date Interval &nbsp;&nbsp; From :</td>
					<td><input type="text" id="recefromDate" name="recefromDate" class="form-control" style="width: 190px;" maxlength="10" readonly="readonly"></td>
					<td align="left">To :</td>
					<td><input type="text" id="recetoDate" name="recetoDate" class="form-control" style="width: 190px;" maxlength="10" readonly="readonly"></td>
				</tr>
				<tr><td height="30px"></td></tr>
			<tr>
			<td align="center"></td>
				<td align="center"><center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="Printbtn" class="button1" id="Printbtn" type="button" VALUE="Print" />
				</center></td>
			</tr>		
		</table>
		
		<br>				
		</div>
	</div>
	

	<script type="text/javascript">
function onback(){
	window.history.back();
}
</script>

</body>
<script type="text/javascript" src="../../../commonFiles/js/common.js"></script>

</html>