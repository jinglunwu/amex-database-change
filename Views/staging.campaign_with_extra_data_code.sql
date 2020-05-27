CREATE OR REPLACE VIEW staging.campaign_with_extra_data_code
AS SELECT campaigns.id,
    campaigns.portfolio_id AS name,
    supporting_mi_campaign_placement_index_appid.mi_campaign_id,
    supporting_mi_campaign_placement_index_appid.extra_data_code,
    supporting_mi_campaign_placement_index_appid.app_id,
    campaigns.drop_date
   FROM staging.supporting_mi_campaign_placement_index_appid
     LEFT JOIN staging.campaigns ON supporting_mi_campaign_placement_index_appid.mi_campaign_id::text = campaigns.mi_campaign_id::text;
