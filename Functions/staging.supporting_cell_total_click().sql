CREATE OR REPLACE FUNCTION staging.supporting_cell_total_click()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	TRUNCATE TABLE staging.supporting_cell_total_click;
	
	INSERT INTO staging.supporting_cell_total_click(cell_id, clicks)
	SELECT offer_1_cell_id,  COUNT(*) 
	FROM staging.agency_click
	WHERE offer_1_cell_id IS NOT NULL
	GROUP BY offer_1_cell_id 
    ORDER BY offer_1_cell_id ;
    
    UPDATE staging.supporting_cell_based_report
	SET total_clicks = staging.supporting_cell_total_click.clicks
	FROM staging.supporting_cell_total_click
	WHERE staging.supporting_cell_based_report.cell_id = staging.supporting_cell_total_click.cell_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
