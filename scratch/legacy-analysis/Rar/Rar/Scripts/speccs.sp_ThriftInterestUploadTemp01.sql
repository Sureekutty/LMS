
IF OBJECT_ID('speccs.sp_ThriftInterestUploadTemp01') IS NOT NULL
    DROP PROCEDURE speccs.sp_ThriftInterestUploadTemp01
GO

CREATE PROCEDURE speccs.sp_ThriftInterestUploadTemp01
    @EmpCode     VARCHAR(50),
    @UploadDate  DATETIME,
    @Amount      FLOAT,
    @ThriftType  INT
AS
BEGIN
    -- Commented DROP and CREATE TABLE statements for prerequisites
    /*
    IF OBJECT_ID('speccs.ThriftInterestUploading06082025temp1') IS NOT NULL
        DROP TABLE speccs.ThriftInterestUploading06082025temp1
    CREATE TABLE speccs.ThriftInterestUploading06082025temp1 (
        EmpCode VARCHAR(50),         -- Employee code
        UploadDate DATETIME,         -- Upload date
        RegDate DATETIME,            -- Registration date
        Amount FLOAT,                -- Amount
        ThriftType INT               -- Thrift type (e.g., 2 for loan, 3 for thrift)
    )

    IF OBJECT_ID('speccs.ThriftInterestUploadTempNew') IS NOT NULL
        DROP TABLE speccs.ThriftInterestUploadTempNew
    CREATE TABLE speccs.ThriftInterestUploadTempNew (
        SerialNo INT,                -- Serial number for unique identification
        EmpCode VARCHAR(50),         -- Employee code
        UploadDate DATETIME,         -- Upload date
        Amount FLOAT,                -- Amount
        ThriftType INT,              -- Thrift type
        MemAccNum VARCHAR(15)        -- Member account number
    )

    IF OBJECT_ID('speccs.Members') IS NOT NULL
        DROP TABLE speccs.Members
    CREATE TABLE speccs.Members (
        MemEmpCode VARCHAR(50),      -- Employee code
        MemAccNo VARCHAR(15),        -- Member account number
        Status VARCHAR(10)           -- Status (e.g., 'ACTIVE')
    )
    */

    -- Declare variables
    DECLARE @EmpCodeExists INT,
            @MemAccNum VARCHAR(15),
            @SerialNo INT,
            @Message VARCHAR(255)

    -- Check if EmpCode exists in the main table
    SELECT @EmpCodeExists = COUNT(*)
    FROM speccs.ThriftInterest06082025temp1
    WHERE EmpCode = @EmpCode

    -- Get MemAccNum from Members table
    SELECT @MemAccNum = MemAccNo
    FROM speccs.Members
    WHERE MemEmpCode = @EmpCode

    IF @EmpCodeExists = 0
    BEGIN
        -- If EmpCode does not exist, insert into both tables
        INSERT INTO speccs.ThriftInterest06082025temp1 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
        VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)

        -- Calculate next SerialNo for the temporary table
        SELECT @SerialNo = COALESCE(MAX(SerialNo), 0) + 1
        FROM speccs.ThriftInterestUploadTempNew

        INSERT INTO speccs.ThriftInterestUploadTempNew (SerialNo, EmpCode, UploadDate, Amount, ThriftType, MemAccNum)
        VALUES (@SerialNo, @EmpCode, @UploadDate, @Amount, @ThriftType, @MemAccNum)
    END
    ELSE
    BEGIN
        -- If EmpCode exists, check if UploadDate matches
        IF EXISTS (
            SELECT 1
            FROM speccs.ThriftInterest06082025temp1
            WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        )
        BEGIN
            -- Update existing record in both tables
            UPDATE speccs.ThriftInterest06082025temp1
            SET Amount = @Amount,
                ThriftType = @ThriftType,
                RegDate = GETDATE()
            WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate

            UPDATE speccs.ThriftInterestUploadTempNew
            SET Amount = @Amount,
                ThriftType = @ThriftType
            WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        END
        ELSE
        BEGIN
            -- Insert new record if UploadDate differs
            INSERT INTO speccs.ThriftInterest06082025temp1 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
            VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)

            -- Calculate next SerialNo for the temporary table
            SELECT @SerialNo = COALESCE(MAX(SerialNo), 0) + 1
            FROM speccs.ThriftInterestUploadTempNew

            INSERT INTO speccs.ThriftInterestUploadTempNew (SerialNo, EmpCode, UploadDate, Amount, ThriftType, MemAccNum)
            VALUES (@SerialNo, @EmpCode, @UploadDate, @Amount, @ThriftType, @MemAccNum)
        END
    END


    -- Call the processing procedure
    EXEC speccs.sp_ThriftProcessUpload
END
GO