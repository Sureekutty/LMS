package org.society.service.authentication;

import java.sql.SQLException;

import org.society.dao.authentication.UserDAO;
import org.society.model.TBSCSocStaffModel;

public class UserService {
	
	public TBSCSocStaffModel getStaffDetailsByUserId(String userId) throws SQLException, InstantiationException, IllegalAccessException, ClassNotFoundException{
		return new UserDAO().getStaffDetailsByUserId(userId);
	}

}
