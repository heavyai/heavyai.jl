# Internal Functions

For completeness of wrapping the OmniSci Thrift interface, the following functions have been implemented. These functions represent either internal OmniSci functionality and/or functions that have other convenience methods defined around them.

It is not expected that a user would need to use these functions under normal circumstances.

## Licensing

```@docs
get_license_claims
set_license_key
```

## Memory Management
```@docs
deallocate_df
clear_gpu_memory
clear_cpu_memory
set_execution_mode
get_memory
```

## Misc

```@docs
sql_validate
interrupt
```
