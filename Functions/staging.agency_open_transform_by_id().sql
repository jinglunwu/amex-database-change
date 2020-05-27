CREATE OR REPLACE FUNCTION staging.agency_open_transform_by_id(start_id bigint, end_id bigint)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	INSERT INTO staging.agency_open(id, encrypted_email, job_id, list_id, batch_id, subscriber_id, offer_1_lob_campaign_id, offer_1_cell_id,
    clic_cust_id, message_id, card_product, offer_3_pers_4, open_activity_date, meta, checksum, created_at) 
	SELECT id, data->>'ENCRYPTED_EMAIL', data->>'JobID', data->>'ListID', data->>'BatchID', data->>'SubscriberID', data->>'offer_1_lob_campaign_id',
	data->>'offer_1_cell_id', data->>'CLIC_CUST_ID', data->>'MESSAGE_ID',  data->>'card_product', data->>'OFFER_3_PERS_4', 
	TO_TIMESTAMP(data->>'Open Activity Date', 'MM/DD/YYYY HH:MI:SS AM'), meta, checksum, CURRENT_TIMESTAMP
	FROM raw.sales_force_open
	WHERE id > start_id AND id <= end_id;
	
	UPDATE raw.sales_force_open SET processed_at = CURRENT_TIMESTAMP WHERE id > start_id AND id <= end_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
