CREATE OR REPLACE FUNCTION staging.agency_click_mi_alias_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	--Step1: replac alias_placement_index with mi extra_data_code	
	UPDATE staging.agency_click
	SET alias_placement_index = staging.mi_event_log_click_open_merge.extra_data_code, 
	    alias_placement_index_source = 1
	FROM staging.mi_event_log_click_open_merge, staging.urls
	WHERE staging.agency_click.encrypted_email = staging.mi_event_log_click_open_merge.mi_u
	AND staging.agency_click.offer_1_lob_campaign_id = staging.mi_event_log_click_open_merge.sf_campaign_id
	AND staging.agency_click.url LIKE staging.urls.url_id
	AND staging.mi_event_log_click_open_merge.campaign_id = staging.urls.campaign_id
	AND staging.mi_event_log_click_open_merge.app_id = staging.urls.app_id;
	
	--Step2: replace alias_placement_index with keyword if it is still empty
	UPDATE staging.agency_click
	SET alias_placement_index = alias_order, alias_order = '',  
	    alias_placement_index_source = 2
	WHERE (alias_placement_index = '' OR alias_placement_index IS NULL) 
	AND (alias_order <> '' AND alias_order IS NOT NULL) 
	AND alias_order !~ '^[0-9]';
	
	--Step3: replace alias attributes with the urls table when they are empty
	UPDATE staging.agency_click
	SET alias_section = staging.urls.alias_section, 
	    alias_section_source = 3
	FROM staging.urls
	WHERE (staging.agency_click.url LIKE staging.urls.url_id OR staging.agency_click.url = staging.urls.url_id)
	AND (staging.agency_click.alias_section IS NULL OR staging.agency_click.alias_section = '') 
	AND (staging.urls.alias_section IS NOT NULL AND staging.urls.alias_section <> '');
	
	UPDATE staging.agency_click 
	SET alias_slot = staging.urls.alias_slot, 
	    alias_slot_source = 3
	FROM staging.urls
	WHERE (staging.agency_click.url LIKE staging.urls.url_id OR staging.agency_click.url = staging.urls.url_id)
	AND (staging.agency_click.alias_slot IS NULL OR staging.agency_click.alias_slot = '') 
	AND (staging.urls.alias_slot IS NOT NULL AND staging.urls.alias_slot <> '');
	
	UPDATE staging.agency_click 
	SET alias_placement_index = staging.urls.alias_placement_index, 
	    alias_placement_index_source = 3
	FROM staging.urls
	WHERE (staging.agency_click.url LIKE staging.urls.url_id OR staging.agency_click.url = staging.urls.url_id)
	AND (staging.agency_click.alias_placement_index IS NULL OR staging.agency_click.alias_placement_index = '') 
	AND (staging.urls.alias_placement_index IS NOT NULL AND staging.urls.alias_placement_index <> '');
	
	UPDATE staging.agency_click 
	SET alias_cta = staging.urls.alias_cta, 
	    alias_cta_source = 3
	FROM staging.urls
	WHERE (staging.agency_click.url LIKE staging.urls.url_id OR staging.agency_click.url = staging.urls.url_id)
	AND (staging.agency_click.alias_cta IS NULL OR staging.agency_click.alias_cta = '') 
	AND (staging.urls.alias_cta IS NOT NULL AND staging.urls.alias_cta <> '');
	
	--Step4: replace alias_placement_index with truncated url if it is still empty
	UPDATE staging.agency_click
	SET alias_placement_index = staging.supporting_get_truncate_url(url), 
	    alias_placement_index_source = 4
	WHERE alias_placement_index IS NULL OR alias_placement_index = '';	
	
	--Step5: replace alias_section with placement table when it is empty
	UPDATE staging.agency_click
	SET alias_section = staging.placements.alias_section, 
	    alias_section_source = 5
	FROM staging.placements
	WHERE staging.agency_click.offer_1_lob_campaign_id = staging.placements.campaign_id
	AND staging.agency_click.alias_placement_index = staging.placements."index"
	AND (staging.agency_click.alias_section IS NULL OR staging.agency_click.alias_section ='')
	AND (staging.placements.alias_section IS NOT NULL AND staging.placements.alias_section <> '');

	--Step6: Hard-coded changes for 6 urls in pink
	UPDATE 	staging.agency_click
	SET alias_placement_index = alias_placement_index || 'e', 
	    alias_placement_index_source = 6
    WHERE url LIKE '%7d94df0d2a116256%';
   
    UPDATE 	staging.agency_click
	SET alias_placement_index = alias_placement_index || 'e', 
	    alias_placement_index_source = 6
    WHERE url LIKE '%8b4fa37beae2f271%';
   
    UPDATE 	staging.agency_click
	SET alias_placement_index = alias_placement_index || 'a', 
	    alias_placement_index_source = 6
    WHERE url LIKE '%dccfb58a1c947869%';
   
    UPDATE 	staging.agency_click
	SET alias_placement_index = alias_placement_index || 'b', 
	    alias_placement_index_source = 6
    WHERE url LIKE '%adf0a016286edbfd%';
   
    UPDATE 	staging.agency_click
	SET alias_placement_index = alias_placement_index || 'c', 
	    alias_placement_index_source = 6
    WHERE url LIKE '%8e5cfe3b0b70d1b0%';
   
    UPDATE 	staging.agency_click
	SET alias_placement_index = alias_placement_index || 'd', 
	    alias_placement_index_source = 6
    WHERE url LIKE '%d846b959d7d1e010%';
	
	--Text Version Click No Alias Remediation | 20190918
	
	--If the url is like "https://www.aexpfeedback.com/%" and the alias (after processing) is like "https://www.aexpfeedback%" 
	--then make the alias "Footer: Share Your Feedback" instead
	UPDATE staging.agency_click
	SET alias_placement_index = 'Footer: Share Your Feedback', alias_placement_index_source = 7
	WHERE url LIKE 'https://www.aexpfeedback.com/%' AND alias_placement_index LIKE 'https://www.aexpfeedback%';
	
	--If the url is like "%/terms%" and the alias after processing is like "%/terms%" and the section is empty 
	--then make the section "terms"
	UPDATE staging.agency_click
	SET alias_section = 'terms', alias_section_source = 7
	WHERE url LIKE '%/terms%' AND alias_placement_index LIKE '%/terms%' AND (alias_section IS NULL OR alias_section = '') ;
	
	--If the url is like any line in the attached doc "aejohg-text-clicks-no-alias.text" and the alias is empty 
	--then suppress it from the clicks report 
	TRUNCATE TABLE staging.supporting_agency_click_text_version_delete;
	
	INSERT INTO staging.supporting_agency_click_text_version_delete
	SELECT staging.agency_click.* FROM staging.agency_click
	INNER JOIN staging.supporting_aejohg_text_clicks_no_alias
	ON staging.agency_click.url LIKE '%' || staging.supporting_aejohg_text_clicks_no_alias.url_string || '%'
	WHERE alias_placement_index LIKE 'http%' OR alias_placement_index IS NULL OR alias_placement_index = '';
	
	DELETE FROM staging.agency_click
	WHERE id IN (SELECT id FROM staging.supporting_agency_click_text_version_delete);
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
