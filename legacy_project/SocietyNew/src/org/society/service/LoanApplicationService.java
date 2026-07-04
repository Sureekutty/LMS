package org.society.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.society.dao.LoanApplicationDAO;
import org.society.dao.MemberDao;
import org.society.dto.MembershipDto;

public class LoanApplicationService {
	GenericDetailsService genericDetailsService = null;
public LinkedList<MembershipDto> getMemberInformation(String memEmployeeCode, String recordType, String regStatus,String memAccountNumber) throws Exception {
		MemberDao memberDao = new MemberDao();
		LinkedList<MembershipDto> memberInformation = memberDao.getMemberInformation(memEmployeeCode, recordType, regStatus,memAccountNumber);
		return memberInformation;
	}
	
	public LinkedList<MembershipDto> getApplicationInformation(
			String EmployeeCode, String recordType, String regStatus,
			String ApplNo) throws Exception {
		MemberDao memberDao = new MemberDao();
		LinkedList<MembershipDto> memberInformation = memberDao.
				getApplicationInformation( EmployeeCode, recordType, regStatus, ApplNo);
		return memberInformation;
	}
	LoanApplicationDAO loanApplicationDAO = null;
	public  List<Map<String, String>> getLoanTypes() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		loanApplicationDAO = new LoanApplicationDAO();
		List<Map<String,String>> loanTypes = loanApplicationDAO.getLoanTypes();
		return loanTypes;
	}
	
	public  List<Map<String, String>> getLoanTypesload() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		loanApplicationDAO = new LoanApplicationDAO();
		List<Map<String,String>> loanTypes = loanApplicationDAO.getLoanTypesload();
		return loanTypes;
	}
	
	public Map<String, String> getLoanDetails(String memAccNo,String loanType,String fdRefNum) throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		return new LoanApplicationDAO().getLoanDetails(memAccNo, loanType, fdRefNum);
	}
	
	public static void main(String[] args) throws Exception {}
}
