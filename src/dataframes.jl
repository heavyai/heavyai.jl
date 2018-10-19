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
