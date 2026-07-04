IF OBJECT_ID ('speccs.SP_MonthlyProcess') IS NOT NULL
	DROP PROCEDURE speccs.SP_MonthlyProcess
GO

CREATE PROCEDURE speccs.SP_MonthlyProcess

@option VARCHAR(20),
@purcode VARCHAR(4),
@month  VARCHAR(10),
@empcode VARCHAR(7),
@amount FLOAT,
@UserId CHAR(7),
@promonth VARCHAR(12),
@ReceiptNo		VARCHAR(14) OUTPUT 
AS


	
/*
	DROP PROCEDURE  speccs.SP_MonthlyProcess
	
	GRANT ALL ON speccs.SP_MonthlyProcess to speccsgroup
*/

	if(@option='PROCESS')
	begin
	
	--month data deletion
	delete from speccs.MonthlyProcess where Month=@month
	
	--PRI_RECOVERY - START

	SELECT MemAccNo,LoanAccNo,LoanType,LoanSanctionAmount,InterestRate,NoOfInstallments,MonthlyInstallments into #t1 FROM speccs.Loans 
	where LoanStatus='RELEASED' and LoanType in ('LTL','EXL')
	
	select LoanAccNo,CB=MIN(ClosingBal),TXdate=MAX(TransactionDate),installCount=COUNT(*) into #t2 from speccs.LoanTransactions where P_I='P' group by LoanAccNo


	INSERT INTO speccs.MonthlyProcess
	select @promonth,#t1.MemAccNo,
	purcode=case when LoanType='LTL' then 'L24' when LoanType='EXL' then 'L29' else null end,
	#t1.LoanAccNo,GETDATE(),
	(select MemEmpCode from speccs.Members where MemAccNo=#t1.MemAccNo),
	Salcode=case when LoanType='LTL' then 235 when LoanType='EXL' then 277 when LoanType='FDL' then 103 else null end,
	amount=case when #t1.LoanSanctionAmount < #t1.MonthlyInstallments then #t1.LoanSanctionAmount else #t1.MonthlyInstallments end,0,null,'R',@UserId,GETDATE()
	from #t1, #t2 where #t1.LoanAccNo=#t2.LoanAccNo
	
	  --INT_RECOVERY -START
	   

	declare @enddate datetime
	select @enddate=@promonth --(Eg. 05/01/2021 - 1st of May which is the processing month)

    
	INSERT INTO speccs.MonthlyProcess
	select @month,#t1 .MemAccNo,
	purcode=case when LoanType='LTL' then 'L25' when LoanType='EXL' then 'L30' else null end,
	#t1 .LoanAccNo,GETDATE(),(select MemEmpCode from speccs.Members where MemAccNo=#t1 .MemAccNo),
	Salcode=case when LoanType='LTL' then 319 when LoanType='EXL' then 337 else null end,
	amount=CASE WHEN speccs.SP_getIntAmount(#t1.LoanType,@month,#t1.LoanAccNo,#t1.InterestRate)=NULL THEN 0 ELSE speccs.SP_getIntAmount(#t1.LoanType,@month,#t1.LoanAccNo,#t1.InterestRate) END ,
	0,null,'R',@UserId,GETDATE()
	from #t1 , #t2 where #t1 .LoanAccNo=#t2.LoanAccNo
	
    --INT_RECOVERY - end
    
    	
      --RECURRENT DEPOSIT SUB  -START
      --15/07/2025 Changed SANCTION to ACTIVE
   --SELECT MemAccNo,DepositNo,Subscription,DepositType into #t4 FROM speccs.Deposits WHERE Status='ACTIVE' AND DepositType='RCD' 
    SELECT d.MemAccNo,d.DepositNo,d.Subscription,d.DepositType,m.MemEmpCode INTO #t4  FROM speccs.Deposits d,speccs.Members m WHERE d.Status='ACTIVE' AND d.DepositType='RCD' AND d.MemAccNo=m.MemAccNo
	
 --select LoanAccNo,CB=SUM(Amount),TXdate=MAX(TransactionDate),installCount=COUNT(*) into #t2 from speccs.LoanTransactions where P_I='P' group by LoanAccNo

	INSERT INTO speccs.MonthlyProcess
	select @month,#t4.MemAccNo,'D20',
	#t4.DepositNo,GETDATE(),#t4.MemEmpCode,
	224,amount=#t4.Subscription,0,null,'R',@UserId,GETDATE()
	from #t4 where #t4.DepositNo=#t4.DepositNo
	
    --RECURRENT DEPOSIT SUB  - end
    
       --THRIFT SUB  -START
   --DECLARE @accno VARCHAR(7)
   --SELECT @accno= MemAccNo  FROM speccs.Members WHERE  Status='ACTIVE'
   --changed by pn on 11/04/2025
   SELECT MemAccNo,ThriftSubscriptionAmount into #t5 FROM speccs.MemberAccount  WHERE MemAccNo IN (SELECT MemAccNo  FROM speccs.Members WHERE  Status='ACTIVE')
	----Changed Month to promonth Below
	INSERT INTO speccs.MonthlyProcess
	select @promonth,#t5.MemAccNo,purcode='M03',#t5.MemAccNo,GETDATE(),(select MemEmpCode from speccs.Members where MemAccNo=#t5.MemAccNo),
	Salcode=243,amount=#t5.ThriftSubscriptionAmount,0,null,'R',@UserId,GETDATE()
	from #t5 where #t5.MemAccNo=#t5.MemAccNo
	 
	  --THRIFT SUB  - end
    
    RETURN
	end

		IF (@option='GRIDDATA') 
  
	BEGIN
	
	-----LTL
	IF (@purcode='L24' OR @purcode='L29')
	BEGIN


	
	 SELECT A.Memcode,A.Purposecode,B.MemName,A.Refid,A.Empcode, CASE WHEN (C.LoanSanctionAmount) <=0 THEN 0 ELSE (C.LoanSanctionAmount) END AS Balance,CASE WHEN (C.LoanSanctionAmount) <=0 THEN 0 ELSE round(A.Recoveryamount,0)END AS Recoveryamount FROM  speccs.MonthlyProcess A,speccs.Members B,speccs.Loans C
   WHERE A.Memcode=B.MemAccNo AND A.Month=@month AND A.Purposecode=@purcode AND B.Status='ACTIVE' AND A.Memcode=C.MemAccNo AND A.Refid=C.LoanAccNo
	
	END
	-----
	------Thrift
	ELSE IF  (@purcode='M03')
	BEGIN
	
	SELECT A.Memcode,A.Purposecode,B.MemName,A.Refid,A.Empcode,(C.ThriftBalance+A.Recoveryamount) AS Balance,round(A.Recoveryamount,0) AS Recoveryamount FROM  speccs.MonthlyProcess A,speccs.Members B,speccs.MemberAccount C
   WHERE A.Memcode=B.MemAccNo AND A.Month=@month AND A.Purposecode=@purcode AND B.Status='ACTIVE' AND A.Memcode=C.MemAccNo
	
	
	
	END
	-------
	ELSE IF  (@purcode='M')
	BEGIN
	
  	SELECT MemAccNo AS Memcode,'D20' AS Purposecode,'' AS MemName,DepositNo AS Refid,DepositNo AS Empcode,Subscription AS Balance,0 AS Recoveryamount  FROM speccs.Deposits WHERE Status='ACTIVE' AND DepositType='RCD' 

	
	END
	ELSE
	BEGIN
                	
   SELECT A.Memcode,A.Purposecode,B.MemName,A.Refid,A.Empcode,0 AS Balance,round(A.Recoveryamount,0) AS Recoveryamount FROM  speccs.MonthlyProcess A,speccs.Members B
   WHERE A.Memcode=B.MemAccNo AND A.Month=@month AND A.Purposecode=@purcode AND B.Status='ACTIVE'
	 END	   
  RETURN
	END
	IF (@option='TEXTDATA') 
  
	BEGIN
             	
   SELECT A.Month,A.Purposecode,A.Memcode, A.Empcode,round(A.Recoveryamount,0) AS Recoveryamount,A.Salcode,A.Refid
    FROM  speccs.MonthlyProcess A WHERE A.Month=@month AND A.Purposecode=@purcode ORDER BY Empcode ASC
		   
  RETURN
	END
	
	IF (@option='EXCELDATA') 
  
	BEGIN
	SELECT Month,Memcode,Refid,Empcode,Salcode,round(Recoveryamount,0) AS Recoveryamount,Purposecode INTO #t3 FROM speccs.MonthlyProcess WHERE Purposecode=@purcode AND Month = convert(CHAR(10),dateadd(mm,-1,@month),101)
             	
   SELECT A.Empcode,C.MemName,C.Designation,A.Recoveryamount,round(B.Recoveryamount,0) AS prvAmount,(A.Recoveryamount-B.Recoveryamount) AS diffAmt
    FROM  speccs.MonthlyProcess A,#t3 B,speccs.Members C WHERE A.Memcode=B.Memcode AND A.Empcode=C.MemEmpCode AND A.Month=@month AND A.Purposecode=@purcode AND A.Purposecode=B.Purposecode ORDER BY A.Empcode ASC
		   
  RETURN
	END
--added by pn on 17/02/2025 to insert into monthly response table told by Kannan sir	
 	IF (@option='TXTDATAUPDATE') 
  
	BEGIN
           
		 DECLARE @memeaccno VARCHAR(7)
         DECLARE @refid VARCHAR(14)
         SELECT @memeaccno= MemAccNo  FROM speccs.Members WHERE MemEmpCode=@empcode  AND Status='ACTIVE'	
         SELECT @refid= Refid  FROM speccs.MonthlyProcess WHERE Empcode=@empcode  AND Month=@month AND Memcode=@memeaccno AND Purposecode=@purcode
        
		 IF EXISTS(SELECT * FROM speccs.MonthlyProcess WHERE Month= @month AND Purposecode=@purcode AND Memcode=@memeaccno)
		 
		 	DECLARE @DepositTypeCode VARCHAR(3)
		 	DECLARE @LoanP_I VARCHAR(2)
			BEGIN
				
				UPDATE speccs.MonthlyProcess SET Recoveredamount=@amount,RecoveredDate=getdate(),
				UserId=@UserId,RegTime=getdate() WHERE Purposecode=@purcode AND Empcode=@empcode AND Month=@month
			  
				IF(@purcode='D20' or @purcode='M03')
				BEGIN
		
					IF (@purcode = 'D20') SELECT @DepositTypeCode="RCD"
					IF (@purcode = 'M03') SELECT @DepositTypeCode="THR"
		
					DELETE FROM speccs.MonthlyResponse WHERE LoanAccNo=@refid AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='PENDING'
					DECLARE @responseDepAmt NUMERIC(15,2)
					IF(@purcode='M03')
					BEGIN
					SELECT @responseDepAmt=CASE WHEN EXISTS(SELECT ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@memeaccno) THEN ( SELECT ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@memeaccno) ELSE 0 END 
					END
					ELSE
					BEGIN 
   					SELECT @responseDepAmt=CASE WHEN Subscription=NULL THEN 0 ELSE Subscription END FROM speccs.Deposits WHERE DepositNo=@refid
   					END
					INSERT INTO speccs.MonthlyResponse (LoanAccNo,MemaccNo, TransactionDate, PayCode, Amount, P_I, Modeofpay,ClosingBal,Status, RegTime, UserId)
					VALUES (@refid,@memeaccno,convert(DATE,dateadd(mm,1,@month)) , @purcode, @amount, '', 'SALARY',@responseDepAmt+@amount,'PENDING', getdate(),@UserId)
					
				END
				ELSE
				BEGIN
					IF (@purcode = 'L24' or @purcode='L29'or @purcode='L34') SELECT @LoanP_I="P"
					IF (@purcode = 'L25' OR  @purcode='L30'or @purcode='L35') SELECT @LoanP_I="I"
				
		
					DELETE FROM speccs.MonthlyResponse WHERE LoanAccNo=@refid AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='PENDING'
					DECLARE @responseAmt NUMERIC(15,2)
				   
					
   					SELECT @responseAmt=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@refid
   					IF(@purcode = 'L25' OR  @purcode='L30'or @purcode='L35') BEGIN SELECT @responseAmt=@amount END
   					
					INSERT INTO speccs.MonthlyResponse (LoanAccNo,MemaccNo, TransactionDate, PayCode, Amount, P_I, Modeofpay,ClosingBal,Status, RegTime, UserId)
					VALUES (@refid,@memeaccno,convert(DATE,dateadd(mm,1,@month)) , @purcode, @amount, @LoanP_I, 'SALARY',(@responseAmt-@amount),'PENDING', getdate(),@UserId)
							
				END
		RETURN
		END
		  
  RETURN
	END
--added by pn on 17/02/2025 to approve monthly response told by Kannan sir
 IF (@option = 'APPROVEMONTHLYRESP') 
	BEGIN

   	DECLARE @memaccno VARCHAR(7)
    DECLARE @loanAccNo VARCHAR(14)
	SELECT @memaccno= @empcode	
	SELECT @loanAccNo= Refid  FROM speccs.MonthlyProcess WHERE Month=@month AND Memcode=@memaccno AND Purposecode=@purcode
  
 IF EXISTS(SELECT * FROM speccs.MonthlyProcess WHERE Month= @month AND Purposecode=@purcode AND Memcode=@memaccno)

		DECLARE @DepositCode VARCHAR(3)
		DECLARE @P_I VARCHAR(2)
		BEGIN
		EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
		
		UPDATE speccs.MonthlyProcess SET Recoveredamount=@amount,RecoveredDate=getdate(),
		UserId=@UserId,RegTime=getdate() WHERE Purposecode=@purcode AND Memcode=@memaccno AND Month=@month
		
		
		IF(@purcode='D20' or @purcode='M03')
		BEGIN

			IF (@purcode = 'D20') SELECT @DepositCode="RCD"
			IF (@purcode = 'M03') SELECT @DepositCode="THR"
			IF EXISTS(SELECT * FROM speccs.MonthlyResponse WHERE MemaccNo=@memaccno AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='PENDING')
	   		BEGIN
	   		   		 --Added on 05/12/2025 for avoiding Duplicate receipt Creation	-Start

		INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
		VALUES (@memaccno, @ReceiptNo, convert(DATE,dateadd(mm,1,@month)), @purcode, @amount, 'SALARY',@UserId,getdate(),'ACTIVE','',@loanAccNo)
   		 --Added on 05/12/2025 for avoiding Duplicate receipt Creation	-End

	   			
	   			UPDATE speccs.MonthlyResponse
	   			SET Status='APPROVE', RegTime=getdate(),UserId=@UserId
	   	   		WHERE MemaccNo=@memaccno AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='PENDING'
	   			--added by pn on 09/04/2025
	   			IF(@purcode = 'D20')
	   			BEGIN
	   			INSERT INTO speccs.DepositTransactions
	   			SELECT MemaccNo,PayCode,LoanAccNo,@month,TransactionDate,Modeofpay,Amount,0,0,@ReceiptNo,UserId,getdate() FROM speccs.MonthlyResponse
	   			WHERE MemaccNo=@memaccno AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='APPROVE'
	   			END 
	   			ELSE
	   			BEGIN
	   			--added by pn on 17/04/2025
	   			DECLARE @oldThrift Decimal(15,2)
	   			SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@memaccno
	   		 --	EXEC SP_Receipts 'SAVE', @memaccno, @month, @purcode, @amount, 'SALARY', '', @UserId, '', '','Monthly Response', @ReceiptNo OUTPUT
	   			
	   			INSERT INTO speccs.ThriftTransactions
	   			SELECT MemaccNo,convert(VARCHAR(8),datepart(MM,convert(DATE,@month))),TransactionDate,Modeofpay,Amount,@ReceiptNo,UserId,getdate(),(@oldThrift+Amount) FROM speccs.MonthlyResponse
	   			WHERE MemaccNo=@memaccno AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='APPROVE'
	   			DECLARE @thriftAmount DECIMAL(15,2)
	   			SELECT @thriftAmount=ClosingBal FROM speccs.MonthlyResponse mr WHERE LoanAccNo=@memaccno AND
	   			convert(DATE,mr.TransactionDate)=dateadd(mm,1,@month) AND mr.Status='APPROVE' 
	   			
	   			UPDATE speccs.MemberAccount
	   			SET RegTime=getdate(), ThriftBalance=@thriftAmount
	   			WHERE MemAccNo=@memaccno
	   			END
	   			
	   		END 

		END
		ELSE
		BEGIN

			IF (@purcode = 'L24' or @purcode='L29'or @purcode='L34') SELECT @P_I="P"
			IF (@purcode = 'L25'OR  @purcode='L30'or @purcode='L35') SELECT @P_I="I"

			IF EXISTS(SELECT * FROM speccs.MonthlyResponse WHERE LoanAccNo=@loanAccNo AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='PENDING')
   			BEGIN
   		 --Added on 05/12/2025 for avoiding Duplicate receipt Creation	-Start
		INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
		VALUES (@memaccno, @ReceiptNo, convert(DATE,dateadd(mm,1,@month)), @purcode, @amount, 'SALARY',@UserId,getdate(),'ACTIVE','',@loanAccNo)
--Added on 05/12/2025 for avoiding Duplicate receipt Creation	-End
   	   			UPDATE speccs.MonthlyResponse
   				SET Status='APPROVE', RegTime=getdate(),UserId=@UserId
   				WHERE LoanAccNo=@loanAccNo AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='PENDING'
   				-- added by pn on 08/04/2025 for updation in Loans after monthly response
   				IF(@purcode= 'L24' OR @purcode= 'L29')
   				BEGIN
   				UPDATE speccs.Loans
   				SET LoanSanctionAmount=m.ClosingBal,RegTime=getdate()
   				FROM speccs.Loans l,speccs.MonthlyResponse m
   				WHERE l.LoanAccNo=m.LoanAccNo AND m.TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND m.PayCode= @purcode AND m.Status='APPROVE'
   				END
   				
 	
		   		INSERT INTO speccs.LoanTransactions
		   		SELECT LoanAccNo,TransactionDate,PayCode,Amount,P_I,@ReceiptNo,Modeofpay,ClosingBal,getdate(),UserId FROM speccs.MonthlyResponse
		   		WHERE LoanAccNo=@loanAccNo AND TransactionDate = convert(DATE,dateadd(mm,1,@month)) AND PayCode= @purcode AND Status='APPROVE'
   		
   			END 


		END
	RETURN
	END

	RETURN
	END
	
	
IF (@option='RESPGRIDDATA') 
  
	BEGIN
             	
/* SELECT A.Memcode,A.Purposecode,B.MemName,A.Refid,A.Empcode,A.Salcode,A.Recoveryamount,A.Recoveredamount,C.Status  FROM  speccs.MonthlyProcess A,speccs.Members B,speccs.MonthlyResponse C
 WHERE A.Memcode=B.MemAccNo AND A.Refid=C.LoanAccNo AND A.Month=@month AND A.Purposecode=@purcode AND A.RecoveredDate!=NULL AND A.Recoveredamount!=0 
*/
 SELECT A.Memcode,A.Purposecode,B.MemName,A.Refid,A.Empcode,A.Salcode,A.Recoveryamount,C.Amount,C.Status  FROM  speccs.MonthlyProcess A,speccs.Members B,speccs.MonthlyResponse C
   WHERE A.Memcode=B.MemAccNo AND A.Refid=C.LoanAccNo AND A.Month=@month AND A.Purposecode=C.PayCode AND A.Purposecode=@purcode 
   AND C.TransactionDate IN (SELECT max(TransactionDate) FROM speccs.MonthlyResponse WHERE PayCode=@purcode)
                 
		   
  RETURN
	END
	
	
	
	IF (@option='PURPOSECODE') 
  
	BEGIN
  
  SELECT PayCode,SalaryCode,Description FROM speccs.TransactionType WHERE PayCode IN ('L24','L25','L29','L30','L34','L35','M03','D20','L45','L46','M43')
  
    /* SELECT 'PY1-LTL-LOAN AMOUNT RECOVERY' AS PURPOSE
     UNION 
     SELECT 'PY2-LTL-LOAN INTEREST RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY3-FDL-FD LOAN AMOUNT RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY4-FDL-FD LOAN INTEREST RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY5-EXL-EXPRESS LOAN AMOUNT RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY6-EXL-EXPRESS LOAN INTEREST RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY7-THR-THRIFT AMOUNT RECOVERY' AS PURPOSE
     UNION
	 SELECT 'PY8-RCD-RECURRENTDEPOSIT AMOUNT RECOVERY' AS PURPOSE	 	
		   
  */
  RETURN
	END



   	IF (@option='Salarycode') 
  
	BEGIN
  
  SELECT SalaryCode FROM speccs.TransactionType WHERE PayCode=@purcode
  
 RETURN
	END















GO

