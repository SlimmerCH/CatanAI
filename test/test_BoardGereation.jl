using Test

@testset "Board Generation" begin
    tile_to_resource = CatanBoard.generate_tile_to_resource_lookup()
    tile_to_number = CatanBoard.generate_tile_to_number_lookup(tile_to_resource)
    number_to_tile = CatanBoard.generate_number_to_tile_lookup(tile_to_resource)

    for i in 1:20 @test CatanBoard.random_starting_index() ∈ [1,3,5,7,9,11] end
    @test CatanBoard.out_to_inner_ring(1) == 1
    @test CatanBoard.CatanBoard.out_to_inner_ring(3) == 2
    @test CatanBoard.out_to_inner_ring(5) == 3
    @test CatanBoard.out_to_inner_ring(7) == 4
    @test CatanBoard.out_to_inner_ring(9) == 5
    @test CatanBoard.out_to_inner_ring(11) == 6
    @test sum(CatanBoard.outer_ring_order) + sum(CatanBoard.inner_ring_order) + sum(CatanBoard.center) == sum(1:19)
    @test sum(tile_to_resource) == sum([0,1,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5])
    @test length(tile_to_resource) == 19
    @test sum(tile_to_number) == sum([5,2,6,3,8,10,9,12,11,4,8,10,9,4,5,6,3,11])
    @test sum([number_to_tile[i] |> sum for i in 1:12]) + findfirst(tile_to_resource .== 0) == sum(1:19)

    @test Board2P() isa Board2P

    ranboard = rand(Board2P)
    flip_player_turn(ranboard.dynamic)
    @test 0b0 == ranboard.dynamic.p1.settlement_bitboard & ranboard.dynamic.p1.city_bitboard & ranboard.dynamic.p2.settlement_bitboard & ranboard.dynamic.p2.city_bitboard
end