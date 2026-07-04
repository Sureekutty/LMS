package org.society.util;

public class Test {

	public Test() {
	}
	@SuppressWarnings("unused")
	public static void main(String[] args) {
		System.out.println("coming");
		String memAccountNumber="121212",status="CANCELED";
		if(memAccountNumber!=null  && status=="CANCELED"){
			System.out.println("inside");
			memAccountNumber = "NEW";
		}
	}

}
