using Test

include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

@testset "Board Generation" begin
    for i in 1:20 @test CatanBoard.random_starting_index() ∈ [1,3,5,7,9,11] end
    @test CatanBoard.out_to_inner_ring(1) == 1
    @test CatanBoard.CatanBoard.out_to_inner_ring(3) == 2
    @test CatanBoard.out_to_inner_ring(5) == 3
    @test CatanBoard.out_to_inner_ring(7) == 4
    @test CatanBoard.out_to_inner_ring(9) == 5
    @test CatanBoard.out_to_inner_ring(11) == 6
    @test sum(CatanBoard.outer_ring_order) + sum(CatanBoard.inner_ring_order) + sum(CatanBoard.center) == sum(1:19)
    @test sum(CatanBoard.generate_tile_to_resource_lookup()) == sum([0,1,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5])
    @test length(CatanBoard.generate_tile_to_resource_lookup()) == 19
    @test sum(CatanBoard.generate_tile_to_number_lookup(CatanBoard.generate_tile_to_resource_lookup())) == sum([5,2,6,3,8,10,9,12,11,4,8,10,9,4,5,6,3,11])
    @test Board2P() isa Board2P

    ranboard = rand(Board2P)
    flip_player_turn(ranboard.dynamic)
    @test 0b0 == ranboard.dynamic.p1.settlement_bitboard & ranboard.dynamic.p1.city_bitboard & ranboard.dynamic.p2.settlement_bitboard & ranboard.dynamic.p2.city_bitboard
end