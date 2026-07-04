/**
 * 
 */
package org.society.exceptions;

import org.society.model.TBSCLogin;

/**
 * @author cowaa
 *
 */
public class InvalidUserException extends Exception {

	
	
	public InvalidUserException() {
		// TODO Auto-generated constructor stub
		
		super("Invalid Username or Password");
	}
	/*
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return errorMessage;
	}*/

}
