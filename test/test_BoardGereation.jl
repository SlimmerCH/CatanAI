using Test

include("../src/catan/board/CatanBoard.jl")
include("../src/catan/board/BoardGeneration.jl")
using .CatanBoard
using Base: summarysize

@testset "Board Generation" begin
    for i in 1:20 @test random_starting_index() ∈ [1,3,5,7,9,11] end
    @test out_to_inner_ring(1) == 1
    @test out_to_inner_ring(3) == 2
    @test out_to_inner_ring(5) == 3
    @test out_to_inner_ring(7) == 4
    @test out_to_inner_ring(9) == 5
    @test out_to_inner_ring(11) == 6
    @test sum(outer_ring_order) + sum(inner_ring_order) + sum(center) == sum(1:19)
    @test sum(generate_tile_to_resource_lookup()) == sum([0,1,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5])
    @test length(generate_tile_to_resource_lookup()) == 19
    @test sum(generate_tile_to_number_lookup(generate_tile_to_resource_lookup())) == sum([5,2,6,3,8,10,9,12,11,4,8,10,9,4,5,6,3,11])
    @test Board2P() isa Board2P

    ranboard = rand(Board2P)
    @test 0b0 == ranboard.dynamic.p1_bitboard.settlement_bitboard & ranboard.dynamic.p1_bitboard.city_bitboard & ranboard.dynamic.p2_bitboard.settlement_bitboard & ranboard.dynamic.p2_bitboard.city_bitboard
end

b = rand(Board2P)
@show CatanBoard.get_card_value(b.dynamic.p1_bitboard, Int8(1))