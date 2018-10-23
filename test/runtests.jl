using OmniSci, Test, Dates, Random

#defaults for OmniSci
host="localhost"
user="mapd"
passwd="HyperInteractive"
port=9091
dbname="mapd"

######################################## completed tests

#set up connection just to disconnect
conn_d = connect(host, port , user, passwd, dbname)
disc = disconnect(conn_d)
@test typeof(disc) == Nothing

#connect to database, used for rest of tests
conn = connect(host, port , user, passwd, dbname)
@test typeof(conn) == OmniSci.OmniSciConnection

#get properties of server: version, rendering enabled, start time, etc.
sstatus = get_status(conn)
@test typeof(sstatus) == Vector{OmniSci.TServerStatus}
@test sstatus[1].start_time <= Dates.datetime2unix(now(UTC)) #test sstatus has values...assumes server started before test happened

#get users for the database specified in connect()
users = get_users(conn)
@test typeof(users) == DataFrame

#get databases user specified during connect() can see
databases = get_databases(conn)
@test typeof(databases) == DataFrame

#gets tables/views and their properties
met = get_tables_meta(conn)
@test typeof(met) == DataFrame

#execute query, return result via Thrift interface
se = sql_execute(conn, "select * from omnisci_counties")
@test typeof(se) == DataFrame
@test size(se) == (3250, 6)

#cdash represents id of dashboard created, use for later tests
cdash = create_dashboard(conn, randstring(10), "state", "image", "metadata")
@test cdash > 0

getdbs = get_dashboards(conn)
@test typeof(getdbs) == DataFrame

######################################## not exported (essentially, OmniSci internal)

clear_cpu = OmniSci.clear_cpu_memory(conn)
@test typeof(clear_cpu) == Nothing

execmode = OmniSci.set_execution_mode(conn, TExecuteMode.CPU)
@test typeof(execmode) == Nothing

glc = OmniSci.get_license_claims(conn)
@test typeof(glc) == OmniSci.TLicenseInfo

#TODO: what are the acceptable values of the second argument? seems like anything works
#Add valid values as assertions inside method
mem = OmniSci.get_memory(conn, "cpu")
@test typeof(mem) == Vector{OmniSci.TNodeMemoryInfo}

#not exported
#OmniSci.deallocate_df(conn::OmniSciConnection, df::TDataFrame, device_type::Int, device_id::Int)

#not exported
#OmniSci.interrupt(conn::OmniSciConnection)








######################################## Need work

#TODO: Single table: dataframe kw
#What to do with shard info and other singletons, given column descriptions should be rows
tbl_details = get_table_details(conn, "omnisci_counties")
@test typeof(table_deet) == OmniSci.TTableDetails

#render_vega(conn::OmniSciConnection, widget_id::Int, vega_json::String, compression_level::Int)

#TODO: create a show method and/or return as dataframe
hware = get_hardware_info(conn)
@test typeof(hware) == OmniSci.TClusterHardwareInfo

#TODO: Figure out IPC
cpu_arrow = sql_execute_df(conn,  "select id from omnisci_counties limit 100", 0, 0)
@test typeof(cpu_arrow) == OmniSci.TDataFrame

getdashgrant = get_dashboard_grantees(conn, cdash)
@test typeof(getdashgrant) == Vector{OmniSci.TDashboardGrantees}

replacedash = replace_dashboard(conn, cdash, "", "mapd", "newstate", "newhash", "newmetadata")
@test typeof(replacedash) == Nothing

ddash = delete_dashboard(conn, cdash)
@test typeof(ddash) == Nothing

#get roles assigned to user
sql_execute(conn, "create role testuser") #TODO: write convenience method when result unlikely to return a result instead of empty dataframe
roleuser = get_all_roles_for_user(conn, "mapd")
@test typeof(roleuser) == Vector{String}

gobj = get_db_objects_for_grantee(conn, "testuser")
@test typeof(gobj) == Vector{OmniSci.TDBObject}

#get_db_object_privs(conn::OmniSciConnection, objectName::String, type_::Int)

#load_table_binary(conn::OmniSciConnection, table_name::String, rows::Vector{TRow})

#load_table_binary_columnar(conn::OmniSciConnection, table_name::String, cols::Vector{TColumn})

#load_table_binary_arrow(conn::OmniSciConnection, table_name::String, arrow_stream::Vector{UInt8})

#load_table(conn::OmniSciConnection, table_name::String, rows::Vector{TStringRow})

#import_geo_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams, row_desc::TRowDescriptor)

#sharedash = share_dashboard(conn, cdash, [""], [""], OmniSci.TDashboardPermissions(false))

#unshare_dashboard(conn::OmniSciConnection, dashboard_id::Int, groups::Vector{String}, objects::Vector{String}, permissions::TDashboardPermissions)


######################################## Need validation of purpose of methods

#Is this method right? Why is it returning TDashboard?
gr = get_roles(conn)
@test typeof(gr) == Vector{OmniSci.TDashboard}

#Is this a front-end method or mapdql? Does this make sense from a client like this?
#import_table(conn::OmniSciConnection, table_name::String, file_name::String, copy_params::TCopyParams)

#Is this an internal/front-end/mapdql method?
#import_table_status(conn::OmniSciConnection, import_id::String)

#Is this internal/front-end/mapdql method?
#detect_column_types(conn::OmniSciConnection, file_name::String, copy_params::TCopyParams)

#Is this internal/front-end/mapdql method?
#create_table(conn::OmniSciConnection, table_name::String, row_desc::TRowDescriptor, table_type::TTableType.Enum)
