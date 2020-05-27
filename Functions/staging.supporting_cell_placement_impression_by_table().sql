CREATE OR REPLACE FUNCTION staging.supporting_cell_placement_impression_by_table(table_name character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
DECLARE _sql TEXT;
BEGIN
	
	_sql := 'INSERT INTO staging.supporting_cell_placement_impression_report(campaign_id, cell_id, placement_index, counts) '
	       'SELECT campaign_id, cell_id, placement_index, counts ' 
	       'FROM ' || table_name || ' '
	       'ON CONFLICT (campaign_id, cell_id, placement_index) '
	       'DO UPDATE SET counts = staging.supporting_cell_placement_impression_report.counts + excluded.counts;';
	      
	EXECUTE _sql;      

	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
