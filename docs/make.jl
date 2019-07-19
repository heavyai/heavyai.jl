using Documenter, OmniSci

makedocs(
    # options
    modules = [OmniSci],
    clean = false,
    format = Documenter.HTML(assets = ["assets/favicon.ico"]),
    sitename = "OmniSci.jl",
    pages = [
        "Getting Started" => "index.md",
        "Functions" => "functions.md",
        "API Reference" => "apireference.md"

    ]
)

deploydocs(
    repo = "github.com/omnisci/OmniSci.jl.git",
    #julia = "1.0",
    deps=nothing,
    make=nothing,
    target = "build"
)
