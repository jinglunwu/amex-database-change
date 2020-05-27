CREATE OR REPLACE FUNCTION staging.validate_mi_clicks_drop_during_merge(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _mi_campaign_id varchar(100);
DECLARE mi_unique_click_count int4;
DECLARE mi_click_merge_count int4;
DECLARE _merged_rate int4;
DECLARE mi_clicks_dropped int4; 
DECLARE _dropped_rate int4;
BEGIN
	INSERT INTO staging.validate_mi_clicks_drop_during_merge(drop_date, campaign_id, mi_campaign_id, portfolio)
	SELECT drop_date, staging.campaigns.id, mi_campaign_id,  name FROM staging.campaigns
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id ;
	
	_mi_campaign_id := (SELECT mi_campaign_id FROM staging.campaigns WHERE id = _campaign_id);
	mi_unique_click_count := (SELECT COUNT(1) FROM staging.mi_event_log_click_unique WHERE campaign_id = _mi_campaign_id);
	mi_click_merge_count :=  (SELECT COUNT(1) FROM (SELECT mi_u, app_id FROM staging.mi_event_log_click_open_merge WHERE campaign_id = _mi_campaign_id 
	GROUP BY mi_u, app_id) AS tem_merge);
	_merged_rate := (mi_click_merge_count * 100) / mi_unique_click_count;
	mi_clicks_dropped := mi_unique_click_count - mi_click_merge_count;

	_dropped_rate := 100 - _merged_rate;	

	UPDATE staging.validate_mi_clicks_drop_during_merge 
    SET mi_clicks = mi_unique_click_count, mi_clicks_merged = mi_click_merge_count, merged_rate = _merged_rate || '%', 
    mi_clicks_droped = mi_clicks_dropped, dropped_rate = _dropped_rate || '%'
    WHERE campaign_id = _campaign_id;
	

	RETURN '--Check is completed';
END;
$function$
;