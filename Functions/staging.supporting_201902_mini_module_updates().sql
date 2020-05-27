CREATE OR REPLACE FUNCTION staging.supporting_201902_mini_module_updates()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE _2222EJ9C_H1a int4;
DECLARE _2222EJ9C_H1b int4;
DECLARE _2222EJ9E_H1a int4;
DECLARE _2222EJ9E_H1b int4;
DECLARE _2222EJ9F_H1a int4;
DECLARE _2222EJ9F_H1b int4;
DECLARE _2222EJ95_H2a int4;
DECLARE _2222EJ95_H2b int4;
DECLARE _2222EJ96_H2a int4;
DECLARE _2222EJ96_H2b int4;
DECLARE _2222EJ97_H2a int4;
DECLARE _2222EJ97_H2b int4;
DECLARE _2222EJ99_H2a int4;
DECLARE _2222EJ99_H2b int4;
DECLARE _2222EJ9A_H2a int4;
DECLARE _2222EJ9A_H2b int4;
DECLARE _2222EJ9H_H3a int4;
DECLARE _2222EJ9H_H3b int4;
DECLARE _2222EJ9J_H3a int4;
DECLARE _2222EJ9J_H3b int4;
DECLARE _2222EJ9L_H1M int4;
DECLARE _2222EJ9M_H1M int4;
DECLARE _2222EJ9L_H2M int4;
DECLARE _2222EJ9M_H2M int4;
DECLARE _2222EJ9N_H3M int4;
DECLARE _2222EJ9P_H3M int4;
DECLARE _2222EJ9R_H4M int4;
DECLARE _2222EJ9T_H1M int4;
DECLARE _2222EJ9U_H1M int4;
DECLARE _2222EJ9V_H1M int4;
DECLARE _2222EJ9Y_H1M int4;
DECLARE _2222EJ9Z_H1M int4;
DECLARE _2222EJA3_H1M int4;
DECLARE _2222EJA4_H1M int4;
BEGIN
	--Cobrand (1BX1UMCA)
	
	--2222EJ9C_H1a	
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ9C' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9C_H1a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9C_H1a WHERE cell_id = '2222EJ9C' AND alias_placement_index = 'H1a';

	--2222EJ9C_H1b	
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ9C' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9C_H1b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9C_H1b WHERE cell_id = '2222EJ9C' AND alias_placement_index = 'H1b';

	--2222EJ9E_H1a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ9E' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9E_H1a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9E_H1a WHERE cell_id = '2222EJ9E' AND alias_placement_index = 'H1a';	

	--2222EJ9E_H1b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ9E' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9E_H1b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9E_H1b WHERE cell_id = '2222EJ9E' AND alias_placement_index = 'H1b';	

	--2222EJ9F_H1a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ9F' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9F_H1a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9F_H1a WHERE cell_id = '2222EJ9F' AND alias_placement_index = 'H1a';	

	--2222EJ9F_H1b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ9F' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9F_H1b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9F_H1b WHERE cell_id = '2222EJ9F' AND alias_placement_index = 'H1b';	

	--2222EJ95_H2a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ95' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ95_H2a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ95_H2a WHERE cell_id = '2222EJ95' AND alias_placement_index = 'H2a';

	--2222EJ95_H2b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ95' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ95_H2b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ95_H2b WHERE cell_id = '2222EJ95' AND alias_placement_index = 'H2b';

	--2222EJ96_H2a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ96' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ96_H2a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ96_H2a WHERE cell_id = '2222EJ96' AND alias_placement_index = 'H2a';

	--2222EJ96_H2b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ96' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ96_H2b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ96_H2b WHERE cell_id = '2222EJ96' AND alias_placement_index = 'H2b';

	--2222EJ97_H2a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ97' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ97_H2a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ97_H2a WHERE cell_id = '2222EJ97' AND alias_placement_index = 'H2a';

	--2222EJ97_H2b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ97' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ97_H2b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ97_H2b WHERE cell_id = '2222EJ97' AND alias_placement_index = 'H2b';

	--2222EJ99_H2a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ99' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ99_H2a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ99_H2a WHERE cell_id = '2222EJ99' AND alias_placement_index = 'H2a';

	--2222EJ99_H2b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ99' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ99_H2b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ99_H2b WHERE cell_id = '2222EJ99' AND alias_placement_index = 'H2b';

	--2222EJ9A_H2a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ9A' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9A_H2a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9A_H2a WHERE cell_id = '2222EJ9A' AND alias_placement_index = 'H2a';

	--2222EJ9A_H2b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ9A' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9A_H2b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9A_H2b WHERE cell_id = '2222EJ9A' AND alias_placement_index = 'H2b';

	--2222EJ9H_H3a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H3' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ9H' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9H_H3a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9H_H3a WHERE cell_id = '2222EJ9H' AND alias_placement_index = 'H3a';

	--2222EJ9H_H3b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H3' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ9H' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9H_H3b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9H_H3b WHERE cell_id = '2222EJ9H' AND alias_placement_index = 'H3b';

	--2222EJ9J_H3a
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H3' AND offer_2_pers_1 = 'YES' AND offer_1_cell_id = '2222EJ9J' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9J_H3a;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9J_H3a WHERE cell_id = '2222EJ9J' AND alias_placement_index = 'H3a';

	--2222EJ9J_H3b
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H3' AND offer_2_pers_1 <> 'YES' AND offer_1_cell_id = '2222EJ9J' AND offer_1_lob_campaign_id ='1BX1UMCA' INTO _2222EJ9J_H3b;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9J_H3b WHERE cell_id = '2222EJ9J' AND alias_placement_index = 'H3b';

	--2222EJ9L_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9L' AND offer_1_lob_campaign_id ='1BV1UMCA' INTO _2222EJ9L_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9L_H1M WHERE cell_id = '2222EJ9L' AND alias_placement_index = 'H1M';

	--2222EJ9M_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9M' AND offer_1_lob_campaign_id ='1BV1UMCA' INTO _2222EJ9M_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9M_H1M WHERE cell_id = '2222EJ9M' AND alias_placement_index = 'H1M';

	--2222EJ9L_H2M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9L' AND offer_1_lob_campaign_id ='1BV1UMCA' INTO _2222EJ9L_H2M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9L_H2M WHERE cell_id = '2222EJ9L' AND alias_placement_index = 'H2M';

	--2222EJ9M_H2M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H2' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9M' AND offer_1_lob_campaign_id ='1BV1UMCA' INTO _2222EJ9M_H2M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9M_H2M WHERE cell_id = '2222EJ9M' AND alias_placement_index = 'H2M';

	--2222EJ9N_H3M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H3' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9N' AND offer_1_lob_campaign_id ='1BV1UMCA' INTO _2222EJ9N_H3M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9N_H3M WHERE cell_id = '2222EJ9N' AND alias_placement_index = 'H3M';

	--2222EJ9P_H3M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H3' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9P' AND offer_1_lob_campaign_id ='1BV1UMCA' INTO _2222EJ9P_H3M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9P_H3M WHERE cell_id = '2222EJ9P' AND alias_placement_index = 'H3M';

	--2222EJ9R_H4M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H4' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9R' AND offer_1_lob_campaign_id ='1BV1UMCA' INTO _2222EJ9R_H4M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9R_H4M WHERE cell_id = '2222EJ9R' AND alias_placement_index = 'H4M';

	--2222EJ9T_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9T' AND offer_1_lob_campaign_id ='1BU1UMCA' INTO _2222EJ9T_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9T_H1M WHERE cell_id = '2222EJ9T' AND alias_placement_index = 'H1M';

	--2222EJ9U_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9U' AND offer_1_lob_campaign_id ='1BU1UMCA' INTO _2222EJ9U_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9U_H1M WHERE cell_id = '2222EJ9U' AND alias_placement_index = 'H1M';

	--2222EJ9V_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9V' AND offer_1_lob_campaign_id ='1BU1UMCA' INTO _2222EJ9V_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9V_H1M WHERE cell_id = '2222EJ9V' AND alias_placement_index = 'H1M';

	--2222EJ9Y_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9Y' AND offer_1_lob_campaign_id ='1BU1UMCA' INTO _2222EJ9Y_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9Y_H1M WHERE cell_id = '2222EJ9Y' AND alias_placement_index = 'H1M';

	--2222EJ9Z_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJ9Z' AND offer_1_lob_campaign_id ='1BU1UMCA' INTO _2222EJ9Z_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJ9Z_H1M WHERE cell_id = '2222EJ9Z' AND alias_placement_index = 'H1M';

	--2222EJA3_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJA3' AND offer_1_lob_campaign_id ='1BU1UMCA' INTO _2222EJA3_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJA3_H1M WHERE cell_id = '2222EJA3' AND alias_placement_index = 'H1M';

	--2222EJA4_H1M
	SELECT COUNT(*) FROM staging.agency_sent WHERE offer_2_pers_2 = 'H1' AND offer_3_pers_2 = 'YES' AND offer_1_cell_id = '2222EJA4' AND offer_1_lob_campaign_id ='1BU1UMCA' INTO _2222EJA4_H1M;
	UPDATE staging.supporting_click_cell_placement_index_based_report SET sent_impression = _2222EJA4_H1M WHERE cell_id = '2222EJA4' AND alias_placement_index = 'H1M';

END;
$function$
;