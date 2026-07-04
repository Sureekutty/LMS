package org.society.service;

import java.sql.SQLException;
import java.util.LinkedList;
import java.util.Map;

import org.society.dao.MemberDao;
import org.society.dto.MembershipDto;

public class MemberService {

	MemberDao memberDao = null;

public  LinkedList<MembershipDto> getMemberInformation(String memEmployeeCode,String recordType,String regStatus,String memAccountNumber) throws Exception {
		
		memberDao = new MemberDao();
		LinkedList<MembershipDto> memberInformation = memberDao.getMemberInformation(memEmployeeCode, recordType, regStatus, memAccountNumber);
		
		return memberInformation;
		
	}
	
	public  LinkedList<MembershipDto> getApplicationInformation(String EmployeeCode,String recordType,String regStatus,String ApplNo) throws Exception {
		
		memberDao = new MemberDao();
		LinkedList<MembershipDto> memberInformation = memberDao.getApplicationInformation(EmployeeCode, recordType, regStatus, ApplNo);
		
		
		return memberInformation;
		
	}
	public  LinkedList<MembershipDto> getApplicationInformationstaff(String EmployeeCode,String recordType,String regStatus,String ApplNo) throws Exception {
		
		memberDao = new MemberDao();
		LinkedList<MembershipDto> memberInformation = memberDao.getApplicationInformationstaff(EmployeeCode, recordType, regStatus, ApplNo);
		
		
		return memberInformation;
		
	}
	public LinkedList<String> getMemAddress(String fetch, String empCode) throws Exception {
		memberDao = new MemberDao();
		LinkedList<String> MemAddress = memberDao.getMemAddress(fetch,empCode);
		
	
		return MemAddress;
	}

	
}
