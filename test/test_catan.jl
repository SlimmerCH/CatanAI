include("../src/catan/CatanBoard.jl")
include("../src/catan/BoardStructure.jl")
using Test
using .CatanBoard

@testset "Bit Operations" begin
    @test CatanBoard.set_bit(0b01011, 0) == 0b01011
    @test CatanBoard.set_bit(0b11010, 2) == 0b11110
    @test CatanBoard.clear_bit(0b01011, 0) == 0b01010
    @test CatanBoard.clear_bit(0b11010, 2) == 0b11010
    @test CatanBoard.check_bit(0b01011, 0) == 1
    @test CatanBoard.check_bit(0b11010, 2) == 0
    @test CatanBoard.set_bit(UInt8(0b01011), 0) |> typeof == UInt8
    @test CatanBoard.set_bit(UInt16(0b01011), 0) |> typeof == UInt16
end

@testset "Game Board" begin
    for i in 1:20 @test random_starting_index() ∈ [1,3,5,7,9,11] end
    @test out_to_inner_ring(1) == 1
    @test out_to_inner_ring(3) == 2
    @test out_to_inner_ring(5) == 3
    @test out_to_inner_ring(7) == 4
    @test out_to_inner_ring(9) == 5
    @test out_to_inner_ring(11) == 6
    @test sum(outer_ring_order) + sum(inner_ring_order) + center == sum(1:19)
    @test sum(generate_tile_to_resource_lookup()) == sum([0,1,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5])
    @test length(generate_tile_to_resource_lookup()) == 19
    @test sum(generate_tile_to_number_lookup(generate_tile_to_resource_lookup())) == sum([5,2,6,3,8,10,9,12,11,4,8,10,9,4,5,6,3,11])
end
