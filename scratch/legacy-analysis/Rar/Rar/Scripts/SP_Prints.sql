IF OBJECT_ID ('speccs.SP_Prints') IS NOT NULL
	DROP PROCEDURE speccs.SP_Prints
GO

CREATE  PROCEDURE speccs.SP_Prints
@Option  		VARCHAR (50),
@MemAccNo  		VARCHAR(10)= NULL,
@Receiptno     	VARCHAR(15)=NULL,
@LoanAccNo        VARCHAR(15) = NULL,
@Option4 		VARCHAR(15)=NULL

AS



--DROP PROC speccs.SP_Prints
--GRANT ALL ON speccs.SP_Prints to speccsgroup

 IF (@Option="APPSHAREANDMEMSHIP") 
	BEGIN
 SELECT m.MemAccNo,m.MemEmpCode,m.Designation,m.MemName,m.CareOf,m.Division,m.BasicPay,CONVERT(CHAR(10),m.Dob,103) as Dob,a.NoOfShares,
 n.NomName,n.Relationship,n.Address  FROM speccs.Members m JOIN speccs.Nominee n ON m.MemAccNo=n.MemAccNo 
 JOIN speccs.MemberAccount a ON m.MemAccNo=a.MemAccNo WHERE m.MemAccNo=@MemAccNo

RETURN
END

 IF (@Option="MONTHLYTHIFTDEPOSIT") 
	BEGIN

SELECT m.MemName,m.MemEmpCode,m.MemAccNo,m.Designation,m.Division,m.BasicPay,n.NomName,n.Relationship,n.Address FROM speccs.Members m
 join speccs.Nominee n on m.MemAccNo=n.MemAccNo WHERE  m.MemAccNo =@MemAccNo
				
RETURN
END


 IF (@Option="MEMDETAILS") 
	BEGIN

SELECT m.MemEmpCode,m.MemName,m.PanNo,m.AadharNo,m.MailId,m.Designation,m.Division,m.Phone,m.OffPhone,m.BankAccNo,
m.IfscCode,m.BankName,m.BankAddress,m.BasicPay,CONVERT(CHAR(10),m.MemDate,103)AS MemDate ,CONVERT(CHAR(10),m.Dob,103)AS Dob,CONVERT(CHAR(10),m.RetiredDate,103)AS RetiredDate,m.CareOf,m.Remarks,mac.ThriftSubscriptionAmount,
mac.ThriftBalance,mac.ShareAmount,mac.NoOfShares FROM speccs.Members m ,speccs.MemberAccount mac 
WHERE m.MemAccNo=mac.MemAccNo AND m.MemAccNo=@MemAccNo
				
RETURN
END


 IF (@Option="MEMNOMDETAILS") 
	BEGIN

SELECT n.NomineeId,n.NomName,n.NomDOB,n.Relationship,n.Gender,n.Address FROM speccs.Nominee n WHERE n.MemAccNo=@MemAccNo
				
RETURN
END


 IF (@Option="MEMADDDETAILS") 
	BEGIN

SELECT mad.MemberId,mad.Address1,mad.Address2,mad.City,mad.District,mad.State,mad.Pincode,mad.Remarks FROM speccs.MemAddress mad WHERE mad.MemAccNo=@MemAccNo
				
RETURN
END


 IF (@Option="BASICDETAILS") 
	BEGIN
SELECT  MemAccNo as AccNumber,MemEmpCode,MemName As Name,Designation As Desination,Division as Division,BasicPay as BasicPay ,
CareOf as Nominee,Phone as PhoneNo,CONVERT(CHAR(10),MemDate,103)as MemberDate FROM speccs.Members where MemAccNo =@MemAccNo
				
RETURN
END

 IF (@Option="THIFTLEDGER") 
	BEGIN
SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,macc.ThriftSubscriptionAmount,mem.Designation,macc.ThriftBalance,
CONVERT(CHAR(10),thr.Month,103) AS Month,thr.ReceiptNo,thr.Amount,thr.ModeOfPayment FROM speccs.Members mem 
 inner JOIN speccs.MemberAccount macc on mem.MemAccNo=macc.MemAccNo inner JOIN  
 speccs.DepositTransactions thr on mem.MemAccNo=thr.MemaccNo WHERE mem.MemAccNo =@MemAccNo AND thr.ReceiptNo=@Receiptno

RETURN
END


 IF (@Option="LOANDETAILS") 
	BEGIN
DECLARE @surety1temp VARCHAR(10),@surety2temp VARCHAR(10),@surety3temp VARCHAR(10)

SELECT @surety1temp=Surety1,@surety2temp=Surety2,@surety3temp=Surety3 FROM speccs.Loans WHERE LoanAccNo=@LoanAccNo

SELECT mem.MemAccNo, mem.MemEmpCode, mem.MemName,memloan.LoanAccNo,memloan.LoanType,mem.BasicPay, mem.BasicPay*30 AS Eligibility,memloanstatus.Thriftdudamt AS ThriftDeductAmount,memloanstatus.ChequeAmount,memloanstatus.LoanSanctionAmount AS LoanstatusSanctionAmount,
memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,
memloan.FundId,memloan.LoanSanctionAmount,sur.SMemAccNo,memloan.InterestMethod,memloan.InterestRate,memloan.LoanSanctionDate,
CONVERT (CHAR(10),memloan.Loanappdate,103) AS Loanappdate,memloan.DisbursedOnDate,memAccount.ThriftSubscriptionAmount,memAccount.ThriftBalance,
memAccount.ShareAmount,memAccount.NoOfShares,prin_OS=memloan.LoanSanctionAmount-(select SUM(Amount) from speccs.LoanTransactions where LoanAccNo=@LoanAccNo and P_I='P'),
remainingInstallments=memloan.NoOfInstallments-(select count(*) from speccs.LoanTransactions where LoanAccNo=@LoanAccNo and P_I='P'),
(SELECT MemEmpCode FROM speccs.Members  WHERE MemAccNo=@surety1temp) AS Surety1Code,(SELECT MemEmpCode FROM speccs.Members  WHERE MemAccNo=@surety2temp) AS Surety2Code,
(SELECT MemEmpCode FROM speccs.Members  WHERE MemAccNo=@surety3temp) AS Surety3Code,
(SELECT MemName FROM speccs.Members  WHERE MemAccNo=@surety1temp) AS Surety1Name,
(SELECT MemName FROM speccs.Members  WHERE MemAccNo=@surety2temp) AS Surety2Name,
(SELECT MemName FROM speccs.Members  WHERE MemAccNo=@surety3temp) AS Surety3Name,
(SELECT ThriftBalance FROM speccs.MemberAccount  WHERE MemAccNo=@surety1temp) AS Surety1ThriftBal,
(SELECT ThriftBalance FROM speccs.MemberAccount  WHERE MemAccNo=@surety2temp) AS Surety2ThriftBal,
(SELECT ThriftBalance FROM speccs.MemberAccount  WHERE MemAccNo=@surety3temp) AS Surety3ThriftBal
			FROM speccs.Members mem
			LEFT JOIN speccs.Loans memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.Loanstatus memloanstatus
			ON memloan.MemAccNo = memloanstatus.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			RIGHT JOIN speccs.Surety sur
			ON sur.MemAccNo = memloan.MemAccNo
			WHERE memloan.LoanAccNo=@LoanAccNo
			ORDER BY memloanstatus.Thriftdudamt DESC
			
			
	  -- SELECT @surety1temp=Surety1,@surety1temp=Surety2,@surety1temp=Surety3 FROM speccs.Loans WHERE LoanAccNo=@LoanAccNo
			
			--SELECT 
RETURN
END


 IF (@Option="LOANDETAILS2") 
	BEGIN
SELECT  mp.Month,Purposecode=(select Description from speccs.TransactionType where  PayCode=mp.Purposecode),
convert(char(10),mp.Processdate,103) AS Processdate  ,mp.Recoveryamount FROM speccs.MonthlyProcess mp WHERE mp.Refid=@LoanAccNo

RETURN
END






 IF (@Option="RECEIPTREPORT") 
	BEGIN
	-------------Added 13-10-2025
    	DECLARE @MemAcc VARCHAR(17)   
 IF EXISTS(SELECT rr.PurposeCode FROM speccs.Receipts rr  
 	WHERE rr.ReceiptDate BETWEEN @LoanAccNo  AND @Option4   AND(rr.PurposeCode='EXL' OR rr.PurposeCode='FDL' OR rr.PurposeCode='LTL'))

    BEGIN
	SELECT MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),r.ReceiptNo,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,
	purpose=r.PurposeCode,
	r.Amount,MemName=(select MemName from speccs.Members where MemAccNo=r.MemAccNO) FROM speccs.Receipts r 
	WHERE PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4 AND Status='ACTIVE'
	
	RETURN
	END
	-----------------------------------------
	
	
		ELSE IF (@Receiptno='B22')
	BEGIN
	
   
   --	SELECT @MemAcc=MemAccNo FROM speccs.Deposits WHERE DepositNo=(SELECT RefNo from speccs.Receipts WHERE ReceiptNo=ReceiptNo AND  PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4)

 --	SELECT @MemAcc=MemAccNO  from speccs.Receipts WHERE  PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4

/*
	SELECT r.ReceiptNo AS ReceiptNo,MemAccNO=(SELECT MemEmpCode from speccs.Members WHERE MemAccNo=(SELECT MemAccNO from speccs.Receipts WHERE ReceiptNo=r.ReceiptNo)) ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,
   --	purpose=r.PurposeCode,
   MemName=(select MemName from speccs.Members WHERE MemAccNo=(SELECT MemAccNO from speccs.Receipts WHERE ReceiptNo=r.ReceiptNo)),	r.Amount FROM speccs.Receipts r 
	WHERE PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4 AND Status='ACTIVE'
	 
	 
	 SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@purposecode 


	SELECT 0 AS Amount,'ReceiptNo' AS ReceiptNo,'' AS ReceiptDate ,
	0 AS purpose,
	0 AS MemName ,'PurCode' AS MemAccNO 

 UNION 
 */
 	SELECT ROUND(BankBalance,2) AS Amount,ReceiptNo,convert(CHAR(10),TransactionDate,103) AS ReceiptDate ,
	BankBalance AS purpose,
	Amount AS MemName ,PurCode AS MemAccNO 	FROM speccs.BankTransactions  

  
	
	END
	
	
	-------------------------------------------
	
	ELSE IF (@Receiptno='D14' OR @Receiptno='D17'  )
	BEGIN
	
   
   --	SELECT @MemAcc=MemAccNo FROM speccs.Deposits WHERE DepositNo=(SELECT RefNo from speccs.Receipts WHERE ReceiptNo=ReceiptNo AND  PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4)

	SELECT @MemAcc=MemAccNO  from speccs.Receipts WHERE  PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4


	SELECT r.ReceiptNo AS ReceiptNo,MemAccNO=(SELECT MemEmpCode from speccs.Members WHERE MemAccNo=(SELECT MemAccNO from speccs.Receipts WHERE ReceiptNo=r.ReceiptNo)) ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,
   --	purpose=r.PurposeCode,
   MemName=(select MemName from speccs.Members WHERE MemAccNo=(SELECT MemAccNO from speccs.Receipts WHERE ReceiptNo=r.ReceiptNo)),	r.Amount FROM speccs.Receipts r 
	WHERE PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4 AND Status='ACTIVE'
	
	
	END
	
	ELSE IF (@Receiptno='D20'  )
	BEGIN
	
   
   --	SELECT @MemAcc=MemAccNo FROM speccs.Deposits WHERE DepositNo=(SELECT RefNo from speccs.Receipts WHERE ReceiptNo=ReceiptNo AND  PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4)

	SELECT @MemAcc=MemAccNO  from speccs.Receipts WHERE  PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4
--

--DECLARE @MemNamedepNo VARCHAR(200)
--SELECT MemAccNo from speccs.Deposits WHERE DepositNo=r.RefNo

	SELECT r.ReceiptNo AS ReceiptNo,r.RefNo AS MemAccNO,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,
   --	purpose=r.PurposeCode,
   MemName=(select MemName from speccs.Members where MemAccNo=(SELECT MemAccNo from speccs.Deposits WHERE DepositNo=r.RefNo
)),	r.Amount FROM speccs.Receipts r 
	WHERE PurposeCode = @Receiptno AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4 AND r.Status='ACTIVE'
	
	
	END
	
	
	ELSE IF (@Receiptno='R11')
	BEGIN
	
		SELECT r.ReceiptNo AS ReceiptNo ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),
   --	purpose=r.PurposeCode,
   MemName=(SELECT Description from speccs.TransactionType WHERE PayCode=r.PurposeCode),	r.Amount FROM speccs.Receipts r 
	WHERE ReceiptDate BETWEEN @LoanAccNo  AND @Option4 
	
	
	
	END
		
	ELSE IF (@Receiptno='M03')
	BEGIN
	
		SELECT r.ReceiptNo AS ReceiptNo ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),
   --	purpose=r.PurposeCode,
   MemName=@Receiptno,r.Amount FROM speccs.Receipts r  WHERE r.PurposeCode = @Receiptno AND r.ReceiptDate<=@Option4 AND r.ReceiptDate>=@LoanAccNo AND r.Status='ACTIVE'
   ---- r.ReceiptDate BETWEEN @LoanAccNo  AND @Option4
	
	
	END
		ELSE IF (@Receiptno='M06')
	BEGIN
	
		SELECT r.ReceiptNo AS ReceiptNo ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),
   --	purpose=r.PurposeCode,
   MemName=@Receiptno,r.Amount FROM speccs.Receipts r  WHERE r.PurposeCode = @Receiptno AND r.ReceiptDate<=@Option4 AND r.ReceiptDate>=@LoanAccNo AND r.Status='ACTIVE'
   ---- r.ReceiptDate BETWEEN @LoanAccNo  AND @Option4
	
	
	END
	ELSE IF (@Receiptno='M43')
	BEGIN
	
		SELECT r.ReceiptNo AS ReceiptNo ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),
   --	purpose=r.PurposeCode,
   MemName=@Receiptno,r.Amount FROM speccs.Receipts r  WHERE r.PurposeCode = @Receiptno AND r.ReceiptDate<=@Option4 AND r.ReceiptDate>=@LoanAccNo AND r.Status='ACTIVE'
   ---- r.ReceiptDate BETWEEN @LoanAccNo  AND @Option4
	
	END 
		ELSE IF (@Receiptno='L42')
	BEGIN
	
		SELECT r.ReceiptNo AS ReceiptNo ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),
   --	purpose=r.PurposeCode,
   MemName=@Receiptno,r.Amount FROM speccs.Receipts r  WHERE r.PurposeCode = @Receiptno AND r.ReceiptDate<=@Option4 AND r.ReceiptDate>=@LoanAccNo AND r.Status='ACTIVE'
   ---- r.ReceiptDate BETWEEN @LoanAccNo  AND @Option4
	
	END 
	ELSE IF (@Receiptno='C43')
	BEGIN
	
		SELECT r.ReceiptNo AS ReceiptNo ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),
   --	purpose=r.PurposeCode,
   MemName=@Receiptno,r.Amount FROM speccs.Receipts r  WHERE r.PurposeCode = 'L42' AND r.ReceiptDate<=@Option4 AND r.ReceiptDate>=@LoanAccNo AND r.Status='ACTIVE' AND r.RefNo LIKE 'LTL%'
   ---- r.ReceiptDate BETWEEN @LoanAccNo  AND @Option4
	
	END 
	ELSE IF (@Receiptno='C44')
	BEGIN
	
		SELECT r.ReceiptNo AS ReceiptNo ,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,MemAccNO=(select MemEmpCode from speccs.Members where MemAccNo=r.MemAccNO),
   --	purpose=r.PurposeCode,
   MemName=@Receiptno,r.Amount FROM speccs.Receipts r  WHERE r.PurposeCode = 'L42' AND r.ReceiptDate<=@Option4 AND r.ReceiptDate>=@LoanAccNo AND r.Status='ACTIVE' AND r.RefNo LIKE 'EXL%'
   ---- r.ReceiptDate BETWEEN @LoanAccNo  AND @Option4
	
	END 
	ELSE IF (@Receiptno='B11')
	BEGIN
	/*
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=(SELECT Description from speccs.TransactionType WHERE PayCode=p.PurposeCode) FROM speccs.Payments p 
		WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 */
		
		/* Adaptive Server has expanded all '*' elements in the following statement */
		 SELECT speccs.TransactionType.PayCode, speccs.TransactionType.Description, speccs.TransactionType.PaymentReceipt, speccs.TransactionType.SalaryCode, speccs.TransactionType.AccountCode, speccs.TransactionType.UserId, speccs.TransactionType.RegTime, speccs.TransactionType.ScreenType INTO speccs.TransactionTypeTemp FROM speccs.TransactionType 
		 WHERE PayCode NOT IN ('B11','P11','R11','L42','D08','D09','D15','D16','D18','D19','D21','D22','L23','L28','L33','L38','L39','L40','L42','M04','M05','M07','M09','M10')

DECLARE @PayCodePExists VARCHAR(15)
DECLARE @PayCodeRExists VARCHAR(15)
DECLARE @SumAmount1 FLOAT  

      	WHILE EXISTS (SELECT 1 FROM speccs.TransactionTypeTemp WHERE PaymentReceipt IN ('R'))
			BEGIN
			
  
			    SELECT TOP 1 @PayCodePExists = PayCode FROM speccs.TransactionTypeTemp
			    SELECT @SumAmount1=sum(Amount) FROM speccs.Receipts WHERE PurposeCode=@PayCodePExists AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4 AND Status='ACTIVE'
 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)
 --SELECT TOP 1 @PayCodePExists AS PayVoucherNo,@Option4 AS VoucherDate ,
   --			@PayCodePExists AS MemAccNo,MemName=(select Description from speccs.TransactionType where PayCode=@PayCodePExists),@SumAmount1 AS Amount FROM speccs.Payments p 
	  --	WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
			  
			DECLARE @Desc VARCHAR(50)
   
   SELECT @Desc=Description from speccs.TransactionType where PayCode=@PayCodePExists
   
 INSERT INTO speccs.BalancesheetPL VALUES ( @PayCodePExists,@Option4 ,@PayCodePExists,@Desc,@SumAmount1 )
		
		--SELECT PayVoucherNo AS PayVoucherNo,VoucherDate AS VoucherDate , PayAccNo AS MemAccNo, MemName, Amount AS Amount  FROM speccs.BalancesheetPL  
		
			
				    
			    DELETE FROM TransactionTypeTemp WHERE PayCode= @PayCodePExists
			
END 
-------------------------------------------
/*
DECLARE @SumAmount2 FLOAT  
SELECT @SumAmount2=sum(Amount) FROM speccs.Receipts WHERE PurposeCode IN ('L27') AND Amount > 0 AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4 AND Status='ACTIVE'

 SELECT @SumAmount2 =(CASE WHEN @SumAmount2 = NULL THEN 0 ELSE @SumAmount2 END)
 --SELECT TOP 1 @PayCodePExists AS PayVoucherNo,@Option4 AS VoucherDate ,
   --			@PayCodePExists AS MemAccNo,MemName=(select Description from speccs.TransactionType where PayCode=@PayCodePExists),@SumAmount1 AS Amount FROM speccs.Payments p 
	  --	WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
			  
			--DECLARE @Desc VARCHAR(50)
   
   SELECT @Desc=Description from speccs.TransactionType where PayCode='L27'
   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'L27',@Option4 ,'L27',@Desc,@SumAmount2 )
		
		--SELECT PayVoucherNo AS PayVoucherNo,VoucherDate AS VoucherDate , PayAccNo AS MemAccNo, MemName, Amount AS Amount  FROM speccs.BalancesheetPL  
		
			


--------------------------------------------
*/

------------------------------
SELECT  @SumAmount1=sum(Amount) FROM speccs.Receipts WHERE PurposeCode='L42' AND Status ='ACTIVE' AND RefNo LIKE 'LTL%'  AND ReceiptDate  BETWEEN @LoanAccNo  AND @Option4 

 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)

   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'L42' ,@Option4 ,'L42' ,'LTL contra',@SumAmount1 )


SELECT  @SumAmount1=sum(Amount) FROM speccs.Receipts WHERE PurposeCode='L42' AND Status ='ACTIVE' AND RefNo LIKE 'EXL%'  AND ReceiptDate  BETWEEN @LoanAccNo  AND @Option4 

 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)

   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'L43' ,@Option4 ,'L43' ,'EXL Contra',@SumAmount1 )

----------------------------------Added  on 10/02/2026 By JS- feedback Society Team

SELECT  @SumAmount1=sum(Amount) FROM speccs.Receipts WHERE PurposeCode IN ('D14''D17','D20','L24','L25',
'L26','L27','L29','L30','L31',
'L32','L34','L35','L36','L37',
'L41','L66','L67','M01','M02',
'M03','M06','M33','M34','M43') AND Status ='ACTIVE' 
AND ReceiptDate  BETWEEN @LoanAccNo  AND @Option4 


 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)

   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'R12' ,@Option4 ,'R12' ,'Current Account With SBI Withdrawals',@SumAmount1 )

------------------------------
------------------------------

		SELECT PayVoucherNo AS ReceiptNo,VoucherDate AS ReceiptDate , PayAccNo AS MemAccNo, MemName, Amount AS Amount  FROM speccs.BalancesheetPL  


DROP TABLE  speccs.TransactionTypeTemp
DELETE FROM speccs.BalancesheetPL 
		
		
		
	
	END
	
	ELSE 
	BEGIN
	SELECT r.MemAccNO,r.ReceiptNo,convert(CHAR(10),r.ReceiptDate,103) AS ReceiptDate ,
	purpose=(select Description from speccs.TransactionType where PayCode=r.PurposeCode),
	r.Amount,MemName=(select MemName from speccs.Members where MemAccNo=r.MemAccNO) FROM speccs.Receipts r 
	WHERE PurposeCode IN( @Receiptno) AND ReceiptDate BETWEEN @LoanAccNo  AND @Option4 AND Status='ACTIVE'
	
	
	RETURN
	END
	
	END
	
	IF (@Option="PAYMENTREPORT") 
	BEGIN
	
	IF (@Receiptno='P11')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=(SELECT Description from speccs.TransactionType WHERE PayCode=p.PurposeCode) FROM speccs.Payments p 
		WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
	
	END
		
		ELSE IF (@Receiptno='L23')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=@Receiptno FROM speccs.Payments p  
		WHERE p.PurposeCode=@Receiptno and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
	
	END
	--------------------------11-12-2025 Start
		
			ELSE IF (@Receiptno='D19')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=@Receiptno FROM speccs.Payments p  
		WHERE p.PurposeCode=@Receiptno and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
	
	END
	
		--------------------------11-12-2025 End 
		ELSE IF (@Receiptno='L28')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=@Receiptno FROM speccs.Payments p  
		WHERE p.PurposeCode=@Receiptno and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
	
	END
	
		
		ELSE IF (@Receiptno='L33')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=@Receiptno FROM speccs.Payments p  
		WHERE p.PurposeCode=@Receiptno and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 AND p.RefNo LIKE 'FDL%' AND p.Status='ACTIVE'
	
	END
	ELSE IF (@Receiptno='L42')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=@Receiptno FROM speccs.Payments p  
		WHERE p.PurposeCode=@Receiptno and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
	
	END
	
	ELSE IF (@Receiptno='C43')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=@Receiptno FROM speccs.Payments p  
		WHERE p.PurposeCode='L42' and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 AND p.RefNo LIKE 'LTL%'
	
	END
	ELSE IF (@Receiptno='C44')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=@Receiptno FROM speccs.Payments p  
		WHERE p.PurposeCode='L42' and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 AND p.RefNo LIKE 'EXL%'
	
	END
		ELSE IF (@Receiptno='M46')
	BEGIN
	
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName= p.Remarks  FROM speccs.Payments p  
		WHERE p.PurposeCode=@Receiptno and  p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
	
	END
	
	ELSE IF (@Receiptno='B11')
	BEGIN
	/*
	
	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=(SELECT Description from speccs.TransactionType WHERE PayCode=p.PurposeCode) FROM speccs.Payments p 
		WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 */
		
	SELECT speccs.TransactionType.PayCode, speccs.TransactionType.Description, speccs.TransactionType.PaymentReceipt, speccs.TransactionType.SalaryCode, speccs.TransactionType.AccountCode, speccs.TransactionType.UserId, speccs.TransactionType.RegTime, speccs.TransactionType.ScreenType INTO speccs.TransactionTypeTemp2 FROM speccs.TransactionType 
	WHERE PayCode NOT IN ('B11','P11','R11','L42','L33','D08','D09','D20','L24','L25','L26','L27','L29','L30','L31','L32','L34','L35','L36','L37','L66','L67','M03','M34','M43')


--DECLARE @PayCodePExists VARCHAR(15)
--DECLARE @PayCodeRExists VARCHAR(15)
--DECLARE @SumAmount1 INT 

      	WHILE EXISTS (SELECT 1 FROM speccs.TransactionTypeTemp2 WHERE PaymentReceipt IN ('P'))
			BEGIN
			
  
			    SELECT TOP 1 @PayCodePExists = PayCode FROM speccs.TransactionTypeTemp2
			    SELECT @SumAmount1=sum(Amount) FROM speccs.Payments WHERE PurposeCode=@PayCodePExists AND VoucherDate BETWEEN @LoanAccNo  AND @Option4 
 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)
 --SELECT TOP 1 @PayCodePExists AS PayVoucherNo,@Option4 AS VoucherDate ,
   --			@PayCodePExists AS MemAccNo,MemName=(select Description from speccs.TransactionType where PayCode=@PayCodePExists),@SumAmount1 AS Amount FROM speccs.Payments p 
	  --	WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4 
			  
		   --	DECLARE @Desc VARCHAR(50)
   
   SELECT @Desc=Description from speccs.TransactionType where PayCode=@PayCodePExists
   
 INSERT INTO speccs.BalancesheetPL VALUES ( @PayCodePExists,@Option4 ,@PayCodePExists,@Desc,@SumAmount1 )
		
		--SELECT PayVoucherNo AS PayVoucherNo,VoucherDate AS VoucherDate , PayAccNo AS MemAccNo, MemName, Amount AS Amount  FROM speccs.BalancesheetPL  
		
			
				    
			    DELETE FROM TransactionTypeTemp2 WHERE PayCode= @PayCodePExists
			
END 

------------------------------
SELECT  @SumAmount1=sum(Amount) FROM speccs.Payments WHERE PurposeCode='L42' AND Status='ACTIVE' AND RefNo LIKE 'LTL%'  AND VoucherDate BETWEEN @LoanAccNo  AND @Option4 

 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)

   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'L42' ,@Option4 ,'L42' ,'LTL contra',@SumAmount1 )


SELECT  @SumAmount1=sum(Amount) FROM speccs.Payments WHERE PurposeCode='L42' AND Status='ACTIVE' AND RefNo LIKE 'EXL%'  AND VoucherDate BETWEEN @LoanAccNo  AND @Option4 

 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)

   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'L43' ,@Option4 ,'L43' ,'EXL Contra',@SumAmount1 )


SELECT  @SumAmount1=sum(Amount) FROM speccs.Payments WHERE PurposeCode='L33' AND Status='ACTIVE' AND RefNo LIKE 'FDL%'  AND VoucherDate BETWEEN @LoanAccNo  AND @Option4 

 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)

   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'L33' ,@Option4 ,'L33' ,'FDL Loan Disbursement',@SumAmount1 )
 
 
 ------------------------------------------Added on 10/02/2026 by Js - FeedBackSociety team 
 
 
 SELECT  @SumAmount1=sum(Amount) FROM speccs.Payments WHERE PurposeCode IN ('D14','D15','D16','D17','D18',
'D19','D21','D22','L01','L23',
'L28','L38','L39','L40','L41',
'M01','M02','M04','M05','M06',
'M07','M08','M09','M10','M12',
'M13','M33','M46','P34') AND Status='ACTIVE' AND VoucherDate BETWEEN '01/01/2026'  AND '01/31/2026' 

 SELECT @SumAmount1 =(CASE WHEN @SumAmount1 = NULL THEN 0 ELSE @SumAmount1 END)

   
 INSERT INTO speccs.BalancesheetPL VALUES ( 'P12' ,@Option4 ,'P12' ,'Current Account With SBI - Deposits',@SumAmount1 )
 
 
 
 -------------------------------------------


------------------------------


		SELECT PayVoucherNo AS PayVoucherNo,VoucherDate AS VoucherDate , PayAccNo AS MemAccNo, MemName, Amount AS Amount  FROM speccs.BalancesheetPL  


DROP TABLE  speccs.TransactionTypeTemp2
DELETE FROM speccs.BalancesheetPL 
		
		
		
	
	END
	
	ELSE
	BEGIN
	
 	SELECT MemAccNo=(select MemEmpCode from speccs.Members where MemAccNo=p.MemAccNo),p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=(select MemName from speccs.Members where MemAccNo=p.MemAccNo) FROM speccs.Payments p 
		WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4  AND p.PurposeCode=@Receiptno
	
	/*--added by pn on 25/06/2025 for MIS Payments Report told by rama rao
	IF(@Receiptno='D19')
	BEGIN 
		SELECT p.MisNo AS PayVoucherNo,convert(CHAR(10),p.Month,103) AS VoucherDate,'D19' AS purpose,p.PaidInterest AS Amount,m.MemAccNo,m.MemEmpCode,m.MemName
		FROM speccs.MisPayments p,speccs.Deposits d,speccs.Members m
		WHERE p.MisNo=d.DepositNo AND d.MemAccNo=m.MemAccNo
	END
	ELSE
	BEGIN 
		SELECT p.MemAccNo,p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS VoucherDate,
		purpose=(select Description from speccs.TransactionType where PayCode=p.PurposeCode),p.Amount,
		MemName=(select MemName from speccs.Members where MemAccNo=p.MemAccNo) FROM speccs.Payments p 
		WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4
	END 
	*/
	END 
	RETURN
	END
	
		
	IF (@Option="CAHSBOOKREPORT") 
	BEGIN

	SELECT r.MemAccNO,r.ReceiptNo,convert(CHAR(10),r.ReceiptDate,103) AS dt ,purpose=(select PayCode+"-"+Description 
	from speccs.TransactionType where PayCode=r.PurposeCode),r.Amount,MemName=(select MemName from speccs.Members 
	where MemAccNo=r.MemAccNO) into #t2 FROM speccs.Receipts r 
	WHERE ReceiptDate BETWEEN @LoanAccNo  AND @Option4
	insert into #t2 SELECT p.MemAccNo,p.PayVoucherNo,convert(CHAR(10),p.VoucherDate,103) AS dt,
	purpose=(select PayCode+"-"+Description from speccs.TransactionType where  PayCode=p.PurposeCode),p.Amount,
	MemName=(select MemName from speccs.Members where MemAccNo=p.MemAccNo) 
	FROM speccs.Payments p WHERE p.VoucherDate BETWEEN @LoanAccNo  AND @Option4
	
	/* Adaptive Server has expanded all '*' elements in the following statement */ 
		select #t2.MemAccNO, #t2.ReceiptNo, #t2.dt, count(#t2.purpose) AS purCount,#t2.purpose,#t2.Amount, sum(#t2.Amount) AS totalAmount, #t2.MemName from #t2 GROUP BY purpose order by purpose desc
	
	
	RETURN
	END
	
	

 IF (@Option="MEMETAILS") 
 
 
	BEGIN
	BEGIN TRANSACTION
SELECT mem.MemAccNo, mem.MemEmpCode, mem.MemName, mem.PanNo, mem.AadharNo, mem.MailId,
		  mem.Designation, mem.Division, mem.Phone, mem.OffPhone, mem.BasicPay,CONVERT(CHAR(10),mem.MemDate,103)AS MemDate,
		   CONVERT(CHAR(10),mem.Dob,103)AS Dob,CONVERT(CHAR(10),mem.RetiredDate,103)AS RetiredDate, mem.Status, mem.CareOf, mem.Remarks,
		     memAccount.MembershipFee, memAccount.ThriftSubscriptionAmount, 
		     memAccount.ThriftBalance, memAccount.ShareAmount, memAccount.NoOfShares, memAccount.WelfareFund,
		      memAccount.SERBS, memAccount.Insurance_Loan, memAccount.Insurance_Thrift,convert(char(10),memAccount.RegTime,103) AS RegTime  
			FROM speccs.Members mem
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE memAccount.MemAccNo=@MemAccNo

	COMMIT TRANSACTION
RETURN
END

 IF (@Option="STAFFMEMETAILS") 
 
 
	BEGIN
	BEGIN TRANSACTION
SELECT stfmem.SMemAccNo AS MemAccNo,stfmem.SEmpName AS MemName, stfmem.PanNo,stfmem.AdhaarNo AS AadharNo, stfmem.MailId AS MailId,
		   stfmem.Phone, stfmem.OfficePhone AS OffPhone, stfmem.BasicPay AS BasicPay,CONVERT(CHAR(10),stfmem.MemDate,103)AS MemDate,
		   CONVERT(CHAR(10),stfmem.Dob,103)AS Dob, stfmem.RegStatus AS Status, stfmem.CareOf, stfmem.Remarks,
		     memAccount.MembershipFee, memAccount.ThriftSubscriptionAmount, 
		     memAccount.ThriftBalance, memAccount.ShareAmount, memAccount.NoOfShares, memAccount.WelfareFund,
		      memAccount.SERBS, memAccount.Insurance_Loan, memAccount.Insurance_Thrift,convert(char(10),memAccount.RegTime,103) AS RegTime  
			FROM speccs.Staff stfmem
			LEFT JOIN speccs.MemberAccount memAccount
			ON stfmem.SMemAccNo = memAccount.MemAccNo
			WHERE memAccount.MemAccNo=@MemAccNo

	COMMIT TRANSACTION
RETURN
END


IF (@Option="DEPOSITDETAILS") 
	BEGIN

SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,memDeposit.DepositNo,memDeposit.DepositType,memDeposit.IntRate,Convert(CHAR(10),memDeposit.OpenDate,103) AS OpenDate ,
memDeposit.Duration,memDeposit.MaturityAmount,memDeposit.Subscription,memDeposit.Remarks,memDeposit.Subscription,
memDeposit.RegTime
			FROM speccs.Members mem
			LEFT JOIN speccs.Deposits memDeposit
			ON mem.MemAccNo=memDeposit.MemAccNo
			WHERE memDeposit.DepositNo=@Option4
RETURN
END
IF (@Option="DEPOSITNOMINEE") 
	BEGIN

SELECT nom.NomName FROM speccs.Nominee nom
			LEFT JOIN speccs.NomineeRef nomref
			ON nom.NomineeId=nomref.NomineeId
			WHERE nomref.Depositno=@Option4
RETURN
END

IF (@Option="RECEIPTLEDGER") 
	BEGIN
	
	DECLARE @purposedesc VARCHAR(150)
	
	DECLARE @purposecode VARCHAR(150)
	
	SELECT @purposecode= PurposeCode FROM speccs.Receipts WHERE ReceiptNo=@Receiptno
	
	SELECT @purposedesc=Description FROM speccs.TransactionType WHERE PayCode=@purposecode

SELECT @purposedesc AS purposedesc,rr.MemAccNO,rr.ReceiptNo,convert(CHAR(10),rr.ReceiptDate,103) AS ReceiptDate,rr.PurposeCode,rr.Amount,rr.RefNo   FROM speccs.Receipts rr WHERE ReceiptNo=@Receiptno
RETURN
END
--added by pn on 06/06/2024
IF (@Option="GENERALLEDGER") 
	BEGIN
	SELECT  ReceiptNo, Amount,convert(CHAR(10),(ReceiptDate),101) AS recDate FROM speccs.Receipts 
	WHERE ReceiptDate BETWEEN @LoanAccNo AND @Option4
	GROUP BY convert(date,(ReceiptDate),103)
	HAVING PurposeCode=@Receiptno
	union
	SELECT  PayVoucherNo, sum(Amount) AS Amount,convert(CHAR(10),(VoucherDate),103) AS VoucherDate FROM speccs.Payments 
	WHERE VoucherDate BETWEEN @LoanAccNo AND @Option4
	GROUP BY convert(date,(VoucherDate),103)
	HAVING PurposeCode=@Receiptno
 RETURN
END


IF (@Option="DEPOSITMONTHS") 
IF EXISTS(SELECT * FROM speccs.DepositTransactions WHERE MemaccNo=@MemAccNo AND DepositTypeCode=@Option4)
	BEGIN
SELECT Month,Amount,convert(CHAR(10),RegTime,103) AS RegTime FROM speccs.DepositTransactions 	WHERE MemaccNo=@MemAccNo AND DepositTypeCode=@Option4
RETURN
END
ELSE
BEGIN
SELECT '- ' AS Month,0 AS Amount,'00-00-0000' AS RegTime
RETURN
END

IF (@Option="BANKINFO") 
	BEGIN

SELECT mb.Bankaccno,mb.Ifsccode,mb.Bankname,mb.Bankplace  FROM speccs.MemberBank mb WHERE mb.MemAccNo=@MemAccNo
RETURN
END

--------Daily Accounts Process--------------
IF (@Option="DAP") 
	BEGIN

SELECT convert(CHAR(10),dap.ProcessDate,103) AS ProcessDate,a.AccountDescription,dap.Amount,dap.UserId
 FROM speccs.DailyAccountsProcessing dap
 LEFT JOIN speccs.Accounts a
 ON a.AccountCode=dap.AccountCode
  WHERE dap.ProcessDate=@Option4
RETURN
END


















GO

