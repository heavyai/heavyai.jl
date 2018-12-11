module OmniSci

using Thrift, Random, Sockets, Distributed, DataFrames, Dates, DecFP, GeoInterface, LibGEOS
import Thrift: process, meta, distribute, ThriftMeta, ThriftMetaAttribs
import Base: show, convert
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
export load_table_binary_columnar, load_table_binary_arrow, load_table
export create_table, import_table
export get_roles, get_all_roles_for_user
export DataFrame

#Thrift interface code, mostly generated from Thrift.jl
include("thrift_code/enums.jl") #hand-maintained code for more convenient enums
include("thrift_code/types.jl") #slightly modified from Thrift.jl for circular type fix
include("thrift_code/client.jl") #same as output by Thrift.jl, except where methods deleted

#Package code
include("internal.jl")
include("ipc.jl")
include("client.jl")
include("dataframe_show.jl")

end # module OmniSci
