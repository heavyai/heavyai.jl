using OmniSci
using Test
using Dates
using Random

#defaults for OmniSci
host="localhost"
user="mapd"
passwd="HyperInteractive"
port=9091
dbname="mapd"

######################################## connection, admin
#connect to database
conn = connect(host, port , user, passwd, dbname)
@test typeof(conn) == OmniSci.OmniSciConnection

#TODO: create a nametuple here?
sstatus = get_status(conn)
@test typeof(sstatus) == Vector{OmniSci.TServerStatus}
@test sstatus[1].start_time <= Dates.datetime2unix(now(UTC)) #test sstatus has values...assumes server started before test happened

#TODO: create list of a nametuple here?
hware = get_hardware_info(conn)
@test typeof(hware) == OmniSci.TClusterHardwareInfo

#TODO: create kw for dataframe?
tables = get_tables(conn)
@test typeof(tables) == Vector{String}

#TODO: create kw for dataframe?
ptables = get_physical_tables(conn)
@test typeof(ptables) == Vector{String}

#TODO: create kw for dataframe?
views = get_views(conn)
@test typeof(views) == Vector{String}

#TODO: create kw for dataframe? namedtuple?
met = get_tables_meta(conn)
@test typeof(met) == Vector{OmniSci.TTableMeta}

#TODO: Single table: dataframe or namedtuple?
table_deet = get_table_details(conn, "omnisci_counties")
@test typeof(table_deet) == OmniSci.TTableDetails

#TODO: create kw for dataframe?
users = get_users(conn)
@test typeof(users) == Vector{String}

#TODO: create kw for dataframe?
databases = get_databases(conn)
@test typeof(databases) == Vector{OmniSci.TDBInfo}

#TODO: what are the acceptable values of the second argument?
mem = get_memory(conn, "cpu")
@test typeof(mem) == Vector{OmniSci.TNodeMemoryInfo}

clear_cpu = clear_cpu_memory(conn)
@test typeof(clear_cpu) == Nothing

######################################## query, render

#TODO: How to return this data? namedtuple? what would the user expect?
se = sql_execute(conn, "select * from omnisci_counties")
@test typeof(se) == DataFrame

#TODO: write convenience method when result unlikely to return a result
#This needed for later to test role access
sql_execute(conn, "create role testuser")

cpu_arrow = sql_execute_df(conn,  "select id from omnisci_counties limit 100", 0, 0)
@test typeof(cpu_arrow) == OmniSci.TDataFrame

#TODO: Should this be public?
execmode = set_execution_mode(conn, TExecuteMode.CPU)
@test typeof(execmode) == Nothing

#deallocate_df(conn::OmniSciConnection, df::TDataFrame, device_type::Int, device_id::Int)

#interrupt(conn::OmniSciConnection)

#does this fit within this package?
#render_vega(conn::OmniSciConnection, widget_id::Int, vega_json::String, compression_level::Int)

######################################## dashboard

getdbs = get_dashboards(conn)
@test typeof(getdbs) == Vector{OmniSci.TDashboard}

#cdash represents id of dashboard created, use for later tests
cdash = create_dashboard(conn, randstring(10), "state", "image", "metadata")
@test cdash > 0

getdash = get_dashboard(conn, cdash)
@test typeof(getdash) == OmniSci.TDashboard

getdashgrant = get_dashboard_grantees(conn, cdash)
@test typeof(getdashgrant) == Vector{OmniSci.TDashboardGrantees}

#sharedash = share_dashboard(conn, cdash, [""], [""], OmniSci.TDashboardPermissions(false))

#unshare_dashboard(conn::OmniSciConnection, dashboard_id::Int, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions)

replacedash = replace_dashboard(conn, cdash, "", "mapd", "newstate", "newhash", "newmetadata")
@test typeof(replacedash) == Nothing

ddash = delete_dashboard(conn, cdash)
@test typeof(ddash) == Nothing

######################################## import

#load_table_binary(conn::OmniSciConnection, table_name::String, rows::Vector{TRow})

#load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn})

#load_table_binary_arrow(conn::OmniSciConnection, table_name::String, arrow_stream::Vector{UInt8})

#load_table(conn::OmniSciConnection, table_name::String, rows::Vector{TStringRow})

#detect_column_types(conn::OmniSciConnection, file_name::String, copy_params::TCopyParams)

#create_table(conn::OmniSciConnection, table_name::String, row_desc::TRowDescriptor, table_type::TTableType.Enum)

#import_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams)

#import_geo_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams, row_desc::TRowDescriptor)

#import_table_status(conn::OmniSciConnection, import_id::String)

######################################## object privileges

gr = get_roles(conn)
@test typeof(gr) == Vector{OmniSci.TDashboard}

roleuser = get_all_roles_for_user(conn, "mapd")
@test typeof(roleuser) == Vector{String}

gobj = get_db_objects_for_grantee(conn, "testuser")
@test typeof(gobj) == Vector{OmniSci.TDBObject}

#get_db_object_privs(conn::OmniSciConnection, objectName::String, type_::Int)

######################################## licensing

glc = get_license_claims(conn)
@test typeof(glc) == OmniSci.TLicenseInfo

#disconnect from database
disc = disconnect(conn)
@test typeof(disc) == Nothing

# slc = set_license_key(conn, "hello, world!") #not real license key :)
# @test typeof(slc) == OmniSci.TLicenseInfo
