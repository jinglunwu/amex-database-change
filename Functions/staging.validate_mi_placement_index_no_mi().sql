CREATE OR REPLACE FUNCTION staging.validate_mi_placement_index_no_mi(_campaign_id varchar(100))
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
	
	INSERT INTO staging.validate_mi_placement_index_no_mi
	SELECT DISTINCT _drop_date, _campaign_id, _mi_campaign_id, _portfolio, "index"
	FROM staging.placements
	WHERE campaign_id = _campaign_id AND mi_index_flag = 'y' AND 
	"index" NOT IN (SELECT DISTINCT extra_data_code FROM staging.mi_event_log_open_unique WHERE campaign_id = _mi_campaign_id);
	
	RETURN '--Validation is completed--';
END;
$function$
;