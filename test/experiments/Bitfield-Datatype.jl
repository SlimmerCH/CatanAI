# This script compares the memory usage of different data types for a catan board's city/settlement bitboard

using Base: summarysize
using Random: rand

function get_size(T::Type)
    return T |> rand |> summarysize
end

matrix_approach = rand(Int8, 54) |> summarysize # 54 nodes for buildings
uint_approach = 4 * get_size(UInt64) # 4 UInt64 fields for the cities-P1, cities-P2, settlements-P1, settlements-P2
bitarray_approach = BitArray(rand(Bool, 54, 3)) |> summarysize # 54 nodes, 5 possoble states = 3 bits

println("Size of City/Settlement Bitboard:")
println("Matrix approach: $matrix_approach Bytes")
println("UInt64 approach: $uint_approach Bytes")
println("BitArray approach: $bitarray_approach Bytes")

# UInt approach is the most memory-efficient for small Bitboards
# This is because BitArrays come with a lot of overhead