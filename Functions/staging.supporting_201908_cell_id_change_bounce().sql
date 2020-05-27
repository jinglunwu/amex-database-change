CREATE OR REPLACE FUNCTION staging.supporting_201908_cell_id_change_bounce()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN		
	UPDATE staging.agency_bounce
	SET offer_1_cell_id = staging.agency_bounce.offer_1_cell_id || '_NYC' 
	FROM staging.agency_sent
	WHERE staging.agency_bounce.offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA') AND
	staging.agency_bounce.encrypted_email = staging.agency_sent.encrypted_email AND 
	staging.agency_bounce.offer_1_lob_campaign_id = staging.agency_sent.offer_1_lob_campaign_id AND
	staging.agency_bounce.original_cell_id = staging.agency_sent.original_cell_id AND 
	staging.agency_sent.offer_1_cell_id LIKE '%_NYC';
	
	RETURN '--Execution is completed--';
END;
$function$
;


 





 