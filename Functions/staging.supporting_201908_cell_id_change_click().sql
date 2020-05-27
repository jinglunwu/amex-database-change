CREATE OR REPLACE FUNCTION staging.supporting_201908_cell_id_change_click()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN	
	UPDATE staging.agency_click
	SET offer_1_cell_id = staging.agency_click.offer_1_cell_id || '_NYC' 
	FROM staging.agency_sent
	WHERE staging.agency_click.offer_1_lob_campaign_id IN ('28S1UMCA', '28J1UMCA') AND
	staging.agency_click.encrypted_email = staging.agency_sent.encrypted_email AND 
	staging.agency_click.offer_1_lob_campaign_id = staging.agency_sent.offer_1_lob_campaign_id AND
	staging.agency_click.original_cell_id = staging.agency_sent.original_cell_id AND
	staging.agency_sent.offer_1_cell_id LIKE '%_NYC' AND
	(staging.agency_sent.offer_1_pers_1 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_2 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_3 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_4 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_5 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_1_pers_6 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_7 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_8 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_9 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_1_pers_10 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_2_pers_1 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_2 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_3 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_4 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_5 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_2_pers_6 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_7 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_8 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_9 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_2_pers_10 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_3_pers_1 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_2 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_3 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_4 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_5 = staging.agency_click.alias_placement_index OR
	staging.agency_sent.offer_3_pers_6 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_7 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_8 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_9 = staging.agency_click.alias_placement_index OR staging.agency_sent.offer_3_pers_10 = staging.agency_click.alias_placement_index);
	
	RETURN '--Execution is completed--';
END;
$function$
;


 





 