IF OBJECT_ID ('speccs.SP_FetchSurety') IS NOT NULL
	DROP PROCEDURE speccs.SP_FetchSurety
GO

CREATE PROCEDURE speccs.SP_FetchSurety
@option   VARCHAR(15),
@MemAccNo CHAR(10)=NULL,
@suretyinput CHAR(10)=NULL

--drop proc speccs.SP_FetchSurety
--grant all on speccs.SP_FetchSurety to speccsgroup
AS    


IF (@option ='DELSUR')
BEGIN

IF EXISTS(SELECT * FROM speccs.Loans l WHERE l.LoanAccNo=@suretyinput AND l.Surety1=@MemAccNo)
BEGIN
UPDATE speccs.Loans SET Surety1=''  WHERE LoanAccNo=@suretyinput
END
ELSE IF EXISTS(SELECT * FROM speccs.Loans l WHERE l.LoanAccNo=@suretyinput AND l.Surety2=@MemAccNo)
BEGIN
UPDATE speccs.Loans SET Surety2=''  WHERE LoanAccNo=@suretyinput
END
ELSE IF EXISTS(SELECT * FROM speccs.Loans l WHERE l.LoanAccNo=@suretyinput AND l.Surety3=@MemAccNo)
BEGIN
UPDATE speccs.Loans SET Surety3=''  WHERE LoanAccNo=@suretyinput
RETURN
END 
END



IF (@option='SURETYLIST')
BEGIN

DECLARE  @Surety1 VARCHAR (7)
DECLARE  @Surety2 VARCHAR (7)
DECLARE  @Surety3 VARCHAR (7)


SELECT @Surety1=Surety1 FROM speccs.Loanstatus WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
SELECT @Surety2=Surety2 FROM speccs.Loanstatus WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
SELECT @Surety3=Surety3 FROM speccs.Loanstatus WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
/*
SELECT @Surety1=Surety1 FROM speccs.Loans WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
SELECT @Surety2=Surety2 FROM speccs.Loans WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
SELECT @Surety3=Surety3 FROM speccs.Loans WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
*/

SELECT mm.MemAccNo,mm.MemEmpCode,mm.MemName, ma.ThriftBalance FROM speccs.Members mm ,speccs.MemberAccount ma 
WHERE mm.MemAccNo=@Surety1 AND ma.MemAccNo=mm.MemAccNo
UNION
SELECT m.MemAccNo,m.MemEmpCode,m.MemName ,maaa.ThriftBalance FROM speccs.Members m ,speccs.MemberAccount maaa
 WHERE maaa.MemAccNo=@Surety2 AND maaa.MemAccNo=m.MemAccNo
UNION
SELECT mmm.MemAccNo,mmm.MemEmpCode,mmm.MemName ,maa.ThriftBalance FROM speccs.Members mmm ,speccs.MemberAccount maa 
WHERE mmm.MemAccNo=@Surety3 AND maa.MemAccNo=mmm.MemAccNo
RETURN

END


 


IF (@option='SURETYACTIVE')
BEGIN

DECLARE  @Surety4 VARCHAR (7)
DECLARE  @Surety5 VARCHAR (7)
DECLARE  @Surety6 VARCHAR (7)

SELECT @Surety4=Surety1 FROM speccs.Loans WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
SELECT @Surety5=Surety2 FROM speccs.Loans WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput
SELECT @Surety6=Surety3 FROM speccs.Loans WHERE MemAccNo=@MemAccNo AND LoanAccNo=@suretyinput



SELECT  DISTINCT mm.MemAccNo,mm.MemEmpCode,mm.MemName, ma.ThriftBalance FROM speccs.Members mm ,speccs.MemberAccount ma 
WHERE mm.MemAccNo NOT IN(@Surety4,@Surety5,@Surety6,@MemAccNo) AND ma.MemAccNo=mm.MemAccNo
RETURN

END





GO

