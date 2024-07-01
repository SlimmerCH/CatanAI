# Multiple dispatch goes brrrrrrrrrrrrrrrrrrrrrrr

include("BitOperations.jl")

const starting_index::NTuple{2, Int8} = (
    73, # resources and cards   |   road_bitboard
    55  # player turn           |   settlement_bitboard
)

const max_value::NTuple{6, Int8} = (
    19, # resources
    14, # knight_cards
    2,  # road_cards
    2,  # monopoly_cards
    2,  # plenty_cards
    5   # point_cards
)

const cards = ["knight_cards", ]

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

function set_building(player::PlayerStats, index::Integer, type::Int8)
    if value == 2
        player.city_bitboard = set_bit(player.city_bitboard, index)
        player.settlement_bitboard = clear_bit(player.settlement_bitboard, index)
    elseif value == 1
        player.settlement_bitboard = set_bit(player.settlement_bitboard, index)
    else
        throw(ArgumentError("Invalid building type"))
    end
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