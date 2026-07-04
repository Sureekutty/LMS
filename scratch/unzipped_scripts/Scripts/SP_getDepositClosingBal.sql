IF OBJECT_ID ('speccs.SP_getDepositClosingBal') IS NOT NULL
	DROP PROCEDURE speccs.SP_getDepositClosingBal
GO

CREATE PROCEDURE speccs.SP_getDepositClosingBal

   	@Deposittype VARCHAR (20),
	@CloseDate  VARCHAR(10),
	@DepositNo VARCHAR(10),
	@closingAmount NUMERIC(10,2) OUTPUT 

/*
drop proc speccs.SP_getDepositClosingBal
GRANT ALL ON speccs.SP_getDepositClosingBal to speccsgroup
*/
    
   	AS
	SELECT @closingAmount=0
   	
		--added  by pn on 05/05/2025 told by Rama Rao    
		DECLARE @intRate FLOAT, @months INT , @openDate DATE, @penalityRate FLOAT
		SELECT @openDate=OpenDate,@penalityRate=PenalIntRate FROM speccs.Deposits WHERE DepositNo=@DepositNo
		SELECT @months=Datediff(dd,@openDate,@CloseDate)
		--FXD start
		IF(@Deposittype='FXD')
		BEGIN
		  IF(@months<=10) BEGIN SELECT @months=0 END		
	   	IF(@months>=11 AND @months<60) BEGIN SELECT @months=1 END
		IF(@months>=60 AND @months<=182) BEGIN SELECT @months=5 END
		IF(@months>182 AND @months<=365) BEGIN SELECT @months=11 END
		IF(@months>=366 AND @months<=548) BEGIN SELECT @months=17 END
		IF(@months>548 AND @months<=730) BEGIN SELECT @months=23 END
		IF(@months>730 AND @months<=912) BEGIN SELECT @months=29 END
		IF(@months>912 AND @months<=1095) BEGIN SELECT @months=35 END
		IF(@months>1095 AND @months<=1825) BEGIN SELECT @months=40 END
		
		
		select @intRate=RateOfInterest+@penalityRate from speccs.Interest where IntCode='FXD' and @openDate between EffFromDate and EffToDate AND @months BETWEEN MinMonth AND MaxMonth
		IF (@months=0)
		BEGIN 
		SELECT  @intRate=0 
		END
		select @closingAmount=Subscription+CONVERT(numeric(10,2),(Subscription*@intRate*DATEDIFF(dd,OpenDate,@CloseDate)/36500))
		from speccs.Deposits where DepositNo=@DepositNo
		
		END	--fxd end
		--RCD start
		IF(@Deposittype='RCD')
		BEGIN
		DECLARE @duration INT 
		SELECT @months=Datediff(mm,@openDate,@CloseDate)
		--24/07/2025 ADDED BY Rama Sir 
		IF(@openDate<'11/11/2024')
		BEGIN
		IF(@months<2) BEGIN SELECT @intRate=0 END
		IF(@months>=2 AND @months<7) BEGIN SELECT @intRate=5 END
		IF(@months>=7 AND @months<12) BEGIN SELECT @intRate=5.5 END
		IF(@months>=12 AND @months<24) BEGIN SELECT @intRate=6 END
		IF(@months>=24 AND @months<60) BEGIN SELECT @intRate=6.6 END
		SELECT @months=@months+1
		SELECT @duration=(@months*(@months-1))/2
		
		select @closingAmount=(@months*Subscription)+CONVERT(numeric(10,2),(Subscription*@intRate*@duration/1200)) from speccs.Deposits where DepositNo=@DepositNo
		
		END
		ELSE
		BEGIN
		
		IF(@months<2) BEGIN SELECT @intRate=0 END
		IF(@months>=2 AND @months<7) BEGIN SELECT @intRate=6 END
		IF(@months>=7 AND @months<12) BEGIN SELECT @intRate=6.5 END
		IF(@months>=12 AND @months<24) BEGIN SELECT @intRate=7 END
		IF(@months>=24 AND @months<60) BEGIN SELECT @intRate=7.5 END
		SELECT @months=@months+1
		SELECT @duration=(@months*(@months-1))/2
		
		select @closingAmount=(@months*Subscription)+CONVERT(numeric(10,2),(Subscription*@intRate*@duration/1200)) from speccs.Deposits where DepositNo=@DepositNo
		END 
		
		END
		
		
		--rcd end
		--MIS start
		IF(@Deposittype='MIS')
		BEGIN
				SELECT @openDate=OpenDate,@penalityRate=PenalIntRate FROM speccs.Deposits WHERE DepositNo=@DepositNo

		  		SELECT @months=Datediff(dd,@openDate,@CloseDate)
		
		DECLARE @paidIntAmt NUMERIC(15,2)
		DECLARE @OpenDate1 DATE
		SELECT @OpenDate1=OpenDate FROM speccs.Deposits WHERE DepositNo=@DepositNo
	  SELECT @paidIntAmt=sum(PaidInterest) FROM speccs.MisPayments WHERE MisNo=@DepositNo AND Month BETWEEN @OpenDate1 AND @CloseDate
		
		
		IF (@OpenDate1 >= '09/11/2023')
		BEGIN
		
	
	 IF(@months<10) BEGIN SELECT @intRate=0 END
		IF(@months>=10 AND @months<=60) BEGIN SELECT @intRate=5.5 END
		IF(@months>=61 AND @months<=180) BEGIN SELECT @intRate=6.5 END
		IF(@months>180 AND @months<=365) BEGIN SELECT @intRate=6.75 END
		IF(@months>365 AND @months<=730) BEGIN SELECT @intRate=7.0 END
		IF(@months>730 ) BEGIN SELECT @intRate=7.25 END
		END 
		
		ELSE 
		BEGIN 
	  
		IF(@months<30) BEGIN SELECT @intRate=0 END
		IF(@months>=30 AND @months<=180) BEGIN SELECT @intRate=6.0 END
		IF(@months>180 AND @months<=365) BEGIN SELECT @intRate=6.5 END
		IF(@months>365 AND @months<=730) BEGIN SELECT @intRate=7 END
		IF(@months>730) BEGIN SELECT @intRate=0 END
		
		END 
		
		
		
	

		DECLARE @InterestRate2 FLOAT,@Months INT
		SELECT @Months=DATEDIFF(dd,OpenDate,@CloseDate)/31 from speccs.Deposits where DepositNo=@DepositNo
		SELECT @InterestRate2= IntRate FROM speccs.Deposits WHERE DepositNo=@DepositNo
		
		--SELECT @paidIntAmt=CASE WHEN @paidIntAmt=NULL THEN 0 ELSE @paidIntAmt END

		
	   --		select @closingAmount=Subscription+CONVERT(numeric(10,2),(Subscription*@intRate*DATEDIFF(dd,OpenDate,@CloseDate)/36500))-(CASE WHEN @paidIntAmt=NULL THEN 0 ELSE @paidIntAmt END)
	  --	from speccs.Deposits where DepositNo=@DepositNo
	  
	  
	  DECLARE  @Amountopen FLOAT
	  IF (datepart(dd,@OpenDate1)=1)
	  BEGIN 
	 SELECT  @Amountopen=0
	 END
	 ELSE
	 BEGIN
	 DECLARE @MonthDay INT 
	

	SELECT @MonthDay=DATEDIFF(dd, @OpenDate1, DATEADD(mm, 1, @OpenDate1)) 


	 		SELECT @Amountopen=(@MonthDay-(SELECT  datepart(dd,@OpenDate1))+1)* Subscription*@InterestRate2/36500 from speccs.Deposits where DepositNo=@DepositNo
		
	 		END
	 		
	  
 
	   	select @closingAmount=Subscription+CONVERT(numeric(10,2),(Subscription*@intRate*DATEDIFF(dd,OpenDate,@CloseDate)/36500))-(CONVERT(numeric(10,2),(Subscription*@InterestRate2*@Months/(12*100))))-@Amountopen
	   	from speccs.Deposits where DepositNo=@DepositNo
		
		
		
			
		
		
		END	--mis end
		





GO

