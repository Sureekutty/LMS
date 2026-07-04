IF OBJECT_ID ('speccs.SP_MemberProcessView') IS NOT NULL
	DROP PROCEDURE speccs.SP_MemberProcessView
GO

CREATE PROCEDURE speccs.SP_MemberProcessView
@Option VARCHAR(25),
@MemAccNo CHAR(5) ,
@SetDate DATE 

AS  

--EXEC speccs.SP_MemberProcessView 'Liability','M0008'

--DROP PROC speccs.SP_MemberProcessView

--	GRANT ALL ON speccs.SP_MemberProcessView to speccsgroup

DECLARE @isDataPresent INT
SELECT @isDataPresent = 0



/*IF EXISTS( SELECT  * FROM speccs.Deposits dep WHERE  dep.MemAccNo=@MemAccNo AND dep.Status='ACTIVE')
   BEGIN
   SELECT @isDataPresent=1
   END
       
IF (@isDataPresent = 0)
   BEGIN
    RAISERROR 99999 "Invalid  deposit Number :SP_MemberProcessView"
 	RETURN
   END */
 
IF (@Option='Deposits')
   BEGIN
   
     SELECT  dep.MemAccNo, dep.DepositNo,dep.DepositType,convert(CHAR(10),dep.OpenDate,103) AS OpenDate  ,dep.SettlementAmount
     ,dep.Duration,dep.SettlementAmount
     FROM speccs.Deposits dep
     WHERE  dep.MemAccNo=@MemAccNo AND dep.Status='CLOSE_INIT'
  
  --added by pn on 14/02/2024   
     union
     SELECT  mem.MemAccNo,mem.MemAccNo,null,'Share capital',mem.ShareAmount,null,null
     FROM speccs.MemberAccount mem,speccs.Members m
     WHERE m.MemAccNo=mem.MemAccNo AND mem.MemAccNo=@MemAccNo AND m.Status='ACTIVE'
     
     union
     SELECT  mem.MemAccNo,mem.MemAccNo,null,'Thrift Deposit',mem.ThriftBalance,null,null
     FROM speccs.MemberAccount mem,speccs.Members m
     WHERE m.MemAccNo=mem.MemAccNo AND mem.MemAccNo=@MemAccNo AND m.Status='ACTIVE'
     
     union
     SELECT  mem.MemAccNo,mem.MemAccNo,null,'REMBS',CASE WHEN (Datediff(YY,m.MemDate ,@SetDate))>10 THEN  (CASE WHEN ((Datediff(YY,m.MemDate ,@SetDate)) * 450) <= 15000 THEN ((Datediff(YY,m.MemDate ,@SetDate)) * 450) ELSE 15000 END) ELSE 0 END ,null,null
     FROM speccs.MemberAccount mem,speccs.Members m
     WHERE m.MemAccNo=mem.MemAccNo AND mem.MemAccNo=@MemAccNo AND m.Status='ACTIVE'
     
   RETURN
   END



/* IF EXISTS( SELECT  * FROM speccs.Loans l WHERE  l.MemAccNo=@MemAccNo AND l.LoanStatus='SANCTION')
   BEGIN
   SELECT @isDataPresent=1
   END
       
IF (@isDataPresent = 0)
   BEGIN
    RAISERROR 99999 "Invalid  loan Number :SP_MemberProcessView"
 	RETURN
   END */

 IF (@Option='Liability')
   BEGIN
   
   DECLARE  @days INT,@lastDate INT 
SELECT @days=datepart(dd,@SetDate)-1
   
   SELECT @lastDate=datepart(dd,dateadd(dd,-datepart(dd,@SetDate),dateadd(mm,1,@SetDate)))
  --- SELECT @LoanSanctionAmount1=convert(NUMERIC(15,2),LoanSanctionAmount+((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200))) FROM speccs.Loans WHERE MemAccNo=@MemAccNo AND LoanStatus='RELEASED' 
   
    SELECT l.MemAccNo,l.LoanAccNo,l.LoanType,convert(CHAR(10),l.Loanappdate,103) AS OpenDate ,convert(NUMERIC(15,2),l.LoanSanctionAmount+(l.LoanSanctionAmount*l.InterestRate*@days/(@lastDate*1200))) AS LoanSanctionAmount
     FROM speccs.Loans l
     WHERE  l.MemAccNo=@MemAccNo AND l.LoanStatus='RELEASED'
   RETURN
   END


--added by pn on 22/02/2024
IF(@Option='Surity')
	BEGIN
	  SELECT MemAccNo INTO #TEMP1 FROM speccs.Loans 
	  WHERE Surety1=@MemAccNo OR  Surety2=@MemAccNo OR Surety3=@MemAccNo
	  SELECT M.MemAccNo,M.MemEmpCode,M.MemName FROM speccs.Members M,#TEMP1 T WHERE M.MemAccNo=T.MemAccNo
	  
	 RETURN
	 END

--END

GO

