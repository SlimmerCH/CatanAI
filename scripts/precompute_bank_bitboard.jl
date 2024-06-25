include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

bank = CatanBoard.Bank()
for i in 1:5
    set_resource(bank, i, 19)
end
set_card(bank, 1, 14)
set_card(bank, 2, 2)
set_card(bank, 3, 2)
set_card(bank, 4, 2)
set_card(bank, 5, 5)

@show bank.bitboard |> bitstring
@show bank.bitboard
