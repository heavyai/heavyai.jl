########################### Common/Utils ###########################

#Convenience struct to pass `conn` each time instead of the parts
mutable struct OmniSciConnection
    session::TSessionId
    c::MapDClient
end

#convert methods implicitly needed for squashbitmask
convert(::Type{DateTime}, x::Int64) = unix2datetime(x)
convert(::Type{Date}, x::Int64) =  Date(unix2datetime(x))
convert(::Type{Time}, x::Int64) = Time(x/3600, x % 3600)

#conversions from WKT to GeoInterface types, to get typed df from sql_execute
convert(::Type{Point}, x::String) = Point(readgeom(x))
convert(::Type{LineString}, x::String) = LineString(readgeom(x))
convert(::Type{Polygon}, x::String) = Polygon(readgeom(x))
convert(::Type{MultiPolygon}, x::String) = MultiPolygon(readgeom(x))

#WKT from LibGEOS types
wkt(x::AbstractPoint) =  writegeom(LibGEOS.Point(x))
wkt(x::AbstractLineString) = writegeom(LibGEOS.LineString(x))
wkt(x::AbstractPolygon) = writegeom(LibGEOS.Polygon(x))
wkt(x::AbstractMultiPolygon) = writegeom(LibGEOS.MultiPolygon(x))
wkt(x::T) where T <: Union{String, Missing} = ""

#Define these methods to avoid type piracy
myDateTime(x::Missing) = missing
myDateTime(x) = DateTime(x)

mydatetime2unix(x::Missing) = missing
mydatetime2unix(x) = datetime2unix(floor(x, Second))

myInt64(x::Missing) = missing
myInt64(x) = Int64(x)

#Find which field in the struct the data actually is
function findvalues(x::TColumn)
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
function getsqlcoltype(x, precision::Tuple{Int, Int})

    dec = "DECIMAL$precision"

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
        Union{Missing, Point} => "POINT",
        Point => "POINT",
        Union{Missing, LineString} => "LINESTRING",
        LineString => "LINESTRING",
        Union{Missing, Polygon} => "POLYGON",
        Polygon => "POLYGON",
        Union{Missing, MultiPolygon} => "MULTIPOLYGON",
        MultiPolygon => "MULTIPOLYGON",
        #arrays
        Array{Union{Missing, Int8},1} => "TINYINT[]",
        Array{Int8,1} => "TINYINT[]",
        Array{Union{Missing, Int16},1} => "SMALLINT[]",
        Array{Int16,1} => "SMALLINT[]",
        Array{Union{Missing, Int32},1} => "INTEGER[]",
        Array{Int32,1} => "INTEGER[]",
        Array{Union{Missing, Int64},1} => "BIGINT[]",
        Array{Int64,1} => "BIGINT[]",
        Array{String,1} => "TEXT[]",
        Array{Union{Missing, Float32},1} => "FLOAT[]",
        Array{Float32,1} => "FLOAT[]",
        Array{Union{Missing, Float64},1} => "DOUBLE[]",
        Array{Float64,1} => "DOUBLE[]",
        Array{Union{Missing, Bool},1} => "BOOLEAN[]",
        Array{Bool,1} => "BOOLEAN[]",
        Array{Union{Missing, Date},1} => "DATE[]",
        Array{Date,1} => "DATE[]",
        Array{Union{Missing, Time},1} => "TIME[]",
        Array{Time,1} => "TIME[]",
        Array{Union{Missing, DateTime},1} => "TIMESTAMP[]",
        Array{DateTime,1} => "TIMESTAMP[]",
        #DecFP
        Union{Dec32, Missing} => dec,
        Dec32 => dec,
        Union{Dec64, Missing} => dec,
        Dec64 => dec,
        Union{Dec128, Missing} => dec,
        Dec128 => dec,
        #Decimals.jl
        Union{Decimal, Missing} => dec,
        Decimal => dec,
        #missing: default to TEXT ENCODING DICT as design decision
        #https://github.com/omnisci/OmniSci.jl/issues/76
        Missing => "TEXT ENCODING DICT"
    )

    get(lookup, x, "Unknown")

end

########################### Typedefs for load_table method ###########################

#For functions below, value for is_null should be known based on the dispatched type
#Left as keyword just in case my assumption incorrect

# convert vectors to string representations for atomic types only
function TStringValue(str_val::Vector{<:Union{Real, String, Char, TimeType, Missing}})
  val = TStringValue()

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
  Thrift.set_field!(val, :is_null, false)
  return val
end

function TStringValue(str_val::T) where T <: Union{AbstractLineString, AbstractPoint, AbstractPolygon, AbstractMultiPolygon}
  val = TStringValue()
  p = wkt(str_val)
  Thrift.set_field!(val, :str_val, p)
  Thrift.set_field!(val, :is_null, false)
  return val
end

function TStringValue(str_val::Rational)
  val = TStringValue()
  Thrift.set_field!(val, :str_val, string(convert(Float64, str_val)))
  Thrift.set_field!(val, :is_null, false)
  return val
end

#generic fallback for any type serializable with string()
function TStringValue(str_val, is_null::Bool = false)
  val = TStringValue()
  Thrift.set_field!(val, :str_val, string(str_val))
  Thrift.set_field!(val, :is_null, is_null)
  return val
end
TStringValue(str_val::T) where T <: Union{Missing, Nothing} = TStringValue(str_val, true)

function TStringRow(cols::Vector{TStringValue})
    tsr = TStringRow()
    Thrift.set_field!(tsr, :cols, cols)
    return tsr
end

TStringRow(cols) = TStringRow(TStringValue.(eachcolumn(cols)))

########################### Typedefs for load_table_binary_columnar method ###########################
function TColumn(x::AbstractVector{<:AbstractVector{T}}) where T #array of arrays

    #Create TColumn, fill nulls column by checking for missingness
    tc = TColumn()
    Thrift.set_field!(tc, :nulls, convert(Vector{Bool}, ismissing.(x)))

    #Create TColumnData for the arr_col, which is a Vector{TColumn}
    tcd = TColumnData()
    Thrift.set_field!(tcd, :arr_col, TColumn.(x))

    #Complete TColumn
    Thrift.set_field!(tc, :data, tcd)

    return tc
end


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

    #Replace missing values with typed sentinel and convert to Vector{String} per API requirement
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

function TColumn(x::AbstractVector{<:Union{Missing, T}}) where T <: Union{AbstractPoint, AbstractPolygon, AbstractLineString, AbstractMultiPolygon}

    #Create TColumn, fill nulls column by checking for missingness
    tc = TColumn()
    Thrift.set_field!(tc, :nulls, convert(Vector{Bool}, ismissing.(x)))

    #Convert geo types to string
    tcd = TColumnData()
    Thrift.set_field!(tcd, :str_col, wkt.(x))

    #Complete TColumn
    Thrift.set_field!(tc, :data, tcd)

    return tc
end

#for a missing column, default to empty string column per https://github.com/omnisci/OmniSci.jl/pull/77
function TColumn(x::AbstractVector{Missing})

    #Create TColumn, fill nulls column by checking for missingness
    tc = TColumn()
    Thrift.set_field!(tc, :nulls, convert(Vector{Bool}, ismissing.(x)))

    #Replace missing values with typed sentinel and convert to Vector{String} per API requirement
    tcd = TColumnData()
    Thrift.set_field!(tcd, :str_col, convert(Vector{String}, coalesce.(x, "")))

    #Complete TColumn
    Thrift.set_field!(tc, :data, tcd)

    return tc
end

# Dispatches to Int after conversion function applied
TColumn(x::AbstractVector{<:Union{Missing, DateTime}}) = TColumn(myInt64.(mydatetime2unix.(x)))
TColumn(x::AbstractVector{<:Union{Missing, Time}}) = TColumn(seconds_since_midnight.(x))

#Before OmniSci 4.4, Dates were specified in epoch seconds
TColumn(x::AbstractVector{<:Union{Missing, Date}}) = TColumn(myDateTime.(x))
