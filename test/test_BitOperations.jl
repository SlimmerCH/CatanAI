using Test

include("../src/catan/board/BitOperations.jl")

@testset "Bit Operations" begin
    @test set_bit(0b01011, 1) == 0b01011
    @test set_bit(0b11010, 3) == 0b11110

    @test clear_bit(0b01011, 1) == 0b01010
    @test clear_bit(0b11010, 3) == 0b11010

    @test write_bit(0b01011, 1, true) == 0b01011
    @test write_bit(0b01011, 1, false) == 0b01010
    @test write_bit(0b11010, 3, true) == 0b11110
    @test write_bit(0b11010, 3, false) == 0b11010

    uint::UInt8 = 0b01011
    @test uint(1) == 1
    @test uint(2) == 1
    @test uint(3) == 0
    @test uint(4) == 1
    @test uint(5) == 0

    @test set_bit(UInt8(0b01011), 1) isa UInt8
    @test set_bit(UInt16(0b01011), 1) isa UInt16

    @test flip_bit(0b01011, 1) == 0b01010
    @test flip_bit(0b11010, 3) == 0b11110

    @test read_binary_range(0b01011, 1, 3) == 3
    @test read_binary_range(0b01011, 2, 4) == 5
    @test read_binary_range(0b01011, 1, 5) == 11

    @test write_binary_range(0b01011, 1, 3, 0b101) == 0b01101
    @test write_binary_range(0b01011, 3, 5, 0b101) == 0b10111
end