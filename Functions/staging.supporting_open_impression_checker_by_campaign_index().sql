CREATE OR REPLACE FUNCTION staging.supporting_open_impression_checker_by_campaign_index(_campaign_id varchar(500), _placement_index varchar(500))
RETURNS text
LANGUAGE plpgsql
AS $function$
DECLARE row_count int4;
BEGIN
	
	row_count := (SELECT COUNT(*) FROM staging.mi_event_log_open_unique 
	INNER JOIN staging.campaigns 
	ON staging.mi_event_log_open_unique.campaign_id = staging.campaigns.mi_campaign_id
	WHERE staging.campaigns.id = _campaign_id AND extra_data_code = _placement_index);

	IF row_count > 0 THEN
		RETURN 'Yes';
	ELSE
		RETURN 'No';
	END IF;	
	
	
END;
$function$
;