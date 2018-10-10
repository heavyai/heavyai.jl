Introduction statement.

#### Installation

OmniSci.jl is still in very heavy development mode; as such, it is currently not on [METADATA](https://github.com/JuliaLang/METADATA.jl). To install, use `Pkg.clone()` or similar.

#### Authentication

The first step in using OmniSci.jl is to authenticate against an OmniSci database. Currently, OmniSci.jl only implements the binary transfer protocol from Apache Thrift; https support to be developed at a later date.

Using the default login credentials for a new OmniSci install:

```
julia> using OmniSci

julia> conn = connect("localhost", 9091, "mapd", "HyperInteractive", "mapd")
Connected to localhost:9091
```

#### Usage

Once authenticated, use the `conn` object as the first argument for each method in the package:

```
julia> tbl = get_tables(conn)
4-element Array{String,1}:
 "mapd_states"
 "mapd_counties"
 "mapd_countries"
 "nyc_trees_2015_683k"
```
