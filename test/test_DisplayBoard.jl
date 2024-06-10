include("../src/catan/CatanBoard.jl")
using .CatanBoard

task = display!(rand(Board2P))
sleep(4)
