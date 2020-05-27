CREATE OR REPLACE FUNCTION staging.supporting_201907_H1MM_sent_impression()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN	
	DELETE FROM staging.supporting_cell_placement_impression_report WHERE campaign_id = '2521UMCA' AND placement_index IN ('H1a', 'H1b'); 
  
	INSERT INTO staging.supporting_cell_placement_impression_report
   	SELECT MAX(offer_1_lob_campaign_id), offer_1_cell_id, 'H1a', COUNT(*)  FROM staging.agency_sent 
   	WHERE offer_1_lob_campaign_id = '2521UMCA' AND offer_3_pers_6 = 'M16'
   	GROUP BY offer_1_cell_id;
   
   	INSERT INTO staging.supporting_cell_placement_impression_report
   	SELECT MAX(offer_1_lob_campaign_id), offer_1_cell_id, 'H1b', COUNT(*)  FROM staging.agency_sent 
   	WHERE offer_1_lob_campaign_id = '2521UMCA' AND offer_3_pers_6 = 'M17'
   	GROUP BY offer_1_cell_id;
END;
$function$
;