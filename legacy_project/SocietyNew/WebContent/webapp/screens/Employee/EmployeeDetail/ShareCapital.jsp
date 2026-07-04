<%@page import="java.sql.CallableStatement"%>
<%@page import="org.society.util.DataBaseConnectionForNewDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page 
	import="javax.swing.*,java.awt.*,java.io.*,java.util.*,java.text.*"%>

 <!-- to show the popup detail -->
<!-- Modal -->
 <%
 	Connection con=null;
 CallableStatement stmt = null;
 ResultSet rs=null;
 String empCode =(String) session.getAttribute("EMPLOYEECODE");
 try{
 String query1="SELECT m.MemName,m.Designation, m.MemDate,mact.ShareAmount,mact.NoOfShares FROM speccs.Members m,speccs.MemberAccount mact WHERE m.MemAccNo=mact.MemAccNo AND m.MemEmpCode='"+empCode+"'";
 con = DataBaseConnectionForNewDB.getConnectionForSyBase();
 stmt = con.prepareCall(query1);
 rs=stmt.executeQuery();
 %>
  <div class="modal fade" id="employeeModal" tabindex="-1" role="dialog" aria-labelledby="employeeModalLabel">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <!-- Modal Header -->
        <div class="modal-header">
          <button type="button" class="close"  data-dismiss="modal" aria-label="Close" >
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title" id="employeeModalLabel">Employee Share Details</h4>
        </div>

        <!-- Modal Body -->
        <div class="modal-body">
          <!-- Employee Details -->
          <div class="well">
          <% if(rs.next()) {
          String date = new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(rs.getString("MemDate")));%>
            <p><strong>Name:</strong> <%= rs.getString("MemName") %></p>
            <p><strong>Designation:</strong> <%= rs.getString("Designation") %></p>
            <p><strong>Joining Date:</strong> <%= date %></p>
          </div>


          <!-- Loan Details Table -->
          <div>
            <table class="table table-bordered table-striped">
              <thead>
                <tr>
                  <th>Share Capital Holding</th>
                  <th>Number of Shares</th>
                  <th>Max Share Capital Eligibility Amount</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td align="center"><%= rs.getString("ShareAmount") %></td>
                  <td align="center"><%= rs.getString("NoOfShares") %></td>
                 <%  int year=Integer.parseInt(date.split("/")[2]);
                	 int month=Integer.parseInt(date.split("/")[1]);
                	 Calendar calendar = Calendar.getInstance();
                 	 int currentMonth=calendar.get(Calendar.MONTH),currentYear=calendar.get(Calendar.YEAR);                 	 
                 	 if((currentYear-year)>=9 ||( (currentYear-year)==8 && (currentMonth-month)>-1 )){%>
             		<td align="center">  7500   </td>                
                <% }
                 	 else{%>
                 	 <td align="center">  6500   </td>
                	  </tr>
                 	<% }}
          if(con!=null){
				 con.close();
				}
          }catch(Exception e2){
				System.out.println("  EXCEPTION     "+e2);
			
				e2.printStackTrace();
				if(con!=null){
					 con.close();
					}
			
			}%>               
              </tbody>
            </table>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-default"  data-dismiss="modal" >Close</button>
        </div>
      </div>
    </div>
  </div>
