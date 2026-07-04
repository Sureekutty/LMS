<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<script type="text/javascript" src="webapp/commonFiles/js/jquery-1.12.4.js"></script>
<script type="text/javascript" src="webapp/commonFiles/js/jquery-ui-1.9.2.custom.js"></script>

<script type="text/javascript" src="webapp/commonFiles/js/bootstrap.min.js"></script>
<link href="webapp/commonFiles/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src='./checkScreens.js'></script>
<script type="text/javascript">

	</script>
<style type="text/css">
.background {
            position: relative;
            width: 100%;
            height: 80vh;
            overflow: hidden;
            
        }

       .background::before {
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
        
</style>
</head>
<div>
	<%@include file="webapp/commonFiles/ver/logoTitle2"%>
</div>
<body >
	<%@include file="home1.html"%>
	<div class="background"></div>
</body>
<script type="text/javascript">
		
		function openScreen(click) {
			var urlid = click.id;

			if (urlid == "LOUT") {

				window.location = "/SocietyNew/Login.jsp";

			}
		}
			</script>
</html>