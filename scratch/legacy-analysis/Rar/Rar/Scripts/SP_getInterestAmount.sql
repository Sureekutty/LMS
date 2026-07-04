IF OBJECT_ID ('speccs.SP_getInterestAmount') IS NOT NULL
	DROP PROCEDURE speccs.SP_getInterestAmount
GO

CREATE PROCEDURE speccs.SP_getInterestAmount

   	@Option VARCHAR (20),
	@month  VARCHAR(10),
	@loanAccNo VARCHAR(10),
	@intRate FLOAT ,
	@intAmount FLOAT OUTPUT 


    
   	AS
	--DROP PROC speccs.SP_getInterestAmount
	--GRANT Execute ON speccs.SP_getInterestAmount TO speccsgroup 
	-- EXEC SP_getInterestAmount ''','','',,@intAmount output
	
	/*
SELECT MemAccNo='',LoanAccNo='',LoanType='',LoanSanctionAmount=0,InterestRate=0.0 into #t1
	*/
	
	
	SELECT @intAmount=0
   	DECLARE @prvStartDate DATE
   	SELECT @prvStartDate=dateadd(dd,-1,@month)
   	DECLARE  @p1 NUMERIC(15,2),@nextTranDate DATE
   DECLARE @nextMonth DATE,@startDate DATE, @endDate DATE,@maxTranDate DATE,@totalTransactions INT 
   SELECT @nextMonth=dateadd(dd,14,@month),@endDate=dateadd(dd,-1,dateadd(mm,1,@month))
   SELECT @prvStartDate AS prvStartDate,@nextMonth AS nextMonth,@endDate AS endDate
   	DECLARE @prvMonthTrandate DATE
   	DECLARE @cbl NUMERIC(15,2)
   	DECLARE @prvEndDate DATE
	DECLARE @payCode VARCHAR(5)
 	IF(@Option='LTL')
   	BEGIN 
		SELECT TransactionDate,PayCode,Amount,P_I,ClosingBal INTO #tempData7
		FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo ORDER BY TransactionDate asc			
		SELECT @startDate= min(TransactionDate) FROM #tempData7
		SELECT @maxTranDate=max(TransactionDate) FROM #tempData7			
		SELECT @startDate AS startDate,@maxTranDate AS maxTranDate
-- calculation for when there is no payment on very 1st day of month
		IF(@startDate!=@month)
		BEGIN
		SELECT '1'
			SELECT @prvMonthTrandate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN dateadd(mm,-1,@prvStartDate) AND @prvStartDate AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo
					
			SELECT @cbl=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@prvMonthTrandate AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo 
			SELECT @intAmount=((CASE WHEN @cbl=NULL THEN 0 ELSE @cbl END) *@intRate*(datediff(dd,@month,@startDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) 
		END 
-- calculation from 1 to 30 of every month start	
		IF(@startDate=@maxTranDate)		--when only one transaction 
		BEGIN
		SELECT '2'
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM #tempData7 WHERE TransactionDate=@startDate
			SELECT @intAmount=@intAmount+@p1
			SELECT @intAmount AS amnts
		END 
-- here loop start for if more than one transactions there		
		WHILE  (@startDate<@maxTranDate)
		BEGIN
			SELECT 'Boom'
			SELECT TOP 1 @nextTranDate=TransactionDate FROM #tempData7 WHERE TransactionDate>@startDate ORDER BY TransactionDate asc
			SELECT ClosingBal FROM #tempData7 WHERE convert(DATE,TransactionDate)=@startDate
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@nextTranDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM #tempData7 WHERE convert(DATE,TransactionDate)=@startDate
			SELECT @intAmount=@intAmount+@p1
			SELECT @intAmount AS before
			SELECT @startDate=@nextTranDate
--if start and max transaction date same because loop checks for before max transactions
			IF(@startDate=@maxTranDate)
			BEGIN
			SELECT 'inside > 1'
			SELECT ClosingBal FROM #tempData7 WHERE TransactionDate=@startDate
				 SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM #tempData7 WHERE TransactionDate=@startDate
				 SELECT @intAmount=@intAmount+@p1
			END
		END--end
-- any payments/loans during 16-30 of previous month start
 		SELECT @prvStartDate=dateadd(mm,-1,dateadd(dd,15,@month)),@prvEndDate=dateadd(dd,-1,@month)
		SELECT TransactionDate,PayCode,Amount,P_I,ClosingBal  INTO #tempData8 FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L23','L26') AND LoanAccNo=@loanAccNo ORDER BY TransactionDate asc 
		SELECT @startDate= min(TransactionDate) FROM #tempData8
		SELECT @maxTranDate=max(TransactionDate) FROM #tempData8
		SELECT @startDate AS prvstartDate,@maxTranDate AS prvmaxTranDate
--when only one transaction there in previous month from 16-30
		IF(@startDate=@maxTranDate)
		BEGIN
		SELECT TOP 1 @payCode=PayCode FROM #tempData8 WHERE TransactionDate=@startDate ORDER BY TransactionDate ASC
		SELECT @payCode AS payCode
			IF(@payCode='L23')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData8 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
				SELECT @intAmount=@intAmount+@p1
				SELECT @intAmount AS amntst
			END
			 
			IF(@payCode='L26')
			BEGIN
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData8 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
				SELECT @intAmount=@intAmount-@p1
				SELECT @intAmount AS amntstp
			END
		END
--loop start for previous month calculation if more transactions available
		WHILE (@startDate<@maxTranDate)  
		BEGIN 
		SELECT 'Boom 2'
			SELECT TOP 1 @payCode=PayCode FROM #tempData8 WHERE TransactionDate=@startDate ORDER BY TransactionDate ASC
--checking based on pay code because monthly recovery has done on 15 only
			IF(@payCode='L23')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData8 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode				
				SELECT @intAmount=@intAmount+@p1
			END 
			IF(@payCode='L26')
			BEGIN
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData8 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
				SELECT @intAmount=@intAmount-@p1
			END
						
		 	SELECT TOP 1 @nextTranDate=TransactionDate,@payCode=PayCode FROM #tempData8 WHERE TransactionDate>@startDate ORDER BY TransactionDate asc
			SELECT @startDate=@nextTranDate
 --if start and max transaction date same because here also loop checks for previous month max transactions
			IF(@startDate=@maxTranDate)
			BEGIN
			SELECT 'prv 1'
				IF(@payCode='L23')
				BEGIN 
					SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData8 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode		
					SELECT @intAmount=@intAmount+@p1
		   		END
		   		 
		 		IF(@payCode='L26')
		   		BEGIN
			 		SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData8 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
			   		SELECT @intAmount=@intAmount-@p1
	 	   		END
			END
		END
		------------------------------------------------------------------
		--Newly Added on 03/12/2025-Start
		----------------------------------------------------------
		IF (@intAmount=0)
		BEGIN 
		DECLARE @prvSDate1 DATE,@prvEDate1 DATE, @Balance NUMERIC(15,2),@Transactiondate DATE
				SELECT @prvSDate1=dateadd(mm,-1,dateadd(dd,15,@month)),@prvEDate1=dateadd(dd,-1,@month)
 IF EXISTS (SELECT ClosingBal FROM speccs.LoanTransactions WHERE (convert(DATE,TransactionDate) BETWEEN @prvSDate1 AND @prvEDate1 )  AND PayCode IN('L23') AND LoanAccNo=@loanAccNo)
	BEGIN
	SELECT @Balance=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate) BETWEEN @prvSDate1 AND @prvEDate1   AND PayCode IN('L23') AND LoanAccNo=@loanAccNo
		SELECT @Transactiondate=TransactionDate FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate) BETWEEN @prvSDate1 AND @prvEDate1   AND PayCode IN('L23') AND LoanAccNo=@loanAccNo

	SELECT @intAmount=(@Balance*@intRate*(datediff(dd,@Transactiondate,dateadd(mm,+1,@month))))/(1200) 

	
	END	
		END 
		------------------------------------------------------------------
	  	--Newly Added on 03/12/2025-End 
		--------------------------------------------------------------------
		 			   
	END -- ltl end
-- interest calculation for express loans according to account number start
	   
	IF(@Option='EXL')
	BEGIN
		SELECT TransactionDate,PayCode,Amount,P_I,ClosingBal INTO #tempData9
		FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L28','L29','L31') AND LoanAccNo=@loanAccNo ORDER BY TransactionDate asc
		SELECT @startDate= min(TransactionDate) FROM #tempData9
		SELECT @maxTranDate=max(TransactionDate) FROM #tempData9		
-- calculation for when there is no payment on very 1st day of month
		IF(@startDate!=@month)
		BEGIN
			SELECT @prvMonthTrandate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN dateadd(mm,-1,@prvStartDate) AND @prvStartDate AND PayCode IN('L28','L29','L31') AND LoanAccNo=@loanAccNo			
			SELECT @cbl=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@prvMonthTrandate AND PayCode IN('L28','L29','L31') AND LoanAccNo=@loanAccNo 
			SELECT @intAmount=((CASE WHEN @cbl=NULL THEN 0 ELSE @cbl END) *@intRate*(datediff(dd,@month,@startDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) 
		END 
-- calculation from 1 to 30 of every month start	
		IF(@startDate=@maxTranDate)		--when only one transaction 
		BEGIN
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM #tempData9 WHERE TransactionDate=@startDate
			SELECT @intAmount=@intAmount+@p1
		END 
-- here loop start for if more than one transactions there		
		WHILE  (@startDate<@maxTranDate)
		BEGIN
			SELECT TOP 1 @nextTranDate=TransactionDate FROM #tempData9 WHERE TransactionDate>@startDate ORDER BY TransactionDate asc
   			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@nextTranDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM #tempData9 WHERE convert(DATE,TransactionDate)=@startDate
			SELECT @intAmount=@intAmount+@p1
			SELECT @startDate=@nextTranDate
--if start and max transaction date same because loop checks for before max transactions
			IF(@startDate=@maxTranDate)
			BEGIN			
				SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM #tempData9 WHERE TransactionDate=@startDate
				SELECT @intAmount=@intAmount+@p1
			END		 
		END--end
-- any payments/loans during 16-30 of previous month start
		SELECT @prvStartDate=dateadd(mm,-1,dateadd(dd,15,@month)),@prvEndDate=dateadd(dd,-1,@month)
		SELECT TransactionDate,PayCode,Amount,P_I,ClosingBal  INTO #tempData10 FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L28','L31') AND LoanAccNo=@loanAccNo ORDER BY TransactionDate asc 
		SELECT @startDate= min(TransactionDate) FROM #tempData10
		SELECT @maxTranDate=max(TransactionDate) FROM #tempData10
--when only one transaction there in previous month from 16-30
		IF(@startDate=@maxTranDate)
		BEGIN
			IF(@payCode='L28')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData10 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
				SELECT @intAmount=@intAmount+@p1
			END
			 
		 	IF(@payCode='L31')
		 	BEGIN
			 	SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData10 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
				SELECT @intAmount=@intAmount-@p1		   
	 		END
		END
--loop start for previous month calculation if more transactions available
		WHILE (@startDate<@maxTranDate)  
		BEGIN 	
			SELECT TOP 1 @payCode=PayCode FROM #tempData10 WHERE TransactionDate=@startDate ORDER BY TransactionDate asc   
--checking based on pay code for L28 & L31 because monthly recovery has done on 15 only
			IF(@payCode='L28')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData10 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode	
				SELECT @intAmount=@intAmount+@p1
			END 
			
	 		IF(@payCode='L31')
	 		BEGIN
				SELECT Amount AS amtL26 FROM #tempData10 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
	 			SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData10 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
				SELECT @intAmount=@intAmount-@p1
	 		END
	 		
	 		SELECT TOP 1 @nextTranDate=TransactionDate,@payCode=PayCode FROM #tempData10 WHERE TransactionDate>@startDate ORDER BY TransactionDate asc
			SELECT @startDate=@nextTranDate
		 --if start and max transaction date same because here also loop checks for previous month max transactions
			IF(@startDate=@maxTranDate)
			BEGIN
				IF(@payCode='L28')
				BEGIN 
					SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData10 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode			
					SELECT @intAmount=@intAmount+@p1
			 	END 
		 		IF(@payCode='L31')
		 		BEGIN
			 		SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM #tempData10 WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode
					SELECT @intAmount=@intAmount-@p1
				END
			END
		END	--exl end	
	 END
GO

