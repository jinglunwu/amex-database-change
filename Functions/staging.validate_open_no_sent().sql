CREATE OR REPLACE FUNCTION staging.validate_open_no_sent(_campaign_id varchar(500))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	INSERT INTO staging.validate_open_no_sent
	SELECT staging.agency_open.id, staging.agency_open.encrypted_email, staging.agency_open.offer_1_lob_campaign_id, staging.agency_open.offer_1_cell_id
	FROM staging.agency_open
	LEFT OUTER JOIN staging.agency_sent
	ON staging.agency_open.encrypted_email = staging.agency_sent.encrypted_email AND staging.agency_open.offer_1_cell_id = staging.agency_sent.offer_1_cell_id
	WHERE staging.agency_open.offer_1_lob_campaign_id = TRIM(_campaign_id) AND LENGTH(staging.agency_open.encrypted_email) >= 40 AND staging.agency_sent.encrypted_email IS NULL;

	RETURN '--Validation is completed--';
END;
$function$
;
