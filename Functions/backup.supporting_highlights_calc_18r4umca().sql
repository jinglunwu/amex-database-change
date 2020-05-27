CREATE OR REPLACE FUNCTION backup.supporting_highlights_calc_18r4umca()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE _sql TEXT;
	DECLARE _top_spend varchar(500);
	DECLARE _flights_booked varchar(500);
	DECLARE _transactions varchar(500);
	DECLARE _yes_date varchar(500);
	DECLARE _small_bus_roc varchar(500);
	DECLARE _small_fav_day varchar(500);
	DECLARE _sup_roc varchar(500);
	DECLARE _fav_merch varchar(500);
	DECLARE _dining_credit varchar(500);
	DECLARE _afc_credit varchar(500);	
BEGIN
	_top_spend := 'OFFER_1_PERS_2';
	_flights_booked := 'OFFER_1_PERS_3';
	_transactions := 'OFFER_1_PERS_4';	
	_yes_date := 'OFFER_1_PERS_10';
	_small_bus_roc := 'OFFER_2_PERS_1';
	_small_fav_day := 'OFFER_2_PERS_2';
	_sup_roc := 'OFFER_2_PERS_5';
	_fav_merch := 'OFFER_3_PERS_1';
	_dining_credit := 'OFFER_3_PERS_2';
	_afc_credit := 'OFFER_3_PERS_7';
	
	--Reset highlights_row for rerun this function...
	UPDATE backup.agency_sent_18R4UMCA SET highlights_row = '';
	
	--IF (@transactions > 5) THEN SET @highlights_id = "D1" SET @highlights_row = Concat(@highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_row = highlights_row || ''D1|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _transactions || ' = '''' THEN ''0'' ELSE ' || _transactions || ' END, ''999999999999'') > 5;';
	EXECUTE _sql;
	
	--IF NOT Empty(@top_spend) THEN SET @highlights_id = "D2" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_row = highlights_row || ''D2|'' '
			'WHERE ' || _top_spend || ' IS NOT NULL AND ' || _top_spend || ' <> '''';';
	EXECUTE _sql;
	
	--IF (@dining_credit > 5) THEN SET @highlights_id = "D3" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_row = highlights_row || ''D3|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _dining_credit || ' = '''' THEN ''0'' ELSE ' || _dining_credit || ' END, ''999999999999'') > 5;';
	EXECUTE _sql;
	
	--IF (@afc_credit > 45) THEN SET @highlights_id = "D4" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_row = highlights_row || ''D4|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _afc_credit || ' = '''' THEN ''0'' ELSE ' || _afc_credit || ' END, ''999999999999'') > 45;';
	EXECUTE _sql;
	
	--IF NOT Empty(@fav_merch) THEN SET @highlights_id = "D5" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_row = highlights_row || ''D5|'' '
			'WHERE ' || _fav_merch || ' IS NOT NULL AND ' || _fav_merch || ' <> '''';';
	EXECUTE _sql;
	
	--IF (@flights_booked >= 2) THEN SET @highlights_id = "D6" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_row = highlights_row || ''D6|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _flights_booked || ' = '''' THEN ''0'' ELSE ' || _flights_booked || ' END, ''999999999999'') >= 2;';
	EXECUTE _sql;
	
	--IF (@sup_roc >= 2) THEN SET @highlights_id = "D7" SET @highlights_row = Concat(@highlights_row, @highlights_id, "|") ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_row = highlights_row || ''D7|'' '
			'WHERE TO_NUMBER(CASE WHEN ' || _sup_roc || ' = '''' THEN ''0'' ELSE ' || _sup_roc || ' END, ''999999999999'') >= 2;';
	EXECUTE _sql;
	
	--Remove the | from highlights_row
	UPDATE backup.agency_sent_18R4UMCA SET highlights_row = SUBSTRING(highlights_row, 1, CHAR_LENGTH(highlights_row) - 1) WHERE highlights_row LIKE '%|';
	
	--IF (@yes_date == "YES") THEN SET @highlights_yes_id = "D14" ELSE SET @highlights_yes_id = "D15" ENDIF
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_yes_id = ''D14'' '
			'WHERE ' || _yes_date || ' = ''YES'' ';
	EXECUTE _sql;
	
	_sql := 'UPDATE backup.agency_sent_18R4UMCA '
	        'SET highlights_yes_id = ''D15'' '
			'WHERE ' || _yes_date || ' <> ''YES'' ';
	EXECUTE _sql;
	
	--IF (Rowcount(@highlights_params) < 2) THEN SET @highlights_id_1 = "D8" SET @highlights_id_2 = "D9" 
	----IF (@card_nickname == "Gold") THEN SET @highlights_id_3 = "D12" SET @highlights_id_4 = "D13" 
	----ELSE SET @highlights_id_3 = "D10" SET @highlights_id_4 = "D11" ENDIF
	--SET @highlights_id_5   = @highlights_yes_id
	--ELSEIF (Rowcount(@highlights_params) == 2) THEN SET SET @highlights_id_1 = Field(Row(@highlights_params, 1), 1) SET @highlights_id_2 = Field(Row(@highlights_params, 2), 1) SET @highlights_id_5   = @highlights_yes_id
	--ELSEIF (Rowcount(@highlights_params) == 3) THEN SET @highlights_id_1 = Field(Row(@highlights_params, 1), 1) SET @highlights_id_2 = Field(Row(@highlights_params, 2), 1) SET @highlights_id_3 = Field(Row(@highlights_params, 3), 1) SET @highlights_id_4 = @highlights_yes_id
	--ELSEIF (Rowcount(@highlights_params) >= 4) THEN SET @highlights_id_1 = Field(Row(@highlights_params, 1), 1) SET @highlights_id_2 = Field(Row(@highlights_params, 2), 1) SET @highlights_id_3 = Field(Row(@highlights_params, 3), 1) SET @highlights_id_4 = Field(Row(@highlights_params, 4), 1) SET @highlights_id_5 = @highlights_yes_id
	--ENDIF
	
	UPDATE backup.agency_sent_18R4UMCA
	SET highlights_id_1 = 'D8', highlights_id_2 = 'D9', highlights_id_3 = 'D12', highlights_id_4 = 'D13', highlights_id_5 = highlights_yes_id
	WHERE staging.supporting_get_count_on_highlights(highlights_row) < 2 AND  offer_1_cell_id IN ('2222EHPH', '2222EHPJ');
	
	UPDATE backup.agency_sent_18R4UMCA
	SET highlights_id_1 = 'D8', highlights_id_2 = 'D9', highlights_id_3 = 'D10', highlights_id_4 = 'D11', highlights_id_5 = highlights_yes_id
	WHERE staging.supporting_get_count_on_highlights(highlights_row) < 2 AND  offer_1_cell_id NOT IN ('2222EHPH', '2222EHPJ');
	
	UPDATE backup.agency_sent_18R4UMCA
	SET highlights_id_1 = SPLIT_PART(highlights_row, '|', 1), highlights_id_2 = SPLIT_PART(highlights_row, '|', 2), highlights_id_5 = highlights_yes_id
	WHERE staging.supporting_get_count_on_highlights(highlights_row) = 2;
	
	UPDATE backup.agency_sent_18R4UMCA
	SET highlights_id_1 = SPLIT_PART(highlights_row, '|', 1), highlights_id_2 = SPLIT_PART(highlights_row, '|', 2), highlights_id_3 = SPLIT_PART(highlights_row, '|', 3), highlights_id_4 = highlights_yes_id
	WHERE staging.supporting_get_count_on_highlights(highlights_row) = 3;	
	
	UPDATE backup.agency_sent_18R4UMCA
	SET highlights_id_1 = SPLIT_PART(highlights_row, '|', 1), highlights_id_2 = SPLIT_PART(highlights_row, '|', 2), highlights_id_3 = SPLIT_PART(highlights_row, '|', 3), highlights_id_4 = SPLIT_PART(highlights_row, '|', 4), highlights_id_5 = highlights_yes_id
	WHERE staging.supporting_get_count_on_highlights(highlights_row) >= 4;	
	
	--Get the highlights nunber
	--Clear the table for rerun 
    TRUNCATE TABLE staging.supporting_cell_placement_impression_18R4UMCA;
	
	--insert highlights_id_1
    INSERT INTO staging.supporting_cell_placement_impression_18R4UMCA
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_1, COUNT(highlights_id_1) 
	FROM backup.agency_sent_18R4UMCA
	WHERE highlights_id_1 <> ''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_1;
	
	--insert highlights_id_2
    INSERT INTO staging.supporting_cell_placement_impression_18R4UMCA
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_2, COUNT(highlights_id_2) 
	FROM backup.agency_sent_18R4UMCA
	WHERE highlights_id_2 <> ''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_2
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18R4UMCA.counts + excluded.counts;
	
	--insert highlights_id_3
    INSERT INTO staging.supporting_cell_placement_impression_18R4UMCA
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_3, COUNT(highlights_id_3) 
	FROM backup.agency_sent_18R4UMCA
	WHERE highlights_id_3 <> ''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_3
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18R4UMCA.counts + excluded.counts;
	
	--insert highlights_id_4
    INSERT INTO staging.supporting_cell_placement_impression_18R4UMCA
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_4, COUNT(highlights_id_4) 
	FROM backup.agency_sent_18R4UMCA
	WHERE highlights_id_4 <> ''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_4
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18R4UMCA.counts + excluded.counts;
	
	--insert highlights_id_5
    INSERT INTO staging.supporting_cell_placement_impression_18R4UMCA
	SELECT offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_5, COUNT(highlights_id_5) 
	FROM backup.agency_sent_18R4UMCA
	WHERE highlights_id_5 <> ''
	GROUP BY offer_1_lob_campaign_id, offer_1_cell_id, highlights_id_5
	ON CONFLICT (campaign_id, cell_id, placement_index) 
	DO UPDATE SET counts = staging.supporting_cell_placement_impression_18R4UMCA.counts + excluded.counts;
	
	RETURN 'Function has been executed successfully!';	
END;
$function$
;
