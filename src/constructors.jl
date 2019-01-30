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

#conversions from WKT to GeoInterface types, to get typed df from sql_execute
convert(::Type{GeoInterface.Point}, x::String) = GeoInterface.Point(LibGEOS.readgeom(x))
convert(::Type{GeoInterface.LineString}, x::String) = GeoInterface.LineString(LibGEOS.readgeom(x))
convert(::Type{GeoInterface.Polygon}, x::String) = GeoInterface.Polygon(LibGEOS.readgeom(x))
convert(::Type{GeoInterface.MultiPolygon}, x::String) = GeoInterface.MultiPolygon(LibGEOS.readgeom(x))

#Define these methods to avoid type piracy
myDateTime(x::Missing) = missing
myDateTime(x) = DateTime(x)

mydatetime2unix(x::Missing) = missing
mydatetime2unix(x) = datetime2unix(x)

epochdays(x::Missing) = missing
epochdays(x) = (x - Dates.Date("1970-01-01")).value

myInt64(x::Missing) = missing
myInt64(x) = Int64(x)

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
seconds_since_midnight(x::Missing) = missing

#TODO: ensure valid col names
#1. check if first character a number, prepend some valid string
#2. check if in reserved word list, append _ if reserved
function sanitizecolnames(x::Symbol)
    str = string(x)
end

#convert julia types to OmniSci types
function getsqlcoltype(x)

    lookup = Dict(
        #ints
        Union{Missing, Int8} => "TINYINT",
        Int8 => "TINYINT",
        Union{Missing, Int16} => "SMALLINT",
        Int16 => "SMALLINT",
        Union{Missing, Int32} => "INTEGER",
        Int32 => "INTEGER",
        Union{Missing, Int64} => "BIGINT",
        Int64 => "BIGINT",
        #floats
        Union{Missing, Float32} => "FLOAT",
        Float32 => "FLOAT",
        Union{Missing, Float64} => "DOUBLE",
        Float64 => "DOUBLE",
        #rational: convert to float, rational not avail in OmniSci
        Union{Missing, Rational} => "FLOAT",
        Rational => "FLOAT",
        #strings
        Union{String, Missing} => "TEXT ENCODING DICT",
        String => "TEXT ENCODING DICT",
        #bool
        Union{Missing, Bool} => "BOOLEAN",
        Bool => "BOOLEAN",
        #dates and time
        Union{Missing, Date} => "DATE",
        Date => "DATE",
        Union{Missing, Time} => "TIME",
        Time => "TIME",
        Union{Missing, DateTime} => "TIMESTAMP",
        DateTime => "TIMESTAMP",
        #geospatial
        Union{Missing, GeoInterface.Point} => "POINT",
        GeoInterface.Point => "POINT",
        Union{Missing, GeoInterface.LineString} => "LINESTRING",
        GeoInterface.LineString => "LINESTRING",
        Union{Missing, GeoInterface.Polygon} => "POLYGON",
        GeoInterface.Polygon => "POLYGON",
        Union{Missing, GeoInterface.MultiPolygon} => "MULTIPOLYGON",
        GeoInterface.MultiPolygon => "MULTIPOLYGON"
    )

    get(lookup, x, "Unknown")

end

########################### Typedefs for load_table method ###########################

#For functions below, value for is_null should be known based on the dispatched type
#Left as keyword just in case my assumption incorrect

# convert vectors to string representations for atomic types only
function TStringValue(str_val::Vector{<:Union{Real, String, Char, TimeType, Missing}}, is_null::Bool = false)
  val = OmniSci.TStringValue()

  #Write values into buffer to avoid any weird display issues
  io = IOBuffer()
  write(io, "{")

  for val in str_val[1:end-1]
    ismissing(val) ? val_ = "NA" : val_ = val
    write(io, string(val_))
    write(io, ",")
  end

  #for last value in array, don't add trailing comma
  ismissing(str_val[end]) ? lastval = "NA" : lastval = str_val[end]
  write(io, string(lastval))
  write(io, "}")

  p = String(take!(io))

  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::GeoInterface.AbstractPoint, is_null::Bool = false)
  val = OmniSci.TStringValue()
  p = writegeom(LibGEOS.Point(str_val))
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::GeoInterface.AbstractLineString, is_null::Bool = false)
  val = OmniSci.TStringValue()
  p = writegeom(LibGEOS.LineString(str_val))
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::GeoInterface.AbstractPolygon, is_null::Bool = false)
  val = OmniSci.TStringValue()
  p = writegeom(LibGEOS.Polygon(str_val))
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::GeoInterface.AbstractMultiPolygon, is_null::Bool = false)
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

#generic fallback for any type serializable with string()
function TStringValue(str_val, is_null::Bool = false)
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

TStringRow(cols::T) where T <: Union{AbstractVector, DataFrameRow{DataFrame}} = TStringRow(TStringValue.(cols))

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

# Dispatches to Int after conversion function applied
TColumn(x::AbstractVector{<:Union{Missing, DateTime}}) = TColumn(myInt64.(mydatetime2unix.(x)))
TColumn(x::AbstractVector{<:Union{Missing, Time}}) = TColumn(seconds_since_midnight.(x))

TColumn(x::AbstractVector{<:Union{Missing, Date}}) = TColumn(epochdays.(x))
