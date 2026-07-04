function genhall() {
		
		var advtNum = document.getElementById("advtno").value;
		if(advtNum.length == 0) {
			alert("Enter Advertisement Number.");
			return false;
		} /*else if(advtNum.length != 12) {
			alert("Length of Advertisement Number should be 12 characters.")
			return false;
		}
		var pattAdvt = /^[A-Z]{1}[a-z]{3}[_]{1}[0-9]{2}[_]{1}[0-9]{4}$/;
		if(!pattAdvt.test(advtNum)) {
			alert("Enter Advertisement Number as shown in example.");
			return false;
		}*/
		var advtDate = document.getElementById("date").value;
		if(advtDate.length == 0) {
			alert("Enter Advertisement Date.");
			return false;
		}
		var patt = /^[0-9]{2}[.]{1}[0-9]{2}[.]{1}[0-9]{4}$/;
		if(!patt.test(advtDate)) {
			alert("Invalid Advertisement Date.");
			return false;
		}
		var postCode = document.getElementById("pcode").value;
		if(postCode == null || postCode == "") {
			alert("Enter Post Code.");
			return false;
		}
		var pattPC = /^[0-9]{2}$/;
		if(!pattPC.test(postCode)) {
			alert("Invalid Post Code.");
			return false;
		}
		var postName = document.getElementById("pname").value;
		
		if(postName.length == 0) {
			alert("Enter Post Name.");
			return false;
		}
		if(postName.indexOf("&") != -1) {
			alert("Replace '&' with 'AND' in Post Name.");
			return false;
		}
		
       var pnamehin = document.getElementById("pnamehin").value;
		
		if(pnamehin.length == 0) {
			alert("Enter Hindi Post Name.");
			return false;
		}
		
		if(pnamehin.indexOf("&") != -1) {
			alert("Replace '&' with 'AND' in Post hindi Name.");
			return false;
		}
		
		
		var dateOfTest = document.getElementById("dot").value;
		if(dateOfTest.length == 0) {
			alert("Enter Date of Test.");
			return false;
		}
		var timeOfTest = document.getElementById("tot").value;
		if(timeOfTest.length == 0) {
			alert("Enter Time of Test.");
			return false;
		}
		var repTime = document.getElementById("rept").value;
		if(repTime.length == 0) {
			alert("Enter Reporting Time.");
			return false;
		}
		var venl1 = document.getElementById("venline1").value;
		if(venl1.length == 0) {
			alert("Enter Venue.");
			return false;
		}
		var venl2 = document.getElementById("venline2").value;
		if(venl2.length == 0) {
			/*alert("Enter Venue.");
			return false;*/
			venl2 = "";
		}
		var venl3 = document.getElementById("venline3").value;
		if(venl3.length == 0) {
			/*alert("Enter Venue.");
			return false;*/
			venl3 = "";
		}
		var venl4 = document.getElementById("venline4").value;
		if(venl4.length == 0) {
			/*alert("Enter Venue.");
			return false;*/
			venl4 = "";
		}
		
		
		
		var venl5 = document.getElementById("venline5").value;
		if(venl5.length == 0) {
			/*alert("Enter Venue.");
			return false;*/
			venl5 = "";
		}
		
		
		
		var venl6 = document.getElementById("venline6").value;
		if(venl6.length == 0) {
			/*alert("Enter Venue.");
			return false;*/
			venl6 = "";
		}
		
		
		
		var venl7 = document.getElementById("venline7").value;
		if(venl7.length == 0) {
			/*alert("Enter Venue.");
			return false;*/
			venl7 = "";
		}
		
		
		
		var venl8 = document.getElementById("venline8").value;
		if(venl8.length == 0) {
			/*alert("Enter Venue.");
			return false;*/
			venl8 = "";
		}
		
		
		var txtfield1 = document.getElementById("txtfield1").value;
		if(txtfield1.length == 0) {
	          alert("Enter txtfield1");
		}
		var txtfield2 = document.getElementById("txtfield2").value;
		if(txtfield2.length == 0) {
	          alert("Enter txtfield2");
		}
		var txtfield3 = document.getElementById("txtfield3").value;
		if(txtfield3.length == 0) {
	          alert("Enter txtfield3");
		}
		
		
		
		document.getElementById("text").innerHTML = "Hall Ticket generation process initiated... Plz wait for a while."; 
		
		methodtype='POST';
		url="/RMS/HallTkt?";
		var req="saveCheckDetailsFunction";
		params="req="+req+"&advtNum="+advtNum+"&advtDate="+advtDate+"&postCode="
		+postCode+"&postName="+postName+"&dateOfTest="+dateOfTest+"&timeOfTest="+timeOfTest+"&repTime="+repTime+"&venl1="+venl1+"&venl2="+venl2+"&venl3="+venl3+"&venl4="+venl4+"&venl5="+venl5+"&venl6="+venl6+"&venl7="+venl7+"&venl8="+venl8+"&pnamehin="+pnamehin+"&txtfield1="+txtfield1+"&txtfield2="+txtfield2+"&txtfield3="+txtfield3;             
		ajaxCallver(methodtype,params,url,handelerfunction);
		
}

function handelerfunction()
{ 
	 if(xmlhttp.readyState == 4 && xmlhttp.status == 200)
	 {
		 var main = eval("("+xmlhttp.responseText+")");	
		 if(main.success=="Y")
		 	{	
			 	var text = " Hall Tickets generated for the post ";
			 	var pCode = document.getElementById("pcode").value;
			 	var pName = document.getElementById("pname").value
			 	
			 	var path = main.rec[0].directoryName;
			 	var total = main.rec[0].total;
			 	total = total - 1;
			
		 		if(total == 0){
		 			document.getElementById("ackfile").innerHTML = "";
		 			document.getElementById("text").innerHTML = "";
		 			document.getElementById("nodata").innerHTML = "No data in database! Upload Excel File.";
		 		}
		 		else{
		 			document.getElementById("ackfile").innerHTML = "";
		 			document.getElementById("text").innerHTML = total + " " + text + " " + pCode + " - " + pName + " in the directory <br>" +path;
		 		}
			   
		 	}
		 	else
		 	{
		 		var exception = main.rec[0].exception;
				document.getElementById("text").innerHTML = "";
				document.getElementById("nodata").innerHTML = "";
				document.getElementById("ackfile").innerHTML = "Exception - "+exception;
		 	}	 
		
	} 
}