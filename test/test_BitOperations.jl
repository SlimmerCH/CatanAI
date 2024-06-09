using Test

include("../src/catan/BitOperations.jl")

@testset "Bit Operations" begin
    @test set_bit(0b01011, 1) == 0b01011
    @test set_bit(0b11010, 3) == 0b11110
    @test clear_bit(0b01011, 1) == 0b01010
    @test clear_bit(0b11010, 3) == 0b11010
    uint::UInt8 = 0b01011
    @test uint(1) == 1
    @test uint(2) == 1
    @test uint(3) == 0
    @test uint(4) == 1
    @test uint(5) == 0
    @test set_bit(UInt8(0b01011), 1) isa UInt8
    @test set_bit(UInt16(0b01011), 1) isa UInt16
end