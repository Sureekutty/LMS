
IF OBJECT_ID ('speccs.SP_getFDLInterestAmount10122025') IS NOT NULL
	DROP PROCEDURE speccs.SP_getFDLInterestAmount10122025
GO

CREATE PROCEDURE speccs.SP_getFDLInterestAmount10122025

   	@Option VARCHAR (20),
	@month  VARCHAR(10),
	@loanAccNo VARCHAR(10),
	@intRate FLOAT ,
	@intAmount NUMERIC(15,2) OUTPUT 

/*
drop proc speccs.SP_getFDLInterestAmount
GRANT ALL ON speccs.SP_getFDLInterestAmount to speccsgroup
*/
    
   	AS
	SELECT @intAmount=0
   	
   	IF(@Option='FDL')
   	BEGIN
--Calculation for principle of fdl start
   		SELECT LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,ClosingBal INTO #tempdata FROM speccs.LoanTransactions WHERE LoanAccNo=@loanAccNo AND PayCode='L34'
	   	DECLARE @maxTranDate DATE,@startDate DATE,@dayDiff INT,@closingBal NUMERIC(15,2),@nextTranDate DATE,@intAmnt2 NUMERIC(15,2)
	   	SELECT @startDate=min(TransactionDate) FROM #tempdata
	   	SELECT @maxTranDate=max(TransactionDate) FROM #tempdata
	   	SELECT @dayDiff=(datediff(dd,@startDate,@month))
 
	   	WHILE(@startDate!=@maxTranDate)
	   	BEGIN
	   			
	   			SELECT @nextTranDate=min(TransactionDate) FROM #tempdata WHERE LoanAccNo=@loanAccNo AND TransactionDate>@startDate
	   	   	   
	   	   		SELECT @dayDiff=(datediff(dd,@startDate,@month))/365
	   	   		 
	   			WHILE (@dayDiff>=1)
	   			BEGIN 
	   				SELECT @intAmount=@intAmount+(@intAmount*@intRate)/100+(Amount*@intRate)/100 FROM #tempdata WHERE LoanAccNo=@loanAccNo AND TransactionDate= @startDate AND PayCode='L34'
	   				SELECT @dayDiff=@dayDiff-1
	   			END 
	   		 
	   		   SELECT @dayDiff=(datediff(dd,@startDate,@month))%365
		   	     IF( @dayDiff>0)
		   	     BEGIN
			   	    IF(((datediff(dd,@startDate,@month))/365)=0)
			   	    BEGIN
			   	     	SELECT @intAmount=(Amount*@intRate*@dayDiff)/36500 FROM #tempdata WHERE LoanAccNo=@loanAccNo AND TransactionDate= @startDate AND PayCode='L34'
			   	    END
			   	    ELSE 
			   	    BEGIN  	
			   	     	SELECT  @intAmount=@intAmount+(@intAmount*@intRate*@dayDiff)/36500
			   	     END 
		   	     END 
	   			SELECT @intAmnt2=@intAmount

	   			SELECT @startDate=@nextTranDate
	   	END
	   	
	   	IF(@startDate=@maxTranDate)
	   	BEGIN 
	   		SELECT @intAmount=0
	   		SELECT @dayDiff=(datediff(dd,@startDate,@month))/365
	   		
	   			WHILE (@dayDiff>=1)
	   			BEGIN 
	   				SELECT @intAmount=@intAmount+(@intAmount*@intRate)/100+(Amount*@intRate)/100 FROM #tempdata WHERE LoanAccNo=@loanAccNo AND TransactionDate= @startDate AND PayCode IN ('L34','L35')
	   				SELECT @dayDiff=@dayDiff-1
	   			   
	   				
	   			END 
	   		   SELECT @dayDiff=(datediff(dd,@startDate,@month))%365
		   	     IF( @dayDiff>0)
		   	     BEGIN
		   	       IF(((datediff(dd,@startDate,@month))/365)=0)
			   	    BEGIN
			   	     	SELECT @intAmount=(Amount*@intRate*@dayDiff)/36500 FROM #tempdata WHERE LoanAccNo=@loanAccNo AND TransactionDate= @startDate AND PayCode='L34'
			   	    END
			   	    ELSE 
			   	    BEGIN  	
			   	     	SELECT  @intAmount=@intAmount+(@intAmount*@intRate*@dayDiff)/36500
			   	     END
		   	     END 
	   			
	   	END -- principle end
	   	SELECT @intAmount=@intAmount+(CASE WHEN @intAmnt2=NULL THEN 0 ELSE @intAmnt2 END)
	   	--Calculation for disbursment of fdl start
 		DECLARE @intAmount1 NUMERIC(15,2)
 		SELECT @intAmount1=0
 		   SELECT @startDate=TransactionDate FROM speccs.LoanTransactions WHERE LoanAccNo=@loanAccNo AND PayCode='L33'
 		   	
 			SELECT @dayDiff=(datediff(dd,@startDate,@month))/365

	   			WHILE (@dayDiff>=1)
	   			BEGIN 
	   					SELECT @intAmount1=@intAmount1+(@intAmount1*@intRate)/100+(Amount*@intRate)/100 FROM LoanTransactions WHERE LoanAccNo=@loanAccNo AND PayCode='L33'
	   				SELECT @dayDiff=@dayDiff-1
	   				
	   			END 
	   		 	
	   		   SELECT @dayDiff=(datediff(dd,@startDate,@month))%365
		   	     IF( @dayDiff>0)
		   	     BEGIN
		   	     IF(((datediff(dd,@startDate,@month))/365)=0)
			   	    BEGIN
			   	     	SELECT @intAmount1=(Amount*@intRate*@dayDiff)/36500 FROM speccs.LoanTransactions WHERE LoanAccNo=@loanAccNo AND TransactionDate= @startDate AND PayCode='L33'
			   	    END
			   	    ELSE 
			   	    BEGIN  	
			   	     	SELECT  @intAmount1=@intAmount1+(@intAmount1*@intRate*@dayDiff)/36500
			   	     END
		   	     END 
	   	--disbursement end
	   	SELECT @intAmount=@intAmount1-(CASE WHEN @intAmount=NULL THEN 0 ELSE @intAmount END)
   	END
GO

