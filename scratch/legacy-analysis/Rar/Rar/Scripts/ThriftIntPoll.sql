IF OBJECT_ID ('speccs.ThriftIntPoll') IS NOT NULL
	DROP TABLE speccs.ThriftIntPoll
GO

CREATE TABLE speccs.ThriftIntPoll
	(
	MemAccNo     VARCHAR (5) NOT NULL,
	MemEmpCode   VARCHAR (8) NOT NULL,
	MemName      VARCHAR (50) NOT NULL,
	ThriftIntOpt VARCHAR (20) NOT NULL,
	ThriftOption INT DEFAULT 3 NOT NULL,
	OptedDate    DATETIME NOT NULL,
	UserId       VARCHAR (7) NOT NULL,
	RegTime      DATETIME NOT NULL,
	CONSTRAINT PK_MEMACCNO PRIMARY KEY (MemAccNo,MemEmpCode),
	CONSTRAINT MEMACCNO_FK FOREIGN KEY (MemAccNo) REFERENCES speccs.Members (MemAccNo)
	)
GO



INSERT INTO speccs.ThriftIntPoll	
	SELECT MemAccNo,MemEmpCode,MemName,'Thrift Account',3,getdate(),'SH15823',getdate() FROM speccs.Members WHERE Status='ACTIVE'


--UPDATE speccs.ThriftIntPoll SET OptedDate=getdate(), ThriftIntOpt=poll,ThriftOption=pollOpted WHERE MemEmpCode=empCode




