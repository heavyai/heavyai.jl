#https://discourse.julialang.org/t/encapsulating-enum-access-via-dot-syntax/11785/3
# @scopedenum Fruit APPLE=1 PEAR=2 BANANA=3
# Fruit.APPLE
# Fruit.PEAR
# # access enum value
# Fruit.APPLE.value
# # make an APPLE from string
# Fruit.Enum("APPLE")
# # restricting type signatures
# f(x::Fruit.Enum) = # do stuff w/ x
macro scopedenum(T, args...)
    defs = Expr(:block)
    append!(defs.args, collect(:(const $(x.args[1]) = Enum($(x.args[2]))) for x in args))
    names = Dict(x.args[2]=>String(x.args[1]) for x in args)
    str2val = Dict(String(x.args[1])=>x.args[2] for x in args)
    push!(defs.args, quote
        function name(e::Enum)
            nms = $names
            return nms[e.value]
        end
        Enum(str::String) = Enum($(str2val)[str])
        Base.show(io::IO, e::E) where {E <: Enum} = print(io, "$(Base.datatype_module(E)).$(name(e)) = $(e.value)")
    end)
    blk = esc(:(module $T; struct Enum{T}; value::T; end; Enum{T}(e::Enum{T}) where {T} = e; $defs; end))
    return Expr(:toplevel, blk)
end


#translated from auto-generated Thrift.jl to more ergonomic enum usage via macro
@scopedenum TDatumType SMALLINT=Int32(0) INT=Int32(1) BIGINT=Int32(2) FLOAT=Int32(3) DECIMAL=Int32(4) DOUBLE=Int32(5) STR=Int32(6) TIME=Int32(7) TIMESTAMP=Int32(8) DATE=Int32(9) BOOL=Int32(10) INTERVAL_DAY_TIME=Int32(11) INTERVAL_YEAR_MONTH=Int32(12) POINT=Int32(13) LINESTRING=Int32(14) POLYGON=Int32(15) MULTIPOLYGON=Int32(16) TINYINT=Int32(17) GEOMETRY=Int32(18) GEOGRAPHY=Int32(19)

@scopedenum TEncodingType NONE=Int32(0) FIXED=Int32(1) RL=Int32(2) DIFF=Int32(3) DICT=Int32(4) SPARSE=Int32(5) GEOINT=Int32(6)

@scopedenum TExecuteMode GPU=Int32(1) CPU=Int32(2)

@scopedenum TDeviceType CPU=Int32(0) GPU=Int32(1)

@scopedenum TTableType DELIMITED=Int32(0) POLYGON=Int32(1)

@scopedenum TPartitionDetail DEFAULT=Int32(0) REPLICATED=Int32(1) SHARDED=Int32(2) OTHER=Int32(3)

@scopedenum TMergeType UNION=Int32(0) REDUCE=Int32(1)

@scopedenum TExpressionRangeType INVALID=Int32(0) INTEGER=Int32(1) FLOAT=Int32(2) DOUBLE=Int32(3)

@scopedenum TDBObjectType AbstractDBObjectType=Int32(0) DatabaseDBObjectType=Int32(1) TableDBObjectType=Int32(2) DashboardDBObjectType=Int32(3) ViewDBObjectType=Int32(4)
