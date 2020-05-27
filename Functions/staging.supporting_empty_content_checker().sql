CREATE OR REPLACE FUNCTION staging.supporting_empty_content_checker(campaign_ids character varying, truncate_flag character varying DEFAULT 'no'::character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _sql_script text := '';
DECLARE campaign_id_array text[];
DECLARE campaign_id text := '';
DECLARE campaign_id_list text := '';
DECLARE alias_array text[];
DECLARE alias_item text;
DECLARE alias_index int4 := 0;
BEGIN
	--Call this function
	--SELECT staging.supporting_empty_content_checker('    1SA1UMCA   ,    1SB1UMCA    ');
	
	--Check result
	--SELECT * FROM staging.supporting_empty_content_check ORDER BY drop_date, campaign_id, cell_id, alias_placement_index;
	
	IF LOWER(truncate_flag) = 'yes' THEN
		TRUNCATE TABLE staging.supporting_empty_content_check;
	END IF;	
	
	campaign_id_array = string_to_array(campaign_ids, ',');

	FOREACH campaign_id IN ARRAY campaign_id_array
	LOOP
		campaign_id_list := campaign_id_list || '''' || TRIM(campaign_id) || ''',' ;
	END LOOP;

	campaign_id_list :=   TRIM(TRAILING ',' FROM campaign_id_list); 

	_sql_script := 'INSERT INTO staging.supporting_empty_content_check(drop_date, campaign_id, portfolio, alias_placement_index, content_title, content_category, content_subcategory) ' ||
	 			   'SELECT MIN(drop_date), campaign_id, MIN(portfolio), alias_placement_index, MIN(content_title), MIN(content_category), MIN(content_subcategory) ' ||
	               'FROM staging.view_click_cell_placement_report ' ||
	               'WHERE campaign_id IN(' || campaign_id_list || ') AND ' ||
	               'LENGTH(alias_placement_index) <= 12 AND LOWER(alias_placement_index) <> ''browserview'' AND content_title IS NULL  ' ||
	               'GROUP BY campaign_id, alias_placement_index ' ||
				   'ORDER BY MIN(drop_date), campaign_id, alias_placement_index';
				   
	EXECUTE(_sql_script);			   
	
	UPDATE staging.supporting_empty_content_check
	SET placements_in_lookup_table = 'Yes'
	FROM staging.placements
	WHERE staging.supporting_empty_content_check.campaign_id = staging.placements.campaign_id
	AND staging.supporting_empty_content_check.alias_placement_index = staging.placements."index"; 
	
	UPDATE staging.supporting_empty_content_check
	SET placements_in_lookup_table = 'No'
	WHERE placements_in_lookup_table IS NULL OR placements_in_lookup_table = '';
	
	UPDATE staging.supporting_empty_content_check
	SET index_source =  ARRAY_TO_STRING(ARRAY(SELECT DISTINCT alias_placement_index_source
	FROM staging.agency_click 
	WHERE staging.supporting_empty_content_check.campaign_id = staging.agency_click.offer_1_lob_campaign_id AND staging.supporting_empty_content_check.alias_placement_index = staging.agency_click.alias_placement_index), ',');
	 
	 alias_array := ARRAY(SELECT alias FROM staging.supporting_agency_click_source ORDER BY id);
	 
	 FOREACH alias_item IN ARRAY alias_array
	 LOOP
		UPDATE staging.supporting_empty_content_check
		SET index_source = REPLACE(index_source, alias_index::varchar(2), alias_item);
		
		alias_index := alias_index + 1;
	 END LOOP;
	 
	RETURN '--CHECK is completed--';	 
END;
$function$
;