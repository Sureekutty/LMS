package org.society.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.society.model.RequestSourceModel;
import org.society.model.TBSCLogin;
import org.society.model.TBSCSocStaffModel;
import org.society.service.authentication.AuthenticationService;
import org.society.service.authentication.UserService;
import org.society.util.DataBaseConnectionForNewDB;
import org.society.validators.authentication.LoginDTOValidator;

@WebServlet("/checkLogin")
public class UserController extends HttpServlet {

	
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String viewName=  "";
		try {
		TBSCSocStaffModel userDetails = null;
		HttpSession session = request.getSession(true);
		String userId = request.getParameter("user").toUpperCase();
		
		String password = request.getParameter("pass");
		
		//System.out.println("username "+userId+" pass "+password);
		TBSCLogin tbsc_Login = new TBSCLogin();

		tbsc_Login.setSocEmpCode(userId);
		
		tbsc_Login.setPassword(password);
		boolean validated = LoginDTOValidator.validateLoginDTO(tbsc_Login);
		//System.out.println("validation is "+validated);
		if (false==validated) {
			viewName = "Login.jsp";

		} else {
			
				RequestSourceModel requestSourceModel=new RequestSourceModel();
				boolean isValidUser=false;
				String returnMessage="";
				
				requestSourceModel.setIPAddress(request.getLocalAddr());
				requestSourceModel.setRequestedUserId(tbsc_Login.getSocEmpCodel());
				requestSourceModel.setSessionId(session.getId());
				
				AuthenticationService authenticationService = new AuthenticationService();
				
				boolean validUSer = authenticationService.isValidUSer(tbsc_Login, requestSourceModel);
				//System.out.println("valid user "+validUSer);
				if(false==validUSer){
					
					request.setAttribute("USERVALIDATION", "INVALID USER");
					viewName = "Login.jsp";
					
				}
				else{
					
					int validUSerRole = authenticationService.isValidUSerRole(tbsc_Login);
					//System.out.println("user role "+validUSerRole);
					if(validUSerRole==3) 
						viewName = "EmployeeDetail.jsp";
					else
						viewName = "MainPage.jsp";
					UserService userService = new UserService();
					userDetails = userService.getStaffDetailsByUserId(userId);
					
					requestSourceModel.setUserValidated(true);
					requestSourceModel.setUserDetails(userDetails);
					session.setAttribute("USERDETAILS", userDetails);
					session.setAttribute("EMPLOYEENAME", userDetails.getSocName());
					session.setAttribute("ROLE",validUSerRole );
					session.setAttribute("requestSourceModel", requestSourceModel);
					session.setAttribute("EMPLOYEECODE", tbsc_Login.getSocEmpCodel());
					
				}
				
			} 
		Calendar calendar = Calendar.getInstance();
		Date time = calendar.getTime();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String format = dateFormat.format(time);
		String format2 = new SimpleDateFormat("dd/MM/yyyy").format(time);
		session.setAttribute("TIMESTAMP", format);
		session.setAttribute("CURRDATE", format2);

		session.setAttribute("LOGINMODE", "DIRECTOR");
		
	}
		catch (SQLException e) {
			e.printStackTrace();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			viewName = "Login.jsp";
			String returnMessage = e.getMessage();
			request.setAttribute("USERVALIDATION", returnMessage);
			System.out.println("Inside exception "+e.getMessage());
			e.printStackTrace();
		}
	finally{
		RequestDispatcher rd = request.getRequestDispatcher(viewName);
		rd.forward(request, response);
	}
	}

}
