These functions constitute the main interface for working with OmniSci. If a function is not exported for the package, the assumption is that an end-user shouldn't need to use it. If you find otherwise, please [open an issue](https://github.com/omnisci/OmniSci.jl/issues) for discussion.

## Authentication

```@docs
connect
disconnect
```

## Querying Data
```@docs
sql_execute
sql_execute_df
sql_execute_gdf
```

## Loading Data
```@docs
create_table
load_table
load_table_binary_arrow
load_table_binary
load_table_binary_columnar
import_geo_table
```

## Table Metadata
```@docs
get_tables_meta
get_table_details
```

## Dashboards
```@docs
create_dashboard
share_dashboard
unshare_dashboard
get_dashboards
get_dashboard_grantees
replace_dashboard
delete_dashboard
render_vega
```

## Metadata
```@docs
get_databases
get_users
get_roles
get_hardware_info
get_status
get_all_roles_for_user
get_db_objects_for_grantee
get_db_object_privs
```
