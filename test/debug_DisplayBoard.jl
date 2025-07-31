include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

showRandom = false


if !showRandom
    board = Board2P()
else
    board = rand(Board2P)
end

increase_cards(board.dynamic.p1, 1, 2) # 2 wood
increase_cards(board.dynamic.p1, 2, 2) # 2 brick
increase_cards(board.dynamic.p1, 3, 2) # 2 sheep
increase_cards(board.dynamic.p1, 4, 2) # 2 wheat
increase_cards(board.dynamic.p1, 5, 2) # 2 ore
increase_cards(board.dynamic.p1, 6, 2) # 2 knight cards
increase_cards(board.dynamic.p1, 7, 2) # 2 road cards
increase_cards(board.dynamic.p1, 8, 2) # 2 monopoly cards
increase_cards(board.dynamic.p1, 9, 2) # 2 year of plenty cards

task = display!(board)

sleep(2000)
