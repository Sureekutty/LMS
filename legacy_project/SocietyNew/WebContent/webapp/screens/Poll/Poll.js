
$(document).ready(function() {
	
      var params = getQueryParams();
     // alert(params)
      // Populate hidden fields with passed member data
      $('#memcode').val(params);
     
      $('#form').on('#submitBtn', function(e) {
    	    // Check if any optionSelected radio button is checked
    	  alert("here")
    	  if ($('input[name="vote"]:checked').length) {
    	     var option=$('input[name="vote"]:checked');
    	     var id=option.attr('id');
    	     alert(id)
    	    if(id=="bank")
    	    	 $('#pollOpt').val(1)
    	    if(id=="loan")
    	    	 $('#pollOpt').val(2)
    	    if(id=="thrift")
    	    	 $('#pollOpt').val(3)
    	    }
    	  
    	    if (!$('input[name="vote"]:checked').length) {
    	      alert('Please select an option before submitting.');
    	      e.preventDefault(); // Prevent form submit
    	      return false;
    	    }

    	    // You can also validate hidden inputs if needed, e.g.:
    		// alert($('#memcode').val())
    	    if (!$('#memcode').val()) {
    	      alert('Member code missing!');
    	      e.preventDefault();
    	      return false;
    	    }
    	  }); 
      
      
/*      $('#form').submit(function(e) {
    	    //e.preventDefault();  // Prevent normal form submit
    	    // Check if any optionSelected radio button is checked
    	    if (!$('input[name="vote"]:checked').length) {
    	      alert('Please select an option before submitting.');
    	      e.preventDefault(); // Prevent form submit
    	      return false;
    	    }

    	    // You can also validate hidden inputs if needed, e.g.:
    		// alert($('#memcode').val())
    	    if (!$('#memcode').val()) {
    	      alert('Member code missing!');
    	      e.preventDefault();
    	      return false;
    	    }
    	    // Serialize form data for POST
    	    var formData = $(this).serialize();
    	    alert(formData)
    	    $.ajax({
    	        url: '../../screens/Poll/savePoll.jsp',
    	        type: 'POST',
    	        data: formData,
    	        success: function(response) {
    	        	try {
        				alert(response)
        				var pop_data = eval("(" + response + ")");	
        				alert(pop_data.SUCCESS)
        				if(pop_data.SUCCESS ==="Y"){
        					alert(pop_data.msg);
        					 window.location.href = 'EmployeeDetail.jsp';
        				}
        				else{
        					alert(pop_data.msg);
        				}
        				
        			} catch (e) {
        				alert('Exception in checkEmp ' + e.message)
        			}
    	        },
    	        error: function(xhr, status, error) {
    	          alert('An error occurred: ' + error);
    	        }
    	      });
    	  });*/

});//document.ready fun end


function getQueryParams() {
      var params ;
      window.location.search.substring(1).split("&").forEach(function(pair) {
        if(pair) {
          var parts = pair.split("=");
          
          params= decodeURIComponent(parts[1] || '');
          
        }
      });
      return params;
    }


