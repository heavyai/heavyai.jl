using OmniSci, Test, Dates, Random, DataFrames, DecFP, GeoInterface, LibGEOS

#defaults for OmniSci CPU Docker image
host="localhost"
user="mapd"
passwd="HyperInteractive"
port=9091
dbname="mapd"

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
cdash = OmniSci.create_dashboard(conn, randstring(10), "state", "image", "metadata")
@test cdash > 0

getdbs = get_dashboards(conn)
@test typeof(getdbs) == DataFrame

gr = get_roles(conn)
@test typeof(gr) == DataFrame

getdashgrant = get_dashboard_grantees(conn, cdash)
@test typeof(getdashgrant) == Vector{OmniSci.TDashboardGrantees}

tbl_details = get_table_details(conn, "omnisci_counties")
@test typeof(tbl_details) == DataFrame

#get roles assigned to user
sql_execute(conn, "create role testuser") #TODO: write convenience method when result unlikely to return a result instead of empty dataframe
sql_execute(conn, "create user mapd2 (password = 'OmniSciRocks!', is_super = 'true')")
sql_execute(conn, "grant testuser to mapd2")
roleuser = get_all_roles_for_user(conn, "mapd2")
@test typeof(roleuser) == DataFrame

#load data to table from dataframe
sql = """
create table test (
col1 tinyint,
col2 smallint,
col3 integer,
col4 bigint,
col5 float,
col6 double,
col7 decimal(7,2),
col8 text,
col9 text encoding dict(32),
col10 boolean,
col11 date,
col12 time,
col13 timestamp,
col14 point,
col15 linestring,
col16 point,
col17 linestring
)
"""

sql_execute(conn, sql)

#Define an example dataframe
tinyintcol = Int8[4,3,2,1]
smallintcol = Int16[4,3,2,1]
intcol = Int32[4,3,2,1]
bigintcol = Int64[4,3,2,1]
floatcol = Float32[3.0, 4.1, 2.69, 3.8]
doublecol = [3//2, 4//7, 9//72, 90/112] #testing julia rational, OmniSci double
decimalcol = [3.0, 4.1, 2.69, 3.8]
textcol = ["hello", "world", "omnisci", "gpu"]
boolcol = [true, false, true, true]
datecol = [Date(2013,7,1), Date(2013,7,1), Date(2013,7,1), Date(2013,7,1)]
timecol = [Time(4), Time(5), Time(6), Time(7)]
tscol = [DateTime(2013,7,1,12,30,59), DateTime(2013,7,1,12,30,59), DateTime(2013,7,1,12,30,59), DateTime(2013,7,1,12,30,59)]
pointcol = ["POINT (30 10)", "POINT (-30.18764587 12.2)", "POINT (30 -10.437878634)", "POINT (-78 -25)"]
linecol = ["LINESTRING (30 10, 10 30, 40 40)", "LINESTRING (30 10, 10 30, 40 40)", "LINESTRING (30 10, 10 30, 40 40)", "LINESTRING (30 10, 10 30, 40 40)"]
pointcol_native = GeoInterface.Point.(readgeom.(pointcol)),
linecol_native = GeoInterface.LineString.(readgeom.(linecol))

df = DataFrame([tinyintcol, smallintcol, intcol, bigintcol, floatcol, doublecol,
                decimalcol, textcol, textcol, boolcol, datecol, timecol, tscol,
                pointcol, linecol, pointcol_native, linecol_native])

#load data rowwise from dataframe
@test load_table(conn, "test", df) == nothing

#load data rowwise from Vector{TStringRow}
@test load_table(conn, "test", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(df)]) == nothing

#validate return types same as server
tbldb = sql_execute(conn, "select * from test")
@test eltypes(tbldb) == Type[Union{Missing, Int8},
                             Union{Missing, Int16},
                             Union{Missing, Int32},
                             Union{Missing, Int64},
                             Union{Missing, Float32},
                             Union{Missing, Float64},
                             Union{Missing, Dec64},
                             Union{Missing, String},
                             Union{Missing, String},
                             Union{Missing, Bool},
                             Union{Missing, Date},
                             Union{Missing, Time},
                             Union{Missing, DateTime},
                             Union{Missing, GeoInterface.Point},
                             Union{Missing, GeoInterface.LineString},
                             Union{Missing, GeoInterface.Point},
                             Union{Missing, GeoInterface.LineString}
                             ]

#Test polygon and multipolygon separately due to outstanding Thrift issue
#https://github.com/tanmaykm/Thrift.jl/issues/51

polycol = ["POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))", "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
(20 30, 35 35, 30 20, 20 30))", "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))", "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
(20 30, 35 35, 30 20, 20 30))"]
mpolycol = ["MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))",
"MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35), (30 20, 20 15, 20 25, 30 20)))",
"MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))",
"MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35), (30 20, 20 15, 20 25, 30 20)))"]

polysql = "create table polys (col1 polygon, col2 multipolygon)"
sql_execute(conn, polysql)
polydf = DataFrame([polycol, mpolycol])

@test load_table(conn, "polys", polydf) == nothing
@test load_table(conn, "polys", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(polydf)]) == nothing

#test loading native GeoInterface objects
polydf_native = DataFrame([GeoInterface.Polygon.(readgeom.(polycol)),
                           GeoInterface.MultiPolygon.(readgeom.(mpolycol))
                           ])

@test load_table(conn, "polys", polydf_native) == nothing
@test load_table(conn, "polys", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(polydf_native)]) == nothing

polydb = sql_execute(conn, "select * from polys")
@test eltypes(polydb) == Type[Union{Missing, GeoInterface.Polygon}, Union{Missing, GeoInterface.MultiPolygon}]

sql2 = """
create table test2 (
col1 tinyint,
col2 smallint,
col3 integer,
col4 bigint,
col5 float,
col6 double,
col8 text,
col9 text encoding dict(32),
col10 boolean,
col11 date,
col12 time,
col13 timestamp
)
"""

sql_execute(conn, sql2)

df2 = DataFrame([tinyintcol, smallintcol, intcol, bigintcol, floatcol, doublecol,
                textcol, textcol, boolcol, datecol, timecol, tscol])

#load table columnwise
@test load_table_binary_columnar(conn, "test2", df2) == nothing

#load data from Vector{TColumn}
@test load_table_binary_columnar(conn, "test2", [TColumn(df2[x]) for x in 1:ncol(df2)]) == nothing

#TODO: create a show method and/or return as dataframe
hware = get_hardware_info(conn)
@test typeof(hware) == OmniSci.TClusterHardwareInfo

#TODO: Figure out IPC
cpu_arrow = sql_execute_df(conn,  "select id from omnisci_counties limit 100", 0, 0)
@test typeof(cpu_arrow) == OmniSci.TDataFrame


######################################## not exported (essentially, OmniSci internal)

clear_cpu = OmniSci.clear_cpu_memory(conn)
@test typeof(clear_cpu) == Nothing

execmode = OmniSci.set_execution_mode(conn, TExecuteMode.CPU)
@test typeof(execmode) == Nothing

glc = OmniSci.get_license_claims(conn)
@test typeof(glc) == OmniSci.TLicenseInfo

mem = OmniSci.get_memory(conn, "cpu")
@test typeof(mem) == Vector{OmniSci.TNodeMemoryInfo}
