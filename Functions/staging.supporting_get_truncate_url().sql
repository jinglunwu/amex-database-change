CREATE OR REPLACE FUNCTION staging.supporting_get_truncate_url(url character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE return_url varchar(100);
BEGIN
	
	IF LENGTH(url) <= 50 THEN
	    return_url := url;
	ELSE
	    return_url := CONCAT(LEFT(url, 24) , '...' , RIGHT(url, 23));
	END IF;
	
	RETURN return_url;
END;
$function$
;
