######################################## connection, admin

"""
    connect(host::String, port::Int, user::String, passwd::String, dbname::String)

Connect to an OmniSci database.

# Examples
```julia-repl
julia> conn = connect("localhost", 6274, "admin", "HyperInteractive", "omnisci")
Connected to localhost:6274
```
"""
function connect(host::String, port::Int, user::String, passwd::String, dbname::String)

    socket = TSocket(host, port)

    #create libuv socket and keep-alive
    tcp = connect(host, port) #connect from Sockets library
    err = ccall(:uv_tcp_keepalive, Cint, (Ptr{Nothing}, Cint, Cuint), tcp.handle, 1, 1)
    err != 0 && error("Error setting keepalive on socket")

    Thrift.set_field!(socket, :io, tcp)
    #transport = TBufferedTransport(socket) # https://github.com/tanmaykm/Thrift.jl/issues/12
    proto = TBinaryProtocol(socket, false, true)
    c = MapDClient(proto)

    session = connect(c, user, passwd, dbname)

    return OmniSciConnection(session, c)

end

"""
    disconnect(conn::OmniSciConnection)

Close connection to OmniSci database.

# Examples
```julia-repl
julia> disconnect(conn)
Connection to localhost:6274 closed
```
"""
function disconnect(conn::OmniSciConnection)

    disconnect(conn.c, conn.session)
    println("Connection to $(conn.c.p.t.host):$(conn.c.p.t.port) closed")

end

"""
    get_status(conn::OmniSciConnection)

Displays properties of OmniSci server, such as version and rendering capabilities.

# Examples
```julia-repl
julia> status = get_status(conn)
OmniSci.TServerStatus

  read_only: false
  version: 4.1.3-20180926-66c2aee949
  rendering_enabled: false
  start_time: 1540579280
  edition: ce
  host_name: aggregator
  poly_rendering_enabled: false
```
"""
get_status(conn::OmniSciConnection) =
    get_status(conn.c, conn.session)

"""
    get_hardware_info(conn::OmniSciConnection)

Displays selected properties of hardware where OmniSci running, such as
GPU and CPU information.

# Examples
```julia-repl
julia> hardware = get_hardware_info(conn)
OmniSci.TClusterHardwareInfo(OmniSci.THardwareInfo[THardwareInfo(0, 12, 0, 0, "", OmniSci.TGpuSpecification[])])
```
"""
get_hardware_info(conn::OmniSciConnection) =
    get_hardware_info(conn.c, conn.session)

"""
    get_tables_meta(conn::OmniSciConnection; as_df::Bool = true)

Get metadata for tables in database specified in `connect()`.

# Examples
```julia-repl
julia> metad = get_tables_meta(conn)
5×6 DataFrame
│ Row │ is_replicated │ is_view │ max_rows            │ num_cols │ shard_count │ table_name        │
│     │ Bool          │ Bool    │ Int64               │ Int64    │ Int64       │ String            │
├─────┼───────────────┼─────────┼─────────────────────┼──────────┼─────────────┼───────────────────┤
│ 1   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ omnisci_states    │
│ 2   │ false         │ false   │ 4611686018427387904 │ 6        │ 0           │ omnisci_counties  │
│ 3   │ false         │ false   │ 4611686018427387904 │ 64       │ 0           │ omnisci_countries │
│ 4   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test2             │
│ 5   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test              │
```
"""
get_tables_meta(conn::OmniSciConnection; as_df::Bool = true) =
    as_df ? DataFrame(get_tables_meta(conn.c, conn.session)) : get_tables_meta(conn.c, conn.session)

"""
    get_table_details(conn::OmniSciConnection, table_name::String; as_df::Bool = true)

Get table details such as column names and types.

# Examples
```julia-repl
julia> tbl_detail = get_table_details(conn, "omnisci_states")
4×21 DataFrame. Omitted printing of 15 columns
│ Row │ col_name    │ col_type     │ comp_param │ encoding │ is_array │ is_physical │
│     │ String      │ DataType     │ Int32      │ String   │ Bool     │ Bool        │
├─────┼─────────────┼──────────────┼────────────┼──────────┼──────────┼─────────────┤
│ 1   │ id          │ String       │ 32         │ Dict     │ false    │ false       │
│ 2   │ abbr        │ String       │ 32         │ Dict     │ false    │ false       │
│ 3   │ name        │ String       │ 32         │ Dict     │ false    │ false       │
│ 4   │ omnisci_geo │ MultiPolygon │ 32         │ GeoInt   │ false    │ false       │
```
"""
function get_table_details(conn::OmniSciConnection, table_name::String; as_df::Bool = true)

    r = get_table_details(conn.c, conn.session, table_name)

    #for dataframe, put enum values instead of keys for column type
    #makes it easier to determine column types in load_table and sql_execute
    if as_df
        df = DataFrame(r)
        df[!, :col_type] = getcolumntype.(df.col_type)
        df[!, :encoding] = getencodingtype.(df.encoding)
        return df
    else
        return r
    end
end

"""
    get_users(conn::OmniSciConnection; as_df::Bool = true)

Get list of users who have access to database specified in `connect()`.

# Examples
```julia-repl
julia> users = get_users(conn)
1×1 DataFrame
│ Row │ users  │
│     │ String │
├─────┼────────┤
│ 1   │ mapd   │
```
"""
get_users(conn::OmniSciConnection; as_df::Bool = true) =
    as_df ? DataFrame(Dict(:users => get_users(conn.c, conn.session))) : get_users(conn.c, conn.session)

"""
    get_databases(conn::OmniSciConnection; as_df::Bool=true)

Get list of databases.

# Examples
```julia-repl
julia> db = get_databases(conn)
1×2 DataFrame
│ Row │ db_name │ db_owner │
│     │ String  │ String   │
├─────┼─────────┼──────────┤
│ 1   │ mapd    │ mapd     │
```
"""
get_databases(conn::OmniSciConnection; as_df::Bool=true) =
    as_df ? DataFrame(get_databases(conn.c, conn.session)) : get_databases(conn.c, conn.session)

"""
    get_memory(conn::OmniSciConnection, memory_level::String)

Get memory profile from current session. Acceptable values for `memory_level` are "cpu" or "gpu".

# Examples
```julia-repl
julia> gm = OmniSci.get_memory(conn, "cpu")
1-element Array{OmniSci.TNodeMemoryInfo,1}:
 OmniSci.TNodeMemoryInfo("", 512, 25692761, 8388608, false, OmniSci.TMemoryData[TMemoryData(0, 0, 26, 0, [1, 2, 1, 0], 0, false), TMemoryData(0, 26, 26, 1, [1, 2, 2, 0], 0, false), TMemoryData(0, 52, 26, 2, [1, 2, 3, 0], 0, false), TMemoryData(0, 78, 26, 3, [1, 2, 4, 0], 0, false), TMemoryData(0, 104, 26, 4, [1, 2, 5, 0], 0, false), TMemoryData(0, 130, 533,5, [1, 2, 7, 0, 1], 0, false), TMemoryData(0, 663, 26, 6, [1, 2, 7, 0, 2], 0, false), TMemoryData(0, 689, 28, 7, [1, 2,8, 0, 1], 0, false), TMemoryData(0, 717, 26, 8, [1, 2, 8, 0, 2], 0, false), TMemoryData(0, 743, 28, 9, [1, 2, 9, 0, 1],0, false), TMemoryData(0, 771, 26, 10, [1, 2, 9, 0, 2], 0, false), TMemoryData(0, 797, 204, 11, [1, 2, 10, 0], 0, false), TMemoryData(0, 1001, 26, 12, [1, 2, 11, 0], 0, false), TMemoryData(0, 1027, 8387581, 0, Int64[], 0, true)])
```
"""
function get_memory(conn::OmniSciConnection, memory_level::String)

    @assert memory_level in ["cpu", "gpu"] """memory level can be one of: \"cpu\", \"gpu\""""
    get_memory(conn.c, conn.session, memory_level)
end

"""
    clear_cpu_memory(conn::OmniSciConnection)

Clears CPU memory. This function returns `nothing`.

# Examples
```julia-repl
julia> cm = OmniSci.clear_cpu_memory(conn)
```
"""
clear_cpu_memory(conn::OmniSciConnection) =
    clear_cpu_memory(conn.c, conn.session)

"""
    clear_gpu_memory(conn::OmniSciConnection)

Clears GPU memory. This function returns `nothing`.

# Examples
```julia-repl
julia> cgm = OmniSci.clear_gpu_memory(conn)

"""
clear_gpu_memory(conn::OmniSciConnection) =
    clear_gpu_memory(conn.c, conn.session)

######################################## query, render

"""
    sql_execute(conn::OmniSciConnection, query::String; first_n::Int = -1, at_most_n::Int = -1, as_df::Bool = true)

Execute a SQL query.

"""
function sql_execute(conn::OmniSciConnection, query::String; first_n::Int = -1, at_most_n::Int = -1, as_df::Bool = true)

    #asserting here, rather than pass a bad query and getting an TMapDException
    @assert (first_n < 0 || at_most_n < 0) "Only one of 'first_n' and 'at_most_n' can be set at one time"

    #true hard-coded for column_format, as its not clear there is any benefit to providing row-wise parsing (slow)
    result = sql_execute(conn.c, conn.session, query, true, randstring(32), Int32(first_n), Int32(at_most_n))

    #test if query string expected to return a df-like result
    #minimizes returning 0x0 dataframe
    as_df && startswith(lowercase(lstrip(query)), "select") ? DataFrame(result) : nothing

end

"""
    sql_execute_df(conn::OmniSciConnection, query::String, device_type::Int, device_id::Int, first_n::Int = -1)

Execute a SQL query using Apache Arrow IPC (CPU). This method requires running the code in the same environment where
OmniSci is running. This method is currently unsupported, until such time when Julia can read Arrow buffers.

"""
sql_execute_df(conn::OmniSciConnection, query::String, device_type::Int, device_id::Int, first_n::Int = -1) =
    sql_execute_df(conn.c, conn.session, query, Int32(device_type), Int32(device_id), Int32(first_n))

"""
    sql_execute_gdf(conn::OmniSciConnection, query::String, device_id::Int; first_n::Int = -1)

Execute a SQL query using Apache Arrow IPC (GPU). This method requires running the code in the same environment where
OmniSci is running. This method is currently unsupported, until such time when Julia can read Arrow buffers.

"""
sql_execute_gdf(conn::OmniSciConnection, query::String, device_id::Int; first_n::Int = -1) =
    sql_execute_gdf(conn.c, conn.session, query, Int32(device_id), Int32(first_n))

"""
    deallocate_df(conn::OmniSciConnection, df::TDataFrame, device_type::Int, device_id::Int)

"""
deallocate_df(conn::OmniSciConnection, df::TDataFrame, device_type::Int, device_id::Int) =
    deallocate_df(conn.c, conn.session, df, Int32(device_type), Int32(device_id))

"""
    interrupt(conn::OmniSciConnection)

"""
interrupt(conn::OmniSciConnection) =
    interrupt(conn.c, conn.session)

"""
    set_execution_mode(conn::OmniSciConnection, mode::TExecuteMode.Enum)

Sets execution mode for server during session. This function returns `nothing`.

# Examples
```julia-repl
julia> set_execution_mode(conn, TExecuteMode.CPU)
```

"""
set_execution_mode(conn::OmniSciConnection, mode::TExecuteMode.Enum) =
    set_execution_mode(conn.c, conn.session, mode.value)

"""
    render_vega(conn::OmniSciConnection, vega_json::String, compression_level::Int = 0)

Render an OmniSci-flavored Vega specification using the backend rendering engine. Note that OmniSci does
not currently support the full Vega specification; this method is mostly useful for rendering choropleths and
related geospatial charts.

compression_level ranges from 0 (low compression, faster) to 9 (high compression, slower).

# Examples
```julia-repl
julia> vg = {"width" : 1024, "height" : 1024...}

julia> vega_json = render_vega(conn, vg)
```
"""
function render_vega(conn::OmniSciConnection, vega_json::String, compression_level::Int = 0)

    @assert (compression_level >= 0 && compression_level <= 9) "compression_level ranges from 0 (low compression, faster) to 9 (high compression, slower)"
    render_vega(conn.c, conn.session, Int64(1), vega_json, Int32(compression_level), randstring(32))

end

######################################## dashboard

"""
    get_dashboards(conn::OmniSciConnection; as_df::Bool = true)

Gets dashboards that user submitted during connect() can access.

# Examples
```julia-repl
julia> getdbs = get_dashboards(conn)
7×8 DataFrame. Omitted printing of 3 columns
│ Row │ dashboard_id │ dashboard_metadata │ dashboard_name │ dashboard_owner │ dashboard_state │
│     │ Int32        │ String             │ String         │ String          │ String          │
├─────┼──────────────┼────────────────────┼────────────────┼─────────────────┼─────────────────┤
│ 1   │ 9            │ metadata           │ 0vcAQEO1ZD     │ mapd            │                 │
│ 2   │ 6            │ metadata           │ QI0JsthBsB     │ mapd            │                 │
│ 3   │ 5            │ metadata           │ Srm72rCJHa     │ mapd            │                 │
│ 4   │ 4            │ metadata           │ sO0XgMUOZH     │ mapd            │                 │
│ 5   │ 1            │ metadata           │ testdash       │ mapd            │                 │
│ 6   │ 2            │ metadata           │ testdash2      │ mapd            │                 │
│ 7   │ 3            │ metadata           │ testdash3      │ mapd            │                 │
```

"""
get_dashboards(conn::OmniSciConnection; as_df::Bool = true) =
    as_df ? DataFrame(get_dashboards(conn.c, conn.session)) : get_dashboards(conn.c, conn.session)

"""
    create_dashboard(conn::OmniSciConnection, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String)


"""
create_dashboard(conn::OmniSciConnection, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String) =
    create_dashboard(conn.c, conn.session, dashboard_name, dashboard_state, image_hash, dashboard_metadata)

"""
    get_dashboard_grantees(conn::OmniSciConnection, dashboard_id::Integer)

"""
get_dashboard_grantees(conn::OmniSciConnection, dashboard_id::Integer) =
    get_dashboard_grantees(conn.c, conn.session, Int32(dashboard_id))

######################################## import

"""
    load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn})

"""
load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn}) =
    load_table_binary_columnar(conn.c, conn.session, table_name, cols)

"""
    load_table_binary_columnar(conn::OmniSciConnection, table_name::String, tbl_obj)

Load a Tables.jl table into OmniSci. This method loads data column-wise, and should be
used instead of `load_table` unless you encounter an error, as the load should be considerably faster.
Currently, this method requires the table to already exist on OmniSci.

"""
load_table_binary_columnar(conn::OmniSciConnection, table_name::String, tbl_obj) =
    load_table_binary_columnar(conn, table_name, TColumn.(eachcolumn(tbl_obj)))

"""
    load_table_binary_arrow(conn::OmniSciConnection, table_name::String, arrow_stream::Vector{UInt8})

"""
load_table_binary_arrow(conn::OmniSciConnection, table_name::String, arrow_stream::Vector{UInt8}) =
    load_table_binary_arrow(conn.c, conn.session, table_name, arrow_stream)

"""
    load_table(conn::OmniSciConnection, table_name::String, rows::Vector{TStringRow})

"""
load_table(conn::OmniSciConnection, table_name::String, rows::Vector{TStringRow}) =
    load_table(conn.c, conn.session, table_name, rows)

"""
    load_table(conn::OmniSciConnection, table_name::String, rows)

Load a Tables.jl table into OmniSci. This method loads data row-wise, converting data elements to string before upload.
Currently, this method requires the table to already exist on OmniSci.

# Examples
```julia-repl
julia> load_table(conn, "test", df)
```

"""
function load_table(conn::OmniSciConnection, table_name::String, tbl_obj)

    tbl_to_array = [TStringRow(x) for x in rows(tbl_obj)]
    load_table(conn, table_name, tbl_to_array)

end

"""
    create_table(conn::OmniSciConnection, table_name::String, df::DataFrame; dryrun::Bool = false, precision::Tuple{Int,Int} = (0,0))

Create a table in the database specified during authentication. This method takes a Julia DataFrame, reads the column
types and creates the equivalent `create table` statement, optionally printing the `create table` statement instead
of executing the statement using `sql_execute` method.

Note: This method is for convenience purposes only! It does not guarantee an optimized table statement. Additionally,
if Decimal columns present in 'df', user must set precision/scale via the 'precision' argument.

# Examples
```julia-repl
julia> create_table(conn, "test", df)
```

"""
function create_table(conn::OmniSciConnection, table_name::String, tbl_obj;
                      dryrun::Bool = false, precision::Tuple{Int,Int} = (0,0))

    #Only assert if default value changed; check for decimal column in df later
    if precision != (0,0)
        @assert precision[1] > 0 "First number in 'precision' tuple must be greater than 0"

        #Precision of 19 OmniSci limitation
        @assert (precision[1] + precision[2]) <= 19 "Sum of tuple values for 'precision' argument must be <= 19"
    else
        #TODO: check if Decimal column in dataframe and precision = (0,0), throw warning
        #Or throw error telling to set precision
        for x in [Dec32, Dec64, Dec128, Decimal]
            @assert !(x in schema(tbl_obj).types) "Decimal column(s) detected. Please change 'precision' value from (0,0)"
        end
    end

    io = IOBuffer()
    write(io, "create table $table_name ( \n")

    for x in zip(schema(tbl_obj).names, schema(tbl_obj).types)
        write(io, "  " * sanitizecolnames(x[1]) * " ") # function sanitizecolnames would need to
        write(io, "  " * getsqlcoltype(x[2], precision) * ",\n") # lookup to convert julia types to OmniSci types
    end
    query = String(take!(io))

    #remove training comma (also removes trailing newline)
    query = query[1:end-2] * "\n);"

    dryrun ? print(query) : sql_execute(conn, query)

end

######################################## object privileges

"""
    get_roles(conn::OmniSciConnection; as_df::Bool = true)

"""
get_roles(conn::OmniSciConnection; as_df::Bool = true) =
    as_df ? DataFrame(Dict(:roles => get_roles(conn.c, conn.session))) : get_roles(conn.c, conn.session)

"""
    get_all_roles_for_user(conn::OmniSciConnection, userName::String; as_df::Bool = true)

"""
get_all_roles_for_user(conn::OmniSciConnection, userName::String; as_df::Bool = true) =
    as_df ? DataFrame(Dict("roles" => get_all_roles_for_user(conn.c, conn.session, userName))) : get_all_roles_for_user(conn.c, conn.session, userName)
