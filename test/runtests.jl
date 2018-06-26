using MapD
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

#wrap in ifexists before using on Travis
include("credentials.jl")

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


# met = get_tables_meta(conn)
# table_deet = get_table_details(conn, "fordgobike_tripdata_v2")
# #int_tab_deet = get_internal_table_details(conn, "")
# users = get_users(conn)
# databases = get_databases(conn)
# version = get_version(conn)
# clear_cpu = clear_cpu_memory(conn)
# clear_gpu = clear_gpu_memory(conn)
# interupt = interrupt(conn)
# frontend_views = get_frontend_views(conn)
# dashboards = get_dashboards(conn)
# mem = get_memory(conn, "cpu") # "cpu" or "gpu" based on ThriftWithRetry.h
#
#
#
# #disconnect from database
# disc = disconnect(conn)
