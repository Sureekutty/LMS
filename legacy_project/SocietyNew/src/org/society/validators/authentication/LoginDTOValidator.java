package org.society.validators.authentication;

import org.society.exceptions.InvalidUserException;
import org.society.model.TBSCSocStaffModel;
import org.society.model.TBSCLogin;

public class LoginDTOValidator {

	public static boolean validateLoginDTO(TBSCLogin tbsc_Login) throws InvalidUserException
	{
		/*
		 * it is expected that user name and password will not contain spaces.
		 */
		//System.out.println("validateLoginDTO...1");
		if(null==tbsc_Login.getSocEmpCodel()||null==tbsc_Login.getPassword())
		{
	  return false;
		//	throw new InvalidUserException();
		}
		else if(tbsc_Login.getSocEmpCodel().isEmpty()||tbsc_Login.getPassword().isEmpty()){
	   return false;
			//throw new InvalidUserException();
		}
		else {
			return true;
		}
		
	}

}
