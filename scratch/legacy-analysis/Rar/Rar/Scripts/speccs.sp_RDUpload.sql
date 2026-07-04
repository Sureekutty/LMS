IF OBJECT_ID ('speccs.sp_RDUpload') IS NOT NULL
	DROP PROCEDURE speccs.sp_RDUpload
GO

CREATE PROCEDURE speccs.sp_RDUpload
    @EmpCode     VARCHAR(50),
    @UploadDate  DATETIME,
    @Amount      FLOAT
AS
BEGIN
    -- Declare variable to check if EmpCode exists
    		DECLARE @EmpCodeExists INT
    	 

    -- Check if EmpCode exists in the table
    		SELECT @EmpCodeExists = COUNT(*)
    		FROM speccs.sp_RDUpload20082025temp
    		WHERE EmpCode = @EmpCode
-----------Start 0 ------------
    	IF @EmpCodeExists = 0
    	BEGIN
        -- If EmpCode does not exist, insert new record
        			INSERT INTO speccs.sp_RDUpload20082025temp (EmpCode, UploadDate, RegDate, Amount)
       				VALUES (@EmpCode, @UploadDate, getdate(), @Amount)
    	END
    	ELSE
    	BEGIN
       		 -- If EmpCode exists, check if UploadDate matches an existing record
        		IF EXISTS (
            		SELECT 1 
            		FROM speccs.sp_RDUpload20082025temp 
            		WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        			)
        		BEGIN
            		-- Update Amount and ThriftType for the matching record
            	UPDATE speccs.sp_RDUpload20082025temp
            	SET Amount = @Amount,
                RegDate = getdate() -- Update RegDate on modification
            	WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
       
        		END
        		ELSE
        		BEGIN
           		 -- If UploadDate differs, insert new record for the same EmpCode
            	INSERT INTO speccs.sp_RDUpload20082025temp (EmpCode, UploadDate, RegDate, Amount)
            	VALUES (@EmpCode, @UploadDate, getdate(), @Amount)
        		END
    	END
    
    
    
    
          	   	   
END






GO

/*

Table Creation 
IF OBJECT_ID ('speccs.sp_RDUpload20082025temp') IS NOT NULL
	DROP TABLE speccs.sp_RDUpload20082025temp
GO

CREATE TABLE speccs.sp_RDUpload20082025temp
	(
	EmpCode    VARCHAR (50) NOT NULL,
	UploadDate DATETIME NOT NULL,
	RegDate    DATETIME NOT NULL,
	Amount     FLOAT NOT NULL
	)
GO





*/
