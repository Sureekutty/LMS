package org.society.controller;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.LinkedList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.society.util.DataBaseConnectionForNewDB;

import com.mysql.jdbc.PreparedStatement;

@WebServlet("/LoanProcessController")
public class LoanProcessController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		JSONObject jsonObject = null;
		String incomingRequest = request.getParameter("req");
		HttpSession session = request.getSession();
		Connection con = null;
		Connection conn = null;
		Connection conn1 = null;
		CallableStatement prepareCall = null;
		CallableStatement prepareCall1 = null;
		LinkedList<String> list = null;
		if ("loanAppNo".equalsIgnoreCase(incomingRequest)) {

			String memAccNo = request.getParameter("memAccNo");
//			System.out.println(memAccNo+" member account number");
			
			try {
				con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String Query = "speccs.SP_LoanProcess 'LOANPROCESS','',0,'"+memAccNo+"','','','',0,0,''";
//			System.out.println(Query);
				prepareCall = con.prepareCall(Query);

				ResultSet resultSet = prepareCall.executeQuery();
				list = new LinkedList<String>();

				while (resultSet.next()) {
//					System.out.println(resultSet.getString("LoanAccNo"));
					list.add(resultSet.getString("LoanAccNo"));

				}
				jsonObject = new JSONObject();
				jsonObject.put("loanAppNo", list);
				response.getWriter().write(jsonObject.toString());
				
			}

			catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException
					| JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != prepareCall)
					try {
						prepareCall.close();
					} catch (SQLException e) {

						e.printStackTrace();
					}
				if (null != con)
					try {
						con.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}

		}

		if ("SettlementAmt".equalsIgnoreCase(incomingRequest)) {
			
			
			JSONObject jsonObject2 = null;
			String LoanAppNo = request.getParameter("LoanAppNo");
			String date = request.getParameter("date");
			try {
				date=new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(date));
			} catch (ParseException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			try {
				con = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String Query = "{call  speccs.SP_LoanInfo(?,?,?,?,?)}";
                
				prepareCall = con.prepareCall(Query);
				prepareCall.setString(1, LoanAppNo);
				prepareCall.setString(2, date);
				prepareCall.registerOutParameter(3, Types.NUMERIC);
				prepareCall.registerOutParameter(4, Types.NUMERIC);
				prepareCall.registerOutParameter(5, Types.NUMERIC);
				prepareCall.executeUpdate();

				float P_Bal = prepareCall.getFloat(4);
	
				float I_Bal = prepareCall.getFloat(5);
				//System.out.println("I "+I_Bal);
				
				list = new LinkedList<String>();
				list.add(String.valueOf(P_Bal));
				list.add(String.valueOf(I_Bal));
				


				jsonObject2 = new JSONObject();
				if (list.size() > 0) {
					jsonObject2.put("ERROR", "N");
					jsonObject2.put("loanAppNo", list);
				}

			} catch (SQLException e) {

				String message = e.getMessage();
				boolean b = message.contains("sanctioned/active");
				String errMsg = "This is sanctioned loan";
				String Msg = null;
				if (b) {
					Msg = errMsg;
				}
				jsonObject2 = new JSONObject();
				try {
					jsonObject2.put("ERROR", Msg);
				} catch (JSONException e1) {

					e1.printStackTrace();
				}

			}

			catch (InstantiationException | IllegalAccessException | ClassNotFoundException | JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != prepareCall)
					try {
						prepareCall.close();
					} catch (SQLException e) {

						e.printStackTrace();
					}
				if (null != con)
					try {
						con.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}
			response.getWriter().write(jsonObject2.toString());

		}
		if ("getInterest".equalsIgnoreCase(incomingRequest)) {

			String loanType = request.getParameter("loanType");
			try {
				String interestRate;
				conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String query ="{CALL speccs.Sp_getInterestRates (?,?,?,?,?)}";
				CallableStatement cs1 = conn.prepareCall(query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
				cs1.setString(1, "Value");
				cs1.setString(2, loanType);
				cs1.setInt(3, 0);
				cs1.registerOutParameter(4, Types.NUMERIC);
				cs1.setString(5, "");
				int rs2 = cs1.executeUpdate();
				DecimalFormat df = new DecimalFormat();
				df.setMinimumFractionDigits(2);
				df.setMaximumFractionDigits(2);
				
				 interestRate = df.format(cs1.getFloat(4));
//				 System.out.println("interestRate"+interestRate+"|"+Types.NUMERIC+"|"+loanType);
				 
				 
				jsonObject = new JSONObject();
				jsonObject.put("Interest", interestRate);
				response.getWriter().write(jsonObject.toString());
			}
			catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException
					| JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != prepareCall)
					try {
						prepareCall.close();
					} catch (SQLException e) {

						e.printStackTrace();
					}
				if (null != conn)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}

		}
		if ("getNoOfInst".equalsIgnoreCase(incomingRequest)) {

			String LoanAppNo = request.getParameter("LoanAppNo");
			String MemAccNo = request.getParameter("MemAccNo");
			
			LinkedList list1 = new LinkedList();
			try {
				
				conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
				if(null!=MemAccNo&&null!=LoanAppNo){
				
				String Query = "select l.NoOfInstallments FROM  speccs.Loans l where l.LoanAccNo=? AND l.MemAccNo=?";

				
				java.sql.PreparedStatement pstmt = conn.prepareStatement(Query);
				pstmt.setString(1, LoanAppNo);
				pstmt.setString(2, MemAccNo);

				ResultSet resultSet = pstmt.executeQuery();

				while (resultSet.next()) {

					list1.add(resultSet.getString("NoOfInstallments"));
				}
				}

				String query1 = "SELECT r.RuleValue FROM speccs.Rules r WHERE  r.RuleCode=?";
				
				java.sql.PreparedStatement pstmt1 = conn.prepareStatement(query1);
				pstmt1.setString(1, "111");
				
				ResultSet result = pstmt1.executeQuery();
				

				while (result.next()) {

					list1.add(result.getInt("RuleValue"));

				}
				jsonObject = new JSONObject();
				jsonObject.put("NoOfInst", list1);
				response.getWriter().write(jsonObject.toString());
			}

			catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException
					| JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != prepareCall)
					try {
						prepareCall.close();
					} catch (SQLException e) {

						e.printStackTrace();
					}
				if (null != conn)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}

		}
		if ("getInstAmnt".equalsIgnoreCase(incomingRequest)) {

			String LoanAppNo = request.getParameter("LoanAppNo");
			String MemAccNo = request.getParameter("MemAccNo");
			
			LinkedList list1 = new LinkedList();
			try {
				
				conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
				if(null!=MemAccNo&&null!=LoanAppNo){
				
				String Query = "select l.MonthlyInstallments FROM  speccs.Loans l where l.LoanAccNo=? AND l.MemAccNo=?";

				
				java.sql.PreparedStatement pstmt = conn.prepareStatement(Query);
				pstmt.setString(1, LoanAppNo);
				pstmt.setString(2, MemAccNo);

				ResultSet resultSet = pstmt.executeQuery();

				while (resultSet.next()) {

					list1.add(resultSet.getString("MonthlyInstallments"));
					list1.add(resultSet.getString("MonthlyInstallments"));
				}
				}

				jsonObject = new JSONObject();
				jsonObject.put("NoOfInst", list1);
				response.getWriter().write(jsonObject.toString());
			}

			catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException
					| JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != prepareCall)
					try {
						prepareCall.close();
					} catch (SQLException e) {

						e.printStackTrace();
					}
				if (null != conn)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}

		}

		if ("UpdateInstallment".equalsIgnoreCase(incomingRequest)) {
			try {
			String LoanAppNo = request.getParameter("LoanAppNo");
			String MemAccNo = request.getParameter("MemAccNo");
			String Option = request.getParameter("Option");
			String NoOfIn = request.getParameter("NoOfInst");
			String RuleVal = request.getParameter("RuleValue"); 
			 
			 
			String pribalance = request.getParameter("pribalance");
			int priBal = (int)(Float.parseFloat(pribalance));
			String intAmount = request.getParameter("intAmount");
			int interestAmnt = (int)(Float.parseFloat(intAmount));
			String date = request.getParameter("date");
			date=new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(date));
			
			int NoOfInst=Integer.parseInt(NoOfIn);
			int RuleValue=Integer.parseInt(RuleVal);
			String ipaddress=request.getRemoteHost();
			if(NoOfInst>RuleValue && Option.equals("update")){
				jsonObject = new JSONObject();
				jsonObject.put("error", "Y");
			response.getWriter().write(jsonObject.toString());
			return;
			}
			if(NoOfInst<RuleValue && Option.equals("UpdateMonInstAmnt")){
				jsonObject = new JSONObject();
				jsonObject.put("error", "Y");
			response.getWriter().write(jsonObject.toString());
			return;
			}
			String userId = (String) session.getAttribute("EMPLOYEECODE");
			
			
		
				conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String Query = "{call  speccs.SP_LoanProcess(?,?,?,?,?,?,?,?,?,?)}";
				
				prepareCall = conn.prepareCall(Query);
				
				prepareCall.setString(1, Option);
				prepareCall.setString(2, LoanAppNo);
				prepareCall.setInt(3, NoOfInst);
				prepareCall.setString(4, MemAccNo);
				prepareCall.setString(5, userId);
				prepareCall.setString(6, ipaddress);
				prepareCall.registerOutParameter(7, Types.VARCHAR);
				prepareCall.setInt(8, priBal);
				prepareCall.setInt(9, interestAmnt);
				prepareCall.setString(10, date);

				boolean resultSet = prepareCall.execute();

				if (!resultSet) {
					jsonObject = new JSONObject();
					jsonObject.put("success", "Y");
				} else {
					jsonObject.put("success", "N");
				}
				response.getWriter().write(jsonObject.toString());
			
			}
			catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException
					| JSONException | ParseException e) {
				e.printStackTrace();
			} finally {
				if (null != prepareCall)
					try {
						prepareCall.close();
					} catch (SQLException e) {

						e.printStackTrace();
					}
				if (null != conn)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}

		}

		if ("Settlement".equalsIgnoreCase(incomingRequest)) {

			String LoanAppNo = request.getParameter("LoanAppNo");
			String MemAccNo = request.getParameter("MemAccNo");
			System.out.println(MemAccNo);
			String Option = request.getParameter("Option");
			String userId = (String) session.getAttribute("EMPLOYEECODE");
			String ipaddress=request.getRemoteHost();
			String pribalance = request.getParameter("pribalance");
			int priBal = (int)(Float.parseFloat(pribalance));
			String intAmount = request.getParameter("intAmount");
			int interestAmnt = (int)(Float.parseFloat(intAmount));
//			System.out.println(priBal+" -- "+interestAmnt);
			String date = request.getParameter("date");
			try {
				date=new SimpleDateFormat("MM/dd/yyyy").format(new SimpleDateFormat("dd/MM/yyyy").parse(date));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			try {
				conn1 = DataBaseConnectionForNewDB.getConnectionForSyBase();
				String Query = "{call  speccs.SP_LoanProcess(?,?,?,?,?,?,?,?,?,?)}";
				
				prepareCall1 = conn1.prepareCall(Query);
				prepareCall1.setString(1, Option);
				prepareCall1.setString(2, LoanAppNo);
				prepareCall1.setInt(3, 0);
				prepareCall1.setString(4, MemAccNo.split("-")[0]);
				prepareCall1.setString(5, userId);
				prepareCall1.setString(6, MemAccNo.split("-")[1]);
				prepareCall1.registerOutParameter(7, Types.VARCHAR);
				prepareCall1.setInt(8, priBal);
				prepareCall1.setInt(9, interestAmnt);
				prepareCall1.setString(10, date);

				int resultSet = prepareCall1.executeUpdate();
				

				if (resultSet > 0) {
					jsonObject = new JSONObject();
					jsonObject.put("success", "Y");
				}

				else {
					jsonObject.put("success", "N");
				}
				response.getWriter().write(jsonObject.toString());
			}

			catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException
					| JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != prepareCall1)
					try {
						prepareCall1.close();
					} catch (SQLException e) {

						e.printStackTrace();
					}
				if (null != conn1)
					try {
						conn1.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
			}

		}

	}
}
