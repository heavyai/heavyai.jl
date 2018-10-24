clear_gpu = clear_gpu_memory(conn)
@test typeof(clear_gpu) == Nothing

#Can't test this on Travis, use OmniSci Jenkins?
#sql_execute_gdf
