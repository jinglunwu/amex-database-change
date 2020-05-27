CREATE OR REPLACE FUNCTION staging.supporting_cell_placement_impression(start_id bigint, end_id bigint, table_insert character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
_field_cursor refcursor;
_sql TEXT;
_campaign_id varchar(100);
_field varchar(100);
_insert_time int4;
_row_count int4;
_running_result varchar(500);
BEGIN
	_insert_time := 0;

	_running_result := 'This function is running successfully.';
	
	_sql := 'SELECT campaign_id, field '
	'FROM staging.agency_sent '
	'INNER JOIN staging.agency_sent_map ' 
	'ON staging.agency_sent.offer_1_lob_campaign_id = staging.agency_sent_map.campaign_id '
	'WHERE campaign_id IN (''39L1UMCA'') AND id > ' || start_id || ' AND id <= ' || end_id || ' '
	'GROUP BY campaign_id, field '
	'ORDER BY campaign_id, field;';
	
	OPEN _field_cursor FOR EXECUTE(_sql);

	LOOP
		FETCH _field_cursor INTO _campaign_id, _field;
	
		IF NOT FOUND THEN
			EXIT;
		END IF;
		
		IF _insert_time = 0 THEN
			_sql := 'SELECT COUNT(*) FROM ' || table_insert || ';';
			EXECUTE _sql INTO _row_count;
			
			
			IF _row_count > 0 THEN
				_running_result := 'ERROR: Table has data already, so please use another table and try again.';
				EXIT;
			END IF;		
		END IF;
	
	
		
	 	_sql := 'INSERT INTO ' || table_insert || ' '
	         	'SELECT MAX(offer_1_lob_campaign_id) AS campaign_id, offer_1_cell_id AS cell_id, ' || _field || ' AS placement_index, COUNT(*) AS counts '
	         	'FROM staging.agency_sent '
			 	'WHERE offer_1_lob_campaign_id = ''' || _campaign_id || ''' '
			 	'AND id > ' || start_id || ' AND id <= ' || end_id || ' '
			 	'AND ' || _field || ' IN (SELECT "index" FROM staging.placements WHERE campaign_id = ''' || _campaign_id || ''') '
			 	'GROUP BY offer_1_cell_id, ' || _field || ';';
		EXECUTE _sql; 
	
		 _insert_time =  _insert_time + 1;
			
	END LOOP;

	CLOSE _field_cursor;


	RETURN _running_result;
	
END;
$function$
;
