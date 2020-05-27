CREATE OR REPLACE FUNCTION staging.validate_pzn_with_agency_sent_map(_campaign_id varchar(500))
RETURNS text
LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _portfolio varchar(100);
DECLARE _placement_index varchar(50);
DECLARE array_placement_index text[];
DECLARE _pzn varchar(50);
DECLARE _pzns text[]; 
DECLARE _sql text;
DECLARE count_num int4;
BEGIN
	SELECT drop_date, name FROM staging.campaigns 
	INNER JOIN staging.portfolios
	ON staging.campaigns.portfolio_id = staging.portfolios.id 
	WHERE staging.campaigns.id = _campaign_id
    INTO _drop_date, _portfolio;
   
    array_placement_index := ARRAY(SELECT "index" FROM staging.placements WHERE campaign_id = _campaign_id ORDER BY "index");
   
    _pzns := ARRAY(SELECT field FROM staging.personalizations WHERE field NOT IN (SELECT field FROM staging.agency_sent_map WHERE campaign_id = _campaign_id) ORDER BY field);
   
    FOREACH _placement_index IN ARRAY array_placement_index
    LOOP    	
    	FOREACH _pzn IN ARRAY _pzns
    	LOOP
    	
    		_sql := 'SELECT COUNT(*) FROM staging.agency_sent WHERE offer_1_lob_campaign_id = ''' || _campaign_id || ''' AND ' || _pzn || ' = ''' || _placement_index || '''' ;  
    		EXECUTE _sql INTO count_num;
    		
    		IF count_num > 0 THEN
    			INSERT INTO staging.validate_pzn_with_agency_sent_map VALUES(_drop_date, _campaign_id, _portfolio, _placement_index, _pzn);
    		END IF;
    	
    	END LOOP;    
    END LOOP;
    
    RETURN '--validation is completed';
	
END;
$function$
;