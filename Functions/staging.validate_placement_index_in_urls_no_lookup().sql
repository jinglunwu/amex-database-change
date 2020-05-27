CREATE OR REPLACE FUNCTION staging.validate_placement_index_in_urls_no_lookup(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	INSERT INTO staging.validate_placement_index_in_urls_no_lookup
	SELECT MIN(staging.campaigns.drop_date), staging.campaigns.id, MIN(staging.portfolios.name), staging.urls.alias_placement_index
	FROM staging.urls
	INNER JOIN staging.campaigns ON staging.urls.campaign_id = staging.campaigns.mi_campaign_id
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	LEFT OUTER JOIN staging.placements ON staging.urls.alias_placement_index = staging.placements."index" AND staging.campaigns.id = staging.placements.campaign_id
	WHERE staging.urls.campaign_id IS NOT NULL AND staging.urls.Campaign_id <> '' AND
	staging.placements."index" IS NULL AND staging.urls.alias_placement_index <> '' AND 
	staging.campaigns.id = _campaign_id	
	GROUP BY staging.campaigns.id, staging.urls.alias_placement_index
	ORDER BY MIN(staging.campaigns.drop_date), staging.campaigns.id, staging.urls.alias_placement_index;
	
	RETURN '--Check is completed';
END;
$function$
;