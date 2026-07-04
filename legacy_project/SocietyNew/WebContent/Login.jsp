<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"
	autoFlush="true" session="true"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript" src="webapp/commonFiles/js/jquery-1.12.4.js"></script>
<script type="text/javascript" src="webapp/commonFiles/js/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="webapp/commonFiles/js/bootstrap.min.js"></script>
<script type="text/javascript" src='./checkScreens.js'></script>
<link rel="stylesheet" href="webapp/common/css/tabstyler.css" type="text/css">
<link rel="stylesheet" href="webapp/commonFiles/css/Login1.css">
<title>Society</title>
<style type="text/css">
 .download-box {
            position: absolute;
            right: 43px;
            top: 200px;
            width: 200px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 15px;
        }

        .download-box h4 {
            margin-top: 0;
            font-size: 16px;
            text-align: center;
            color: #333;
        }

        .download-box a {
            display: block;
            margin: 3px 0;
            padding: 6px;
            text-align: center;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .download-box a:hover {
            background-color: #0056b3;
        }
</style>
</head>

<%@include file="/webapp/commonFiles/ver/logoTitle"%>

<body >
	<!-- <marquee bgcolor='pink'  ><b><font color="white" style="font-weight: bolder; font-style:normal;font-size:17px;">WELCOME TO IT INFRASTRUCTURE INFORMATION MANAGEMENT SYSTEM APPLICATION</font></b></marquee> -->
	
	 <div class="main">
	<h3></h3>
	  <div class="download-box">
        <h4>Download Files</h4>
	        <a href="DownloadPdfServlet?file=AboutSPECCS.pdf" target="_blank">About SPECCS</a>
	        <a href="DownloadPdfServlet?file=Membershipform.pdf" target="_blank">Membership Form</a>
	        <a href="DownloadPdfServlet?file=SPECCSDepositsinterestrates.pdf" target="_blank">Deposits Interest Rate</a>
	        <a href="DownloadPdfServlet?file=Expressloanform.pdf" target="_blank">Express Loan Form</a>
	        <a href="DownloadPdfServlet?file=FDform.pdf" target="_blank">FD Form</a>
	        <a href="DownloadPdfServlet?file=FDloanreqform.pdf" target="_blank">FD Loan Request Form</a>
        	<a href="DownloadPdfServlet?file=RDform.pdf" target="_blank">RD Form</a> 
        	<a href="DownloadPdfServlet?file=FDCancellation.pdf" target="_blank">FD Cancellation Form</a>   
        	<a href="DownloadPdfServlet?file=RDcancellationform.pdf" target="_blank">RD Cancellation Form</a> 
        	<a href="DownloadPdfServlet?file=Membershipcancellation.pdf" target="_blank">Membership Cancellation Form</a>   
    </div>
    
	

 <!-- 	<div class="card"> -->
			<form action="checkLogin" style="width: 250px; margin-left: 680px;margin-top: 44px;" method="post">
				<input type="hidden" name="pagename" value="login" />

				<table align="left" style="margin-left: 400px">
					<tr>
						<td align="left" height="16"><b style="color: aliceblue">User Id</b></td>
						<td><input type="text" name="user" id="user" value="" maxlength="7" size="7" placeholder="username" style="text-transform: uppercase;text-align: center; width: 200px; border: 1px #88b1dd solid; height: 25px;border-radius: 8px;"></td>
					</tr>
					<tr>
						<td align="left" height="16"><b style="color: aliceblue">Password</b></td>
						<td><input type="password" name="pass" id="pass" value="" size="8" maxlength="10" placeholder="password" style="width: 200px;text-transform: uppercase;text-align: center; border: 1px #88b1dd solid; height: 25px;border-radius: 8px;">
						</td>
					</tr>
					<tr>
					<td ><button type="submit" name="submit">
						<!-- <img src="webapp/commonFiles/images/Login01.png" alt="Login" width="75px" height="35px"> -->
						Login</button>
					</td></tr>
					<tr>
						<%-- <%
String userValidation = (String) request.getAttribute("USERVALIDATION");
//System.out.println("userValidation - >> " +userValidation);
%>
						<script>
	var myVar = '<%=userValidation%>';
	//alert(myVar != 'null');
	if(myVar != null || myVar != 'null'){
//		alert(myVar);
		}
</script> --%>

						<td colspan="2"><span><%=request.getAttribute("USERVALIDATION") == null ? "" : request.getAttribute("USERVALIDATION")%></span></td>
						</tr><tr>
					</tr>
				</table>

				<!-- <table bgcolor='white' align="left" style="margin-left: 579px;">
					<tr>
						<td>
							<button type="submit" name="submit">
								<img src="webapp/commonFiles/images/Login01.png" alt="Login" width="75px" height="35px">
								Login
							</button>
						</td>
					</tr>
				</table> -->




			</form>
			
		<!-- </div> -->
	
		<marquee class="marquee"><h2>Welcome To SPECCS</h2></marquee>
		</div> 
<!-- Loging page in card -->
 <%-- <div class="container">
  <div class="row login-container">
      <div class="col-lg-5 col-md-7 col-sm-9">
        <div class="card">
          <div class="card-header">
            <h4 class="mb-0 text-white heading-card">User Login</h4>
          </div>
          <div class="card-body">
            <form id="submitForm" action="checkLogin" method="post" data-parsley-validate="" data-parsley-errors-messages-disabled="true" novalidate=""_lpchecked="1">
              <div class="form-group">
                <label for="username">User Code &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                <input align="right" type="text" class="form-control" name="user" id="user" value="" required=""  autocomplete="off" placeholder="Enter Employee Code">
              </div>
              <div class="form-group">
                <label for="password">Password</label>
                <input align="right" type="password" class="form-control password" name="pass" id="pass" value="" required=""  autocomplete="off" placeholder="Enter Password">
              </div>
              <button type="submit" class="btn btn-login">Login</button><br><br>
              <div class="text-center" style="color:red;text-align: center;">${USERVALIDATION}</div>
            </form>
          </div>
        </div>
      </div>
    </div>
</div> --%>
		<script type="text/javascript">







function noback() {
window.history.forward(); 
		
	} 
noback();
window.onload=noback;
window.onpageshow=function(evt){ if(evt.persisted) noback()}
window.onunload=function(){ void (0)}
function upperCase(data){
	var code=document.getElementById("user");
	//code=code
}

</script>
	
</body>
</html>

