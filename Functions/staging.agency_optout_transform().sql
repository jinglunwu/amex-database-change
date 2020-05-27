CREATE OR REPLACE FUNCTION staging.agency_optout_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	INSERT INTO staging.agency_optout(id, encrypted_email, job_id, list_id, batch_id, subscriber_id, offer_1_lob_campaign_id, offer_1_cell_id, clic_cust_id, message_id, card_product,
	offer_3_pers_4, optout_activity_date, meta, checksum, created_at)
	SELECT id, data->>'ENCRYPTED_EMAIL', data->>'JobID', data->>'ListID', data->>'BatchID', data->>'SubscriberID', data->>'offer_1_lob_campaign_id', data->>'offer_1_cell_id',
	data->>'CLIC_CUST_ID', data->>'MESSAGE_ID', data->>'card_product', data->>'OFFER_3_PERS_4', TO_TIMESTAMP(data->>'OptOut Activity Date', 'MM/DD/YYYY HH:MI:SS AM'), meta,
	checksum, current_timestamp
	FROM raw.sales_force_optout
	WHERE processed_at IS NULL;
	
	UPDATE raw.sales_force_optout SET processed_at = CURRENT_TIMESTAMP WHERE processed_at IS NULL;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
