CREATE OR REPLACE FUNCTION staging.validate_campaign_in_lookup_no_data()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _mi_campaign_id varchar(100);
DECLARE campaign_exists_flag BOOLEAN;
BEGIN
	_mi_campaign_id := (SELECT mi_campaign_id FROM staging.campaigns WHERE id = _campaign_id);
	
    -- Sales Force Sent
	SELECT NOT EXISTS(SELECT 1 FROM staging.agency_sent WHERE offer_1_lob_campaign_id = _campaign_id) INTO campaign_exists_flag;
	
	IF campaign_exists_flag = '1' THEN
		INSERT INTO staging.validate_campaign_in_lookup_no_data(campaign_id, error_message)
		VALUES(_campaign_id, 'No data in Sales Force Sent' );
	END IF;

 -- Sales Force Open
	SELECT NOT EXISTS(SELECT 1 FROM staging.agency_open_unique WHERE offer_1_lob_campaign_id = _campaign_id) INTO campaign_exists_flag;
	
	IF campaign_exists_flag = '1' THEN
		INSERT INTO staging.validate_campaign_in_lookup_no_data(campaign_id, error_message)
		VALUES(_campaign_id, 'No data in Sales Force Open' );
	END IF;

	 -- Sales Force Click
	SELECT NOT EXISTS(SELECT 1 FROM staging.agency_click_unique_cell_based WHERE offer_1_lob_campaign_id = _campaign_id) INTO campaign_exists_flag;
	
	IF campaign_exists_flag = '1' THEN
		INSERT INTO staging.validate_campaign_in_lookup_no_data(campaign_id, error_message)
		VALUES(_campaign_id, 'No data in Sales Force Click' );
	END IF;
	
	 -- MovableInk Open
	SELECT NOT EXISTS(SELECT 1 FROM staging.mi_event_log_open_unique WHERE campaign_id = _mi_campaign_id) INTO campaign_exists_flag;
	
	IF campaign_exists_flag = '1' THEN
		INSERT INTO staging.validate_campaign_in_lookup_no_data(campaign_id, error_message)
		VALUES(_campaign_id, 'No data in MovableInk Open');
	END IF;
	
	 -- MovableInk Click
	SELECT NOT EXISTS(SELECT 1 FROM staging.mi_event_log_open_unique WHERE campaign_id = _mi_campaign_id) INTO campaign_exists_flag;
	
	IF campaign_exists_flag = '1' THEN
		INSERT INTO staging.validate_campaign_in_lookup_no_data(campaign_id, error_message)
		VALUES(_campaign_id, 'No data in MovableInk Open');
	END IF;

	RETURN 'validate_campaign_in_lookup_no_data Check is completed';
	
END;
$function$
;
