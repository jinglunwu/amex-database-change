CREATE OR REPLACE FUNCTION staging.supporting_programmatic_impression_inheritance()
 RETURNS void
 LANGUAGE plpgsql 
AS $function$
BEGIN
	TRUNCATE TABLE staging.supporting_programmatic_impression_inheritance;
	
	--Insert into Mini modules (placements) + Recommender Rails with 0 Sent Impressions
	INSERT INTO staging.supporting_programmatic_impression_inheritance(cell_id, placement_index, parent_placement_index, sent_impression)
	SELECT cell_id, alias_placement_index, SUBSTRING(alias_placement_index, '^([HWN]\d{1,2})[Mm](\d{1,2})?$'), 0
	FROM staging.supporting_click_cell_placement_index_based_report
	WHERE alias_placement_index ~ '^([HWN]\d{1,2})[Mm](\d{1,2})?$' 
	AND (sent_impression IS NULL OR sent_impression = 0);
	
	--Insert into Mini modules (MC) & Static OTR with 0 Sent Impressions
	INSERT INTO staging.supporting_programmatic_impression_inheritance(cell_id, placement_index, parent_placement_index, sent_impression)
	SELECT cell_id, alias_placement_index, 'N/A', 0 
	FROM staging.supporting_click_cell_placement_index_based_report
	WHERE (alias_placement_index ~ '^MC[Mm](\d{1,2})?$' OR alias_placement_index ~ '^SR\d{1,2}[Mm](\d{1,2})?$') 
	AND (sent_impression IS NULL OR sent_impression = 0);

	--Update the sent_impression for Mini modules (placements) + Recommender Rails
	UPDATE staging.supporting_programmatic_impression_inheritance AS impression_inheritance
	SET sent_impression = placement_report.sent_impression
	FROM staging.supporting_click_cell_placement_index_based_report AS placement_report
	WHERE impression_inheritance.cell_id = placement_report.cell_id
	AND impression_inheritance.parent_placement_index = placement_report.alias_placement_index
	AND impression_inheritance.parent_placement_index <> 'N/A'; 
	
	--Update the sent_impression for Mini modules (MC) & Static OTR
	UPDATE staging.supporting_programmatic_impression_inheritance AS impression_inheritance
	SET sent_impression = cell_report.unique_opens
	FROM staging.supporting_cell_based_report AS cell_report
	WHERE impression_inheritance.cell_id = cell_report.cell_id
	AND impression_inheritance.parent_placement_index = 'N/A';

	--Update the final report using staging.supporting_programmatic_impression_inheritance table
	UPDATE staging.supporting_click_cell_placement_index_based_report AS placement_report
	SET sent_impression = impression_inheritance.sent_impression
	FROM staging.supporting_programmatic_impression_inheritance AS impression_inheritance
	WHERE placement_report.cell_id = impression_inheritance.cell_id
	AND placement_report.alias_placement_index = impression_inheritance.placement_index;	
END;
$function$
; 


 
