CREATE OR REPLACE VIEW staging.view_cell_based_report
AS SELECT campaigns.drop_date,
    supporting_cell_based_report.cell_id,
    supporting_cell_based_report.sents,
    supporting_cell_based_report.total_opens,
    supporting_cell_based_report.unique_opens,
    supporting_cell_based_report.total_clicks,
    supporting_cell_based_report.unique_clicks,
    supporting_cell_based_report.bounces,
    supporting_cell_based_report.optouts,
    cells.campaign_id,
    campaigns.theme,
    portfolios.id AS portfolio_id,
    portfolios.name AS portfolio_name,
    cells.card_id,
    cards.name AS cards_name,
    product_teams.id AS team_id,
    product_teams.name AS team_name,
    cells.subject_line,
    cells.preview_line,
    cells.segment_details,
    cells.test_details,
    cells.test_type,
    cells.test_variant
   FROM staging.supporting_cell_based_report
     LEFT JOIN staging.cells ON supporting_cell_based_report.cell_id::text = cells.id::text
     LEFT JOIN staging.campaigns ON cells.campaign_id::text = campaigns.id::text
     LEFT JOIN staging.cards ON cells.card_id::text = cards.id::text
     LEFT JOIN staging.product_teams ON cards.team_id::text = product_teams.id::text
     LEFT JOIN staging.portfolios ON campaigns.portfolio_id::text = portfolios.id::text
  WHERE campaigns.drop_date <= '2020-05-01'::date
  ORDER BY campaigns.drop_date, cells.campaign_id, supporting_cell_based_report.cell_id;