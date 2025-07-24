include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

showFull = false


if showFull
    board = fullBoard()
else
    board = rand(Board2P)
end

task = display!(board)

sleep(2000)
