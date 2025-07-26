struct Move
    
    # AA0YY YXXX trade amount (A) of resource type (X) with the bank for 1 resource of type (Y) 
    trade::Vector{UInt8} #

    # (0XXX XXXX) road with id X
    # (10XX XXXX) building with id X
    # (1100 0000) development card
    buy::Vector{UInt8}

    # (0001 XXXX) knight card with tile id X
    # (0010 0XXX) monopoly card with resource id X
    # (01YY YXXX) plenty card with resource ids X and Y
    # (1000 0000) the first two items in "buy" are roads and are free.
    play::UInt8

    function Move(trade::Vector{UInt8} = UInt8[], buy::Vector{UInt8} = UInt8[], play::UInt8 = UInt8(0))
        new(trade, buy, play)
    end
end

function upgrade_building(player::PlayerStats, index::UInt8)
    println("Upgrading building at index: $(index)")
    # build a settlement
    if get_building(player, index) == 0
        set_building(player, index, 1) # 1 for settlement
        buy(player, 2) # spend resource for settlement
    elseif get_building(player, index) == 1
        set_building(player, index, 2) # 2 for city
        buy(player, 3) # spend resource for city
    else
        error("Cannot upgrade building at index $(index): No settlement found.")
    end
end

function devcard_distribution(bank::Bank)::NTuple{5, Int8}
    buy(player, 4) # spend resources for development card
    card_stock::Vector{Int8} = [
        get_card_amount(bank, 6),
        get_card_amount(bank, 7),
        get_card_amount(bank, 8),
        get_card_amount(bank, 9),
        get_card_amount(bank, 10)
    ]

    total_stock::Int8 = sum(card_stock)

    for i::Int8 in 1:5
    end

end

function random_dice()::Int8
    # Randomly generate a number between 2 and 12 (inclusive)
    # Simulate rolling two dice
    die1 = rand(1:6)
    die2 = rand(1:6)
    println("Rolled sum of dice: $(die1 + die2)")
    return die1 + die2
end

function roll_dice(num::Int8, static::StaticBoard, dynamic::DynamicBoard2P)
    if num == 7
        println("Rolled a 7, activating robber.")
        # Handle robber logic here
        return
    end

    adjacency::NTuple{19, NTuple{6, Int8}} = tile_to_node

    tile1 = static.number_to_tile[num][1]
    tile2 = static.number_to_tile[num][2]

    for building_index in adjacency[tile1]
        resource_type = static.tile_to_resource[tile1]
        if get_building(dynamic.p1, building_index) == 1
            increase_cards(dynamic.p1, resource_type, 1)
        elseif get_building(dynamic.p2, building_index) == 1
            increase_cards(dynamic.p1, resource_type, 1)
        elseif get_building(dynamic.p1, building_index) == 2
            increase_cards(dynamic.p1, resource_type, 2)
        elseif get_building(dynamic.p2, building_index) == 2
            increase_cards(dynamic.p2, resource_type, 2)
        end
    end

    if tile2 == 0
        return # no resources to distribute
    end
    for building_index in adjacency[tile2]
        resource_type = static.tile_to_resource[tile2]
        if get_building(dynamic.p1, building_index) == 1
            increase_cards(dynamic.p1, resource_type, 1)
        elseif get_building(dynamic.p2, building_index) == 1
            increase_cards(dynamic.p2, resource_type, 1)
        elseif get_building(dynamic.p1, building_index) == 2
            increase_cards(dynamic.p1, resource_type, 2)
        elseif get_building(dynamic.p2, building_index) == 2
            increase_cards(dynamic.p2, resource_type, 2)
        end
    end
end

function commit(board::Board2P, move::Move, force_end::Bool = false)
    # we assume that the move is valid
    println("Committing move.")

    last_road::UInt8 = 0b0

    player = get_next_player(board.dynamic)
    for purchase::UInt8 in move.buy

        if (purchase & 0b10000000) == 0b00000000 # road
            buy(player, 1) # spend resource for road
            last_road = purchase & 0b01111111
            set_road(player, last_road) # road index
            clear_force_road(player) # clear forced road after building
            continue
        end

        if (purchase & 0b11000000) == 0b10000000 # building
            upgrade_building(player, purchase & 0b00111111) # 1 for settlement
            if !initial_phase_ended(player)
                force_road(player) # force road after settlement
            end
            continue
        end

        if (purchase & 0b11000000) == 0b11000000 # development card
            buy(player, 4) # spend resource for development card
            buy_development_card(player)
            continue
        end

        error("Unknown purchase type: $(purchase)")
    end


    if (force_end)
        if !initial_phase_ended(player) && count_settlements(player) == 2
            end_initial_phase(player) # end initial phase
            adjacency::NTuple{54, Vector{Int8}} = node_to_tile
            for tile::Int8 in adjacency[get_settlement_of_road(player, last_road)]
                resource::Int8 = board.static.tile_to_resource[tile]
                if resource == 0
                    continue # skip desert
                end
                increase_cards(player, resource, 1)
            end

        end
        flip_player_turn(board.dynamic)        
    end
end

function validate(board::Board2P, move::Move)::Bool
    
    # Check if the move is valid

    ##### FOR NOW, THIS WORKS ONLY WITH SINGLE ACTIONS MOVES. NOT WITH MULTIPLE ACTIONS #####

    # This function should implement the game rules to validate the move
    
    player = get_next_player(board.dynamic)

    if isempty(move.buy) && !initial_phase_ended(player)
        @warn "Must place a structure: Player $(player)"
        return false # Initial phase must be ended before forcing
    end

    # @show initial_phase_ended(player)
    # @show is_road_forced(player)

    for purchase::UInt8 in move.buy

        if (purchase & 0b10000000) == 0b00000000 # road
            purchase_type::UInt8 = 1
            building_index = purchase & 0b01111111 # road index
        elseif (purchase & 0b11000000) == 0b10000000 # building
            building_index = purchase & 0b00111111 # building index
            if get_building(player, building_index) == 0
                purchase_type = 2 # settlement
            elseif get_building(player, building_index) == 1
                purchase_type = 3 # city
            else
                @warn "Invalid building foundation: $(building_index)"
                return false
            end
        elseif (purchase & 0b11000000) == 0b11000000 # development card
            purchase_type = 4
        end

        if !can_afford(player, purchase_type) && initial_phase_ended(player)
            @warn "Player cannot afford the purchase type: $(purchase_type)"
            return false # Player cannot afford the purchase
        end

        if purchase_type == 1 # road
            if initial_phase_ended(player) && !is_roadable(board.dynamic, player, building_index)
                @warn "Road cannot be built at index: $(building_index)"
                return false # Invalid road placement
            end

            if !initial_phase_ended(player)
                if !is_road_forced(player)
                    @warn "Settlement must be built instead of road: $(building_index)"
                    return false # Road is not forced
                end
                if !road_has_settlement(player, building_index)
                    @warn "Road must be built next to settlement: $(building_index)"
                    return false # Road is forced
                end

                settlement_index = get_settlement_of_road(player, building_index)

                if building_has_road(player, settlement_index)
                    @warn "This settlement already has a road: $(building_index)"
                    return false # Road already exists
                end
                
            end

        elseif purchase_type == 2 # settlement
            if !is_buildable(board.dynamic, building_index)
                @warn "Settlement needs more distance to other buildings: $(building_index)"
                return false # Invalid settlement placement
            end

            if is_road_forced(player)
                @warn "Road must be built: $(building_index)"
                return false # Settlement is forced
            end

            if initial_phase_ended(player) && !building_has_road(player, building_index)
                @warn "Settlement must be built next to a road: $(building_index)"
                return false # Settlement must be next to a road
            end

        elseif purchase_type == 3 # city
            if get_building(player, building_index) != 1
                @warn "City can only be built on a settlement: $(building_index)"
                return false # City can only be built on a settlement
            end

            if !initial_phase_ended(player)
                @warn "Settlements and roads must be built instead of a city: $(building_index)"
                return false # City is not forced
            end

        elseif purchase_type == 4 # development card
        else
            error("Unknown building type: $(building_type)")
        end

    end

    return true
end

function buy_development_card(player::PlayerStats)

end

function get_knight_moves(d::DynamicBoard2P)::Array{KnightMove}
    # knight cards can be played before rolling the dice
end

function get_moves(d::DynamicBoard2P, initial_phase = false)::Array{Move}
    if (initial_phase)
        return get_staring_moves(d)
    end
    # the actions will be played in the following order:
    # 1. trade
    # 2. play development cards
    # 3. buy stuff

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