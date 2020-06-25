-- MSSQL script to change Incremental Scan Threshold and Action
-- By default, Incremental Scans have 7% of changed files as a threshold, if this threshold is overcome by default the scan will fail
-- CxVersion Tested: 8.9.0 HF14
-- Date: 30 March 2020
-- Author: Miguel Freitas <miguel.freitas@checkmarx.com>
USE [CxDB]
GO
 
DECLARE @INCREMENTAL_SCAN_THRESHOLD INT
DECLARE @INCREMENTAL_SCAN_THRESHOLD_ACTION NVARCHAR(50)
 
SET @INCREMENTAL_SCAN_THRESHOLD = 7 -- (1-19), Default 7
SET @INCREMENTAL_SCAN_THRESHOLD_ACTION = 'FULL' -- FAIL or FULL, Default FAIL
  
IF (@INCREMENTAL_SCAN_THRESHOLD > 0 AND @INCREMENTAL_SCAN_THRESHOLD < 20)
    BEGIN
        UPDATE [Config].[CxEngineConfigurationKeysMeta]
        SET DefaultValue = @INCREMENTAL_SCAN_THRESHOLD
        WHERE KeyName = 'INCREMENTAL_SCAN_THRESHOLD'
        UPDATE [dbo].[CxComponentConfiguration]
        SET [Value] = @INCREMENTAL_SCAN_THRESHOLD
        WHERE [Key] = 'INCREMENTAL_SCAN_THRESHOLD'
    END
ELSE
    BEGIN
        PRINT 'INCREMENTAL_SCAN_THRESHOLD out of interval (1-19)'
    END
IF (@INCREMENTAL_SCAN_THRESHOLD_ACTION = 'FAIL' OR @INCREMENTAL_SCAN_THRESHOLD_ACTION = 'FULL')
    BEGIN
        UPDATE [Config].[CxEngineConfigurationKeysMeta]
        SET [DefaultValue] = @INCREMENTAL_SCAN_THRESHOLD_ACTION
        WHERE [KeyName] = 'INCREMENTAL_SCAN_THRESHOLD_ACTION'
        UPDATE [dbo].[CxComponentConfiguration]
        SET [Value] = @INCREMENTAL_SCAN_THRESHOLD_ACTION
        WHERE [Key] = 'INCREMENTAL_SCAN_THRESHOLD_ACTION'
    END
ELSE
    BEGIN
        PRINT 'INCREMENTAL_SCAN_THRESHOLD_ACTION valid values: FAIL or FULL'
    END
 
SELECT * FROM [Config].[CxEngineConfigurationKeysMeta] where [KeyName] IN ('INCREMENTAL_SCAN_THRESHOLD','INCREMENTAL_SCAN_THRESHOLD_ACTION') order by [KeyName]
 
SELECT * FROM [dbo].[CxComponentConfiguration] where [Key] IN ('INCREMENTAL_SCAN_THRESHOLD','INCREMENTAL_SCAN_THRESHOLD_ACTION') order by [Key]
