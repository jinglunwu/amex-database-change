CREATE OR REPLACE FUNCTION staging.validate_click_no_sent(_campaign_id varchar(500))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
	INSERT INTO staging.validate_click_no_sent
	SELECT staging.agency_click.id, staging.agency_click.encrypted_email, staging.agency_click.offer_1_lob_campaign_id, staging.agency_click.offer_1_cell_id
	FROM staging.agency_click
	LEFT OUTER JOIN staging.agency_sent
	ON staging.agency_click.encrypted_email = staging.agency_sent.encrypted_email AND staging.agency_click.offer_1_cell_id = staging.agency_sent.offer_1_cell_id
	WHERE staging.agency_click.offer_1_lob_campaign_id = TRIM(_campaign_id) AND LENGTH(staging.agency_click.encrypted_email) >= 40 AND staging.agency_sent.encrypted_email IS NULL;

	RETURN '--Validation is completed--';
END;
$function$
;