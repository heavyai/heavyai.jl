const TSessionId = String
const TQueryId = Int64

mutable struct TDatumVal <: Thrift.TMsg
  int_val::Int64
  real_val::Float64
  str_val::String
  arr_val::AbstractVector
  TDatumVal() = (o=new(); fillunset(o); o)
end # mutable struct TDatumVal

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
  arr_col::AbstractVector
  TColumnData() = (o=new(); fillunset(o); o)
end # mutable struct TColumnData

mutable struct TColumn <: Thrift.TMsg
  data::TColumnData
  nulls::Vector{Bool}
  TColumn() = (o=new(); fillunset(o); o)
end # mutable struct TColumn

mutable struct TStringRow <: Thrift.TMsg
  cols::Vector{TStringValue}
  TStringRow() = (o=new(); fillunset(o); o)
end # mutable struct TStringRow

const TRowDescriptor = Vector{TColumnType}
const TTableDescriptor = Dict{String,TColumnType}

mutable struct TStepResult <: Thrift.TMsg
  serialized_rows::String
  execution_finished::Bool
  merge_type::Int32
  sharded::Bool
  row_desc::TRowDescriptor
  node_id::Int32
  TStepResult() = (o=new(); fillunset(o); o)
end # mutable struct TStepResult

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

mutable struct TImportStatus <: Thrift.TMsg
  elapsed::Int64
  rows_completed::Int64
  rows_estimated::Int64
  rows_rejected::Int64
  TImportStatus() = (o=new(); fillunset(o); o)
end # mutable struct TImportStatus

mutable struct TFrontendView <: Thrift.TMsg
  view_name::String
  view_state::String
  image_hash::String
  update_time::String
  view_metadata::String
  TFrontendView() = (o=new(); fillunset(o); o)
end # mutable struct TFrontendView

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

mutable struct TPixel <: Thrift.TMsg
  x::Int64
  y::Int64
  TPixel() = (o=new(); fillunset(o); o)
end # mutable struct TPixel

mutable struct TPixelTableRowResult <: Thrift.TMsg
  pixel::TPixel
  vega_table_name::String
  table_id::Int64
  row_id::Int64
  row_set::TRowSet
  nonce::String
  TPixelTableRowResult() = (o=new(); fillunset(o); o)
end # mutable struct TPixelTableRowResult

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

mutable struct TDictionaryGeneration <: Thrift.TMsg
  dict_id::Int32
  entry_count::Int64
  TDictionaryGeneration() = (o=new(); fillunset(o); o)
end # mutable struct TDictionaryGeneration

mutable struct TTableGeneration <: Thrift.TMsg
  table_id::Int32
  tuple_count::Int64
  start_rowid::Int64
  TTableGeneration() = (o=new(); fillunset(o); o)
end # mutable struct TTableGeneration

mutable struct TPendingQuery <: Thrift.TMsg
  id::TQueryId
  column_ranges::Vector{TColumnRange}
  dictionary_generations::Vector{TDictionaryGeneration}
  table_generations::Vector{TTableGeneration}
  TPendingQuery() = (o=new(); fillunset(o); o)
end # mutable struct TPendingQuery

mutable struct TVarLen <: Thrift.TMsg
  payload::Vector{UInt8}
  is_null::Bool
  TVarLen() = (o=new(); fillunset(o); o)
end # mutable struct TVarLen

mutable struct TDataBlockPtr <: Thrift.TMsg
  fixed_len_data::Vector{UInt8}
  var_len_data::Vector{TVarLen}
  TDataBlockPtr() = (o=new(); fillunset(o); o)
end # mutable struct TDataBlockPtr
meta(t::Type{TDataBlockPtr}) = meta(t, Symbol[:fixed_len_data,:var_len_data], Int[], Dict{Symbol,Any}())

mutable struct TInsertData <: Thrift.TMsg
  db_id::Int32
  table_id::Int32
  column_ids::Vector{Int32}
  data::Vector{TDataBlockPtr}
  num_rows::Int64
  TInsertData() = (o=new(); fillunset(o); o)
end # mutable struct TInsertData

mutable struct TPendingRenderQuery <: Thrift.TMsg
  id::TQueryId
  TPendingRenderQuery() = (o=new(); fillunset(o); o)
end # mutable struct TPendingRenderQuery

mutable struct TRenderParseResult <: Thrift.TMsg
  merge_type::Int32
  node_id::Int32
  execution_time_ms::Int64
  render_time_ms::Int64
  total_time_ms::Int64
  TRenderParseResult() = (o=new(); fillunset(o); o)
end # mutable struct TRenderParseResult

mutable struct TRawRenderPassDataResult <: Thrift.TMsg
  num_channels::Int32
  pixels::Vector{UInt8}
  row_ids_A::Vector{UInt8}
  row_ids_B::Vector{UInt8}
  table_ids::Vector{UInt8}
  accum_data::Vector{UInt8}
  TRawRenderPassDataResult() = (o=new(); fillunset(o); o)
end # mutable struct TRawRenderPassDataResult

const TRenderPassMap = Dict{Int32,TRawRenderPassDataResult}

mutable struct TRawPixelData <: Thrift.TMsg
  width::Int32
  height::Int32
  render_pass_map::TRenderPassMap
  TRawPixelData() = (o=new(); fillunset(o); o)
end # mutable struct TRawPixelData

mutable struct TRenderDatum <: Thrift.TMsg
  _type::Int32
  cnt::Int32
  value::Vector{UInt8}
  TRenderDatum() = (o=new(); fillunset(o); o)
end # mutable struct TRenderDatum

const TRenderAggDataMap = Dict{String,Dict{String,Dict{String,Dict{String,Vector{TRenderDatum}}}}}

mutable struct TRenderStepResult <: Thrift.TMsg
  merge_data::TRenderAggDataMap
  raw_pixel_data::TRawPixelData
  execution_time_ms::Int64
  render_time_ms::Int64
  total_time_ms::Int64
  TRenderStepResult() = (o=new(); fillunset(o); o)
end # mutable struct TRenderStepResult

mutable struct TDatabasePermissions <: Thrift.TMsg
  create_::Bool
  delete_::Bool
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

# types encapsulating arguments and return values of method get_physical_tables

mutable struct get_physical_tables_args <: Thrift.TMsg
  session::TSessionId
  get_physical_tables_args() = (o=new(); fillunset(o); o)
end # mutable struct get_physical_tables_args

mutable struct get_physical_tables_result
  success::Vector{String}
  e::TMapDException
  get_physical_tables_result() = (o=new(); fillunset(o); o)
  get_physical_tables_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_physical_tables_result
meta(t::Type{get_physical_tables_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_views

mutable struct get_views_args <: Thrift.TMsg
  session::TSessionId
  get_views_args() = (o=new(); fillunset(o); o)
end # mutable struct get_views_args

mutable struct get_views_result
  success::Vector{String}
  e::TMapDException
  get_views_result() = (o=new(); fillunset(o); o)
  get_views_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_views_result
meta(t::Type{get_views_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method get_internal_table_details

mutable struct get_internal_table_details_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  get_internal_table_details_args() = (o=new(); fillunset(o); o)
end # mutable struct get_internal_table_details_args

mutable struct get_internal_table_details_result
  success::TTableDetails
  e::TMapDException
  get_internal_table_details_result() = (o=new(); fillunset(o); o)
  get_internal_table_details_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_internal_table_details_result
meta(t::Type{get_internal_table_details_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method get_version

mutable struct get_version_args <: Thrift.TMsg
end # mutable struct get_version_args

mutable struct get_version_result
  success::String
  e::TMapDException
  get_version_result() = (o=new(); fillunset(o); o)
  get_version_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_version_result
meta(t::Type{get_version_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method start_heap_profile

mutable struct start_heap_profile_args <: Thrift.TMsg
  session::TSessionId
  start_heap_profile_args() = (o=new(); fillunset(o); o)
end # mutable struct start_heap_profile_args

mutable struct start_heap_profile_result
  e::TMapDException
  start_heap_profile_result() = (o=new(); fillunset(o); o)
end # mutable struct start_heap_profile_result
meta(t::Type{start_heap_profile_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method stop_heap_profile

mutable struct stop_heap_profile_args <: Thrift.TMsg
  session::TSessionId
  stop_heap_profile_args() = (o=new(); fillunset(o); o)
end # mutable struct stop_heap_profile_args

mutable struct stop_heap_profile_result
  e::TMapDException
  stop_heap_profile_result() = (o=new(); fillunset(o); o)
end # mutable struct stop_heap_profile_result
meta(t::Type{stop_heap_profile_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_heap_profile

mutable struct get_heap_profile_args <: Thrift.TMsg
  session::TSessionId
  get_heap_profile_args() = (o=new(); fillunset(o); o)
end # mutable struct get_heap_profile_args

mutable struct get_heap_profile_result
  success::String
  e::TMapDException
  get_heap_profile_result() = (o=new(); fillunset(o); o)
  get_heap_profile_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_heap_profile_result
meta(t::Type{get_heap_profile_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method set_table_epoch

mutable struct set_table_epoch_args <: Thrift.TMsg
  session::TSessionId
  db_id::Int32
  table_id::Int32
  new_epoch::Int32
  set_table_epoch_args() = (o=new(); fillunset(o); o)
end # mutable struct set_table_epoch_args

mutable struct set_table_epoch_result
  e::TMapDException
  set_table_epoch_result() = (o=new(); fillunset(o); o)
end # mutable struct set_table_epoch_result
meta(t::Type{set_table_epoch_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method set_table_epoch_by_name

mutable struct set_table_epoch_by_name_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  new_epoch::Int32
  set_table_epoch_by_name_args() = (o=new(); fillunset(o); o)
end # mutable struct set_table_epoch_by_name_args

mutable struct set_table_epoch_by_name_result
  e::TMapDException
  set_table_epoch_by_name_result() = (o=new(); fillunset(o); o)
end # mutable struct set_table_epoch_by_name_result
meta(t::Type{set_table_epoch_by_name_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_table_epoch

mutable struct get_table_epoch_args <: Thrift.TMsg
  session::TSessionId
  db_id::Int32
  table_id::Int32
  get_table_epoch_args() = (o=new(); fillunset(o); o)
end # mutable struct get_table_epoch_args

mutable struct get_table_epoch_result
  success::Int32
  get_table_epoch_result() = (o=new(); fillunset(o); o)
  get_table_epoch_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_table_epoch_result
meta(t::Type{get_table_epoch_result}) = meta(t, Symbol[:success], Int[0], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_table_epoch_by_name

mutable struct get_table_epoch_by_name_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  get_table_epoch_by_name_args() = (o=new(); fillunset(o); o)
end # mutable struct get_table_epoch_by_name_args

mutable struct get_table_epoch_by_name_result
  success::Int32
  get_table_epoch_by_name_result() = (o=new(); fillunset(o); o)
  get_table_epoch_by_name_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_table_epoch_by_name_result
meta(t::Type{get_table_epoch_by_name_result}) = meta(t, Symbol[:success], Int[0], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method sql_validate

mutable struct sql_validate_args <: Thrift.TMsg
  session::TSessionId
  query::String
  sql_validate_args() = (o=new(); fillunset(o); o)
end # mutable struct sql_validate_args

mutable struct sql_validate_result
  success::TTableDescriptor
  e::TMapDException
  sql_validate_result() = (o=new(); fillunset(o); o)
  sql_validate_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct sql_validate_result
meta(t::Type{sql_validate_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_completion_hints

mutable struct get_completion_hints_args <: Thrift.TMsg
  session::TSessionId
  sql::String
  cursor::Int32
  get_completion_hints_args() = (o=new(); fillunset(o); o)
end # mutable struct get_completion_hints_args

mutable struct get_completion_hints_result
  success::AbstractVector
  e::TMapDException
  get_completion_hints_result() = (o=new(); fillunset(o); o)
  get_completion_hints_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_completion_hints_result
meta(t::Type{get_completion_hints_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method get_result_row_for_pixel

mutable struct get_result_row_for_pixel_args <: Thrift.TMsg
  session::TSessionId
  widget_id::Int64
  pixel::TPixel
  table_col_names::Dict{String,Vector{String}}
  column_format::Bool
  pixelRadius::Int32
  nonce::String
  get_result_row_for_pixel_args() = (o=new(); fillunset(o); o)
end # mutable struct get_result_row_for_pixel_args

mutable struct get_result_row_for_pixel_result
  success::TPixelTableRowResult
  e::TMapDException
  get_result_row_for_pixel_result() = (o=new(); fillunset(o); o)
  get_result_row_for_pixel_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_result_row_for_pixel_result
meta(t::Type{get_result_row_for_pixel_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_frontend_view

mutable struct get_frontend_view_args <: Thrift.TMsg
  session::TSessionId
  view_name::String
  get_frontend_view_args() = (o=new(); fillunset(o); o)
end # mutable struct get_frontend_view_args

mutable struct get_frontend_view_result
  success::TFrontendView
  e::TMapDException
  get_frontend_view_result() = (o=new(); fillunset(o); o)
  get_frontend_view_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_frontend_view_result
meta(t::Type{get_frontend_view_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_frontend_views

mutable struct get_frontend_views_args <: Thrift.TMsg
  session::TSessionId
  get_frontend_views_args() = (o=new(); fillunset(o); o)
end # mutable struct get_frontend_views_args

mutable struct get_frontend_views_result
  success::Vector{TFrontendView}
  e::TMapDException
  get_frontend_views_result() = (o=new(); fillunset(o); o)
  get_frontend_views_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_frontend_views_result
meta(t::Type{get_frontend_views_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method create_frontend_view

mutable struct create_frontend_view_args <: Thrift.TMsg
  session::TSessionId
  view_name::String
  view_state::String
  image_hash::String
  view_metadata::String
  create_frontend_view_args() = (o=new(); fillunset(o); o)
end # mutable struct create_frontend_view_args

mutable struct create_frontend_view_result
  e::TMapDException
  create_frontend_view_result() = (o=new(); fillunset(o); o)
end # mutable struct create_frontend_view_result
meta(t::Type{create_frontend_view_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method delete_frontend_view

mutable struct delete_frontend_view_args <: Thrift.TMsg
  session::TSessionId
  view_name::String
  delete_frontend_view_args() = (o=new(); fillunset(o); o)
end # mutable struct delete_frontend_view_args

mutable struct delete_frontend_view_result
  e::TMapDException
  delete_frontend_view_result() = (o=new(); fillunset(o); o)
end # mutable struct delete_frontend_view_result
meta(t::Type{delete_frontend_view_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method replace_dashboard

mutable struct replace_dashboard_args <: Thrift.TMsg
  session::TSessionId
  dashboard_id::Int32
  dashboard_name::String
  dashboard_owner::String
  dashboard_state::String
  image_hash::String
  dashboard_metadata::String
  replace_dashboard_args() = (o=new(); fillunset(o); o)
end # mutable struct replace_dashboard_args

mutable struct replace_dashboard_result
  e::TMapDException
  replace_dashboard_result() = (o=new(); fillunset(o); o)
end # mutable struct replace_dashboard_result
meta(t::Type{replace_dashboard_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method delete_dashboard

mutable struct delete_dashboard_args <: Thrift.TMsg
  session::TSessionId
  dashboard_id::Int32
  delete_dashboard_args() = (o=new(); fillunset(o); o)
end # mutable struct delete_dashboard_args

mutable struct delete_dashboard_result
  e::TMapDException
  delete_dashboard_result() = (o=new(); fillunset(o); o)
end # mutable struct delete_dashboard_result
meta(t::Type{delete_dashboard_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method share_dashboard

mutable struct share_dashboard_args <: Thrift.TMsg
  session::TSessionId
  dashboard_id::Int32
  groups::Vector{String}
  objects::Vector{String}
  permissions::TDashboardPermissions
  share_dashboard_args() = (o=new(); fillunset(o); o)
end # mutable struct share_dashboard_args

mutable struct share_dashboard_result
  e::TMapDException
  share_dashboard_result() = (o=new(); fillunset(o); o)
end # mutable struct share_dashboard_result
meta(t::Type{share_dashboard_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method unshare_dashboard

mutable struct unshare_dashboard_args <: Thrift.TMsg
  session::TSessionId
  dashboard_id::Int32
  groups::Vector{String}
  objects::Vector{String}
  permissions::TDashboardPermissions
  unshare_dashboard_args() = (o=new(); fillunset(o); o)
end # mutable struct unshare_dashboard_args

mutable struct unshare_dashboard_result
  e::TMapDException
  unshare_dashboard_result() = (o=new(); fillunset(o); o)
end # mutable struct unshare_dashboard_result
meta(t::Type{unshare_dashboard_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method get_link_view

mutable struct get_link_view_args <: Thrift.TMsg
  session::TSessionId
  link::String
  get_link_view_args() = (o=new(); fillunset(o); o)
end # mutable struct get_link_view_args

mutable struct get_link_view_result
  success::TFrontendView
  e::TMapDException
  get_link_view_result() = (o=new(); fillunset(o); o)
  get_link_view_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_link_view_result
meta(t::Type{get_link_view_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method create_link

mutable struct create_link_args <: Thrift.TMsg
  session::TSessionId
  view_state::String
  view_metadata::String
  create_link_args() = (o=new(); fillunset(o); o)
end # mutable struct create_link_args

mutable struct create_link_result
  success::String
  e::TMapDException
  create_link_result() = (o=new(); fillunset(o); o)
  create_link_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct create_link_result
meta(t::Type{create_link_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method load_table_binary

mutable struct load_table_binary_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  rows::Vector{TRow}
  load_table_binary_args() = (o=new(); fillunset(o); o)
end # mutable struct load_table_binary_args

mutable struct load_table_binary_result
  e::TMapDException
  load_table_binary_result() = (o=new(); fillunset(o); o)
end # mutable struct load_table_binary_result
meta(t::Type{load_table_binary_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method detect_column_types

mutable struct detect_column_types_args <: Thrift.TMsg
  session::TSessionId
  file_name::String
  copy_params::TCopyParams
  detect_column_types_args() = (o=new(); fillunset(o); o)
end # mutable struct detect_column_types_args

mutable struct detect_column_types_result
  success::TDetectResult
  e::TMapDException
  detect_column_types_result() = (o=new(); fillunset(o); o)
  detect_column_types_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct detect_column_types_result
meta(t::Type{detect_column_types_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method create_table

mutable struct create_table_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  row_desc::TRowDescriptor
  table_type::Int32
  create_table_args() = (o=new(); fillunset(o); o)
end # mutable struct create_table_args
meta(t::Type{create_table_args}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:table_type => Int32(0)))

mutable struct create_table_result
  e::TMapDException
  create_table_result() = (o=new(); fillunset(o); o)
end # mutable struct create_table_result
meta(t::Type{create_table_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method import_table

mutable struct import_table_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  file_name::String
  copy_params::TCopyParams
  import_table_args() = (o=new(); fillunset(o); o)
end # mutable struct import_table_args

mutable struct import_table_result
  e::TMapDException
  import_table_result() = (o=new(); fillunset(o); o)
end # mutable struct import_table_result
meta(t::Type{import_table_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method import_geo_table

mutable struct import_geo_table_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  file_name::String
  copy_params::TCopyParams
  row_desc::TRowDescriptor
  import_geo_table_args() = (o=new(); fillunset(o); o)
end # mutable struct import_geo_table_args

mutable struct import_geo_table_result
  e::TMapDException
  import_geo_table_result() = (o=new(); fillunset(o); o)
end # mutable struct import_geo_table_result
meta(t::Type{import_geo_table_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method import_table_status

mutable struct import_table_status_args <: Thrift.TMsg
  session::TSessionId
  import_id::String
  import_table_status_args() = (o=new(); fillunset(o); o)
end # mutable struct import_table_status_args

mutable struct import_table_status_result
  success::TImportStatus
  e::TMapDException
  import_table_status_result() = (o=new(); fillunset(o); o)
  import_table_status_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct import_table_status_result
meta(t::Type{import_table_status_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_first_geo_file_in_archive

mutable struct get_first_geo_file_in_archive_args <: Thrift.TMsg
  session::TSessionId
  archive_path::String
  copy_params::TCopyParams
  get_first_geo_file_in_archive_args() = (o=new(); fillunset(o); o)
end # mutable struct get_first_geo_file_in_archive_args

mutable struct get_first_geo_file_in_archive_result
  success::String
  e::TMapDException
  get_first_geo_file_in_archive_result() = (o=new(); fillunset(o); o)
  get_first_geo_file_in_archive_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_first_geo_file_in_archive_result
meta(t::Type{get_first_geo_file_in_archive_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_all_files_in_archive

mutable struct get_all_files_in_archive_args <: Thrift.TMsg
  session::TSessionId
  archive_path::String
  copy_params::TCopyParams
  get_all_files_in_archive_args() = (o=new(); fillunset(o); o)
end # mutable struct get_all_files_in_archive_args

mutable struct get_all_files_in_archive_result
  success::Vector{String}
  e::TMapDException
  get_all_files_in_archive_result() = (o=new(); fillunset(o); o)
  get_all_files_in_archive_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_all_files_in_archive_result
meta(t::Type{get_all_files_in_archive_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method start_query

mutable struct start_query_args <: Thrift.TMsg
  session::TSessionId
  query_ra::String
  just_explain::Bool
  start_query_args() = (o=new(); fillunset(o); o)
end # mutable struct start_query_args

mutable struct start_query_result
  success::TPendingQuery
  e::TMapDException
  start_query_result() = (o=new(); fillunset(o); o)
  start_query_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct start_query_result
meta(t::Type{start_query_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method execute_first_step

mutable struct execute_first_step_args <: Thrift.TMsg
  pending_query::TPendingQuery
  execute_first_step_args() = (o=new(); fillunset(o); o)
end # mutable struct execute_first_step_args

mutable struct execute_first_step_result
  success::TStepResult
  e::TMapDException
  execute_first_step_result() = (o=new(); fillunset(o); o)
  execute_first_step_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct execute_first_step_result
meta(t::Type{execute_first_step_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method broadcast_serialized_rows

mutable struct broadcast_serialized_rows_args <: Thrift.TMsg
  serialized_rows::String
  row_desc::TRowDescriptor
  query_id::TQueryId
  broadcast_serialized_rows_args() = (o=new(); fillunset(o); o)
end # mutable struct broadcast_serialized_rows_args

mutable struct broadcast_serialized_rows_result
  e::TMapDException
  broadcast_serialized_rows_result() = (o=new(); fillunset(o); o)
end # mutable struct broadcast_serialized_rows_result
meta(t::Type{broadcast_serialized_rows_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method start_render_query

mutable struct start_render_query_args <: Thrift.TMsg
  session::TSessionId
  widget_id::Int64
  node_idx::Int16
  vega_json::String
  start_render_query_args() = (o=new(); fillunset(o); o)
end # mutable struct start_render_query_args

mutable struct start_render_query_result
  success::TPendingRenderQuery
  e::TMapDException
  start_render_query_result() = (o=new(); fillunset(o); o)
  start_render_query_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct start_render_query_result
meta(t::Type{start_render_query_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method execute_next_render_step

mutable struct execute_next_render_step_args <: Thrift.TMsg
  pending_render::TPendingRenderQuery
  merged_data::TRenderAggDataMap
  execute_next_render_step_args() = (o=new(); fillunset(o); o)
end # mutable struct execute_next_render_step_args

mutable struct execute_next_render_step_result
  success::TRenderStepResult
  e::TMapDException
  execute_next_render_step_result() = (o=new(); fillunset(o); o)
  execute_next_render_step_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct execute_next_render_step_result
meta(t::Type{execute_next_render_step_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method insert_data

mutable struct insert_data_args <: Thrift.TMsg
  session::TSessionId
  insert_data::TInsertData
  insert_data_args() = (o=new(); fillunset(o); o)
end # mutable struct insert_data_args

mutable struct insert_data_result
  e::TMapDException
  insert_data_result() = (o=new(); fillunset(o); o)
end # mutable struct insert_data_result
meta(t::Type{insert_data_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method checkpoint

mutable struct checkpoint_args <: Thrift.TMsg
  session::TSessionId
  db_id::Int32
  table_id::Int32
  checkpoint_args() = (o=new(); fillunset(o); o)
end # mutable struct checkpoint_args

mutable struct checkpoint_result
  e::TMapDException
  checkpoint_result() = (o=new(); fillunset(o); o)
end # mutable struct checkpoint_result
meta(t::Type{checkpoint_result}) = meta(t, Symbol[:e], Int[1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_table_descriptor

mutable struct get_table_descriptor_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  get_table_descriptor_args() = (o=new(); fillunset(o); o)
end # mutable struct get_table_descriptor_args

mutable struct get_table_descriptor_result
  success::TTableDescriptor
  e::TMapDException
  get_table_descriptor_result() = (o=new(); fillunset(o); o)
  get_table_descriptor_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_table_descriptor_result
meta(t::Type{get_table_descriptor_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_row_descriptor

mutable struct get_row_descriptor_args <: Thrift.TMsg
  session::TSessionId
  table_name::String
  get_row_descriptor_args() = (o=new(); fillunset(o); o)
end # mutable struct get_row_descriptor_args

mutable struct get_row_descriptor_result
  success::TRowDescriptor
  e::TMapDException
  get_row_descriptor_result() = (o=new(); fillunset(o); o)
  get_row_descriptor_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_row_descriptor_result
meta(t::Type{get_row_descriptor_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

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

# types encapsulating arguments and return values of method get_db_objects_for_grantee

mutable struct get_db_objects_for_grantee_args <: Thrift.TMsg
  session::TSessionId
  roleName::String
  get_db_objects_for_grantee_args() = (o=new(); fillunset(o); o)
end # mutable struct get_db_objects_for_grantee_args

mutable struct get_db_objects_for_grantee_result
  success::Vector{TDBObject}
  e::TMapDException
  get_db_objects_for_grantee_result() = (o=new(); fillunset(o); o)
  get_db_objects_for_grantee_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_db_objects_for_grantee_result
meta(t::Type{get_db_objects_for_grantee_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

# types encapsulating arguments and return values of method get_db_object_privs

mutable struct get_db_object_privs_args <: Thrift.TMsg
  session::TSessionId
  objectName::String
  _type::Int32
  get_db_object_privs_args() = (o=new(); fillunset(o); o)
end # mutable struct get_db_object_privs_args

mutable struct get_db_object_privs_result
  success::Vector{TDBObject}
  e::TMapDException
  get_db_object_privs_result() = (o=new(); fillunset(o); o)
  get_db_object_privs_result(success) = (o=new(); fillset(o, :success); o.success=success; o)
end # mutable struct get_db_object_privs_result
meta(t::Type{get_db_object_privs_result}) = meta(t, Symbol[:success, :e], Int[0, 1], Dict{Symbol,Any}())

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

# Processor for MapD service (to be used in server implementation)
mutable struct MapDProcessor <: TProcessor
  tp::ThriftProcessor
  function MapDProcessor()
    p = new(ThriftProcessor())
    handle(p.tp, ThriftHandler("connect", _connect, connect_args, connect_result))
    handle(p.tp, ThriftHandler("disconnect", _disconnect, disconnect_args, disconnect_result))
    handle(p.tp, ThriftHandler("get_server_status", _get_server_status, get_server_status_args, get_server_status_result))
    handle(p.tp, ThriftHandler("get_status", _get_status, get_status_args, get_status_result))
    handle(p.tp, ThriftHandler("get_hardware_info", _get_hardware_info, get_hardware_info_args, get_hardware_info_result))
    handle(p.tp, ThriftHandler("get_tables", _get_tables, get_tables_args, get_tables_result))
    handle(p.tp, ThriftHandler("get_physical_tables", _get_physical_tables, get_physical_tables_args, get_physical_tables_result))
    handle(p.tp, ThriftHandler("get_views", _get_views, get_views_args, get_views_result))
    handle(p.tp, ThriftHandler("get_tables_meta", _get_tables_meta, get_tables_meta_args, get_tables_meta_result))
    handle(p.tp, ThriftHandler("get_table_details", _get_table_details, get_table_details_args, get_table_details_result))
    handle(p.tp, ThriftHandler("get_internal_table_details", _get_internal_table_details, get_internal_table_details_args, get_internal_table_details_result))
    handle(p.tp, ThriftHandler("get_users", _get_users, get_users_args, get_users_result))
    handle(p.tp, ThriftHandler("get_databases", _get_databases, get_databases_args, get_databases_result))
    handle(p.tp, ThriftHandler("get_version", _get_version, get_version_args, get_version_result))
    handle(p.tp, ThriftHandler("start_heap_profile", _start_heap_profile, start_heap_profile_args, start_heap_profile_result))
    handle(p.tp, ThriftHandler("stop_heap_profile", _stop_heap_profile, stop_heap_profile_args, stop_heap_profile_result))
    handle(p.tp, ThriftHandler("get_heap_profile", _get_heap_profile, get_heap_profile_args, get_heap_profile_result))
    handle(p.tp, ThriftHandler("get_memory", _get_memory, get_memory_args, get_memory_result))
    handle(p.tp, ThriftHandler("clear_cpu_memory", _clear_cpu_memory, clear_cpu_memory_args, clear_cpu_memory_result))
    handle(p.tp, ThriftHandler("clear_gpu_memory", _clear_gpu_memory, clear_gpu_memory_args, clear_gpu_memory_result))
    handle(p.tp, ThriftHandler("set_table_epoch", _set_table_epoch, set_table_epoch_args, set_table_epoch_result))
    handle(p.tp, ThriftHandler("set_table_epoch_by_name", _set_table_epoch_by_name, set_table_epoch_by_name_args, set_table_epoch_by_name_result))
    handle(p.tp, ThriftHandler("get_table_epoch", _get_table_epoch, get_table_epoch_args, get_table_epoch_result))
    handle(p.tp, ThriftHandler("get_table_epoch_by_name", _get_table_epoch_by_name, get_table_epoch_by_name_args, get_table_epoch_by_name_result))
    handle(p.tp, ThriftHandler("sql_execute", _sql_execute, sql_execute_args, sql_execute_result))
    handle(p.tp, ThriftHandler("sql_execute_df", _sql_execute_df, sql_execute_df_args, sql_execute_df_result))
    handle(p.tp, ThriftHandler("sql_execute_gdf", _sql_execute_gdf, sql_execute_gdf_args, sql_execute_gdf_result))
    handle(p.tp, ThriftHandler("deallocate_df", _deallocate_df, deallocate_df_args, deallocate_df_result))
    handle(p.tp, ThriftHandler("interrupt", _interrupt, interrupt_args, interrupt_result))
    handle(p.tp, ThriftHandler("sql_validate", _sql_validate, sql_validate_args, sql_validate_result))
    handle(p.tp, ThriftHandler("get_completion_hints", _get_completion_hints, get_completion_hints_args, get_completion_hints_result))
    handle(p.tp, ThriftHandler("set_execution_mode", _set_execution_mode, set_execution_mode_args, set_execution_mode_result))
    handle(p.tp, ThriftHandler("render_vega", _render_vega, render_vega_args, render_vega_result))
    handle(p.tp, ThriftHandler("get_result_row_for_pixel", _get_result_row_for_pixel, get_result_row_for_pixel_args, get_result_row_for_pixel_result))
    handle(p.tp, ThriftHandler("get_frontend_view", _get_frontend_view, get_frontend_view_args, get_frontend_view_result))
    handle(p.tp, ThriftHandler("get_frontend_views", _get_frontend_views, get_frontend_views_args, get_frontend_views_result))
    handle(p.tp, ThriftHandler("create_frontend_view", _create_frontend_view, create_frontend_view_args, create_frontend_view_result))
    handle(p.tp, ThriftHandler("delete_frontend_view", _delete_frontend_view, delete_frontend_view_args, delete_frontend_view_result))
    handle(p.tp, ThriftHandler("get_dashboard", _get_dashboard, get_dashboard_args, get_dashboard_result))
    handle(p.tp, ThriftHandler("get_dashboards", _get_dashboards, get_dashboards_args, get_dashboards_result))
    handle(p.tp, ThriftHandler("create_dashboard", _create_dashboard, create_dashboard_args, create_dashboard_result))
    handle(p.tp, ThriftHandler("replace_dashboard", _replace_dashboard, replace_dashboard_args, replace_dashboard_result))
    handle(p.tp, ThriftHandler("delete_dashboard", _delete_dashboard, delete_dashboard_args, delete_dashboard_result))
    handle(p.tp, ThriftHandler("share_dashboard", _share_dashboard, share_dashboard_args, share_dashboard_result))
    handle(p.tp, ThriftHandler("unshare_dashboard", _unshare_dashboard, unshare_dashboard_args, unshare_dashboard_result))
    handle(p.tp, ThriftHandler("get_dashboard_grantees", _get_dashboard_grantees, get_dashboard_grantees_args, get_dashboard_grantees_result))
    handle(p.tp, ThriftHandler("get_link_view", _get_link_view, get_link_view_args, get_link_view_result))
    handle(p.tp, ThriftHandler("create_link", _create_link, create_link_args, create_link_result))
    handle(p.tp, ThriftHandler("load_table_binary", _load_table_binary, load_table_binary_args, load_table_binary_result))
    handle(p.tp, ThriftHandler("load_table_binary_columnar", _load_table_binary_columnar, load_table_binary_columnar_args, load_table_binary_columnar_result))
    handle(p.tp, ThriftHandler("load_table_binary_arrow", _load_table_binary_arrow, load_table_binary_arrow_args, load_table_binary_arrow_result))
    handle(p.tp, ThriftHandler("load_table", _load_table, load_table_args, load_table_result))
    handle(p.tp, ThriftHandler("detect_column_types", _detect_column_types, detect_column_types_args, detect_column_types_result))
    handle(p.tp, ThriftHandler("create_table", _create_table, create_table_args, create_table_result))
    handle(p.tp, ThriftHandler("import_table", _import_table, import_table_args, import_table_result))
    handle(p.tp, ThriftHandler("import_geo_table", _import_geo_table, import_geo_table_args, import_geo_table_result))
    handle(p.tp, ThriftHandler("import_table_status", _import_table_status, import_table_status_args, import_table_status_result))
    handle(p.tp, ThriftHandler("get_first_geo_file_in_archive", _get_first_geo_file_in_archive, get_first_geo_file_in_archive_args, get_first_geo_file_in_archive_result))
    handle(p.tp, ThriftHandler("get_all_files_in_archive", _get_all_files_in_archive, get_all_files_in_archive_args, get_all_files_in_archive_result))
    handle(p.tp, ThriftHandler("start_query", _start_query, start_query_args, start_query_result))
    handle(p.tp, ThriftHandler("execute_first_step", _execute_first_step, execute_first_step_args, execute_first_step_result))
    handle(p.tp, ThriftHandler("broadcast_serialized_rows", _broadcast_serialized_rows, broadcast_serialized_rows_args, broadcast_serialized_rows_result))
    handle(p.tp, ThriftHandler("start_render_query", _start_render_query, start_render_query_args, start_render_query_result))
    handle(p.tp, ThriftHandler("execute_next_render_step", _execute_next_render_step, execute_next_render_step_args, execute_next_render_step_result))
    handle(p.tp, ThriftHandler("insert_data", _insert_data, insert_data_args, insert_data_result))
    handle(p.tp, ThriftHandler("checkpoint", _checkpoint, checkpoint_args, checkpoint_result))
    handle(p.tp, ThriftHandler("get_table_descriptor", _get_table_descriptor, get_table_descriptor_args, get_table_descriptor_result))
    handle(p.tp, ThriftHandler("get_row_descriptor", _get_row_descriptor, get_row_descriptor_args, get_row_descriptor_result))
    handle(p.tp, ThriftHandler("get_roles", _get_roles, get_roles_args, get_roles_result))
    handle(p.tp, ThriftHandler("get_db_objects_for_grantee", _get_db_objects_for_grantee, get_db_objects_for_grantee_args, get_db_objects_for_grantee_result))
    handle(p.tp, ThriftHandler("get_db_object_privs", _get_db_object_privs, get_db_object_privs_args, get_db_object_privs_result))
    handle(p.tp, ThriftHandler("get_all_roles_for_user", _get_all_roles_for_user, get_all_roles_for_user_args, get_all_roles_for_user_result))
    handle(p.tp, ThriftHandler("set_license_key", _set_license_key, set_license_key_args, set_license_key_result))
    handle(p.tp, ThriftHandler("get_license_claims", _get_license_claims, get_license_claims_args, get_license_claims_result))
    p
  end
  function _connect(inp::connect_args)
    try
      result = connect(inp.user, inp.passwd, inp.dbname)
      return connect_result(result)
    catch ex
      exret = connect_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _connect
  function _disconnect(inp::disconnect_args)
    try
      disconnect(inp.session)
      return disconnect_result()
    catch ex
      exret = disconnect_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _disconnect
  function _get_server_status(inp::get_server_status_args)
    try
      result = get_server_status(inp.session)
      return get_server_status_result(result)
    catch ex
      exret = get_server_status_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_server_status
  function _get_status(inp::get_status_args)
    try
      result = get_status(inp.session)
      return get_status_result(result)
    catch ex
      exret = get_status_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_status
  function _get_hardware_info(inp::get_hardware_info_args)
    try
      result = get_hardware_info(inp.session)
      return get_hardware_info_result(result)
    catch ex
      exret = get_hardware_info_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_hardware_info
  function _get_tables(inp::get_tables_args)
    try
      result = get_tables(inp.session)
      return get_tables_result(result)
    catch ex
      exret = get_tables_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_tables
  function _get_physical_tables(inp::get_physical_tables_args)
    try
      result = get_physical_tables(inp.session)
      return get_physical_tables_result(result)
    catch ex
      exret = get_physical_tables_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_physical_tables
  function _get_views(inp::get_views_args)
    try
      result = get_views(inp.session)
      return get_views_result(result)
    catch ex
      exret = get_views_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_views
  function _get_tables_meta(inp::get_tables_meta_args)
    try
      result = get_tables_meta(inp.session)
      return get_tables_meta_result(result)
    catch ex
      exret = get_tables_meta_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_tables_meta
  function _get_table_details(inp::get_table_details_args)
    try
      result = get_table_details(inp.session, inp.table_name)
      return get_table_details_result(result)
    catch ex
      exret = get_table_details_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_table_details
  function _get_internal_table_details(inp::get_internal_table_details_args)
    try
      result = get_internal_table_details(inp.session, inp.table_name)
      return get_internal_table_details_result(result)
    catch ex
      exret = get_internal_table_details_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_internal_table_details
  function _get_users(inp::get_users_args)
    try
      result = get_users(inp.session)
      return get_users_result(result)
    catch ex
      exret = get_users_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_users
  function _get_databases(inp::get_databases_args)
    try
      result = get_databases(inp.session)
      return get_databases_result(result)
    catch ex
      exret = get_databases_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_databases
  function _get_version(inp::get_version_args)
    try
      result = get_version()
      return get_version_result(result)
    catch ex
      exret = get_version_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_version
  function _start_heap_profile(inp::start_heap_profile_args)
    try
      start_heap_profile(inp.session)
      return start_heap_profile_result()
    catch ex
      exret = start_heap_profile_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _start_heap_profile
  function _stop_heap_profile(inp::stop_heap_profile_args)
    try
      stop_heap_profile(inp.session)
      return stop_heap_profile_result()
    catch ex
      exret = stop_heap_profile_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _stop_heap_profile
  function _get_heap_profile(inp::get_heap_profile_args)
    try
      result = get_heap_profile(inp.session)
      return get_heap_profile_result(result)
    catch ex
      exret = get_heap_profile_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_heap_profile
  function _get_memory(inp::get_memory_args)
    try
      result = get_memory(inp.session, inp.memory_level)
      return get_memory_result(result)
    catch ex
      exret = get_memory_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_memory
  function _clear_cpu_memory(inp::clear_cpu_memory_args)
    try
      clear_cpu_memory(inp.session)
      return clear_cpu_memory_result()
    catch ex
      exret = clear_cpu_memory_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _clear_cpu_memory
  function _clear_gpu_memory(inp::clear_gpu_memory_args)
    try
      clear_gpu_memory(inp.session)
      return clear_gpu_memory_result()
    catch ex
      exret = clear_gpu_memory_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _clear_gpu_memory
  function _set_table_epoch(inp::set_table_epoch_args)
    try
      set_table_epoch(inp.session, inp.db_id, inp.table_id, inp.new_epoch)
      return set_table_epoch_result()
    catch ex
      exret = set_table_epoch_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _set_table_epoch
  function _set_table_epoch_by_name(inp::set_table_epoch_by_name_args)
    try
      set_table_epoch_by_name(inp.session, inp.table_name, inp.new_epoch)
      return set_table_epoch_by_name_result()
    catch ex
      exret = set_table_epoch_by_name_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _set_table_epoch_by_name
  _get_table_epoch(inp::get_table_epoch_args) = get_table_epoch_result(get_table_epoch(inp.session, inp.db_id, inp.table_id))
  _get_table_epoch_by_name(inp::get_table_epoch_by_name_args) = get_table_epoch_by_name_result(get_table_epoch_by_name(inp.session, inp.table_name))
  function _sql_execute(inp::sql_execute_args)
    try
      result = sql_execute(inp.session, inp.query, inp.column_format, inp.nonce, inp.first_n, inp.at_most_n)
      return sql_execute_result(result)
    catch ex
      exret = sql_execute_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _sql_execute
  function _sql_execute_df(inp::sql_execute_df_args)
    try
      result = sql_execute_df(inp.session, inp.query, inp.device_type, inp.device_id, inp.first_n)
      return sql_execute_df_result(result)
    catch ex
      exret = sql_execute_df_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _sql_execute_df
  function _sql_execute_gdf(inp::sql_execute_gdf_args)
    try
      result = sql_execute_gdf(inp.session, inp.query, inp.device_id, inp.first_n)
      return sql_execute_gdf_result(result)
    catch ex
      exret = sql_execute_gdf_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _sql_execute_gdf
  function _deallocate_df(inp::deallocate_df_args)
    try
      deallocate_df(inp.session, inp.df, inp.device_type, inp.device_id)
      return deallocate_df_result()
    catch ex
      exret = deallocate_df_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _deallocate_df
  function _interrupt(inp::interrupt_args)
    try
      interrupt(inp.session)
      return interrupt_result()
    catch ex
      exret = interrupt_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _interrupt
  function _sql_validate(inp::sql_validate_args)
    try
      result = sql_validate(inp.session, inp.query)
      return sql_validate_result(result)
    catch ex
      exret = sql_validate_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _sql_validate
  function _get_completion_hints(inp::get_completion_hints_args)
    try
      result = get_completion_hints(inp.session, inp.sql, inp.cursor)
      return get_completion_hints_result(result)
    catch ex
      exret = get_completion_hints_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_completion_hints
  function _set_execution_mode(inp::set_execution_mode_args)
    try
      set_execution_mode(inp.session, inp.mode)
      return set_execution_mode_result()
    catch ex
      exret = set_execution_mode_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _set_execution_mode
  function _render_vega(inp::render_vega_args)
    try
      result = render_vega(inp.session, inp.widget_id, inp.vega_json, inp.compression_level, inp.nonce)
      return render_vega_result(result)
    catch ex
      exret = render_vega_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _render_vega
  function _get_result_row_for_pixel(inp::get_result_row_for_pixel_args)
    try
      result = get_result_row_for_pixel(inp.session, inp.widget_id, inp.pixel, inp.table_col_names, inp.column_format, inp.pixelRadius, inp.nonce)
      return get_result_row_for_pixel_result(result)
    catch ex
      exret = get_result_row_for_pixel_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_result_row_for_pixel
  function _get_frontend_view(inp::get_frontend_view_args)
    try
      result = get_frontend_view(inp.session, inp.view_name)
      return get_frontend_view_result(result)
    catch ex
      exret = get_frontend_view_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_frontend_view
  function _get_frontend_views(inp::get_frontend_views_args)
    try
      result = get_frontend_views(inp.session)
      return get_frontend_views_result(result)
    catch ex
      exret = get_frontend_views_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_frontend_views
  function _create_frontend_view(inp::create_frontend_view_args)
    try
      create_frontend_view(inp.session, inp.view_name, inp.view_state, inp.image_hash, inp.view_metadata)
      return create_frontend_view_result()
    catch ex
      exret = create_frontend_view_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _create_frontend_view
  function _delete_frontend_view(inp::delete_frontend_view_args)
    try
      delete_frontend_view(inp.session, inp.view_name)
      return delete_frontend_view_result()
    catch ex
      exret = delete_frontend_view_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _delete_frontend_view
  function _get_dashboard(inp::get_dashboard_args)
    try
      result = get_dashboard(inp.session, inp.dashboard_id)
      return get_dashboard_result(result)
    catch ex
      exret = get_dashboard_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_dashboard
  function _get_dashboards(inp::get_dashboards_args)
    try
      result = get_dashboards(inp.session)
      return get_dashboards_result(result)
    catch ex
      exret = get_dashboards_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_dashboards
  function _create_dashboard(inp::create_dashboard_args)
    try
      result = create_dashboard(inp.session, inp.dashboard_name, inp.dashboard_state, inp.image_hash, inp.dashboard_metadata)
      return create_dashboard_result(result)
    catch ex
      exret = create_dashboard_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _create_dashboard
  function _replace_dashboard(inp::replace_dashboard_args)
    try
      replace_dashboard(inp.session, inp.dashboard_id, inp.dashboard_name, inp.dashboard_owner, inp.dashboard_state, inp.image_hash, inp.dashboard_metadata)
      return replace_dashboard_result()
    catch ex
      exret = replace_dashboard_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _replace_dashboard
  function _delete_dashboard(inp::delete_dashboard_args)
    try
      delete_dashboard(inp.session, inp.dashboard_id)
      return delete_dashboard_result()
    catch ex
      exret = delete_dashboard_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _delete_dashboard
  function _share_dashboard(inp::share_dashboard_args)
    try
      share_dashboard(inp.session, inp.dashboard_id, inp.groups, inp.objects, inp.permissions)
      return share_dashboard_result()
    catch ex
      exret = share_dashboard_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _share_dashboard
  function _unshare_dashboard(inp::unshare_dashboard_args)
    try
      unshare_dashboard(inp.session, inp.dashboard_id, inp.groups, inp.objects, inp.permissions)
      return unshare_dashboard_result()
    catch ex
      exret = unshare_dashboard_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _unshare_dashboard
  function _get_dashboard_grantees(inp::get_dashboard_grantees_args)
    try
      result = get_dashboard_grantees(inp.session, inp.dashboard_id)
      return get_dashboard_grantees_result(result)
    catch ex
      exret = get_dashboard_grantees_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_dashboard_grantees
  function _get_link_view(inp::get_link_view_args)
    try
      result = get_link_view(inp.session, inp.link)
      return get_link_view_result(result)
    catch ex
      exret = get_link_view_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_link_view
  function _create_link(inp::create_link_args)
    try
      result = create_link(inp.session, inp.view_state, inp.view_metadata)
      return create_link_result(result)
    catch ex
      exret = create_link_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _create_link
  function _load_table_binary(inp::load_table_binary_args)
    try
      load_table_binary(inp.session, inp.table_name, inp.rows)
      return load_table_binary_result()
    catch ex
      exret = load_table_binary_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _load_table_binary
  function _load_table_binary_columnar(inp::load_table_binary_columnar_args)
    try
      load_table_binary_columnar(inp.session, inp.table_name, inp.cols)
      return load_table_binary_columnar_result()
    catch ex
      exret = load_table_binary_columnar_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _load_table_binary_columnar
  function _load_table_binary_arrow(inp::load_table_binary_arrow_args)
    try
      load_table_binary_arrow(inp.session, inp.table_name, inp.arrow_stream)
      return load_table_binary_arrow_result()
    catch ex
      exret = load_table_binary_arrow_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _load_table_binary_arrow
  function _load_table(inp::load_table_args)
    try
      load_table(inp.session, inp.table_name, inp.rows)
      return load_table_result()
    catch ex
      exret = load_table_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _load_table
  function _detect_column_types(inp::detect_column_types_args)
    try
      result = detect_column_types(inp.session, inp.file_name, inp.copy_params)
      return detect_column_types_result(result)
    catch ex
      exret = detect_column_types_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _detect_column_types
  function _create_table(inp::create_table_args)
    try
      create_table(inp.session, inp.table_name, inp.row_desc, inp.table_type)
      return create_table_result()
    catch ex
      exret = create_table_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _create_table
  function _import_table(inp::import_table_args)
    try
      import_table(inp.session, inp.table_name, inp.file_name, inp.copy_params)
      return import_table_result()
    catch ex
      exret = import_table_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _import_table
  function _import_geo_table(inp::import_geo_table_args)
    try
      import_geo_table(inp.session, inp.table_name, inp.file_name, inp.copy_params, inp.row_desc)
      return import_geo_table_result()
    catch ex
      exret = import_geo_table_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _import_geo_table
  function _import_table_status(inp::import_table_status_args)
    try
      result = import_table_status(inp.session, inp.import_id)
      return import_table_status_result(result)
    catch ex
      exret = import_table_status_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _import_table_status
  function _get_first_geo_file_in_archive(inp::get_first_geo_file_in_archive_args)
    try
      result = get_first_geo_file_in_archive(inp.session, inp.archive_path, inp.copy_params)
      return get_first_geo_file_in_archive_result(result)
    catch ex
      exret = get_first_geo_file_in_archive_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_first_geo_file_in_archive
  function _get_all_files_in_archive(inp::get_all_files_in_archive_args)
    try
      result = get_all_files_in_archive(inp.session, inp.archive_path, inp.copy_params)
      return get_all_files_in_archive_result(result)
    catch ex
      exret = get_all_files_in_archive_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_all_files_in_archive
  function _start_query(inp::start_query_args)
    try
      result = start_query(inp.session, inp.query_ra, inp.just_explain)
      return start_query_result(result)
    catch ex
      exret = start_query_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _start_query
  function _execute_first_step(inp::execute_first_step_args)
    try
      result = execute_first_step(inp.pending_query)
      return execute_first_step_result(result)
    catch ex
      exret = execute_first_step_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _execute_first_step
  function _broadcast_serialized_rows(inp::broadcast_serialized_rows_args)
    try
      broadcast_serialized_rows(inp.serialized_rows, inp.row_desc, inp.query_id)
      return broadcast_serialized_rows_result()
    catch ex
      exret = broadcast_serialized_rows_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _broadcast_serialized_rows
  function _start_render_query(inp::start_render_query_args)
    try
      result = start_render_query(inp.session, inp.widget_id, inp.node_idx, inp.vega_json)
      return start_render_query_result(result)
    catch ex
      exret = start_render_query_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _start_render_query
  function _execute_next_render_step(inp::execute_next_render_step_args)
    try
      result = execute_next_render_step(inp.pending_render, inp.merged_data)
      return execute_next_render_step_result(result)
    catch ex
      exret = execute_next_render_step_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _execute_next_render_step
  function _insert_data(inp::insert_data_args)
    try
      insert_data(inp.session, inp.insert_data)
      return insert_data_result()
    catch ex
      exret = insert_data_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _insert_data
  function _checkpoint(inp::checkpoint_args)
    try
      checkpoint(inp.session, inp.db_id, inp.table_id)
      return checkpoint_result()
    catch ex
      exret = checkpoint_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _checkpoint
  function _get_table_descriptor(inp::get_table_descriptor_args)
    try
      result = get_table_descriptor(inp.session, inp.table_name)
      return get_table_descriptor_result(result)
    catch ex
      exret = get_table_descriptor_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_table_descriptor
  function _get_row_descriptor(inp::get_row_descriptor_args)
    try
      result = get_row_descriptor(inp.session, inp.table_name)
      return get_row_descriptor_result(result)
    catch ex
      exret = get_row_descriptor_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_row_descriptor
  function _get_roles(inp::get_roles_args)
    try
      result = get_roles(inp.session)
      return get_roles_result(result)
    catch ex
      exret = get_roles_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_roles
  function _get_db_objects_for_grantee(inp::get_db_objects_for_grantee_args)
    try
      result = get_db_objects_for_grantee(inp.session, inp.roleName)
      return get_db_objects_for_grantee_result(result)
    catch ex
      exret = get_db_objects_for_grantee_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_db_objects_for_grantee
  function _get_db_object_privs(inp::get_db_object_privs_args)
    try
      result = get_db_object_privs(inp.session, inp.objectName, inp._type)
      return get_db_object_privs_result(result)
    catch ex
      exret = get_db_object_privs_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_db_object_privs
  function _get_all_roles_for_user(inp::get_all_roles_for_user_args)
    try
      result = get_all_roles_for_user(inp.session, inp.userName)
      return get_all_roles_for_user_result(result)
    catch ex
      exret = get_all_roles_for_user_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_all_roles_for_user
  function _set_license_key(inp::set_license_key_args)
    try
      result = set_license_key(inp.session, inp.key, inp.nonce)
      return set_license_key_result(result)
    catch ex
      exret = set_license_key_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _set_license_key
  function _get_license_claims(inp::get_license_claims_args)
    try
      result = get_license_claims(inp.session, inp.nonce)
      return get_license_claims_result(result)
    catch ex
      exret = get_license_claims_result()
      isa(ex, TMapDException) && (set_field!(exret, :e, ex); return exret)
      rethrow()
    end # try
  end #function _get_license_claims
end # mutable struct MapDProcessor
process(p::MapDProcessor, inp::TProtocol, outp::TProtocol) = process(p.tp, inp, outp)
distribute(p::MapDProcessor) = distribute(p.tp)

# Client implementation for MapD service
mutable struct MapDClient <: MapDClientBase
  p::TProtocol
  seqid::Int32
  MapDClient(p::TProtocol) = new(p, 0)
end # mutable struct MapDClient
