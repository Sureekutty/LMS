package org.society.dao.authentication;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.society.exceptions.ThrowClassNotFoundException;
import org.society.exceptions.ThrowInstantiationException;
import org.society.exceptions.ThrowSQLException;
import org.society.model.TBSCLogin;
import org.society.util.DataBaseConnectionForNewDB;

public class AuthenticationDAO {
	 
	public boolean isValidUser(TBSCLogin tbsc_Login) throws SQLException 
	{ 	
	 boolean isValidUser = false;
	 Statement statement=null;
		Connection conn=null;
		try {
			//System.out.println("Validating...SQL..."+ tbsc_Login.getSocEmpCodel()+"-"+tbsc_Login.getPassword());
			 conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
			  statement = conn.createStatement();
			 
			String sqlQuerry = "SELECT * FROM speccs.Login WHERE UserId='"+tbsc_Login.getSocEmpCodel()+"' AND Password='"+ tbsc_Login.getPassword()+"'";
			ResultSet 	resultSet = statement.executeQuery(sqlQuerry);
			
			 //System.out.println("Validating1...SQL1..."+sqlQuerry);
			if (resultSet.next()) {
				//System.out.println("Validating1...SQL..."+resultSet.getString("UserName"));
				isValidUser =  true;
				
			}
			if(conn!=null){
			conn.close();
			}
			//System.out.println("Validating2...SQL..."+isValidUser);
			
		} catch (Exception e) {
			e.printStackTrace();
			if(conn!=null){
				conn.close();
			}
			if(statement!=null){
				statement.close();
			}
			
		}
		return isValidUser;
	}
	public int isValidUserRole(TBSCLogin tbsc_Login) throws SQLException 
	{ 	
	 
		int role = 0;
		 Statement statement=null;
			Connection conn=null;
		try {
			 conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
			  statement = conn.createStatement();
			String sqlQuerry = "SELECT * FROM speccs.Login WHERE UserId='" + tbsc_Login.getSocEmpCodel() + "' AND Password='" + tbsc_Login.getPassword()+ "' ";
			ResultSet 	resultSet = statement.executeQuery(sqlQuerry);
			
			
			if (resultSet.next()) {
				role =  resultSet.getInt("Role1");
			}
			if(conn!=null){
			conn.close();
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			if(conn!=null){
				conn.close();
			}
			if(statement!=null){
				statement.close();
			}
			
		}
		return role;
	}
}
