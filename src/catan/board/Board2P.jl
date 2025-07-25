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
    function PlayerStats(is_p1::Bool=false)
        new(UInt64(0), UInt64(0), UInt128(0))
    end
end

struct StaticBoard
    tile_to_resource::NTuple{19, Int8}
    tile_to_number::NTuple{19, Int8}
    number_to_tile::NTuple{12, Tuple{Int8, Int8}}
    
    function StaticBoard()

        tile_to_resource, tile_to_number, number_to_tile = generate_lookups()

        new(tile_to_resource, tile_to_number, number_to_tile)
    end
end

mutable struct Bank
    bitboard::UInt64
    function Bank(uint::UInt64)
        new(uint)
    end
    function Bank()
        new(UInt64(0x0000002d5d39ce73))
    end
end

mutable struct DynamicBoard2P
    p1::PlayerStats
    p2::PlayerStats
    bank::Bank
    
    function DynamicBoard2P(p1::PlayerStats, p2::PlayerStats, bank::Bank)
        new(p1, p2, bank)
    end
    function DynamicBoard2P() new(PlayerStats(true), PlayerStats(false), Bank()) end
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