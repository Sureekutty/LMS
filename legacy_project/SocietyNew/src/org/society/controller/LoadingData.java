package org.society.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.Scanner;


import org.json.JSONObject;
import org.society.dto.MembershipDto;
import org.society.service.GenericDetailsService;
import org.society.service.LoanApplicationService;
import org.society.util.DataBaseConnectionForNewDB;

 class LoadingData {

	public static void main(String[] args) throws Exception {
		

		DateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm");
		Date d = sdf.parse("10-04-2021 12:10");		
		
		Connection connection6 =null;		
			connection6=DataBaseConnectionForNewDB.getConnectionForSyBase();		
		/*			 
				String sqlQuery = "{call speccs.SP_Loans(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";				
				CallableStatement cStatement = connection6.prepareCall(sqlQuery);				
				FileInputStream fis=new FileInputStream("E:/sqlsociety.txt");
				double loanEligbleAmount = 0;
		          Scanner sc=new Scanner(fis);
		          int count=0;
		          while(sc.hasNextLine()){
		        	  String linedata=sc.nextLine();
		        	  String data[]=linedata.split(",");		        	  
		     		 String sql = "SELECT * FROM speccs.Members  where MemEmpCode='"+data[0]+"'";
					 CallableStatement cs1 = connection6.prepareCall(sql);
					ResultSet rs = cs1.executeQuery();
				String MemAccNo="";
				int thriftbal=0;				
					if(rs.next()){
						count++;
						MemAccNo=rs.getString("MemAccNo").trim();						
						  LoanApplicationService loanApplicationService = new LoanApplicationService();
			        		GenericDetailsService genericDetailsService  =  new GenericDetailsService();			        	  
			        	  LinkedList<MembershipDto> memberInformation = loanApplicationService.getMemberInformation("", "SOCIETYMEM", "ACTIVE",MemAccNo);
			        	  MembershipDto membershipDto = memberInformation.get(0);			          
			        	  int noOfTimesLoanElgAmt = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("101", "Value"));
							int basicPay = membershipDto.getBasicPay();
							thriftbal=membershipDto.getThriftAmount();							
							loanEligbleAmount = noOfTimesLoanElgAmt*basicPay;					
							int maxLoanAmtAddedSocietyRule = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("106", "Value"));
							int maxLoanAmtSocietyRule = (int) Double.parseDouble(genericDetailsService.getSocietyRuleValue("107", "Value"));
							if(loanEligbleAmount > maxLoanAmtSocietyRule)
								loanEligbleAmount = maxLoanAmtSocietyRule;
							if(loanEligbleAmount < maxLoanAmtAddedSocietyRule)
								loanEligbleAmount = maxLoanAmtAddedSocietyRule;
							int loanAmount =Integer.parseInt(data[1])+Integer.parseInt(data[3]);
							int installmentNumber =100;
							int installmentAmount =((loanAmount/installmentNumber)/100)*100;							
							int minimumThriftAmount = (loanAmount * 20 )/100;
								minimumThriftAmount =(minimumThriftAmount/100)*100;
							int thriftAmount =thriftbal;
							int balance =  minimumThriftAmount - thriftAmount;							
							cStatement.setString(1, "SAVE"); 
							cStatement.setString(2,MemAccNo); 
							cStatement.setString(3,"");   
							cStatement.setString(4, "LTL");
							cStatement.setString(5, "PERSONAL");  
							cStatement.setInt(6, 100);  
							cStatement.setInt(7, Integer.parseInt(data[3])); 
							cStatement.setInt(8, 0); 
							cStatement.setString(9,"");  
							cStatement.setInt(10, loanAmount);   
							cStatement.setString(11, "04/01/2021"); 
							cStatement.setFloat(12, 8);  
							cStatement.setString(13, ""); 
							cStatement.setString(14, ""); 
							cStatement.setString(15, ""); 
							cStatement.setString(16,"SH13875"); 
							cStatement.setString(17,"REMARKS"); 
							cStatement.setString(18,"192.168.105.111"); 							
							cStatement.registerOutParameter(19, Types.VARCHAR);
							
							cStatement.executeUpdate();
				            System.out.println(MemAccNo +"    Success "+data[0]+"   "+count);				
						}		        	        
		          }
		          sc.close();*/
			
			
			
			FileInputStream fis=new FileInputStream("E:/sqlsociety.txt");
			double loanEligbleAmount = 0;
			float interestRateloan=0;
	          Scanner sc=new Scanner(fis);
	          String loanaccno="";
	          int noofinstall=0;
	          String Loansancamt="";
	          String MemAccNo="";
	          float interestamount=0;
	          String noofinstallpaid="";
	          String data[] = null;
	          while(sc.hasNextLine()){
	        	  String linedata=sc.nextLine();
	        	   data=linedata.split(",");
	        	  
	        	  
	        	  String sql = "SELECT * FROM speccs.Members  where MemEmpCode='"+data[0]+"'";
					 CallableStatement cs1 = connection6.prepareCall(sql);
					ResultSet rs = cs1.executeQuery();
				
				
					if(rs.next()){
						
						MemAccNo=rs.getString("MemAccNo").trim();
					
	        	  
	        		String Query = "SELECT * FROM speccs.Loans where MemAccNo='"+MemAccNo+"'";
	    			
	        		CallableStatement prepareCall = connection6.prepareCall(Query);

					ResultSet resultSet = prepareCall.executeQuery();
					
					if(resultSet.next()) {

						loanaccno=resultSet.getString("LoanAccNo");
						noofinstall=resultSet.getInt("NoOfInstallments");
						Loansancamt=""+resultSet.getInt("LoanSanctionAmount");
						noofinstallpaid=""+resultSet.getInt("MonthlyInstallments");

					} 
					
				
					GenericDetailsService genericDetailsService = new GenericDetailsService();
				     interestRateloan = genericDetailsService.getInterestRatesloan("04/01/2021","LTL",MemAccNo);
					System.out.println(interestRateloan);
					 interestamount=Integer.parseInt(data[3])*(interestRateloan)*30/36500;
	          
		
			String query="{call speccs.SP_LoanRecovery ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
				
			CallableStatement cStatement = connection6.prepareCall(query);
			 
		
			cStatement.setString(1, "SAVE");
			cStatement.setString(2, loanaccno);
			cStatement.setString(3, "LTL");
			cStatement.setString(4, "04/01/2021");
			cStatement.setFloat(5, interestRateloan);
			cStatement.setInt(6, noofinstall);
			cStatement.setString(7, Loansancamt);
			cStatement.setString(8, "04/01/2021");
			cStatement.setString(9, noofinstallpaid);
			cStatement.setInt(10, Integer.parseInt(data[3]));
			cStatement.setString(11, ""+interestRateloan);
			cStatement.setString(12, "CASH");
			cStatement.setInt(13, Integer.parseInt(data[3]));
			cStatement.setFloat(14, interestamount);
			cStatement.setString(15, "");
			cStatement.setString(16, "SH13875");
			cStatement.setString(17, MemAccNo);
			cStatement.setString(18, "192.168.105.111");
			cStatement.setInt(19, Integer.parseInt(data[1]));
			
			cStatement.registerOutParameter(20, Types.VARCHAR);
			cStatement.executeUpdate();
			
			System.out.println(MemAccNo +"    Success "+data[0]);
	}
	          }
    sc.close();
	}

}
