var selType = '';
var myButtonClicked = '';
$(document).ready(function() {

	$('#upload').click(function() {
		myButtonClicked = '';
		if(this.id == 'upload'){
			myButtonClicked = this.value;
		}
		uploadfunction(myButtonClicked)
	});
	
	$('#send').click(function() {
		alert("kjfdgdfg")
	
		sendsmsfunc(myButtonClicked)
	});
	
	$('#home').click(function() {
		myButtonClicked = '';
		if(this.id == 'home'){
			myButtonClicked = this.value;
		}
		home(myButtonClicked)
	});
	
	
	$('#testsms').click(function() {
		myButtonClicked = '';
		if(this.id == 'testsms'){
			myButtonClicked = this.value;
		}
		testsms(myButtonClicked)
	});
	
});


/*
function uploadhandelerfunction()
{ 
	 if(xmlhttp.readyState == 4 && xmlhttp.status == 200)
	 {
		 var main = eval("("+xmlhttp.responseText+")");
		 
		 if(main.success=="Y")
		 {	
			 var rowcount = main.rec[1].totalrows;
		
			 var count = main.rec[0].count;
			 if(count > 0) {
				 document.getElementById("text").innerHTML = "";
				 document.getElementById("ackfile").innerHTML = count + " records already exist. File not inserted.";
			 }
			 else {
				 var arr=new Array();
				 arr = main.rec;
				 document.getElementById("text").innerHTML = "";
				 document.getElementById("nodata").innerHTML = "";
				 document.getElementById("ackfile").innerHTML = main.action + " rows uploaded.";
					 findgrid.setContent(arr); 
			 }
		 }
		 else
		 { 
			var exception = main.rec[0].exception;
			document.getElementById("text").innerHTML = "";
			document.getElementById("ackfile").innerHTML = "Exception - "+exception;
		 }	
	 }
}*/
//---------------------------------------------------------

function sendsmsfunc(myButtonClicked) {
	alert("gfdghj")
	var req="SENDSMS";
		 $.ajax({
			 type:'post',
			 url:'/SocietyNew/ExcelImport',
			 data:{
				 'req':req,
				 
			 },
			 success:function(data)
			 {
				 alert(data)
			 }
		 })
}


function testsms(myButtonClicked){

	var mobileno = document.getElementById("mobileno").value;
	if(mobileno==""){
		document.getElementById("nodata").innerHTML ="Mobile Number  can't Be Blank";
		return;
	}
	if(mobileno.length!=10){
		document.getElementById("nodata").innerHTML ="Enter Ten Digit Mobile Number";
		return;
	}
	var message = document.getElementById("message").value;
	if(message==""){
		document.getElementById("nodata").innerHTML ="message  can't Be Blank";
		return;
	}
	
	var req="TESTSMS";
		document.getElementById("nodata").innerHTML = "";
		document.getElementById("text").innerHTML = "Testing... Plz wait for a while.";
		
		 $.ajax({
			 type:'post',
			 url:'/SchoolSMS/Sendsms',
			 data:{
				 'req':req,
				 'mobileno':mobileno,
				 'message':message
			 },
			 success:function(data)
			 {
				 document.getElementById("text").innerHTML = "";
				 document.getElementById("ackfile").innerHTML = data;
			 }
		 })
}
function home(myButtonClicked) {
	
		window.location = "/SchoolSMS/logout.jsp";
	
}


