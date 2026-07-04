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
 String query="SELECT ma.ThriftBalance,l.LoanSanctionAmount FROM speccs.Members m,speccs.MemberAccount ma,speccs.Loans l WHERE m.MemAccNo=ma.MemAccNo AND m.MemAccNo=l.MemAccNo AND m.MemEmpCode='"+empCode+"' AND l.LoanType='LTL'";
 con = DataBaseConnectionForNewDB.getConnectionForSyBase();
 stmt = con.prepareCall(query);
 rs=stmt.executeQuery();
 int loanBal=0,thriftBal=0;
 if(rs.next()){
	 loanBal=rs.getInt("LoanSanctionAmount");
	 thriftBal=rs.getInt("ThriftBalance");
 }
 %>
 <input type="hidden" id='loanbal' name='loanbal'	value=<%=loanBal %>>
 <input type="hidden" id='thriftbal' name='thriftbal'	value=<%=thriftBal %>>
  <div class="modal fade" id="employeeModal" tabindex="-1" role="dialog" aria-labelledby="employeeModalLabel">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <!-- Modal Header -->
        <div class="modal-header">
          <button type="button" class="close"  data-dismiss="modal" aria-label="Close" >
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title" id="employeeModalLabel">Know Your Loan Eligibility</h4>
        </div>

        <!-- Modal Body -->
        <div class="modal-body">
          <!-- Employee Details -->
          <div class="well">
         

          <!-- Loan Details Table -->
          <div>
            <table class="table table-bordered table-striped">

             
                <tr>
                 <td align="left"><label><b>Enter your Basic Pay :</b></label></td>
                  <td align="center"><input type="text" id="basicPay" name="basicPay" /></td>
                  </tr>
                  <tr id="elgAmnt" hidden>
                    <td align="left"><label><b>Current Loan Eligibility Amount :</b></label></td>
                  <td align="center"><input type="text" id="amnt" name="amnt"  disabled="disabled"/></td>            
				 
                </tr>

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
  <%}
 catch(Exception e){
	 System.out.println("  EXCEPTION     "+e);
		e.printStackTrace();
		if(con!=null){
			 con.close();
			}
 }
  %>
<script>
$('#basicPay').change(function() {
	$('#elgAmnt').show();
	var basicPay =this.value;
	basicPay=Number(basicPay);
	var loanBal = Number($('#loanbal').val());
	var thriftBal = Number($('#thriftbal').val());
	//alert(loanBal+" -- "+thriftBal+" -- "+basicPay)
	var elgibilityAmount = (basicPay*28)-loanBal-(0.2*28*basicPay)+thriftBal;
	elgibilityAmount=Math.round(elgibilityAmount);
	$('#amnt').val(elgibilityAmount);
})

</script>