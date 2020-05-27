CREATE OR REPLACE FUNCTION staging.supporting_cell_total_open()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	TRUNCATE TABLE staging.supporting_cell_total_open;
	
	INSERT INTO staging.supporting_cell_total_open(cell_id, opens)
	SELECT offer_1_cell_id,  COUNT(*) 
	FROM staging.agency_open 
	WHERE offer_1_cell_id IS NOT NULL
	GROUP  BY offer_1_cell_id 
    ORDER BY offer_1_cell_id;
    
    UPDATE staging.supporting_cell_based_report
	SET total_opens = staging.supporting_cell_total_open.opens
	FROM staging.supporting_cell_total_open
	WHERE staging.supporting_cell_based_report.cell_id = staging.supporting_cell_total_open.cell_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
