CREATE OR REPLACE FUNCTION staging.mi_event_log_click_unique_transform(min_id int8)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	INSERT INTO staging.mi_event_log_click_unique
	SELECT mi_u, campaign_id, app_id, MAX(url)
	FROM staging.mi_event_log_click
	WHERE id >= min_id
	GROUP BY mi_u, campaign_id, app_id
	ON CONFLICT(mi_u, campaign_id, app_id) DO NOTHING;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
