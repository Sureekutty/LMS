<html>
<body>
	<%@page language="java"
		import="com.google.gson.JsonObject,com.google.gson.JsonParser,java.io.BufferedReader,java.io.IOException,java.io.InputStreamReader,java.net.HttpURLConnection,java.net.MalformedURLException,java.net.URL,jdk.nashorn.internal.parser.JSONParser;"%>
	<%
System.out.println("===============VALIDATION STARTED==============");
String userDetailsjson=(String)request.getParameter("txtuserjson");
JsonParser parserx=new JsonParser();

JsonObject jobjx=(JsonObject)parserx.parse(userDetailsjson);
//String userDetailsjson=(String)request.getParameter("userDetails");
String userid=jobjx.get("employeeId").getAsString();
String usertoken=jobjx.get("token").getAsString(); 
String restserviceipaddress=jobjx.get("restserviceipaddress").getAsString(); 
 //out.println(userDetailsjson);
 
System.out.println("===============INDEX userDetailsjson=============="+userDetailsjson);
//System.out.println("===============INDEX passwd=============="+jobjx.get("passwd").getAsString());
//System.out.println("===============INDEX userid=============="+userid);
//System.out.println("===============INDEX usertoken=============="+usertoken);

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
 
 String fastforward="false";

		try {
			//System.out.println("2");

			                 URL url = new URL(restserviceipaddress+"/RestServices/webresources/helloWorldJson/validate?&uid="+userid+"&token="+usertoken);
							 			System.out.println("2.1");
			                 HttpURLConnection conn = (HttpURLConnection) url.openConnection();
							 			System.out.println("2.2");
			conn.setRequestMethod("GET");
						//System.out.println("2.3");
			conn.setRequestProperty("Accept", "application/json");
						//System.out.println("2.4");

			if (conn.getResponseCode() != 200) {
				System.out.println("2.4.1 error");
				System.out.println("usertoken==>"+usertoken);
				System.out.println("userid==>"+userid);
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
							 
			}

			                 BufferedReader br = new BufferedReader(new InputStreamReader(
					(conn.getInputStream())));
							 			System.out.println("2.6");

			String output;
			System.out.println("Output from Server .... \n");
                        String json="";
			while ((output = br.readLine()) != null) {

				//System.out.println(output);
                                json+=output;
			}
                        System.out.println("json "+json);
                        JsonParser parser=new JsonParser();
                        
                        JsonObject jobj=(JsonObject)parser.parse(json);
                        
                        System.out.println("Json object"+jobj);
                        System.out.println(jobj.get("valid"));
                        
						fastforward=jobj.get("valid").getAsString();

			
			conn.disconnect();

		}
		catch (Exception e) {
//out.println(e);
			e.printStackTrace();
		}

	 
 
System.out.println("===============VALIDATING TOKEN ENDED==============");

 
   

String ecode=userid;
if(fastforward.equals("true"))
{
%>

	<centre> Please wait... </centre>


	<script>
//	alert('IN');
	var frm = document.createElement("form");
	frm.method="POST";
	frm.name="EMP";
	frm.action="interface.jsp";
	document.body.appendChild(frm);
	
	//alert(">>>>"+frm)
	
	var in1=document.createElement("input");
	in1.type='hidden';in1.name='ecd';in1.value='<%=ecode%>';
	
	frm.appendChild(in1);
	
	frm.submit();
	
	</script>
	<%
}

else{
	
	%>
	<centre> Login Failed. Please try again. <a
		href="http://192.168.50.192/intranet/index.jsp">Click here</a> </centre>
	<%
}
	System.out.println("===============VALIDATION.JSP ENDED==============");

%>

</body>
</html>
