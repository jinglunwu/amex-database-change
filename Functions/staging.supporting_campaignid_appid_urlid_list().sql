CREATE OR REPLACE FUNCTION staging.supporting_campaignid_appid_urlid_list()
 RETURNS TABLE(_drop_date date, _campaign_id text, _mi_campaign_id character varying, _app_id character varying, url_id text)
 LANGUAGE plpgsql
AS $function$
BEGIN
	 RETURN QUERY
	 SELECT MAX(drop_date), MAX(id), campaign_id, app_id, SUBSTRING(MAX(url), '/p/rp/(.*)/url.*')
	 FROM staging.mi_event_log_click_open_merge
	 INNER JOIN staging.campaigns
	 ON staging.mi_event_log_click_open_merge.sf_campaign_id = staging.campaigns.id
	 GROUP BY campaign_id, app_id
	 ORDER BY MAX(drop_date), campaign_id, app_id;
END;
$function$
;
