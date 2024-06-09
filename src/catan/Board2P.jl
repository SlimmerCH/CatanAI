# Bitboard Representation goes brrrrrrrrrrrrr

# Nodes: 54
# Edges: 72
# Tiles: 19

struct Cards
    knight_cards::Int8
    road_cards::Int8
    monopoly_cards::Int8
    plenty_cards::Int8
    point_cards::Int8

    function Cards() new(Int8(0), Int8(0), Int8(0), Int8(0), Int8(0)) end
end

struct Resources
    wood::Int8
    brick::Int8
    sheep::Int8
    wheat::Int8
    stone::Int8

    function Resources() new(Int8(0), Int8(0), Int8(0), Int8(0), Int8(0)) end
end

struct PlayerBitboard
    settlement_bitboard::UInt64
    city_bitboard::UInt64
    road_bitboard::UInt128
    tradeport_bitfield::UInt8 # 3-to-1, wood, brick, sheep, stone, wheat

    resources::Resources
    cards::Cards

    resource_points::Resources
    vp::Int8

    function PlayerBitboard() new(UInt64(0), UInt64(0), UInt128(0), UInt8(0), Resources(), Cards(), Resources(), Int8(0)) end
end

struct StaticBoard
    tile_to_resource::NTuple{19, Int8}
    tile_to_number::NTuple{19, Int8}
    function StaticBoard()
        tile_to_resource = generate_tile_to_resource_lookup()
        tile_to_number = generate_tile_to_number_lookup(tile_to_resource)
        new(tile_to_resource, tile_to_number)
    end
end

struct DynamicBoard2P
    p1_bitboard::PlayerBitboard
    p2_bitboard::PlayerBitboard
    bank::Resources
    function DynamicBoard2P()
        new(PlayerBitboard(), PlayerBitboard(), Resources())
    end
end

struct Board2P
    static::StaticBoard
    dynamic::DynamicBoard2P
    function Board2P()
        new(StaticBoard(), DynamicBoard2P())
    end
end