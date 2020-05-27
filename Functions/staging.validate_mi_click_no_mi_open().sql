CREATE OR REPLACE FUNCTION staging.validate_mi_click_no_mi_open(_campaign_id varchar(100))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _mi_campaign_id varchar(100);
BEGIN
	_mi_campaign_id := (SELECT mi_campaign_id FROM staging.campaigns WHERE id = _campaign_id);

	INSERT INTO staging.validate_mi_click_no_mi_open(mi_u, campaign_id, app_id)
	SELECT mi_click.mi_u, mi_click.campaign_id, mi_click.app_id
	FROM staging.mi_event_log_click_unique AS mi_click
	LEFT JOIN staging.mi_event_log_open_unique AS mi_open
	ON mi_click.mi_u = mi_open.mi_u AND mi_click.campaign_id = mi_open.campaign_id AND mi_click.app_id = mi_open.app_id
    WHERE mi_click.campaign_id = _mi_campaign_id AND mi_open.campaign_id = _mi_campaign_id AND mi_open.mi_u IS NULL;

	RETURN 'staging.validate_mi_click_no_mi_open check is completed';
END;
$function$
;