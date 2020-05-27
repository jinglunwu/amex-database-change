CREATE OR REPLACE FUNCTION staging.agency_sendjob_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	INSERT INTO staging.agency_sendjob(client_id, send_id, from_name, from_email, schedule_time, sent_time, subject, email_name, triggered_send_external_key, send_definition_external_key,
	job_status, email_id, is_multipart, additional, meta, checksum, created_at)
	SELECT data->>'ClientID', data->>'SendID', data->>'FromName', data->>'FromEmail', TO_DATE(data->>'ScheduledTime', 'MM/DD/YYYY HH:MI:SS AM'),
	TO_DATE(data->>'SentTime', 'MM/DD/YYYY HH:MI:SS AM'), data->>'Subject', data->>'EmailName', data->>'TriggeredSendExternalKey', data->>'SendDefinitionExternalKey', data->>'JobStatus',
	data->>'EmailID', data->>'IsMultipart', data->>'Additional', meta, checksum, current_timestamp
	FROM raw.sales_force_sendjob
	WHERE processed_at IS NULL;
	
	UPDATE raw.sales_force_sendjob SET processed_at = CURRENT_TIMESTAMP WHERE processed_at IS NULL;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
