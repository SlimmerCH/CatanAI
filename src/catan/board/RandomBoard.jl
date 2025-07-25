function rand(type::Type{PlayerStats})::PlayerStats
    return PlayerStats(
        UInt64(rand(UInt64)),
        UInt64(rand(UInt64)),
        UInt128(rand(UInt128)),

    )
end

function rand(type::Type{Bank})::Bank
    return Bank(rand(UInt64))
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

    return Board2P(StaticBoard(), DynamicBoard2P(p1_bitboard, p2_bitboard, rand(Bank)))
end

function fullBoard()::Board2P

    zero64::UInt64 = 0x0000000000000000
    full64::UInt64 = 0xFFFFFFFFFFFFFFFF
    zero128::UInt128 = 0x00000000000000000000000000000000
    full128::UInt128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

    p1_bitboard = PlayerStats(full64, zero64, full128)
    p2_bitboard = PlayerStats(zero64, zero64, zero128)
    return Board2P(StaticBoard(), DynamicBoard2P(p1_bitboard, p2_bitboard, Bank()))
end