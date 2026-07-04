
getEntities = function(){
	
	$.post('/SocietyNew/StatementDispatch',{
		req:'getEntities',				
	},function(data){
		try{
			var pop_data = eval("("+data+")");						
			var sel = document.getElementById("entity");
			for(var i=0;i<pop_data.entities.length;i++){	
				var option=document.createElement("option");
				var temp = pop_data.entities[i].ENTITYCODE+" - "+pop_data.entities[i].ENTITYFULLNAME;
				option.text=temp;
				var string = temp.split('-')[0];
				option.value=string;
				sel.add(option);
			}
			$("#entity").trigger("chosen:updated");
		}
		catch(e){
			alert("Exception while getting entities  "+e);
		}
	});
}

function upload() {
	var fileName = $('#xfile').val();
	$('#uploadedfile').val(fileName);
//	$("#frm1").submit();
	
	var fData= new FormData($("#frm1")[0]);
	var fileList=document.getElementById('xfile');
	
	document.getElementById("load").innerHTML='<b><center>Please Wait....</b></center>';
//	alert($("input[name='POtyp']:checked").val());
	
	if(fileList.files.length==0){
		alert('Select a file');
		return;
	}
	
//	if()
//	var req = 'uploadFile';
	$.ajax({
		type:'POST',
		url:'/SocietyNew/StatementDispatch',
		data:fData,
		mimeType:'multipart/form-data',
		contentType:false,
		processData:false,
		cache:false,
		beforeSend:function(){
			$('#load').show().css("visibility","visible");
		},
		success:function(data){ 
			try{
			  var pop_data=eval("("+data+")");			  
			  findgrid.setContent(pop_data);			  			  
			  }
			   catch(e){				  
				   alert('Error parsing data:'+e);
			   }
		},
		complete:function(){			
			$('#load').hide();
		}
		
	});
	
}


bulkSend=function(){
	
	alert('reader');
	$.post('/SocietyNew/StatementDispatch',{
		req:'readfile'				
	},function(data){
		try{
			var pop_data = eval("("+data+")");
			
		}
		catch(e){
			alert("Exception while getting entities  "+e);
		}
	});
}

function financeonChange(){
	$('#uploadedfile').val();
}

function btnClear(){
	window.location="/SocietyNew/webapp/screens/Members/AnnualStmtDispatch/StmtDispatch.jsp";
}

function fileCheck(){
	var folderPath="H:\Pradumn\PradumnWorkspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\SocietyNew\fileRepository";
	var reader = new FileReader();
	reader.readAsText(new File([folderPath],""));
	reader.onload=function(event){
		var fileContent = event.target.result;
		var fileList = fileContent.split('\n');
		console.log(fileList)
	}

}
