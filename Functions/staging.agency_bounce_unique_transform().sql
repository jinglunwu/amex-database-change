CREATE OR REPLACE FUNCTION staging.agency_bounce_unique_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int8;
BEGIN	
	TRUNCATE TABLE staging.agency_bounce_unique;
	
	INSERT INTO staging.agency_bounce_unique
	SELECT encrypted_email, MAX(offer_1_lob_campaign_id), offer_1_cell_id
	FROM staging.agency_bounce
	WHERE encrypted_email <> '' AND offer_1_cell_id <> ''
	GROUP BY encrypted_email, offer_1_cell_id ;	 
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
