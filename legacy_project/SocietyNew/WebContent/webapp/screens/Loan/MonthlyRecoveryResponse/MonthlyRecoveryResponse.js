var Role;
$(document).ready(function() {
	
//	var dt_obj= new Date();
//	var current_month=dt_obj.getMonth();
//	var current_year=dt_obj.getFullYear();
//	var monthdate=current_date+"/"+current_month+"/"+current_year;
//	var monthdate=new Date(current_year,current_month,0).toLocaleDateString();	
//	$('#monthproces').text(monthdate);
	Role = $('#Role').val();
	if(Role == 2){
		$('#btnApprove').show();
		
	}
	
	$('#browse').val('');
	getpurposeCodeList()
	displayScreenDetails(" Monthly Recovery Update Process");
	
	$("#btnClearAll").click(function() {
		
		window.location="/SocietyNew/webapp/screens/Loan/MonthlyRecoveryResponse/MonthlyRecoveryResponse.jsp";
		
	});
	
		
	$('#browse').prop('disabled',true);
	$('#btnUpdate').prop('disabled',true);
	$('#btnApprove').prop('disabled',true);
	$('#Purpose').change(function(){
		
		$('#browse').prop('disabled',false);
			
		});
$('#browse').change(function(){
		
	$('#btnUpdate').prop('disabled',false);
			
		});
		
		
		$('#btnUpdate').click(function() {
						

			
			var file=$('#browse').val();
			
			var Purpose=$('#Purpose').val();
			
			var monthproces=$('#monthproces').text();
			
			var monthandyear=monthproces.replace("/","-");
			
			var month=parseInt(monthandyear.split("-")[0]);
			
			var currmonth=month;
			
			var year=monthandyear.split("-")[1];
			
			var name=currmonth+"-"+year.replace("/",'')+"&"+Purpose;
			
			
	  var filename=$('input[type=file]').val();
			
		var fname;
		
		fname=filename.split(".")[0];
		
		
		if(fname.includes("fakepath")){
			
			fname=fname.replace("C:\\fakepath\\","")	
		}
		
		if(name!=fname){
			alert("InValid File,  Please  Upload  "+name+".txt File ")
			return;
		}
	
		uploadfunction(file)
		});
	
		$('#btnApprove').click(function() {
			var monthproces=$('#monthproces').text();
			var Purpose=$('#Purpose').val();
			 var grid=Sigma.$grid("grid");
			 var data = findgrid.dataset.data;					 
			 var gridData = JSON.stringify(data);
			 findgrid.cleanContent()
			 $('#dialog1').dialog('open');
			 document.getElementById("updateinfo").innerHTML = "     Data Updating Please Wait....";
			if (confirm("Do you want to approve all the record..??")) {
				$.post('/SocietyNew/MonthlyRecoveryResponse',{
							'req' : 'approve',
							'gridData' : gridData,
							 monthproces :monthproces,
							 Purpose :Purpose
						},function(data) {								
							try {
								$('#dialog1').dialog('close');
								var pop_data = eval("("+ data+ ")");
								if (pop_data.SUCCESS == 'Y') {	
									document.getElementById("updateinfo").innerHTML = "";
									alert('all responses are approved  ');
									griddata();
									$('#btnApprove').prop('disabled',true);
								}
								else{
									document.getElementById("updateinfo").innerHTML = "";
									alert("Exception while approving data")
								}
							} catch (e) {
								// TODO: handle exception
								alert('Exception while approving '+ e.message)
							}
						});
			}
		});



	});
$(function() {
	  $( "#dialog1" ).dialog({
		  autoOpen: false,
		  dialogClass: 'no-close',
		  position:['CENTER','top+5'],
		  closeOnEscape:false,
		  show: 'blind',
		  hide: 'explode',
		  modal:true,
		});
	});


var reader; //GLOBAL File Reader object for demo purpose only

/**
 * Check for the various File API support.
 */
function checkFileAPI() {
	
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        reader = new FileReader();
        return true; 
    } else {
        alert('The File APIs are not fully supported by your browser. Fallback required.');
        return false;
    }
}

getpurposeCodeList = function() {
	
	$.post('/SocietyNew/genericsDetails',{
		req:'getpurposecodes',
		option : 'PURPOSECODE',
	},function (data) {
		try {
			
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.ALLPURPOSECODELIST;
			var sel = document.getElementById("Purpose");
			
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				
				var temp = arr[i];
//				alert("temp  "+temp)
				option.text=temp.split('-')[1]+" ["+temp.split('-')[2]+"]";
				var string = temp.split('-')[0];
				option.value=string;
				sel.add(option);
				
				
				
			}
			$("#Purpose").trigger("chosen:updated");
		} catch (e) {
			// TODO: handle exception
			alert('Exception in purposeCodeList ' +e.message)
		}
		
	});
}

function uploadfunction(file) {
		var fileInput = $('#browse');
	    if (!window.FileReader) {
	        alert('Your browser is not supported');
	        return false;
	    }
	    var input = fileInput.get(0);
	    // Create a reader object
	    var reader = new FileReader();
	    if (input.files.length) {
	        var textFile = input.files[0];
	        // Read the file
	        reader.readAsText(textFile);
	        // When it's loaded, process it
	        $(reader).on('load', processFile);
	    } else {
	        alert('Please upload a file before continuing')
	    } 
	}

	function processFile(e) {
		document.getElementById("updateinfo").innerHTML = "     Data Updating Please Wait....";
		var monthproces=$('#monthproces').text();
		var Purpose=$('#Purpose').val();
		var purpose1 = $('#Purpose option:selected').text();
		
		
		var salCode = purpose1.split('[')[1];
		var code=salCode.replace(']',"");
		//alert("salCode is  "+ code)
		
//		.split("~")[0]
	    var file = e.target.result,
	        results;
	   
	    var linedata="";
	    
	    if (file && file.length) {
	    	
	        results = file.split("\r");
	        
	       // alert(results)
	    	
	        for(var line = 0; line < results.length; line++){  
	        	
	        	if(results[line].trim()==""){
	        		continue;
	        	}
	           linedata=linedata+"&&"+results[line];
	           
	          } 
	       // alert(linedata)
	        if(!linedata.includes(code) && code ==""){
	        	alert("salCode is not availabe");
	        	return;
	        }
	        $('#dialog1').dialog('open');
	        	$.post('/SocietyNew/MonthlyRecoveryResponse',{
    		req:'txtxfile',
    		file :linedata.trim(),
    		monthproces:monthproces,
    		Purpose:Purpose,
    		purpose1 : purpose1,
    	},function (data) {
    		try {
    			 $('#dialog1').dialog('close');
    		var pop_data = eval("("+data+")");
    		if(pop_data.success=='Y'){
    			document.getElementById("updateinfo").innerHTML = "";
    			griddata();
    		}
    		 if(pop_data.success=='N'){
    			 document.getElementById("updateinfo").innerHTML =""
     			alert(pop_data.error)
     		}
    		
    		}catch(e){
    			 document.getElementById("updateinfo").innerHTML =""
    			alert("Error in Updating text file data "+e)
    		}
    		
    		
    		
    	});
	        
	        
	    }
	    
	}
	
function griddata(){

	var monthproces=$('#monthproces').text();
	var Purpose=$('#Purpose').val();
	findgrid.cleanContent()
	$.post('/SocietyNew/MonthlyRecoveryResponse',{
		monthproces :monthproces,
		Purpose :Purpose,
		req:'gettinggriddata',
	},function(data){
		
		try {
			var pop_data = eval("("+data+")");
			
			if(pop_data.RECDETAILS=="N"){
				findgrid.cleanContent()
				alert("No Data Updated")
			}else{
			findgrid.cleanContent()	
			findgrid.setContent(pop_data.RECDETAILS);
			//alert(pop_data.RECDETAILS)
			if(Role == 2){
				$('#btnApprove').prop('disabled',false);
				
			}
			}
			$('#btnUpdate').prop('disabled',true);
		
		} catch (e) {
			// TODO: handle exception
			alert('Exception in Monthly Recovery Response ' +e.message)
		}
		
	});
	
}

