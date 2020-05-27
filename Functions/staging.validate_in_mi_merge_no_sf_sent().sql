CREATE OR REPLACE FUNCTION staging.validate_in_mi_merge_no_sf_sent(_campaign_id varchar(100))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	INSERT INTO staging.validate_in_mi_merge_no_sf_sent
	SELECT DISTINCT sf_campaign_id, campaign_id, mi_u
	FROM staging.mi_event_log_click_open_merge
	LEFT OUTER JOIN staging.agency_sent
	ON staging.mi_event_log_click_open_merge.sf_campaign_id = staging.agency_sent.offer_1_lob_campaign_id AND staging.mi_event_log_click_open_merge.mi_u = staging.agency_sent.encrypted_email
	WHERE staging.mi_event_log_click_open_merge.sf_campaign_id = TRIM(_campaign_id) AND LENGTH(staging.mi_event_log_click_open_merge.mi_u) >= 40 AND staging.agency_sent.encrypted_email IS NULL;

	RETURN '--Validation is completed--';
END;
$function$
;