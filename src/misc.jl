######################################## internals
mutable struct OmniSciConnection
    session::TSessionId
    c::MapDClient
end

#REPL display; show method for Juno uses inline tree display
Base.show(io::IO, ::MIME"text/plain", m::OmniSciConnection) = print(io, "Connected to $(m.c.p.t.host):$(m.c.p.t.port)")

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

######################################## connection, admin

"""
    connect(host::String, port::Int, user::String, passwd::String, dbname::String)

Connect to an OmniSci database.

# Examples
```julia-repl
julia> conn = connect("localhost", 9091, "mapd", "HyperInteractive", "mapd")
Connected to localhost:9091
```
"""
function connect(host::String, port::Int, user::String, passwd::String, dbname::String)

    socket = TSocket(host, port)

    #create libuv socket and keep-alive
    tcp = connect(host, port)
    err = ccall(:uv_tcp_keepalive, Cint, (Ptr{Nothing}, Cint, Cuint), tcp.handle, 1, 1)
    err != 0 && error("error setting keepalive on socket")

    Thrift.set_field!(socket, :io, tcp)
    #transport = TBufferedTransport(socket) # https://github.com/tanmaykm/Thrift.jl/issues/12
    proto = TBinaryProtocol(socket, false, true)
    c = OmniSci.MapDClient(proto)

    session = OmniSci.connect(c, user, passwd, dbname)

    return OmniSciConnection(session, c)

end

"""
    disconnect(conn::OmniSciConnection)

Close connection to OmniSci database.

# Examples
```julia-repl
julia> disconnect(conn)
Connection to localhost:9091 closed
```
"""
function disconnect(conn::OmniSciConnection)

    disconnect(conn.c, conn.session) #consider printing to console that disconnection happened
    print("Connection to $(conn.c.p.t.host):$(conn.c.p.t.port) closed")

end

"""
    get_status(conn::OmniSciConnection)

Displays properties of OmniSci server, such as version and rendering capabilities.

# Examples
```julia-repl
julia> status = get_status(conn)
1-element Array{TServerStatus,1}:
 TServerStatus(false, "4.2.0dev-20181003-0206b9f92c", false, 1539095178, "ee", "aggregator", false)
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
TClusterHardwareInfo(THardwareInfo[THardwareInfo(0, 12, 0, 0, "", TGpuSpecification[])])
```
"""
get_hardware_info(conn::OmniSciConnection) =
    get_hardware_info(conn.c, conn.session)

"""
    get_tables(conn::OmniSciConnection)

Get tables and views for authenticated database specified in `connect()`.

# Examples
```julia-repl
julia> tbl = get_tables(conn)
4-element Array{String,1}:
 "mapd_states"
 "mapd_counties"
 "mapd_countries"
 "nyc_trees_2015_683k"
```
"""
get_tables(conn::OmniSciConnection) =
    get_tables(conn.c, conn.session)

"""
    get_physical_tables(conn::OmniSciConnection)

Get tables for authenticated database specified in `connect()`.

# Examples
```julia-repl
julia> ptbl = get_physical_tables(conn)
4-element Array{String,1}:
 "mapd_states"
 "mapd_counties"
 "mapd_countries"
 "nyc_trees_2015_683k"
```
"""
get_physical_tables(conn::OmniSciConnection) =
    get_physical_tables(conn.c, conn.session)

"""
    get_views(conn::OmniSciConnection)

Get views for authenticated database specified in `connect()`.

# Examples
```julia-repl
julia> vw = get_views(conn)
0-element Array{String,1}
```
"""
get_views(conn::OmniSciConnection) =
    get_views(conn.c, conn.session)

"""
    get_tables_meta(conn::OmniSciConnection)

Get metadata for tables in database specified in `connect()`.

# Examples
```julia-repl
julia> metad = get_tables_meta(conn)
4-element Array{TTableMeta,1}:
 TTableMeta("mapd_states", 4, Int32[6, 16], false, false, 0, 4611686018427387904)
 TTableMeta("mapd_counties", 6, Int32[6, 16], false, false, 0, 4611686018427387904)
 TTableMeta("mapd_countries", 64, Int32[1, 5, 6, 16], false, false, 0, 4611686018427387904)
 TTableMeta("nyc_trees_2015_683k", 42, Int32[0, 3, 6, 9], false, false, 0, 4611686018427387904)
```
"""
get_tables_meta(conn::OmniSciConnection) =
    get_tables_meta(conn.c, conn.session)

"""
    get_table_details(conn::OmniSciConnection, table_name::String)

Get table details such as column names and types.

# Examples
```julia-repl
julia> tbl_detail = get_table_details(conn, "mapd_states")
TTableDetails(TColumnType[TColumnType("id", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, "", false, false), TColumnType("abbr", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, "", false, false), TColumnType("name", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, "", false, false), TColumnType("mapd_geo", TTypeInfo(16, 6, true, false, 23, 4326, 32, -1), false, "", false, false)], 32000000, 2097152, 4611686018427387904, "", 0, "[]", false, 0)
```
"""
get_table_details(conn::OmniSciConnection, table_name::String) =
    get_table_details(conn.c, conn.session, table_name)

"""
    get_users(conn::OmniSciConnection)

Get list of users who have access to database specified in `connect()`.

# Examples
```julia-repl
julia> users = get_users(conn)
1-element Array{String,1}:
 "mapd"
```
"""
get_users(conn::OmniSciConnection) =
    get_users(conn.c, conn.session)

"""
    get_databasesconn::OmniSciConnection

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_databases(conn::OmniSciConnection) =
    get_databases(conn.c, conn.session)

"""
    get_version()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_version(conn::OmniSciConnection) =
    get_version(conn.c)

"""
    get_memory()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_memory(conn::OmniSciConnection, memory_level::String) =
    get_memory(conn.c, conn.session, memory_level)

"""
    clear_cpu_memory()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
clear_cpu_memory(conn::OmniSciConnection) =
    clear_cpu_memory(conn.c, conn.session)

"""
    clear_gpu_memory()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
clear_gpu_memory(conn::OmniSciConnection) =
    clear_gpu_memory(conn.c, conn.session)

######################################## query, render

"""
    sql_execute()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
function sql_execute(conn::OmniSciConnection, query::String, column_format::Bool, first_n::Int = -1, at_most_n::Int = -1)

    first_n > 0 && at_most_n > 0 ? error("Only one of first_n and at_most_n can be set at one time") : nothing

    result = sql_execute(conn.c, conn.session, query, column_format, randstring(32), Int32(first_n), Int32(at_most_n))

end

"""
    sql_execute_df()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
sql_execute_df(conn::OmniSciConnection, query::String, device_type::Int, device_id::Int, first_n::Int = -1) =
    sql_execute_df(conn.c, conn.session, query, Int32(device_type), Int32(device_id), Int32(first_n))

"""
    sql_execute_gdf()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
sql_execute_gdf(conn::OmniSciConnection, query::String, device_id::Int, first_n::Int = -1) =
    sql_execute_gdf(conn.c, conn.session, query, Int32(device_id), Int32(first_n))

"""
    deallocate_df()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
deallocate_df(conn::OmniSciConnection, df::TDataFrame, device_type::Int, device_id::Int) =
    deallocate_df(conn.c, conn.session, df, Int32(device_type), Int32(device_id))

"""
    interrupt()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
interrupt(conn::OmniSciConnection) =
    interrupt(conn.c, conn.session)

"""
    sql_validate()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
sql_validate(conn::OmniSciConnection, query::String) =
    sql_validate(conn.c, conn.session, query)

"""
    set_execution_mode()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
set_execution_mode(conn::OmniSciConnection, mode::TExecuteMode.Enum) =
    set_execution_mode(conn.c, conn.session, mode.value)

"""
    render_vega()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
render_vega(conn::OmniSciConnection, widget_id::Int, vega_json::String, compression_level::Int) =
    render_vega(conn.c, conn.session, Int64(widget_id), vega_json, Int32(compression_level), randstring(32))

######################################## dashboard

"""
    get_dashboard()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_dashboard(conn::OmniSciConnection, dashboard_id::Int) =
    get_dashboard(conn.c, conn.session, Int32(dashboard_id))

"""
    get_dashboards()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_dashboards(conn::OmniSciConnection) =
    get_dashboards(conn.c, conn.session)

"""
    create_dashboard()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
create_dashboard(conn::OmniSciConnection, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String) =
    create_dashboard(conn.c, conn.session, dashboard_name, dashboard_state, image_hash, dashboard_metadata)

"""
    replace_dashboard()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
replace_dashboard(conn::OmniSciConnection, dashboard_id::Int, dashboard_name::String, dashboard_owner::String, dashboard_state::String, image_hash::String, dashboard_metadata::String) =
    replace_dashboard(conn.c, conn.session, Int32(dashboard_id), dashboard_name, dashboard_owner, dashboard_state, image_hash, dashboard_metadata)

"""
    delete_dashboard()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
delete_dashboard(conn::OmniSciConnection, dashboard_id::Int) =
    delete_dashboard(conn.c, conn.session, Int32(dashboard_id))

"""
    share_dashboard()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
share_dashboard(conn::OmniSciConnection, dashboard_id::Int, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions) =
    share_dashboard(conn.c, conn.session, Int32(dashboard_id), groups, objects, permissions)

"""
    unshare_dashboard()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
unshare_dashboard(conn::OmniSciConnection, dashboard_id::Int, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions) =
    unshare_dashboard(conn.c, conn.session, Int32(dashboard_id), groups, objects, permissions)

"""
    get_dashboard_grantees()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_dashboard_grantees(conn::OmniSciConnection, dashboard_id::Int) =
    get_dashboard_grantees(conn.c, conn.session, Int32(dashboard_id))

######################################## import

"""
    load_table_binary()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
load_table_binary(conn::OmniSciConnection, table_name::String, rows::Vector{TRow}) =
    load_table_binary(conn.c, conn.session, table_name, rows)

"""
    load_table_binary_columnar()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn}) =
    load_table_binary_columnar(conn.c, conn.session, table_name, cols)

"""
    load_table_binary_arrow()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
load_table_binary_arrow(conn::OmniSciConnection, table_name::String, arrow_stream::Vector{UInt8}) =
    load_table_binary_arrow(conn.c, conn.session, table_name, arrow_stream)

"""
    load_table()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
load_table(conn::OmniSciConnection, table_name::String, rows::Vector{TStringRow}) =
    load_table(conn.c, conn.session, table_name, rows)

"""
    detect_column_types()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
detect_column_types(conn::OmniSciConnection, file_name::String, copy_params::TCopyParams) =
    detect_column_types(conn.c, conn.session, file_name, copy_params)

"""
    create_table()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
create_table(conn::OmniSciConnection, table_name::String, row_desc::TRowDescriptor, table_type::TTableType.Enum) =
    create_table(conn.c, conn.session, table_name, row_desc, table_type.value)

"""
    import_table()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
import_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams) =
    import_table(conn.c, conn.session, table_name, file_name, copy_params)

"""
    import_geo_table()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
import_geo_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams, row_desc::TRowDescriptor) =
    import_geo_table(conn.c, conn.session, table_name, file_name, copy_params, row_desc)

"""
    import_table_status()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
import_table_status(conn::OmniSciConnection, import_id::String) =
    import_table_status(conn.c, conn.session, import_id)

######################################## object privileges

"""
    get_roles()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_roles(conn::OmniSciConnection) =
    get_dashboards(conn.c, conn.session)

"""
    get_db_objects_for_grantee()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_db_objects_for_grantee(conn::OmniSciConnection, roleName::String) =
    get_db_objects_for_grantee(conn.c, conn.session, roleName)

"""
    get_db_object_privs()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_db_object_privs(conn::OmniSciConnection, objectName::String, type_::Int) =
    get_db_object_privs(conn.c, conn.session, objectName, Int32(type_))

"""
    get_all_roles_for_user()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_all_roles_for_user(conn::OmniSciConnection, userName::String) =
    get_all_roles_for_user(conn.c, conn.session, userName)

######################################## licensing

"""
    set_license_key()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
set_license_key(conn::OmniSciConnection, key::String) =
    set_license_key(conn.c, conn.session, key, randstring(32))

"""
    get_license_claims()

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
get_license_claims(conn::OmniSciConnection) =
    get_license_claims(conn.c, conn.session, randstring(32))
