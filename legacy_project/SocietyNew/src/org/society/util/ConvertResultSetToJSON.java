package org.society.util;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ConvertResultSetToJSON {

	public static JSONArray ResultToJSON(ResultSet resultSet) throws SQLException, JSONException{
		
		JSONArray dataArray = new JSONArray();
		JSONObject dataObject = new JSONObject();
		
		DecimalFormat df= new DecimalFormat("#");
		df.setMinimumIntegerDigits(1);
		df.setMinimumFractionDigits(2);
		df.setMaximumFractionDigits(4);
		
		SimpleDateFormat dateFormat=new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat regtimeFormat=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		
		
			ResultSetMetaData metaData=resultSet.getMetaData();
			
			while (resultSet.next()) {
				int colCount = metaData.getColumnCount();
			    dataObject = new JSONObject();
			    for (int i = 1; i <= colCount; i++) {
			    	int colType=metaData.getColumnType(i);
			    	String colName=metaData.getColumnLabel(i).toString().trim();
			    	String val=resultSet.getString(i);
			    	if(val==null)
			    		dataObject.put(colName, "");
			    	else if(colType==Types.INTEGER)
			    		dataObject.put(colName, resultSet.getInt(i));
			    	else if(colType==Types.FLOAT || colType==Types.NUMERIC || colType==Types.DOUBLE)
			    		dataObject.put(colName, df.format(resultSet.getDouble(i)));		 
			    	else if(colName.toUpperCase().equals("REGTIME") && (colType==Types.TIMESTAMP || colType==Types.DATE))
			    		dataObject.put(colName, regtimeFormat.format(resultSet.getTime(i)));
					else if(colType==Types.TIMESTAMP || colType==Types.DATE)
			    		dataObject.put(colName, dateFormat.format(resultSet.getDate(i)));
			    	else
			    		dataObject.put(colName, resultSet.getString(i).trim());
			    }
			    dataArray.put(dataObject);
			}
			        
		
		
		return dataArray;
	}
}
