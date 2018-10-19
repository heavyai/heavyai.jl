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
    "location": "functions.html#OmniSci.import_table",
    "page": "Functions",
    "title": "OmniSci.import_table",
    "category": "function",
    "text": "import_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams)\n\n\n\n\n\n"
},

{
    "location": "functions.html#Loading-Data-1",
    "page": "Functions",
    "title": "Loading Data",
    "category": "section",
    "text": "create_table\nload_table\nload_table_binary_arrow\nload_table_binary\nload_table_binary_columnar\nimport_geo_table\nimport_table"
},

{
    "location": "functions.html#OmniSci.get_tables",
    "page": "Functions",
    "title": "OmniSci.get_tables",
    "category": "function",
    "text": "get_tables(conn::OmniSciConnection)\n\nGet tables and views for authenticated database specified in connect().\n\nExamples\n\njulia> tbl = get_tables(conn)\n4-element Array{String,1}:\n \"mapd_states\"\n \"mapd_counties\"\n \"mapd_countries\"\n \"nyc_trees_2015_683k\"\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_physical_tables",
    "page": "Functions",
    "title": "OmniSci.get_physical_tables",
    "category": "function",
    "text": "get_physical_tables(conn::OmniSciConnection)\n\nGet tables for authenticated database specified in connect().\n\nExamples\n\njulia> ptbl = get_physical_tables(conn)\n4-element Array{String,1}:\n \"mapd_states\"\n \"mapd_counties\"\n \"mapd_countries\"\n \"nyc_trees_2015_683k\"\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_tables_meta",
    "page": "Functions",
    "title": "OmniSci.get_tables_meta",
    "category": "function",
    "text": "get_tables_meta(conn::OmniSciConnection)\n\nGet metadata for tables in database specified in connect().\n\nExamples\n\njulia> metad = get_tables_meta(conn)\n4-element Array{TTableMeta,1}:\n TTableMeta(\"mapd_states\", 4, Int32[6, 16], false, false, 0, 4611686018427387904)\n TTableMeta(\"mapd_counties\", 6, Int32[6, 16], false, false, 0, 4611686018427387904)\n TTableMeta(\"mapd_countries\", 64, Int32[1, 5, 6, 16], false, false, 0, 4611686018427387904)\n TTableMeta(\"nyc_trees_2015_683k\", 42, Int32[0, 3, 6, 9], false, false, 0, 4611686018427387904)\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_views",
    "page": "Functions",
    "title": "OmniSci.get_views",
    "category": "function",
    "text": "get_views(conn::OmniSciConnection)\n\nGet views for authenticated database specified in connect().\n\nExamples\n\njulia> vw = get_views(conn)\n0-element Array{String,1}\n\n\n\n\n\n"
},

{
    "location": "functions.html#OmniSci.get_table_details",
    "page": "Functions",
    "title": "OmniSci.get_table_details",
    "category": "function",
    "text": "get_table_details(conn::OmniSciConnection, table_name::String)\n\nGet table details such as column names and types.\n\nExamples\n\njulia> tbl_detail = get_table_details(conn, \"mapd_states\")\nTTableDetails(TColumnType[TColumnType(\"id\", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, \"\", false, false), TColumnType(\"abbr\", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, \"\", false, false), TColumnType(\"name\", TTypeInfo(6, 4, true, false, 0, 0, 32, -1), false, \"\", false, false), TColumnType(\"mapd_geo\", TTypeInfo(16, 6, true, false, 23, 4326, 32, -1), false, \"\", false, false)], 32000000, 2097152, 4611686018427387904, \"\", 0, \"[]\", false, 0)\n\n\n\n\n\n"
},

{
    "location": "functions.html#Table-Metadata-1",
    "page": "Functions",
    "title": "Table Metadata",
    "category": "section",
    "text": "get_tables\nget_physical_tables\nget_tables_meta\nget_views\nget_table_details"
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
    "location": "functions.html#OmniSci.get_dashboard",
    "page": "Functions",
    "title": "OmniSci.get_dashboard",
    "category": "function",
    "text": "get_dashboard(conn::OmniSciConnection, dashboard_id::Integer)\n\n\n\n\n\n"
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
    "text": "get_dashboards(conn::OmniSciConnection)\n\n\n\n\n\n"
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
    "location": "functions.html#Dashboards-1",
    "page": "Functions",
    "title": "Dashboards",
    "category": "section",
    "text": "create_dashboard\nshare_dashboard\nget_dashboard\nunshare_dashboard\nget_dashboards\nget_dashboard_grantees\nreplace_dashboard\ndelete_dashboard"
},

{
    "location": "functions.html#Metadata-1",
    "page": "Functions",
    "title": "Metadata",
    "category": "section",
    "text": "get_databases\nget_users\nget_roles\nget_hardware_info\nget_status\nget_all_roles_for_user\nget_db_objects_for_grantee\nget_version\nget_db_object_privs"
},

{
    "location": "internal.html#",
    "page": "Internal",
    "title": "Internal",
    "category": "page",
    "text": ""
},

{
    "location": "internal.html#Internal-Functions-1",
    "page": "Internal",
    "title": "Internal Functions",
    "category": "section",
    "text": "For completeness of wrapping the OmniSci Thrift interface, the following functions have been implemented. These functions represent either internal OmniSci functionality and/or functions that have other convenience methods defined around them.It is not expected that a user would need to use these functions under normal circumstances."
},

{
    "location": "internal.html#OmniSci.get_license_claims",
    "page": "Internal",
    "title": "OmniSci.get_license_claims",
    "category": "function",
    "text": "get_license_claims(conn::OmniSciConnection)\n\n\n\n\n\n"
},

{
    "location": "internal.html#OmniSci.set_license_key",
    "page": "Internal",
    "title": "OmniSci.set_license_key",
    "category": "function",
    "text": "set_license_key(conn::OmniSciConnection, key::String)\n\n\n\n\n\n"
},

{
    "location": "internal.html#Licensing-1",
    "page": "Internal",
    "title": "Licensing",
    "category": "section",
    "text": "get_license_claims\nset_license_key"
},

{
    "location": "internal.html#Memory-Management-1",
    "page": "Internal",
    "title": "Memory Management",
    "category": "section",
    "text": "deallocate_df\nclear_gpu_memory\nclear_cpu_memory\nset_execution_mode\nget_memory"
},

{
    "location": "internal.html#Misc-1",
    "page": "Internal",
    "title": "Misc",
    "category": "section",
    "text": "sql_validate\nimport_table_status\ninterrupt\ndetect_column_types\nrender_vega"
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
