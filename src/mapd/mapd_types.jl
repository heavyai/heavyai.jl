#
# Autogenerated by Thrift Compiler (0.11.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING

struct _enum_TExecuteMode
  GPU::Int32
  CPU::Int32
end
const TExecuteMode = _enum_TExecuteMode(Int32(1), Int32(2))

struct _enum_TFileType
  DELIMITED::Int32
  POLYGON::Int32
  PARQUET::Int32
end
const TFileType = _enum_TFileType(Int32(0), Int32(1), Int32(2))

struct _enum_TPartitionDetail
  DEFAULT::Int32
  REPLICATED::Int32
  SHARDED::Int32
  OTHER::Int32
end
const TPartitionDetail = _enum_TPartitionDetail(Int32(0), Int32(1), Int32(2), Int32(3))

struct _enum_TGeoFileLayerContents
  EMPTY::Int32
  GEO::Int32
  NON_GEO::Int32
  UNSUPPORTED_GEO::Int32
end
const TGeoFileLayerContents = _enum_TGeoFileLayerContents(Int32(0), Int32(1), Int32(2), Int32(3))

struct _enum_TImportHeaderRow
  AUTODETECT::Int32
  NO_HEADER::Int32
  HAS_HEADER::Int32
end
const TImportHeaderRow = _enum_TImportHeaderRow(Int32(0), Int32(1), Int32(2))

struct _enum_TRole
  SERVER::Int32
  AGGREGATOR::Int32
  LEAF::Int32
  STRING_DICTIONARY::Int32
end
const TRole = _enum_TRole(Int32(0), Int32(1), Int32(2), Int32(3))

struct _enum_TMergeType
  UNION::Int32
  REDUCE::Int32
end
const TMergeType = _enum_TMergeType(Int32(0), Int32(1))

struct _enum_TExpressionRangeType
  INVALID::Int32
  INTEGER::Int32
  FLOAT::Int32
  DOUBLE::Int32
end
const TExpressionRangeType = _enum_TExpressionRangeType(Int32(0), Int32(1), Int32(2), Int32(3))

struct _enum_TDBObjectType
  AbstractDBObjectType::Int32
  DatabaseDBObjectType::Int32
  TableDBObjectType::Int32
  DashboardDBObjectType::Int32
  ViewDBObjectType::Int32
end
const TDBObjectType = _enum_TDBObjectType(Int32(0), Int32(1), Int32(2), Int32(3), Int32(4))

const TRowDescriptor = Vector{TColumnType}

const TTableDescriptor = Dict{String,TColumnType}

const TSessionId = String

const TQueryId = Int64

const TRenderPassMap = Dict{Int32,TRawRenderPassDataResult}

const TRenderAggDataMap = Dict{String,Dict{String,Dict{String,Dict{String,Vector{TRenderDatum}}}}}


mutable struct TDatumVal <: Thrift.TMsg
  int_val::Int64
  real_val::Float64
  str_val::String
  arr_val::Vector{TDatum}
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

mutable struct TColumnType <: Thrift.TMsg
  col_name::String
  col_type::TTypeInfo
  is_reserved_keyword::Bool
  src_name::String
  is_system::Bool
  is_physical::Bool
  col_id::Int64
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
  arr_col::Vector{TColumn}
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

mutable struct TStepResult <: Thrift.TMsg
  serialized_rows::TSerializedRows
  uncompressed_size::Int64
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
  has_header::Int32
  quoted::Bool
  _quote::String
  escape::String
  line_delim::String
  array_delim::String
  array_begin::String
  array_end::String
  threads::Int32
  file_type::Int32
  s3_access_key::String
  s3_secret_key::String
  s3_region::String
  geo_coords_encoding::Int32
  geo_coords_comp_param::Int32
  geo_coords_type::Int32
  geo_coords_srid::Int32
  sanitize_column_names::Bool
  geo_layer_name::String
  s3_endpoint::String
  TCopyParams() = (o=new(); fillunset(o); o)
end # mutable struct TCopyParams
meta(t::Type{TCopyParams}) = meta(t, Symbol[], Int[], Dict{Symbol,Any}(:has_header => Int32(0), :file_type => Int32(0), :geo_coords_encoding => Int32(6), :geo_coords_comp_param => Int32(32), :geo_coords_type => Int32(18), :geo_coords_srid => Int32(4326), :sanitize_column_names => true))

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
  role::Int32
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
  table_id::Vector{Int64}
  row_id::Vector{Int64}
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
  table_id::Int64
  max_table_id::Int64
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
  num_pixel_channels::Int32
  num_pixel_samples::Int32
  pixels::Vector{UInt8}
  row_ids_A::Vector{UInt8}
  row_ids_B::Vector{UInt8}
  table_ids::Vector{UInt8}
  accum_data::Vector{UInt8}
  TRawRenderPassDataResult() = (o=new(); fillunset(o); o)
end # mutable struct TRawRenderPassDataResult

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
  alter_::Bool
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

mutable struct TDBObjectPermissions <: Thrift.TMsg
  database_permissions_::TDatabasePermissions
  table_permissions_::TTablePermissions
  dashboard_permissions_::TDashboardPermissions
  view_permissions_::TViewPermissions
  TDBObjectPermissions() = (o=new(); fillunset(o); o)
end # mutable struct TDBObjectPermissions
meta(t::Type{TDBObjectPermissions}) = meta(t, Symbol[:database_permissions_,:table_permissions_,:dashboard_permissions_,:view_permissions_], Int[], Dict{Symbol,Any}())

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

mutable struct TSessionInfo <: Thrift.TMsg
  user::String
  database::String
  start_time::Int64
  TSessionInfo() = (o=new(); fillunset(o); o)
end # mutable struct TSessionInfo

mutable struct TGeoFileLayerInfo <: Thrift.TMsg
  name::String
  contents::Int32
  TGeoFileLayerInfo() = (o=new(); fillunset(o); o)
end # mutable struct TGeoFileLayerInfo

abstract type MapDClientBase end
