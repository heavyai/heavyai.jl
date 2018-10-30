mutable struct OmniSciConnection
    session::TSessionId
    c::MapDClient
end

#For functions below, value for is_null should be known based on the dispatched type
#Left as keyword just in case my assumption incorrect
function TStringValue(str_val::Rational, is_null::Bool = false)
  val = OmniSci.TStringValue()
  Thrift.set_field!(val, :str_val, string(convert(Float64, str_val)))
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::T, is_null::Bool = false) where T <: Union{Real, AbstractString}
  val = OmniSci.TStringValue()
  Thrift.set_field!(val, :str_val, string(str_val))
  Thrift.set_field!(val, :is_null, is_null)
  return val
end

function TStringValue(str_val::T, is_null::Bool = true) where T <: Union{Missing, Nothing}
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

#REPL display; show method for Juno uses inline tree display
Base.show(io::IO, ::MIME"text/plain", m::OmniSciConnection) = println(io, "Connected to $(m.c.p.t.host):$(m.c.p.t.port)")

function load_buffer(handle::Vector{UInt8}, size::Int)

    # get key as UInt32, then get string value instead of len 1 array
    shmkey = reinterpret(UInt32, handle)[1]

    # use <sys/ipc.h> from C standard library to get shared memory id
    # validate that shmget returns a valid id
    shmid = ccall((:shmget, "libc"), Cint, (Cuint, Int32, Int32), shmkey, size, 0)
    shmid == -1 ? error("Invalid shared memory key: $shmkey") : nothing

    # with shmid, get shared memory start address
    ptr = ccall((:shmat, "libc"), Ptr{Nothing}, (Cint, Ptr{Nothing}, Cint), shmid, C_NULL, 0)

    # makes a zero-copy reference to memory, true gives ownership to julia
    # validate that memory no longer needs to be released using MapD methods
    return unsafe_wrap(Array, convert(Ptr{UInt8}, ptr), size)

end

#Find which field in the struct the data actually is
function findvalues(x::OmniSci.TColumn)
    for f in propertynames(x.data)
        n = length(getfield(x.data, f))
        if n > 0
            return (f, eltype(getfield(x.data, f)), n)
        end
    end
end

#Take two vectors, values and nulls, make into a single vector
function squashbitmask(x::TColumn)

    #Get location of data from struct, eltype of vector and its length
    valuescol, ltype, n = findvalues(x)

    #Build/fill new vector based on missingness
    A = Vector{Union{ltype, Missing}}(undef, n)
    @simd for i = 1:n
        @inbounds A[i] = ifelse(x.nulls[i], missing, getfield(x.data, valuescol)[i])
    end

    return A
end
