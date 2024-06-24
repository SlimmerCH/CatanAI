module CatanBoard

    export Board2P, DynamicBoard2P, display!, rand

    include("Board2P.jl")
    include("RandomBoard.jl")
    include("BoardOperations.jl")
    include("BoardGeneration.jl")
    include("../../gui/DisplayBoard.jl")

    Board2P()
end

