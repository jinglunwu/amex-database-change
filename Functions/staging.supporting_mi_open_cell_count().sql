CREATE OR REPLACE FUNCTION staging.supporting_mi_open_cell_count()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	TRUNCATE TABLE staging.supporting_mi_open_cell_count;
	
	INSERT INTO staging.supporting_mi_open_cell_count
	SELECT cell_id, extra_data_code, count(*) 
	FROM staging.mi_event_log_open_unique_impression
	WHERE cell_id IS NOT NULL AND extra_data_code IS NOT NULL
	GROUP BY cell_id, extra_data_code;    
	
	UPDATE staging.supporting_click_cell_placement_index_based_report
	SET open_impression = staging.supporting_mi_open_cell_count.counts
	FROM staging.supporting_mi_open_cell_count
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_mi_open_cell_count.cell_id
	AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_mi_open_cell_count.placement_index;

	--Open impression change for RAF placement index
	UPDATE staging.supporting_click_cell_placement_index_based_report
	SET open_impression = staging.supporting_cell_based_report.unique_opens
	FROM staging.supporting_cell_based_report
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_based_report.cell_id
	AND alias_placement_index = 'RAF';
	
	--Adjust June Platinum placement indexes | 2019-07-19
	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET alias_placement_index = 'M17'
	FROM staging.cells, staging.campaigns
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.cells.id AND staging.cells.campaign_id = staging.campaigns.id AND
	campaign_id = '1Y31UMCA' AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = 'M4';
	
	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET alias_placement_index = 'M16a'
	FROM staging.cells, staging.campaigns
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.cells.id AND staging.cells.campaign_id = staging.campaigns.id AND
	campaign_id = '1Y31UMCA' AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = 'M3a';
	
	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET alias_placement_index = 'M16b'
	FROM staging.cells, staging.campaigns
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.cells.id AND staging.cells.campaign_id = staging.campaigns.id AND
	campaign_id = '1Y31UMCA' AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = 'M3b';
	
	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET alias_placement_index = 'M16fallback'
	FROM staging.cells, staging.campaigns
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.cells.id AND staging.cells.campaign_id = staging.campaigns.id AND
	campaign_id = '1Y31UMCA' AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = 'M4fallback';
	
	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET alias_placement_index = 'M4fallback'
	FROM staging.cells, staging.campaigns
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.cells.id AND staging.cells.campaign_id = staging.campaigns.id AND
	campaign_id = '1Y31UMCA' AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = 'M5fallback';
	
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;