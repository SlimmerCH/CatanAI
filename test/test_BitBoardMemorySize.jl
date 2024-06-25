include("../src/catan/board/CatanBoard.jl")
using .CatanBoard: Board2P
using Base: summarysize
size = Board2P().dynamic |> summarysize # The dynamic component must utilize memory efficiently to ensure the tree search operates smoothly.
println("Size of Board2P dynamic component: $size Bytes")