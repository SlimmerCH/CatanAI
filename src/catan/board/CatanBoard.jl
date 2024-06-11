module CatanBoard

    export Board2P, DynamicBoard2P, display!, rand

    include("Board2P.jl")
    include("BitOperations.jl")
    include("BoardGeneration.jl")
    include("../../gui/DisplayBoard.jl")
    
end

