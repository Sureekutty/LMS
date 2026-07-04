
IF OBJECT_ID ('speccs.SP_MemberDetailsFDEMP') IS NOT NULL
	DROP PROCEDURE speccs.SP_MemberDetailsFDEMP
GO

CREATE  PROCEDURE speccs.SP_MemberDetailsFDEMP
@EmpCode VARCHAR(7) = NULL,
@Option  	VARCHAR (20),
@Status VARCHAR(10) = NULL,
@MemAccNo VARCHAR(5) = NULL,
@LoanType VARCHAR (20)


AS

/*
	DROP PROCEDURE  speccs.SP_MemberDetails
	
	GRANT ALL ON speccs.SP_MemberDetails to speccsgroup
*/
--DECLARE @LatestStatus VARCHAR(20)
--SELECT @LatestStatus=mem.Status FROM speccs.Members mem WHERE mem.MemEmpCode=@EmpCode


   IF(@Option = 'SOCIETYMEM')
	BEGIN 
		
	   
	   IF(@LoanType="LTL")
	   BEGIN
	   
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
	   ELSE IF(@LoanType="EXL")
	   BEGIN
	   
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
	   ELSE IF(@LoanType="FDL")
	   BEGIN
	   
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
			WHERE mem.Status IN ('SETTLED','ACTIVE') AND mem.MemAccNo =@MemAccNo
	   
	   END
	   
	   
	     /* 
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
			*/
			
	END


GO

