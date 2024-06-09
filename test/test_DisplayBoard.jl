include("../src/catan/CatanBoard.jl")
using .CatanBoard

task = display!(Board2P())
fetch(task)
