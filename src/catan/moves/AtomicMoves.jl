function upgrade_building(player::PlayerStats, port_lookup::NTuple{9, Int8}, index::UInt8)
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
    port::Int8 = get_port_of_building(index)
    if port != 0
        acquire_port(player, port_lookup[port]) # activate port if building is on a port
    end
end

function buy_random_devcard(player::PlayerStats, bank::Bank)
    distribution::Vector{Float16} = devcard_distribution(bank)
    for i::Int8 in 2:5
        distribution[i] += distribution[i - 1]
    end
    random_value = rand(Float16)
    for i::Int8 in 1:5
        if random_value <= distribution[i]
            i += 5 # convert to card id
            buy_devcard(player, bank, i)
            return
        end
    end
    @show distribution
    @show random_value
    throw("Error in picking a random developement card.")
end

function steal_random_resource(player::PlayerStats, target_player::PlayerStats)
    if player == target_player
        throw("Cannot steal from self.")
    end

    distribution::Vector{Float16} = resource_distribution(target_player)
    if isempty(distribution)
       return
    end

    for i in 2:5
        distribution[i] += distribution[i-1]
    end
    random_value = rand(Float16)

    for i in 1:5
        if random_value <= distribution[i]
            increase_cards(player, i, 1) # steal resource
            increase_cards(target_player, i, -1) # remove resource from target player
            return
        end
    end
    throw("Error in stealing a random resource.")
end

function buy_devcard(player::PlayerStats, bank::Bank, card_id::Integer)
    buy(player, 4) # spend resources for development card
    increase_cards(bank, card_id, -1)
    increase_cards(player, card_id, 1)
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
        set_robber_position(dynamic.bank, 0) # reset robber position
        return
    end

    adjacency::NTuple{19, NTuple{6, Int8}} = tile_to_node

    tile1 = static.number_to_tile[num][1]
    tile2 = static.number_to_tile[num][2]

    if get_robber_position(dynamic.bank) != tile1
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
    end

    if tile2 == 0 || get_robber_position(dynamic.bank) == tile2
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

function monopoly_steal(player::PlayerStats, target_player::PlayerStats, resource_id::Integer)
    if player == target_player
        throw("Cannot steal from self.")
    end
    if resource_id < 1 || resource_id > 5
        throw("Invalid resource ID for monopoly: $(resource_id)")
    end
    amount_to_steal::Int8 = get_card_amount(target_player, resource_id)
    set_card_amount(target_player, resource_id, 0) # remove all resources of that type
    increase_cards(player, resource_id, amount_to_steal) # add stolen resources to player
end