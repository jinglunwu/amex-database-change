CREATE OR REPLACE FUNCTION staging.validate_sf_clicks_no_mi_click_open_merge(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _mi_campaign_id varchar(100);
DECLARE _clicks_count int4;
DECLARE _clicks_matched int4;
DECLARE _matched_rate  int4;
DECLARE _click_unmatched int4; 
DECLARE _unmatched_rate int4;
BEGIN
	INSERT INTO staging.validate_sf_clicks_no_mi_click_open_merge(drop_date, campaign_id, mi_campaign_id, portfolio)
	SELECT drop_date, staging.campaigns.id, mi_campaign_id,  name FROM staging.campaigns
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id ;
	
	_mi_campaign_id := (SELECT mi_campaign_id FROM staging.campaigns WHERE id = _campaign_id);
	_clicks_count :=  (SELECT COUNT(*) FROM (SELECT COUNT(*) FROM staging.agency_click_unique_cell_based WHERE offer_1_lob_campaign_id = _campaign_id GROUP BY offer_1_lob_campaign_id, encrypted_email) AS temp);
	_clicks_matched :=  (SELECT count(*)
	FROM staging.agency_click_unique_cell_based 
	INNER JOIN staging.campaigns ON staging.agency_click_unique_cell_based.offer_1_lob_campaign_id = staging.campaigns.id
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	INNER JOIN staging.mi_event_log_click_open_merge ON staging.agency_click_unique_cell_based.encrypted_email = staging.mi_event_log_click_open_merge.mi_u AND staging.mi_event_log_click_open_merge.campaign_id = staging.campaigns.mi_campaign_id
	WHERE offer_1_lob_campaign_id = _campaign_id);
	_matched_rate  := (_clicks_matched * 100) / _clicks_count;
	_click_unmatched := _clicks_count - _clicks_matched;
	_unmatched_rate := 100 - _matched_rate;
	

	UPDATE staging.validate_sf_clicks_no_mi_click_open_merge
    SET clicks_count = _clicks_count, clicks_matched = _clicks_matched,matched_rate = _matched_rate || '%', 
    click_unmatched = _click_unmatched, unmatched_rate = _unmatched_rate || '%'
    WHERE campaign_id = _campaign_id;
	

	RETURN '--Check is completed';
	
	
END;
$function$
;
