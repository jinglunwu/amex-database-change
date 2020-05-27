CREATE OR REPLACE FUNCTION staging.supporting_click_cell_placement_sent_impression()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	--Add the 201907_H1MM_sent_impression || 2019-08-06
	PERFORM staging.supporting_201907_H1MM_sent_impression();
	
    UPDATE staging.supporting_click_cell_placement_index_based_report
    SET  sent_impression = staging.supporting_cell_placement_impression_report.counts
    FROM staging.supporting_cell_placement_impression_report
    WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_placement_impression_report.cell_id 
    AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_cell_placement_impression_report.placement_index;
	
	--Add the special sent impression for PRM, MCL and MMS || 2020-03-31
	PERFORM staging.supporting_special_sent_impression_calculation_log();
	
    UPDATE staging.supporting_click_cell_placement_index_based_report
    SET sent_impression = staging.supporting_cell_based_report.sents
    FROM staging.supporting_cell_based_report
    WHERE (sent_impression IS NULL OR sent_impression = 0)
    AND LEFT(staging.supporting_click_cell_placement_index_based_report.alias_placement_index, 1) = 'P'
    AND staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_based_report.cell_id;
   
    PERFORM staging.supporting_2019_hightlights_updates();
   
    --Add the 2019 Febuary mini module updates || 2019-07-03
    PERFORM staging.supporting_201902_mini_module_updates();
   
    --Add the Programmatic Impression Inheritance || 2019-10-30
    PERFORM staging.supporting_programmatic_impression_inheritance();
    
	GET DIAGNOSTICS r_row_count = ROW_COUNT;	
	
	RETURN r_row_count;
END;
$function$
;