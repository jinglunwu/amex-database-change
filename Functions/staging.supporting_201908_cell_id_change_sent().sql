CREATE OR REPLACE FUNCTION staging.supporting_201908_cell_id_change_sent()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN	
	UPDATE staging.agency_sent
	SET offer_1_cell_id = offer_1_cell_id || '_NYC' 
	WHERE offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA') AND
	OFFER_1_PERS_4 = 'NYC';
	
	RETURN '--Execution is completed--';
END;
$function$
;


 





 