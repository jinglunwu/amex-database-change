CREATE OR REPLACE FUNCTION staging.supporting_missing_alias_url()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE r_row_count int4;
BEGIN
	
	TRUNCATE TABLE staging.supporting_missing_alias_url;
	
	INSERT INTO staging.supporting_missing_alias_url
	SELECT url, COUNT(*) FROM staging.agency_click
	WHERE alias = '' AND url NOT LIKE '%optout%'
	GROUP BY url
	ORDER BY COUNT(*) DESC;
	
	GET DIAGNOSTICS r_row_count = ROW_COUNT;
	
	RETURN r_row_count;
END;
$function$
;
