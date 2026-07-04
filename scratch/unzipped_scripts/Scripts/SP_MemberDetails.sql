IF OBJECT_ID ('speccs.SP_MemberDetails') IS NOT NULL
	DROP PROCEDURE speccs.SP_MemberDetails
GO

CREATE  PROCEDURE speccs.SP_MemberDetails
@EmpCode VARCHAR(7) = NULL,
@Option  	VARCHAR (20),
@Status VARCHAR(10) = NULL,
@MemAccNo VARCHAR(5) = NULL


AS

/*
	DROP PROCEDURE  speccs.SP_MemberDetails
	
	GRANT ALL ON speccs.SP_MemberDetails to speccsgroup
*/
--DECLARE @LatestStatus VARCHAR(20)
--SELECT @LatestStatus=mem.Status FROM speccs.Members mem WHERE mem.MemEmpCode=@EmpCode


   	IF (@Option="SHAREMP") 
	BEGIN
	DECLARE @status VARCHAR(10)
	SELECT @status=m.Status   FROM speccs.Members m WHERE m.MemEmpCode=@EmpCode
	   		/* Adaptive Server has expanded all '*' elements in the following statement */ 
   		/* Adaptive Server has expanded all '*' elements in the following statement */ 
   		IF(@status='CANCELLED' OR @status='SETTLED' OR @status='CANCELED')
   		BEGIN 
   		SELECT  memData.MemEmpCode,memData.MemName, memData.PanNo, 
   		memData.AadharNo, memData.Phone, memData.OffPhone, memData.CareOf, 
   		memData.Division, memData.Designation, memData.MailId, 
   		memData.BasicPay, memData.Dob, memData.RetiredDate, 
   		memData.BankAccNo, memData.IfscCode, memData.BankName,
   		 memData.BankPlace, memData.UserId, memData.RegTime,member.Status
   	  FROM speccs.EmployeeData memData ,speccs.Members member
	   WHERE memData.MemEmpCode=member.MemEmpCode AND memData.MemEmpCode=@EmpCode
	   END 
	   
	   ELSE 
	   	SELECT  memData.MemEmpCode,memData.MemName, memData.PanNo, 
   		memData.AadharNo, memData.Phone, memData.OffPhone, memData.CareOf, 
   		memData.Division, memData.Designation, memData.MailId, 
   		memData.BasicPay, memData.Dob, memData.RetiredDate, 
   		memData.BankAccNo, memData.IfscCode, memData.BankName,
   		 memData.BankPlace, memData.UserId, memData.RegTime ,memData.Status
   	  FROM speccs.EmployeeData memData 
	   WHERE memData.MemEmpCode=@EmpCode
	   RETURN
	END
	IF(@Option = 'SOCIETYMEM')
	BEGIN 
	
	
		IF(@MemAccNo = '')
		BEGIN 
		/* Adaptive Server has expanded all '*' elements in the following statement */
		 SELECT mem.MemAccNo, mem.MemEmpCode, mem.MemName, mem.PanNo, mem.AadharNo, mem.MailId,
		  mem.Designation, mem.Division, mem.Phone, mem.OffPhone,mem.BasicPay, mem.MemDate,
		   mem.Dob, mem.RetiredDate, mem.Status, mem.CareOf, mem.ClosedDate, mem.Remarks, memAccount.MemAccNo, memAccount.MembershipFee, memAccount.ThriftSubscriptionAmount, 
		     memAccount.ThriftBalance, memAccount.ShareAmount, memAccount.NoOfShares, memAccount.WelfareFund,
		      memAccount.SERBS, memAccount.Insurance_Loan, memAccount.Insurance_Thrift, memAccount.UserId, memAccount.RegTime 
			FROM speccs.Members mem
			LEFT JOIN speccs.MemberBank mb
			ON mem.MemAccNo = mb.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			--WHERE mem.Status =@Status 
		END
		
		ELSE
		BEGIN 
		/* Adaptive Server has expanded all '*' elements in the following statement */
	   
	   
	      
            SELECT mem.MemAccNo, mem.MemEmpCode, mem.MemName, mem.PanNo, mem.AadharNo, mem.MailId,
		  mem.Designation, mem.Division, mem.Phone, mem.OffPhone, mem.BasicPay, mem.MemDate, mem.Dob,
		   mem.RetiredDate, mem.Status, mem.CareOf, mem.ClosedDate, mem.Remarks, mem.UserId,
		    mem.RegTime, memAccount.MemAccNo, memAccount.MembershipFee,
		     memAccount.ThriftSubscriptionAmount, memAccount.ThriftBalance, memAccount.ShareAmount,
		      memAccount.NoOfShares, memAccount.WelfareFund, memAccount.SERBS, memAccount.Insurance_Loan,
		       memAccount.Insurance_Thrift, memAccount.UserId, memAccount.RegTime         
			FROM speccs.Members mem
			LEFT JOIN speccs.MemberBank mb
			ON mem.MemAccNo = mb.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE mem.Status =@Status AND mem.MemAccNo =@MemAccNo
			END
			
		
		RETURN
	END
	
	
	
		IF(@Option = 'EMPDATA')
	
		BEGIN 
		
		SELECT A.MemName,A.Division,A.Designation,A.BasicPay,A.Dob,A.RetiredDate,A.MailId,
		A.PanNo,A.AadharNo,A.Phone,A.OffPhone,A.CareOf,A.BankAccNo,A.IfscCode,A.BankName,A.BankPlace FROM speccs.EmployeeData A
		WHERE A.MemEmpCode=@EmpCode
		
			
		RETURN
	END




	IF(@Option = 'LOADEMPDATA')
	
		BEGIN 
		
		SELECT DISTINCT A.MemEmpCode,A.MemName,A.Division,A.Designation,A.BasicPay,A.Dob,A.RetiredDate FROM speccs.EmployeeData A WHERE  A.MemEmpCode=@EmpCode
			
	  RETURN	
	END
	
	IF(@Option = 'STAFFLOADEMPDATA')
	
		BEGIN 
		
		/* Adaptive Server has expanded all '*' elements in the following statement */ SELECT st.SMemAccNo, st.SEmpName, st.PanNo, st.AdhaarNo, st.MailId, st.Phone, st.OfficePhone, st.BasicPay, st.MemDate, st.Dob, st.RegDate, st.RegStatus, st.CareOf, st.Remarks, st.UserID, st.RegTime  FROM speccs.Staff st WHERE st.SMemAccNo=@MemAccNo
			
	  RETURN	
	END

	IF(@Option = 'MEMINFO')
	
		BEGIN 
		
	  /* Adaptive Server has expanded all '*' elements in the following statement */ SELECT speccs.Members.MemAccNo, speccs.Members.MemEmpCode, speccs.Members.MemName, speccs.Members.PanNo, speccs.Members.AadharNo, speccs.Members.MailId, speccs.Members.Designation, speccs.Members.Division, speccs.Members.Phone, speccs.Members.OffPhone, speccs.Members.BankAccNo, speccs.Members.IfscCode, speccs.Members.BankName, speccs.Members.BankAddress, speccs.Members.BankPlace, speccs.Members.BasicPay, speccs.Members.MemDate, speccs.Members.Dob, speccs.Members.RetiredDate, speccs.Members.Status, speccs.Members.CareOf, speccs.Members.ClosedDate, speccs.Members.Remarks, speccs.Members.UserId, speccs.Members.RegTime FROM speccs.Members where MemEmpCode=@EmpCode and Status in ('DRAFT','SUBMIT')
			
	  RETURN	
	END


	IF(@Option = 'APPLINFO')
	
		BEGIN 
		
   SELECT MemAccNo, MembershipFee, ThriftSubscriptionAmount, ThriftBalance, ShareAmount,NoOfShares,
   WelfareFund,SERBS,Insurance_Loan, Insurance_Thrift FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNo
			
	  RETURN	
	END

	IF(@Option = 'BANKINFO')
	
		BEGIN 
		
   SELECT mb.Bankaccno,mb.Ifsccode,mb.Bankname,mb.Bankplace  FROM speccs.MemberBank mb WHERE mb.MemAccNo=@MemAccNo
			
	  RETURN	
	END

GO

