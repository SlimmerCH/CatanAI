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

    
    function DynamicBoard2P(p1_bitboard::PlayerBitboard, p2_bitboard::PlayerBitboard, bank::Resources)
        new(p1_bitboard, p2_bitboard, bank)
    end
    function DynamicBoard2P() new(PlayerBitboard(), PlayerBitboard(), Resources()) end
end

struct Board2P
    static::StaticBoard
    dynamic::DynamicBoard2P

    function Board2P(static::StaticBoard, dynamic::DynamicBoard2P)
        new(static, dynamic)
    end
    function Board2P()
        new(StaticBoard(), DynamicBoard2P())
    end
end

function rand(type::Type{PlayerBitboard})::PlayerBitboard
    resources = rand(Resources)

    cards = rand(Cards)

    resource_points = rand(Resources)

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

function rand(type::Type{Cards})::Cards
    return cards = Cards(
        Int8(rand(0:14)),
        Int8(rand(0:2)),
        Int8(rand(0:2)),
        Int8(rand(0:2)),
        Int8(rand(0:5))
    )
end

function rand(type::Type{Resources})::Resources
    return Resources(
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19)),
        Int8(rand(0:19))
    )
end

function rand(type::Type{Board2P})::Board2P
    b1 = rand(UInt64) & rand(UInt64) & rand(UInt64) & rand(UInt64)
    b2 = rand(UInt64) & rand(UInt64) & rand(UInt64) & ~b1
    b3 = rand(UInt64) & rand(UInt64) & ~b1 & ~b2
    b4 = rand(UInt64) & ~b1 & ~b2 & ~b3

    s1 = rand(UInt128) & rand(UInt128)
    s2 = rand(UInt128) & ~s1

    p1_bitboard = PlayerBitboard(b1, b2, s1, rand(UInt8), rand(Resources), rand(Cards), rand(Resources), rand(0:9))
    p2_bitboard = PlayerBitboard(b3, b4, s2, rand(UInt8), rand(Resources), rand(Cards), rand(Resources), rand(0:9))
    bank = rand(Resources)

    return Board2P(StaticBoard(), DynamicBoard2P(p1_bitboard, p2_bitboard, bank))
end