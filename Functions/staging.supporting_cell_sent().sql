CREATE OR REPLACE FUNCTION staging.supporting_cell_sent()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	TRUNCATE TABLE staging.supporting_cell_based_report;
	
	INSERT INTO staging.supporting_cell_based_report(cell_id, sents)
	SELECT offer_1_cell_id, COUNT(*)
	FROM staging.agency_sent
	WHERE offer_1_cell_id IS NOT NULL
	GROUP BY offer_1_cell_id
	ORDER BY offer_1_cell_id;	

	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
