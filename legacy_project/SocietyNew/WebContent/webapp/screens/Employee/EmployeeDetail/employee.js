$(document).ready(function(){
	
	 $('.badge').click(function(){
	    	var id = $(this).attr('id')
			var url;
	    	if(id=='shareCapital'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/ShareCapital.jsp';
	    	}
	    	if(id=='thriftBalance'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/Thrift.jsp';
	    	}
	    	if(id=='ltl'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/LTL.jsp';
	    	}
	    	if(id=='exl'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/EXL.jsp';
	    	}
	    	if(id=='fdl'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/FDL.jsp';
	    	}
	    	if(id=='recDeposit'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/RCD.jsp';
	    	}
	    	if(id=='fixedDeposit'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/FD.jsp';
	    	}
	    	if(id=='surety'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/SuretyDetails.jsp';
	    	}
	    	if(id=='eligibility'){
	    		url='/SocietyNew/webapp/screens/Employee/EmployeeDetail/ELG.jsp';
	    	}
	        $('#modalContainer').load(url, function(response, status,xhr){
	            if(status === "success"){
	            	
	                $('#employeeModal').modal('show');
	            } else {
	                alert("Error loading modal: " + xhr.status+" - "+shr.statusText);
	            }
	        });
	    	
	    });
	 
	 
	 
	  $('#apply').click(function () {
	      
		/*  $.post('/SocietyNew/GeneratePDF',{
	            method: 'POST',
	            xhrFields: {
	                responseType: 'blob'  // Important for binary response (PDF)
	            },
	            success: function (data, status, xhr) {
	                var blob = new Blob([data], { type: 'application/pdf' });
	                var link = document.createElement('a');
	                link.href = window.URL.createObjectURL(blob);
	                link.download = 'filled_template.pdf';
	                link.click();
	            },
	            error: function () {
	                alert("Failed to generate PDF.");
	            }
	        });*/
		
			//var req = "MemGenpdfformSanctionRelease";
			var frm = document.createElement("form");
			frm.method = "POST";
			frm.name = "GenPDF_FORM";
			frm.action = "/SocietyNew/GeneratePDF";
			frm.target = "_blank";
			document.body.appendChild(frm);

			frm.submit();
		  
	    });
});






