include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

showRandom = false


if !showRandom
    board = Board2P()
else
    board = rand(Board2P)
end

increase_cards(board.dynamic.p1, 6, 2)
increase_cards(board.dynamic.p1, 7, 2)
increase_cards(board.dynamic.p1, 8, 2)
increase_cards(board.dynamic.p1, 9, 2)

task = display!(board)

sleep(2000)
