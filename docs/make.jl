using Documenter, OmniSci

makedocs(
    # options
    modules = [OmniSci],
    format = :html,
    sitename = "OmniSci.jl",
    pages = [
        "index.md"

    ]
)

deploydocs(
    repo = "github.com/omnisci/OmniSci.jl.git",
    julia = "1.0",
    deps=nothing,
    make=nothing
)
