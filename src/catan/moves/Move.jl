struct Move
    trade::Vector{} # 
    buy::Vector{UInt8} # (YYXXXXXX) X for node/vertex id, Y for type (road, settlement, city or developement card)
    play_developement::Vector{UInt8} # (00YYYXXX) X and Y are resource ids
    play_road::Vector{UInt8} # edge ids

    function Move(trade::Vector{} = [], buy::Vector{UInt8} = UInt8[], play_developement::Vector{UInt8} = UInt8[], play_road::Vector{UInt8} = UInt8[])
        new(trade, buy, play_developement, play_road)
    end
end

struct KnightMove
    tile_id::Int8 # tile id
    player_id::Int8 # player id
end

function commit(board::Board2P, move::Move)
    # we assume that the move is valid
    println("Committing move: ", move)

    player = get_next_player(board.dynamic)
    for building::UInt8 in move.buy
        building_type::UInt8 = building & 0b11000000
        building_index::UInt8 = building & 0b00111111

        @show building_type, building_index

        if building_type == 0b00000000 # road
            set_road(player, building_index)
        elseif building_type == 0b01000000 # settlement
            set_building(player, building_index, 1) # 1 for settlement
        elseif building_type == 0b10000000 # city
            set_building(player, building_index, 2) # 2 for city
        elseif building_type == 0b11000000 # development card
            buy_development_card(player)
        else
            error("Unknown building type: $(building_type)")
        end
    end
end

function validate(board::Board2P, move::Move)::Bool
    # Check if the move is valid
    # This function should implement the game rules to validate the move
    
    player = get_next_player(board.dynamic)
    for building::UInt8 in move.buy
        building_type::UInt8 = building & 0b11000000
        building_index::UInt8 = building & 0b00111111

        @show building_type, building_index

        if !can_afford(player, building_type >> 6 + 1) && initial_phase_ended(player)
            @warn "Player cannot afford the building: $(building_type >> 6 + 1)"
            return false # Player cannot afford the building
        end

        if building_type == 0b00000000
            if !is_roadable(board.dynamic, player, building_index)
                @warn "Road cannot be built at index: $(building_index)"
                return false # Invalid road placement
            end
            if !initial_phase_ended(player) && !is_road_forced(player)
                @warn "Settlement must be built instead of road: $(building_index)"
                return false # Road is not forced
            end
        elseif building_type == 0b01000000 # settlement
            if !is_buildable(board.dynamic, building_index)
                @warn "Settlement needs more distance to other buildings: $(building_index)"
                return false # Invalid settlement placement
            end
            if get_building(player, building_index) != 0
                @warn "Building already exists at index: $(building_index)"
                return false # Settlement already exists
            end

            if is_road_forced(player)
                @warn "Road must be built: $(building_index)"
                return false # Settlement is forced
            end

        elseif building_type == 0b10000000 # city
            if get_building(player, building_index) != 1
                @warn "City can only be built on a settlement: $(building_index)"
                return false # City can only be built on a settlement
            end

            if !initial_phase_ended(player) && !is_road_forced(player)
                @warn "Settlements and roads must be built instead of a city: $(building_index)"
                return false # City is not forced
            end

        elseif building_type == 0b11000000 # development card
        else
            error("Unknown building type: $(building_type)")
        end
    end

    return true
end

function buy_development_card(player::PlayerStats)

end

function get_knight_moves(d::DynamicBoard2P)::Array{KnightMove}
    # knight cards will be played before rolling the dice
end

function get_moves(d::DynamicBoard2P, initial_phase = false)::Array{Move}
    if (initial_phase)
        return get_staring_moves(d)
    end
    # the actions will be played in the following order:
    # 1. play plenty
    # 2. play monopoly
    # 3. trade
    # 4. road
    # 5. play road
    # 6. building
    # 7. buy card
end

function get_staring_moves(d::DynamicBoard2P)::Array{Move}
    moves::Array{Move} = []
    node_to_edge::NTuple{54, NTuple{3, Int8}} = node_to_edge
    for i::UInt8 in 1:54
        if is_buildable(d, i)
            for j in 1:3
                road::Int8 = node_to_edge[i][j]
                if (road != 0)
                    push!(moves, Move([], [i], [road]))
                end
            end
        end
    end
end