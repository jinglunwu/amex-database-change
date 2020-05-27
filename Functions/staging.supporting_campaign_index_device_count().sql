CREATE OR REPLACE FUNCTION staging.supporting_campaign_index_device_count(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _mi_campaign_id varchar(100);
DECLARE _portfolio varchar(500);
BEGIN 
	SELECT drop_date, mi_campaign_id, "name"
	FROM staging.campaigns AS campaigns 
	INNER JOIN staging.portfolios AS portfolios 
	ON campaigns.portfolio_id = portfolios.id 
	WHERE campaigns.id = _campaign_id
	INTO _drop_date, _mi_campaign_id, _portfolio;
	
	INSERT INTO staging.supporting_campaign_index_device_count(drop_date, campaign_id, mi_campaign_id, portfolio, extra_data_code, device_type,
	device_platform, device_browser_family, row_count)
	SELECT _drop_date, _campaign_id, _mi_campaign_id, _portfolio, extra_data_code, device_type, device_platform, device_browser_family, COUNT(1) 
	FROM staging.mi_event_log_open 
	WHERE campaign_id = _mi_campaign_id
	GROUP BY extra_data_code, device_type, device_platform, device_browser_family
	ORDER BY extra_data_code, device_type, device_platform, device_browser_family;

	RETURN '--Validataion is completed--';
END;
$function$
;