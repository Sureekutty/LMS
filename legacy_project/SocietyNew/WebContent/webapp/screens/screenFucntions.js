$(document).ready(function(){
	
	disableInputFileds = function(){
		$(':input').not('[type = button],[id = empCode]').prop('disabled',true);
		$('#membershipDate').prop('disabled',false);
	}
	enableInputFileds = function(){
		$(':input').not('[type = button]').prop('disabled',false);
	}
	disableButton = function(){
		$(':button').not('[id = btnClearAll]').prop('disabled',true);
	}
	clearInputValues = function() {
		$(':input').not('[type = button],[id = empCode],[id=currDate]').val("");
	}
	onLoad = function(){
		disableButton();
		disableInputFileds();
		clearInputValues();
	}
});

function numericKey(e,id) {
	var evt_mozila = window.event || e;
	if (evt_mozila) {
		var charcode = evt_mozila.keyCode || evt_mozila.which;
		if ((charcode > 31) && (charcode < 46) || (charcode > 57)) {
			$("#"+id+"").val("");
			return false;
		}
		return true;
	}
}
