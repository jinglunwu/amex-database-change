CREATE OR REPLACE FUNCTION staging.agency_click_brandnew_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	TRUNCATE TABLE staging.agency_click;
	
	INSERT INTO staging.agency_click(id, encrypted_email, job_id, list_id, batch_id, subscriber_id, offer_1_lob_campaign_id, offer_1_cell_id, clic_cust_id, message_id, card_product,
	send_url_id, url_id, url, alias, alias_order, alias_section, alias_slot, alias_placement_index, alias_cta, impression_region_name, marketing, servicing, footer, click_activity_date,
	meta, checksum, created_at)
	SELECT id, data->>'ENCRYPTED_EMAIL', data->>'JobID', data->>'ListID', data->>'BatchID', data->>'SubscriberID', data->>'offer_1_lob_campaign_id', data->>'offer_1_cell_id',
	data->>'CLIC_CUST_ID', data->>'MESSAGE_ID', data->>'card_product', data->>'SendURLID', data->>'URLID', data->>'URL', data->>'Alias', DATA->>'alias_order',
	data->>'alias_section', data->>'alias_slot', data->>'alias_placement_index', data->>'alias_cta', data->>'ImpressionRegionName',
	data->>'Marketing', data->>'Servicing', data->>'Footer', TO_TIMESTAMP(data->>'Click Activity Date', 'MM/DD/YYYY HH:MI:SS AM'), meta, checksum, current_timestamp
	FROM raw.sales_force_click;	
	
	UPDATE staging.agency_click
	SET offer_1_cell_id = '2222E46Z_CENT'
	WHERE offer_1_cell_id = '2222E46Z' AND offer_1_lob_campaign_id = 'ZBK1UMCA';
	
	UPDATE staging.agency_click
	SET offer_1_cell_id = '2222E46Z_CHRG'
	WHERE offer_1_cell_id = '2222E46Z' AND offer_1_lob_campaign_id = 'ZBH1UMCA';
	
	UPDATE staging.agency_click
	SET offer_1_cell_id = '2222EAJ4_CHRG'
	WHERE offer_1_cell_id = '2222EAJ4' AND offer_1_lob_campaign_id = 'ZM71UMCA';
	
	UPDATE staging.agency_click
	SET offer_1_cell_id = '2222EAJ4_PROP'
	WHERE offer_1_cell_id = '2222EAJ4' AND offer_1_lob_campaign_id = 'ZPC1UMCA';	
	
	UPDATE raw.sales_force_click SET processed_at = CURRENT_TIMESTAMP WHERE processed_at IS NULL;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
