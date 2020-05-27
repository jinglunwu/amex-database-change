CREATE OR REPLACE FUNCTION staging.validate_in_mi_click_not_in_mi_open(_mi_campaign_id varchar(50))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	INSERT INTO staging.validate_in_mi_click_not_in_mi_open
	SELECT staging.mi_event_log_click.* FROM staging.mi_event_log_click
	LEFT OUTER JOIN staging.mi_event_log_open
	ON staging.mi_event_log_click.mi_u = staging.mi_event_log_open.mi_u AND
	staging.mi_event_log_click.campaign_id = staging.mi_event_log_open.campaign_id AND 
	staging.mi_event_log_click.app_id = staging.mi_event_log_open.app_id
	WHERE staging.mi_event_log_click.campaign_id = TRIM(_mi_campaign_id) 
    AND staging.mi_event_log_open.mi_u IS NULL;

	RETURN '--Validation is completed--';
END;
$function$
;