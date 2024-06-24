function rand(type::Type{PlayerStats})::PlayerStats
    return PlayerStats(
        UInt64(rand(UInt64)),
        UInt64(rand(UInt64)),
        UInt128(rand(UInt128)),

    )
end


function rand(type::Type{Board2P})::Board2P
    b1 = rand(UInt64) & rand(UInt64) & rand(UInt64) & rand(UInt64)
    b2 = rand(UInt64) & rand(UInt64) & rand(UInt64) & ~b1
    b3 = rand(UInt64) & rand(UInt64) & ~b1 & ~b2
    b4 = rand(UInt64) & ~b1 & ~b2 & ~b3

    s1 = rand(UInt128) & rand(UInt128)
    s2 = rand(UInt128) & ~s1

    p1_bitboard = PlayerStats(b1, b2, s1)
    p2_bitboard = PlayerStats(b3, b4, s2)

    return Board2P(StaticBoard(), DynamicBoard2P(p1_bitboard, p2_bitboard, rand(UInt64)))
end