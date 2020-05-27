CREATE OR REPLACE FUNCTION staging.supporting_campaign_device_type_count(_campaign_id varchar(100))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _mi_campaign_id varchar(100);
DECLARE _portfolio varchar(500);
BEGIN	
	SELECT drop_date, mi_campaign_id, "name"
	FROM staging.campaigns 
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id
	INTO _drop_date,  _mi_campaign_id, _portfolio;
	
	INSERT INTO staging.supporting_campaign_device_type_count
	SELECT _drop_date, _campaign_id, _mi_campaign_id, _portfolio, device_type, count(*)
	FROM staging.mi_event_log_click 
	WHERE campaign_id = _mi_campaign_id
	GROUP BY device_type
	ORDER BY count(*) DESC;
	
	RETURN '--Validation is completed--';
END;
$function$
;