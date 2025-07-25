include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

showRandom = false


if !showRandom
    board = Board2P()
else
    board = rand(Board2P)
end

task = display!(board)

sleep(2000)
