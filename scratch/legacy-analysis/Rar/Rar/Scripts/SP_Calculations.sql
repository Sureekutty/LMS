IF OBJECT_ID ('speccs.SP_Calculations') IS NOT NULL
	DROP PROCEDURE speccs.SP_Calculations
GO

CREATE PROCEDURE speccs.SP_Calculations

   	@Option  		VARCHAR (20),
	@MemAccNo  		VARCHAR(10)= NULL,
	@TypeOfDeposit	VARCHAR(3)= NULL,
	@DepositDate	VARCHAR(10)= NULL,
	@Amount			DECIMAL(15,2)= NULL,
	@Duration	    INT = NULL,	
	@maturitydate   VARCHAR(10) output,
	@maturity		NUMERIC(15,2)  output


    
   	AS
	--DROP PROC speccs.SP_Calculations
	--GRANT Execute ON speccs.SP_Calculations TO speccsgroup 
	-- EXEC SP_Calculations '','','RCD','06/01/2025',10000,27,'02/04/2025',1439
	 	
   	BEGIN 
   	DECLARE @intrate NUMERIC(5,2)
   	DECLARE @mindur INT
	DECLARE @maxdur INT,@intrestType VARCHAR(10),@intrestTerm INT 
	
	DECLARE @penaltyrate NUMERIC(5,2)	
	DECLARE @day INT,@month INT ,@year INT
	EXEC  speccs.Sp_getInterestRates 'VAlues',@TypeOfDeposit,@Duration,@intrate output,@DepositDate

	IF (@TypeOfDeposit = 'FXD' )  -- Start of Fixed deposit maturity 
	BEGIN 
	
	--getting details of FD rates ST
	
	
	
	select @mindur=RuleValue from speccs.Rules where RuleCode='121'
	select @maxdur=RuleValue from speccs.Rules where RuleCode='122'
	select @penaltyrate=RateOfInterest from speccs.Interest where IntCode='FXP' and getdate() between EffFromDate and EffToDate
   
	SELECT @intrestType=InterestType, @intrestTerm=CAST(InterstCalcTerm AS INT) FROM speccs.Interest where IntCode=@TypeOfDeposit and @Duration between  MinMonth and MaxMonth and getdate() between EffFromDate and EffToDate
   
   -- divideFactor for every calculation term start
   DECLARE @divideFactor INT 
   IF(@intrestTerm=1)BEGIN select @divideFactor=12 END
   IF(@intrestTerm=2)BEGIN select @divideFactor=6 END
   IF(@intrestTerm=4)BEGIN select @divideFactor=3 END
   IF(@intrestTerm=6)BEGIN select @divideFactor=2 END
   IF(@intrestTerm=12)BEGIN select @divideFactor=1 END
    -- divideFactor for every calculation term end
    
	--maturity date start
	SELECT @day=datepart(dd,@DepositDate)
	IF (@day<=3)
	BEGIN
	SELECT @month=datepart(mm,(dateadd(mm,@Duration,@DepositDate)))
	select @year=datepart(yy,(dateadd(mm,@Duration,@DepositDate)))
	
	SELECT @maturitydate = convert(VARCHAR(2),@month)+'/'+convert(VARCHAR(2),@day)+'/'+convert(VARCHAR(4),@year)
	--SELECT @maturitydate=DATEADD(mm,@Duration,@DepositDate)
	END
	
	ELSE
	BEGIN
	SELECT @day=1
	SELECT @month=datepart(mm,(dateadd(mm,@Duration+1,@DepositDate)))
	select @year=datepart(yy,(dateadd(mm,@Duration+1,@DepositDate)))
	
	SELECT @maturitydate=convert(VARCHAR(2),@month)+'/'+convert(VARCHAR(2),@day)+'/'+convert(VARCHAR(4),@year)
	END
	--maturity date end
	
	--interest calculation start
	IF(@intrestType='SNG' OR @intrestType='Sim' )
	BEGIN 
	select @maturity=convert(NUMERIC(15,2), @Amount+(@Amount*@Duration*@intrate/(@divideFactor*100)))
	DECLARE @simMaturity NUMERIC(15,2)
	SELECT @simMaturity=@maturity
		-- maturity amount calculation for remaining days start
	DECLARE @simDiffDate DATE, @simDaysDiff INT
	SELECT @simDiffDate=dateadd(mm,@Duration,@DepositDate)
	SELECT @simDaysDiff = Datediff(dd,@simDiffDate,@maturitydate)
	
	DECLARE @simDaysMaturity NUMERIC(15,2)
	IF(@simDaysDiff>0)
	BEGIN 	
	SELECT @simDaysMaturity=convert(NUMERIC(15,2),(@Amount*@intrate*(@simDaysDiff))/CAST(36500 AS DECIMAL))
	END
	ELSE BEGIN SELECT @simDaysMaturity=0 END
	
	SELECT @maturity=@simDaysMaturity+@simMaturity
	-- maturity amount calculation for remaining days end
	
	END
	IF(@intrestType='Com')
	BEGIN 
	-- maturity amount calculation for years start 
	SELECT @maturity=convert(NUMERIC(15,2), @Amount*EXP(@Duration/@divideFactor*log(1+@intrate/100.0)))
    --select @maturity=convert(NUMERIC(15,2),(@Amount*POWER(1+(@intrate/100*@intrestTerm),@intrestTerm*(@Duration/@divideFactor))))	
	DECLARE @yearMaturity NUMERIC(15,2)
	SELECT @yearMaturity=@maturity
   
	
	-- maturity amount calculation for years end
	
	-- maturity amount calculation for months start
		DECLARE @remainMonth INT
		SELECT @remainMonth=@Duration%@divideFactor
		DECLARE @monthsMaturity NUMERIC(15,2)
		IF(@remainMonth>0)
		BEGIN		
			SELECT @monthsMaturity=convert(NUMERIC(15,2),(@yearMaturity*@remainMonth*@intrate)/(12*100))
			
		END
		ELSE BEGIN SELECT @monthsMaturity=0  END
		
	-- maturity amount calculation for months end
	
	-- maturity amount calculation for remaining days start
	DECLARE @diffDate DATE, @daysDiff INT
	SELECT @diffDate=dateadd(mm,@Duration,@DepositDate)
	SELECT @daysDiff = Datediff(dd,@diffDate,@maturitydate)
	
	DECLARE @daysMaturity NUMERIC(15,2)
	IF(@daysDiff>0)
	BEGIN 	
	SELECT @daysMaturity=convert(NUMERIC(15,2),(@yearMaturity*@intrate*(@daysDiff))/CAST(36500 AS DECIMAL))
	END
	ELSE BEGIN SELECT @daysMaturity=0 END
	-- maturity amount calculation for remaining days end
	SELECT @maturity=ROUND((@yearMaturity+@monthsMaturity+@daysMaturity),0)
	END
	
	--interest calculation end
  
	--SELECT @maturitydate AS maturityDate,@maturity AS maturityAmount
	
	--validations ST
	if(@Duration <@mindur) or (@Duration>@maxdur)
	begin
		RAISERROR 99999 "Invalid Duration value for FD :SP_Deposits" 
		ROLLBACK TRANSACTION
		--SELECT 1 AS cnt ,"Error while updating in Appln :SP_Loans " AS MSG
		RETURN
	end
	--validations ND

END
-- end of Fixed deposit maturity

IF(@TypeOfDeposit = 'RCD')
BEGIN


	
	select @mindur=RuleValue from speccs.Rules where RuleCode='121'
	select @maxdur=RuleValue from speccs.Rules where RuleCode='122'
	select @penaltyrate=RateOfInterest from speccs.Interest where IntCode='RCD' and getdate() between EffFromDate and EffToDate
   
	SELECT @intrestType=InterestType, @intrestTerm=CAST(InterstCalcTerm AS INT) FROM speccs.Interest where IntCode=@TypeOfDeposit and @Duration between  MinMonth and MaxMonth and getdate() between EffFromDate and EffToDate
    
	--maturity date start
	SELECT @day=datepart(dd,@DepositDate)
	IF (@day<=4)
	BEGIN
	SELECT @month=datepart(mm,(dateadd(mm,@Duration,@DepositDate)))
	select @year=datepart(yy,(dateadd(mm,@Duration,@DepositDate)))
	
	SELECT @maturitydate = convert(VARCHAR(2),@month)+'/'+convert(VARCHAR(2),@day)+'/'+convert(VARCHAR(4),@year)
	--SELECT @maturitydate=DATEADD(mm,@Duration,@DepositDate)
	END
	
	ELSE
	BEGIN
	SELECT @day=1
	SELECT @month=datepart(mm,(dateadd(mm,@Duration+1,@DepositDate)))
	select @year=datepart(yy,(dateadd(mm,@Duration+1,@DepositDate)))
	
	SELECT @maturitydate=convert(VARCHAR(2),@month)+'/'+convert(VARCHAR(2),@day)+'/'+convert(VARCHAR(4),@year)
	END
	--maturity date end
	DECLARE @m1 NUMERIC(15,2),@m2 NUMERIC(15,2),@m3 NUMERIC(15,2),@m4 NUMERIC(15,2),@m5 NUMERIC(15,2)
	IF(@Duration<=12)
	BEGIN 
	select @m1=convert(NUMERIC(15,2),(@Amount*@intrate*(@Duration*(@Duration+1)))/2400)
	SELECT @maturity = @m1+@Duration*@Amount
	
	END 
		IF(@Duration>=13 AND @Duration<=24)
		BEGIN
		SELECT @m1=convert(NUMERIC(15,2),(@Amount*@intrate*(12*(13)))/2400)
		 SELECT @m2 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-12)*(@Duration-12+1))/2400)+((@m1+12*@Amount)*@intrate*(@Duration-12))/1200)
		 SELECT @maturity = @m1+@m2+@Duration*@Amount
		
		END
		IF(@Duration>=25 AND @Duration<=36)
		BEGIN
		SELECT @m1=convert(NUMERIC(15,2),(@Amount*@intrate*(12*(13)))/2400)
		 SELECT @m2 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-24)*(@Duration-24+1))/2400)+((@m1+12*@Amount)*@intrate)/100)
		 SELECT @m3 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-24)*(@Duration-24+1))/2400)+((@m1+@m2+24*@Amount)*@intrate*(@Duration-24))/1200)
		 SELECT @maturity = @m1+@m2+@m3+@Duration*@Amount 
	   
		END
		IF(@Duration>=37 AND @Duration<=48)
		BEGIN
		SELECT @m1=convert(NUMERIC(15,2),(@Amount*@intrate*(12*(13)))/2400)
		 SELECT @m2 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-36)*(@Duration-36+1))/2400)+((@m1+12*@Amount)*@intrate)/100)
		 SELECT @m3 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-36)*(@Duration-36+1))/2400)+((@m1+@m2+24*@Amount)*@intrate)/100)
		 SELECT @m4 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-36)*(@Duration-36+1))/2400)+((@m1+@m2+@m3+36*@Amount)*@intrate*(@Duration-36))/1200)
		 SELECT @maturity = @m1+@m2+@m3+@m4+@Duration*@Amount   
		
		END
		IF(@Duration>=49 AND @Duration<=60)
		BEGIN
		  SELECT @m1=convert(NUMERIC(15,2),(@Amount*@intrate*(12*(13)))/2400)
		 SELECT @m2 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-48)*(@Duration-48+1))/2400)+((@m1+12*@Amount)*@intrate)/100)
		 SELECT @m3 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-48)*(@Duration-48+1))/2400)+((@m1+@m2+24*@Amount)*@intrate)/100)
		 SELECT @m4 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-48)*(@Duration-48+1))/2400)+((@m1+@m2+@m3+36*@Amount)*@intrate)/100)
		 SELECT @m5 = convert(NUMERIC(15,2),((@Amount*@intrate)*((@Duration-48)*(@Duration-48+1))/2400)+((@m1+@m2+@m3+@m4+48*@Amount)*@intrate*(@Duration-48))/1200)
		
		SELECT @maturity = ROUND((@m1+@m2+@m3+@m4+@m5+@Duration*@Amount),0)
		
		END
	
	
	
		--SELECT @maturitydate AS maturityDate,@maturity AS maturityAmount
END

 END 


























GO

