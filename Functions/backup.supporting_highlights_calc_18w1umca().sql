CREATE OR REPLACE FUNCTION backup.supporting_highlights_calc_18w1umca()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _highlights varchar(100) := 'D13';
BEGIN
	--IF (@yes_date == "YES") THEN
	----SET @highlights_id_3   = "D13"
	--ENDIF
	
	UPDATE backup.agency_sent_18w1umca
	SET highlights = 'D13'
	WHERE offer_1_pers_10 = 'YES';
	
	TRUNCATE TABLE staging.supporting_cell_placement_impression_18w1umca;
	
	INSERT INTO staging.supporting_cell_placement_impression_18w1umca
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, _highlights, COUNT(*)
	FROM backup.agency_sent_18w1umca
	WHERE highlights IS NOT NULL AND highlights <> ''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights;
	
	RETURN 'Function has been executed successfully!';	
END;
$function$
;
