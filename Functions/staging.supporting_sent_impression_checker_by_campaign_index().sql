CREATE OR REPLACE FUNCTION staging.supporting_sent_impression_checker_by_campaign_index(_campaign_id character varying, _cell_id character varying, _placement_index character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE sql_script text := '';
DECLARE map_field_array text[];
DECLARE map_field text;
DECLARE row_count int4;
BEGIN
	map_field_array := ARRAY(SELECT field FROM staging.agency_sent_map WHERE campaign_id = _campaign_id);
	
	sql_script := 'SELECT COUNT(*) FROM staging.agency_sent WHERE offer_1_cell_id = ''' || _cell_id || ''' AND  ('; 

	FOREACH map_field IN ARRAY map_field_array
	LOOP
		sql_script := sql_script || map_field || ' = ''' ||  _placement_index || ''' OR ';	
	END LOOP;

	sql_script := TRIM(sql_script);
	sql_script := TRIM(TRAILING 'OR' FROM sql_script);

	sql_script := sql_script || ');';

	EXECUTE sql_script INTO row_count;	

	IF row_count > 0 THEN
		RETURN 'Yes';
	ELSE
		RETURN 'No';
	END IF;

END;
$function$
;
