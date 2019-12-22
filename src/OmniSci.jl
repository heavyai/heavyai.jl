module OmniSci

using Thrift, Random, Sockets, Dates, DecFP, GeoInterface, LibGEOS, Decimals, Tables
import Thrift: process, meta, distribute, ThriftMeta, ThriftMetaAttribs
import Base: show, convert
import DataFrames: DataFrame, rename!

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
include("common/common_types.jl")
include("completion_hints/completion_hints_types.jl")
include("serialized_result_set/serialized_result_set_types.jl")
include("extension_functions/extension_functions_types.jl")
include("mapd/mapd_types.jl")
include("mapd/MapD.jl")

#Package code
include("enums.jl") #hand-maintained code for more convenient enums
include("constructors.jl")
include("ipc.jl")
include("client.jl")
include("dataframe_show.jl")

end # module OmniSci
