module CatanBoard

    export Board2P, StaticBoard, DynamicBoard2P, Bank, display!, rand, fullBoard
    export Move, commit, validate
    export get_player_turn, flip_player_turn, get_next_player, get_other_player
    export is_road_forced, force_road, clear_force_road
    export get_card_amount, set_card_amount, increase_cards, buy
    export can_afford, get_card, set_card, add_card
    export get_building, set_building, is_buildable, is_road, set_road, has_road_neighbor, building_has_road, get_settlement_of_road
    export count_settlements, count_cities, count_roads
    export acquire_port, has_port, get_port_of_building, can_afford_trade, get_trade_offer
    export initial_phase_ended
    export roll_dice, random_dice
    export set_robber_position, get_robber_position, reset_robber_position
    export buy_random_devcard, steal_random_resource
    export is_first_free_road_built, set_first_free_road_built, clear_first_free_road_built
    export is_devcard_ready, set_devcard_ready

    include("Board2P.jl")
    include("RandomBoard.jl")
    include("BoardOperations.jl")
    include("BoardGeneration.jl")
    include("../../gui/DisplayBoard.jl")
    include("../moves/Move.jl") # <-- Ensure Move.jl is included

    Board2P()
end