module CatanBoard

    export Board2P, DynamicBoard2P, display!

    include("Board2P.jl")
    include("BoardStructure.jl")
    include("../gui/DisplayBoard.jl")
    include("BitOperations.jl")
end

