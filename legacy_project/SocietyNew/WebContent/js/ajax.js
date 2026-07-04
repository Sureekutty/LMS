var url;
var methodtype;
var params;
var handelerfunction;
var xmlhttp;
var result;
function ajaxCallver(methodtype,params,url,handelerfunction){
		
	if(window.XMLHttpRequest){
		
		xmlhttp=new XMLHttpRequest();
		
	}else
		{
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		
		}
	
	if(methodtype == 'POST'){
		
		
		xmlhttp.open(methodtype, url+params, true);
		xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		xmlhttp.send();
	}
	else if(methodtype == 'GET'){
		xmlhttp.open(methodtype, url+params, true);
		xmlhttp.send();
	}
	
	
	xmlhttp.onreadystatechange=handelerfunction;
}




