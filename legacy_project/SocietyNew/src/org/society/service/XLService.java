package org.society.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class XLService {

	public static JSONArray readXLSXSheet(XSSFSheet xSheet, int keyColumnIndex) throws IOException, JSONException {
		
		JSONArray output=new JSONArray();
		    
	    ArrayList<String> headers=new ArrayList<String>();
	    int colTrack=0;
	    
	    for(Row rw : xSheet){
	    	
//   		System.out.println("Row"+rw.getRowNum()+"|"+rw.isFormatted()+"--- No of cells: "+rw.getLastCellNum()+" - ");
//		    	int i=1;
	    	JSONObject jobj=new JSONObject();

	    	for(Cell cl : rw){
				Object val=null;
				
				switch(cl.getCellType()){
				case STRING: val=cl.getStringCellValue().trim(); 			                   
					break;
				case NUMERIC: val=cl.getNumericCellValue();
					if(HSSFDateUtil.isCellDateFormatted(cl)) val=new SimpleDateFormat("dd/MM/yyyy").format(cl.getDateCellValue());
					break;
 				case BOOLEAN: val=cl.getBooleanCellValue();
 					break;
				case ERROR:	val=cl.getErrorCellValue();
					break;
				case FORMULA:
					switch(cl.getCachedFormulaResultType()){
					case STRING: val=cl.getStringCellValue().trim();			                   
						break;
					case NUMERIC: val=cl.getNumericCellValue();
						if(HSSFDateUtil.isCellDateFormatted(cl)) val=new SimpleDateFormat("dd/MM/yyyy").format(cl.getDateCellValue());
						break;
					case BOOLEAN: val=cl.getBooleanCellValue();
						break;
					case ERROR: val=cl.getErrorCellValue();
						break;
					default: val="";
					}
					break;
				default:
					val="";
				}
//				System.out.println("type: "+cl.getCellType()+"/"+cl.getColumnIndex()+" @ "+(cl.getColumnIndex()+1)+" - val - >>"+val+"<<");
				jobj.put("column"+(cl.getColumnIndex()+1), val);
			}
	    	if(jobj.has("column"+keyColumnIndex))
	    			if(!jobj.get("column"+keyColumnIndex).toString().trim().equals(""))
	    					output.put(jobj);
//		    	System.out.println("---rowend");
	    	}
	    return output;
    }
	    
	   
	public static JSONArray readXLSSheet(HSSFSheet xSheet, int keyColumnIndex) throws IOException, JSONException {
		
		JSONArray output=new JSONArray();
		
		ArrayList<String> headers=new ArrayList<String>();
		int colTrack=0;
		
		for(Row rw : xSheet){
			
			JSONObject jobj=new JSONObject();
			
			for(Cell cl : rw){
				Object val=null;
				
				switch(cl.getCellType()){
				case STRING: val=cl.getStringCellValue().trim(); 			                   
					break;
				case NUMERIC: val=cl.getNumericCellValue();
					if(HSSFDateUtil.isCellDateFormatted(cl)) val=new SimpleDateFormat("dd/MM/yyyy").format(cl.getDateCellValue());
					break;
 				case BOOLEAN: val=cl.getBooleanCellValue();
 					break;
				case ERROR:	val=cl.getErrorCellValue();
					break;
				case FORMULA:
					switch(cl.getCachedFormulaResultType()){
					case STRING: val=cl.getStringCellValue().trim();			                   
						break;
					case NUMERIC: val=cl.getNumericCellValue();
						if(HSSFDateUtil.isCellDateFormatted(cl)) val=new SimpleDateFormat("dd/MM/yyyy").format(cl.getDateCellValue());
						break;
					case BOOLEAN: val=cl.getBooleanCellValue();
						break;
					case ERROR: val=cl.getErrorCellValue();
						break;
					default: val="";
					}
					break;
				default:
					val="";
				}
				
				jobj.put("column"+(cl.getColumnIndex()+1), val);
			}
			
			if(jobj.has("column"+keyColumnIndex))
				if(!jobj.get("column"+keyColumnIndex).toString().trim().equals(""))
					output.put(jobj);
//		    	System.out.println("---rowend");
//		    	if(!jobj.get("column"+keyColumnIndex).toString().trim().equals(""))
//		    		output.put(jobj);
		}
		return output;
	}
	
	protected static boolean isValifXLfile(File xfile) throws IOException{
		
		if(!xfile.getAbsoluteFile().toString().endsWith(".xlsx") && !xfile.getAbsoluteFile().toString().endsWith(".xls"))
			return false;
		
	    if(xfile.getAbsoluteFile().toString().endsWith(".xlsx")){
		    return false;
	    }
	   
	    return true;
	}
}
