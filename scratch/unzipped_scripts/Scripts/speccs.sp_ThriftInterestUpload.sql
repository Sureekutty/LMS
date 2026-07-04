
-- Drop Table if exists
IF OBJECT_ID('speccs.ThriftInterestUploading') IS NOT NULL
    DROP TABLE speccs.ThriftInterestUploading
GO

-- Create Table
CREATE TABLE speccs.ThriftInterestUploading (
    EmpCode     VARCHAR(50)   NOT NULL,
    UploadDate  DATETIME      NOT NULL,
    RegDate     DATETIME      NOT NULL,
    Amount      FLOAT         NOT NULL
)
GO



-- Drop Procedure if exists
IF OBJECT_ID('speccs.sp_ThriftInterestUpload') IS NOT NULL
    DROP PROCEDURE speccs.sp_ThriftInterestUpload
GO

-- Create Procedure
CREATE PROCEDURE speccs.sp_ThriftInterestUpload
    @EmpCode     VARCHAR(50),
    @UploadDate  DATETIME,
    @Amount      FLOAT
AS
BEGIN
    INSERT INTO speccs.ThriftInterestUploading (EmpCode, UploadDate, RegDate, Amount)
    VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount)
END
GO
