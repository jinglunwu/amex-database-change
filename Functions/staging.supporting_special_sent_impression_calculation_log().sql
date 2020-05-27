CREATE OR REPLACE FUNCTION staging.supporting_special_sent_impression_calculation_log()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE _parent_index_arr text[];
DECLARE _parent_index text;
DECLARE _child_index_arr text[];
DECLARE _child_index text;
DECLARE _parent_index_string text := '';
DECLARE sql_script text;
DECLARE cur_sent_impression_cal CURSOR FOR
SELECT cell_id, placement_index, sent_impression 
FROM staging.supporting_special_sent_impression_calculation_log;
DECLARE rec record;
DECLARE _sent_impression int4;
DECLARE _child_sent_impression int4;
BEGIN 
	TRUNCATE TABLE staging.supporting_special_sent_impression_calculation_log;
	
	_parent_index_arr := ARRAY(SELECT DISTINCT parent_index FROM staging.supporting_special_sent_impression_calculation_lookup);	
	
	sql_script := 'INSERT INTO staging.supporting_special_sent_impression_calculation_log(cell_id, placement_index, sent_impression) ' ||
	'SELECT cell_id, alias_placement_index, 0 ' ||
	'FROM staging.supporting_click_cell_placement_index_based_report ' ||
	'WHERE alias_placement_index IN (';
	
	FOREACH _parent_index IN ARRAY _parent_index_arr
	LOOP
		sql_script = sql_script || '''' || _parent_index || ''',';
	END LOOP;
	
	sql_script = TRIM(TRAILING ',' FROM sql_script);
	
	sql_script = sql_script || ') ' ||
	'ORDER BY cell_id, alias_placement_index;';
	
	EXECUTE sql_script;

	FOR rec IN cur_sent_impression_cal
	LOOP
		_child_index_arr := ARRAY(SELECT child_index FROM staging.supporting_special_sent_impression_calculation_lookup WHERE parent_index = rec.placement_index);
		_sent_impression := rec.sent_impression;
		
		FOREACH _child_index IN ARRAY _child_index_arr 
		LOOP
			_child_sent_impression := (SELECT counts FROM staging.supporting_mi_open_cell_count WHERE cell_id = rec.cell_id AND placement_index = _child_index);
			_sent_impression := COALESCE(_sent_impression + _child_sent_impression, _sent_impression);			
		END LOOP;
		
		UPDATE staging.supporting_special_sent_impression_calculation_log
		SET sent_impression = _sent_impression
		WHERE cell_id = rec.cell_id AND placement_index = rec.placement_index;
		
	END LOOP;	
	
	UPDATE staging.supporting_click_cell_placement_index_based_report AS report
	SET sent_impression = sent_impression_cal.sent_impression
	FROM staging.supporting_special_sent_impression_calculation_log AS sent_impression_cal
	WHERE report.cell_id = sent_impression_cal.cell_id AND report.alias_placement_index = sent_impression_cal.placement_index
	AND sent_impression_cal.sent_impression <> 0;
		
END;
$function$
;