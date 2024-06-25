include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

task = display!(rand(Board2P))
sleep(20)
