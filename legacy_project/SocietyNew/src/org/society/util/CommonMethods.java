package org.society.util;

import java.time.LocalDate;
import java.time.Period;

public class CommonMethods {
	
	public static String returnDateYYYYMMDDFormat(String strDate) {
		String myResultDate = "";
		String resultDate = strDate.substring(0, 2);
		String resultMonth = strDate.substring(3, 5);
		String resultYear = strDate.substring(6);
		// System.out.println("In GetYYYYMMMDDD  " + resultYear + "-"
		// +resultMonth + "-" + resultDate);
		myResultDate = resultYear + "/" + resultMonth + "/" + resultDate;
		return myResultDate;
	}
	public static int getLoanInstalments(String retirementDate) {
		System.out.println("retirementDate-- >> "+retirementDate);
		int day = Integer.parseInt(retirementDate.toString().substring(0,2));
		int month = Integer.parseInt(retirementDate.toString().toString().substring(3,5));
		int year = Integer.parseInt(retirementDate.toString().toString().substring(6));
		LocalDate date=LocalDate.of(year, month, day);
		LocalDate current=LocalDate.now();
		int getyear= Period.between(current,date ).getYears();
		int months = Period.between(current,date ).getMonths();
//		int days = Period.between(current,date).getDays();
		System.out.println("getyear "  +getyear + "  months " + months );
		int noOfMonths = (getyear *12 )+ months;
		System.out.println("getyear "+getyear);
		return noOfMonths;	
	}
}
