CREATE OR REPLACE FUNCTION staging.validate_placement_index_in_mi_no_lookup(_campaign_id varchar(100))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _portfolio varchar(500);
DECLARE _mi_campaign_id varchar(100);
BEGIN	
	SELECT drop_date, "name", mi_campaign_id
	FROM staging.campaigns 
	INNER JOIN staging.portfolios
	ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id
	INTO _drop_date, _portfolio, _mi_campaign_id; 
	
	INSERT INTO staging.validate_placement_index_in_mi_no_lookup
	SELECT DISTINCT _drop_date, _campaign_id, _portfolio, extra_data_code
	FROM staging.mi_event_log_open_unique
	WHERE campaign_id = _mi_campaign_id AND extra_data_code <> '' AND 
	extra_data_code NOT IN (SELECT "index" FROM staging.placements WHERE campaign_id = _campaign_id);

	RETURN '--Check is completed';
END;
$function$
;