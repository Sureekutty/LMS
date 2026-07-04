
-- *** SqlDbx Personal Edition ***
-- !!! Not licensed for commercial use beyound 90 days evaluation period !!!
-- For version limitations please check http://www.sqldbx.com/personal_edition.htm
-- Number of queries executed: 65, number of rows retrieved: 2223


-- *** SqlDbx Personal Edition ***
-- !!! Not licensed for commercial use beyound 90 days evaluation period !!!
-- For version limitations please check http://www.sqldbx.com/personal_edition.htm
-- Number of queries executed: 39, number of rows retrieved: 20

IF OBJECT_ID ('speccs.SP_getIntAmount') IS NOT NULL
	DROP FUNCTION speccs.SP_getIntAmount
GO

create function speccs.SP_getIntAmount (@Option VARCHAR (20),@month  VARCHAR(10),@loanAccNo VARCHAR(10),@intRate FLOAT)
returns FLOAT 
as

begin 
declare @intAmount NUMERIC(15,2)
SELECT @intAmount=0
   	DECLARE @prvStartDate DATE
   	SELECT @prvStartDate=dateadd(dd,-1,@month)
   	DECLARE  @p1 NUMERIC(15,2),@nextTranDate DATE
   DECLARE @nextMonth DATE,@startDate DATE, @endDate DATE,@maxTranDate DATE,@totalTransactions INT 
   SELECT @nextMonth=dateadd(dd,14,@month),@endDate=dateadd(dd,-1,dateadd(mm,1,@month))
   	DECLARE @prvMonthTrandate DATE
   	DECLARE @cbl NUMERIC(15,2)
   	DECLARE @prvEndDate DATE
	DECLARE @payCode VARCHAR(5)
 	IF(@Option='LTL')
   	BEGIN 
		SELECT @startDate= min(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo			
		SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo						

-- calculation for when there is no payment on very 1st day of month
		IF(@startDate!=@month)
		BEGIN

			SELECT @prvMonthTrandate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN dateadd(mm,-1,@prvStartDate) AND @prvStartDate AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo
					
			SELECT @cbl=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@prvMonthTrandate AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo 
			SELECT @intAmount=((CASE WHEN @cbl=NULL THEN 0 ELSE @cbl END) *@intRate*(datediff(dd,@month,@startDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) 
		END 
-- calculation from 1 to 30 of every month start	
		IF(@startDate=@maxTranDate)		--when only one transaction 
		BEGIN
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L23','L24','L26')
			SELECT @intAmount=@intAmount+@p1
		END 
		
-- here loop start for if more than one transactions there		
		WHILE  (@startDate<@maxTranDate)
		BEGIN
			SELECT TOP 1 @nextTranDate=TransactionDate FROM speccs.LoanTransactions WHERE TransactionDate>@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC 
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@nextTranDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L23','L24','L26')
			SELECT @intAmount=@intAmount+@p1
			SELECT @startDate=@nextTranDate
--if start and max transaction date same because loop checks for before max transactions
			IF(@startDate=@maxTranDate)
			BEGIN
				 SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L23','L24','L26')
				 SELECT @intAmount=@intAmount+@p1
			END
		END-- loop end
-- any payments/loans during 16-30 or 31 of previous month start
 		SELECT @prvStartDate=dateadd(mm,-1,dateadd(dd,15,@month)),@prvEndDate=dateadd(dd,-1,@month)
		SELECT @startDate= min(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L23','L26') AND LoanAccNo=@loanAccNo 
		SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L23','L26') AND LoanAccNo=@loanAccNo 
--when only one transaction there in previous month from 16-30
		IF(@startDate=@maxTranDate)
		BEGIN

			SELECT TOP 1 @payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC
			IF(@payCode='L23')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount+@p1
 
			END
			 
			IF(@payCode='L26')
			BEGIN
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount-@p1

			END
		END
--loop start for previous month calculation if more transactions available
		WHILE (@startDate<@maxTranDate)  
		BEGIN 
			SELECT TOP 1 @payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC
--checking based on pay code because monthly recovery has done on 15 only
			IF(@payCode='L23')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo				
				SELECT @intAmount=@intAmount+@p1

			END 
			IF(@payCode='L26')
			BEGIN
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount-@p1
 
			END
						
		 	SELECT TOP 1 @nextTranDate=TransactionDate,@payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate>@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate asc
			SELECT @startDate=@nextTranDate
 --if start and max transaction date same because here also loop checks for previous month max transactions
			IF(@startDate=@maxTranDate)
			BEGIN
				SELECT TOP 1 @payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC
				IF(@payCode='L23')
				BEGIN 
					SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo		
					SELECT @intAmount=@intAmount+@p1

		   		END
		   		 
		 		IF(@payCode='L26')
		   		BEGIN
			 		SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
			   		SELECT @intAmount=@intAmount-@p1

	 	   		END
			END
		END	 --loop end		   
		
			  
	   
	END -- ltl end
-- interest calculation for express loans according to account number start
	IF(@Option='EXL')
	BEGIN
		SELECT @startDate= min(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L28','L29','L31') AND LoanAccNo=@loanAccNo
		SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L28','L29','L31') AND LoanAccNo=@loanAccNo
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
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L28','L29','L31')
			SELECT @intAmount=@intAmount+@p1
		END 
-- here loop start for if more than one transactions there		
		WHILE  (@startDate<@maxTranDate)
		BEGIN
			SELECT TOP 1 @nextTranDate=TransactionDate FROM speccs.LoanTransactions WHERE TransactionDate>@startDate AND LoanAccNo=@loanAccNo
   			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@nextTranDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L28','L29','L31')
			SELECT @intAmount=@intAmount+@p1
			SELECT @startDate=@nextTranDate
--if start and max transaction date same because loop checks for before max transactions
			IF(@startDate=@maxTranDate)
			BEGIN			
				SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L28','L29','L31')
				SELECT @intAmount=@intAmount+@p1
			END		 
		END--end
-- any payments/loans during 16-30 of previous month start
		SELECT @prvStartDate=dateadd(mm,-1,dateadd(dd,15,@month)),@prvEndDate=dateadd(dd,-1,@month)
		SELECT @startDate= min(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L28','L31') AND LoanAccNo=@loanAccNo 
		SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L28','L31') AND LoanAccNo=@loanAccNo 
--when only one transaction there in previous month from 16-30
		IF(@startDate=@maxTranDate)
		BEGIN
			SELECT TOP 1 @payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC
			IF(@payCode='L28')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount+@p1
			END
			 
		 	IF(@payCode='L31')
		 	BEGIN
			 	SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount-@p1		   
	 		END
		END
--loop start for previous month calculation if more transactions available
		WHILE (@startDate<@maxTranDate)  
		BEGIN 	
			SELECT TOP 1 @payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate asc   
--checking based on pay code for L28 & L31 because monthly recovery has done on 15 only
			IF(@payCode='L28')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo	
				SELECT @intAmount=@intAmount+@p1
			END 
			
	 		IF(@payCode='L31')
	 		BEGIN
	 			SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount-@p1
	 		END
	 		
	 		SELECT TOP 1 @nextTranDate=TransactionDate,@payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate>@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate asc
			SELECT @startDate=@nextTranDate
		 --if start and max transaction date same because here also loop checks for previous month max transactions
			IF(@startDate=@maxTranDate)
			BEGIN
				SELECT TOP 1 @payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC
				IF(@payCode='L28')
				BEGIN 
					SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo			
					SELECT @intAmount=@intAmount+@p1
			 	END 
		 		IF(@payCode='L31')
		 		BEGIN
			 		SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
					SELECT @intAmount=@intAmount-@p1
				END
			END
		END	
		END   --exl end
		
		------------------------------------------------------------------
		--Newly Added on 04/12/2025-Start
		----------------------------------------------------------
		IF NOT EXISTS (SELECT ReceiptNo   FROM speccs.LoanTransactions WHERE LoanAccNo=@loanAccNo AND TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L23','L24','L26'))
		BEGIN 
		DECLARE @prvSDate1 DATE,@prvEDate1 DATE, @Balance NUMERIC(15,2),@Transactiondate DATE
				SELECT @prvSDate1=dateadd(mm,-1,dateadd(dd,15,@month)),@prvEDate1=dateadd(dd,-1,@month)
 IF EXISTS (SELECT ClosingBal FROM speccs.LoanTransactions WHERE (convert(DATE,TransactionDate) BETWEEN @prvSDate1 AND @prvEDate1 )  AND PayCode IN('L23') AND LoanAccNo=@loanAccNo)
	BEGIN
	SELECT TOP 1 @Balance=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate) BETWEEN @prvSDate1 AND @prvEDate1   AND PayCode IN('L23') AND LoanAccNo=@loanAccNo ORDER BY ClosingBal desc
		SELECT @Transactiondate=TransactionDate FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate) BETWEEN @prvSDate1 AND @prvEDate1   AND PayCode IN('L23') AND LoanAccNo=@loanAccNo

	SELECT @intAmount=(@Balance*@intRate*(datediff(dd,@Transactiondate,dateadd(mm,+1,@month))))/(36500) 

	
	END	
		END 
		--SELECT @intAmount AS amnts
		------------------------------------------------------------------
	  	--Newly Added on 04/12/2025-End 
		--- 	
	
	return @intAmount
END
GO

