using OmniSci
using Test
using Dates

#defaults for OmniSci
host="localhost"
user="mapd"
passwd="HyperInteractive"
port=9091
dbname="mapd"

######################################## connection, admin
#connect to database
conn = OmniSci.connect(host, port , user, passwd, dbname)
@test typeof(conn) == OmniSci.OmniSciConnection

sstatus = get_status(conn)
@test typeof(sstatus) == Vector{OmniSci.TServerStatus}
@test sstatus[1].start_time <= Dates.datetime2unix(now(UTC)) #test sstatus has values...assumes server started before test happened

hware = get_hardware_info(conn)
@test typeof(hware) == OmniSci.TClusterHardwareInfo

tables = get_tables(conn)
@test typeof(tables) == Vector{String}

ptables = get_physical_tables(conn)
@test typeof(ptables) == Vector{String}

views = get_views(conn)
@test typeof(views) == Vector{String}

met = get_tables_meta(conn)
@test typeof(met) == Vector{OmniSci.TTableMeta}

#Need to change eventually, depending on what is in test instance
table_deet = get_table_details(conn, "omnisci_counties")
@test typeof(table_deet) == OmniSci.TTableDetails

users = get_users(conn)
@test typeof(users) == Vector{String}

databases = get_databases(conn)
@test typeof(databases) == Vector{OmniSci.TDBInfo}

version = get_version(conn)
@test typeof(version) == String

mem = get_memory(conn, "cpu")
@test typeof(mem) == Vector{OmniSci.TNodeMemoryInfo}

clear_cpu = clear_cpu_memory(conn)
@test typeof(clear_cpu) == Nothing

clear_gpu = clear_gpu_memory(conn)
@test typeof(clear_gpu) == Nothing

######################################## query, render

se_row = sql_execute(conn, "select count(*) as records from omnisci_counties", false) #row
#

se = sql_execute(conn, "select count(*) as records from omnisci_counties", true) #columnar

#sql_execute_df

#sql_execute_gdf

#deallocate_df

#interrupt

sqlval = sql_validate(conn, "select count(*) as records from omnisci_counties")
@test typeof(sqlval) == Dict{String,OmniSci.TColumnType}

#set_execution_mode(conn, GPU)

#render_vega

######################################## dashboard

#make this test conditional on taking a value from get_dashboards?
#would need to reverse order of tests so that getdbs exists first
#getdash = get_dashboard(conn, 1)
#@test typeof(getdash) == OmniSci.TDashboard

getdbs = get_dashboards(conn)
@test typeof(getdbs) == Vector{OmniSci.TDashboard}

#create_dashboard

#replace_dashboard

#delete_dashboard

#share_dashboard

#unshare_dashboard

#getdashgrant = get_dashboard_grantees(conn, 1)
#@test typeof(getdashgrant) == Vector{OmniSci.TDashboardGrantees}

######################################## import

#load_table_binary

#load_table_binary_columnar

#load_table_binary_arrow

#load_table

#detect_column_types

#create_table

#import_table

#import_geo_table

#import_table_status

######################################## object privileges

gr = get_roles(conn)
@test typeof(gr) == Vector{OmniSci.TDashboard}

#get_db_objects_for_grantee(conn, "mapd")

#get_db_object_privs

#roleuser = get_all_roles_for_user(conn, "mapd")
#@test typeof(roleuser) == Vector{String}

######################################## licensing

slc = set_license_key(conn, "hello, world!") #not real license key :)
@test typeof(slc) == OmniSci.TLicenseInfo

glc = get_license_claims(conn)
@test typeof(glc) == OmniSci.TLicenseInfo

#disconnect from database
disc = disconnect(conn)
@test typeof(disc) == Nothing
