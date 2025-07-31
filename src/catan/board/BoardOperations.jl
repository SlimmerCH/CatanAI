# Multiple dispatch goes brrrrrrrrrrrrrrrrrrrrrrr

include("BitOperations.jl")
include("BoardGraph.jl")

const starting_index::NTuple{5, Int8} = (
    73,     # resources and cards   |   road_bitboard
    55,     # first free road           |   settlement_bitboard
    56,      # initial_phase_ended   |   settlement_bitboard
    57,       # force_road          |   settlement_bitboard
    58      # devcard ready to play (58 - 61)   |   settlement_bitboard
)

const max_card_supplies::NTuple{10, Int8} = (
    15, # wood
    15, # brick
    15, # sheep
    15, # wheat
    15, # ore
    14, # knight_cards
    2,  # road_cards
    2,  # monopoly_cards
    2,  # plenty_cards
    5   # point_cards
)

function bit_usage(max_values::Integer)
    return ceil(log2(max_values+1))
end

const card_bit_usages::NTuple{10, Int8} = map(bit_usage, max_card_supplies)

const card_entry_offsets::NTuple{10, Int8} = Tuple([sum(map(bit_usage, [0, max_card_supplies...])[1:(i)]) for i in 1:length(max_card_supplies)])

const building_bitboard_mask::UInt64 = 
0b00000000111111111111111111111111111111111111111111111111111111

const road_bitboard_mask::UInt128 = 
0b00000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111

if building_bitboard_mask |> count_ones != 54
    throw(ArgumentError("Invalid building bitboard mask"))
end
if road_bitboard_mask |> count_ones != 72
    throw(ArgumentError("Invalid road bitboard mask"))
end

# resource ids
# 0 - desert
# 1 - wood
# 2 - brick
# 3 - sheep
# 4 - wheat
# 5 - ore

function get_trade_offer(player::PlayerStats, source_resource::Integer)
    if source_resource < 1 || source_resource > 5
        throw(ArgumentError("Invalid resource ID: $(source_resource)"))
    end
    @show has_port(player, source_resource), has_port(player, 6)
    if has_port(player, source_resource)
        return 2;
    elseif has_port(player, 6) # generic port
        return 3;
    else
        return 4;
    end
end

function can_afford_trade(player::PlayerStats, source_resource::Integer)
    if source_resource < 1 || source_resource > 5
        throw(ArgumentError("Invalid resource ID: $(source_resource)"))
    end

    amount = get_trade_offer(player, source_resource)
    return can_afford(player, source_resource, amount)

end

function get_port_of_building(building_index::Integer)::Int8
    if building_index < 1 || building_index > 54
        throw(ArgumentError("Invalid building index: $(building_index)"))
    end
    adjacency::NTuple{54, Int8} = node_to_port   # from BoardGraph.jl
    return adjacency[building_index]
end

function is_tile_occupied_by(player::PlayerStats, tile_id::Int8)::Bool
    adjacency::NTuple{19, NTuple{6, Int8}} = tile_to_node   # from BoardGraph.jl
    neighbors::NTuple{6, Int8} = adjacency[tile_id]
    for neighbor::Int8 in neighbors
        if check_bit(player.settlement_bitboard, neighbor)
            return true
        end
        if check_bit(player.city_bitboard, neighbor)
            return true
        end
    end
    return false
end

function unready_all_devcards(player::PlayerStats)
    for i::Int8 in 6:9
        player.settlement_bitboard = clear_bit(player.settlement_bitboard, starting_index[5] + i - 6)
    end
end

function is_first_free_road_built(player::PlayerStats)::Bool
    return check_bit(player.settlement_bitboard, starting_index[2])
end

function set_first_free_road_built(player::PlayerStats)
    player.settlement_bitboard = set_bit(player.settlement_bitboard, starting_index[2])
end

function clear_first_free_road_built(player::PlayerStats)
    player.settlement_bitboard = clear_bit(player.settlement_bitboard, starting_index[2])
end

function is_devcard_ready(player::PlayerStats, card_id::Integer)::Bool
    if card_id < 6 || card_id > 9
        throw(ArgumentError("Invalid card ID: $(card_id)"))
    end
    return check_bit(player.settlement_bitboard, starting_index[5]+ card_id - 6)
end

function set_devcard_ready(player::PlayerStats, card_id::Integer)
    if card_id < 6 || card_id > 9
        throw(ArgumentError("Invalid card ID: $(card_id)"))
    end
    player.settlement_bitboard = set_bit(player.settlement_bitboard, starting_index[5]+ card_id - 6)
end

function get_robber_position(bank::Bank)::Int8
    return read_binary_range(bank.bitboard, 15, 19)
end

function set_robber_position(bank::Bank, tile_id::Integer)
    if tile_id < 0 || tile_id > 19 # we allow 0 for pending placement after a knight card
        throw(ArgumentError("Invalid tile ID: $(tile_id)"))
    end
    bank.bitboard = write_binary_range(bank.bitboard, 15, 19, tile_id)
end

function reset_robber_position(static::StaticBoard, dynamic::DynamicBoard2P)
    for i in 1:19
        if static.tile_to_resource[i] == 0 # desert
            set_robber_position(dynamic.bank, i)
            return
        end
    end
    throw("No desert tile found to reset robber position.")
end

function is_second_free_road(player::PlayerStats)::Bool
    return check_bit(player.settlement_bitboard, starting_index[2])
end

function set_second_free_road(player::PlayerStats)
    player.settlement_bitboard = set_bit(player.settlement_bitboard, starting_index[2])
end

function is_road_forced(player::PlayerStats)::Bool # in the initial phase after the settlement
    return check_bit(player.settlement_bitboard, starting_index[4])
end

function force_road(player::PlayerStats)
    player.settlement_bitboard = set_bit(player.settlement_bitboard, starting_index[4])
end

function clear_force_road(player::PlayerStats)
    player.settlement_bitboard = clear_bit(player.settlement_bitboard, starting_index[4])
end

function building_has_road(player::PlayerStats, building_index::UInt8)::Bool
    if building_index < 1 || building_index > 54
        throw(ArgumentError("Invalid building index: $(building_index)"))
    end
    adjacency::NTuple{54, NTuple{3, Int8}} = node_to_edge   # from BoardGraph.jl
    neighbors::NTuple{3, Int8} = adjacency[building_index]

    return (
        player.road_bitboard(neighbors[1]) ||
        player.road_bitboard(neighbors[2]) ||
        (neighbors[3] != 0 && player.road_bitboard(neighbors[3]))
    )
end

function get_settlement_of_road(player::PlayerStats, road_index::UInt8)::UInt8
    if road_index < 1 || road_index > 72
        throw(ArgumentError("Invalid road index: $(road_index)"))
    end
    adjacency::NTuple{72, NTuple{2, Int8}} = edge_to_node
    neighbors::NTuple{2, Int8} = adjacency[road_index]
    if player.settlement_bitboard(neighbors[1])
        return neighbors[1]
    elseif player.settlement_bitboard(neighbors[2])
        return neighbors[2]
    else
        return 0 # No building at this road
    end
end


function get_player_turn(dynamicboard::DynamicBoard2P)::Bool
    return dynamicboard.bank.bitboard(14)
end

function flip_player_turn(dynamicboard::DynamicBoard2P)
    dynamicboard.bank.bitboard = flip_bit(dynamicboard.bank.bitboard, 14)
end

function get_next_player(dynamicboard::DynamicBoard2P)::PlayerStats
    if get_player_turn(dynamicboard)
        return dynamicboard.p2
    else
        return dynamicboard.p1
    end
end

function get_other_player(dynamicboard::DynamicBoard2P)::PlayerStats
    if get_player_turn(dynamicboard)
        return dynamicboard.p1
    else
        return dynamicboard.p2
    end
end

function get_card_amount(player::PlayerStats, card_id::Integer)::Int8
    index::Int8 = starting_index[1] + card_entry_offsets[card_id]
    return read_binary_range(
        player.road_bitboard,
        index,
        index + card_bit_usages[card_id] - 1
    )
end

function get_card_amount(bank::Bank, card_id::Integer)::Int8
    if card_id < 6 || card_id > 10
        throw(ArgumentError("Invalid card ID: $(card_id)"))
    end
    index::Int8 = 1 + card_entry_offsets[card_id] - card_entry_offsets[6]
    return read_binary_range(
        bank.bitboard,
        index,
        index + card_bit_usages[card_id] - 1
    )
end


function set_card_amount(player::PlayerStats, card_id::Integer, value::Integer)
    index::Int8 = starting_index[1] + card_entry_offsets[card_id]
    player.road_bitboard = write_binary_range(
        player.road_bitboard,
        index,
        index + card_bit_usages[card_id] - 1,
        value
    )
end

function set_card_amount(bank::Bank, card_id::Integer, value::Integer)
    if card_id < 6 || card_id > 10
        throw(ArgumentError("Invalid card ID: $(card_id)"))
    end
    index::Int8 = 1 + card_entry_offsets[card_id] - card_entry_offsets[6]
    bank.bitboard = write_binary_range(
        bank.bitboard,
        index,
        index + card_bit_usages[card_id] - 1,
        value
    )
end

function increase_cards(player::PlayerStats, resource_type::Integer, value::Integer)
    sum::Int16 = get_card_amount(player, resource_type) + value
    result::Int8 = sum >= Int16(15) ? 15 : sum # prevent overflow
    return set_card_amount(player, resource_type, result)
end

function increase_cards(bank::Bank, resource_type::Integer, value::Integer)
    sum::Int16 = get_card_amount(bank, resource_type) + value
    result::Int8 = sum >= Int16(15) ? 15 : sum # prevent overflow
    return set_card_amount(bank, resource_type, result)
end

function can_afford(player::PlayerStats, resource_id::Integer, value::Integer)::Bool
    return get_card_amount(player, resource_id) >= value
end

function buy(player::PlayerStats, purchase_id::Integer)
    if !initial_phase_ended(player)
        return # no resources to spend in the initial phase
    end
    if purchase_id == 1 # road
        increase_cards(player, 1, -1) # wood
        increase_cards(player, 2, -1) # brick
    elseif purchase_id == 2 # settlement
        increase_cards(player, 1, -1) # wood
        increase_cards(player, 2, -1) # brick
        increase_cards(player, 3, -1) # sheep
        increase_cards(player, 4, -1) # wheat
    elseif purchase_id == 3 # city
        increase_cards(player, 4, -2) # wheat
        increase_cards(player, 5, -3) # ore
    elseif purchase_id == 4 # development_card
        increase_cards(player, 3, -1) # sheep
        increase_cards(player, 4, -1) # wheat
        increase_cards(player, 5, -1) # ore
    else
        throw(ArgumentError("Invalid purchase ID"))
    end
end

function can_afford(player::PlayerStats, purchaseID::Integer)::Bool
    # 1 - road
    # 2 - settlement
    # 3 - city
    # 4 - developement_card
    
    if purchaseID == 1 # road
        return (
            can_afford(player, 1, 1) &&
            can_afford(player, 2, 1) # wood and brick
        )
    elseif purchaseID == 2 # settlement
        return (
            can_afford(player, 1, 1) &&
            can_afford(player, 2, 1) &&
            can_afford(player, 3, 1) &&
            can_afford(player, 4, 1) # wood, brick, sheep and wheat
        )
    elseif purchaseID == 3 # city
        return (
            can_afford(player, 4, 2) &&
            can_afford(player, 5, 3) # wheat and ore
        )
    elseif purchaseID == 4 # developement_card
        return (
            can_afford(player, 3, 1) &&
            can_afford(player, 4, 1) &&
            can_afford(player, 5, 1) # sheep, wheat and ore
        )
    else
        throw(ArgumentError("Invalid purchase ID"))
    end
end

function get_building(player::PlayerStats, index::Integer)::Int8
    if player.city_bitboard(index)
        return 2
    elseif player.settlement_bitboard(index)
        return 1
    else
        return 0
    end
end

function get_building(bitBoard::UInt64, index::Integer)::Int8
    return bitBoard(index)
end

function set_building(player::PlayerStats, index::Integer, value::Integer)
    if value == 2
        player.city_bitboard = set_bit(player.city_bitboard, index)
        player.settlement_bitboard = clear_bit(player.settlement_bitboard, index)
    elseif value == 1
        player.settlement_bitboard = set_bit(player.settlement_bitboard, index)
    else
        throw(ArgumentError("Invalid building type"))
    end
end

function is_buildable(globalBitboard::UInt64, index::Integer)::Bool
    if (globalBitboard(index) != 0)
        return false
    end
    adjacency::NTuple{54, NTuple{3, Int8}} = building_adjacency
    neighbors::NTuple{3, Int8} = adjacency[index];
    
    if (globalBitboard(neighbors[1])+globalBitboard(neighbors[2]) == 0 &&
        ((neighbors[3] == 0) || globalBitboard(neighbors[3]) == 0 ))
        return true
    end
    return false
end

function is_buildable(dynamicboard::DynamicBoard2P, index::Integer)::Bool
    globalBitboard::UInt64 =
        dynamicboard.p1.settlement_bitboard |
        dynamicboard.p1.city_bitboard |
        dynamicboard.p2.settlement_bitboard |
        dynamicboard.p2.city_bitboard
    
    return is_buildable(globalBitboard, index)
end

function has_road_neighbor(player::PlayerStats, index::Integer)::Bool
    if index < 1 || index > 72
        throw(ArgumentError("Invalid road index: $(index)"))
    end
    adjacency::NTuple{72, NTuple{4, Int8}} = road_adjacency # from BoardGraph.jl
    neighbors::NTuple{4, Int8} = adjacency[index];
    
    if (
        player.road_bitboard(neighbors[1]) == 0 &&
        player.road_bitboard(neighbors[2]) == 0 &&
        ((neighbors[3] == 0) || player.road_bitboard(neighbors[3]) == 0 ) &&
        ((neighbors[4] == 0) || player.road_bitboard(neighbors[4]) == 0 )
    )
        return false
    end
    return true
end

function road_has_settlement(player::PlayerStats, road_index::UInt8)::Bool
    adjacency::NTuple{72, NTuple{2, Int8}} = edge_to_node
    neighbors::NTuple{2, Int8} = adjacency[road_index]
    return (
        player.settlement_bitboard(neighbors[1]) ||
        player.settlement_bitboard(neighbors[2])
    )
end

function is_road(dynamic::DynamicBoard2P, index::Integer)::Bool
    return (
        dynamic.p1.road_bitboard(index) ||
        dynamic.p2.road_bitboard(index)
    )
end

function is_road(player::PlayerStats, index::Integer)::Bool
    return player.road_bitboard(index)
end

function set_road(player::PlayerStats, index::Integer)
    player.road_bitboard = set_bit(player.road_bitboard, index)
end

function acquire_port(player::PlayerStats, resource::Integer)
    player.city_bitboard = set_bit(player.city_bitboard, 54 + resource)
end

function has_port(player::PlayerStats, resource::Integer)::Bool
    return check_bit(player.city_bitboard, 54 + resource)
end

function count_settlements(player::PlayerStats)::Int8
    return count_ones(player.settlement_bitboard & building_bitboard_mask)
end

function count_cities(player::PlayerStats)::Int8
    return count_ones(player.city_bitboard & building_bitboard_mask)
end

function count_roads(player::PlayerStats)::Int8
    return count_ones(player.road_bitboard & road_bitboard_mask)
end

function initial_phase_ended(player::PlayerStats)::Bool
    return check_bit(player.settlement_bitboard, starting_index[3])
end

function end_initial_phase(player::PlayerStats)
    player.settlement_bitboard = set_bit(player.settlement_bitboard, starting_index[3])
end

function devcard_distribution(bank::Bank)::Vector{Float16}
    card_stock::Vector{Float16} = [
        get_card_amount(bank, 6),
        get_card_amount(bank, 7),
        get_card_amount(bank, 8),
        get_card_amount(bank, 9),
        get_card_amount(bank, 10)
    ]

    total_stock::Int8 = sum(card_stock)

    for i::Int8 in 1:5
        card_stock[i] = card_stock[i] / total_stock # normalize the stock
    end
    return card_stock
end

function resource_distribution(player::PlayerStats)::Vector{Float16}
    resource_stock::Vector{Float16} = [
        get_card_amount(player, 1),
        get_card_amount(player, 2),
        get_card_amount(player, 3),
        get_card_amount(player, 4),
        get_card_amount(player, 5)
    ]

    total_stock::Int8 = sum(resource_stock)

    if total_stock == 0
        @warn "Player has no resources."
        return Float16[]
    end

    for i::Int8 in 1:5
        resource_stock[i] = resource_stock[i] / total_stock # normalize the stock
    end

    return resource_stock

end