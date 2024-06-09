using Test

@testset verbose = true "Tests" begin
    include("test_BoardGereation.jl")
    include("test_Bitoperations.jl")
end