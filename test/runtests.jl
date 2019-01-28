using OmniSci, Test, Dates, Random, DataFrames, DecFP, GeoInterface, LibGEOS

#defaults for OmniSci CPU Docker image
host="localhost"
user="mapd"
passwd="HyperInteractive"
port=9091
dbname="mapd"

#global connection to database, used for most tests
conn = connect(host, port , user, passwd, dbname)

@testset "connect/disconnect" begin
   #set up connection just to disconnect
   conn_d = connect(host, port , user, passwd, dbname)
   @test typeof(conn_d) == OmniSci.OmniSciConnection

   disc = disconnect(conn_d)
   @test typeof(disc) == Nothing
end

@testset "get_status" begin
   #get properties of server: version, rendering enabled, start time, etc.
   sstatus = get_status(conn)
   @test typeof(sstatus) == Vector{OmniSci.TServerStatus}
   @test sstatus[1].start_time <= Dates.datetime2unix(now(UTC)) #test sstatus has values...assumes server started before test happened
end

@testset "get_users" begin
   #get users for the database specified in connect()
   users = get_users(conn)
   @test typeof(users) == DataFrame

   users_nodf = get_users(conn, as_df = false)
   @test typeof(users_nodf) == Vector{String}
end

@testset "get_databases" begin
   #get databases user specified during connect() can see
   databases = get_databases(conn)
   @test typeof(databases) == DataFrame

   databases_nodf = get_databases(conn, as_df = false)
   @test typeof(databases_nodf) == Vector{OmniSci.TDBInfo}
end

@testset "get_tables_meta" begin
   #gets tables/views and their properties
   met = get_tables_meta(conn)
   @test typeof(met) == DataFrame

   met_nodf = get_tables_meta(conn, as_df = false)
   @test typeof(met_nodf) == Vector{OmniSci.TTableMeta}
end

@testset "sql_execute df" begin
   #execute query, return result via Thrift interface
   se = sql_execute(conn, "select * from omnisci_counties")
   @test typeof(se) == DataFrame
   @test size(se) == (3250, 6)
   @test eltypes(se) ==  [Union{Missing, String},
                          Union{Missing, String},
                          Union{Missing, String},
                          Union{Missing, String},
                          Union{Missing, String},
                          Union{Missing, GeoInterface.MultiPolygon}
                          ]
end

@testset "create/get_dashboards and grantees" begin
   #cdash represents id of dashboard created, use for later tests
   cdash = OmniSci.create_dashboard(conn, randstring(10), "state", "image", "metadata")
   @test cdash > 0

   getdbs = get_dashboards(conn)
   @test typeof(getdbs) == DataFrame

   getdbs_nodf = get_dashboards(conn, as_df = false)
   @test typeof(getdbs_nodf) == Vector{OmniSci.TDashboard}

   getdashgrant = get_dashboard_grantees(conn, cdash)
   @test typeof(getdashgrant) == Vector{OmniSci.TDashboardGrantees}
end

@testset "get_roles" begin
   gr = get_roles(conn)
   @test typeof(gr) == DataFrame

   gr_nodf = get_roles(conn, as_df = false)
   @test typeof(gr_nodf) == Vector{String}
end

@testset "get_table_details" begin
   tbl_details = get_table_details(conn, "omnisci_counties")
   @test typeof(tbl_details) == DataFrame
   @test size(tbl_details) == (6,21)
   @test names(tbl_details) == [:col_name, :col_type, :comp_param, :encoding, :is_array, :is_physical,
                               :is_reserved_keyword, :is_system, :nullable, :precision, :scale,
                               :size, :src_name, :fragment_size, :page_size, :max_rows, :view_sql,
                               :shard_count, :key_metainfo, :is_temporary, :partition_detail]

   tbl_details_nodf = get_table_details(conn, "omnisci_counties", as_df = false)
   @test typeof(tbl_details_nodf) == OmniSci.TTableDetails
end

@testset "get_all_roles_for_user" begin
   #drop for convenience so later test will pass, just in case tests run multiple times
   "testuser" in get_roles(conn, as_df=false) ? sql_execute(conn, "drop role testuser") : nothing
   "mapd2" in get_users(conn, as_df=false) ? sql_execute(conn, "drop user mapd2") : nothing

   #get roles assigned to user
   sql_execute(conn, "create role testuser")
   sql_execute(conn, "create user mapd2 (password = 'OmniSciRocks!', is_super = 'true')")
   sql_execute(conn, "grant testuser to mapd2")
   roleuser = get_all_roles_for_user(conn, "mapd2")
   @test typeof(roleuser) == DataFrame

   roleuser_nodf = get_all_roles_for_user(conn, "mapd2", as_df = false)
   @test typeof(roleuser_nodf) == Vector{String}
end

@testset "create_table, load_table[_binary_columnar]: int, float/double" begin

   tinyintcol = Union{Int8,Missing}[missing,3,2,1]
   smallintcol = Union{Int16,Missing}[4,missing,2,1]
   intcol = Union{Int32,Missing}[4,3,missing,1]
   bigintcol = Union{Int64,Missing}[4,3,2,missing]
   floatcol = Union{Float32,Missing}[missing, 4.1, 2.69, 3.8]
   doublecol = [3//2, missing, 9//72, 90/112]

   df = DataFrame(x1 = tinyintcol,
                  x2 = smallintcol,
                  x3 = intcol,
                  x4 = bigintcol,
                  x5 = floatcol,
                  x6 = doublecol)

   #drop table if it exists
   tables = get_tables_meta(conn)
   "test_int_float" in tables[:table_name] ? sql_execute(conn, "drop table test_int_float") : nothing

   @test create_table(conn, "test_int_float", df) == nothing

   #load data rowwise from dataframe
   @test load_table(conn, "test_int_float", df) == nothing

   #load data rowwise from Vector{TStringRow}
   @test load_table(conn, "test_int_float", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(df)]) == nothing

   #load data colwise from dataframe
   @test load_table_binary_columnar(conn, "test_int_float", df) == nothing

   #load data colwise from Vector{TColumn}
   @test load_table_binary_columnar(conn, "test_int_float", [TColumn(df[x]) for x in 1:ncol(df)]) == nothing

   #test roundtrip of data
   tbldb = sql_execute(conn, "select * from test_int_float")
   @test size(tbldb) == (16,6)
   @test isequal(df, tbldb[1:4, :])
   @test isequal(vcat(df, df, df, df), tbldb)
end

@testset "create_table, load_table[_binary_columnar]: dates/times" begin
   datecol = [Date(2013,7,1), missing, Date(2013,7,1), Date(2013,7,1)]
   timecol = [Time(4), Time(5), missing, Time(7)]
   tscol = [DateTime(2013,7,1,12,30,59), DateTime(2013,7,1,12,30,59), DateTime(2013,7,1,12,30,59), missing]

   df = DataFrame(x1 = datecol, x2 = timecol, x3 = tscol)

   #drop table if it exists
   tables = get_tables_meta(conn)
   "test_dates_times" in tables[:table_name] ? sql_execute(conn, "drop table test_dates_times") : nothing

   @test create_table(conn, "test_dates_times", df) == nothing

   #load data rowwise from dataframe
   @test load_table(conn, "test_dates_times", df) == nothing

   #load data rowwise from Vector{TStringRow}
   @test load_table(conn, "test_dates_times", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(df)]) == nothing

   #load data colwise from dataframe
   @test load_table_binary_columnar(conn, "test_dates_times", df) == nothing

   #load data colwise from Vector{TColumn}
   @test load_table_binary_columnar(conn, "test_dates_times", [TColumn(df[x]) for x in 1:ncol(df)]) == nothing

   #test roundtrip of data
   tbldb = sql_execute(conn, "select * from test_dates_times")
   @test size(tbldb) == (16,3)
   @test isequal(df, tbldb[1:4, :])
   @test isequal(vcat(df, df, df, df), tbldb)
end

# @testset "load_table: geospatial" begin
#    pointcol = ["POINT (30 10)", "POINT (-30.18764587 12.2)", "POINT (30 -10.437878634)", "POINT (-78 -25)"]
#    linecol = ["LINESTRING (30 10, 10 30, 40 40)", "LINESTRING (30 10, 10 30, 40 40)", "LINESTRING (30 10, 10 30, 40 40)", "LINESTRING (30 10, 10 30, 40 40)"]
#    pointcol_native = GeoInterface.Point.(readgeom.(pointcol))
#    linecol_native = GeoInterface.LineString.(readgeom.(linecol))
#    polycol = ["POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))", "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
#     (20 30, 35 35, 30 20, 20 30))", "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))", "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
#     (20 30, 35 35, 30 20, 20 30))"]
#    mpolycol = ["MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))",
#    "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35), (30 20, 20 15, 20 25, 30 20)))",
#    "MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))",
#    "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35), (30 20, 20 15, 20 25, 30 20)))"]
#
#    df = DataFrame(x1 = pointcol,
#                   x2 = linecol,
#                   x3 = pointcol_native,
#                   x4 = linecol_native,
#                   x5 = polycol,
#                   x6 = mpolycol
#                   )
#
#    #drop table if it exists
#    tables = get_tables_meta(conn)
#    "test_geo" in tables[:table_name] ? sql_execute(conn, "drop table test_geo") : nothing
#
#    @test create_table(conn, "test_geo", df) == nothing
#
#    #load data rowwise from dataframe
#    @test load_table(conn, "test_geo", df) == nothing
#
#    #load data rowwise from Vector{TStringRow}
#    @test load_table(conn, "test_geo", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(df)]) == nothing
#
#    #test roundtrip of data
#    tbldb = sql_execute(conn, "select * from test_geo")
#    @test size(tbldb) == (8,6)
#    @test isequal(df, tbldb[1:4, :])
#    @test isequal(vcat(df, df), tbldb)
# end

# decimalcol = [3.0, 4.1, missing, 3.8]
# textcol = ["hello", "world", "omnisci", "gpu"]
# boolcol = [missing, false, true, true]
#
# #validate return types same as server
# tbldb = sql_execute(conn, "select * from test")
# @test eltypes(tbldb) == Type[Union{Missing, Int8},
#                              Union{Missing, Int16},
#                              Union{Missing, Int32},
#                              Union{Missing, Int64},
#                              Union{Missing, Float32},
#                              Union{Missing, Float64},
#                              Union{Missing, String},
#                              Union{Missing, String},
#                              Union{Missing, Bool},
#                              Union{Missing, Date},
#                              Union{Missing, Time},
#                              Union{Missing, DateTime},
#                              Union{Missing, GeoInterface.Point},
#                              Union{Missing, GeoInterface.LineString},
#                              Union{Missing, GeoInterface.Point},
#                              Union{Missing, GeoInterface.LineString}
#                              ]
#
# #Test polygon and multipolygon separately due to outstanding Thrift issue
# #https://github.com/tanmaykm/Thrift.jl/issues/51
#

# polysql = "create table polys (col1 polygon, col2 multipolygon)"
# sql_execute(conn, polysql)
# polydf = DataFrame([polycol, mpolycol])
#
# @test load_table(conn, "polys", polydf) == nothing
# @test load_table(conn, "polys", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(polydf)]) == nothing
#
# #test loading native GeoInterface objects
# polydf_native = DataFrame([GeoInterface.Polygon.(readgeom.(polycol)),
#                            GeoInterface.MultiPolygon.(readgeom.(mpolycol))
#                            ])
#
# @test load_table(conn, "polys", polydf_native) == nothing
# @test load_table(conn, "polys", [OmniSci.TStringRow(x) for x in DataFrames.eachrow(polydf_native)]) == nothing
#
# polydb = sql_execute(conn, "select * from polys")
# @test eltypes(polydb) == Type[Union{Missing, GeoInterface.Polygon}, Union{Missing, GeoInterface.MultiPolygon}]
#
# sql2 = """
# create table test2 (
# col1 tinyint,
# col2 smallint,
# col3 integer,
# col4 bigint,
# col5 float,
# col6 double,
# col8 text,
# col9 text encoding dict(32),
# col10 boolean,
# col11 date,
# col12 time,
# col13 timestamp
# )
# """
#
# sql_execute(conn, sql2)
#
# df2 = DataFrame([tinyintcol, smallintcol, intcol, bigintcol, floatcol, doublecol,
#                 textcol, textcol, boolcol, datecol, timecol, tscol])
#
# #load table columnwise
# @test load_table_binary_columnar(conn, "test2", df2) == nothing
#
# #load data from Vector{TColumn}
# @test load_table_binary_columnar(conn, "test2", [TColumn(df2[x]) for x in 1:ncol(df2)]) == nothing
#
# #### Test loading arrays rowwise
# sqlarray = """
# CREATE TABLE arrayexamples (
# tiny_int_array TINYINT[],
# int_array INTEGER[],
# big_int_array BIGINT[],
# text_array TEXT[],
# float_array FLOAT[],
# double_array DOUBLE[],
# decimal_array DECIMAL(18,6)[],
# boolean_array BOOLEAN[],
# date_array DATE[],
# time_array TIME[],
# timestamp_array TIMESTAMP[])
# """
#
# sql_execute(conn, sqlarray)
#
# tinyarrarr = [tinyintcol, tinyintcol, tinyintcol, tinyintcol]
# intarrarr = [intcol, intcol, intcol, intcol]
# bigintarrarr = [bigintcol, bigintcol, bigintcol, bigintcol]
# textarrarr = [textcol, textcol, textcol, textcol]
# floatarrarr = [floatcol, floatcol, floatcol, floatcol]
# dblarrarr = [doublecol, doublecol, doublecol, doublecol]
# decarrarr = [decimalcol, decimalcol, decimalcol, decimalcol]
# boolarrarr = [boolcol, boolcol, boolcol, boolcol]
# datearrarr = [datecol, datecol, datecol, datecol]
# timearrarr = [timecol, timecol, timecol, timecol]
# tsarrarr = [tscol, tscol, tscol, tscol]
#
# dfarray = DataFrame([tinyarrarr, intarrarr, bigintarrarr, textarrarr, floatarrarr,
#                     dblarrarr, decarrarr, boolarrarr, datearrarr, timearrarr, tsarrarr])
# @test load_table(conn, "arrayexamples", dfarray) == nothing

@testset "get_hardware_info" begin
   #TODO: create a show method and/or return as dataframe
   hware = get_hardware_info(conn)
   @test typeof(hware) == OmniSci.TClusterHardwareInfo
end

@testset "sql_execute_df" begin
   #TODO: Figure out IPC
   cpu_arrow = sql_execute_df(conn,  "select id from omnisci_counties limit 100", 0, 0)
   @test typeof(cpu_arrow) == OmniSci.TDataFrame
end

######################################## not exported (essentially, OmniSci internal)

@testset "clear_cpu_memory" begin
   clear_cpu = OmniSci.clear_cpu_memory(conn)
   @test typeof(clear_cpu) == Nothing
end

@testset "set_execution_mode" begin
   execmode = OmniSci.set_execution_mode(conn, TExecuteMode.CPU)
   @test typeof(execmode) == Nothing
end

@testset "get_memory" begin
   mem = OmniSci.get_memory(conn, "cpu")
   @test typeof(mem) == Vector{OmniSci.TNodeMemoryInfo}
end
