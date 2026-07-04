IF OBJECT_ID ('speccs.SP_getTempInterestAmount') IS NOT NULL
	DROP PROCEDURE speccs.SP_getTempInterestAmount
GO

CREATE PROCEDURE speccs.SP_getTempInterestAmount

   	@Option VARCHAR (20),
	@month  VARCHAR(10),
	@loanAccNo VARCHAR(10),
	@intRate FLOAT ,
	@intAmount FLOAT OUTPUT 


    
   	AS
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
		SELECT @startDate AS startDate
		SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @month AND @nextMonth AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo						
		SELECT @maxTranDate AS maxTranDate
-- calculation for when there is no payment on very 1st day of month
		IF(@startDate!=@month)
		BEGIN
			SELECT 'not equal'
			SELECT @prvMonthTrandate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN dateadd(mm,-1,@prvStartDate) AND @prvStartDate AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo
					
			SELECT @cbl=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@prvMonthTrandate AND PayCode IN('L23','L24','L26') AND LoanAccNo=@loanAccNo 
			SELECT @intAmount=((CASE WHEN @cbl=NULL THEN 0 ELSE @cbl END) *@intRate*(datediff(dd,@month,@startDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) 
		END 
-- calculation from 1 to 30 of every month start	
		IF(@startDate=@maxTranDate)		--when only one transaction 
		BEGIN
		SELECT '1'
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L23','L24','L26')
			SELECT @intAmount=@intAmount+@p1
			SELECT @intAmount AS intAmount1
		END 
-- here loop start for if more than one transactions there		
		WHILE  (@startDate<@maxTranDate)
		BEGIN
			SELECT "loop"
			SELECT TOP 1 @nextTranDate=TransactionDate FROM speccs.LoanTransactions WHERE TransactionDate>@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC 
			SELECT @nextTranDate AS nextDate
			SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@nextTranDate)))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L23','L24','L26')
			SELECT @intAmount=@intAmount+@p1
			SELECT @startDate=@nextTranDate
--if start and max transaction date same because loop checks for before max transactions
			IF(@startDate=@maxTranDate)
			BEGIN
			SELECT 'loop equal'
				 SELECT @p1=(ClosingBal*@intRate*(datediff(dd,@startDate,@endDate)+1))/(datepart(dd,dateadd(dd,-1,dateadd(mm,1,@month)))*1200) FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo AND PayCode IN('L23','L24','L26')
				 SELECT @intAmount=@intAmount+@p1
			END
		END-- loop end
-- any payments/loans during 16-30 or 31 of previous month start
 		SELECT @prvStartDate=dateadd(mm,-1,dateadd(dd,15,@month)),@prvEndDate=dateadd(dd,-1,@month)
		SELECT @startDate= min(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L23','L26') AND LoanAccNo=@loanAccNo 
		SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE TransactionDate BETWEEN @prvStartDate AND @prvEndDate AND PayCode IN('L23','L26') AND LoanAccNo=@loanAccNo 
		SELECT @startDate AS prvstartDate,@maxTranDate AS prvmaxTranDate
--when only one transaction there in previous month from 16-30
		IF(@startDate=@maxTranDate)
		BEGIN
			SELECT '2'
			SELECT TOP 1 @payCode=PayCode FROM speccs.LoanTransactions WHERE TransactionDate=@startDate AND LoanAccNo=@loanAccNo ORDER BY TransactionDate ASC
			IF(@payCode='L23')
			BEGIN 
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount+@p1
 				SELECT @intAmount AS intAmountL232
			END
			 
			IF(@payCode='L26')
			BEGIN
				SELECT @p1=(Amount*@intRate*(datediff(dd,@startDate,@prvEndDate)+1))/(datepart(dd,@prvEndDate)*1200) FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)=@startDate AND PayCode=@payCode AND LoanAccNo=@loanAccNo
				SELECT @intAmount=@intAmount-@p1
				SELECT @intAmount AS intAmountL262
			END
		END
--loop start for previous month calculation if more transactions available
		WHILE (@startDate<@maxTranDate)  
		BEGIN 
		SELECT 'prv loop'
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
	
GO

