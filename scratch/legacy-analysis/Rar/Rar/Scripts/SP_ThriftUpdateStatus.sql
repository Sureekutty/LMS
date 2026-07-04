IF OBJECT_ID ('speccs.SP_ThriftUpdateStatus') IS NOT NULL
	DROP PROCEDURE speccs.SP_ThriftUpdateStatus
GO

CREATE PROCEDURE speccs.SP_ThriftUpdateStatus
    @MemCode VARCHAR(50),--MemAccNO
    @RequestedAmount FLOAT,
   	@EmpCode VARCHAR(50),
   	@Rem VARCHAR(50),
   	@StatusThft VARCHAR(50)
   	
    
AS
BEGIN
    -- Comment: Declare variables for fetched data
    DECLARE @EmployeeName VARCHAR(100),
            @MemberAccNo VARCHAR(50),
            @ThriftSubscriptionAmount DECIMAL(18,2)

    -- Comment: Fetch Name and MemAccNo from Members table using @EmpCode
    SELECT @EmployeeName = MemName, @MemberAccNo = MemAccNo
    FROM speccs.Members
    WHERE MemEmpCode = @EmpCode

    -- Comment: Fetch current ThriftSubscriptionAmount from MemberAccounts using @MemberAccNo
    -- Assumption: Table is speccs.MemberAccounts, column is ThriftSubscriptionAmount (adjust if column name differs)
    SELECT @ThriftSubscriptionAmount = ThriftSubscriptionAmount
    FROM speccs.MemberAccount
    WHERE MemAccNo = @MemCode

    -- Comment: Insert the record into ThriftRequests
    INSERT INTO speccs.ThriftUpdateStatus (
        EmployeeName,
        MemberAccNo,
        ThriftSubscriptionAmount,
        RequestedAmount,
        TransactionDate,
        Status,
        RegTime,
        UserId
    )
    VALUES (
        @EmployeeName,
        @MemberAccNo,
        @ThriftSubscriptionAmount,
        @RequestedAmount,
        GETDATE(),  -- Requested date
        @StatusThft,  -- Initial status
        GETDATE(),  -- Reg time
        @EmpCode  -- UserId
    )
    
    -- Comment: Optional - You can add error handling here if needed, e.g., IF @@ERROR != 0 ...
END
GO

