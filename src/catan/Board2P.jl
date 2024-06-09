import Random: rand

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

    function Cards(knight::Integer, road::Integer, monopoly::Integer, plenty::Integer, point::Integer) new(Int8(knight), Int8(road), Int8(monopoly), Int8(plenty), Int8(point)) end

    function Cards() new(Int8(0), Int8(0), Int8(0), Int8(0), Int8(0)) end
end

struct Resources
    wood::Int8
    brick::Int8
    sheep::Int8
    wheat::Int8
    stone::Int8

    function Resources(wood::Integer, brick::Integer, sheep::Integer, wheat::Integer, stone::Integer) new(Int8(wood), Int8(brick), Int8(sheep), Int8(wheat), Int8(stone)) end

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

    function PlayerBitboard(settlement_bitboard::UInt64, city_bitboard::UInt64, road_bitboard::UInt128, tradeport_bitfield::UInt8, resources::Resources, cards::Cards, resource_points::Resources, vp::Integer)
        new(settlement_bitboard, city_bitboard, road_bitboard, tradeport_bitfield, resources, cards, resource_points, Int8(vp))
    end
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

function rand(type::Type{PlayerBitboard})::PlayerBitboard
    resources = Resources(
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19))
    )

    cards = Cards(
        Int8(rand(0:14)),
        Int8(rand(0:2)),
        Int8(rand(0:2)),
        Int8(rand(0:2)),
        Int8(rand(0:5))
    )

    resource_points = Resources(
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19))
    )

    vp = Int8(rand(0:9))

    return PlayerBitboard(
        UInt64(rand(UInt64)),
        UInt64(rand(UInt64)),
        UInt128(rand(UInt128)),
        UInt8(rand(UInt8)),
        resources,
        cards,
        resource_points,
        vp
    )
end

function rand(type::Type{Board2P})::Board2P
    board::Board2P = Board2P()
    Board2P.dynamic.p1_bitboard = rand(PlayerBitboard)
    Board2P.dynamic.p2_bitboard = rand(PlayerBitboard)
    Board2P.dynamic.bank = Resources(
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19))
    )
    return board
end