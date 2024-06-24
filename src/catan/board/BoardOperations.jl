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
    return dynamicboard.p1_bitboard.settlement_bitboard(starting_index[2])
end

function flip_player_turn()
    return flip_bit(dynamicboard.p1_bitboard.settlement_bitboard, starting_index[2])
end


function get_resource_value(player::PlayerStats, resource::Integer)::Int8
    index::Int8 = starting_index[1] + (resource - 1) * bit_usage[1]
    return read_binary_range(
        player.road_bitboard,
        index,
        index + bit_usage[1]
    )
end

function get_resource_value(bank::Unsigned, resource::Integer)::Int8
    index::Int8  = 1 + (resource - 1)*bit_usage[1]
    return read_binary_range(bank,
    index,
    index + bit_usage[1])
end


function set_resouce_value(player::PlayerStats, resource::Integer, value::Integer)
    index::Int8  = starting_index[1] + (resource - 1) * bit_usage[1]
    return write_binary_range(
        player.road_bitboard,
        index,
        index + bit_usage[1],
        value
    )
end

function set_resouce_value(bank::Unsigned, resource::Integer, value::Integer)
    index::Int16  = 1 + (resource - 1) * bit_usage[1]
    return write_binary_range(
        bank,
        index,
        index + bit_usage[1],
        value
    )
end


function add_resource(player::PlayerStats, resource_type::Integer, value::Integer)
    current::Int8 = get_resource_value(player, resource_type)
    return set_resouce_value(player, resource_type, current + value)
end

function add_resource(bank::Unsigned, resource_type::Integer, value::Integer)
    current::Int8 = get_resource_value(bank, resource_type)
    return set_resouce_value(bank, resource_type, current + value)
end


function remove_resource(player::PlayerStats, resource_type::Integer, value::Integer)
    current::Int8 = get_resource_value(player, resource_type)
    return set_resouce_value(player, resource_type, current - value)
end

function remove_resource(bank::Unsigned, resource_type::Integer, value::Integer)
    current::Int8 = get_resource_value(bank, resource_type)
    return set_resouce_value(bank, resource_type, current - value)
end


function can_afford(player::PlayerStats, resource_type::Integer, value::Integer)::Bool
    return get_resource_value(player, resource_type) >= value
end

function can_afford(bank::Unsigned, resource_type::Integer, value::Integer)::Bool
    return get_resource_value(bank, resource_type) >= value
end


function get_card_value(player::PlayerStats, card_type::Integer)::Int8
    index::Int8 = starting_index[1] + sum(bit_usage[1:0+card_type])
    return read_binary_range(
        player.road_bitboard,
        index,
        index + bit_usage[card_type+1]
    )
end

function get_card_value(bank::Unsigned, card_type::Integer)::Int8
    index::Int8 = 1 + sum(bit_usage[1:0+card_type])
    return read_binary_range(
        bank,
        index,
        index + bit_usage[card_type+1]
    )
end