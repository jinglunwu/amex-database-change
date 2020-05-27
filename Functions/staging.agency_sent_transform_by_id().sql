CREATE OR REPLACE FUNCTION staging.agency_sent_transform_by_id(start_id bigint, end_id bigint)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4 DEFAULT 0;
BEGIN
	INSERT INTO staging.agency_sent(id, encrypted_email, job_id, list_id, batch_id, subscriber_id, offer_1_lob_campaign_id, offer_1_cell_id, clic_cust_id, message_id, card_product_code,
	gran_ctgy_cd_key, card_product, offer_1_pers_1, offer_1_pers_2, offer_1_pers_3, offer_1_pers_4, offer_1_pers_5, offer_1_pers_6, offer_1_pers_7, offer_1_pers_8, offer_1_pers_9,
	offer_1_pers_10, offer_2_pers_1, offer_2_pers_2, offer_2_pers_3, offer_2_pers_4, offer_2_pers_5, offer_2_pers_6, offer_2_pers_7, offer_2_pers_8, offer_2_pers_9, offer_2_pers_10,
	offer_3_pers_1, offer_3_pers_2, offer_3_pers_3, offer_3_pers_4, offer_3_pers_5, offer_3_pers_6, offer_3_pers_7, offer_3_pers_8, offer_3_pers_9, offer_3_pers_10, sent_activity_date,
	meta, checksum, created_at)
	SELECT id, data->>'ENCRYPTED_EMAIL', data->>'JobID', data->>'ListID', data->>'BatchID', data->>'SubscriberID', data->>'OFFER_1_LOB_CAMPAIGN_ID', data->>'OFFER_1_CELL_ID',
	data->>'CLIC_CUST_ID', data->>'MESSAGE_ID', data->>'CARD_PRODUCT_CODE', data->>'GRAN_CTGY_CD_KEY', data->>'CARD_PRODUCT', data->>'OFFER_1_PERS_1', data->>'OFFER_1_PERS_2',
	data->>'OFFER_1_PERS_3', data->>'OFFER_1_PERS_4', data->>'OFFER_1_PERS_5', data->>'OFFER_1_PERS_6', data->>'OFFER_1_PERS_7', data->>'OFFER_1_PERS_8', data->>'OFFER_1_PERS_9',
	data->>'OFFER_1_PERS_10', data->>'OFFER_2_PERS_1', data->>'OFFER_2_PERS_2', data->>'OFFER_2_PERS_3', data->>'OFFER_2_PERS_4', data->>'OFFER_2_PERS_5', data->>'OFFER_2_PERS_6',
	data->>'OFFER_2_PERS_7', data->>'OFFER_2_PERS_8', data->>'OFFER_2_PERS_9', data->>'OFFER_2_PERS_10', data->>'OFFER_3_PERS_1', data->>'OFFER_3_PERS_2', data->>'OFFER_3_PERS_3',
	data->>'OFFER_3_PERS_4', data->>'OFFER_3_PERS_5', data->>'OFFER_3_PERS_6', data->>'OFFER_3_PERS_7', data->>'OFFER_3_PERS_8', data->>'OFFER_3_PERS_9', data->>'OFFER_3_PERS_10',
	TO_TIMESTAMP(data->>'SENT ACTIVITY DATE', 'MM/DD/YYYY HH:MI:SS AM'), meta, checksum, current_timestamp
	FROM raw.sales_force_sent
	WHERE id > start_id AND id <= end_id;
	
	UPDATE raw.sales_force_sent SET processed_at = current_timestamp WHERE id > start_id AND id <= end_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;	
END;
$function$
;
