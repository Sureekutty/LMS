package org.society.controller;


import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.society.service.XLGenerator;
import org.society.util.DataBaseConnectionForNewDB;


@WebServlet("/MonthlyRecoveryProcess")
public class MonthlyRecoveryProcess extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String incomingRequest = request.getParameter("req");
		
	

		HttpSession session = request.getSession();
	PrintWriter out = null;
		String sqlQuery = "";
		JSONObject jsonObject = null;
		String userId = (String) session.getAttribute("EMPLOYEECODE");
		try {
			if (!incomingRequest.equals("monthlyrecoverytextfile")) {
				out = response.getWriter();
			}
			
			if(incomingRequest.equalsIgnoreCase("monthlyrecoveryprocess")){
				Connection connection = null;
				try{
					jsonObject = new JSONObject();
				connection = DataBaseConnectionForNewDB.getConnectionForSyBase();	
				String month = request.getParameter("month").trim();
				month = (Integer.parseInt(month)<10)?"0"+month:month;
				String year = request.getParameter("year").trim();
				String Purpose = request.getParameter("Purpose").trim();
				
				String monandyear=month+"/01/"+year;
				System.out.println(monandyear+" "+Purpose);
	         sqlQuery = "EXEC speccs.SP_MonthlyProcess 'GRIDDATA','"+Purpose+"','"+monandyear+"','',0,'','',''";
	           
	          PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
	      	ResultSet res = ps3.executeQuery();
			
			JSONArray array3 = new JSONArray();
			int flag=0;
			while (res.next()) {
				flag=1;
				jsonObject = new JSONObject();
				String MemAccNo=res.getString("Memcode").trim();
				String Emp=res.getString("Empcode").trim()+"-"+res.getString("MemName").trim();
				String Refid=res.getString("Refid").trim();
				String Paycode=res.getString("Purposecode");
				int Salcode=res.getInt("Salcode");
				float amount=res.getFloat("Recoveryamount");
				
				jsonObject.put("MemAccNo", MemAccNo);
				jsonObject.put("Emp", Emp);
				jsonObject.put("Refid", Refid);
				jsonObject.put("Paycode", Paycode);
				jsonObject.put("Salcode", Salcode);
				jsonObject.put("amount", amount);
				array3.put(jsonObject);	
			}
			
			if(flag==0){
				jsonObject.put("PURPOSECODEDETAILS", "N");
				response.getWriter().write(jsonObject.toString());
			}else{
				jsonObject = new JSONObject();
				jsonObject.put("PURPOSECODEDETAILS", array3);
				response.getWriter().write(jsonObject.toString());
			}
			if(connection!=null){
				connection.close();
			}
				}catch(Exception e){
					e.printStackTrace();
					if(connection!=null){
						connection.close();
					}
				}
			}
			

	
	if(incomingRequest.equalsIgnoreCase("recoveryprocess")){
		Connection connection = null;
		try{
		connection=DataBaseConnectionForNewDB.getConnectionForSyBase();
		String month = request.getParameter("month");
		month = (Integer.parseInt(month)<10)?"0"+month:month;
		String year = request.getParameter("year");
		 String monandyear=month+"/01/"+year;
		 String promonth =month+"/01/"+year;
		 System.out.println(monandyear+" "+promonth);
        sqlQuery = "EXEC speccs.SP_MonthlyProcess 'PROCESS','','"+monandyear+"','',0,'"+userId+"','"+promonth+"',''";
      
         PreparedStatement  ps3 = connection.prepareStatement(sqlQuery); 
     	 ps3.executeUpdate();
			response.getWriter().write("Process Successfully");
			if(connection!=null){
				connection.close();
			}
		}catch(Exception e){
			response.getWriter().write("Error Occured  \n"+e);
			if(connection!=null){
				connection.close();
			}
		}
		
			}
	if (incomingRequest.equals("monthlyrecoverytextfile")) {


		String month = request.getParameter("month");
		month = (Integer.parseInt(month)<10)?"0"+month:month;
		String year = request.getParameter("year");
	    String res = request.getParameter("res").trim();
	    //String fileType= (request.getParameter("fileType").trim()).toLowerCase();
	    String purpose[]=res.split(",");
	 
	    String RecDepSub=purpose[0];
	    String LtlPriMonRec=purpose[1];
	    String LtlIntMonRec=purpose[2];
	    String ExlPriMonRec=purpose[3];
	    String ExlIntMonRec=purpose[4];
	    String FdlPriMonRec=purpose[5];
	    String FdlIntMonRec=purpose[6];
	    String ThrMonSub=purpose[7];
/*	    String LtlObl=purpose[8];
	    String ExlObl=purpose[9];
	    String ThrObl=purpose[10];*/
	    String monandyear=month+"-"+year;
	    String monthdate=month+"/01/"+year;

	    
	    //------------------LTL Interest Monthly Recovery--------------\\
		MonthlyRecoveryTextfile.getText(monandyear,LtlIntMonRec,monthdate);
		String fileName=  monandyear+"&"+LtlIntMonRec+".txt";
		response.setContentType("application/txt");	
		File LtlIntMonRec1 = new File(fileName);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setContentLength((int) LtlIntMonRec1.length());
		
	    //--------------------LTL Principal Monthly Recovey----------------\\
		MonthlyRecoveryTextfile.getText(monandyear,LtlPriMonRec,monthdate);
		String fileName1 = monandyear+"&"+LtlPriMonRec+".txt";
		response.setContentType("application/txt");
		File LtlPriMonRec1 = new File(fileName1);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName1);
		response.setContentLength((int) LtlPriMonRec1.length());
		  //--------------------FDL Principal Monthly Recovey----------------\\
		MonthlyRecoveryTextfile.getText(monandyear,FdlPriMonRec,monthdate);
		String fileName3 = monandyear+"&"+FdlPriMonRec+".txt";
		response.setContentType("application/txt");
		File FdlPriMonRec1 = new File(fileName3);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName3);
		response.setContentLength((int) FdlPriMonRec1.length());
		
		
		  //--------------------FDL Interest Monthly Recovey----------------\\
		MonthlyRecoveryTextfile.getText(monandyear,FdlIntMonRec,monthdate);
		String fileName4 = monandyear+"&"+FdlIntMonRec+".txt";
		response.setContentType("application/txt");
		File FdlIntMonRec1 = new File(fileName4);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName4);
		response.setContentLength((int) FdlIntMonRec1.length());
		
		  //--------------------EXL Principal Monthly Recovey----------------\\
		MonthlyRecoveryTextfile.getText(monandyear,ExlPriMonRec,monthdate);
		String fileName5 = monandyear+"&"+ExlPriMonRec+".txt";
		response.setContentType("application/txt");
		File ExlPriMonRec1 = new File(fileName5);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName5);
		response.setContentLength((int) ExlPriMonRec1.length());
	
		  //--------------------EXL Interest Monthly Recovey----------------\\
		MonthlyRecoveryTextfile.getText(monandyear,ExlIntMonRec,monthdate);
		String fileName6 = monandyear+"&"+ExlIntMonRec+".txt";
		response.setContentType("application/txt");
		File ExlIntMonRec1 = new File(fileName6);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName6);
		response.setContentLength((int) ExlIntMonRec1.length());
	
	  //--------------------Recurring Deposit Subscription----------------\\
		MonthlyRecoveryTextfile.getText(monandyear,RecDepSub,monthdate);
		String fileName7 = monandyear+"&"+RecDepSub+".txt";
		response.setContentType("application/txt");
		File RecDepSub1 = new File(fileName7);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName7);
		response.setContentLength((int) RecDepSub1.length());
		
		  //--------------------Thrift Monthly Subscription----------------\\
		MonthlyRecoveryTextfile.getText(monandyear,ThrMonSub,monthdate);
		String fileName8 = monandyear+"&"+ThrMonSub+".txt";
		response.setContentType("application/txt");
		File ThrMonSub1 = new File(fileName8);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName8);
		response.setContentLength((int) ThrMonSub1.length());
		
		//----------------------LTL Balance(OBL)---------------\\
		/*MonthlyRecoveryTextfile.getText(monandyear,LtlObl,monthdate);
		String fileName9 = monandyear+"&"+LtlObl+".txt";
		response.setContentType("application/txt");
		File LtlObl1 = new File(fileName9);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName9);
		response.setContentLength((int) LtlObl1.length());*/
		
		//----------------------EXL Balance(OBL)---------------\\
	/*	MonthlyRecoveryTextfile.getText(monandyear,ExlObl,monthdate);
		String fileName10 = monandyear+"&"+ExlObl+".txt";
		response.setContentType("application/txt");
		File ExlObl1 = new File(fileName10);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName10);
		response.setContentLength((int) ExlObl1.length());*/
		
		//----------------------Thrift Balance(OBL)---------------\\
		/*MonthlyRecoveryTextfile.getText(monandyear,ThrObl,monthdate);
		String fileName11 = monandyear+"&"+ThrObl+".txt";
		response.setContentType("application/txt");
		File ThrObl1 = new File(fileName11);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName11);
		response.setContentLength((int) ThrObl1.length());*/
		
		//----------------------Ending Report Files Generated---------------\\
	    try
	     {
	    
		     ServletOutputStream  servletOutStream=response.getOutputStream();
		    // String zipFile = "H:/SocietyZipFiles/societyzipfile.zip";
		     String[] sourceFiles = {fileName, fileName1,fileName3,fileName4,fileName5,fileName6,fileName7,fileName8};
		     
		     byte[] buffer = new byte[4000];
		    // FileOutputStream fout = new FileOutputStream(zipFile);
			 ByteArrayOutputStream byteArrOutStream=new ByteArrayOutputStream();
		     ZipOutputStream zout = new ZipOutputStream(byteArrOutStream);
		     
	//	     System.out.println(sourceFiles.length);
		     for(int i=0; i < sourceFiles.length; i++)
		     {
		     FileInputStream fin = new FileInputStream(sourceFiles[i]);
		     
		     zout.putNextEntry(new ZipEntry(sourceFiles[i]));
	//	     System.out.println(sourceFiles[i]);
		     int length;
		     
		     while((length = fin.read(buffer)) > 0)
		     {
	//	    	 System.out.println(length+" length "+" fin.read(buffer) "+ fin.read(buffer));
		        zout.write(buffer, 0, length);
		     }
		     zout.closeEntry();
		     fin.close();
		     }
		    zout.close();
			response.setHeader("Content-Type", "application/zip");
			response.setHeader("Content-Disposition", "attachment; filename="+monandyear+".zip");
			response.setContentLength((int) byteArrOutStream.size());
			servletOutStream.write(byteArrOutStream.toByteArray());
			servletOutStream.flush();
			servletOutStream.close();
			byteArrOutStream.close();
	     }
	     catch(IOException ioe)
	     {
	    	System.out.println("IOException :" + ioe);
	     }
	     
	     }
	if(incomingRequest.equalsIgnoreCase("monthlyrecoveryexcelfile")){
		String month = request.getParameter("month");
		month = (Integer.parseInt(month)<10)?"0"+month:month;
		String year = request.getParameter("year");
	    String res = request.getParameter("res").trim();
	    String purpose[]=res.split(",");
	 
	    String RecDepSub=purpose[0];
	    String LtlPriMonRec=purpose[1];
	    String LtlIntMonRec=purpose[2];
	    String ExlPriMonRec=purpose[3];
	    String ExlIntMonRec=purpose[4];
	    String FdlPriMonRec=purpose[5];
	    String FdlIntMonRec=purpose[6];
	    String ThrMonSub=purpose[7];
	    /*String LtlObl=purpose[8];
	    String ExlObl=purpose[9];
	    String ThrObl=purpose[10];*/
	   // String Month = (Integer.parseInt(month)<10)?"0"+month:month;
	    String monandyear=month+"-"+year;
	    String monthdate=month+"/01/"+year;
	    System.out.println(monandyear+" date "+monthdate);
	    //------------------LTL Interest Monthly Recovery--------------\\
		XLGenerator.getExecl(response,monandyear,LtlIntMonRec,monthdate);
		/*String fileName=  monandyear+"&"+LtlIntMonRec+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");	
		File LtlIntMonRec1 = new File(fileName);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setContentLength((int) LtlIntMonRec1.length());*/
		
		 
		
	    //--------------------LTL Principal Monthly Recovey----------------\\
		XLGenerator.getExecl(response,monandyear,LtlPriMonRec,monthdate);
		/*String fileName1 = monandyear+"&"+LtlPriMonRec+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File LtlPriMonRec1 = new File(fileName1);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName1);
		response.setContentLength((int) LtlPriMonRec1.length());*/
		  //--------------------FDL Principal Monthly Recovey----------------\\
		
		/*String fileName3 = monandyear+"&"+FdlPriMonRec+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File FdlPriMonRec1 = new File(fileName3);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName3);
		response.setContentLength((int) FdlPriMonRec1.length());*/
		XLGenerator.getExecl(response,monandyear,FdlPriMonRec,monthdate);
		
		  //--------------------FDL Interest Monthly Recovey----------------\\
		XLGenerator.getExecl(response,monandyear,FdlIntMonRec,monthdate);
		/*String fileName4 = monandyear+"&"+FdlIntMonRec+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File FdlIntMonRec1 = new File(fileName4);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName4);
		response.setContentLength((int) FdlIntMonRec1.length());*/
		
		  //--------------------EXL Principal Monthly Recovey----------------\\
		XLGenerator.getExecl(response,monandyear,ExlPriMonRec,monthdate);
		/*String fileName5 = monandyear+"&"+ExlPriMonRec+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File ExlPriMonRec1 = new File(fileName5);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName5);
		response.setContentLength((int) ExlPriMonRec1.length());*/
	
		  //--------------------EXL Interest Monthly Recovey----------------\\
		XLGenerator.getExecl(response,monandyear,ExlIntMonRec,monthdate);
		/*String fileName6 = monandyear+"&"+ExlIntMonRec+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File ExlIntMonRec1 = new File(fileName6);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName6);
		response.setContentLength((int) ExlIntMonRec1.length());*/
	
	  //--------------------Recurring Deposit Subscription----------------\\
		XLGenerator.getExecl(response,monandyear,RecDepSub,monthdate);
		/*String fileName7 = monandyear+"&"+RecDepSub+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File RecDepSub1 = new File(fileName7);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName7);
		response.setContentLength((int) RecDepSub1.length());*/
		
		  //--------------------Thrift Monthly Subscription----------------\\
		XLGenerator.getExecl(response,monandyear,ThrMonSub,monthdate);
		/*String fileName8 = monandyear+"&"+ThrMonSub+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File ThrMonSub1 = new File(fileName8);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName8);
		response.setContentLength((int) ThrMonSub1.length());*/
		
	/*	//----------------------LTL Balance(OBL)---------------\\
		XLGenerator.getExecl(monandyear,LtlObl,monthdate);
		String fileName9 = monandyear+"&"+LtlObl+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File LtlObl1 = new File(fileName9);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName9);
		response.setContentLength((int) LtlObl1.length());
		
		//----------------------EXL Balance(OBL)---------------\\
		XLGenerator.getExecl(monandyear,ExlObl,monthdate);
		String fileName10 = monandyear+"&"+ExlObl+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File ExlObl1 = new File(fileName10);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName10);
		response.setContentLength((int) ExlObl1.length());
		
		//----------------------Thrift Balance(OBL)---------------\\
		XLGenerator.getExecl(monandyear,ThrObl,monthdate);
		String fileName11 = monandyear+"&"+ThrObl+".xlsx";
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		File ThrObl1 = new File(fileName11);
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName11);
		response.setContentLength((int) ThrObl1.length());*/
		
		//----------------------Ending Report Files Generated---------------\\
	   /* try
	     {
	    
		     ServletOutputStream  servletOutStream=response.getOutputStream();
		    // String zipFile = "H:/SocietyZipFiles/societyzipfile.zip";
		     String[] sourceFiles = {fileName, fileName1,fileName3,fileName4,fileName5,fileName6,fileName7,fileName8,fileName9,fileName10,fileName11};
		     
		     byte[] buffer = new byte[4000];
		    // FileOutputStream fout = new FileOutputStream(zipFile);
			 ByteArrayOutputStream byteArrOutStream=new ByteArrayOutputStream();
		     ZipOutputStream zout = new ZipOutputStream(byteArrOutStream);
		     
	//	     System.out.println(sourceFiles.length);
		     for(int i=0; i < sourceFiles.length; i++)
		     {
		     FileInputStream fin = new FileInputStream(sourceFiles[i]);
		     
		     zout.putNextEntry(new ZipEntry(sourceFiles[i]));
	//	     System.out.println(sourceFiles[i]);
		     int length;
		     
		     while((length = fin.read(buffer)) > 0)
		     {
	//	    	 System.out.println(length+" length "+" fin.read(buffer) "+ fin.read(buffer));
		        zout.write(buffer, 0, length);
		     }
		     zout.closeEntry();
		     fin.close();
		     }
		    zout.close();
			response.setHeader("Content-Type", "application/zip");
			response.setHeader("Content-Disposition", "attachment; filename="+monandyear+".zip");
			response.setContentLength((int) byteArrOutStream.size());
			servletOutStream.write(byteArrOutStream.toByteArray());
			servletOutStream.flush();
			servletOutStream.close();
			byteArrOutStream.close();
	     }
	     catch(IOException ioe)
	     {
	    	System.out.println("IOException :" + ioe);
	     }*/
	}

	
	}
		catch(SQLException | JSONException | InstantiationException | IllegalAccessException | ClassNotFoundException e){
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	
	

}
}

