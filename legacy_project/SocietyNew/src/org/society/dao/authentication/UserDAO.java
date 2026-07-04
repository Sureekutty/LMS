package org.society.dao.authentication;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.society.model.TBSCSocStaffModel;
import org.society.util.DataBaseConnectionForNewDB;

public class UserDAO {

	public TBSCSocStaffModel getStaffDetailsByUserId(String userId) throws SQLException, InstantiationException, IllegalAccessException, ClassNotFoundException{
		
		PreparedStatement ps = null;
		TBSCSocStaffModel tbscSocStaffModel = new TBSCSocStaffModel();
		try {
			Connection conn = DataBaseConnectionForNewDB.getConnectionForSyBase();
		String sqlQuerry = "SELECT * FROM speccs.Login WHERE UserId='" + userId + "' ";
		ps = conn.prepareStatement(sqlQuerry);
		ResultSet resultSet = ps.executeQuery();
	
		while(resultSet.next()) {
			
			tbscSocStaffModel.setSocEmpCode(userId);
			tbscSocStaffModel.setSocName(resultSet.getString("UserName"));
			
		}
		ps.close();
		}
		 catch (SQLException e) {
				throw e;
		}
		finally{
		
		//	conn.close();
		}
		return tbscSocStaffModel;
	}
	
public static void main(String[] args) throws SQLException, InstantiationException, IllegalAccessException, ClassNotFoundException {
		UserDAO dao = new UserDAO();
		TBSCSocStaffModel loginUserDetails = dao.getStaffDetailsByUserId("SH1790");
		
}
	
}
