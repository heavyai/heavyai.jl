const TSessionId = String
const TQueryId = Int64

mutable struct TDatumVal <: Thrift.TMsg
  int_val::Int64
  real_val::Float64
  str_val::String
  arr_val::Vector{Any}
  TDatumVal() = (o=new(); fillunset(o); o)
end # mutable struct TDatumVal

#https://github.com/tanmaykm/Thrift.jl/issues/37#issuecomment-428024388
function Thrift.meta(t::Type{TDatumVal})
    ThriftMeta(t, [
        ThriftMetaAttribs(1, :int_val, 10, true, Any[], ThriftMeta[])
        ThriftMetaAttribs(2, :real_val, 4, true, Any[], ThriftMeta[])
        ThriftMetaAttribs(3, :str_val, 11, true, Any[], ThriftMeta[])
        ThriftMetaAttribs(4, :arr_val, 15, true, Any[], ThriftMeta[meta(Core.eval(Main, Meta.parse("TDatum")))])
    ])
end

mutable struct TDatum <: Thrift.TMsg
  val::TDatumVal
  is_null::Bool
  TDatum() = (o=new(); fillunset(o); o)
end # mutable struct TDatum

mutable struct TStringValue <: Thrift.TMsg
  str_val::String
  is_null::Bool
  TStringValue() = (o=new(); fillunset(o); o)
end # mutable struct TStringValue

mutable struct TTypeInfo <: Thrift.TMsg
  _type::Int32
  encoding::Int32
  nullable::Bool
  is_array::Bool
  precision::Int32
  scale::Int32
  comp_param::Int32
  size::Int32
  TTypeInfo() = (o=new(); fillunset(o); o)
end # mutable struct TTypeInfo
meta(t::Type{TTypeInfo}) = meta(t, Symbol[:size], Int[1,4,2,3,5,6,7,8], Dict{Symbol,Any}(:size => Int32(-1)))

mutable struct TColumnType <: Thrift.TMsg
  col_name::String
  col_type::TTypeInfo
  is_reserved_keyword::Bool
  src_name::String
  is_system::Bool
  is_physical::Bool
  TColumnType() = (o=new(); fillunset(o); o)
end # mutable struct TColumnType

mutable struct TRow <: Thrift.TMsg
  cols::Vector{TDatum}
  TRow() = (o=new(); fillunset(o); o)
end # mutable struct TRow

mutable struct TColumnData <: Thrift.TMsg
  int_col::Vector{Int64}
  real_col::Vector{Float64}
  str_col::Vector{String}
  arr_col::Vector{Any}
  TColumnData() = (o=new(); fillunset(o); o)
end # mutable struct TColumnData

mutable struct TColumn <: Thrift.TMsg
  data::TColumnData
  nulls::Vector{Bool}
  TColumn() = (o=new(); fillunset(o); o)
end # mutable struct TColumn

function Thrift.meta(t::Type{TColumnData})
    ThriftMeta(t, [
        ThriftMetaAttribs(1, :int_col, 15, true, Any[], ThriftMeta[])
        ThriftMetaAttribs(2, :real_col,15, true, Any[], ThriftMeta[])
        ThriftMetaAttribs(3, :str_col, 15, true, Any[], ThriftMeta[])
        ThriftMetaAttribs(4, :arr_col, 15, true, Any[], ThriftMeta[meta(Core.eval(Main, Meta.parse("TColumn")))])
    ])
end

mutable struct TStringRow <: Thrift.TMsg
  cols::Vector{TStringValue}
  TStringRow() = (o=new(); fillunset(o); o)
end # mutable struct TStringRow

const TRowDescriptor = Vector{TColumnType}
const TTableDescriptor = Dict{String,TColumnType}

mutable struct TRowSet <: Thrift.TMsg
  row_desc::TRowDescriptor
  rows::Vector{TRow}
  columns::Vector{TColumn}
  is_columnar::Bool
  TRowSet() = (o=new(); fillunset(o); o)
end # mutable struct TRowSet

mutable struct TQueryResult <: Thrift.TMsg
  row_set::TRowSet
  execution_time_ms::Int64
  total_time_ms::Int64
  nonce::String
  TQueryResult() = (o=new(); fillunset(o); o)
end # mutable struct TQueryResult

mutable struct TDataFrame <: Thrift.TMsg
  sm_handle::Vector{UInt8}
  sm_size::Int64
  df_handle::Vector{UInt8}
  df_size::Int64
  TDataFrame() = (o=new(); fillunset(o); o)
end # mutable struct TDataFrame

mutable struct TDBInfo <: Thrift.TMsg
  db_name::String
  db_owner::String
  TDBInfo() = (o=new(); fillunset(o); o)
end # mutable struct TDBInfo

mutable struct TMapDException <: Exception
  error_msg::String
  TMapDException() = (o=new(); fillunset(o); o)
end # mutable struct TMapDException

mutable struct TCopyParams <: Thrift.TMsg
  delimiter::String
  null_str::String
  has_header::Bool
  quoted::Bool
  _quote::String
  escape::String
  line_delim::String
  array_delim::String
  array_begin::String
  array_end::String
  threads::Int32
  table_type::Int32
  s3_access_key::String
  s3_secret_key::String
  s3_region::String
  geo_coords_encoding::Int32
  geo_coords_comp_param::Int32
  geo_coords_type::Int32
  geo_coords_srid::Int32
  sanitize_column_names::Bool
  TCopyParams() = (o=new(); fillunset(o); o)
end # mutable struct TCopyParams
meta(t::Type{TCopyParams}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:table_type => Int32(0), :geo_coords_encoding => Int32(6), :geo_coords_comp_param => Int32(32), :geo_coords_type => Int32(18), :geo_coords_srid => Int32(4326), :sanitize_column_names => true))

mutable struct TCreateParams <: Thrift.TMsg
  is_replicated::Bool
  TCreateParams() = (o=new(); fillunset(o); o)
end # mutable struct TCreateParams

mutable struct TDetectResult <: Thrift.TMsg
  row_set::TRowSet
  copy_params::TCopyParams
  TDetectResult() = (o=new(); fillunset(o); o)
end # mutable struct TDetectResult

mutable struct TDashboard <: Thrift.TMsg
  dashboard_name::String
  dashboard_state::String
  image_hash::String
  update_time::String
  dashboard_metadata::String
  dashboard_id::Int32
  dashboard_owner::String
  is_dash_shared::Bool
  TDashboard() = (o=new(); fillunset(o); o)
end # mutable struct TDashboard

mutable struct TServerStatus <: Thrift.TMsg
  read_only::Bool
  version::String
  rendering_enabled::Bool
  start_time::Int64
  edition::String
  host_name::String
  poly_rendering_enabled::Bool
  TServerStatus() = (o=new(); fillunset(o); o)
end # mutable struct TServerStatus

mutable struct TRenderResult <: Thrift.TMsg
  image::Vector{UInt8}
  nonce::String
  execution_time_ms::Int64
  render_time_ms::Int64
  total_time_ms::Int64
  vega_metadata::String
  TRenderResult() = (o=new(); fillunset(o); o)
end # mutable struct TRenderResult

mutable struct TGpuSpecification <: Thrift.TMsg
  num_sm::Int32
  clock_frequency_kHz::Int64
  memory::Int64
  compute_capability_major::Int16
  compute_capability_minor::Int16
  TGpuSpecification() = (o=new(); fillunset(o); o)
end # mutable struct TGpuSpecification

mutable struct THardwareInfo <: Thrift.TMsg
  num_gpu_hw::Int16
  num_cpu_hw::Int16
  num_gpu_allocated::Int16
  start_gpu::Int16
  host_name::String
  gpu_info::Vector{TGpuSpecification}
  THardwareInfo() = (o=new(); fillunset(o); o)
end # mutable struct THardwareInfo

mutable struct TClusterHardwareInfo <: Thrift.TMsg
  hardware_info::Vector{THardwareInfo}
  TClusterHardwareInfo() = (o=new(); fillunset(o); o)
end # mutable struct TClusterHardwareInfo

mutable struct TMemoryData <: Thrift.TMsg
  slab::Int64
  start_page::Int32
  num_pages::Int64
  touch::Int32
  chunk_key::Vector{Int64}
  buffer_epoch::Int32
  is_free::Bool
  TMemoryData() = (o=new(); fillunset(o); o)
end # mutable struct TMemoryData

mutable struct TNodeMemoryInfo <: Thrift.TMsg
  host_name::String
  page_size::Int64
  max_num_pages::Int64
  num_pages_allocated::Int64
  is_allocation_capped::Bool
  node_memory_data::Vector{TMemoryData}
  TNodeMemoryInfo() = (o=new(); fillunset(o); o)
end # mutable struct TNodeMemoryInfo

mutable struct TTableMeta <: Thrift.TMsg
  table_name::String
  num_cols::Int64
  col_datum_types::Vector{Int32}
  is_view::Bool
  is_replicated::Bool
  shard_count::Int64
  max_rows::Int64
  TTableMeta() = (o=new(); fillunset(o); o)
end # mutable struct TTableMeta

mutable struct TTableDetails <: Thrift.TMsg
  row_desc::TRowDescriptor
  fragment_size::Int64
  page_size::Int64
  max_rows::Int64
  view_sql::String
  shard_count::Int64
  key_metainfo::String
  is_temporary::Bool
  partition_detail::Int32
  TTableDetails() = (o=new(); fillunset(o); o)
end # mutable struct TTableDetails

mutable struct TColumnRange <: Thrift.TMsg
  _type::Int32
  col_id::Int32
  table_id::Int32
  has_nulls::Bool
  int_min::Int64
  int_max::Int64
  bucket::Int64
  fp_min::Float64
  fp_max::Float64
  TColumnRange() = (o=new(); fillunset(o); o)
end # mutable struct TColumnRange

mutable struct TDatabasePermissions <: Thrift.TMsg
  create_::Bool
  delete_::Bool
  view_sql_editor_::Bool
  access_::Bool
  TDatabasePermissions() = (o=new(); fillunset(o); o)
end # mutable struct TDatabasePermissions

mutable struct TTablePermissions <: Thrift.TMsg
  create_::Bool
  drop_::Bool
  select_::Bool
  insert_::Bool
  update_::Bool
  delete_::Bool
  truncate_::Bool
  TTablePermissions() = (o=new(); fillunset(o); o)
end # mutable struct TTablePermissions

mutable struct TDashboardPermissions <: Thrift.TMsg
  create_::Bool
  delete_::Bool
  view_::Bool
  edit_::Bool
  TDashboardPermissions() = (o=new(); fillunset(o); o)
end # mutable struct TDashboardPermissions

mutable struct TViewPermissions <: Thrift.TMsg
  create_::Bool
  drop_::Bool
  select_::Bool
  insert_::Bool
  update_::Bool
  delete_::Bool
  TViewPermissions() = (o=new(); fillunset(o); o)
end # mutable struct TViewPermissions

mutable struct TDBObject <: Thrift.TMsg
  objectName::String
  objectType::Int32
  privs::Vector{Bool}
  grantee::String
  TDBObject() = (o=new(); fillunset(o); o)
end # mutable struct TDBObject

mutable struct TDashboardGrantees <: Thrift.TMsg
  name::String
  is_user::Bool
  permissions::TDashboardPermissions
  TDashboardGrantees() = (o=new(); fillunset(o); o)
end # mutable struct TDashboardGrantees

mutable struct TLicenseInfo <: Thrift.TMsg
  claims::Vector{String}
  TLicenseInfo() = (o=new(); fillunset(o); o)
end # mutable struct TLicenseInfo

abstract type MapDClientBase end

# types encapsulating arguments and return values of method connect

mutable struct connect_args <: Thrift.TMsg
  user::String
  passwd::String
  dbname::String
  connect_args() = (o=new(); fillunset(o); o)
end # mutable struct connect_args

mutable struct connect_result
  success::TSessionId
  e::TMapDException
  connect_result() = (o=new(); fillunset(o); o)
  connect_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct connect_result
meta(t::Type{connect_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method disconnect

mutable struct disconnect_args <: Thrift.TMsg
  session::TSessionId
  disconnect_args() = (o=new(); fillunset(o); o)
end # mutable struct disconnect_args

mutable struct disconnect_result
  e::TMapDException
  disconnect_result() = (o=new(); fillunset(o); o)
end # mutable struct disconnect_result
meta(t::Type{disconnect_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_server_status

mutable struct get_server_status_args <: Thrift.TMsg
  session::TSessionId
  get_server_status_args() = (o=new(); fillunset(o); o)
end # mutable struct get_server_status_args

mutable struct get_server_status_result
  success::TServerStatus
  e::TMapDException
  get_server_status_result() = (o=new(); fillunset(o); o)
  get_server_status_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_server_status_result
meta(t::Type{get_server_status_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_status

mutable struct get_status_args <: Thrift.TMsg
  session::TSessionId
  get_status_args() = (o=new(); fillunset(o); o)
end # mutable struct get_status_args

mutable struct get_status_result
  success::Vector{TServerStatus}
  e::TMapDException
  get_status_result() = (o=new(); fillunset(o); o)
  get_status_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_status_result
meta(t::Type{get_status_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_hardware_info

mutable struct get_hardware_info_args <: Thrift.TMsg
  session::TSessionId
  get_hardware_info_args() = (o=new(); fillunset(o); o)
end # mutable struct get_hardware_info_args

mutable struct get_hardware_info_result
  success::TClusterHardwareInfo
  e::TMapDException
  get_hardware_info_result() = (o=new(); fillunset(o); o)
  get_hardware_info_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_hardware_info_result
meta(t::Type{get_hardware_info_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_tables

mutable struct get_tables_args <: Thrift.TMsg
  session::TSessionId
  get_tables_args() = (o=new(); fillunset(o); o)
end # mutable struct get_tables_args

mutable struct get_tables_result
  success::Vector{String}
  e::TMapDException
  get_tables_result() = (o=new(); fillunset(o); o)
  get_tables_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_tables_result
meta(t::Type{get_tables_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_tables_meta

mutable struct get_tables_meta_args <: Thrift.TMsg
  session::TSessionId
  get_tables_meta_args() = (o=new(); fillunset(o); o)
end # mutable struct get_tables_meta_args

mutable struct get_tables_meta_result
  success::Vector{TTableMeta}
  e::TMapDException
  get_tables_meta_result() = (o=new(); fillunset(o); o)
  get_tables_meta_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_tables_meta_result
meta(t::Type{get_tables_meta_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_table_details

mutable struct get_table_details_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  get_table_details_args() = (o=new(); fillunset(o); o)
end # mutable struct get_table_details_args

mutable struct get_table_details_result
  success::TTableDetails
  e::TMapDException
  get_table_details_result() = (o=new(); fillunset(o); o)
  get_table_details_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_table_details_result
meta(t::Type{get_table_details_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_users

mutable struct get_users_args <: Thrift.TMsg
  session::TSessionId
  get_users_args() = (o=new(); fillunset(o); o)
end # mutable struct get_users_args

mutable struct get_users_result
  success::Vector{String}
  e::TMapDException
  get_users_result() = (o=new(); fillunset(o); o)
  get_users_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_users_result
meta(t::Type{get_users_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_databases

mutable struct get_databases_args <: Thrift.TMsg
  session::TSessionId
  get_databases_args() = (o=new(); fillunset(o); o)
end # mutable struct get_databases_args

mutable struct get_databases_result
  success::Vector{TDBInfo}
  e::TMapDException
  get_databases_result() = (o=new(); fillunset(o); o)
  get_databases_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_databases_result
meta(t::Type{get_databases_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_memory

mutable struct get_memory_args <: Thrift.TMsg
  session::TSessionId
  memory_level::String
  get_memory_args() = (o=new(); fillunset(o); o)
end # mutable struct get_memory_args

mutable struct get_memory_result
  success::Vector{TNodeMemoryInfo}
  e::TMapDException
  get_memory_result() = (o=new(); fillunset(o); o)
  get_memory_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_memory_result
meta(t::Type{get_memory_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method clear_cpu_memory

mutable struct clear_cpu_memory_args <: Thrift.TMsg
  session::TSessionId
  clear_cpu_memory_args() = (o=new(); fillunset(o); o)
end # mutable struct clear_cpu_memory_args

mutable struct clear_cpu_memory_result
  e::TMapDException
  clear_cpu_memory_result() = (o=new(); fillunset(o); o)
end # mutable struct clear_cpu_memory_result
meta(t::Type{clear_cpu_memory_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method clear_gpu_memory

mutable struct clear_gpu_memory_args <: Thrift.TMsg
  session::TSessionId
  clear_gpu_memory_args() = (o=new(); fillunset(o); o)
end # mutable struct clear_gpu_memory_args

mutable struct clear_gpu_memory_result
  e::TMapDException
  clear_gpu_memory_result() = (o=new(); fillunset(o); o)
end # mutable struct clear_gpu_memory_result
meta(t::Type{clear_gpu_memory_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method sql_execute

mutable struct sql_execute_args <: Thrift.TMsg
  session::TSessionId
  query::String
  column_format::Bool
  nonce::String
  first_n::Int32
  at_most_n::Int32
  sql_execute_args() = (o=new(); fillunset(o); o)
end # mutable struct sql_execute_args
meta(t::Type{sql_execute_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:first_n => Int32(-1), :at_most_n => Int32(-1)))

mutable struct sql_execute_result
  success::TQueryResult
  e::TMapDException
  sql_execute_result() = (o=new(); fillunset(o); o)
  sql_execute_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct sql_execute_result
meta(t::Type{sql_execute_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method sql_execute_df

mutable struct sql_execute_df_args <: Thrift.TMsg
  session::TSessionId
  query::String
  device_type::Int32
  device_id::Int32
  first_n::Int32
  sql_execute_df_args() = (o=new(); fillunset(o); o)
end # mutable struct sql_execute_df_args
meta(t::Type{sql_execute_df_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:device_id => Int32(0), :first_n => Int32(-1)))

mutable struct sql_execute_df_result
  success::TDataFrame
  e::TMapDException
  sql_execute_df_result() = (o=new(); fillunset(o); o)
  sql_execute_df_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct sql_execute_df_result
meta(t::Type{sql_execute_df_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method sql_execute_gdf

mutable struct sql_execute_gdf_args <: Thrift.TMsg
  session::TSessionId
  query::String
  device_id::Int32
  first_n::Int32
  sql_execute_gdf_args() = (o=new(); fillunset(o); o)
end # mutable struct sql_execute_gdf_args
meta(t::Type{sql_execute_gdf_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:device_id => Int32(0), :first_n => Int32(-1)))

mutable struct sql_execute_gdf_result
  success::TDataFrame
  e::TMapDException
  sql_execute_gdf_result() = (o=new(); fillunset(o); o)
  sql_execute_gdf_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct sql_execute_gdf_result
meta(t::Type{sql_execute_gdf_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method deallocate_df

mutable struct deallocate_df_args <: Thrift.TMsg
  session::TSessionId
  df::TDataFrame
  device_type::Int32
  device_id::Int32
  deallocate_df_args() = (o=new(); fillunset(o); o)
end # mutable struct deallocate_df_args
meta(t::Type{deallocate_df_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:device_id => Int32(0)))

mutable struct deallocate_df_result
  e::TMapDException
  deallocate_df_result() = (o=new(); fillunset(o); o)
end # mutable struct deallocate_df_result
meta(t::Type{deallocate_df_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method interrupt

mutable struct interrupt_args <: Thrift.TMsg
  session::TSessionId
  interrupt_args() = (o=new(); fillunset(o); o)
end # mutable struct interrupt_args

mutable struct interrupt_result
  e::TMapDException
  interrupt_result() = (o=new(); fillunset(o); o)
end # mutable struct interrupt_result
meta(t::Type{interrupt_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method set_execution_mode

mutable struct set_execution_mode_args <: Thrift.TMsg
  session::TSessionId
  mode::Int32
  set_execution_mode_args() = (o=new(); fillunset(o); o)
end # mutable struct set_execution_mode_args

mutable struct set_execution_mode_result
  e::TMapDException
  set_execution_mode_result() = (o=new(); fillunset(o); o)
end # mutable struct set_execution_mode_result
meta(t::Type{set_execution_mode_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method render_vega

mutable struct render_vega_args <: Thrift.TMsg
  session::TSessionId
  widget_id::Int64
  vega_json::String
  compression_level::Int32
  nonce::String
  render_vega_args() = (o=new(); fillunset(o); o)
end # mutable struct render_vega_args

mutable struct render_vega_result
  success::TRenderResult
  e::TMapDException
  render_vega_result() = (o=new(); fillunset(o); o)
  render_vega_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct render_vega_result
meta(t::Type{render_vega_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_dashboard

mutable struct get_dashboard_args <: Thrift.TMsg
  session::TSessionId
  dashboard_id::Int32
  get_dashboard_args() = (o=new(); fillunset(o); o)
end # mutable struct get_dashboard_args

mutable struct get_dashboard_result
  success::TDashboard
  e::TMapDException
  get_dashboard_result() = (o=new(); fillunset(o); o)
  get_dashboard_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_dashboard_result
meta(t::Type{get_dashboard_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_dashboards

mutable struct get_dashboards_args <: Thrift.TMsg
  session::TSessionId
  get_dashboards_args() = (o=new(); fillunset(o); o)
end # mutable struct get_dashboards_args

mutable struct get_dashboards_result
  success::Vector{TDashboard}
  e::TMapDException
  get_dashboards_result() = (o=new(); fillunset(o); o)
  get_dashboards_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_dashboards_result
meta(t::Type{get_dashboards_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method create_dashboard

mutable struct create_dashboard_args <: Thrift.TMsg
  session::TSessionId
  dashboard_name::String
  dashboard_state::String
  image_hash::String
  dashboard_metadata::String
  create_dashboard_args() = (o=new(); fillunset(o); o)
end # mutable struct create_dashboard_args

mutable struct create_dashboard_result
  success::Int32
  e::TMapDException
  create_dashboard_result() = (o=new(); fillunset(o); o)
  create_dashboard_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct create_dashboard_result
meta(t::Type{create_dashboard_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())
# types encapsulating arguments and return values of method get_dashboard_grantees

mutable struct get_dashboard_grantees_args <: Thrift.TMsg
  session::TSessionId
  dashboard_id::Int32
  get_dashboard_grantees_args() = (o=new(); fillunset(o); o)
end # mutable struct get_dashboard_grantees_args

mutable struct get_dashboard_grantees_result
  success::Vector{TDashboardGrantees}
  e::TMapDException
  get_dashboard_grantees_result() = (o=new(); fillunset(o); o)
  get_dashboard_grantees_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_dashboard_grantees_result
meta(t::Type{get_dashboard_grantees_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method load_table_binary_columnar

mutable struct load_table_binary_columnar_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  cols::Vector{TColumn}
  load_table_binary_columnar_args() = (o=new(); fillunset(o); o)
end # mutable struct load_table_binary_columnar_args

mutable struct load_table_binary_columnar_result
  e::TMapDException
  load_table_binary_columnar_result() = (o=new(); fillunset(o); o)
end # mutable struct load_table_binary_columnar_result
meta(t::Type{load_table_binary_columnar_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method load_table_binary_arrow

mutable struct load_table_binary_arrow_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  arrow_stream::Vector{UInt8}
  load_table_binary_arrow_args() = (o=new(); fillunset(o); o)
end # mutable struct load_table_binary_arrow_args

mutable struct load_table_binary_arrow_result
  e::TMapDException
  load_table_binary_arrow_result() = (o=new(); fillunset(o); o)
end # mutable struct load_table_binary_arrow_result
meta(t::Type{load_table_binary_arrow_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method load_table

mutable struct load_table_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  rows::Vector{TStringRow}
  load_table_args() = (o=new(); fillunset(o); o)
end # mutable struct load_table_args

mutable struct load_table_result
  e::TMapDException
  load_table_result() = (o=new(); fillunset(o); o)
end # mutable struct load_table_result
meta(t::Type{load_table_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method create_table

# mutable struct create_table_args <: Thrift.TMsg
#   session::TSessionId
#   table_name::String
#   row_desc::TRowDescriptor
#   table_type::Int32
#   create_params::TCreateParams
#   create_table_args() = (o=new(); fillunset(o); o)
# end # mutable struct create_table_args
# meta(t::Type{create_table_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:table_type => Int32(0)))
#
# mutable struct create_table_result
#   e::TMapDException
#   create_table_result() = (o=new(); fillunset(o); o)
# end # mutable struct create_table_result
# meta(t::Type{create_table_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_roles

mutable struct get_roles_args <: Thrift.TMsg
  session::TSessionId
  get_roles_args() = (o=new(); fillunset(o); o)
end # mutable struct get_roles_args

mutable struct get_roles_result
  success::Vector{String}
  e::TMapDException
  get_roles_result() = (o=new(); fillunset(o); o)
  get_roles_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_roles_result
meta(t::Type{get_roles_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_all_roles_for_user

mutable struct get_all_roles_for_user_args <: Thrift.TMsg
  session::TSessionId
  userName::String
  get_all_roles_for_user_args() = (o=new(); fillunset(o); o)
end # mutable struct get_all_roles_for_user_args

mutable struct get_all_roles_for_user_result
  success::Vector{String}
  e::TMapDException
  get_all_roles_for_user_result() = (o=new(); fillunset(o); o)
  get_all_roles_for_user_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_all_roles_for_user_result
meta(t::Type{get_all_roles_for_user_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method set_license_key

mutable struct set_license_key_args <: Thrift.TMsg
  session::TSessionId
  key::String
  nonce::String
  set_license_key_args() = (o=new(); fillunset(o); o)
end # mutable struct set_license_key_args
meta(t::Type{set_license_key_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:nonce => ""))

mutable struct set_license_key_result
  success::TLicenseInfo
  e::TMapDException
  set_license_key_result() = (o=new(); fillunset(o); o)
  set_license_key_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct set_license_key_result
meta(t::Type{set_license_key_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_license_claims

mutable struct get_license_claims_args <: Thrift.TMsg
  session::TSessionId
  nonce::String
  get_license_claims_args() = (o=new(); fillunset(o); o)
end # mutable struct get_license_claims_args
meta(t::Type{get_license_claims_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:nonce => ""))

mutable struct get_license_claims_result
  success::TLicenseInfo
  e::TMapDException
  get_license_claims_result() = (o=new(); fillunset(o); o)
  get_license_claims_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_license_claims_result
meta(t::Type{get_license_claims_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# Client implementation for MapD service
mutable struct MapDClient <: MapDClientBase
  p::TProtocol
  seqid::Int32
  MapDClient(p::TProtocol) = new(p, 0)
end # mutable struct MapDClient
