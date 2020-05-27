CREATE OR REPLACE FUNCTION staging.mi_event_log_open_unique_impression_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	TRUNCATE TABLE staging.mi_event_log_open_unique_impression;
	
	INSERT INTO staging.mi_event_log_open_unique_impression(mi_u, campaign_id, extra_data_code, cell_id)
	SELECT mi_u, campaign_id, extra_data_code, cell_id
	FROM staging.mi_event_log_open_unique
	WHERE cell_id IS NOT NULL AND cell_id <> ''
	GROUP BY cell_id, campaign_id, extra_data_code, mi_u;	
	
	INSERT INTO staging.mi_event_log_open_unique_impression(mi_u, campaign_id, extra_data_code, cell_id)
	SELECT  mi_event_log_open_unique.mi_u, mi_event_log_open_unique.campaign_id, mi_event_log_open_unique.extra_data_code, MAX(agency_sent.offer_1_cell_id)
	FROM staging.mi_event_log_open_unique, staging.campaigns, staging.agency_sent
	WHERE staging.mi_event_log_open_unique.mi_u = staging.agency_sent.encrypted_email
	AND staging.campaigns.id = staging.agency_sent.offer_1_lob_campaign_id
	AND staging.campaigns.mi_campaign_id = staging.mi_event_log_open_unique.campaign_id
	AND (cell_id IS NULL OR cell_id = '')
	GROUP BY mi_event_log_open_unique.mi_u, mi_event_log_open_unique.campaign_id, mi_event_log_open_unique.extra_data_code
	ON CONFLICT(mi_u, campaign_id, extra_data_code, cell_id) DO NOTHING;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;