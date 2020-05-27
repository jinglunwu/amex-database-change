CREATE OR REPLACE FUNCTION staging.validate_mi_opens_drop_during_merge(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _mi_campaign_id varchar(100);
DECLARE mi_unique_open_count int4;
DECLARE mi_open_merge_count int4;
DECLARE _merged_rate int4;
DECLARE mi_opens_dropped int4; 
DECLARE _dropped_rate int4;
BEGIN
	INSERT INTO staging.validate_mi_opens_drop_during_merge(drop_date, campaign_id, mi_campaign_id, portfolio)
	SELECT drop_date, staging.campaigns.id, mi_campaign_id, name FROM staging.campaigns
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id ;
	
	_mi_campaign_id := (SELECT mi_campaign_id FROM staging.campaigns WHERE id = _campaign_id);
	mi_unique_open_count := ( SELECT COUNT(*) FROM
    (SELECT campaign_id, extra_data_code, cell_id, mi_u 
    FROM staging.mi_event_log_open_unique 
    WHERE campaign_id = _mi_campaign_id
    GROUP BY campaign_id, extra_data_code, cell_id, mi_u
    ) AS tbl_mi_unique_open);
	mi_open_merge_count := (SELECT COUNT(*) FROM staging.mi_event_log_open_unique_impression WHERE campaign_id = _mi_campaign_id);
	_merged_rate := (mi_open_merge_count * 100) / mi_unique_open_count;
	mi_opens_dropped := mi_unique_open_count - mi_open_merge_count;

	_dropped_rate := 100 - _merged_rate;	

	UPDATE staging.validate_mi_opens_drop_during_merge 
    SET mi_opens = mi_unique_open_count, mi_opens_merged = mi_open_merge_count, merged_rate = _merged_rate || '%', 
    mi_opens_droped = mi_opens_dropped, dropped_rate = _dropped_rate || '%'
    WHERE campaign_id = _campaign_id;
	

	RETURN '--Check is completed';
END;
$function$
;


 