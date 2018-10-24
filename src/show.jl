#Need to validate this always returns a Vector length 1
#Figure out how to parameterize if possible
function Base.show(io::IO, ::MIME"text/plain", m::Vector{TServerStatus})

    props = propertynames(m[1])

    println(io, "$(eltype(m))\n")
    for sym in props
        println(io, """  $(sym): $(getfield(m[1], sym))""")
    end

end
