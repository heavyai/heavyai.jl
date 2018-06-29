using MapD
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

#wrap in ifexists before using on Travis
include("credentials.jl")


######################################## connection, admin
#connect to database
conn = MapD.connect(host, port , user, passwd, dbname)
@test typeof(conn) == MapD.MapDConnection

sstatus = get_status(conn)
@test typeof(sstatus) == Vector{MapD.TServerStatus}
@test sstatus[1].start_time <= Dates.datetime2unix(now()) #test sstatus has values

hware = get_hardware_info(conn)
@test typeof(hware) == MapD.TClusterHardwareInfo

tables = get_tables(conn)
@test typeof(tables) == Vector{String}

ptables = get_physical_tables(conn)
@test typeof(ptables) == Vector{String}

views = get_views(conn)
@test typeof(views) == Vector{String}

met = get_tables_meta(conn)
@test typeof(met) == Vector{MapD.TTableMeta}

#Need to change eventually, depending on what is in test instance
table_deet = get_table_details(conn, "fordgobike_tripdata_v2")
@test typeof(table_deet) == MapD.TTableDetails

users = get_users(conn)
@test typeof(users) == Vector{String}

databases = get_databases(conn)
@test typeof(databases) == Vector{MapD.TDBInfo}

version = get_version(conn)
@test typeof(version) == String

#start_heap_profile
#stop_heap_profile
#get_heap_profile

mem = get_memory(conn, "cpu")
@test typeof(mem) == Vector{MapD.TNodeMemoryInfo}

clear_cpu = clear_cpu_memory(conn)
clear_gpu = clear_gpu_memory(conn)

######################################## query, render

#sql_execute
#sql_execute_df
sdf = sql_execute_df(conn, "select count(*) as records from fordgobike_tripdata_v2", 0, 0, 1000)
#sql_execute_gdf
#deallocate_df
#interrupt

sqlval = sql_validate(conn, "select count(*) as records from fordgobike_tripdata_v2")
@test typeof(sqlval) == Dict{String,MapD.TColumnType}

#get_completion_hints
#set_execution_mode(conn, GPU)
#render_vega
#get_result_row_for_pixel

######################################## dashboard

#get_dashboard
#get_dashboards
#create_dashboard
#replace_dashboard
#delete_dashboard
#share_dashboard
#unshare_dashboard
#get_dashboard_grantees

######################################## dashboard links

#get_link_view
#create_link

######################################## import

#load_table_binary
#load_table_binary_columnar
#load_table_binary_arrow
#load_table

######################################## object privileges

#get_roles
#get_db_objects_for_grantee
#get_db_object_privs
#get_all_roles_for_user

######################################## licensing

#set_license_key
#get_license_claims



#disconnect from database
disc = disconnect(conn)
