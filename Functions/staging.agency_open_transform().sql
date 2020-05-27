CREATE OR REPLACE FUNCTION staging.agency_open_transform()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE min_id int4;
DECLARE max_id int4;
DECLARE start_time timestamp;
DECLARE end_time timestamp;
DECLARE _running_time int4;
DECLARE _transform_log_id int4;
DECLARE _file_name_array text[];
DECLARE _file_name text;
DECLARE insert_row_count int4 DEFAULT 0;
DECLARE update_row_count int4 DEFAULT 0;
DECLARE transfer_row_count int4 DEFAULT 0;
DECLARE delete_row_count int4 DEFAULT 0;
BEGIN
	SELECT MIN(id) FROM raw.sales_force_open INTO min_id;
	SELECT MAX(id) FROM raw.sales_force_open INTO max_id;
	
	IF min_id IS NOT NULL AND max_id IS NOT NULL THEN
	
		_file_name_array := ARRAY(
		SELECT meta->>'filename'
		FROM raw.sales_force_open
		WHERE processed_at IS NULL 
		AND id BETWEEN min_id AND max_id
		GROUP BY meta->>'filename'
		);
	
		FOREACH _file_name IN ARRAY _file_name_array
		LOOP
			start_time := clock_timestamp();
		
			INSERT INTO staging.supporting_transform_log("type", "date") VALUES('sf_open', current_date) RETURNING id INTO _transform_log_id;
		
			INSERT INTO staging.agency_open(id, encrypted_email, job_id, list_id, batch_id, subscriber_id, offer_1_lob_campaign_id, offer_1_cell_id,
			clic_cust_id, message_id, card_product, offer_3_pers_4, open_activity_date, meta, checksum, created_at, transform_log_id) 
			SELECT id, data->>'ENCRYPTED_EMAIL', data->>'JobID', data->>'ListID', data->>'BatchID', data->>'SubscriberID', data->>'offer_1_lob_campaign_id',
			data->>'offer_1_cell_id', data->>'CLIC_CUST_ID', data->>'MESSAGE_ID',  data->>'card_product', data->>'OFFER_3_PERS_4', 
			TO_TIMESTAMP(data->>'Open Activity Date', 'MM/DD/YYYY HH:MI:SS AM'), meta, checksum, CURRENT_TIMESTAMP, _transform_log_id
			FROM raw.sales_force_open
			WHERE processed_at IS NULL AND
			id BETWEEN min_id AND max_id AND
			meta->>'filename' = _file_name;
			
			GET DIAGNOSTICS insert_row_count = ROW_COUNT;	
			
			UPDATE raw.sales_force_open SET processed_at = CURRENT_TIMESTAMP 
			WHERE processed_at IS NULL AND
			id BETWEEN min_id AND max_id AND
			meta->>'filename' = _file_name;
			
			GET DIAGNOSTICS update_row_count = ROW_COUNT; 
			
			INSERT INTO backup.sales_force_open_history
			SELECT * FROM raw.sales_force_open
			WHERE id BETWEEN min_id AND max_id AND 
			meta->>'filename' = _file_name;
			
			GET DIAGNOSTICS transfer_row_count = ROW_COUNT;
			
			IF insert_row_count = update_row_count AND insert_row_count = transfer_row_count THEN
				DELETE FROM raw.sales_force_open
				WHERE id BETWEEN min_id AND max_id AND 
				meta->>'filename' = _file_name;
				
				GET DIAGNOSTICS delete_row_count = ROW_COUNT;
			END IF;
			
			end_time := clock_timestamp();
			
			_running_time := DATE_PART('minute', end_time - start_time)::int4;
			
			IF insert_row_count <> update_row_count OR insert_row_count <> transfer_row_count OR insert_row_count <> delete_row_count THEN
				INSERT INTO staging.supporting_error_log(function_name, descriptions) VALUES('staging.agency_open_transform()', 'min_id=' 
				|| min_id || ', max_id=' || max_id || ', insert_row_count='  || insert_row_count || ', update_row_count='  || update_row_count ||
				|| ', transfer_row_count='  || transfer_row_count || ', delete_row_count='  || delete_row_count);
				
				UPDATE staging.supporting_transform_log
				SET file_name = _file_name,
				record_number = insert_row_count,
				"state" = 'imcomplete',
				running_time = _running_time
				WHERE id = _transform_log_id;
			ELSE
				UPDATE staging.supporting_transform_log
				SET file_name = _file_name,
				record_number = insert_row_count,
				"state" = 'complete',
				running_time = _running_time
				WHERE id = _transform_log_id;
			END IF;
			
		END LOOP;

	END IF;
	
	RETURN 'This process has been executed, and ' || insert_row_count || ' row(s) have been affected.';
			
END;
$function$
;