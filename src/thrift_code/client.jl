#
# Autogenerated by Thrift Compiler (0.11.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING

# Client callable method for connect
function connect(c::MapDClient, user::String, passwd::String, dbname::String)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "connect", Thrift.MessageType.CALL, c.seqid)
  inp = connect_args()
  Thrift.set_field!(inp, :user, user)
  Thrift.set_field!(inp, :passwd, passwd)
  Thrift.set_field!(inp, :dbname, dbname)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, connect_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function connect

# Client callable method for disconnect
function disconnect(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "disconnect", Thrift.MessageType.CALL, c.seqid)
  inp = disconnect_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, disconnect_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function disconnect

# # Client callable method for get_server_status
# function get_server_status(c::MapDClient, session::TSessionId)
#   p = c.p
#   c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
#   Thrift.writeMessageBegin(p, "get_server_status", Thrift.MessageType.CALL, c.seqid)
#   inp = get_server_status_args()
#   Thrift.set_field!(inp, :session, session)
#   Thrift.write(p, inp)
#   Thrift.writeMessageEnd(p)
#   Thrift.flush(p.t)
#
#   (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
#   (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
#   outp = Thrift.read(p, get_server_status_result())
#   Thrift.readMessageEnd(p)
#   (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
#   Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
#   Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
#   throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
# end # function get_server_status

# Client callable method for get_status
function get_status(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_status", Thrift.MessageType.CALL, c.seqid)
  inp = get_status_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_status_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_status

# Client callable method for get_hardware_info
function get_hardware_info(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_hardware_info", Thrift.MessageType.CALL, c.seqid)
  inp = get_hardware_info_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_hardware_info_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_hardware_info

# Client callable method for get_tables_meta
function get_tables_meta(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_tables_meta", Thrift.MessageType.CALL, c.seqid)
  inp = get_tables_meta_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_tables_meta_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_tables_meta

# Client callable method for get_table_details
function get_table_details(c::MapDClient, session::TSessionId, table_name::String)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_table_details", Thrift.MessageType.CALL, c.seqid)
  inp = get_table_details_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :table_name, table_name)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_table_details_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_table_details

# Client callable method for get_users
function get_users(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_users", Thrift.MessageType.CALL, c.seqid)
  inp = get_users_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_users_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_users

# Client callable method for get_databases
function get_databases(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_databases", Thrift.MessageType.CALL, c.seqid)
  inp = get_databases_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_databases_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_databases

# Client callable method for get_memory
function get_memory(c::MapDClient, session::TSessionId, memory_level::String)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_memory", Thrift.MessageType.CALL, c.seqid)
  inp = get_memory_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :memory_level, memory_level)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_memory_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_memory

# Client callable method for clear_cpu_memory
function clear_cpu_memory(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "clear_cpu_memory", Thrift.MessageType.CALL, c.seqid)
  inp = clear_cpu_memory_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, clear_cpu_memory_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function clear_cpu_memory

# Client callable method for clear_gpu_memory
function clear_gpu_memory(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "clear_gpu_memory", Thrift.MessageType.CALL, c.seqid)
  inp = clear_gpu_memory_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, clear_gpu_memory_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function clear_gpu_memory

# Client callable method for sql_execute
function sql_execute(c::MapDClient, session::TSessionId, query::String, column_format::Bool, nonce::String, first_n::Int32, at_most_n::Int32)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "sql_execute", Thrift.MessageType.CALL, c.seqid)
  inp = sql_execute_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :query, query)
  Thrift.set_field!(inp, :column_format, column_format)
  Thrift.set_field!(inp, :nonce, nonce)
  Thrift.set_field!(inp, :first_n, first_n)
  Thrift.set_field!(inp, :at_most_n, at_most_n)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, sql_execute_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function sql_execute

# Client callable method for sql_execute_df
function sql_execute_df(c::MapDClient, session::TSessionId, query::String, device_type::Int32, device_id::Int32, first_n::Int32)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "sql_execute_df", Thrift.MessageType.CALL, c.seqid)
  inp = sql_execute_df_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :query, query)
  Thrift.set_field!(inp, :device_type, device_type)
  Thrift.set_field!(inp, :device_id, device_id)
  Thrift.set_field!(inp, :first_n, first_n)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, sql_execute_df_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function sql_execute_df

# Client callable method for sql_execute_gdf
function sql_execute_gdf(c::MapDClient, session::TSessionId, query::String, device_id::Int32, first_n::Int32)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "sql_execute_gdf", Thrift.MessageType.CALL, c.seqid)
  inp = sql_execute_gdf_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :query, query)
  Thrift.set_field!(inp, :device_id, device_id)
  Thrift.set_field!(inp, :first_n, first_n)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, sql_execute_gdf_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function sql_execute_gdf

# Client callable method for deallocate_df
function deallocate_df(c::MapDClient, session::TSessionId, df::TDataFrame, device_type::Int32, device_id::Int32)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "deallocate_df", Thrift.MessageType.CALL, c.seqid)
  inp = deallocate_df_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :df, df)
  Thrift.set_field!(inp, :device_type, device_type)
  Thrift.set_field!(inp, :device_id, device_id)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, deallocate_df_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function deallocate_df

# Client callable method for interrupt
function interrupt(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "interrupt", Thrift.MessageType.CALL, c.seqid)
  inp = interrupt_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, interrupt_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function interrupt

# Client callable method for set_execution_mode
function set_execution_mode(c::MapDClient, session::TSessionId, mode::Int32)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "set_execution_mode", Thrift.MessageType.CALL, c.seqid)
  inp = set_execution_mode_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :mode, mode)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, set_execution_mode_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function set_execution_mode

# Client callable method for render_vega
function render_vega(c::MapDClient, session::TSessionId, widget_id::Int64, vega_json::String, compression_level::Int32, nonce::String)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "render_vega", Thrift.MessageType.CALL, c.seqid)
  inp = render_vega_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :widget_id, widget_id)
  Thrift.set_field!(inp, :vega_json, vega_json)
  Thrift.set_field!(inp, :compression_level, compression_level)
  Thrift.set_field!(inp, :nonce, nonce)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, render_vega_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function render_vega

# Client callable method for get_dashboards
function get_dashboards(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_dashboards", Thrift.MessageType.CALL, c.seqid)
  inp = get_dashboards_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_dashboards_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_dashboards

# Client callable method for create_dashboard
function create_dashboard(c::MapDClient, session::TSessionId, dashboard_name::String, dashboard_state::String, image_hash::String, dashboard_metadata::String)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "create_dashboard", Thrift.MessageType.CALL, c.seqid)
  inp = create_dashboard_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :dashboard_name, dashboard_name)
  Thrift.set_field!(inp, :dashboard_state, dashboard_state)
  Thrift.set_field!(inp, :image_hash, image_hash)
  Thrift.set_field!(inp, :dashboard_metadata, dashboard_metadata)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, create_dashboard_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function create_dashboard

# Client callable method for get_dashboard_grantees
function get_dashboard_grantees(c::MapDClient, session::TSessionId, dashboard_id::Int32)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_dashboard_grantees", Thrift.MessageType.CALL, c.seqid)
  inp = get_dashboard_grantees_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :dashboard_id, dashboard_id)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_dashboard_grantees_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_dashboard_grantees

# Client callable method for load_table_binary_columnar
function load_table_binary_columnar(c::MapDClient, session::TSessionId, table_name::String, cols::Vector{TColumn})
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "load_table_binary_columnar", Thrift.MessageType.CALL, c.seqid)
  inp = load_table_binary_columnar_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :table_name, table_name)
  Thrift.set_field!(inp, :cols, cols)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, load_table_binary_columnar_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function load_table_binary_columnar

# Client callable method for load_table_binary_arrow
function load_table_binary_arrow(c::MapDClient, session::TSessionId, table_name::String, arrow_stream::Vector{UInt8})
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "load_table_binary_arrow", Thrift.MessageType.CALL, c.seqid)
  inp = load_table_binary_arrow_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :table_name, table_name)
  Thrift.set_field!(inp, :arrow_stream, arrow_stream)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, load_table_binary_arrow_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function load_table_binary_arrow

# Client callable method for load_table
function load_table(c::MapDClient, session::TSessionId, table_name::String, rows::Vector{TStringRow})
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "load_table", Thrift.MessageType.CALL, c.seqid)
  inp = load_table_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :table_name, table_name)
  Thrift.set_field!(inp, :rows, rows)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, load_table_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function load_table

# Client callable method for create_table
function create_table(c::MapDClient, session::TSessionId, table_name::String, row_desc::TRowDescriptor, table_type::Int32, create_params::TCreateParams)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "create_table", Thrift.MessageType.CALL, c.seqid)
  inp = create_table_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :table_name, table_name)
  Thrift.set_field!(inp, :row_desc, row_desc)
  Thrift.set_field!(inp, :table_type, table_type)
  Thrift.set_field!(inp, :create_params, create_params)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, create_table_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  nothing
end # function create_table

# Client callable method for get_roles
function get_roles(c::MapDClient, session::TSessionId)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_roles", Thrift.MessageType.CALL, c.seqid)
  inp = get_roles_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_roles_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_roles

# Client callable method for get_all_roles_for_user
function get_all_roles_for_user(c::MapDClient, session::TSessionId, userName::String)
  p = c.p
  c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
  Thrift.writeMessageBegin(p, "get_all_roles_for_user", Thrift.MessageType.CALL, c.seqid)
  inp = get_all_roles_for_user_args()
  Thrift.set_field!(inp, :session, session)
  Thrift.set_field!(inp, :userName, userName)
  Thrift.write(p, inp)
  Thrift.writeMessageEnd(p)
  Thrift.flush(p.t)

  (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
  (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
  outp = Thrift.read(p, get_all_roles_for_user_result())
  Thrift.readMessageEnd(p)
  (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
  Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
  Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
  throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
end # function get_all_roles_for_user

# # Client callable method for set_license_key
# function set_license_key(c::MapDClient, session::TSessionId, key::String, nonce::String)
#   p = c.p
#   c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
#   Thrift.writeMessageBegin(p, "set_license_key", Thrift.MessageType.CALL, c.seqid)
#   inp = set_license_key_args()
#   Thrift.set_field!(inp, :session, session)
#   Thrift.set_field!(inp, :key, key)
#   Thrift.set_field!(inp, :nonce, nonce)
#   Thrift.write(p, inp)
#   Thrift.writeMessageEnd(p)
#   Thrift.flush(p.t)
#
#   (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
#   (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
#   outp = Thrift.read(p, set_license_key_result())
#   Thrift.readMessageEnd(p)
#   (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
#   Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
#   Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
#   throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
# end # function set_license_key

# # Client callable method for get_license_claims
# function get_license_claims(c::MapDClient, session::TSessionId, nonce::String)
#   p = c.p
#   c.seqid = (c.seqid < (2^31-1)) ? (c.seqid+1) : 0
#   Thrift.writeMessageBegin(p, "get_license_claims", Thrift.MessageType.CALL, c.seqid)
#   inp = get_license_claims_args()
#   Thrift.set_field!(inp, :session, session)
#   Thrift.set_field!(inp, :nonce, nonce)
#   Thrift.write(p, inp)
#   Thrift.writeMessageEnd(p)
#   Thrift.flush(p.t)
#
#   (fname, mtype, rseqid) = Thrift.readMessageBegin(p)
#   (mtype == Thrift.MessageType.EXCEPTION) && throw(Thrift.read(p, Thrift.TApplicationException()))
#   outp = Thrift.read(p, get_license_claims_result())
#   Thrift.readMessageEnd(p)
#   (rseqid != c.seqid) && throw(Thrift.TApplicationException(ApplicationExceptionType.BAD_SEQUENCE_ID, "response sequence id $rseqid did not match request ($(c.seqid))"))
#   Thrift.has_field(outp, :e) && throw(Thrift.get_field(outp, :e))
#   Thrift.has_field(outp, :success) && (return Thrift.get_field(outp, :success))
#   throw(Thrift.TApplicationException(Thrift.ApplicationExceptionType.MISSING_RESULT, "retrieve failed: unknown result"))
# end # function get_license_claims
