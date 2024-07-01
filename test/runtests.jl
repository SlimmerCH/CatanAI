using Test

include("../src/catan/board/CatanBoard.jl")
using .CatanBoard

@testset verbose = true "Tests" begin
    include("test_BoardGereation.jl")
    include("test_BitOperations.jl")
    include("test_BoardOperations.jl")
end