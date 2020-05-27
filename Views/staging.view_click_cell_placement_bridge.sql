CREATE OR REPLACE VIEW staging.view_click_cell_placement_bridge
AS SELECT campaigns.drop_date,
    supporting_click_cell_placement_index_based_report.cell_id,
    supporting_click_cell_placement_index_based_report.total_clicks,
    supporting_click_cell_placement_index_based_report.unique_clicks,
    supporting_click_cell_placement_index_based_report.sent_impression,
    supporting_click_cell_placement_index_based_report.open_impression,
    cells.campaign_id,
    campaigns.theme,
    portfolios.id AS portfolio_id,
    portfolios.name AS portfolio_name,
    cells.card_id,
    cards.name AS cards_name,
    product_teams.id AS team_id,
    product_teams.name AS team_name,
    supporting_click_cell_placement_index_based_report.alias_order,
    supporting_click_cell_placement_index_based_report.alias_section,
    supporting_click_cell_placement_index_based_report.alias_slot,
    supporting_click_cell_placement_index_based_report.alias_placement_index,
    supporting_click_cell_placement_index_based_report.alias_cta,
    cells.subject_line,
    cells.preview_line,
    cells.segment_details
   FROM staging.supporting_click_cell_placement_index_based_report
     LEFT JOIN staging.cells ON supporting_click_cell_placement_index_based_report.cell_id::text = cells.id::text
     LEFT JOIN staging.campaigns ON cells.campaign_id::text = campaigns.id::text
     LEFT JOIN staging.cards ON cells.card_id::text = cards.id::text
     LEFT JOIN staging.product_teams ON cards.team_id::text = product_teams.id::text
     LEFT JOIN staging.portfolios ON campaigns.portfolio_id::text = portfolios.id::text
  ORDER BY campaigns.drop_date, supporting_click_cell_placement_index_based_report.cell_id, (length(supporting_click_cell_placement_index_based_report.alias_placement_index::text));
