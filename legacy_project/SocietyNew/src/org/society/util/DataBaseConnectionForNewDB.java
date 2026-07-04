package org.society.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.commons.dbcp2.BasicDataSource;

public class DataBaseConnectionForNewDB {

	private static final BasicDataSource dataSource = new BasicDataSource();
	private static Connection connection = null;

	// make connection as singleton
	private DataBaseConnectionForNewDB(){
	}
	
	/*static {
		InputStream inputStream = DataBaseConnectionForNewDB.class.getResourceAsStream("/jdbc.properties");
		Properties properties = new Properties();
			try {
			properties.load(inputStream);
			String driver_Name = properties.getProperty("driver");
			String url_Path = properties.getProperty("serverpath");
			String userName = properties.getProperty("user");
			String password = properties.getProperty("password");
			int maxConnection = Integer.valueOf(properties.getProperty("maxConnection"));
			
			// Sybase Properties
			String driverName = properties.getProperty("driverForSybase");
			String url = properties.getProperty("serverPathForSybase");
			String userNameForSyBase = properties.getProperty("userForSybase");
			String passwordForSybase = properties.getProperty("passwordForSybase");
			int maxConnectionForSybase = Integer.valueOf(properties.getProperty("maxConnectionForSybase"));
			
			//cowaa properties
			String driverNameCowaa = properties.getProperty("driverForCowaa");
			String urlCowaa = properties.getProperty("serverPathForCowaa");
			String userNameForCowaa = properties.getProperty("userForCowaa");
			String passwordForCowaa= properties.getProperty("passwordForCowaa");
			int maxConnectionForCowaa = Integer.valueOf(properties.getProperty("maxConnectionForCowaa"));
			
		//	System.out.println("driver_Name "+driver_Name + "  maxConnection  " + maxConnection);
		//	System.out.println("url_Path " + url_Path + " USername " + userName + " password " +password)  ;
			dataSource.setDriverClassName(driver_Name);
			dataSource.setUrl(url_Path);
			dataSource.setUsername(userName);
			dataSource.setPassword(password);
			dataSource.setMaxTotal(maxConnection);
			connection = dataSource.getConnection();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    }*/
	
	public static Connection getConnection() throws SQLException {
		return connection;
	}
	
	public static Connection getConnectionForSyBase() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		
		Connection conn = null;
		String driver="com.sybase.jdbc2.jdbc.SybDriver";
		String url="jdbc:sybase:Tds:192.168.100.235:9100/";
		String dbName = "speccs";
		String userName = "speccs"; 
		String password = "speccs1";
		Class.forName(driver).newInstance();
		conn = DriverManager.getConnection("jdbc:sybase:Tds:192.168.100.235:9100/speccs",userName,password);
		return conn;
	}	
	public static Connection getConnectionForCowaa() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		
		Connection conn = null;
		String driver="com.sybase.jdbc2.jdbc.SybDriver";
		String url="jdbc:sybase:Tds:192.168.100.45:9100/";
		String dbName = "cowaa";
		String userName = "cowaa"; 
		String password = "cowaaa";
		Class.forName(driver).newInstance();
		conn = DriverManager.getConnection(url+dbName,userName,password);
		return conn;
	}	
	
/*	public static void main(String[] args) throws SQLException {
		Connection connection2 = getConnection();
		connection2.close();
		Connection connection3 = getConnection();
		connection3.close();
	}*/
	
	
}
