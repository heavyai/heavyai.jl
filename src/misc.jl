mutable struct MapDConnection
    session::TSessionId
    c::MapDClient
end

#connect function to abstract away needing to build MapDClient
#user passes MapDConnection created from connect instead of individual pieces
function connect(host::String, port::Int, user::String, passwd::String, dbname::String)

    socket = TSocket(host, port)

    #create libuv socket and keep-alive
    tcp = Base.connect(host, port)
    err = ccall(:uv_tcp_keepalive, Cint, (Ptr{Nothing}, Cint, Cuint), tcp.handle, 1, 1)
    err != 0 && error("error setting keepalive on socket")

    Thrift.set_field!(socket, :io, tcp)
    #transport = TBufferedTransport(socket) # https://github.com/tanmaykm/Thrift.jl/issues/12
    proto = TBinaryProtocol(socket)
    c = MapD.MapDClient(proto)

    session = MapD.connect(c, user, passwd, dbname)

    return MapDConnection(session, c)

end

######################################## connection, admin
disconnect(conn::MapDConnection) =
    disconnect(conn.c, conn.session) #consider printing to console that disconnection happened

get_status(conn::MapDConnection) =
    get_status(conn.c, conn.session)

get_hardware_info(conn::MapDConnection) =
    get_hardware_info(conn.c, conn.session)

get_tables(conn::MapDConnection) =
    get_tables(conn.c, conn.session)

get_physical_tables(conn::MapDConnection) =
    get_physical_tables(conn.c, conn.session)

get_views(conn::MapDConnection) =
    get_views(conn.c, conn.session)

get_tables_meta(conn::MapDConnection) =
    get_tables_meta(conn.c, conn.session)

get_table_details(conn::MapDConnection, table_name::String) =
    get_table_details(conn.c, conn.session, table_name)

get_users(conn::MapDConnection) =
    get_users(conn.c, conn.session)

get_databases(conn::MapDConnection) =
    get_databases(conn.c, conn.session)

get_version(conn::MapDConnection) =
    get_version(conn.c)

start_heap_profile(conn::MapDConnection) =
    start_heap_profile(conn.c, conn.session)

stop_heap_profile(conn::MapDConnection) =
    stop_heap_profile(conn.c, conn.session)

get_heap_profile(conn::MapDConnection) =
    get_heap_profile(conn.c, conn.session)

get_memory(conn::MapDConnection, memory_level::String) =
    get_memory(conn.c, conn.session, memory_level)

clear_cpu_memory(conn::MapDConnection) =
    clear_cpu_memory(conn.c, conn.session)

clear_gpu_memory(conn::MapDConnection) =
    clear_gpu_memory(conn.c, conn.session)

######################################## query, render

sql_execute(conn::MapDConnection, query::String, column_format::Bool, nonce::String, first_n::Int32, at_most_n::Int32) =
    sql_execute(conn.c, conn.session, query, column_format, nonce, first_n, at_most_n)

sql_execute_df(conn::MapDConnection, query::String, device_type::Int32, device_id::Int32, first_n::Int32) =
    sql_execute_df(conn.c, conn.session, query, device_type, device_id, first_n)

sql_execute_gdf(conn::MapDConnection, query::String, device_id::Int32, first_n::Int32) =
    sql_execute_gdf(conn.c, conn.session, query, device_id, first_n)

deallocate_df(conn::MapDConnection, df::TDataFrame, device_type::Int32, device_id::Int32) =
    deallocate_df(conn.c, conn.session, df, device_type, device_id)

interrupt(conn::MapDConnection) =
    interrupt(conn.c, conn.session)

#need a try/catch with this? either returns data or exception
#seems almost like a true/false or internal function
sql_validate(conn::MapDConnection, query::String) =
    sql_validate(conn.c, conn.session, query)

get_completion_hints(conn::MapDConnection, sql::String, cursor::Int32) =
    get_completion_hints(conn.c, conn.session, sql, cursor)

set_execution_mode(conn::MapDConnection, mode::Int32) =
    set_execution_mode(conn.c, conn.session, mode)

render_vega(conn::MapDConnection, widget_id::Int64, vega_json::String, compression_level::Int32, nonce::String) =
    render_vega(conn.c, conn.session, widget_id, vega_json, compression_level, nonce)

get_result_row_for_pixel(conn::MapDConnection, widget_id::Int64, pixel::TPixel, table_col_names::Dict{String,Vector{String}}, column_format::Bool, pixelRadius::Int32, nonce::String) =
    get_result_row_for_pixel(conn.c, conn.session, widget_id, pixel, table_col_names, column_format, pixelRadius, nonce)

######################################## dashboard

get_dashboard(conn::MapDConnection, dashboard_id::Int32) =
    get_dashboard(conn.c, conn.session, dashboard_id)

get_dashboards(conn::MapDConnection) =
    get_dashboards(conn.c, conn.session)

create_dashboard(conn::MapDConnection, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String) =
    create_dashboard(conn.c, conn.session, dashboard_name, dashboard_state, image_hash, dashboard_metadata)

replace_dashboard(conn::MapDConnection, dashboard_id::Int32, dashboard_name::String, dashboard_owner::String, dashboard_state::String, image_hash::String, dashboard_metadata::String) =
    replace_dashboard(conn.c, conn.session, dashboard_id, dashboard_name, dashboard_owner, dashboard_state, image_hash, dashboard_metadata)

delete_dashboard(conn::MapDConnection, dashboard_id::Int32) =
    delete_dashboard(conn.c, conn.session, dashboard_id)

share_dashboard(conn::MapDConnection, dashboard_id::Int32, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions) =
    share_dashboard(conn.c, conn.session, dashboard_id, groups, objects, permissions)

unshare_dashboard(conn::MapDConnection, dashboard_id::Int32, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions) =
    unshare_dashboard(conn.c, conn.session, dashboard_id, groups, objects, permissions)

get_dashboard_grantees(conn::MapDConnection, dashboard_id::Int32) =
    get_dashboard_grantees(conn.c, conn.session, dashboard_id)

######################################## dashboard links

get_link_view(conn::MapDConnection, link::String) =
    get_link_view(conn.c, conn.session, link)

create_link(conn::MapDConnection, view_state::String, view_metadata::String) =
    create_link(conn.c, conn.session, view_state, view_metadata)

######################################## import

load_table_binary(conn::MapDConnection, table_name::String, rows::Vector{TRow}) =
    load_table_binary(conn.c, conn.session, table_name, rows)

load_table_binary_columnar(conn::MapDConnection, table_name::String, cols::Vector{TColumn}) =
    load_table_binary_columnar(conn.c, conn.session, table_name, cols)

load_table_binary_arrow(conn::MapDConnection, table_name::String, arrow_stream::Vector{UInt8}) =
    load_table_binary_arrow(conn.c, conn.session, table_name, arrow_stream)

load_table(conn::MapDConnection, table_name::String, rows::Vector{TStringRow}) =
    load_table(conn.c, conn.session, table_name, rows)

detect_column_types(conn::MapDConnection, file_name::String, copy_params::TCopyParams) =
    detect_column_types(conn.c, conn.session, file_name, copy_params)

create_table(conn::MapDConnection, table_name::String, row_desc::TRowDescriptor, table_type::Int32) =
    create_table(conn.c, conn.session, table_name, row_desc, table_type)

import_table(conn::MapDConnection, table_name::String, file_name::String, copy_params::TCopyParams) =
    import_table(conn.c, conn.session, table_name, file_name, copy_params)

import_geo_table(conn::MapDConnection, table_name::String, file_name::String, copy_params::TCopyParams, row_desc::TRowDescriptor) =
    import_geo_table(conn.c, conn.session, table_name, file_name, copy_params, row_desc)

import_table_status(conn::MapDConnection, import_id::String) =
    import_table_status(conn.c, conn.session, import_id)

######################################## object privileges

get_roles(conn::MapDConnection) =
    get_dashboards(conn.c, conn.session)

get_db_objects_for_grantee(conn::MapDConnection, roleName::String) =
    get_db_objects_for_grantee(conn.c, conn.session, roleName)

get_db_object_privs(conn::MapDConnection, objectName::String, _type::Int32) =
    get_db_object_privs(conn.c, conn.session, objectName, _type)

get_all_roles_for_user(conn::MapDConnection, userName::String) =
    get_all_roles_for_user(conn.c, conn.session, userName)

######################################## licensing

set_license_key(conn::MapDConnection, key::String, nonce::String) =
    set_license_key(conn.c, conn.session, key, nonce)

get_license_claims(conn::MapDConnection, nonce::String) =
    get_license_claims(conn.c, conn.session, nonce)
