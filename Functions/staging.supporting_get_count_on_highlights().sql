CREATE OR REPLACE FUNCTION staging.supporting_get_count_on_highlights(highlights_row character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
	DECLARE counts int4;
BEGIN
	counts := array_length(string_to_array(highlights_row, '|'), 1);

	IF counts IS NULL THEN
		counts := 0;
	END IF;

	RETURN counts;

END;
$function$
;
