CREATE OR REPLACE FUNCTION staging.validate_campaign_in_data_no_lookup()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _min_id int8;
DECLARE _max_id int8;
BEGIN
	--Check sf_sent
	_min_id := (SELECT MAX(max_id_processed) FROM staging.validate_campaign_in_data_no_lookup_log
	WHERE data_type = 'sf-sent');
	
	_max_id := (SELECT MAX(id) FROM staging.agency_sent);
	
	IF _max_id > _min_id THEN
		INSERT INTO staging.validate_campaign_in_data_no_lookup(campaign_id, data_type)
		SELECT DISTINCT offer_1_lob_campaign_id, 'sf-sent' FROM staging.agency_sent 
		WHERE id BETWEEN _min_id AND _max_id AND 
		offer_1_lob_campaign_id NOT IN 
	    (SELECT id FROM staging.campaigns);
		
		INSERT INTO staging.validate_campaign_in_data_no_lookup_log(data_type, max_id, processed_at)
		VALUES('sf-sent', _max_id, 
		
	END IF;
	
	
	
	
	

	RETURN 'staging.validate_campaign_in_data_no_lookup check is completed';
END;
$function$
;