
<%@page import="java.sql.CallableStatement"%>
<%@page import="org.society.util.DataBaseConnectionForNewDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"
	autoFlush="true" session="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Detail</title>
    <link href="webapp/screens/Employee/EmployeeDetail/employee.css" rel="stylesheet" type="text/css" />
    <link href="webapp/commonFiles/employee/bootstrap.min.css" rel="stylesheet" type="text/css" />    
    <script type="text/javascript" src="webapp/commonFiles/js/jquery-3.5.1.min.js"></script>
    <script type="text/javascript" src="webapp/commonFiles/employee/bootstrap.min.js"></script>
    <script type="text/javascript" src="webapp/screens/Employee/EmployeeDetail/employee.js" ></script> 

	<style type="text/css">
	.modal {
		top: 200px;
		overflow: visible;
	}
	.fade {
		opacity: 1;
	}
	body {
            position: unset;
            width: 100%;
            height: 80vh;
            overflow: hidden;            
        }
    body::before {
          content: "";
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: url('webapp/commonFiles/images/44.jpg') no-repeat center center;
          background-size: cover;
          z-index: -1;
      }
    h4{
    	color: #72d572;
    } 
    .modal-dialog {
		 	width: 630px;
		 	margin: 30px auto;
		}
	.badge{
			cursor: pointer;
		}
	.btn-align{
		display: flex;
	}
	.anchor-wrapper {
	 	margin: 18px 315px 0 288px;
	 }
		 
	</style>
	</head>
 <%@include file="webapp/commonFiles/ver/logoTitle2"%> 
<%

Calendar cal = java.util.Calendar.getInstance();
int month = cal.get(Calendar.MONTH); // 0 = January
int day = cal.get(Calendar.DAY_OF_MONTH);
int year = cal.get(Calendar.YEAR);

boolean showLink = false;
int count=0;
String fromDate="05/01/"+year;
String toDate="06/30/"+year;

if ((month == 4 && day >= 1) || (month == 5 && day <= 30) || (month > 4 && month < 5)) {
    showLink = true;
}

 	Connection con=null;
 CallableStatement stmt = null;
 ResultSet rs=null;
 String empCode =(String) session.getAttribute("EMPLOYEECODE");
 try{
 String query="Select count(*) as counts from speccs.ThriftIntPoll where MemEmpCode='"+empCode+"' AND convert(DATE,OptedDate) BETWEEN '"+fromDate+"' AND '"+toDate+"'";
 
 con = DataBaseConnectionForNewDB.getConnectionForSyBase();
 stmt = con.prepareCall(query);
 
 rs=stmt.executeQuery();

 if(rs.next())
	 count=rs.getInt("counts");
 
 %>
<body>
	<div class="container-fluid">
    <div class="container">
    
	    <div class="btn-align">
		 	<a class="btn btn-primary " id="apply" name="apply"  > Apply Loan</a>
			<% if(showLink && count==0) {%>
			 <a href="webapp/screens/Poll/Poll.html?memberCode=<%=empCode%>" class="anchor-wrapper"><h4>Click here to choose Thrift Interest Option Poll</h4></a> 
		  	<%}if(showLink && count>=1){%><a  class="anchor-wrapper" style="width:350px;"><h4 align="center">Thrift Option has been Submitted</h4></a>
		  	<%}if(!showLink){%><a  class="anchor-wrapper" style="width:380px;"></a>
			<%}if(con!=null){
				 con.close();
				}
          }catch(Exception e){
				System.out.println("  EXCEPTION     "+e);				
				e.printStackTrace();
				if(con!=null){
					 con.close();
					}
			
			}%>
		  	<a class="btn btn-danger " href="/SocietyNew/Logout.jsp" > Logout</a>
	    </div>
   
        <div class="header">
        <h1>WELCOME TO SOCIETY</h1>
            <h1>Member Info</h1>
            <p>Get your information here</p>
        </div>

        <div class="loan-options">
            <div class="loan-option">
                <h3>Member Account Info</h3>
                <p>Flexible funds for your needs, from emergencies to big purchases.</p>
                <ul class="badge-container">
                <li><span class="badge " id="thriftBalance" > Thrift Balance </span></li>
                <li><span class="badge " id="shareCapital" > Share Capital</span></li>               
                </ul>
            </div>
            <div class="loan-option">
                <h3>Loan Info</h3>
                <p>Affordable financing to make your dream to a reality.</p>
                <ul class="badge-container">
                <li><span class="badge " id="ltl" > Long Term Loan</span></li>
                <li><span class="badge " id="exl" > Express Loan</span></li>
                <li><span class="badge " id="fdl" > FDL Loan</span></li>
                 <li><span class="badge " id="surety" > Surety Details</span></li> 
                 <li><span class="badge" id="eligibility" >Loan Eligibility Amount</span></li>               
                </ul>
            </div>
            <div class="loan-option">
                <h3>Deposit Info</h3>
                <p>Empower your business with funding tailored to your growth plans.</p>
                   <ul>
                <li><span class="badge" id="fixedDeposit" >Fixed Deposit</span></li>
                <li><span class="badge" id="recDeposit" >Recurrent Deposit</span></li>  
                               
                </ul>
            </div>
        </div>
		</div>
    </div>
	 <div id="modalContainer"></div> 
	
</body>

</html>