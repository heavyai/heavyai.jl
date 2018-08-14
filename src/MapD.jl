__precompile__()

module MapD

using Compat, Thrift, Sockets, Distributed
import Thrift: process, meta, distribute
import Base: connect, interrupt

#### enums ####
export TDatumType, TExecuteMode, TEncodingType, TDeviceType, TTableType, TPartitionDetail,
TMergeType, TExpressionRangeType, TDBObjectType

#### typealiases ####
export TRowDescriptor # typealias for Vector{TColumnType}
export TTableDescriptor # typealias for Dict{String,TColumnType}
export TSessionId # typealias for String
export TQueryId # typealias for Int64
export TRenderPassMap # typealias for Dict{Int32,TRawRenderPassDataResult}
export TRenderDataAggMap # typealias for Dict{String,Dict{String,Dict{String,Dict{String,Vector{TRenderDatum}}}}}

#### types ####
export TDatumVal, TDatum, TStringValue, TTypeInfo, TColumnType, TRow, TColumnData,
TColumn, TStringRow, TStepResult, TRowSet, TQueryResult, TDataFrame, TDBInfo,
TMapDException, TCopyParams, TDetectResult, TImportStatus, TFrontendView, TDashboard,
TServerStatus, TPixel, TPixelTableRowResult, TRenderResult, TGpuSpecification,
THardwareInfo, TClusterHardwareInfo, TMemoryData, TNodeMemoryInfo, TTableMeta,
TTableDetails, TColumnRange, TDictionaryGeneration, TTableGeneration, TPendingQuery,
TVarLen, TDataBlockPtr, TInsertData, TPendingRenderQuery, TRenderParseResult,
TRawRenderPassDataResult, TRawPixelData, TRenderDatum, TRenderStepResult, TDatabasePermissions,
TTablePermissions, TDashboardPermissions, TViewPermissions, TDBObject, TDashboardGrantees,
TLicenseInfo, MapDConnection

#### functions ####
export MapDProcessor, MapDClient, MapDClientBase, connect, disconnect,
get_status, get_hardware_info, get_tables, get_physical_tables, get_views, get_tables_meta,
get_table_details, get_users, get_databases, get_version, get_memory, clear_cpu_memory,
clear_gpu_memory, sql_execute, sql_execute_df, sql_execute_gdf, deallocate_df,
interrupt, sql_validate, set_execution_mode, render_vega, get_frontend_view,
get_frontend_views, create_frontend_view, delete_frontend_view, get_dashboard,
get_dashboards, create_dashboard, replace_dashboard, delete_dashboard,
share_dashboard, unshare_dashboard, get_dashboard_grantees,
load_table_binary, load_table_binary_columnar, load_table_binary_arrow,
load_table, detect_column_types, create_table, import_table, import_geo_table,
import_table_status, get_roles, get_db_objects_for_grantee, get_db_object_privs,
get_all_roles_for_user, set_license_key, get_license_claims

include("mapd_constants.jl")
include("mapd_enums.jl")
include("mapd_types.jl")
include("mapd_client.jl")
include("misc.jl") #for hand-maintained code

end # module MapD
