CREATE OR REPLACE FUNCTION staging.agency_click_unique_cell_placement_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	TRUNCATE TABLE staging.agency_click_unique_cell_placement_based; 
	
	INSERT INTO staging.agency_click_unique_cell_placement_based 
	SELECT encrypted_email, MAX(offer_1_lob_campaign_id), offer_1_cell_id, MAX(alias_order), MAX(alias_section), MAX(alias_slot), 
	alias_placement_index, MAX(alias_cta)
	FROM staging.agency_click
	WHERE encrypted_email <> '' AND offer_1_cell_id <> ''
	GROUP BY encrypted_email, offer_1_cell_id, alias_placement_index;	 
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;