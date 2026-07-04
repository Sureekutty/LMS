$(document).ready(function() {
	
	displayScreenDetails(" GIVEN DETAILS");
	onload=function(){
		$('#empCode').trigger("chosen:updated").prop("disabled" ,false);
	}
    onload();
    
clearAll=function(){
	$('#empCode').val("");
	$('#empCode').trigger("chosen:updated").prop("disabled" ,false);
	findgrid.cleanContent();
	
}
	$('#btnClearAll').click(function() {
		$('#empCode').trigger("chosen:updated").prop("disabled" ,false);
		clearAll();
		
	})
	loadSuretiesList = function(){
	
		$.post('/SocietyNew/LoanApplication',{
			req:'loadSurety',
			memAccNo:"",
			},function(data){
				try {
					var pop_data = eval("("+data+")");
					var arr = new Array();
					arr = pop_data.SURDETAILS;
							var sel = document.getElementById("empCode");
							for(var i=0;i<arr.length;i++){	
								var temp = arr[i].detail;
								var option=document.createElement("option");
								option.text=temp.split('-')[0]+"-"+temp.split('-')[1]+"-"+temp.split('-')[2]+"-"+temp.split('-')[3];
								
								option.value=temp.split('-')[0]+"-"+temp.split('-')[2]+"-"+temp.split('-')[4];
								sel.add(option);
							}
							$('#empCode').trigger("chosen:updated").prop("disabled" ,false);
				} catch (e) {
					// TODO: handle exception
					alert('Exception in loadSurety ' +e.message);
				}
			});
	}
	loadSuretiesList();

	loadempList = function(MEMACCNO,LOANACCNO){
		$.post('/SocietyNew/genericsDetails',{
			type : 'SURETYACTIVE',
			req:'employeeListsurety',
			regstatus : 'ACTIVE',
			MEMACCNO:MEMACCNO,
			LOANACCNO:LOANACCNO,
	},function (data) {
		
		try {
			var pop_data = eval("("+data+")");
			var arr = new Array();
			arr = pop_data.EMPLOYEELIST;
			var sel = document.getElementById("addempCode");
			for(var i=0;i<arr.length;i++){	
				var option=document.createElement("option");
				var temp = arr[i];
				option.text=temp.split('-')[0]+"-"+temp.split('-')[1]+"-"+temp.split('-')[2];
				var string = temp.split('-')[0]+"-"+temp.split('-')[1]+"-"+temp.split('-')[2]+"-"+temp.split('-')[3];
				option.value=string;
				sel.add(option);
			}
			$("#addempCode").trigger("chosen:updated").prop("disabled" ,false);
		
		} catch (e) {
			// TODO: handle exception
			alert('Exception in getEmployeeCodeListsurety ' +e.message)
		}
	});
}
	
	
	$('#empCode').change(function() {
	
		//$('#empCode').prop("disabled" ,true).trigger("chosen:updated");
		var empAccNo=this.value;
		var memacc=empAccNo.split('-')[0];
		var loanno=empAccNo.split('-')[1];
	
		$.post('/SocietyNew/SuretyReplacement',{
			req:'FetchSureties',
			memacc:memacc,
			loanno:loanno,
		},function(data){
		
			try{
			var pop_data=eval("("+data+")");
			var arr=new Array();
			
			if(pop_data.ERROR=="NO"){
				arr=pop_data.SURETYDETAIL;
				
				findgrid.setContent(arr);
				loadempList(memacc,loanno);
				return;
		      }
			else {
				
				alert(pop_data.ERROR);
				findgrid.cleanContent();
				$('#empCode').trigger("chosen:updated").prop("disabled" ,false);
				clearAll();
				return;
			}
		} catch (e) {
			alert('INSIDE getSurety Details BLOCK ' + e.message);
		}
			
		})
	})
	
	//--------------------------------------------------------------//
		$('#addempCode').change(function() {
	
		var empAccNo=this.value;
		var memacc=empAccNo.split('-')[0];
		var empcode=empAccNo.split('-')[1];
		var empname=empAccNo.split('-')[2];
		var thrift=empAccNo.split('-')[3];
		
		var GridData=Sigma.$grid("grid");
		 var data3=GridData.dataset.data;
		 var val=JSON.stringify(data3);
		 var str=val;
		 var camp;
		if(str.includes(empcode)){
			alert(" Member Already Added")
			return;
		}
		var jgrid={'Memaccno':memacc,'Empcode':empcode,'MemName':empname,'Thriftamt':thrift};
		var data3=Sigma.$grid("grid").dataset.data;
		data3.push(jgrid);
		findgrid.setContent(data3);

		})

		$('#btnSave').click(function() {
			   var grid2data=findgrid.dataset.data;
			    if(grid2data.length >4){	// changed by pn on 21/04/2025 told by rama rao 
					alert('Maximum 3 Suretys Only Required for Account ..');
					return;
				}
			    var empCode=$('#empCode').val();
			    
			    var loanamount=empCode.split("-")[2];
			    var loannum=empCode.split("-")[1];
			    var memacc=empCode.split("-")[0];
			   
				var grid=Sigma.$grid("grid");
				var igrid=JSON.stringify(grid.dataset.data);
				
				$.post('/SocietyNew/SuretyReplacement',{
					req : 'suretycheck',
					loanamount:loanamount,
					igrid:igrid,
					loannum:loannum,
					memacc:memacc,
				},function(data){
					try {
						var pop_data = eval("("+data+")");
						if(pop_data.ERROR=='YES'){
							alert(pop_data.errormsg);
							return;
						}else{
							if(pop_data.SUCCESS=='Y'){
								alert("Surety Added Successfully");
								$('#btnSave').prop('disabled',true);
						}
						}
					} catch (e) {
						alert('Exception in Surety Details ' +e.message)
					}
				});
		});	
})