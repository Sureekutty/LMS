package org.society.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.society.util.DataBaseConnectionForNewDB;



@WebServlet("/ExcelImport")
public class ExcelImport extends HttpServlet {

	static String RollNo;
	static String RegNo;
	static String Name;
	static String SCode;
	static String Email;
	static String Dob;
	static String Mobile;
	
	static String tableName;
	static String advtNo;
	static String postCode;
	static String dbName;
	
	static String savePath;
	static Properties props = null;
	static FileInputStream fis;
	static String jdbcdriver;
	static String url;
	static String username;
	static String password;
	File directory = null;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		PrintWriter out = resp.getWriter();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Workbook workbook = null;
		String excelFilePath = null;
		String FilePath="";
		Connection connection = null;
		int i = 0;
		
		String sql = null;
		int count = 0;
		int a = 0;
		
		String requ = req.getParameter("req");
		if (requ.equals("SENDSMS")) {
		try {
			connection=DataBaseConnectionForNewDB.getConnectionForCowaa();
			Connection conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
				excelFilePath = "H:/Schoolsms/Society.xlsx";
				String bankaccno = null;
				String doj= null;
				String mnno = null;
				String scno = null;
				String name = null;
				String sharebal="";
				String Thriftobl="";
				String SubSc="";
				String Divisionname=null;
				String Designation=null;
			 	String Phone=null;
              	String Office=null;
              	String Emailid=null;
              	int Basicpay;
              	String dob=null;
              	String Superannuatndt=null;
				
				
				workbook = WorkbookFactory.create(new File(excelFilePath));
			
				for (int j = 0; j < workbook.getNumberOfSheets(); j++) {
					Sheet sheet = workbook.getSheetAt(j);
					
					DataFormatter dataFormatter = new DataFormatter();
		
					Row row = null;
					for (i = 1; i <= sheet.getLastRowNum(); i++) {
						
						row = sheet.getRow(i);
					
						bankaccno = dataFormatter.formatCellValue(row.getCell(0));
						doj = dataFormatter.formatCellValue(row.getCell(1));
						mnno = dataFormatter.formatCellValue(row.getCell(2));
						scno  = dataFormatter.formatCellValue(row.getCell(3));
						name = dataFormatter.formatCellValue(row.getCell(4));
						sharebal =dataFormatter.formatCellValue(row.getCell(5));
					
						Thriftobl = dataFormatter.formatCellValue(row.getCell(6));
						SubSc = dataFormatter.formatCellValue(row.getCell(7));
						
						int ShareObl=Integer.parseInt(sharebal);
						int ThriftObl=Integer.parseInt(Thriftobl);
						int NoOfShares=ShareObl/10;
						int Subscript=Integer.parseInt(SubSc);
	     //System.out.println(bankaccno+"-"+doj+"-"+mnno+"-"+scno+"-"+name+"-"+sharebal+"-"+Thriftobl+"-"+SubSc);
	           String query="select EMPLOYEECODE,EMPLOYEENAME,"
	           		+ "(select DIVNFULLNAME from TBAD_DIVISION where DIVNCODE=e.DIVNCODE) AS DIVISION,"
	           		+ " (select DESGFULLNAME from TBAD_DESIGNATIONS where DESGCODE =e.DESGCODE and PAYCOMMISSIONNO='7' and GRADECODE=e.GRADECODE) AS DESIGNATION,"
	           		+ " (select MOBILENOOFFC from TBAD_EMPPHONENUMBER where EMPLOYEECODE=e.EMPLOYEECODE) AS PHONE,"
	           		+ "  (select LANDLINEOFFC from TBAD_EMPPHONENUMBER where EMPLOYEECODE=e.EMPLOYEECODE)  AS OFFICE,"
	           		+ "  (select EMAILIDOFFC from TBAD_EMPPHONENUMBER where EMPLOYEECODE=e.EMPLOYEECODE) AS EMAILID,"
	           		+ " (select BASICPAY from TBAD_BIODATA where EMPLOYEECODE=e.EMPLOYEECODE) AS BASICPAY , "
	           		+ "  (select DATEOFBIRTH from TBAD_BIODATA where EMPLOYEECODE=e.EMPLOYEECODE) DOB, "
	           		+ " (select SUPERANNUATNDT from TBAD_BIODATA where EMPLOYEECODE=e.EMPLOYEECODE) AS RETIREDDATE"
	           		+ " from TBAD_EMPLOYEE e where EMPLOYEECODE ='"+scno+"'";
		System.out.println(query);
		            Statement statement = connection.createStatement();
		             ResultSet resultSet = statement.executeQuery(query);
		             
	                  	if(resultSet.next()){
			
	                  	Divisionname=resultSet.getString("DIVISION");
	                   Designation =resultSet.getString("DESIGNATION");
	                   Phone=resultSet.getString("PHONE");
	                   Office=resultSet.getString("OFFICE");
	                   Emailid=resultSet.getString("EMAILID");
	                   Basicpay=resultSet.getInt("BASICPAY");
	                  	dob=resultSet.getString("DOB");
	                  	Superannuatndt=resultSet.getString("RETIREDDATE");
	                  	
	                  	
	                  	if(Divisionname==null || Divisionname=="")
	                  		Divisionname="-";
	                  	if(Designation==null || Designation=="")
	                  		Designation="-";
	                	if(Phone==null || Phone=="")
	                		Phone="-";
	                	if(Office==null || Office=="")
	                		Office="-";   
	                	if(Emailid==null || Emailid=="")
	                		Emailid="-"; 
	                	if(dob==null || dob=="")
	                		dob="-";
	                	if(Superannuatndt==null || Superannuatndt=="")
	                		Superannuatndt="-";
	                	
String sqlQuery = "{call speccs.SP_Membertest(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";

CallableStatement cStatement = conn.prepareCall(sqlQuery);
cStatement.setString(1, "SUBMIT");
cStatement.setString(2, "");
cStatement.setString(3, scno);
cStatement.setString(4, name);
cStatement.setString(5, "pan");
cStatement.setString(6, "12345678910");
cStatement.setString(7, Emailid);
cStatement.setString(8, Designation);
cStatement.setString(9, Divisionname);
cStatement.setString(10, Phone);
cStatement.setString(11, Office);
cStatement.setString(12, bankaccno);
cStatement.setString(13, "IFSC543215");	
cStatement.setString(14, "SBI");
cStatement.setString(15, "SRIHARIKOTA");
cStatement.setDouble(16,Basicpay );
cStatement.setString(17,doj);
cStatement.setString(18,dob );
cStatement.setString(19, Superannuatndt);
cStatement.setString(20,"Care Of" );
cStatement.setString(21,"");
cStatement.setInt(22, NoOfShares);
cStatement.setDouble(23,ThriftObl);
cStatement.setDouble(24,Subscript);
cStatement.setDouble(25, ShareObl);
cStatement.setString(26, "Remarks");
cStatement.setString(27, "SH13875");
cStatement.setString(28, "192.168.105.111");
cStatement.registerOutParameter(29, Types.VARCHAR);
int c1=cStatement.executeUpdate();
String memaccNonew = cStatement.getString(29);

String sqlQuery3 = "speccs.SP_Bankdetails 'SAVE','"+memaccNonew+"','"+bankaccno+"','IFSC543215','SBI','SRIHARIKOTA','SH13875','',''";
PreparedStatement  ps3 = conn.prepareStatement(sqlQuery3); 
					int c2 =ps3.executeUpdate();
					System.out.println("Result: 1-"+c1+" 2-"+c2+"-------"+scno+":"+name+":"+"null :"+"null :"+Emailid+":"+Designation+":"+Divisionname+":"+Phone+":"+Office+":"+bankaccno+" : null :"+"null :"+"null:"+"null :"+Basicpay+":"+doj+":"+dob+":"+Superannuatndt+"ACTIVE :"+"Care Of :"+"null :"+"Remarks :"+"SH13875 :"+"null");
	                    	}

					        }
				            }
	out.print("Calling");
		} catch (Exception e) {
			e.printStackTrace();
			String excp = e.getMessage();
			System.out.println(excp);
			
		}
			
		}
	
	}

}
