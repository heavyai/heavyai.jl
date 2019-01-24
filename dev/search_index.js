var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": "Introduction statement."
},

{
    "location": "#Installation-1",
    "page": "Getting Started",
    "title": "Installation",
    "category": "section",
    "text": "OmniSci.jl is still in very heavy development mode; to get the most up-to-date version, use Pkg.clone() or similar to build from master. Otherwise, this package will follow semver standards and quick iteration cycles (and tags to METADATA) while the package is being developed.Currently, IPC functionality using Apache Arrow isn\'t implemented. This is the biggest opportunity for improvement, and I welcome any and all help from the community!"
},

{
    "location": "#Authentication-1",
    "page": "Getting Started",
    "title": "Authentication",
    "category": "section",
    "text": "The first step in using OmniSci.jl is to authenticate against an OmniSci database. Currently, OmniSci.jl only implements the binary transfer protocol from Apache Thrift (i.e. port must equal 9091); https support to be developed at a later date.Using the default login credentials for a new OmniSci install:julia> using OmniSci\n\njulia> conn = connect(\"localhost\", 9091, \"mapd\", \"HyperInteractive\", \"mapd\")\nConnected to localhost:9091"
},

{
    "location": "#Usage-1",
    "page": "Getting Started",
    "title": "Usage",
    "category": "section",
    "text": "Once authenticated, use the conn object as the first argument for each method in the package:julia> tbl = get_tables_meta(conn)\n5×6 DataFrame\n│ Row │ is_replicated │ is_view │ max_rows            │ num_cols │ shard_count │ table_name        │\n│     │ Bool          │ Bool    │ Int64               │ Int64    │ Int64       │ String            │\n├─────┼───────────────┼─────────┼─────────────────────┼──────────┼─────────────┼───────────────────┤\n│ 1   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ omnisci_states    │\n│ 2   │ false         │ false   │ 4611686018427387904 │ 6        │ 0           │ omnisci_counties  │\n│ 3   │ false         │ false   │ 4611686018427387904 │ 64       │ 0           │ omnisci_countries │\n│ 4   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test2             │\n│ 5   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test              │"
},

{
    "location": "functions/#",
    "page": "Functions",
    "title": "Functions",
    "category": "page",
    "text": "These functions constitute the main interface for working with OmniSci. If a function is not exported for the package, the assumption is that an end-user shouldn\'t need to use it. If you find otherwise, please open an issue for discussion."
},

{
    "location": "functions/#OmniSci.connect",
    "page": "Functions",
    "title": "OmniSci.connect",
    "category": "function",
    "text": "connect(host::String, port::Int, user::String, passwd::String, dbname::String)\n\nConnect to an OmniSci database.\n\nExamples\n\njulia> conn = connect(\"localhost\", 9091, \"mapd\", \"HyperInteractive\", \"mapd\")\nConnected to localhost:9091\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.disconnect",
    "page": "Functions",
    "title": "OmniSci.disconnect",
    "category": "function",
    "text": "disconnect(conn::OmniSciConnection)\n\nClose connection to OmniSci database.\n\nExamples\n\njulia> disconnect(conn)\nConnection to localhost:9091 closed\n\n\n\n\n\n"
},

{
    "location": "functions/#Authentication-1",
    "page": "Functions",
    "title": "Authentication",
    "category": "section",
    "text": "connect\ndisconnect"
},

{
    "location": "functions/#OmniSci.sql_execute",
    "page": "Functions",
    "title": "OmniSci.sql_execute",
    "category": "function",
    "text": "sql_execute(conn::OmniSciConnection, query::String; first_n::Int = -1, at_most_n::Int = -1, as_df::Bool = true)\n\nExecute a SQL query.\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.sql_execute_df",
    "page": "Functions",
    "title": "OmniSci.sql_execute_df",
    "category": "function",
    "text": "sql_execute_df(conn::OmniSciConnection, query::String, device_type::Int, device_id::Int, first_n::Int = -1)\n\nExecute a SQL query using Apache Arrow IPC (CPU). This method requires running the code in the same environment where OmniSci is running.\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.sql_execute_gdf",
    "page": "Functions",
    "title": "OmniSci.sql_execute_gdf",
    "category": "function",
    "text": "sql_execute_gdf(conn::OmniSciConnection, query::String, device_id::Int; first_n::Int = -1)\n\nExecute a SQL query using Apache Arrow IPC (GPU). This method requires running the code in the same environment where OmniSci is running.\n\n\n\n\n\n"
},

{
    "location": "functions/#Querying-Data-1",
    "page": "Functions",
    "title": "Querying Data",
    "category": "section",
    "text": "sql_execute\nsql_execute_df\nsql_execute_gdf"
},

{
    "location": "functions/#Loading-Data-1",
    "page": "Functions",
    "title": "Loading Data",
    "category": "section",
    "text": "create_table\nload_table\nload_table_binary_columnar\nload_table_binary_arrow"
},

{
    "location": "functions/#OmniSci.get_dashboards",
    "page": "Functions",
    "title": "OmniSci.get_dashboards",
    "category": "function",
    "text": "get_dashboards(conn::OmniSciConnection; as_df::Bool = true)\n\nGets dashboards that user submitted during connect() can access.\n\nExamples\n\njulia> getdbs = get_dashboards(conn)\n7×8 DataFrame. Omitted printing of 3 columns\n│ Row │ dashboard_id │ dashboard_metadata │ dashboard_name │ dashboard_owner │ dashboard_state │\n│     │ Int32        │ String             │ String         │ String          │ String          │\n├─────┼──────────────┼────────────────────┼────────────────┼─────────────────┼─────────────────┤\n│ 1   │ 9            │ metadata           │ 0vcAQEO1ZD     │ mapd            │                 │\n│ 2   │ 6            │ metadata           │ QI0JsthBsB     │ mapd            │                 │\n│ 3   │ 5            │ metadata           │ Srm72rCJHa     │ mapd            │                 │\n│ 4   │ 4            │ metadata           │ sO0XgMUOZH     │ mapd            │                 │\n│ 5   │ 1            │ metadata           │ testdash       │ mapd            │                 │\n│ 6   │ 2            │ metadata           │ testdash2      │ mapd            │                 │\n│ 7   │ 3            │ metadata           │ testdash3      │ mapd            │                 │\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_dashboard_grantees",
    "page": "Functions",
    "title": "OmniSci.get_dashboard_grantees",
    "category": "function",
    "text": "get_dashboard_grantees(conn::OmniSciConnection, dashboard_id::Integer)\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.render_vega",
    "page": "Functions",
    "title": "OmniSci.render_vega",
    "category": "function",
    "text": "render_vega(conn::OmniSciConnection, vega_json::String, compression_level::Int = 0)\n\nRender an OmniSci-flavored Vega specification using the backend rendering engine. Note that OmniSci does not currently support the full Vega specification; this method is mostly useful for rendering choropleths and related geospatial charts.\n\ncompression_level ranges from 0 (low compression, faster) to 9 (high compression, slower).\n\nExamples\n\njulia> vg = {\"width\" : 1024, \"height\" : 1024...}\n\njulia> vega_json = render_vega(conn, vg)\n\n\n\n\n\n"
},

{
    "location": "functions/#Dashboards-1",
    "page": "Functions",
    "title": "Dashboards",
    "category": "section",
    "text": "get_dashboards\nget_dashboard_grantees\nrender_vega"
},

{
    "location": "functions/#OmniSci.get_tables_meta",
    "page": "Functions",
    "title": "OmniSci.get_tables_meta",
    "category": "function",
    "text": "get_tables_meta(conn::OmniSciConnection; as_df::Bool = true)\n\nGet metadata for tables in database specified in connect().\n\nExamples\n\njulia> metad = get_tables_meta(conn)\n5×6 DataFrame\n│ Row │ is_replicated │ is_view │ max_rows            │ num_cols │ shard_count │ table_name        │\n│     │ Bool          │ Bool    │ Int64               │ Int64    │ Int64       │ String            │\n├─────┼───────────────┼─────────┼─────────────────────┼──────────┼─────────────┼───────────────────┤\n│ 1   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ omnisci_states    │\n│ 2   │ false         │ false   │ 4611686018427387904 │ 6        │ 0           │ omnisci_counties  │\n│ 3   │ false         │ false   │ 4611686018427387904 │ 64       │ 0           │ omnisci_countries │\n│ 4   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test2             │\n│ 5   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test              │\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_table_details",
    "page": "Functions",
    "title": "OmniSci.get_table_details",
    "category": "function",
    "text": "get_table_details(conn::OmniSciConnection, table_name::String; as_df::Bool = true)\n\nGet table details such as column names and types.\n\nExamples\n\njulia> tbl_detail = get_table_details(conn, \"omnisci_states\")\n4×21 DataFrame. Omitted printing of 15 columns\n│ Row │ col_name    │ col_type     │ comp_param │ encoding │ is_array │ is_physical │\n│     │ String      │ DataType     │ Int32      │ String   │ Bool     │ Bool        │\n├─────┼─────────────┼──────────────┼────────────┼──────────┼──────────┼─────────────┤\n│ 1   │ id          │ String       │ 32         │ Dict     │ false    │ false       │\n│ 2   │ abbr        │ String       │ 32         │ Dict     │ false    │ false       │\n│ 3   │ name        │ String       │ 32         │ Dict     │ false    │ false       │\n│ 4   │ omnisci_geo │ MultiPolygon │ 32         │ GeoInt   │ false    │ false       │\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_databases",
    "page": "Functions",
    "title": "OmniSci.get_databases",
    "category": "function",
    "text": "get_databases(conn::OmniSciConnection; as_df::Bool=true)\n\nGet list of databases.\n\nExamples\n\njulia> db = get_databases(conn)\n1×2 DataFrame\n│ Row │ db_name │ db_owner │\n│     │ String  │ String   │\n├─────┼─────────┼──────────┤\n│ 1   │ mapd    │ mapd     │\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_users",
    "page": "Functions",
    "title": "OmniSci.get_users",
    "category": "function",
    "text": "get_users(conn::OmniSciConnection; as_df::Bool = true)\n\nGet list of users who have access to database specified in connect().\n\nExamples\n\njulia> users = get_users(conn)\n1×1 DataFrame\n│ Row │ users  │\n│     │ String │\n├─────┼────────┤\n│ 1   │ mapd   │\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_roles",
    "page": "Functions",
    "title": "OmniSci.get_roles",
    "category": "function",
    "text": "get_roles(conn::OmniSciConnection; as_df::Bool = true)\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_hardware_info",
    "page": "Functions",
    "title": "OmniSci.get_hardware_info",
    "category": "function",
    "text": "get_hardware_info(conn::OmniSciConnection)\n\nDisplays selected properties of hardware where OmniSci running, such as GPU and CPU information.\n\nExamples\n\njulia> hardware = get_hardware_info(conn)\nOmniSci.TClusterHardwareInfo(OmniSci.THardwareInfo[THardwareInfo(0, 12, 0, 0, \"\", OmniSci.TGpuSpecification[])])\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_status",
    "page": "Functions",
    "title": "OmniSci.get_status",
    "category": "function",
    "text": "get_status(conn::OmniSciConnection)\n\nDisplays properties of OmniSci server, such as version and rendering capabilities.\n\nExamples\n\njulia> status = get_status(conn)\nOmniSci.TServerStatus\n\n  read_only: false\n  version: 4.1.3-20180926-66c2aee949\n  rendering_enabled: false\n  start_time: 1540579280\n  edition: ce\n  host_name: aggregator\n  poly_rendering_enabled: false\n\n\n\n\n\n"
},

{
    "location": "functions/#OmniSci.get_all_roles_for_user",
    "page": "Functions",
    "title": "OmniSci.get_all_roles_for_user",
    "category": "function",
    "text": "get_all_roles_for_user(conn::OmniSciConnection, userName::String; as_df::Bool = true)\n\n\n\n\n\n"
},

{
    "location": "functions/#Metadata-1",
    "page": "Functions",
    "title": "Metadata",
    "category": "section",
    "text": "get_tables_meta\nget_table_details\nget_databases\nget_users\nget_roles\nget_hardware_info\nget_status\nget_all_roles_for_user"
},

{
    "location": "apireference/#",
    "page": "API Reference",
    "title": "API Reference",
    "category": "page",
    "text": ""
},

{
    "location": "apireference/#Index-1",
    "page": "API Reference",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
