CREATE OR REPLACE FUNCTION staging.supporting_lookup_tables_data_clean()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	-- Trim
	UPDATE staging.campaigns
	SET id = TRIM(id), mi_campaign_id = TRIM(mi_campaign_id), portfolio_id = TRIM(portfolio_id);

	UPDATE staging.cells
	SET id = TRIM(id), campaign_id = TRIM(campaign_id), card_id = TRIM(card_id), 
	subject_line = regexp_replace(subject_line, E'[\\n\\r]+', ' ', 'g' ),
    preview_line = regexp_replace(preview_line, E'[\\n\\r]+', ' ', 'g' ),
    segment_details = regexp_replace(segment_details, E'[\\n\\r]+', ' ', 'g' );

	UPDATE staging.placements
	SET "index" = TRIM("index"), campaign_id = TRIM(campaign_id),
	content_title = regexp_replace(content_title, E'[\\n\\r]+', ' ', 'g' ),
	content_category = regexp_replace(content_category, E'[\\n\\r]+', ' ', 'g' ),
	content_subcategory = regexp_replace(content_subcategory, E'[\\n\\r]+', ' ', 'g' ),
	content_detail = regexp_replace(content_detail, E'[\\n\\r]+', ' ', 'g' );
	
	--Remove rows whose pzn_id is NULL in staging.agency_sent_map table
	DELETE FROM staging.agency_sent_map WHERE pzn_id IS NULL;

	RETURN '--completed--';
END;
$function$
;