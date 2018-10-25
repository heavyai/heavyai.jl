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
    tcp = Sockets.connect(host, port)
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
    get_tables_meta(conn::OmniSciConnection, as_df::Bool = true)

Get metadata for tables in database specified in `connect()`.

# Examples
```julia-repl
julia> metad = get_tables_meta(conn)
5×6 DataFrame. Omitted printing of 1 columns
│ Row │ is_replicated │ is_view │ max_rows            │ num_cols │ shard_count │
│     │ Bool          │ Bool    │ Int64               │ Int64    │ Int64       │
├─────┼───────────────┼─────────┼─────────────────────┼──────────┼─────────────┤
│ 1   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │
│ 2   │ false         │ false   │ 4611686018427387904 │ 6        │ 0           │
│ 3   │ false         │ false   │ 4611686018427387904 │ 64       │ 0           │
│ 4   │ false         │ false   │ 4611686018427387904 │ 56       │ 0           │
│ 5   │ false         │ false   │ 4611686018427387904 │ 42       │ 0           │
```
"""
get_tables_meta(conn::OmniSciConnection, as_df::Bool = true) =
    as_df ? DataFrame(get_tables_meta(conn.c, conn.session)) : get_tables_meta(conn.c, conn.session)

"""
    get_table_details(conn::OmniSciConnection, table_name::String, as_df::Bool = true)

Get table details such as column names and types.

# Examples
```julia-repl
julia> tbl_detail = get_table_details(conn, "mapd_states")
TTableDetails(TColumnType[TColumnType("id", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, "", false, false), TColumnType("abbr", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, "", false, false), TColumnType("name", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, "", false, false), TColumnType("mapd_geo", TTypeInfo(16, 6, true, false, 23, 4326, 32, -1), false, "", false, false)], 32000000, 2097152, 4611686018427387904, "", 0, "[]", false, 0)
```
"""
get_table_details(conn::OmniSciConnection, table_name::String, as_df::Bool = true) =
    as_df ? DataFrame(get_table_details(conn.c, conn.session, table_name)) : get_table_details(conn.c, conn.session, table_name)

"""
    get_users(conn::OmniSciConnection, as_df::Bool = true)

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
get_users(conn::OmniSciConnection, as_df::Bool = true) =
    as_df ? DataFrame(Dict(:users => get_users(conn.c, conn.session))) : get_users(conn.c, conn.session)

"""
    get_databases(conn::OmniSciConnection, as_df::Bool=true)

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
get_databases(conn::OmniSciConnection, as_df::Bool=true) =
    as_df ? DataFrame(get_databases(conn.c, conn.session)) : get_databases(conn.c, conn.session)

"""
    get_memory(conn::OmniSciConnection, memory_level::String)

"""
function get_memory(conn::OmniSciConnection, memory_level::String)

    @assert memory_level in ["cpu", "gpu"] """memory level can be one of: \"cpu\", \"gpu\""""
    get_memory(conn.c, conn.session, memory_level)
end

"""
    clear_cpu_memory(conn::OmniSciConnection)

"""
clear_cpu_memory(conn::OmniSciConnection) =
    clear_cpu_memory(conn.c, conn.session)

"""
    clear_gpu_memory(conn::OmniSciConnection)

"""
clear_gpu_memory(conn::OmniSciConnection) =
    clear_gpu_memory(conn.c, conn.session)

######################################## query, render

"""
    sql_execute(conn::OmniSciConnection, query::String, first_n::Int = -1, at_most_n::Int = -1)

"""
function sql_execute(conn::OmniSciConnection, query::String, first_n::Int = -1, at_most_n::Int = -1)

    first_n > 0 && at_most_n > 0 ? error("Only one of first_n and at_most_n can be set at one time") : nothing

    #true hard-coded for column_format, as its not clear there is any benefit to providing row-wise parsing (slow)
    result = sql_execute(conn.c, conn.session, query, true, randstring(32), Int32(first_n), Int32(at_most_n))

    return DataFrame(result)

end

"""
    sql_execute_df(conn::OmniSciConnection, query::String, device_type::Int, device_id::Int, first_n::Int = -1)

"""
sql_execute_df(conn::OmniSciConnection, query::String, device_type::Int, device_id::Int, first_n::Int = -1) =
    sql_execute_df(conn.c, conn.session, query, Int32(device_type), Int32(device_id), Int32(first_n))

"""
    sql_execute_gdf(conn::OmniSciConnection, query::String, device_id::Int, first_n::Int = -1)

"""
sql_execute_gdf(conn::OmniSciConnection, query::String, device_id::Int, first_n::Int = -1) =
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
    render_vega(conn::OmniSciConnection, widget_id::Int, vega_json::String, compression_level::Int)

"""
render_vega(conn::OmniSciConnection, widget_id::Int, vega_json::String, compression_level::Int) =
    render_vega(conn.c, conn.session, Int64(widget_id), vega_json, Int32(compression_level), randstring(32))

######################################## dashboard

# """
#     get_dashboard(conn::OmniSciConnection, dashboard_id::Integer)
#
# """
# get_dashboard(conn::OmniSciConnection, dashboard_id::Integer)  =
#     get_dashboard(conn.c, conn.session, Int32(dashboard_id))

"""
    get_dashboards(conn::OmniSciConnection, as_df::Bool = true)

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
get_dashboards(conn::OmniSciConnection, as_df::Bool = true) =
    as_df ? DataFrame(get_dashboards(conn.c, conn.session)) : get_dashboards(conn.c, conn.session)

"""
    create_dashboard(conn::OmniSciConnection, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String)


"""
create_dashboard(conn::OmniSciConnection, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String) =
    create_dashboard(conn.c, conn.session, dashboard_name, dashboard_state, image_hash, dashboard_metadata)

"""
    replace_dashboard(conn::OmniSciConnection, dashboard_id::Integer, dashboard_name::String, dashboard_owner::String, dashboard_state::String, image_hash::String, dashboard_metadata::String)


"""
replace_dashboard(conn::OmniSciConnection, dashboard_id::Integer, dashboard_name::String, dashboard_owner::String, dashboard_state::String, image_hash::String, dashboard_metadata::String) =
    replace_dashboard(conn.c, conn.session, Int32(dashboard_id), dashboard_name, dashboard_owner, dashboard_state, image_hash, dashboard_metadata)

"""
    delete_dashboard(conn::OmniSciConnection, dashboard_id::Integer)

"""
delete_dashboard(conn::OmniSciConnection, dashboard_id::Integer) =
    delete_dashboard(conn.c, conn.session, Int32(dashboard_id))

"""
    share_dashboard(conn::OmniSciConnection, dashboard_id::Integer, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions)

"""
share_dashboard(conn::OmniSciConnection, dashboard_id::Integer, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions) =
    share_dashboard(conn.c, conn.session, Int32(dashboard_id), groups, objects, permissions)

"""
    unshare_dashboard(conn::OmniSciConnection, dashboard_id::Integer, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions)


"""
unshare_dashboard(conn::OmniSciConnection, dashboard_id::Integer, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions) =
    unshare_dashboard(conn.c, conn.session, Int32(dashboard_id), groups, objects, permissions)

"""
    get_dashboard_grantees(conn::OmniSciConnection, dashboard_id::Integer)

"""
get_dashboard_grantees(conn::OmniSciConnection, dashboard_id::Integer) =
    get_dashboard_grantees(conn.c, conn.session, Int32(dashboard_id))

######################################## import

"""
    load_table_binary(conn::OmniSciConnection, table_name::String, rows::Vector{TRow})

"""
load_table_binary(conn::OmniSciConnection, table_name::String, rows::Vector{TRow}) =
    load_table_binary(conn.c, conn.session, table_name, rows)

"""
    load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn})

"""
load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn}) =
    load_table_binary_columnar(conn.c, conn.session, table_name, cols)

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

# """
#     detect_column_types(conn::OmniSciConnection, file_name::String, copy_params::TCopyParams)
#
# """
# detect_column_types(conn::OmniSciConnection, file_name::String, copy_params::TCopyParams) =
#     detect_column_types(conn.c, conn.session, file_name, copy_params)

"""
    create_table(conn::OmniSciConnection, table_name::String, row_desc::TRowDescriptor, table_type::TTableType.Enum)

"""
create_table(conn::OmniSciConnection, table_name::String, row_desc::TRowDescriptor, table_type::TTableType.Enum) =
    create_table(conn.c, conn.session, table_name, row_desc, table_type.value)

# """
#     import_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams)
#
# """
# import_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams) =
#     import_table(conn.c, conn.session, table_name, file_name, copy_params)

"""
    import_geo_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams, row_desc::TRowDescriptor)

"""
import_geo_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams, row_desc::TRowDescriptor) =
    import_geo_table(conn.c, conn.session, table_name, file_name, copy_params, row_desc)

# """
#     import_table_status(conn::OmniSciConnection, import_id::String)
#
# """
# import_table_status(conn::OmniSciConnection, import_id::String) =
#     import_table_status(conn.c, conn.session, import_id)

######################################## object privileges

"""
    get_roles(conn::OmniSciConnection, as_df::Bool = true)

"""
get_roles(conn::OmniSciConnection, as_df::Bool = true) =
    as_df ? DataFrame(Dict(:roles => get_roles(conn.c, conn.session))) : get_roles(conn.c, conn.session)

"""
    get_db_objects_for_grantee(conn::OmniSciConnection, roleName::String)


"""
get_db_objects_for_grantee(conn::OmniSciConnection, roleName::String) =
    get_db_objects_for_grantee(conn.c, conn.session, roleName)

"""
    get_db_object_privs(conn::OmniSciConnection, objectName::String, type_::Integer)


"""
get_db_object_privs(conn::OmniSciConnection, objectName::String, type_::Integer) =
    get_db_object_privs(conn.c, conn.session, objectName, Int32(type_))

"""
    get_all_roles_for_user(conn::OmniSciConnection, userName::String, as_df::Bool = true)


"""
get_all_roles_for_user(conn::OmniSciConnection, userName::String, as_df::Bool = true) =
    as_df ? DataFrame(Dict("roles" => get_all_roles_for_user(conn.c, conn.session, userName))) : get_all_roles_for_user(conn.c, conn.session, userName)

######################################## licensing

"""
    set_license_key(conn::OmniSciConnection, key::String)


"""
set_license_key(conn::OmniSciConnection, key::String) =
    set_license_key(conn.c, conn.session, key, randstring(32))

"""
    get_license_claims(conn::OmniSciConnection)

"""
get_license_claims(conn::OmniSciConnection) =
    get_license_claims(conn.c, conn.session, randstring(32))
