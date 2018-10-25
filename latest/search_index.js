var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": "Introduction statement."
},

{
    "location": "index.html#Installation-1",
    "page": "Getting Started",
    "title": "Installation",
    "category": "section",
    "text": "OmniSci.jl is still in very heavy development mode; as such, it is currently not on METADATA. To install, use Pkg.clone() or similar."
},

{
    "location": "index.html#Authentication-1",
    "page": "Getting Started",
    "title": "Authentication",
    "category": "section",
    "text": "The first step in using OmniSci.jl is to authenticate against an OmniSci database. Currently, OmniSci.jl only implements the binary transfer protocol from Apache Thrift; https support to be developed at a later date.Using the default login credentials for a new OmniSci install:julia> using OmniSci\n\njulia> conn = connect(\"localhost\", 9091, \"mapd\", \"HyperInteractive\", \"mapd\")\nConnected to localhost:9091"
},

{
    "location": "index.html#Usage-1",
    "page": "Getting Started",
    "title": "Usage",
    "category": "section",
    "text": "Once authenticated, use the conn object as the first argument for each method in the package:julia> tbl = get_tables(conn)\n4-element Array{String,1}:\n \"mapd_states\"\n \"mapd_counties\"\n \"mapd_countries\"\n \"nyc_trees_2015_683k\""
},

{
    "location": "functions.html#",
    "page": "Functions",
    "title": "Functions",
    "category": "page",
    "text": "These functions constitute the main interface for working with OmniSci."
},

{
    "location": "functions.html#OmniSci.connect",
    "page": "Functions",
    "title": "OmniSci.connect",
    "category": "function",
    "text": "connect(host::String, port::Int, user::String, passwd::String, dbname::String)\n\nConnect to an OmniSci database.\n\nExamples\n\njulia> conn = connect(\"localhost\", 9091, \"mapd\", \"HyperInteractive\", \"mapd\")\nConnected to localhost:9091\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.disconnect",
    "page": "Functions",
    "title": "OmniSci.disconnect",
    "category": "function",
    "text": "disconnect(conn::OmniSciConnection)\n\nClose connection to OmniSci database.\n\nExamples\n\njulia> disconnect(conn)\nConnection to localhost:9091 closed\n\n\n\n\n\n"
},

{
    "location": "functions.html#Authentication-1",
    "page": "Functions",
    "title": "Authentication",
    "category": "section",
    "text": "connect\ndisconnect"
},

{
    "location": "functions.html#OmniSci.sql_execute_df",
    "page": "Functions",
    "title": "OmniSci.sql_execute_df",
    "category": "function",
    "text": "sql_execute_df(conn::OmniSciConnection, query::String, device_type::Int, device_id::Int, first_n::Int = -1)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.sql_execute_gdf",
    "page": "Functions",
    "title": "OmniSci.sql_execute_gdf",
    "category": "function",
    "text": "sql_execute_gdf(conn::OmniSciConnection, query::String, device_id::Int, first_n::Int = -1)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.sql_execute",
    "page": "Functions",
    "title": "OmniSci.sql_execute",
    "category": "function",
    "text": "sql_execute(conn::OmniSciConnection, query::String, first_n::Int = -1, at_most_n::Int = -1)\n\n\n\n\n\n"
},

{
    "location": "functions.html#Querying-Data-1",
    "page": "Functions",
    "title": "Querying Data",
    "category": "section",
    "text": "sql_execute_df\nsql_execute_gdf\nsql_execute"
},

{
    "location": "functions.html#OmniSci.create_table",
    "page": "Functions",
    "title": "OmniSci.create_table",
    "category": "function",
    "text": "create_table(conn::OmniSciConnection, table_name::String, row_desc::TRowDescriptor, table_type::TTableType.Enum)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.load_table",
    "page": "Functions",
    "title": "OmniSci.load_table",
    "category": "function",
    "text": "load_table(conn::OmniSciConnection, table_name::String, rows::Vector{TStringRow})\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.load_table_binary_arrow",
    "page": "Functions",
    "title": "OmniSci.load_table_binary_arrow",
    "category": "function",
    "text": "load_table_binary_arrow(conn::OmniSciConnection, table_name::String, arrow_stream::Vector{UInt8})\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.load_table_binary",
    "page": "Functions",
    "title": "OmniSci.load_table_binary",
    "category": "function",
    "text": "load_table_binary(conn::OmniSciConnection, table_name::String, rows::Vector{TRow})\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.load_table_binary_columnar",
    "page": "Functions",
    "title": "OmniSci.load_table_binary_columnar",
    "category": "function",
    "text": "load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn})\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.import_geo_table",
    "page": "Functions",
    "title": "OmniSci.import_geo_table",
    "category": "function",
    "text": "import_geo_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams, row_desc::TRowDescriptor)\n\n\n\n\n\n"
},

{
    "location": "functions.html#Loading-Data-1",
    "page": "Functions",
    "title": "Loading Data",
    "category": "section",
    "text": "create_table\nload_table\nload_table_binary_arrow\nload_table_binary\nload_table_binary_columnar\nimport_geo_table"
},

{
    "location": "functions.html#OmniSci.get_tables_meta",
    "page": "Functions",
    "title": "OmniSci.get_tables_meta",
    "category": "function",
    "text": "get_tables_meta(conn::OmniSciConnection, as_df::Bool = true)\n\nGet metadata for tables in database specified in connect().\n\nExamples\n\njulia> metad = get_tables_meta(conn)\n5×6 DataFrame. Omitted printing of 1 columns\n│ Row │ is_replicated │ is_view │ max_rows            │ num_cols │ shard_count │\n│     │ Bool          │ Bool    │ Int64               │ Int64    │ Int64       │\n├─────┼───────────────┼─────────┼─────────────────────┼──────────┼─────────────┤\n│ 1   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │\n│ 2   │ false         │ false   │ 4611686018427387904 │ 6        │ 0           │\n│ 3   │ false         │ false   │ 4611686018427387904 │ 64       │ 0           │\n│ 4   │ false         │ false   │ 4611686018427387904 │ 56       │ 0           │\n│ 5   │ false         │ false   │ 4611686018427387904 │ 42       │ 0           │\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_table_details",
    "page": "Functions",
    "title": "OmniSci.get_table_details",
    "category": "function",
    "text": "get_table_details(conn::OmniSciConnection, table_name::String, as_df::Bool = true)\n\nGet table details such as column names and types.\n\nExamples\n\njulia> tbl_detail = get_table_details(conn, \"mapd_states\")\nTTableDetails(TColumnType[TColumnType(\"id\", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, \"\", false, false), TColumnType(\"abbr\", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, \"\", false, false), TColumnType(\"name\", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, \"\", false, false), TColumnType(\"mapd_geo\", TTypeInfo(16, 6, true, false, 23, 4326, 32, -1), false, \"\", false, false)], 32000000, 2097152, 4611686018427387904, \"\", 0, \"[]\", false, 0)\n\n\n\n\n\n"
},

{
    "location": "functions.html#Table-Metadata-1",
    "page": "Functions",
    "title": "Table Metadata",
    "category": "section",
    "text": "get_tables_meta\nget_table_details"
},

{
    "location": "functions.html#OmniSci.create_dashboard",
    "page": "Functions",
    "title": "OmniSci.create_dashboard",
    "category": "function",
    "text": "create_dashboard(conn::OmniSciConnection, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.share_dashboard",
    "page": "Functions",
    "title": "OmniSci.share_dashboard",
    "category": "function",
    "text": "share_dashboard(conn::OmniSciConnection, dashboard_id::Integer, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.unshare_dashboard",
    "page": "Functions",
    "title": "OmniSci.unshare_dashboard",
    "category": "function",
    "text": "unshare_dashboard(conn::OmniSciConnection, dashboard_id::Integer, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_dashboards",
    "page": "Functions",
    "title": "OmniSci.get_dashboards",
    "category": "function",
    "text": "get_dashboards(conn::OmniSciConnection, as_df::Bool = true)\n\nGets dashboards that user submitted during connect() can access.\n\nExamples\n\njulia> getdbs = get_dashboards(conn)\n7×8 DataFrame. Omitted printing of 3 columns\n│ Row │ dashboard_id │ dashboard_metadata │ dashboard_name │ dashboard_owner │ dashboard_state │\n│     │ Int32        │ String             │ String         │ String          │ String          │\n├─────┼──────────────┼────────────────────┼────────────────┼─────────────────┼─────────────────┤\n│ 1   │ 9            │ metadata           │ 0vcAQEO1ZD     │ mapd            │                 │\n│ 2   │ 6            │ metadata           │ QI0JsthBsB     │ mapd            │                 │\n│ 3   │ 5            │ metadata           │ Srm72rCJHa     │ mapd            │                 │\n│ 4   │ 4            │ metadata           │ sO0XgMUOZH     │ mapd            │                 │\n│ 5   │ 1            │ metadata           │ testdash       │ mapd            │                 │\n│ 6   │ 2            │ metadata           │ testdash2      │ mapd            │                 │\n│ 7   │ 3            │ metadata           │ testdash3      │ mapd            │                 │\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_dashboard_grantees",
    "page": "Functions",
    "title": "OmniSci.get_dashboard_grantees",
    "category": "function",
    "text": "get_dashboard_grantees(conn::OmniSciConnection, dashboard_id::Integer)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.replace_dashboard",
    "page": "Functions",
    "title": "OmniSci.replace_dashboard",
    "category": "function",
    "text": "replace_dashboard(conn::OmniSciConnection, dashboard_id::Integer, dashboard_name::String, dashboard_owner::String, dashboard_state::String, image_hash::String, dashboard_metadata::String)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.delete_dashboard",
    "page": "Functions",
    "title": "OmniSci.delete_dashboard",
    "category": "function",
    "text": "delete_dashboard(conn::OmniSciConnection, dashboard_id::Integer)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.render_vega",
    "page": "Functions",
    "title": "OmniSci.render_vega",
    "category": "function",
    "text": "render_vega(conn::OmniSciConnection, widget_id::Int, vega_json::String, compression_level::Int)\n\n\n\n\n\n"
},

{
    "location": "functions.html#Dashboards-1",
    "page": "Functions",
    "title": "Dashboards",
    "category": "section",
    "text": "create_dashboard\nshare_dashboard\nunshare_dashboard\nget_dashboards\nget_dashboard_grantees\nreplace_dashboard\ndelete_dashboard\nrender_vega"
},

{
    "location": "functions.html#OmniSci.get_databases",
    "page": "Functions",
    "title": "OmniSci.get_databases",
    "category": "function",
    "text": "get_databases(conn::OmniSciConnection, as_df::Bool=true)\n\nGet list of databases.\n\nExamples\n\njulia> db = get_databases(conn)\n1×2 DataFrame\n│ Row │ db_name │ db_owner │\n│     │ String  │ String   │\n├─────┼─────────┼──────────┤\n│ 1   │ mapd    │ mapd     │\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_users",
    "page": "Functions",
    "title": "OmniSci.get_users",
    "category": "function",
    "text": "get_users(conn::OmniSciConnection, as_df::Bool = true)\n\nGet list of users who have access to database specified in connect().\n\nExamples\n\njulia> users = get_users(conn)\n1×1 DataFrame\n│ Row │ users  │\n│     │ String │\n├─────┼────────┤\n│ 1   │ mapd   │\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_roles",
    "page": "Functions",
    "title": "OmniSci.get_roles",
    "category": "function",
    "text": "get_roles(conn::OmniSciConnection, as_df::Bool = true)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_hardware_info",
    "page": "Functions",
    "title": "OmniSci.get_hardware_info",
    "category": "function",
    "text": "get_hardware_info(conn::OmniSciConnection)\n\nDisplays selected properties of hardware where OmniSci running, such as GPU and CPU information.\n\nExamples\n\njulia> hardware = get_hardware_info(conn)\nTClusterHardwareInfo(THardwareInfo[THardwareInfo(0, 12, 0, 0, \"\", TGpuSpecification[])])\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_status",
    "page": "Functions",
    "title": "OmniSci.get_status",
    "category": "function",
    "text": "get_status(conn::OmniSciConnection)\n\nDisplays properties of OmniSci server, such as version and rendering capabilities.\n\nExamples\n\njulia> status = get_status(conn)\n1-element Array{TServerStatus,1}:\n TServerStatus(false, \"4.2.0dev-20181003-0206b9f92c\", false, 1539095178, \"ee\", \"aggregator\", false)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_all_roles_for_user",
    "page": "Functions",
    "title": "OmniSci.get_all_roles_for_user",
    "category": "function",
    "text": "get_all_roles_for_user(conn::OmniSciConnection, userName::String, as_df::Bool = true)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_db_objects_for_grantee",
    "page": "Functions",
    "title": "OmniSci.get_db_objects_for_grantee",
    "category": "function",
    "text": "get_db_objects_for_grantee(conn::OmniSciConnection, roleName::String)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_db_object_privs",
    "page": "Functions",
    "title": "OmniSci.get_db_object_privs",
    "category": "function",
    "text": "get_db_object_privs(conn::OmniSciConnection, objectName::String, type_::Integer)\n\n\n\n\n\n"
},

{
    "location": "functions.html#Metadata-1",
    "page": "Functions",
    "title": "Metadata",
    "category": "section",
    "text": "get_databases\nget_users\nget_roles\nget_hardware_info\nget_status\nget_all_roles_for_user\nget_db_objects_for_grantee\nget_db_object_privs"
},

{
    "location": "apireference.html#",
    "page": "API Reference",
    "title": "API Reference",
    "category": "page",
    "text": ""
},

{
    "location": "apireference.html#Index-1",
    "page": "API Reference",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
