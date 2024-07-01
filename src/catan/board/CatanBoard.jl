module CatanBoard

    export Board2P, DynamicBoard2P, display!, rand
    export get_player_turn, flip_player_turn
    export get_resource, set_resource, add_resource
    export can_afford, get_card, set_card, add_card
    export get_building, set_building, is_road, set_road
    export activate_port, get_port

    include("Board2P.jl")
    include("RandomBoard.jl")
    include("BoardOperations.jl")
    include("BoardGeneration.jl")
    include("../../gui/DisplayBoard.jl")

    Board2P()
end