CREATE OR REPLACE FUNCTION staging.supporting_campaignid_appid_extradatacode_list()
 RETURNS TABLE(_campaign_id character varying, _mi_campaign_id character varying, _app_id character varying, _extra_data_code character varying, _drop_date date)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY
	SELECT DISTINCT staging.campaigns.id, campaign_id, app_id, extra_data_code, drop_date
	FROM staging.mi_event_log_click_open_merge
	INNER JOIN staging.campaigns
	ON staging.mi_event_log_click_open_merge.campaign_id = staging.campaigns.mi_campaign_id
    WHERE drop_date = '2019-04-01'
	ORDER BY drop_date, staging.campaigns.id, app_id, extra_data_code;
END;
$function$
;
