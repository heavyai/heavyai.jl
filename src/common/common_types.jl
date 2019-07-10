#
# Autogenerated by Thrift Compiler (0.11.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING

struct _enum_TDeviceType
  CPU::Int32
  GPU::Int32
end
const TDeviceType = _enum_TDeviceType(Int32(0), Int32(1))

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
  DATE_IN_DAYS::Int32
end
const TEncodingType = _enum_TEncodingType(Int32(0), Int32(1), Int32(2), Int32(3), Int32(4), Int32(5), Int32(6), Int32(7))


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
