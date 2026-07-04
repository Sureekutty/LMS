package org.society.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.society.service.EmailService;
import org.society.service.PDFGenerator;
import org.society.service.XLService;
import org.society.util.ConvertListToJSONArray;
import org.society.util.ConvertResultSetToJSON;
import org.society.util.DataBaseConnectionForNewDB;

/**
 * Servlet implementation class StatementDispatch
 */
@WebServlet("/StatementDispatch")
public class StatementDispatch extends HttpServlet {
   
	private static final long serialVersionUID = 7764879974306017945L;
	String xlfile_prefix="ASTMT_";
	String jsonfile_prefix="ASTMT_";
	String pdffile_prefix="SPECCSAnnualStmt_";
	String logfile_prefix="mail_log_";
	String repository="",repositoryContext="";
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Connection connection = null;
	try{
		String incomingRequest = null,fy="";
		JSONObject outObject = null;
		repository=request.getRealPath("/")+"FileRepository"+File.separator;
		repositoryContext=request.getContextPath()+File.separator+"FileRepository"+File.separator;
		
		boolean isMP=ServletFileUpload.isMultipartContent(request);
//		System.out.println("type: "+isMP+" - "+request.getContentType().toString());
		
//		System.out.println("repor----"+ repository);
//		System.out.println("request.getServletPath()----"+ request.getServletPath()+"--------request.getRealPath()----"+ request.getRealPath(request.getContextPath())+"--------request.getRealPath(/)----"+ request.getRealPath("/"));
		
		
		if(!isMP) 
			incomingRequest = request.getParameter("req").trim();
		else{
			DiskFileItemFactory factory=new DiskFileItemFactory();
			
			ServletFileUpload upload=new ServletFileUpload(factory);
			
			if(!new File(repository).exists()) new File(repository).mkdir();
//			repository=repository+File.pathSeparator;
			
			List items=upload.parseRequest(request);
			Iterator ir=items.iterator();

			while(ir.hasNext()){

				FileItem item =(FileItem) ir.next();
				if(item.isFormField()){
					InputStream in = item.getInputStream();
					int length = in.available();
					byte dataBytes[] = new byte[length];
					int byteRead = 0, totalBytesRead = 0;
					while (totalBytesRead < length) {
						byteRead = in.read(dataBytes, totalBytesRead, length);
						totalBytesRead += byteRead;
					}
					in.close();
					
					String value = new String(dataBytes);
					
					if(item.getFieldName().equals("req"))
						incomingRequest=value;
					
					if(item.getFieldName().equals("financeyr"))
						fy=value;
				}
				else{
					if(incomingRequest.equals("uploadFile")){
						
						String fileName=new File(item.getName()).getName();
						String xlfilepath= repository+xlfile_prefix+fy+fileName.substring(fileName.lastIndexOf("."),fileName.length());
						String jsonfilepath= repository+jsonfile_prefix+fy+".json";
						JSONObject dataObject=new JSONObject();
						
						cleanFiles(fy);
//						if(1==1)
//							return;
						//writing file
						File xfile=new File(xlfilepath);
						if(xfile.exists())
							xfile.delete();
						item.write(xfile);
						
						int keyColumnIndex1=3,keyColumnIndex2=0;
						
					    FileInputStream xfis= new FileInputStream(xfile);
					    
					    if(xfile.getAbsoluteFile().toString().endsWith(".xlsx")){
					    	XSSFWorkbook xWB= new XSSFWorkbook(xfis);
						    dataObject.put("thriftData", XLService.readXLSXSheet(xWB.getSheetAt(0), keyColumnIndex1));
						    dataObject.put("loanData", XLService.readXLSXSheet(xWB.getSheetAt(1), keyColumnIndex2));
						    xWB.close();
					    }
						
					    else if(xfile.getAbsoluteFile().toString().endsWith(".xls")){
					    	HSSFWorkbook xWB= new HSSFWorkbook(xfis);
					    	dataObject.put("thriftData", XLService.readXLSSheet(xWB.getSheetAt(0), keyColumnIndex1));
					    	dataObject.put("loanData", XLService.readXLSSheet(xWB.getSheetAt(1), keyColumnIndex2));
					    	xWB.close();
					    }
					    
					    xfis.close();
						
//						System.out.println("fulldata: "+dataArray.toString());
						
						//writing JSON data to file
						File jfile=new File(jsonfilepath);
						if(jfile.exists())
							jfile.delete();
						FileOutputStream jfos=new FileOutputStream(jfile);
						jfos.write(dataObject.toString().getBytes(StandardCharsets.UTF_8));
						jfos.close();
						
						for(int i=1;i<dataObject.getJSONArray("thriftData").length();i++){
							
							JSONObject thriftDataObject=dataObject.getJSONArray("thriftData").getJSONObject(i);
							JSONObject loanDataObject=new JSONObject();
							for(int j=1;j<dataObject.getJSONArray("loanData").length();j++)
								if(dataObject.getJSONArray("loanData").getJSONObject(j).getString("column"+keyColumnIndex2).trim().toLowerCase()
										.equals(thriftDataObject.getString("column"+keyColumnIndex1).trim().toLowerCase()))
									loanDataObject=dataObject.getJSONArray("loanData").getJSONObject(j);
//							System.out.println("emp-thrift data-"+thriftDataObject.toString());
//							System.out.println("emp-loan data-"+loanDataObject.toString());
							String empcode=thriftDataObject.has("column"+keyColumnIndex1) ? thriftDataObject.get("column"+keyColumnIndex1).toString() : "";
							String pdfResponse=empcode.length()==7 ? PDFGenerator.generatePDF(thriftDataObject,loanDataObject,repository+pdffile_prefix+fy,fy) : "skipped";
//							System.out.println("emp-"+empcode+" ------- "+pdfResponse);
						}
						response.getWriter().write(new JSONObject().put("success", "y").toString());
					}
				}
			}
			}
	
	//		HttpSession session = request.getSession();
	
		if(incomingRequest.equals("getDetails")){
		
			connection = DataBaseConnectionForNewDB.getConnection();
			fy=request.getParameter("fy").trim();
			
			//entities list
			Statement statement=connection.createStatement();
			String sql = "select * from  cowaa.TBAD_ENTITIES where ENTITYCODE not in ('B1','CO','DW','PP','SP','ZD')";
			ResultSet rs = statement.executeQuery(sql);
			JSONArray entities = ConvertResultSetToJSON.ResultToJSON(rs);
			
			//checking for existing files
			boolean dataExists=false,xlExists=false;
			
			File xfile=new File(repository+xlfile_prefix+fy+".xlsx");
			if(!xfile.exists()){
				xfile=new File(repository+xlfile_prefix+fy+".xls");
				if(xfile.exists())
					xlExists=true;
			}
			else
				xlExists=true;
	
			File jfile=new File(repository+jsonfile_prefix+fy+".json");
			if(jfile.exists())
					dataExists=true;
			String filedata = "";
			
//			System.out.println("json file: "+jfile.getCanonicalPath()+" --- "+jfile.getAbsolutePath()+" ------- "+jfile.getPath());
			
			if(dataExists){
				Scanner dataScanner=new Scanner(jfile);
				while(dataScanner.hasNextLine()) filedata=filedata+dataScanner.nextLine();
				dataScanner.close();
			
//				System.out.println(filedata);
				JSONArray dataArray=new JSONArray(filedata);

				JSONObject output = new JSONObject();
				output.put("entities", entities);
				output.put("data", getEmployeeDetails(dataArray, repository, fy));
				output.put("fileExists", dataExists ? "Y" : "N");
				output.put("xlfileExists", xlExists ? "Y" : "N");
				output.put("fileName", dataExists ? repositoryContext+xfile.getName() : "");
				output.put("filePathSeparator", File.separator);
				output.put("success","y");	
				
//				System.out.println("read complete");
				
				response.getWriter().write(output.toString());
			}
			else{
				response.getWriter().write(new JSONObject().put("success", "n").put("error", "No existing data. Upload Data XLSX file.").toString());
			}
			
				
		}
		
		if(incomingRequest.equals("getList")){
			
			connection = DataBaseConnectionForNewDB.getConnection();
			fy=request.getParameter("fy").trim();
			
			//checking for existing files
			boolean dataExists=false;
			
			File jfile=new File(repository+jsonfile_prefix+fy+".json");
			if(jfile.exists())
				dataExists=true;
			String filedata = "";
			
			if(dataExists){
				Scanner dataScanner=new Scanner(jfile);
				while(dataScanner.hasNextLine()) filedata=filedata+dataScanner.nextLine();
				dataScanner.close();
				
				JSONArray dataArray=new JSONArray(filedata);
				
				JSONObject output = new JSONObject();
				output.put("data", getEmployeeDetails(dataArray, repository, fy));
				output.put("success","y");	
				response.getWriter().write(output.toString());
			}
			else{
				response.getWriter().write(new JSONObject().put("success", "n").put("error", "No existing data. Upload Data XLSX file.").toString());
			}
			
			
		}
		
		if(incomingRequest.equals("sendmail")){
			
			fy=request.getParameter("fy").trim();
			String emp=request.getParameter("emp").trim();
			String email=request.getParameter("email").trim();
			
			if(!email.contains("@")){
				response.getWriter().write(new JSONObject().put("success", "n").put("error", "Error in sending mail: Invalid e-Mail Address").toString());
				return;
			}
			
			File pdfFile=new File(repository+pdffile_prefix+fy+"_"+emp+".pdf");
			if(!pdfFile.exists()){
				response.getWriter().write(new JSONObject().put("success","n").put("error","PDF-File not found for "+emp).toString());
				return;
			}
			else{

				
				String mailBody="Dear Sir/Madam,<br><br>   This is an automated mail from SPECCS Application: <br><br> Your Annual Statement from SPECCS is attached as PDF document.<br><br> NOTE: DO NOT REPLY to this mail";
				String mailerResponse=EmailService.sendMail(email, mailBody, pdfFile);

				if(mailerResponse.toLowerCase().contains("success")){
					writeMailerLog(emp, email, fy, new SimpleDateFormat("dd-MM-yyyy-HH:mm:ss").format(new Date()));
					response.getWriter().write(new JSONObject().put("success", "y").toString());
				}
				else			
					response.getWriter().write(new JSONObject().put("success", "n").put("error", "Error in sending mail: "+mailerResponse).toString());
			}
		}
		
		if(incomingRequest.equals("sendbulkmail")){
			
			fy=request.getParameter("fy").trim();
			String emplist=request.getParameter("emplist").trim();
			JSONArray data=new JSONArray(emplist);
			int successCnt=0,failCnt=0;
			
			for(int i=0;i<data.length();i++){
				
				String emp=data.getJSONObject(i).getString("EmployeeCode").trim();
				String email=data.getJSONObject(i).getString("mailID").trim();
				
				if(!email.contains("@")){
					failCnt++;
				}
				
				File pdfFile=new File(repository+pdffile_prefix+fy+"_"+emp+".pdf");
				if(!pdfFile.exists()){
					failCnt++;
				}
				else{
					String mailBody="Dear Sir/Madam,<br><br>   This is an automated mail from SPECCS Application: <br><br> Your Annual Statement from SPECCS is attached as PDF document.<br><br> NOTE: DO NOT REPLY to this mail";
					String mailerResponse=EmailService.sendMail(email, mailBody, pdfFile);

					if(mailerResponse.toLowerCase().contains("success")){
						writeMailerLog(emp, email, fy, new SimpleDateFormat("dd-MM-yyyy-HH:mm:ss").format(new Date()));
						successCnt++;
					}
				}
			}
			
			response.getWriter().write(new JSONObject().put("success", "y").put("successCnt", successCnt).put("failCnt", failCnt).toString());
		}
		
		}
		catch (Exception e) {
			try {
				response.getWriter().write(new JSONObject().put("success","n").put("error",e.toString().trim()).toString());
				e.printStackTrace();
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
		}finally{
			if(connection!=null)
				try {
					connection.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
	}
	
	protected JSONArray getEmployeeDetails(JSONArray dataList, String repository, String fy) throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException, JSONException, IOException{
		
		JSONArray outArray=new JSONArray();

		Connection connection = DataBaseConnectionForNewDB.getConnection();
		
		for(int i=1;i<dataList.length();i++){
			
			JSONObject jObject=dataList.getJSONObject(i);
			String empcode=jObject.has("column3") ? jObject.get("column3").toString() : "";
			String employeeCode="",offcEmailId="",persEmailId="",entcode="",mailSent="--mail not sent---";
			JSONArray logData=readMailerLog(fy);
			
			if(empcode.length()==7){
				File pdfFile=new File(repository+pdffile_prefix+fy+"_"+empcode+".pdf");
				boolean pdfExists=pdfFile.exists();
				
				String empName = jObject.has("column4") ? jObject.get("column4").toString() : "NA";
				try {
					
					String sql = "SELECT EMPLOYEECODE,EMAILIDOFFC,EMAILIDPERS,(select e.ENTITYCODE from  cowaa.TBAD_DIVISION d, cowaa.TBAD_ENTITIES e,cowaa.TBAD_EMPLOYEE m where e.ENTITYCODE=d.ENTITYCODE and d.DIVNCODE=m.DIVNCODE and m.EMPLOYEECODE=p.EMPLOYEECODE) ENTCODE FROM  cowaa.TBAD_EMPPHONENUMBER p WHERE EMPLOYEECODE=?";						
					CallableStatement cs = connection.prepareCall(sql);
					cs.setString(1,empcode);
					ResultSet rs = cs.executeQuery();
					if(rs.next()){							
						 employeeCode = rs.getString("EMPLOYEECODE");
						 offcEmailId = rs.getString("EMAILIDOFFC")==null ? "" : rs.getString("EMAILIDOFFC").trim();
//						 offcEmailId="rkannan@shar.gov.in";
						 persEmailId = rs.getString("EMAILIDPERS")==null ? "" : rs.getString("EMAILIDPERS").trim();
						 entcode = rs.getString("ENTCODE")==null ? "" : rs.getString("ENTCODE").trim();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				for(int j=0;j<logData.length();j++){
					if(logData.getJSONObject(j).getString("empcode").equals(empcode))
						mailSent=logData.getJSONObject(j).getString("time").trim();
				}
				
				JSONObject outObject=new JSONObject();
				
				outObject.put("EmployeeCode", empcode);
				outObject.put("ent", entcode);
				outObject.put("reportFileName", pdfExists ? repositoryContext+pdfFile.getName() : "");
				outObject.put("filePathSeparator", File.separator);
				outObject.put("mailID", offcEmailId);
				outObject.put("EmployeeName", empName);
				outObject.put("mailSentOn",mailSent);
				
				outArray.put(outObject);
			}
		}
		
		return outArray;
	}
	
	protected void writeMailerLog(String emp, String mail, String fy, String time) throws JSONException, IOException{
		
		File logFile=new File(repository+logfile_prefix+"_"+fy+".log");
		JSONArray logData=new JSONArray();
		JSONArray logFileData=new JSONArray();
		
		String filedata="";
		if(logFile.exists()){
			Scanner dataScanner=new Scanner(logFile);
			while(dataScanner.hasNextLine()) filedata=filedata+dataScanner.nextLine();
			dataScanner.close();
			
			logFileData=new JSONArray(filedata);
			for(int i=0;i<logFileData.length();i++){
				if(!logFileData.getJSONObject(i).getString("empcode").equals(emp))
					logData.put(logFileData.getJSONObject(i));
			}
		}
		
		JSONObject resultObj=new JSONObject();
		resultObj.put("empcode", emp);
		resultObj.put("mail", mail);
		resultObj.put("time", time);
		
		logData.put(resultObj);
		
		FileOutputStream lfos=new FileOutputStream(logFile);
		lfos.write(logData.toString().getBytes(StandardCharsets.UTF_8));
		lfos.close();
	}
	
	protected JSONArray readMailerLog(String fy) throws JSONException, IOException{
		
		File logFile=new File(repository+logfile_prefix+"_"+fy+".log");
		JSONArray logFileData=new JSONArray();
		
		String filedata="";
		if(logFile.exists()){
			Scanner dataScanner=new Scanner(logFile);
			while(dataScanner.hasNextLine()) filedata=filedata+dataScanner.nextLine();
			dataScanner.close();
			
			if(!filedata.trim().equals(""))
				logFileData=new JSONArray(filedata);
		}
		
		return logFileData;
	}
	
	protected void cleanFiles(String fy){
		
		File repositoryDir=new File(repository);
//		System.out.println("deleting in "+repositoryDir);
		File[] files=repositoryDir.listFiles(new FilenameFilter() {
			@Override
			public boolean accept(File arg0, String fname) {
				// TODO Auto-generated method stub
//				System.out.println("file- "+fname);
				if(fname.toLowerCase().endsWith(".xlsx") || fname.toLowerCase().endsWith(".xls"))
					if(fname.contains(xlfile_prefix+fy))
						return true;
				
				if(fname.toLowerCase().endsWith(".pdf"))
					if(fname.contains(pdffile_prefix+fy))
						return true;
				
				if(fname.toLowerCase().endsWith(".json"))
					if(fname.contains(jsonfile_prefix+fy))
						return true;
				return false;
			}
		});
		
		for(int i=0;i<files.length;i++){
//			System.out.println("file ("+files[i].exists()+") del: "+files[i].getName());
			if(files[i].exists()) files[i].delete();
		}
	}
}
