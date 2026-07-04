
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"
	autoFlush="true" session="true"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="/SocietyNew/css/tabstyler.css"
	type="text/css">
<link rel="stylesheet" href="/SocietyNew/css/pikaday.css">
<link rel="stylesheet" type="text/css"
	href="/SocietyNew/css/grid/gt_grid.css" />
<link rel="stylesheet" type="text/css"
	href="/SocietyNew/css/navigation.css">

<script type="text/javascript" src="./js/jquery.min.js"></script>
<script type="text/javascript" src="./js/ajax.js"></script>
<script type="text/javascript" src="./js/hallTkt.js"></script>
<script type="text/javascript" src="./js/excelupload.js"></script>
<script type="text/javascript" src="./js/jszip.js"></script>
<script type="text/javascript" src="./js/xlsx.full.min.js"></script>



<script type="text/javascript">
window.history.forward();
function noBack()
{	
	window.history.forward();
}
</script>

<title>SocietyNew</title>

</head>

<body bgcolor="#a1d2ff" onload="noBack();"
	onpageshow="if (event.persisted) noBack();" onunload="">
	<div class="main">

		<form name="hall" method="post" action="ExcelImport"
			enctype="multipart/form-data">
			<center>
				<h3>
					<u>Files Upload</u><br>
				</h3>
				<br>

				<table style="margin-left: -20%">
					<td>Upload Excel File</td>
					<td><input type="file" value="Upload File" id="browse"
						name="browse">&nbsp;&nbsp;&nbsp;</td>
				</table>
				<br>
				<table align="center">
					<tr>
						<td align="center">
							<div id="container" style="width: 730px; height: 200px;"></div>
						</td>
					</tr>
				</table>
				<table style="width: 750px; height: 70px;">
					<tr>
						<td style="width: 800px" bgcolor="#ffffff" align="center"><label
							id="nodata" style="color: red;"></label><br> <label
							id="text" style="color: green;"></label><br> <label
							id="ackfile" style="color: green;"></label></td>
					</tr>
				</table>


			</center>
			<br>


		</form>
		<center>
			<table>
				<tr>
					<td><input type="submit" id="send" value="send" name="send">
					</td>

				</tr>
			</table>
		</center>
	</div>

	<script src="/SocietyNew/css/moment.js"></script>
	<script src="/SocietyNew/css/pikaday.js"></script>
	<script type="text/javascript" src="/SocietyNew/js/dynamictime.js"></script>

	<script>

	var picker = new Pikaday({
		field : document.getElementById('date'),
		format : 'DD.MM.YYYY',
		onSelect : function() {
			console.log(this.getMoment().format('DD MMMM YYYY'));
		}
	});
</script>

</body>

</html>