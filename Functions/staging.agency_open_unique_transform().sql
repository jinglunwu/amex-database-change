CREATE OR REPLACE FUNCTION staging.agency_open_unique_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN
	INSERT INTO staging.agency_open_unique
	SELECT encrypted_email, MAX(offer_1_lob_campaign_id), offer_1_cell_id
	FROM staging.agency_open
	WHERE encrypted_email <> '' AND offer_1_cell_id <> '' AND unique_processed_at IS NULL
	GROUP BY encrypted_email, offer_1_cell_id
	ON CONFLICT(encrypted_email, offer_1_cell_id) DO NOTHING;	
	
	UPDATE staging.agency_open SET unique_processed_at = current_timestamp WHERE unique_processed_at IS NULL;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
