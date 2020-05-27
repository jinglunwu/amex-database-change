CREATE OR REPLACE FUNCTION staging.validate_sf_placement_index_no_sf(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _portfolio varchar(500);
BEGIN	
	SELECT drop_date, "name"
	FROM staging.campaigns 
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id
	INTO _drop_date, _portfolio;
	
	INSERT INTO staging.validate_sf_placement_index_no_sf
	SELECT DISTINCT _drop_date, _campaign_id, _portfolio, "index"
	FROM staging.placements
	WHERE campaign_id = _campaign_id AND mi_index_flag <> 'y' AND 
	"index" NOT IN (SELECT alias_placement_index FROM staging.agency_click WHERE offer_1_lob_campaign_id = _campaign_id);
	
	RETURN '--Validation is completed--';
END;
$function$
;