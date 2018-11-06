module OmniSci

using Thrift, Random, Sockets, Distributed, DataFrames
import Thrift: process, meta, distribute, ThriftMeta, ThriftMetaAttribs
import Base: show
import DataFrames: DataFrame

#### types and enums ####
export TDatum, TColumn, TExecuteMode

#### functions ####
export connect, disconnect
export get_status, get_hardware_info
export get_tables_meta, get_table_details
export get_users, get_databases
export sql_execute, sql_execute_df, sql_execute_gdf
export render_vega
export get_dashboards, get_dashboard_grantees
export create_dashboard, replace_dashboard, delete_dashboard, share_dashboard, unshare_dashboard
export load_table_binary_columnar, load_table_binary_arrow, load_table
export create_table, import_table
export get_roles, get_all_roles_for_user
export get_db_objects_for_grantee, get_db_object_privs
export DataFrame

include("mapd_enums.jl") #hand-maintained code for more convenient enums
include("mapd_types.jl") #slightly modified from Thrift.jl for circular type fix
include("mapd_client.jl") #should be same as output by Thrift.jl, except where methods deleted
include("internal.jl")
include("ipc.jl")
include("misc.jl") #for hand-maintained code
include("dataframes.jl")
include("show.jl")

end # module OmniSci
