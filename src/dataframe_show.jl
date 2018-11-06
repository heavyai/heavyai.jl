function DataFrame(x::TQueryResult)

    #get column name and whether column is nullable
    colnames = [desc.col_name for desc in x.row_set.row_desc]

    #collapse vectors into a single Vector{T, Missing} vector
    mergecols = [squashbitmask(y) for y in x.row_set.columns]

    #convert to DataFrame
    df = DataFrame(mergecols)
    names!(df, Symbol.(colnames))

    return df

end

#iterate over propertynames and build dict, make parametric?
DataFrame(x::TDBInfo) = DataFrame(Dict(:db_name => x.db_name, :db_owner => x.db_owner))

DataFrame(x::TTableMeta) = DataFrame(Dict(:table_name => x.table_name,
                                          :num_cols => x.num_cols,
                                          :is_view => x.is_view,
                                          :is_replicated => x.is_replicated,
                                          :shard_count => x.shard_count,
                                          :max_rows => x.max_rows
                                          )
                                    )

DataFrame(x::TDashboard) = DataFrame(Dict(:dashboard_name => x.dashboard_name,
                                          :dashboard_state => x.dashboard_state,
                                          :image_hash => x.image_hash,
                                          :update_time => x.update_time,
                                          :dashboard_metadata => x.dashboard_metadata,
                                          :dashboard_id => x.dashboard_id,
                                          :dashboard_owner => x.dashboard_owner,
                                          :is_dash_shared => x.is_dash_shared
                                          )
                                    )

#This one digs into col_type, so slightly different than others that might be generated
DataFrame(x::TColumnType) = DataFrame(Dict(:col_name => x.col_name,
                                           :col_type => x.col_type._type,
                                           :encoding => x.col_type.encoding,
                                           :nullable => x.col_type.nullable,
                                           :is_array => x.col_type.is_array,
                                           :precision => x.col_type.precision,
                                           :scale => x.col_type.scale,
                                           :comp_param => x.col_type.comp_param,
                                           :size => x.col_type.size,
                                           :is_reserved_keyword => x.is_reserved_keyword,
                                           :src_name => x.src_name,
                                           :is_system => x.is_system,
                                           :is_physical => x.is_physical
                                          )
                                      )

#This is slightly awkward, in that the added columns make it seem like these are row-level info
#In reality, these fields are table-level
#TODO: think about how to better represent
function DataFrame(x::TTableDetails)

    tmp = DataFrame(x.row_desc)
    tmp[:fragment_size] = x.fragment_size
    tmp[:page_size] = x.page_size
    tmp[:max_rows] = x.max_rows
    tmp[:view_sql] = x.view_sql
    tmp[:shard_count] = x.shard_count
    tmp[:key_metainfo] = x.key_metainfo
    tmp[:is_temporary] = x.is_temporary
    tmp[:partition_detail] = x.partition_detail

    return tmp
end

#After individual types have DataFrame methods written, this method concatenates
DataFrame(x::Vector{<:Union{TDBInfo, TTableMeta, TDashboard, TColumnType}})  = vcat(DataFrame.(x)...)

#Need to validate this always returns a Vector length 1
#Figure out how to parameterize if possible
function Base.show(io::IO, ::MIME"text/plain", m::Vector{TServerStatus})

    props = propertynames(m[1])

    println(io, "$(eltype(m))\n")
    for sym in props
        println(io, """  $(sym): $(getfield(m[1], sym))""")
    end

end

#REPL display; show method for Juno uses inline tree display
Base.show(io::IO, ::MIME"text/plain", m::OmniSciConnection) = println(io, "Connected to $(m.c.p.t.host):$(m.c.p.t.port)")
