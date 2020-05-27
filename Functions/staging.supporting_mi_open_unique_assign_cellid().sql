CREATE OR REPLACE FUNCTION staging.supporting_mi_open_unique_assign_cellid()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	UPDATE staging.mi_event_log_open_unique
	SET cell_id = staging.agency_sent.offer_1_cell_id
	FROM staging.agency_sent, staging.campaigns
	WHERE staging.mi_event_log_open_unique.mi_u = staging.agency_sent.encrypted_email
	AND staging.campaigns.id = staging.agency_sent.offer_1_lob_campaign_id
	AND staging.campaigns.mi_campaign_id = staging.mi_event_log_open_unique.campaign_id
	AND staging.mi_event_log_open_unique.cell_id IS NULL;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
