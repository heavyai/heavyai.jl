struct _enum_TDatumType
  SMALLINT::Int32
  INT::Int32
  BIGINT::Int32
  FLOAT::Int32
  DECIMAL::Int32
  DOUBLE::Int32
  STR::Int32
  TIME::Int32
  TIMESTAMP::Int32
  DATE::Int32
  BOOL::Int32
  INTERVAL_DAY_TIME::Int32
  INTERVAL_YEAR_MONTH::Int32
  POINT::Int32
  LINESTRING::Int32
  POLYGON::Int32
  MULTIPOLYGON::Int32
  TINYINT::Int32
  GEOMETRY::Int32
  GEOGRAPHY::Int32
end
const TDatumType = _enum_TDatumType(Int32(0), Int32(1), Int32(2), Int32(3), Int32(4), Int32(5), Int32(6), Int32(7), Int32(8), Int32(9), Int32(10), Int32(11), Int32(12), Int32(13), Int32(14), Int32(15), Int32(16), Int32(17), Int32(18), Int32(19))

struct _enum_TEncodingType
  NONE::Int32
  FIXED::Int32
  RL::Int32
  DIFF::Int32
  DICT::Int32
  SPARSE::Int32
  GEOINT::Int32
end
const TEncodingType = _enum_TEncodingType(Int32(0), Int32(1), Int32(2), Int32(3), Int32(4), Int32(5), Int32(6))

struct _enum_TExecuteMode
  HYBRID::Int32
  GPU::Int32
  CPU::Int32
end
const TExecuteMode = _enum_TExecuteMode(Int32(0), Int32(1), Int32(2))

struct _enum_TDeviceType
  CPU::Int32
  GPU::Int32
end
const TDeviceType = _enum_TDeviceType(Int32(0), Int32(1))

struct _enum_TTableType
  DELIMITED::Int32
  POLYGON::Int32
end
const TTableType = _enum_TTableType(Int32(0), Int32(1))

struct _enum_TPartitionDetail
  DEFAULT::Int32
  REPLICATED::Int32
  SHARDED::Int32
  OTHER::Int32
end
const TPartitionDetail = _enum_TPartitionDetail(Int32(0), Int32(1), Int32(2), Int32(3))

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

struct _enum_TCompletionHintType
  COLUMN::Int32
  TABLE::Int32
  VIEW::Int32
  SCHEMA::Int32
  CATALOG::Int32
  REPOSITORY::Int32
  FUNCTION::Int32
  KEYWORD::Int32
end
const TCompletionHintType = _enum_TCompletionHintType(Int32(0), Int32(1), Int32(2), Int32(3), Int32(4), Int32(5), Int32(6), Int32(7))

mutable struct TCompletionHint <: Thrift.TMsg
  _type::Int32
  hints::Vector{String}
  replaced::String
  TCompletionHint() = (o=new(); fillunset(o); o)
end # mutable struct TCompletionHint
