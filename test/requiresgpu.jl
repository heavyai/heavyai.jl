using JSON

clear_gpu = clear_gpu_memory(conn)
@test typeof(clear_gpu) == Nothing

v = String(JSON.read("test/data/omnisci_vega.json"))
veg = render_vega(conn, v, 1)
@test typeof(veg) == OmniSci.TRenderResult
# using ImageMagick
# ImageMagick.readblob(veg.image)

#Can't test this on Travis, use OmniSci Jenkins?
#sql_execute_gdf
