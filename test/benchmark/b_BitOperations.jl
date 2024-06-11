include("../../src/catan/board/BitOperations.jl")

using BenchmarkTools
using Random: Random

function flip(n::Unsigned)
    for i::Int32 in 1:1000000001
        n = flip_bit(n, 1)
    end
    return n
end

n = rand(UInt32)
@show n |> bitstring
@show flip(n) |> bitstring

r = @benchmark flip($n)
println(r)