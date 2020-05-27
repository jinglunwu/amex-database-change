CREATE OR REPLACE FUNCTION staging.supporting_201908_cell_id_change_mi_event_log_open()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN	
	-- 28J1UMCA | 2812619
	-- 28S1UMCA | 2811936
	
	--UPDATE 28J1UMCA | 2812619
	UPDATE staging.mi_event_log_open
	SET cell_id = staging.mi_event_log_open.cell_id || '_NYC' 
	FROM staging.agency_sent
	WHERE staging.mi_event_log_open.mi_u = staging.agency_sent.encrypted_email AND 
	staging.mi_event_log_open.campaign_id = '2812619' AND staging.agency_sent.offer_1_lob_campaign_id = '28J1UMCA' AND
	staging.mi_event_log_open.original_cell_id = staging.agency_sent.original_cell_id AND 
	staging.agency_sent.offer_1_cell_id LIKE '%_NYC';
	
	--UPDATE 28S1UMCA | 2811936
	UPDATE staging.mi_event_log_open
	SET cell_id = staging.mi_event_log_open.cell_id || '_NYC' 
	FROM staging.agency_sent
	WHERE staging.mi_event_log_open.mi_u = staging.agency_sent.encrypted_email AND 
	staging.mi_event_log_open.campaign_id = '2811936' AND staging.agency_sent.offer_1_lob_campaign_id = '28S1UMCA' AND
	staging.mi_event_log_open.original_cell_id = staging.agency_sent.original_cell_id AND 
	staging.agency_sent.offer_1_cell_id LIKE '%_NYC';
	
	RETURN '--Execution is completed--';
END;
$function$
;


 





 