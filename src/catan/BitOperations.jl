function set_bit(uInt::Unsigned, position::Integer)::Unsigned
    return uInt | (UInt8(1) << position)
end

function clear_bit(uInt::Unsigned, position::Integer)::Unsigned
    return uInt & ~(UInt8(1) << position)
end

function check_bit(uInt::Unsigned, position::Integer)::Bool
    return (uInt >> position) & UInt8(1) == UInt8(1)
end