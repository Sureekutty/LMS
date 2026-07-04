var dsOption = {
		fields :[ 
			
		],
		recordType : 'object'
	}
	var colsOption = [
{
	id:'VIEW',
	header:"Option",
	width:70,
	renderer:render_view
}, {
		id : 'memAccno',
		header : "APPLNO",
		//editor:{type:"text"},
		width : 90
	}, 	{
		id: 'employee',
		header : "MEMBER NAME",
		width : 330
	},
	{
		id:'dateOfBirth',
		header:"DATE OF BIRTH",
		//editor:{type:"text"},
		width:170
	},
	{
		id:'registeredDate',
		header:"REGISTERED DATE",
		//editor:{type:"text"},
		width:170
	}
	
	];


var gridOption= {
		
		id : "grid",
		container : 'containerGrid',
		dataset : dsOption,
		columns : colsOption,
		toolbarPosition : false,
		// toolbarContent : 'nav | goto | filter | print ',
		selectRowByCheck : false,
		lightOverRow : false,
		stripeRows : true,
		showIndexColumn : true,
		pageSize : 30000,
		height : 300,
		width : 850,
		
		onRowClick : function(value, record, cell, row, colNO, rowNO,columnObj, grid){
			if(record.memAccno=="" ||record.memAccno===undefined){
				alert("No Records");
				return;
			}
			
			
			
			$('#btnApprove').prop("disabled" ,false);
			$('#btnPrint').prop("disabled" ,false);
			$('#Remarks').val("");
			
			
			$('#basicInfo').hide();
			$('#accNo').val(record.memAccno);
			
			$('#memempcode').val(record.memEmpCode); 
			$('#employeeDetails').text(record.memAccno+" - "+record.memName);
			$('#basicPay').text(record.basicPay);
			var panNumber = record.panNumber;
			if(panNumber == '-')
				panNumber = 'NA';
			var aadharNumber = record.aadharNumber;
			if(aadharNumber == '-')
				aadharNumber = 'NA';
			
			$('#aadharNumber').text(aadharNumber + " - " +panNumber );
			$('#phoneNum').text(record.phoneNumber+" - " +record.officeNumber);
			$('#dateOfBirthRetireDate').text(record.dateOfBirth);
			
			
			
		
			
			
			
			
			$('#remarks').val(record.remarks)
			
			
			$('#membershipDate').text(record.membershipDate)
			
			$('#shares').text(record.shareAmount + " / "+ record.totalShares);
			
			
			$('#entranceAmount').text(record.entranceAmount);
			$('#thriftAmount').text(record.thriftAmount);
			$('#viewTable').find(':text').prop('disabled',true);
			$('#myModal').find(':button').not('[id = closeButton]').hide();
			


				if(typeOfSearch == 'Active' || typeOfSearch == 'ACTIVE'){
				
					$('#btnMemship').show();
					$('#btnApprove').hide();
					$('#remarksTR').hide();
					$('#btnPrint').show();
				}
				if( typeOfSearch == 'CANCEL'){
					$('#btnApprove').hide();
					$('#btnPrint').show();
					$('#remarksTR').hide();
				}
				
				
				if(typeOfSearch == 'SUBMIT'){
					var Role = $('#Role').val();
					
					if(Role==1){
						$('#btnApprove').hide();
						$('#remarksTR').hide();
						$('#btnEdit').show();
						$('#btnPrint').show();
						$('#btnEdit').prop('disabled',false);
						
					}else{
						$('#btnApprove').show();
						$('#btnPrint').show();
						$('#remarksTR').show();
						
					}
					
				$('#btnApprove,#btnEdit').prop('disabled',false);
				
				
				}
			
			else{
				$('#btnApprove,#btnEdit').prop('disabled',true);
			}
			
			return;
		},
		beforeEdit:function(){
	}
};
var findgrid = new Sigma.Grid(gridOption);
Sigma.Util.onLoad(Sigma.Grid.render(findgrid));



function render_view(value ,record,columnObj,grid,colNo,rowNo){
	return "<a href='#' id='"+record.memAccno+"' name='viewDetails' data-toggle='modal' data-target='#myModal' onclick='bankinfo(this.id)'>View</a>";
//	return " <a href='#' data-toggle='modal' id = 'viewClick' data-target='#myModal' onclick = 'setAccountNumber('"+record.memAccno+"') return true;' >View</a> ";
}

	
function bankinfo(memaccno){
	$('#bankAccNo').text('');
	$('#ifscCode').text('');
	$('#bankName').text('');
	$('#bankPlace').text('')
	$.post('/SocietyNew/MembersView',{
		req : 'bankinfo',
		memaccno : memaccno,
	},function(data){
			var pop_data = eval("("+data+")");
			$('#bankAccNo').text(pop_data.Bankinfo[0].Bankaccno);
			$('#ifscCode').text(pop_data.Bankinfo[0].Ifsccode);
			$('#bankName').text(pop_data.Bankinfo[0].Bankname);
			$('#bankPlace').text(pop_data.Bankinfo[0].Bankplace)
	});
	
}


