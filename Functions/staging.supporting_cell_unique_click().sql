CREATE OR REPLACE FUNCTION staging.supporting_cell_unique_click()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	TRUNCATE TABLE staging.supporting_cell_unique_click;
	
	INSERT INTO staging.supporting_cell_unique_click(cell_id, clicks)
	SELECT offer_1_cell_id,  COUNT(*) 
	FROM staging.agency_click_unique_cell_based
	WHERE offer_1_cell_id IS NOT NULL
	GROUP BY offer_1_cell_id 
    ORDER BY offer_1_cell_id ;
    
    UPDATE staging.supporting_cell_based_report
	SET unique_clicks = staging.supporting_cell_unique_click.clicks
	FROM staging.supporting_cell_unique_click
	WHERE staging.supporting_cell_based_report.cell_id = staging.supporting_cell_unique_click.cell_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
