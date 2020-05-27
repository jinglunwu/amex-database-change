CREATE OR REPLACE FUNCTION staging.supporting_2019_hightlights_updates()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
	-- Highlights Platinum 18V1UMCA
	UPDATE staging.supporting_click_cell_placement_index_based_report
	SET sent_impression = counts
	FROM staging.supporting_cell_placement_impression_18v1umca 
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_placement_impression_18v1umca.cell_id AND
	staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_cell_placement_impression_18v1umca.placement_index;

	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	USING (SELECT t.cell_id, t.placement_index 
	FROM staging.supporting_cell_placement_impression_18v1umca t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = open_only.cell_id
	AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = open_only.placement_index;

	INSERT INTO staging.supporting_click_cell_placement_index_based_report
	SELECT open_only.cell_id, '', alias_section, '',  open_only.placement_index, '', 0, 0,  open_only.counts, NULL FROM
	(SELECT t.campaign_id, t.cell_id, t.placement_index, t.counts 
	FROM staging.supporting_cell_placement_impression_18v1umca t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	INNER JOIN staging.placements
	ON open_only.campaign_id  = staging.placements.campaign_id AND open_only.placement_index = staging.placements.index;

	-- Highlights Prop Leading 18T3UMCA
	UPDATE staging.supporting_click_cell_placement_index_based_report
	SET sent_impression = counts
	FROM staging.supporting_cell_placement_impression_18T3UMCA
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_placement_impression_18T3UMCA.cell_id AND
	staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_cell_placement_impression_18T3UMCA.placement_index;

	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	USING (SELECT t.cell_id, t.placement_index 
	FROM staging.supporting_cell_placement_impression_18T3UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = open_only.cell_id
	AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = open_only.placement_index;

	INSERT INTO staging.supporting_click_cell_placement_index_based_report
	SELECT open_only.cell_id, '', alias_section, '',  open_only.placement_index, '', 0, 0,  open_only.counts, NULL FROM
	(SELECT t.campaign_id, t.cell_id, t.placement_index, t.counts 
	FROM staging.supporting_cell_placement_impression_18T3UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	INNER JOIN staging.placements
	ON open_only.campaign_id  = staging.placements.campaign_id AND open_only.placement_index = staging.placements.index;

	-- Highlights Charge 18R4UMCA
	UPDATE staging.supporting_click_cell_placement_index_based_report
	SET sent_impression = counts
	FROM staging.supporting_cell_placement_impression_18R4UMCA
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_placement_impression_18R4UMCA.cell_id AND
	staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_cell_placement_impression_18R4UMCA.placement_index;

	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	USING (SELECT t.cell_id, t.placement_index 
	FROM staging.supporting_cell_placement_impression_18R4UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = open_only.cell_id
	AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = open_only.placement_index;

	INSERT INTO staging.supporting_click_cell_placement_index_based_report
	SELECT open_only.cell_id, '', alias_section, '',  open_only.placement_index, '', 0, 0,  open_only.counts, NULL FROM
	(SELECT t.campaign_id, t.cell_id, t.placement_index, t.counts 
	FROM staging.supporting_cell_placement_impression_18R4UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	INNER JOIN staging.placements
	ON open_only.campaign_id  = staging.placements.campaign_id AND open_only.placement_index = staging.placements.index;

	-- Highlights Cobrand 18Q2UMCA
	UPDATE staging.supporting_click_cell_placement_index_based_report
	SET sent_impression = counts
	FROM staging.supporting_cell_placement_impression_18Q2UMCA
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_placement_impression_18Q2UMCA.cell_id AND
	staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_cell_placement_impression_18Q2UMCA.placement_index;

	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	USING (SELECT t.cell_id, t.placement_index 
	FROM staging.supporting_cell_placement_impression_18Q2UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = open_only.cell_id
	AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = open_only.placement_index;

	INSERT INTO staging.supporting_click_cell_placement_index_based_report
	SELECT open_only.cell_id, '', alias_section, '',  open_only.placement_index, '', 0, 0,  open_only.counts, NULL FROM
	(SELECT t.campaign_id, t.cell_id, t.placement_index, t.counts 
	FROM staging.supporting_cell_placement_impression_18Q2UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	INNER JOIN staging.placements
	ON open_only.campaign_id  = staging.placements.campaign_id AND open_only.placement_index = staging.placements.index;
	
	-- Highlights Centurion 18W1UMCA
	UPDATE staging.supporting_click_cell_placement_index_based_report
	SET sent_impression = counts
	FROM staging.supporting_cell_placement_impression_18W1UMCA
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = staging.supporting_cell_placement_impression_18W1UMCA.cell_id AND
	staging.supporting_click_cell_placement_index_based_report.alias_placement_index = staging.supporting_cell_placement_impression_18W1UMCA.placement_index;

	DELETE FROM staging.supporting_click_cell_placement_index_based_report
	USING (SELECT t.cell_id, t.placement_index 
	FROM staging.supporting_cell_placement_impression_18W1UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	WHERE staging.supporting_click_cell_placement_index_based_report.cell_id = open_only.cell_id
	AND staging.supporting_click_cell_placement_index_based_report.alias_placement_index = open_only.placement_index;

	INSERT INTO staging.supporting_click_cell_placement_index_based_report
	SELECT open_only.cell_id, '', alias_section, '',  open_only.placement_index, '', 0, 0,  open_only.counts, NULL FROM
	(SELECT t.campaign_id, t.cell_id, t.placement_index, t.counts 
	FROM staging.supporting_cell_placement_impression_18W1UMCA t 
	LEFT JOIN staging.view_click_cell_placement_report v 
	ON t.campaign_id = v.campaign_id AND t.cell_id = v.cell_id AND t.placement_index = v.alias_placement_index
	WHERE v.campaign_id IS NULL) AS open_only
	INNER JOIN staging.placements
	ON open_only.campaign_id  = staging.placements.campaign_id AND open_only.placement_index = staging.placements.index;
	
END;
$function$
;
