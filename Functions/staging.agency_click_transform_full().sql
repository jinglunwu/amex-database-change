CREATE OR REPLACE FUNCTION staging.agency_click_transform_full()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	TRUNCATE TABLE staging.agency_click;
	
	INSERT INTO staging.agency_click(id, encrypted_email, job_id, list_id, batch_id, subscriber_id, offer_1_lob_campaign_id, offer_1_cell_id, clic_cust_id, message_id, card_product,
	send_url_id, url_id, url, alias, alias_order, alias_section, alias_slot, alias_placement_index, alias_cta, alias_placement_index_source, impression_region_name, marketing, servicing, footer, click_activity_date,
	meta, checksum, created_at)
	SELECT id, data->>'ENCRYPTED_EMAIL', data->>'JobID', data->>'ListID', data->>'BatchID', data->>'SubscriberID', data->>'offer_1_lob_campaign_id', data->>'offer_1_cell_id',
	data->>'CLIC_CUST_ID', data->>'MESSAGE_ID', data->>'card_product', data->>'SendURLID', data->>'URLID', data->>'URL', data->>'Alias', DATA->>'alias_order',
	data->>'alias_section', data->>'alias_slot', data->>'alias_placement_index', data->>'alias_cta', 0, data->>'ImpressionRegionName',
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

	UPDATE staging.agency_click 
	SET alias = '|highlights_body||D10|Year End Summary', 
	alias_order='', alias_section='highlights_body', alias_slot = '', alias_placement_index='D10', alias_cta = 'Year End Summary'
	WHERE alias LIKE '%Concat(@link_alias,''|D10%' AND offer_1_lob_campaign_id IN ('18V1UMCA', '18T3UMCA', '18R4UMCA');

	UPDATE staging.agency_click 
	SET alias = '|highlights_body||D11|Year End Summary Fallback', 
	alias_order='', alias_section='highlights_body', alias_slot = '', alias_placement_index='D11', alias_cta = 'Year End Summary Fallback'
	WHERE alias LIKE '%Concat(@link_alias,''|D11%' AND offer_1_lob_campaign_id IN ('18V1UMCA', '18T3UMCA', '18R4UMCA');

	UPDATE staging.agency_click 
	SET alias = '|highlights_body||D19|Year End Summary', 
	alias_order='', alias_section='highlights_body', alias_slot = '', alias_placement_index='D19', alias_cta = 'Year End Summary'
	WHERE alias LIKE '%Concat(@link_alias,''|D19%' AND offer_1_lob_campaign_id IN ('18V1UMCA', '18T3UMCA', '18R4UMCA');

	UPDATE staging.agency_click 
	SET alias = '|highlights_body||D3|Dining Credit Used in 2018', 
	alias_order='', alias_section='highlights_body', alias_slot = '', alias_placement_index='D3', alias_cta = 'Dining Credit Used in 2018'
	WHERE alias LIKE '%Concat(@link_alias,''|D3%' AND offer_1_lob_campaign_id IN ('18V1UMCA', '18T3UMCA', '18R4UMCA');
	
	--Add the original_cell_id column into the staging.agency_click table before run this function	
	UPDATE staging.agency_click 
	SET original_cell_id = offer_1_cell_id 
	WHERE offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA');
	
	UPDATE staging.agency_click
	SET offer_1_cell_id = staging.agency_click.offer_1_cell_id || '_NYC' 
	FROM staging.agency_sent
	WHERE staging.agency_click.offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA') AND
	staging.agency_click.encrypted_email = staging.agency_sent.encrypted_email AND 
	staging.agency_click.offer_1_lob_campaign_id = staging.agency_sent.offer_1_lob_campaign_id AND
	staging.agency_click.original_cell_id = staging.agency_sent.original_cell_id AND
	staging.agency_sent.offer_1_cell_id LIKE '%_NYC' AND
	(staging.agency_sent.offer_1_pers_1 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_2 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_3 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_4 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_5 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_1_pers_6 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_7 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_8 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_9 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_10 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_2_pers_1 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_2 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_3 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_4 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_5 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_2_pers_6 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_7 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_8 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_9 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_10 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_3_pers_1 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_2 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_3 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_4 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_5 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_3_pers_6 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_7 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_8 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_9 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_10 = staging.agency_click.alias_placement_index);
	
	UPDATE raw.sales_force_click SET processed_at = CURRENT_TIMESTAMP WHERE processed_at IS NULL;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;