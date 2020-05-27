CREATE OR REPLACE FUNCTION staging.validate_cell_no_lookup(_campaign_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE _drop_date date;
DECLARE _portfolio varchar(500);
BEGIN	
	SELECT drop_date, "name"
	FROM staging.campaigns 
	INNER JOIN staging.portfolios ON staging.campaigns.portfolio_id = staging.portfolios.id
	WHERE staging.campaigns.id = _campaign_id
	INTO _drop_date, _portfolio;
	
	--Handle the agency_sent 
	INSERT INTO staging.validate_cell_no_lookup
	SELECT DISTINCT  _drop_date, _portfolio, _campaign_id, offer_1_cell_id, 'sent'
	FROM staging.agency_sent 
	WHERE  LENGTH(encrypted_email) >= 40 AND offer_1_lob_campaign_id = _campaign_id AND offer_1_cell_id <> '' AND
	offer_1_cell_id NOT IN (SELECT id FROM staging.cells WHERE campaign_id = _campaign_id);

	--Handle the agency_open 
	INSERT INTO staging.validate_cell_no_lookup
	SELECT DISTINCT  _drop_date, _portfolio, _campaign_id, offer_1_cell_id, 'open'
	FROM staging.agency_open_unique 
	WHERE  LENGTH(encrypted_email) >= 40 AND offer_1_lob_campaign_id = _campaign_id AND offer_1_cell_id <> '' AND
	offer_1_cell_id NOT IN (SELECT id FROM staging.cells WHERE campaign_id = _campaign_id);

	--Handle the agency_click
	INSERT INTO staging.validate_cell_no_lookup
	SELECT DISTINCT  _drop_date, _portfolio, _campaign_id, offer_1_cell_id, 'click'
	FROM staging.agency_click 
	WHERE  LENGTH(encrypted_email) >= 40 AND offer_1_lob_campaign_id = _campaign_id AND offer_1_cell_id <> '' AND
	offer_1_cell_id NOT IN (SELECT id FROM staging.cells WHERE campaign_id = _campaign_id);

	--Handle the agency_bounce 
	INSERT INTO staging.validate_cell_no_lookup
	SELECT DISTINCT  _drop_date, _portfolio, _campaign_id, offer_1_cell_id, 'bounce'
	FROM staging.agency_bounce_unique 
	WHERE  LENGTH(encrypted_email) >= 40 AND offer_1_lob_campaign_id = _campaign_id AND offer_1_cell_id <> '' AND
	offer_1_cell_id NOT IN (SELECT id FROM staging.cells WHERE campaign_id = _campaign_id);

	--Handle the agency_optout
	INSERT INTO staging.validate_cell_no_lookup
	SELECT DISTINCT  _drop_date, _portfolio, _campaign_id, offer_1_cell_id, 'optout'
	FROM staging.agency_optout_unique 
	WHERE  LENGTH(encrypted_email) >= 40 AND offer_1_lob_campaign_id = _campaign_id AND offer_1_cell_id <> '' AND
	offer_1_cell_id NOT IN (SELECT id FROM staging.cells WHERE campaign_id = _campaign_id);
	
	RETURN '--Validation is completed--';
END;
$function$
;


 





 