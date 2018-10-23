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

#After individual types have DataFrame methods written, this method concatenates
DataFrame(x::Vector{<:Union{TDBInfo, TTableMeta, TDashboard}})  = vcat(DataFrame.(x)...)
