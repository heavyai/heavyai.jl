module OmniSci

using Compat, Thrift, Random, Sockets, Distributed, DataFrames
import Thrift: process, meta, distribute, ThriftMeta, ThriftMetaAttribs
import Base: show
import DataFrames: DataFrame

export TDatum, TColumn

#### functions ####
export connect, disconnect
export get_status, get_hardware_info
export get_tables, get_physical_tables, get_views, get_tables_meta, get_table_details
export get_users, get_databases
export get_memory, clear_cpu_memory, clear_gpu_memory
export sql_execute, sql_execute_df, sql_execute_gdf
export interrupt
export set_execution_mode
export render_vega
export get_frontend_view, get_frontend_views
export create_frontend_view, delete_frontend_view
export get_dashboard, get_dashboards, get_dashboard_grantees
export create_dashboard, replace_dashboard, delete_dashboard, share_dashboard, unshare_dashboard
export load_table_binary, load_table_binary_columnar, load_table_binary_arrow, load_table
export detect_column_types, create_table, import_table, import_geo_table, import_table_status
export get_roles, get_all_roles_for_user
export get_db_objects_for_grantee, get_db_object_privs
export set_license_key, get_license_claims
export DataFrame

include("mapd_enums.jl") #hand-maintained code for more convenient enums
include("mapd_types.jl") #slightly modified from Thrift.jl for circular type fix
include("mapd_client.jl") #should be same as output by Thrift.jl
include("misc.jl") #for hand-maintained code
include("dataframes.jl")

end # module OmniSci
