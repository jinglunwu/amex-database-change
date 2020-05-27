CREATE OR REPLACE FUNCTION backup.supporting_highlights_calc_18q2umca()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE _sql TEXT;
	DECLARE _top_spend varchar(100);
	DECLARE _fav_merch varchar(100);
	DECLARE _small_bus_roc varchar(100);
	DECLARE _transactions varchar(100);
BEGIN
	
	_top_spend := 'OFFER_2_PERS_1';
	_fav_merch := 'OFFER_2_PERS_2';
	_small_bus_roc := 'OFFER_3_PERS_1';
	_transactions := 'OFFER_3_PERS_7';
	
	--IF (@transactions > 5) THEN SET @highlights_id_1 = "D1" ELSE SET @highlights_id_1 = "D5" ENDIF
	_sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	        'SET highlights_id_1 = ''D1'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _transactions || ' = '''' THEN ''0'' ELSE ' || _transactions || ' END, ''999999999999'') > 5;';
	EXECUTE _sql;
	
	_sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	        'SET highlights_id_1 = ''D5'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _transactions || ' = '''' THEN ''0'' ELSE ' || _transactions || ' END, ''999999999999'') <= 5;';
	EXECUTE _sql;

	-- IF NOT Empty(@top_spend) THEN SET @highlights_id_2 = "D2" ELSE SET @highlights_id_2 = "D6" ENDIF
	_sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	        'SET highlights_id_2 = ''D2'' '
	        'WHERE ' || _top_spend || ' IS NOT NULL AND ' || _top_spend || ' <> '''';';
    EXECUTE _sql;
   
    _sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	        'SET highlights_id_2 = ''D6'' '
			'WHERE ' || _top_spend || ' IS NULL OR ' || _top_spend || ' = '''';';
    EXECUTE _sql;
    
	-- IF (@small_bus_roc > 5) THEN SET @highlights_id_3 = "D3" ELSE SET @highlights_id_3 = "D7" ENDIF
	_sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	        'SET highlights_id_3 = ''D3'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _small_bus_roc || ' = '''' THEN ''0'' ELSE ' || _small_bus_roc || ' END, ''999999999999'') > 5;';
	EXECUTE _sql;	

    _sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	       'SET highlights_id_3 = ''D7'' '
		   'WHERE TO_NUMBER(CASE WHEN ' || _small_bus_roc || ' = '''' THEN ''0'' ELSE ' || _small_bus_roc || ' END, ''999999999999'') <= 5;';
    EXECUTE _sql;
    
	--IF NOT Empty(@fav_merch) THEN SET @highlights_id_4 = "D4" ELSE SET @highlights_id_4 = "D8" ENDIF
	_sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	        'SET highlights_id_4 = ''D4'' '
	        'WHERE ' || _fav_merch || ' IS NOT NULL AND ' || _fav_merch || ' <> '''';';
    EXECUTE _sql;
   
    _sql := 'UPDATE backup.agency_sent_18Q2UMCA '
	        'SET highlights_id_4 = ''D8'' '
			'WHERE ' || _fav_merch || ' IS NULL OR ' || _fav_merch || ' = '''';';
    EXECUTE _sql;
   
    --Get the highlights nunber
	--Clear the table for rerun
    TRUNCATE TABLE staging.supporting_cell_placement_impression_18q2umca;
   
    INSERT INTO staging.supporting_cell_placement_impression_18q2umca
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_1, COUNT(highlights_id_1) 
	FROM backup.agency_sent_18Q2UMCA
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_1
    UNION
    SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_2, COUNT(highlights_id_2) 
	FROM backup.agency_sent_18Q2UMCA
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_2
    UNION
    SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_3, COUNT(highlights_id_3) 
	FROM backup.agency_sent_18Q2UMCA
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_3
    UNION
    SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_4, COUNT(highlights_id_4) 
	FROM backup.agency_sent_18Q2UMCA
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_4;

    RETURN 'Function has been executed successfully!';		
END;
$function$
;
