CREATE OR REPLACE FUNCTION staging.supporting_201908_cell_id_change_original_cell_id_copy()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN	
	--Add the original_cell_id column into the staging.agency_sent table before run this function	
	UPDATE staging.agency_sent 
	SET original_cell_id = offer_1_cell_id 
	WHERE offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA');
	
	--Add the original_cell_id column into the staging.agency_open table before run this function	
	UPDATE staging.agency_open 
	SET original_cell_id = offer_1_cell_id 
	WHERE offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA');
	
	--Add the original_cell_id column into the staging.agency_click table before run this function	
	UPDATE staging.agency_click 
	SET original_cell_id = offer_1_cell_id 
	WHERE offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA');
	
	--Add the original_cell_id column into the staging.agency_bounce table before run this function
	UPDATE staging.agency_bounce 
	SET original_cell_id = offer_1_cell_id 
	WHERE offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA');
	
	--Add the original_cell_id column into the staging.agency_bounce table before run this function	
	UPDATE staging.agency_optout 
	SET original_cell_id = offer_1_cell_id 
	WHERE offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA');
	
	--Add the original_cell_id column into the staging.agency_bounce table before run this function
	-- 28J1UMCA | 2812619
	-- 28S1UMCA | 2811936	
	UPDATE mi_event_log_open
	SET original_cell_id = cell_id 
	WHERE campaign_id IN ('2812619', '2811936');
	
	RETURN '--Execution is completed--';
END;
$function$
;


 





 