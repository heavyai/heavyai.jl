Introduction statement.

#### Installation

OmniSci.jl is still in very heavy development mode; to get the most up-to-date version, use `Pkg.clone()` or similar to build from master. Otherwise, this package will follow semver standards and quick iteration cycles (and tags to METADATA) while the package is being developed.

Currently, IPC functionality using Apache Arrow isn't implemented. This is the biggest opportunity for improvement, and I welcome any and all help from the community!

#### Authentication

The first step in using OmniSci.jl is to authenticate against an OmniSci database. Currently, OmniSci.jl only implements the binary transfer protocol from Apache Thrift (i.e. port must equal 9091); https support to be developed at a later date.

Using the default login credentials for a new OmniSci install:

```
julia> using OmniSci

julia> conn = connect("localhost", 9091, "mapd", "HyperInteractive", "mapd")
Connected to localhost:9091
```

#### Usage

Once authenticated, use the `conn` object as the first argument for each method in the package:

```
julia> tbl = get_tables_meta(conn)
5×6 DataFrame
│ Row │ is_replicated │ is_view │ max_rows            │ num_cols │ shard_count │ table_name        │
│     │ Bool          │ Bool    │ Int64               │ Int64    │ Int64       │ String            │
├─────┼───────────────┼─────────┼─────────────────────┼──────────┼─────────────┼───────────────────┤
│ 1   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ omnisci_states    │
│ 2   │ false         │ false   │ 4611686018427387904 │ 6        │ 0           │ omnisci_counties  │
│ 3   │ false         │ false   │ 4611686018427387904 │ 64       │ 0           │ omnisci_countries │
│ 4   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test2             │
│ 5   │ false         │ false   │ 4611686018427387904 │ 4        │ 0           │ test              │
```
