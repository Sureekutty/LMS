IF OBJECT_ID ('speccs.SP_EMPLOYEECODELIST') IS NOT NULL
	DROP PROCEDURE speccs.SP_EMPLOYEECODELIST
GO

CREATE  PROCEDURE speccs.SP_EMPLOYEECODELIST
@Option  		VARCHAR (20),
@status CHAR(9)


AS

/*
	DROP PROCEDURE  speccs.SP_EMPLOYEECODELIST
	
	GRANT ALL ON speccs.SP_EMPLOYEECODELIST to speccsgroup
*/
   	IF (@Option="ALL") 
	BEGIN
		
	   	SELECT empData.MemEmpCode,empData.MemName,mem.MemAccNo, mem.Status
	 	FROM speccs.EmployeeData  empData
	 	LEFT JOIN speccs.Members mem 
	 	ON empData.MemEmpCode = mem.MemEmpCode AND mem.Status NOT IN ('SETTLED','CANCELLED','CANCELED')
	  --	WHERE empData.MemEmpCode NOT IN ( SELECT memData.MemEmpCode  FROM speccs.Members memData)
	RETURN
	END
	IF (@Option="SOCIETYMEM") 
	BEGIN
		SELECT MemEmpCode,MemName,MemAccNo FROM speccs.Members mem 
		WHERE mem.Status IN ('ACTIVE','SETTLED') --FOR TIMEBEING
		
		
		
	   RETURN
	END
	IF (@Option="ALLMEMEBERS") 
	BEGIN
		SELECT DISTINCT(A.MemEmpCode+"-"+A.MemName) AS empcode FROM speccs.EmployeeData A
		 WHERE A.MemEmpCode NOT IN (SELECT MemEmpCode FROM speccs.Members) 
		  AND A.Status IN('SERV','PROB','SUSP','EXIT') --Added exit by pn on 21/02/2025 because RamaRao sir told
	   RETURN
	END
	IF (@Option="RULECODE") 
	BEGIN
		SELECT RuleValue FROM speccs.Rules WHERE RuleCode='104'
	   RETURN
	END


	IF (@Option="SURITYLIST") 
	BEGIN
		SELECT DISTINCT mem.MemEmpCode,mem.MemName,mem.MemAccNo,mac.ThriftBalance FROM speccs.Members mem
	   
		LEFT JOIN speccs.MemberAccount mac
			ON mem.MemAccNo = mac.MemAccNo		
		WHERE mem.MemAccNo NOT IN(@status) AND mem.Status='ACTIVE'
	   RETURN
	END
	
	
	IF (@Option="SURITYLISTTHRIFT") 
	BEGIN
		SELECT mac.ThriftBalance FROM  speccs.MemberAccount mac WHERE mac.MemAccNo=@status
	   RETURN
	END

	
   
	
	
IF (@Option="SURITYLISTLOAD") 
	BEGIN
		SELECT MemEmpCode,MemName,MemAccNo FROM speccs.Members mem
		WHERE mem.Status='ACTIVE'
	   RETURN
	END












GO

