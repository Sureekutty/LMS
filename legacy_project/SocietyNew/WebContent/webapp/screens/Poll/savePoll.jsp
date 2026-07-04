<%@page import="groovy.json.JsonBuilder"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="org.society.util.DataBaseConnectionForNewDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.io.*,java.util.*,java.text.*"%>


 <%
 	Connection con=null;
 JSONObject obj = null;
 CallableStatement stmt = null;
 ResultSet rs=null;
 String empCode =request.getParameter("memcode").trim();
 String poll =request.getParameter("vote").trim();
 
 int pollOpted=0;
 if(poll.equals("Bank"))
	 pollOpted=1;
 if(poll.equals("Loan Account"))
	 pollOpted=2;
 if(poll.equals("Thrift Account"))
	 pollOpted=3;			 
 //System.out.println("  code     "+empCode+" vote "+poll);
 try{
 String query="UPDATE speccs.ThriftIntPoll SET ThriftIntOpt='"+poll+"',ThriftOption="+pollOpted+",OptedDate=getdate() WHERE MemEmpCode='"+empCode+"'";
 con = DataBaseConnectionForNewDB.getConnectionForSyBase();
 stmt = con.prepareCall(query);

 int count=stmt.executeUpdate();
 
 if(count>0){
	 obj = new JSONObject();
	 obj.put("SUCCESS", "Y");
	 obj.put("msg", "Data inserted successfully");
 }
 if(con!=null){
				 con.close();
				}
          }catch(Exception e){
				System.out.println("  EXCEPTION     "+e);
				obj=new JSONObject();
				obj.put("SUCCESS", "N");
				 obj.put("msg", "Exception while inserting "+e);
				e.printStackTrace();
				if(con!=null){
					 con.close();
					}
			
			}
 //System.out.println(request.getContextPath());
 response.sendRedirect(request.getContextPath()+"/EmployeeDetail.jsp");
			//response.getWriter().write("SocietyNew/EmployeeDetail.jsp");
			%>  