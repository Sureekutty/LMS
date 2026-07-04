<%@page import="java.sql.Timestamp"%>
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
 CallableStatement stmt = null,stmt1=null;
 ResultSet rs=null,rs1=null;
 String empCode =(String) session.getAttribute("EMPLOYEECODE");
 try{
 String query="Select * from speccs.Members where MemEmpCode='"+empCode+"'";
 String query1 = "Select convert(DATE,TransactionDate,120) as TransactionDate,Amount,ModeOfPayment,ThriftBalance from speccs.ThriftTransactions where MemAccNo=(Select MemAccNo from speccs.Members where MemEmpCode='"+empCode+"') ORDER BY TransactionDate DESC";
 con = DataBaseConnectionForNewDB.getConnectionForSyBase();
 stmt = con.prepareCall(query);
 stmt1=con.prepareCall(query1);
 rs=stmt.executeQuery();
 rs1=stmt1.executeQuery();
 %>
  <div class="modal fade" id="employeeModal" tabindex="-1" role="dialog" aria-labelledby="employeeModalLabel">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <!-- Modal Header -->
        <div class="modal-header">
          <button type="button" class="close"  data-dismiss="modal" aria-label="Close" >
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title" id="employeeModalLabel">Employee Thrift Details</h4>
        </div>

        <!-- Modal Body -->
        <div class="modal-body">
          <!-- Employee Details -->
          <div class="well">
          <% if(rs.next()) { %>
            <p><strong>Name:</strong> <%= rs.getString("MemName") %></p>
            <p><strong>Designation:</strong> <%= rs.getString("Designation") %></p>
            <p><strong>Joining Date:</strong> <%= new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(rs.getString("MemDate")))%></p>
          </div>
			<% } %>

          <!-- Loan Details Table -->
          <div>
            <table class="table table-bordered table-striped">
              <thead>
                <tr>
                  <th>Thrift Transaction Date</th>
                  <th>Thrift Subscription Amount</th>
                  <th>Thrift Balance</th>
                  <th>Mode of Payment</th>
                </tr>
              </thead>
              <tbody>
             <% int count=0;while(rs1.next()){ count++; %>
                <tr>
                  <td align="center"><%= new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(rs1.getString("TransactionDate"))) %></td>
                  <td align="center"><%= rs1.getString("Amount") %></td>              
				 <td align="center"> <%= rs1.getString("ThriftBalance") %>  </td>
				 <td align="center"> <%= rs1.getString("ModeOfPayment") %>  </td>
                	  </tr>
                 	<% } if(count<=0) { count=0;%>
                 	<tr><td colspan="3" align="center">No Thrift Data Available</td></tr>
          <%}if(con!=null){
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
