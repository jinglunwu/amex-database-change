CREATE OR REPLACE FUNCTION staging.supporting_click_cell_placement_index()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
DECLARE _2222EPKH_M17_total int4;
DECLARE _2222EPKH_M17_unique int4;
DECLARE _2222EPKH_M4_total int4;
DECLARE _2222EPKH_M4_unique int4;
DECLARE _2222EPKJ_M17_total int4;
DECLARE _2222EPKJ_M17_unique int4;
DECLARE _2222EPKJ_M4_total int4;
DECLARE _2222EPKJ_M4_unique int4;
DECLARE _2222EPKK_M17_total int4;
DECLARE _2222EPKK_M17_unique int4;
DECLARE _2222EPKK_M4_total int4;
DECLARE _2222EPKK_M4_unique int4;
DECLARE _2222EPKN_M17_total int4;
DECLARE _2222EPKN_M17_unique int4;
DECLARE _2222EPKN_M4_total int4;
DECLARE _2222EPKN_M4_unique int4;
DECLARE _2222EPKR_M17_total int4;
DECLARE _2222EPKR_M17_unique int4;
DECLARE _2222EPKR_M4_total int4;
DECLARE _2222EPKR_M4_unique int4;
DECLARE _2222EPKS_M17_total int4;
DECLARE _2222EPKS_M17_unique int4;
DECLARE _2222EPKS_M4_total int4;
DECLARE _2222EPKS_M4_unique int4;
BEGIN
	TRUNCATE TABLE staging.supporting_click_cell_placement_index_based_report;
	
	TRUNCATE TABLE staging.supporting_cell_placement_total_click;
	
	INSERT INTO staging.supporting_click_cell_placement_index_based_report(cell_id, alias_order, alias_section, alias_slot,
	alias_placement_index, alias_cta, unique_clicks)
	SELECT offer_1_cell_id, MAX(alias_order), MAX(alias_section), MAX(alias_slot), alias_placement_index, 
	MAX(alias_cta), COUNT(*) 
	FROM staging.agency_click_unique_cell_placement_based
	WHERE offer_1_cell_id IS NOT NULL
	GROUP BY offer_1_cell_id, alias_placement_index
    ORDER BY offer_1_cell_id, alias_placement_index;   
    
    INSERT INTO staging.supporting_cell_placement_total_click(cell_id, alias_placement_index, total_clicks)
    SELECT offer_1_cell_id, alias_placement_index, COUNT(*)
    FROM staging.agency_click
    WHERE offer_1_cell_id IS NOT NULL
	GROUP BY offer_1_cell_id, alias_placement_index
    ORDER BY offer_1_cell_id, alias_placement_index;   
    
    UPDATE staging.supporting_click_cell_placement_index_based_report
    SET  total_clicks = staging.supporting_cell_placement_total_click.total_clicks
    FROM staging.supporting_cell_placement_total_click
    WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_placement_total_click.cell_id 
    AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_cell_placement_total_click.alias_placement_index;
    
    --Special replacement for Camoaign - 10I1UMCA ANd placement_index - W1 & W2
    UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET alias_section = 'masthead_body'
	FROM staging.cells, staging.campaigns 
	WHERE  staging.supporting_click_cell_placement_index_based_report.cell_id = staging.cells.id 
	AND staging.campaigns.id = staging.cells.campaign_id
	AND staging.campaigns.id = '10I1UMCA' AND (alias_placement_index = 'W1' OR alias_placement_index = 'W2');
	
	--Delete 2019 April Platinum M1 & M3 from the report | 2019-05-30
	DELETE FROM staging.supporting_click_cell_placement_index_based_report 
	USING staging.cells
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.cells.id AND 
	campaign_id = '1MV2UMCA' AND 
	staging.supporting_click_cell_placement_index_based_report.alias_placement_index IN ('M1', 'M3');
	
	--Delete cell_id 2222ENNA and Placement Index R6 1 unique click row | 2019-06-20
	DELETE FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222ENNA' AND alias_placement_index = 'R6';

	--Merge M17 to M4 before change M4 to M17 in the cell_id '2222EPKH', '2222EPKJ', '2222EPKK', '2222EPKN', '2222EPKR', '2222EPKS' | 2019-07-19
	
	_2222EPKH_M17_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKH' AND alias_placement_index = 'M17');
    _2222EPKH_M17_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKH' AND alias_placement_index = 'M17');
	_2222EPKH_M4_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKH' AND alias_placement_index = 'M4') + _2222EPKH_M17_total;
	_2222EPKH_M4_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKH' AND alias_placement_index = 'M4') + _2222EPKH_M17_unique;

	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET total_clicks = _2222EPKH_M4_total, unique_clicks = _2222EPKH_M4_unique 
	WHERE cell_id = '2222EPKH' AND alias_placement_index = 'M4';
	
	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	WHERE cell_id = '2222EPKH' AND alias_placement_index = 'M17';
	
	_2222EPKJ_M17_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKJ' AND alias_placement_index = 'M17');
    _2222EPKJ_M17_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKJ' AND alias_placement_index = 'M17');
	_2222EPKJ_M4_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKJ' AND alias_placement_index = 'M4') + _2222EPKJ_M17_total;
	_2222EPKJ_M4_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKJ' AND alias_placement_index = 'M4') + _2222EPKJ_M17_unique;

	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET total_clicks = _2222EPKJ_M4_total, unique_clicks = _2222EPKJ_M4_unique 
	WHERE cell_id = '2222EPKJ' AND alias_placement_index = 'M4';
	
	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	WHERE cell_id = '2222EPKJ' AND alias_placement_index = 'M17';
	
	_2222EPKK_M17_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKK' AND alias_placement_index = 'M17');
    _2222EPKK_M17_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKK' AND alias_placement_index = 'M17');
	_2222EPKK_M4_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKK' AND alias_placement_index = 'M4') + _2222EPKK_M17_total;
	_2222EPKK_M4_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKK' AND alias_placement_index = 'M4') + _2222EPKK_M17_unique;

	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET total_clicks = _2222EPKK_M4_total, unique_clicks = _2222EPKK_M4_unique 
	WHERE cell_id = '2222EPKK' AND alias_placement_index = 'M4';
	
	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	WHERE cell_id = '2222EPKK' AND alias_placement_index = 'M17';
	
	_2222EPKN_M17_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKN' AND alias_placement_index = 'M17');
    _2222EPKN_M17_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKN' AND alias_placement_index = 'M17');
	_2222EPKN_M4_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKN' AND alias_placement_index = 'M4') + _2222EPKN_M17_total;
	_2222EPKN_M4_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKN' AND alias_placement_index = 'M4') + _2222EPKN_M17_unique;

	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET total_clicks = _2222EPKN_M4_total, unique_clicks = _2222EPKN_M4_unique 
	WHERE cell_id = '2222EPKN' AND alias_placement_index = 'M4';
	
	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	WHERE cell_id = '2222EPKN' AND alias_placement_index = 'M17';

	_2222EPKR_M17_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKR' AND alias_placement_index = 'M17');
    _2222EPKR_M17_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKR' AND alias_placement_index = 'M17');
	_2222EPKR_M4_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKR' AND alias_placement_index = 'M4') + _2222EPKR_M17_total;
	_2222EPKR_M4_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKR' AND alias_placement_index = 'M4') + _2222EPKR_M17_unique;

	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET total_clicks = _2222EPKR_M4_total, unique_clicks = _2222EPKR_M4_unique 
	WHERE cell_id = '2222EPKR' AND alias_placement_index = 'M4';
	
	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	WHERE cell_id = '2222EPKR' AND alias_placement_index = 'M17';
	
	_2222EPKS_M17_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKS' AND alias_placement_index = 'M17');
    _2222EPKS_M17_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKS' AND alias_placement_index = 'M17');
	_2222EPKS_M4_total := (SELECT total_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKS' AND alias_placement_index = 'M4') + _2222EPKS_M17_total;
	_2222EPKS_M4_unique := (SELECT unique_clicks FROM staging.supporting_click_cell_placement_index_based_report 
	WHERE cell_id = '2222EPKS' AND alias_placement_index = 'M4') + _2222EPKS_M17_unique;

	UPDATE staging.supporting_click_cell_placement_index_based_report 
	SET total_clicks = _2222EPKS_M4_total, unique_clicks = _2222EPKS_M4_unique 
	WHERE cell_id = '2222EPKS' AND alias_placement_index = 'M4';
	
	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	WHERE cell_id = '2222EPKS' AND alias_placement_index = 'M17';
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;	
	
	RETURN r_row_count;
END;
$function$
;