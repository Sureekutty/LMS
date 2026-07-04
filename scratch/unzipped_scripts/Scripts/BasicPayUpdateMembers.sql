
IF OBJECT_ID ('speccs.temprama1') IS NOT NULL
	DROP TABLE speccs.temprama1
GO

CREATE TABLE speccs.temprama1
	(
	MemEmpCode CHAR (7) NULL,
	BasicPay NUMERIC(15,2) NULL 
	)
GO