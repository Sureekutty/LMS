$(document).ready(function() {
	displayScreenDetails(" Member Address");
/*clearScreens = function() {
		
		$(':input:not([type=button])').val('');
		$(':input:not([id=empCode])').prop("disabled",true);
		$("#btnEdit").prop('disabled',true);
	  }
clearScreens();*/
	
/*clearBtn=function()
	{
		$(':input:not([type=button])').val('');
		$(':input:not([id=empCode],[type=button])').prop("disabled",true);
		$("#empCode").val("");
		$("#empCode").prop("disabled" ,false).trigger("chosen:updated");
		$("#btnEdit").prop('disabled',true);
	}

*/


Addaddress = function(){
	//alert("Inside address")
	
	var add1=$('#address1').val();
	if(add1==''||add1==undefined)
		{
		alert("Enter 1st Address")
		return;
		}
	
	var add2=$('#address2').val();
	if(add2==''||add2==undefined)
		{
		alert("Enter 2nd Address")
		return;
		}
	
	var addcity=$('#city').val();
	if(addcity==''||addcity==undefined)
		{
		alert("Enter city")
		return;
		}
	var adddistr=$('#Distr').val();
	if(adddistr==''||adddistr==undefined)
		{
		alert("Enter District")
		return;
		}
	var addpin=$('#pincode').val();
	if(addpin==''||addpin==undefined)
		{
		alert("Enter pincode")
		return;
		}
	var addstate=$('#state').val();
	if(addstate==''||addstate==undefined)
		{
		alert("Enter state")
		return;
		}
	
	var Remarks=$('#Remarks').val();
	if(Remarks==''||Remarks==undefined)
		{
		alert("Enter Remarks")
		return;
		}
	
	
	
	var address1=$('#address1').val().toUpperCase();
	var address2=$('#address2').val().toUpperCase();
	var city=$('#city').val().toUpperCase();
	var District=$('#Distr').val().toUpperCase();
	var pincode=$('#pincode').val().toUpperCase();
	var state=$('#state').val().toUpperCase();
	var Remarks=$('#Remarks').val().toUpperCase();
	
	var data={'Address1':address1,'Address2':address2,'City':city,'District':District,'Pincode':pincode,'State':state,'Remarks':Remarks,'AddressId' : ""};
	
	var addlist=findgrid1.dataset.data;
	
	addlist.push(data);
	
	findgrid1.setContent(addlist);
	findgrid1.refresh();
	
}
$("#btnClearAll").click(function() {
	window.location="/SocietyNew/webapp/screens/Members/MemberAddress/MemberAddress.jsp";
});
/*validateSave = function() {
		var address1 = $('#address1').val();
		if(address1 == ''|| address1 == undefined){
			alert('Enter Address1');
			return false;
		}
		var address2 = $('#address2').val();
		if(address2 == ''|| address2 == undefined){
			alert('Enter Address2');
			return false;
		}
		var city = $('#city')
		if(city =='' || city == undefined){
			alert('Enter City Name');
			return false;
		}
		
		var district = $('#district').val();
		if(district =='' || district == undefined){
			alert('Enter District Name');
			return false;
		}
		
		var pincode = $('#pincode').val();
		if(pincode =='' || pincode == undefined){
			
			alert('Enter Pincode');
			return false;
		}
		var state = $('#state').val();
		if(state =='' || state == undefined){
			alert('Enter State Name');
			return false;
		}

		var remarks = $('#remarks').val();
		if(remarks =='' || remarks == undefined){
			alert('Enter Remarks');
			return false;
		}
		return true
	}*/ 


	getMemberCodeList = function(type) {
	
		$.post('/SocietyNew/genericsDetails',{
				type : 'SOCIETYMEM',
				req:'employeeList',
				regstatus : 'NEW',
		},function (data) {
			try {
				var pop_data = eval("("+data+")");
				var arr = new Array();
				arr = pop_data.EMPLOYEELIST;
				var sel = document.getElementById("empCode");
				for(var i=0;i<arr.length;i++){	
					var option=document.createElement("option");
					var temp = arr[i];
					option.text=temp;
					option.value=temp.split("-")[0];
					sel.add(option);
				}
				
				$("#empCode").trigger("chosen:updated");
				$("#empCode").prop("disabled" ,false);
			} catch (e) {
				// TODO: handle exception
				alert('Exception in getEmployeeCodeList ' +e.message)
			}
		});
	}
	var option = null ;
	getMemberCodeList();
	var empCode=null;
	
	$('#empCode').change(function() {
		
		/*empCode=$('#empCode').val();*/
		var memAccNo = (($("#empCode").val()).split("-"))[0];
		
		/*$(':input:not([type=button])').val('');*/
		$.post('/SocietyNew/MemAddress',{
			req : 'gettinggriddata',
			option:"GRIDDATA",
			memAccNo:memAccNo,
		},function(data){
			
			try {
				var pop_data = eval("("+data+")");
				findgrid1.cleanContent();
				findgrid1.setContent(pop_data.addDetails);
			} catch (e) {
				// TODO: handle exception
				alert('Exception in Address ' +e.message)
			}
		    
		});
	})
	
		$("#btnSave").click(function(){
		
			
			var memAccNo = $('#empCode').val();
			var emplcode = $('#emplcode').val();
			if(memAccNo ==" "){
				alert('Select Employee Code');
				return false;
			}
				var memAccNo = (($("#empCode").val()).split("-"))[0];
		
				var grid=Sigma.$grid("grid1");
			var igrid1=JSON.stringify(grid.dataset.data);
			
		if(igrid1 == ''|| igrid1 =="[]"){
				alert('Empty Grid Data');
				return false;
			}
		
		
		deletefun();
		
			$.post('/SocietyNew/MemAddress',{
				req : 'saveMemAddress',
				
				memAccNo:memAccNo,
				emplcode:emplcode,
				igrid1:igrid1,
				option1 : "SAVEWITHOUTID",
				option2 : "SAVEWITHID",
			},function(data){
				
				try {
					var pop_data = eval("("+data+")");
					if(pop_data.success == "y"){
						alert("Details Saved Successfully");
						/*$(':input:not([type=button])').prop('disabled',true);*/
					}
					else{
						alert("Failed To Save Details")
					}
				} catch (e) {
					// TODO: handle exception
					alert('Exception in MemAddress ' +e.message)
				}
				
			});
			
});
		
	/*$("#btnEdit").click(function(){

		$(':input:not([id=empCode])').prop("disabled",false);
		$("#btnEdit").prop('disabled',true);
	})*/;
	
	
	
});


deletefun = function(){
	var memAccNo = $('#empCode').val();
	if(memAccNo ==" "){
		alert('Select Employee Code');
		return false;
	}
		var memAccNo = (($("#empCode").val()).split("-"))[0];

		var grid=Sigma.$grid("grid1");
	var igrid1=JSON.stringify(grid.dataset.data);
	
if(igrid1 == ''|| igrid1 =="[]"){
		alert('Empty Grid Data');
		return false;
	}
		$.post('/SocietyNew/MemAddress',{
			req : 'deleteNomineemember',
			option:"DELETE",
			userid :'SOC0001',
			memAccNo:memAccNo,
			igrid1:igrid1,
		},function(data){
			
		});
}

function numericKey(e) {
	var evt_mozila = window.event || e;
	if (evt_mozila) {
		var charcode = evt_mozila.keyCode || evt_mozila.which;
		if ((charcode > 31) && (charcode < 46) || (charcode > 57)) {
			alert("Enter Number!!");
			return false;
		}
		return true;
	}
}