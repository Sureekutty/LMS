 -------------------------------------------------------------------
    -- Find the latest (maximum) transaction date for this account
    --------------------------------------------------------------------
    
    DECLARE @maxTranDate DATE
    
    SELECT @maxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions 
    
    
   -------------------------------------------------------------------
    -- MISSED TRANSACTION HANDLING – only if uploaded date is BEFORE latest date
    -- This means some old transaction is being inserted now ? we need to re-calculate balances
    -------------------------------------------------------------------
    DECLARE @uploadDate DATE
    
    --SELECT @uploadDate=
    IF (@uploadDate < @maxTranDate)
    BEGIN
       -------------------------------------------------------------------
        --  Collect ALL future transactions (after the missed upload date)
        --  These are the ones whose balances are now wrong
        -------------------------------------------------------------------
        
        SELECT 
            ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB1 
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @uploadDate 
       
        
        -------------------------------------------------------------------
        --  Get the CORRECT previous balance just BEFORE the missed date
        --  This is our starting point for re-calculation
        -------------------------------------------------------------------
        
        -- Temporary variables to hold each row we process
        DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10), 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME
        
      -------------------------------------------------------------------
        --  WHILE LOOP – Re-calculate every affected transaction in correct order
      -------------------------------------------------------------------
        
        WHILE EXISTS (SELECT 1 FROM #tempB1)
        BEGIN
            -- Get the EARLIEST remaining transaction (oldest first)
            SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            FROM #tempB1 
            ORDER BY TransactionDate ASC, RegTime ASC     --  
            
            
            
            DECLARE @CurrentBalance DECIMAL(18,2)
            
            IF (LEFT(@CurrentReceiptNo,1) = 'R')
                SELECT  @CurrentBalance = - @CurrentAmount
            ELSE
                SELECT  @CurrentBalance = @CurrentAmount
            
           
            
            UPDATE speccs.BankTransactions
            SET BankBalance =BankBalance + @CurrentBalance
            WHERE RefNo = @CurrentRefNo 
              AND ReceiptNo = @CurrentReceiptNo
            
           
            -- Remove processed row from temp table
            DELETE FROM #tempB1 
            WHERE RefNo = @CurrentRefNo 
              AND ReceiptNo = @CurrentReceiptNo
        END
       
   
        
    END   -- End of missed transaction handling