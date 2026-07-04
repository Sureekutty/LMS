package org.society.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Hours;
import org.joda.time.Minutes;
import org.joda.time.Seconds;

public class TimeDifference {
static	Date d1 = null;
static	Date d2 = null;
static	DateTime dt1 = null ;
static	DateTime dt2=null;
	
	
	public static int dateDifference(String dateStart, String dateStop) {
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		Date d1 = null;
		Date d2 = null;
		DateTime dt1 = null ;
		DateTime dt2=null;

		try {
			d1 = format.parse(dateStart);
			d2 = format.parse(dateStop);
			
			 dt1 = new DateTime(d1);
			 dt2 = new DateTime(d2);
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return  Days.daysBetween(dt1, dt2).getDays();
	}

	public static int hoursDifference(String dateStart, String dateStop)
			throws ParseException {
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			d1 = format.parse(dateStart);
			d2 = format.parse(dateStop);
			
			 dt1 = new DateTime(d1);
			 dt2 = new DateTime(d2);
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return Hours.hoursBetween(dt1, dt2).getHours() % 24;

	}

	public static int minutesDifference(String dateStart, String dateStop)
			throws ParseException {
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			d1 = format.parse(dateStart);
			d2 = format.parse(dateStop);
			DateTime dt1 = new DateTime(d1);
			DateTime dt2 = new DateTime(d2);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return Minutes.minutesBetween(dt1, dt2).getMinutes() % 60;	 
	}

	public static int secondsDifference(String dateStart, String dateStop)
			throws ParseException {
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

		try {
			d1 = format.parse(dateStart);
			d2 = format.parse(dateStop);
			DateTime dt1 = new DateTime(d1);
			DateTime dt2 = new DateTime(d2);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return Seconds.secondsBetween(dt1, dt2).getSeconds() % 60;
	}
	public static void main(String[] args) {
		System.out.println(TimeDifference.dateDifference("15/01/2017", "10/01/2017"));
	}
	
	
}
