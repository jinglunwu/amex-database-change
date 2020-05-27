CREATE OR REPLACE FUNCTION staging.mi_event_log_click_transform(start_id bigint, end_id bigint)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	INSERT INTO staging.mi_event_log_click
	SELECT id, campaign_id, mi_u, mi_t, request_isodatetime, app_type, app_id, image_type, image_id, event_type, client_type, client_name, device_agent, device_type, device_platform, device_browser_family, device_browser_version, location_country_code, location_region, location_city, location_postal_code, location_latitude, location_longitude, weather_conditions, weather_icao, weather_temperature_c, weather_temperature_f, query_params, extra_data, extra_data_code, carrier, timezone_code, timezone_offset, referer, url, batch, target_url, amount, meta, checksum
    FROM staging.mi_event_log
	WHERE event_type LIKE '%click%' AND id >= start_id AND id <=  end_id;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
