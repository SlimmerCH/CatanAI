# Multiple dispatch goes brrrrrrrrrrrrrrrrrrrrrrr

include("BitOperations.jl")
include("BoardGraph.jl")

const starting_index::NTuple{4, Int8} = (
    73,     # resources and cards   |   road_bitboard
    55,     # player turn           |   settlement_bitboard
    56,      # initial_phase_ended   |   settlement_bitboard
    57       # force_road          |   settlement_bitboard
)

const max_value::NTuple{6, Int8} = (
    19, # resources
    14, # knight_cards
    2,  # road_cards
    2,  # monopoly_cards
    2,  # plenty_cards
    5   # point_cards
)

const building_bitboard_mask::UInt64 = 
0b00000000111111111111111111111111111111111111111111111111111111
if building_bitboard_mask |> count_ones != 54
    throw(ArgumentError("Invalid building bitboard mask"))
end

# resource ids
# 0 - desert
# 1 - wood
# 2 - brick
# 3 - sheep
# 4 - wheat
# 5 - ore

function is_road_forced(player::PlayerStats)::Bool # in the initial phase after the settlement
    return check_bit(player.settlement_bitboard, starting_index[4])
end

function force_road(player::PlayerStats)
    player.settlement_bitboard = set_bit(player.settlement_bitboard, starting_index[4])
end

function clear_force_road(player::PlayerStats)
    player.settlement_bitboard = clear_bit(player.settlement_bitboard, starting_index[4])
end



function get_bit_usage(max_value::Integer)
    return ceil(log2(max_value+1))
end

const bit_usage::NTuple{6, Int8} = map(get_bit_usage, max_value)


function get_player_turn(dynamicboard::DynamicBoard2P)::Bool
    return dynamicboard.p1.settlement_bitboard(starting_index[2])
end

function flip_player_turn(dynamicboard::DynamicBoard2P)
    dynamicboard.p1.settlement_bitboard = flip_bit(dynamicboard.p1.settlement_bitboard, starting_index[2])
end

function get_next_player(dynamicboard::DynamicBoard2P)::PlayerStats
    if get_player_turn(dynamicboard)
        return dynamicboard.p2
    else
        return dynamicboard.p1
    end
end

function get_resource(player::PlayerStats, resource::Integer)::Int8
    index::Int8 = starting_index[1] + (resource - 1) * bit_usage[1]
    return read_binary_range(
        player.road_bitboard,
        index,
        index + bit_usage[1] - 1
    )
end

function get_resource(bank::Bank, resource::Integer)::Int8
    index::Int8  = 1 + (resource - 1)*bit_usage[1]
    return read_binary_range(
        bank.bitboard,
        index,
        index + bit_usage[1] - 1
    )
end


function set_resource(player::PlayerStats, resource::Integer, value::Integer)
    index::Int8  = starting_index[1] + (resource - 1) * bit_usage[1]
    player.road_bitboard = write_binary_range(
        player.road_bitboard,
        index,
        index + bit_usage[1] - 1,
        value
    )
    # println("Range: ", index, " to ", index + bit_usage[1] - 1, " - Resource: ", resource)
end

function set_resource(bank::Bank, resource::Integer, value::Integer)
    index::Int16  = 1 + (resource - 1) * bit_usage[1]
    bank.bitboard = write_binary_range(
        bank.bitboard,
        index,
        index + bit_usage[1] - 1,
        value
    )
    # println("Range: ", index, " to ", index + bit_usage[1] - 1, " - Resource: ", resource)
end


function add_resource(player::PlayerStats, resource_type::Integer, value::Integer)
    current::Int8 = get_resource(player, resource_type)
    return set_resouce(player, resource_type, current + value)
end

function add_resource(bank::Bank, resource_type::Integer, value::Integer)
    current::Int8 = get_resource(bank, resource_type)
    return set_resouce(bank, resource_type, current + value)
end


function can_afford(player::PlayerStats, resource_type::Integer, value::Integer)::Bool
    return get_resource(player, resource_type) >= value
end

function can_afford(bank::Bank, resource_type::Integer, value::Integer)::Bool
    return get_resource(bank, resource_type) >= value
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

function get_card(player::PlayerStats, card_type::Integer)::Int8
    index::Int8 = starting_index[1] + sum(bit_usage[1:0+card_type]) + 4*5
    return read_binary_range(
        player.road_bitboard,
        index,
        index + bit_usage[card_type+1] - 1
    )
end

function get_card(bank::Bank, card_type::Integer)::Int8
    index::Int8 = 1 + sum(bit_usage[1:0+card_type]) + 4*5
    return read_binary_range(
        bank.bitboard,
        index,
        index + bit_usage[card_type+1] - 1
    )
end

function set_card(player::PlayerStats, card_type::Integer, value::Integer)
    index::Int8 = starting_index[1] + sum(bit_usage[1:0+card_type]) + 4*5
    player.road_bitboard = write_binary_range(
        player.road_bitboard,
        index,
        index + bit_usage[card_type+1] - 1,
        value
    )
    # println("Range: ", index, " to ", index + bit_usage[card_type+1] - 1, " - Card: ", card_type)
end

function set_card(bank::Bank, card_type::Integer, value::Integer)
    index::Int8 = 1 + sum(bit_usage[1:0+card_type]) + 4*5
    bank.bitboard = write_binary_range(
        bank.bitboard,
        index,
        index + bit_usage[card_type+1] - 1,
        value
    )
    # println("Range: ", index, " to ", index + bit_usage[card_type+1] - 1, " - Card: ", card_type)
end

function add_card(player::PlayerStats, card_type::Integer, value::Integer)
    current::Int8 = get_card(player, card_type)
    return set_card(player, card_type, current + value)
end

function add_card(bank::Bank, card_type::Integer, value::Integer)
    current::Int8 = get_card(bank, card_type)
    return set_card(bank, card_type, current + value)  
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

function is_roadable(dynamicboard::DynamicBoard2P, player::PlayerStats, index::Integer)::Bool
   
    if (dynamicboard.p1.road_bitboard(index) != 0 || dynamicboard.p2.road_bitboard(index) != 0)
        return false
    end
    adjacency::NTuple{72, NTuple{4, Int8}} = road_adjacency
    neighbors::NTuple{4, Int8} = adjacency[index];
    
    if (
        globalBitboard(neighbors[1]) == 0 &&
        globalBitboard(neighbors[2]) == 0 &&
        ((neighbors[3] == 0) || globalBitboard(neighbors[3]) == 0 ) &&
        ((neighbors[4] == 0) || globalBitboard(neighbors[4]) == 0 )
    )
        return true
    end
    return false
end

function is_road(player::PlayerStats, index::Integer)::Bool
    return player.road_bitboard(index)
end

function set_road(player::PlayerStats, index::Integer)
    player.road_bitboard = set_bit(player.road_bitboard, index)
end

function activate_port(player::PlayerStats, resource::Integer)
    player.settlement_bitboard = set_bit(player.settlement_bitboard, 55 + resource)
end

function get_port(player::PlayerStats, resource::Integer)::Bool
    return check_bit(player.settlement_bitboard, 55 + resource)
end

function count_settlements(player::PlayerStats)::Int8
    return count_ones(player.settlement_bitboard & building_bitboard_mask)
end

function count_cities(player::PlayerStats)::Int8
    return count_ones(player.city_bitboard & building_bitboard_mask)
end

function initial_phase_ended(player::PlayerStats)::Bool
    return check_bit(player.settlement_bitboard, starting_index[2])
end

function end_initial_phase(dynamicboard::DynamicBoard2P)
    dynamicboard.p1.settlement_bitboard = set_bit(dynamicboard.p1.settlement_bitboard, starting_index[2])
    dynamicboard.p2.settlement_bitboard = set_bit(dynamicboard.p2.settlement_bitboard, starting_index[2])
end