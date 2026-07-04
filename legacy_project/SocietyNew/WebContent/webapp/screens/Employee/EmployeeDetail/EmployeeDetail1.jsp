<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"
	autoFlush="true" session="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Buddy</title>
    <link href="../EmployeeDetail/employee.css" rel="stylesheet" type="text/css" />
     <script src="employee.js" defer></script> 
     <link rel="stylesheet" type="text/css" href="../../../commonFiles/js/bootstrap.min.css"></link>
     <script type="text/javascript" src="../../../commonFiles/js/bootstrap.min.js"></script>

</head>
 <%@include file="/webapp/commonFiles/ver/logotitleforInnerScreens"%> 
<body>

    
    <div class="container-fluid">
    <div class="container">
    <div align="right"><a class="btn btn-danger" href="/SocietyNew/Logout.jsp"> Logout</a></div>
        <div class="header">
        <h1>WELCOME TO SOCIETY</h1>
            <h1>Member Info</h1>
            <p>Get your information here</p>
        </div>

        <div class="loan-options">
            <div class="loan-option">
                <h3>Thrift Info</h3>
                <p>Flexible funds for your needs, from emergencies to big purchases.</p>
            </div>
            <div class="loan-option">
                <h3>Loan Info</h3>
                <p>Affordable financing to make your dream home a reality.</p>
                <ul class="badge-container">
                <li><span class="badge bg-primary"> LTL Loan</span></li>
                <li><span class="badge bg-primary"> Express Loan</span></li>               
                </ul>
            </div>
            <div class="loan-option">
                <h3>Deposit Info</h3>
                <p>Empower your business with funding tailored to your growth plans.</p>
                   <ul>
                <li><span class="badge">Fixed Deposit</span></li>
                <li><span class="badge">Recurrent Deposit</span></li>               
                </ul>
            </div>
            <!-- <div class="loan-option">
                <h3>Auto Loan</h3>
                <p>Drive your dream car with easy and low-interest auto loans.</p>
            </div> -->
        </div>
		</div>
    </div>

</body>
</html>