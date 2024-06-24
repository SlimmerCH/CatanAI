import Random: rand

# Bitboard Representation goes brrrrrrrrrrrrr

# Nodes: 54
# Edges: 72
# Tiles: 19

mutable struct PlayerStats
    settlement_bitboard::UInt64
    city_bitboard::UInt64
    road_bitboard::UInt128

    function PlayerStats(settlement_bitboard::UInt64, city_bitboard::UInt64, road_bitboard::UInt128)
        new(settlement_bitboard, city_bitboard, road_bitboard)
    end
    function PlayerStats() new(UInt64(0), UInt64(0), UInt128(0)) end
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

mutable struct DynamicBoard2P
    p1_bitboard::PlayerStats
    p2_bitboard::PlayerStats
    bank::UInt64
    
    function DynamicBoard2P(p1_bitboard::PlayerStats, p2_bitboard::PlayerStats, bank::UInt64)
        new(p1_bitboard, p2_bitboard, bank)
    end
    function DynamicBoard2P() new(PlayerStats(), PlayerStats(), UInt64(0)) end
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