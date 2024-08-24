using PowerNetworkDiagrams
using Documenter

DocMeta.setdocmeta!(PowerNetworkDiagrams, :DocTestSetup, :(using PowerNetworkDiagrams); recursive=true)

makedocs(;
    modules=[PowerNetworkDiagrams],
    authors="tom philpott <tsp266@uowmail.edu.au> and contributors",
    sitename="PowerNetworkDiagrams.jl",
    format=Documenter.HTML(;
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
