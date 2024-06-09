# In julia, indexing starts at 1, so we need to subtract 1 from the position when shifting bits.

function set_bit(uInt::Unsigned, position::Integer)::Unsigned
    return uInt | (UInt8(1) << (position-1))
end

function clear_bit(uInt::Unsigned, position::Integer)::Unsigned
    return uInt & ~(UInt8(1) << (position-1))
end

function check_bit(uInt::Unsigned, position::Integer)::Bool
    return (uInt >> (position-1)) & UInt8(1) == UInt8(1)
end

function (uInt::Unsigned)(position::Integer)::Bool
    return check_bit(uInt, position)
end