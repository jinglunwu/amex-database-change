CREATE OR REPLACE FUNCTION staging.supporting_campaign_placement_index_source(_campaign_id varchar(500))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _portfolio varchar(500);
DECLARE alias_array text[];
DECLARE alias_item text;
DECLARE alias_index int4 := 0;
BEGIN
	SELECT drop_date, "name"
	FROM staging.campaigns 
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id
	INTO _drop_date, _portfolio;

	INSERT INTO staging.supporting_campaign_placement_index_source(drop_date, campaign_id, portfolio, placement_index)
	SELECT DISTINCT _drop_date, _campaign_id, _portfolio, alias_placement_index 
	FROM staging.agency_click
	WHERE LENGTH(alias_placement_index) < 16 AND alias_placement_index <> 'browserview' AND alias_placement_index <> 'Refer a Friend'
	AND offer_1_lob_campaign_id = _campaign_id
	GROUP BY alias_placement_index
    ORDER BY alias_placement_index;
   
    UPDATE staging.supporting_campaign_placement_index_source
	SET index_source =  ARRAY_TO_STRING(ARRAY(SELECT DISTINCT alias_placement_index_source
	FROM staging.agency_click 
	WHERE staging.supporting_campaign_placement_index_source.campaign_id = staging.agency_click.offer_1_lob_campaign_id
	AND staging.supporting_campaign_placement_index_source.placement_index = staging.agency_click.alias_placement_index), ',')
	WHERE staging.supporting_campaign_placement_index_source.campaign_id = _campaign_id;

	alias_array := ARRAY(SELECT alias FROM staging.supporting_agency_click_source ORDER BY id);
	 
	FOREACH alias_item IN ARRAY alias_array
	LOOP
		UPDATE staging.supporting_campaign_placement_index_source
		SET index_source = REPLACE(index_source, alias_index::varchar(2), alias_item)
		WHERE campaign_id = _campaign_id;
		
		alias_index := alias_index + 1;
	 END LOOP;
	 

	RETURN '--Process is completed--';
END;
$function$
;