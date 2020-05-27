CREATE OR REPLACE FUNCTION staging.mi_event_log_transform()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4 default 0;
BEGIN	
	INSERT INTO staging.mi_event_log(id, campaign_id, mi_u, mi_t, request_isodatetime, app_type, app_id, image_type, image_id, event_type, client_type, client_name, device_agent,
	device_type, device_platform, device_browser_family, device_browser_version, location_country_code, location_region, location_city, location_postal_code, location_latitude, location_longitude,
	weather_conditions, weather_icao, weather_temperature_c, weather_temperature_f, query_params, extra_data, extra_data_code, carrier, timezone_code, timezone_offset, referer, url,
	batch, target_url, amount, meta, checksum, processed_at) 
	SELECT id, data->>'campaign_id', data->>'mi_u', data->>'mi_t', data->>'request_isodatetime', data->>'app_type',  data->>'app_id' , data->>'image_type', data->>'image_id', 
	data->>'event_type', data->>'client_type', data->>'client_name', SUBSTRING(data->>'device_agent' FROM 1 FOR 7000), data->>'device_type', data->>'device_platform', data->>'device_browser_family',
	data->>'device_browser_version', data->>'location_country_code', data->>'location_region', data->>'location_city', data->>'location_postal_code', 
	TO_NUMBER(CASE WHEN data->>'location_latitude' IS NULL THEN '0' WHEN data->>'location_latitude' = '' THEN '0' ELSE data->>'location_latitude' END, '999999999999.999999'),
	TO_NUMBER(CASE WHEN data->>'location_longitude' IS NULL THEN '0' WHEN data->>'location_longitude' = '' THEN '0' ELSE data->>'location_longitude' END, '999999999999.999999'),
	data->>'weather_conditions', data->>'weather_icao', data->>'weather_temperature_c', data->>'weather_temperature_f', CAST(data->>'query_params' AS JSON),
	data->'extra_data', data->'extra_data'->>'code', data->>'carrier', data->>'timezone_code', data->>'timezone_offset',
	data->>'referer', data->>'url',	data->>'batch', data->>'target_url', data->>'amount', meta, checksum, current_timestamp
	FROM raw.movableink 
	WHERE data->>'app_type'= 'live_pic' AND 
	data->>'event_type' IN ('open', 'open|visit', 'open|glance|visit', 'click', 'click|u_click')
    ON CONFLICT DO NOTHING;

	INSERT INTO backup.movableink_history3 SELECT * FROM raw.movableink;
	
	TRUNCATE TABLE raw.movableink;	
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;