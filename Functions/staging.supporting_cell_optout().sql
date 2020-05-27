CREATE OR REPLACE FUNCTION staging.supporting_cell_optout()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	TRUNCATE TABLE staging.supporting_cell_optout;
	
	INSERT INTO staging.supporting_cell_optout(cell_id, optouts)
	SELECT offer_1_cell_id,  COUNT(*) 
	FROM staging.agency_optout_unique
	WHERE offer_1_cell_id IS NOT NULL
	GROUP BY offer_1_cell_id 
    ORDER BY offer_1_cell_id ;
    
    UPDATE staging.supporting_cell_based_report
	SET optouts = staging.supporting_cell_optout.optouts
	FROM staging.supporting_cell_optout
	WHERE staging.supporting_cell_based_report.cell_id = staging.supporting_cell_optout.cell_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
