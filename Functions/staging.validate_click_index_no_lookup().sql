CREATE OR REPLACE FUNCTION staging.validate_click_index_no_lookup(_campaign_id character varying)
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
	
	INSERT INTO staging.validate_click_index_no_lookup
	SELECT DISTINCT _drop_date, _campaign_id, _portfolio, alias_placement_index 
	FROM staging.agency_click 
	WHERE alias_placement_index_source IN (0,1) AND LENGTH(encrypted_email) >= 40 AND offer_1_lob_campaign_id = _campaign_id AND 
	alias_placement_index <> 'Refer a Friend' AND 
	alias_placement_index NOT IN (SELECT "index" FROM staging.placements WHERE campaign_id = _campaign_id);
	
	RETURN '--Validation is completed--';
END;
$function$
;