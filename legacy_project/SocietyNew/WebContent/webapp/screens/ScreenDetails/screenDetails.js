function displayScreenDetails(screenName) {
	document.getElementById("screenNo").innerHTML = screenName.toUpperCase();  
	var userDetails = document.getElementById("screenName").innerHTML;
	var userDetailsScreenName = userDetails.toUpperCase();
	document.getElementById("screenName").innerHTML = userDetailsScreenName;
	document.getElementById("screenName").style.fontSize = "22px";
	document.getElementById("screenNo").style.fontSize = "22px";
}



/*function displayScreenDetails(screenID,screenName) {
	document.getElementById("screenNo").innerHTML = screenID + " - " +screenName.toUpperCase();  
	var userDetails = document.getElementById("screenName").innerHTML;
	var userDetailsScreenName = userDetails.toUpperCase();
	document.getElementById("screenName").innerHTML = userDetailsScreenName;
	document.getElementById("screenName").style.fontSize = "22px";
	document.getElementById("screenNo").style.fontSize = "22px";
}*/