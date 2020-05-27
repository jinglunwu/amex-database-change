CREATE OR REPLACE FUNCTION staging.create_history_partition_for_campaign()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

DECLARE
	partition_table_name varchar (100);

BEGIN
	set search_path to 'staging';
	
	if (coalesce(new.mi_campaign_id, '') <> '') then 
	
		select 'mi_event_log_history_c' || new.mi_campaign_id into partition_table_name;

		execute format('create table if not exists %I (check (campaign_id = ''%s'')) inherits (staging.mi_event_log_history)', 'staging.' || partition_table_name, new.mi_campaign_id);
		execute format('create unique index if not exists %s_id_idx on %I(id)', partition_table_name, partition_table_name);
		execute format('create index if not exists %s_campaign_id_idx on %I(campaign_id)', partition_table_name, partition_table_name);
		execute format('create index if not exists %s_event_type_extra_data_code_idx on %I(event_type, extra_data_code)', partition_table_name, partition_table_name);
	
	end if;
	
	return null;
	
END
$function$
;