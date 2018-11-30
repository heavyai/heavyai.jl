########################### Common/Utils ###########################

#Convenience struct to pass `conn` each time instead of the parts
mutable struct OmniSciConnection
    session::TSessionId
    c::MapDClient
end

#convert methods implicitly needed for squashbitmask
convert(::Type{DateTime}, x::Int64) =  Dates.unix2datetime(x)
convert(::Type{Date}, x::Int64) =  Date(Dates.unix2datetime(x))
convert(::Type{Time}, x::Int64) = Time(x/3600, x % 3600)
convert(::Type{GeoInterface.Point}, x::String) = GeoInterface.Point(LibGEOS.readgeom(x))
convert(::Type{GeoInterface.LineString}, x::String) = GeoInterface.LineString(LibGEOS.readgeom(x))
convert(::Type{GeoInterface.Polygon}, x::String) = GeoInterface.Polygon(LibGEOS.readgeom(x))
convert(::Type{GeoInterface.MultiPolygon}, x::String) = GeoInterface.MultiPolygon(LibGEOS.readgeom(x))

#Find which field in the struct the data actually is
function findvalues(x::OmniSci.TColumn)
    for f in propertynames(x.data)
        n = length(getfield(x.data, f))
        if n > 0
            return (f, n)
        end
    end
end

#Take two vectors, values and nulls, make into a single vector
#TODO: Figure out if its possible to further minimize allocations
function squashbitmask(x::TColumn, typeinfo::Tuple{DataType, Bool})

    #Get location of data from struct, eltype of vector and its length
    valuescol, n = findvalues(x)

    #unpack type info
    ltype, nullable = typeinfo

    #Build/fill new vector based on missingness
    if nullable
        A = Vector{Union{ltype, Missing}}(undef, n)
        @simd for i = 1:n
            @inbounds A[i] = ifelse(x.nulls[i], missing, getfield(x.data, valuescol)[i])
        end
    else
        #Assumption here is that for columns without nulls, can cast directly
        #Since whatever is in the x.data column should be valid values
        #And appropriate convert methods defined
        A = convert(Vector{ltype}, getfield(x.data, valuescol))
    end

    return A
end

seconds_since_midnight(x::Time) = (hour(x) * 3600) + (minute(x) * 60) + second(x)

########################### Typedefs for load_table method ###########################

#For functions below, value for is_null should be known based on the dispatched type
#Left as keyword just in case my assumption incorrect
function TStringValue(str_val::GeoInterface.Point, is_null::Bool = false)
  val = OmniSci.TStringValue()
  p = writegeom(LibGEOS.Point(str_val))
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::GeoInterface.LineString, is_null::Bool = false)
  val = OmniSci.TStringValue()
  p = writegeom(LibGEOS.LineString(str_val))
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::GeoInterface.Polygon, is_null::Bool = false)
  val = OmniSci.TStringValue()
  p = writegeom(LibGEOS.Polygon(str_val))
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::GeoInterface.MultiPolygon, is_null::Bool = false)
  val = OmniSci.TStringValue()
  p = writegeom(LibGEOS.MultiPolygon(str_val))
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::Rational, is_null::Bool = false)
  val = OmniSci.TStringValue()
  Thrift.set_field!(val, :str_val, string(convert(Float64, str_val)))
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::T, is_null::Bool = true) where T <: Union{Missing, Nothing}
  val = OmniSci.TStringValue()
  Thrift.set_field!(val, :str_val, string(str_val))
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

#TODO: Could this method just be the generic fallback for any type serializable with string()?
#Or, should it stay to enforce that only certain julia types supported?
function TStringValue(str_val::T, is_null::Bool = false) where T <: Union{Real, AbstractString, TimeType}
  val = OmniSci.TStringValue()
  Thrift.set_field!(val, :str_val, string(str_val))
  Thrift.set_field!(val, :is_null, is_null)
  return val
end


function TStringRow(cols::Vector{TStringValue})
    tsr = OmniSci.TStringRow()
    Thrift.set_field!(tsr, :cols, cols)
    return tsr
end

TStringRow(cols::AbstractVector) = TStringRow(TStringValue.(cols))
TStringRow(x::DataFrameRow{DataFrame}) = TStringRow(vec(convert(Array, x)))

########################### Typedefs for load_table_binary_columnar method ###########################

function TColumn(x::AbstractVector{<:Union{Missing, T}}) where T <: Union{Int8, Int16, Int32, Int64}

    #Create TColumn, fill nulls column by checking for missingness
    tc = TColumn()
    Thrift.set_field!(tc, :nulls, convert(Vector{Bool}, ismissing.(x)))

    #Replace missing values with typed sentinel and convert to Vector{Int64} per API requirement
    tcd = TColumnData()
    Thrift.set_field!(tcd, :int_col, convert(Vector{Int64}, coalesce.(x, -1)))

    #Complete TColumn
    Thrift.set_field!(tc, :data, tcd)

    return tc
end

function TColumn(x::AbstractVector{<:Union{Missing, T}}) where T <: Union{AbstractFloat, Rational}

    #Create TColumn, fill nulls column by checking for missingness
    tc = TColumn()
    Thrift.set_field!(tc, :nulls, convert(Vector{Bool}, ismissing.(x)))

    #Replace missing values with typed sentinel and convert to Vector{Float64} per API requirement
    tcd = TColumnData()
    Thrift.set_field!(tcd, :real_col, convert(Vector{Float64}, coalesce.(x, -1.0)))

    #Complete TColumn
    Thrift.set_field!(tc, :data, tcd)

    return tc
end

function TColumn(x::AbstractVector{<:Union{Missing, AbstractString}})

    #Create TColumn, fill nulls column by checking for missingness
    tc = TColumn()
    Thrift.set_field!(tc, :nulls, convert(Vector{Bool}, ismissing.(x)))

    #Replace missing values with typed sentinel and convert to Vector{Int64} per API requirement
    tcd = TColumnData()
    Thrift.set_field!(tcd, :str_col, convert(Vector{String}, coalesce.(x, "")))

    #Complete TColumn
    Thrift.set_field!(tc, :data, tcd)

    return tc
end

function TColumn(x::AbstractVector{<:Union{Missing, Bool}})

    #Create TColumn, fill nulls column by checking for missingness
    tc = TColumn()
    Thrift.set_field!(tc, :nulls, convert(Vector{Bool}, ismissing.(x)))

    #Replace missing values with typed sentinel and convert to Vector{Int64} per API requirement
    tcd = TColumnData()
    Thrift.set_field!(tcd, :int_col, convert(Vector{Int64}, coalesce.(x, -1)))

    #Complete TColumn
    Thrift.set_field!(tc, :data, tcd)

    return tc
end

# Dispatches to Int
TColumn(x::AbstractVector{<:Union{Missing, DateTime}}) = TColumn(convert(Vector{Int}, datetime2unix.(x)))

# Dispatches to DateTime, which dispatches to Int
TColumn(x::AbstractVector{<:Union{Missing, Date}}) = TColumn(convert(Vector{DateTime}, x))

# Dispatches to Int
TColumn(x::AbstractVector{<:Union{Missing, Time}}) = TColumn(seconds_since_midnight.(x))
