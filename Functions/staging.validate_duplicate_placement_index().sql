CREATE OR REPLACE FUNCTION staging.validate_duplicate_placement_index()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	
	TRUNCATE TABLE staging.validate_duplicate_placement_index;

	INSERT INTO staging.validate_duplicate_placement_index(campaign_id, placement_index, row_count)
	SELECT  campaign_id, "index", COUNT(*) FROM staging.placements
	GROUP BY campaign_id, "index"
	HAVING COUNT(*) > 1
	ORDER BY campaign_id, "index";

	RETURN '--Check is completed';
	
END;
$function$
;