-- http://sqlblog.com/blogs/davide_mauri/archive/2013/03/19/extended-events-did-it-again-monitoring-stored-procedures-performance.aspx
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-event-session-transact-sql
--   requires the ALTER ANY EVENT SESSION permission
-- SSMS: Management/Extended Events/Sessions + right-click/New Session Wizard

CREATE EVENT SESSION [SessionName] ON SERVER 
ADD EVENT sqlserver.rpc_completed 
( 
	ACTION	( package0.collect_system_time, package0.process_id, sqlserver.client_app_name, sqlserver.client_connection_id, sqlserver.client_hostname,
		      sqlserver.client_pid, sqlserver.database_id, sqlserver.database_name, sqlserver.nt_username, sqlserver.request_id, sqlserver.session_id,
			  sqlserver.session_nt_username, sqlserver.sql_text, sqlserver.transaction_id, sqlserver.transaction_sequence,sqlserver.username ) 
    WHERE   ( [object_name] = 'spName' ) 
), 
ADD EVENT sqlserver.module_end 
( 
	ACTION  ( package0.collect_system_time, package0.process_id, sqlserver.client_app_name, sqlserver.client_connection_id, sqlserver.client_hostname,
	          sqlserver.client_pid, sqlserver.database_id, sqlserver.database_name, sqlserver.nt_username, sqlserver.request_id, sqlserver.session_id,
			  sqlserver.session_nt_username, sqlserver.sql_text, sqlserver.transaction_id, sqlserver.transaction_sequence, sqlserver.username ) 
    WHERE   ( [object_name] = 'spName' ) 
    ) 
ADD TARGET package0.ring_buffer 
WITH 
(        
	STARTUP_STATE=OFF 
) 
GO

DROP EVENT SESSION [SessionName] ON SERVER
GO
