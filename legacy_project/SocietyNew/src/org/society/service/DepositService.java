package org.society.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.society.dao.LoanApplicationDAO;
import org.society.dao.MemberDao;
import org.society.dto.MembershipDto;
import org.society.dto.ReceiptDto;

import org.society.util.CommonMethods;

public class DepositService {
	GenericDetailsService genericDetailsService = null;
public LinkedList<MembershipDto> getMemberInformation(String memEmployeeCode, String recordType, String regStatus,String memAccountNumber) throws Exception {
		MemberDao memberDao = new MemberDao();
		LinkedList<MembershipDto> memberInformation = memberDao.getDepositInformation(memEmployeeCode, recordType, regStatus,memAccountNumber);
		return memberInformation;
	}
	
public LinkedList<ReceiptDto> getMemberInformationReceipt(String fromDate,String toDate,String memEmployeeCode, String recordType, String regStatus,String memAccountNumber) throws Exception {
	MemberDao memberDao = new MemberDao();
	LinkedList<ReceiptDto> receiptInformation = memberDao.getDepositInformationReceipt(fromDate,toDate,memEmployeeCode, recordType, regStatus,memAccountNumber);
	return receiptInformation;
}

	public static void main(String[] args) throws Exception {}
}
