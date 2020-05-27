CREATE OR REPLACE FUNCTION staging.mi_event_log_click_open_merge()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	TRUNCATE TABLE staging.mi_event_log_click_open_merge;
	
	INSERT INTO staging.mi_event_log_click_open_merge(mi_u, campaign_id, app_id, url, extra_data_code)
	SELECT staging.mi_event_log_click_unique.mi_u, staging.mi_event_log_click_unique.campaign_id, staging.mi_event_log_click_unique.app_id, url, extra_data_code
	FROM staging.mi_event_log_click_unique
	INNER JOIN staging.mi_event_log_open_unique
	ON staging.mi_event_log_click_unique.campaign_id = staging.mi_event_log_open_unique.campaign_id
	AND staging.mi_event_log_click_unique.app_id = staging.mi_event_log_open_unique.app_id
	AND staging.mi_event_log_click_unique.mi_u = staging.mi_event_log_open_unique.mi_u;
	
	UPDATE staging.mi_event_log_click_open_merge
	SET sf_campaign_id = staging.campaigns.id
	FROM staging.campaigns
	WHERE staging.mi_event_log_click_open_merge.campaign_id = staging.campaigns.mi_campaign_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
