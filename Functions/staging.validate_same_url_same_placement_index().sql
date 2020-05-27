CREATE OR REPLACE FUNCTION staging.validate_same_url_same_placement_index(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _portfolio varchar(500);
BEGIN
	SELECT drop_date, "name"
	FROM staging.campaigns 
	INNER JOIN staging.portfolios
	ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id
	INTO _drop_date, _portfolio; 	
	
	INSERT INTO staging.validate_same_url_same_placement_index(drop_date, campaign_id, portfolio, url_key)
	SELECT DISTINCT _drop_date, _campaign_id, _portfolio, SUBSTRING(url, '.*\%2F(.*)\%2Furl$') 
	FROM staging.agency_click 
	WHERE  url LIKE '%\%2F%\%2Furl' AND offer_1_lob_campaign_id = _campaign_id;

	UPDATE staging.validate_same_url_same_placement_index 
	SET placement_index = ARRAY_TO_STRING(ARRAY(SELECT DISTINCT CASE WHEN alias_placement_index LIKE '%http%' THEN 'blank' ELSE alias_placement_index END 
	FROM staging.agency_click
	WHERE staging.validate_same_url_same_placement_index.campaign_id = staging.agency_click.offer_1_lob_campaign_id AND
	staging.validate_same_url_same_placement_index.url_key = SUBSTRING(staging.agency_click.url, '.*\%2F(.*)\%2Furl$') 
	AND staging.agency_click.url LIKE '%\%2F%\%2Furl' AND offer_1_lob_campaign_id = _campaign_id), ',')
	WHERE campaign_id = _campaign_id;
	
	DELETE FROM staging.validate_same_url_same_placement_index
	WHERE placement_index NOT LIKE '%,%';
	
	RETURN '--Validation is completed--';
END;
$function$
;