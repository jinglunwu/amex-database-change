CREATE OR REPLACE FUNCTION backup.supporting_highlights_calc_18v1umca()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE _sql TEXT;
	DECLARE _lounge_visits varchar(100);
	DECLARE _flights_booked varchar(100);
	DECLARE _transactions varchar(100);
	DECLARE _yes_date varchar(100);
	DECLARE _top_spend varchar(100);
	DECLARE _small_bus_roc varchar(100);
	DECLARE _saks_credit varchar(100);
	DECLARE _afc_credit varchar(100);
BEGIN

	_lounge_visits := 'OFFER_1_PERS_2';
	_flights_booked := 'OFFER_1_PERS_3';
	_transactions := 'OFFER_1_PERS_4';
	_yes_date := 'OFFER_1_PERS_10';
	_top_spend := 'OFFER_2_PERS_2';
	_small_bus_roc := 'OFFER_3_PERS_1';
	_saks_credit := 'OFFER_3_PERS_2';
	_afc_credit := 'OFFER_3_PERS_7';
	
	--Reset highlights_row for rerun this function...
	UPDATE backup.agency_sent_18V1UMCA SET highlights_row = '';
	
	--IF (@afc_credit >= 100) AND (@afc_credit <= 200) THEN SET @highlights_id = "D1" SET @highlights_row = Concat(@highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D1|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _afc_credit || ' = '''' THEN ''0'' ELSE ' || _afc_credit || ' END, ''999999999999'') BETWEEN 100 AND 200;';
	EXECUTE _sql;
	
	--IF (@afc_credit >= 50) AND (@afc_credit <= 99) THEN SET @highlights_id = "D3" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D3|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _afc_credit || ' = '''' THEN ''0'' ELSE ' || _afc_credit || ' END, ''999999999999'') BETWEEN 50 AND 99;';
	EXECUTE _sql;
	
	--IF (@saks_credit > 40) THEN SET @highlights_id = "D2" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D2|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _saks_credit || ' = '''' THEN ''0'' ELSE ' || _saks_credit || ' END, ''999999999999'') > 40;';
	EXECUTE _sql;
	
	--IF (@saks_credit >= 25) AND (@saks_credit <= 40) THEN SET @highlights_id = "D4" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D4|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _saks_credit || ' = '''' THEN ''0'' ELSE ' || _saks_credit || ' END, ''999999999999'') BETWEEN 25 AND 40;';
	EXECUTE _sql;		
	
	--IF (@flights_booked > 10) THEN SET @highlights_id = "D5" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D5|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _flights_booked || ' = '''' THEN ''0'' ELSE ' || _flights_booked || ' END, ''999999999999'') > 10;';
	EXECUTE _sql;
	
	--IF (@flights_booked >= 4) AND (@flights_booked <= 10) THEN SET @highlights_id = "D7" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D7|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _flights_booked || ' = '''' THEN ''0'' ELSE ' || _flights_booked || ' END, ''999999999999'') BETWEEN 4 AND 10;';
	EXECUTE _sql;
	
	--IF (@flights_booked >= 1) AND (@flights_booked <= 3) THEN SET @highlights_id = "D11" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D11|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _flights_booked || ' = '''' THEN ''0'' ELSE ' || _flights_booked || ' END, ''999999999999'') BETWEEN 1 AND 3;';
	EXECUTE _sql;
	
	--IF (@lounge_visits > 5) THEN SET @highlights_id = "D6" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D6|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _lounge_visits || ' = '''' THEN ''0'' ELSE ' || _lounge_visits || ' END, ''999999999999'') > 5;';
	EXECUTE _sql;
	
	--IF (@lounge_visits > 3) AND (@lounge_visits <= 5) THEN SET @highlights_id = "D8" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D8|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _lounge_visits || ' = '''' THEN ''0'' ELSE ' || _lounge_visits || ' END, ''999999999999'') BETWEEN 4 AND 5;';
	EXECUTE _sql;
	
	--IF (@lounge_visits >= 1) AND (@lounge_visits <= 3) THEN SET @highlights_id = "D10" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D10|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _lounge_visits || ' = '''' THEN ''0'' ELSE ' || _lounge_visits || ' END, ''999999999999'') BETWEEN 1 AND 3;';
	EXECUTE _sql;
	
	--IF (@transactions > 150) THEN SET @highlights_id = "D9" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D9|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _transactions || ' = '''' THEN ''0'' ELSE ' || _transactions || ' END, ''999999999999'') > 150;';
	EXECUTE _sql;
	
	--IF (@transactions >= 50) AND (@transactions <= 100) THEN SET @highlights_id = "D13" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D13|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _transactions || ' = '''' THEN ''0'' ELSE ' || _transactions || ' END, ''999999999999'') BETWEEN 50 AND 100;';
	EXECUTE _sql;	

    --IF NOT Empty(@top_spend) THEN SET @highlights_id = "D12" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF	
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D12|'' '
			'WHERE ' ||  _top_spend || ' IS NOT NULL AND ' ||  _top_spend || ' <> '''';';
	EXECUTE _sql;
	
	--IF (@small_bus_roc > 10) THEN SET @highlights_id = "D14" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_row = highlights_row || ''D14|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _small_bus_roc || ' = '''' THEN ''0'' ELSE ' || _small_bus_roc || ' END, ''999999999999'') > 10;';
	EXECUTE _sql;
	
	UPDATE backup.agency_sent_18V1UMCA SET highlights_row = SUBSTRING(highlights_row, 1, CHAR_LENGTH(highlights_row) - 1) WHERE highlights_row LIKE '%|';
	
	--IF (@yes_date == "YES") THEN SET @highlights_yes = "TRUE" SET @highlights_yes_id = "D19" ELSE ENDIF
	_sql := 'UPDATE backup.agency_sent_18V1UMCA '
	        'SET highlights_yes_id = ''D19'' '
			'WHERE ' || _yes_date || ' = ''YES'' ';
	EXECUTE _sql;

	--IF (Rowcount(@highlights_params) <= 3) THEN SET @highlights_id_1 = "D15" SET @highlights_id_2 = "D16" SET @highlights_id_3 = "D17" SET @highlights_id_4 = "D18" SET @highlights_id_5 = @highlights_yes_id
    --ELSEIF (Rowcount(@highlights_params) >= 4) THEN SET @highlights_id_1 = Field(Row(@highlights_params, 1), 1) SET @highlights_id_2 = Field(Row(@highlights_params, 2), 1)
	--SET @highlights_id_3 = Field(Row(@highlights_params, 3), 1) SET @highlights_id_4 = Field(Row(@highlights_params, 4), 1) SET @highlights_id_5 = @highlights_yes_id
    --ENDIF	
	UPDATE backup.agency_sent_18V1UMCA
	SET highlights_id_1 = 'D15', highlights_id_2 = 'D16', highlights_id_3 = 'D17', highlights_id_4 = 'D18', highlights_id_5 = highlights_yes_id
	WHERE staging.supporting_get_count_on_highlights(highlights_row) <= 3;
	
	UPDATE backup.agency_sent_18V1UMCA
	SET highlights_id_1 = SPLIT_PART(highlights_row, '|', 1), highlights_id_2 = SPLIT_PART(highlights_row, '|', 2), highlights_id_3 = SPLIT_PART(highlights_row, '|', 3), 
	highlights_id_4 = SPLIT_PART(highlights_row, '|', 4), highlights_id_5 = highlights_yes_id
	WHERE staging.supporting_get_count_on_highlights(highlights_row) >= 4;	
	
	--Get the highlights nunber
    TRUNCATE TABLE staging.supporting_cell_placement_impression_18V1UMCA;
   
    --insert highlights_id_1
    INSERT INTO staging.supporting_cell_placement_impression_18V1UMCA
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_1, COUNT(highlights_id_1) 
	FROM backup.agency_sent_18V1UMCA
	WHERE highlights_id_1 <> ''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_1;

	--insert highlights_id_2
	INSERT INTO staging.supporting_cell_placement_impression_18V1UMCA
    SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_2, COUNT(highlights_id_2) 
	FROM backup.agency_sent_18V1UMCA
	WHERE highlights_id_2 <>''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_2
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18V1UMCA.counts + excluded.counts;

	--insert highlights_id_3
	INSERT INTO staging.supporting_cell_placement_impression_18V1UMCA
    SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_3, COUNT(highlights_id_3) 
	FROM backup.agency_sent_18V1UMCA
	WHERE highlights_id_3 <>''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_3
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18V1UMCA.counts + excluded.counts;

	--insert highlights_id_4
	INSERT INTO staging.supporting_cell_placement_impression_18V1UMCA
    SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_4, COUNT(highlights_id_4) 
	FROM backup.agency_sent_18V1UMCA
	WHERE highlights_id_4 <>''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_4
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18V1UMCA.counts + excluded.counts;
	
	--insert highlights_id_5
	INSERT INTO staging.supporting_cell_placement_impression_18V1UMCA
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_5, COUNT(highlights_id_5) 
	FROM backup.agency_sent_18V1UMCA
	WHERE highlights_id_5 <>''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_5
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18V1UMCA.counts + excluded.counts;
	
	RETURN 'Function has been executed successfully!';	
END;
$function$
;
