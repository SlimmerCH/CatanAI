# In julia, indexing starts at 1, so we need to subtract 1 from the position when shifting bits.

function set_bit(uInt::Unsigned, position::Integer)::Unsigned
    return uInt | (UInt8(1) << (position-1))
end

function clear_bit(uInt::Unsigned, position::Integer)::Unsigned
    return uInt & ~(UInt8(1) << (position-1))
end

function write_bit(uInt::Unsigned, position::Integer, value::Bool)::Unsigned
    if value
        return set_bit(uInt, position)
    else
        return clear_bit(uInt, position)
    end
end

function check_bit(uInt::Unsigned, position::Integer)::Bool
    return (uInt >> (position-1)) & UInt8(1) == UInt8(1)
end

function flip_bit(uInt::Unsigned, position::Integer)::Unsigned
    return uInt ⊻ (UInt8(1) << (position-1))
end

function (uInt::Unsigned)(position::Integer)::Bool
    return check_bit(uInt, position)
end

function read_binary_range(uInt::UIntT, pos1::Integer, pos2::Integer)::UInt where {UIntT <: Unsigned}

    # Validate input. Remove later for performance
    if pos1 < 1 || pos2 < 1 || pos1 > sizeof(UIntT) * 8 || pos2 > sizeof(UIntT) * 8
        throw(ArgumentError("Position arguments must be within the valid range for a $(string(UIntT)) type"))
    end
    if pos1 > pos2
        throw(ArgumentError("pos1 must be less than or equal to pos2"))
    end
    
    # Convert to 0-based indexing for bit manipulation
    pos1 -= UIntT(1)
    pos2 -= UIntT(1)
    
    # Create a mask to isolate the bits from pos1 to pos2
    mask = (UIntT(1) << UIntT(pos2 - pos1 + 1)) - UIntT(1)
    
    # Shift right to align the desired bits to the rightmost position and apply the mask
    result = (uInt >> pos1) & mask
    
    return result
end

function write_binary_range(uInt::UIntT, pos1::Int, pos2::Int, value::UIntT)::UIntT where {UIntT <: Unsigned}

    # Validate input. Remove later for performance
    if pos1 < 1 || pos2 < 1 || pos1 > sizeof(UIntT) * 8 || pos2 > sizeof(UIntT) * 8
        throw(ArgumentError("Position arguments must be within the valid range for a $(string(UIntT)) type"))
    end
    if pos1 > pos2
        throw(ArgumentError("pos1 must be less than or equal to pos2"))
    end
    
    # Convert to 0-based indexing for bit manipulation
    pos1 -= UIntT(1)
    pos2 -= UIntT(1)
    
    # Create a mask to isolate the bits from pos1 to pos2
    mask = (UIntT(1) << UIntT(pos2 - pos1 + 1)) - UIntT(1)
    
    # Ensure the value fits within the specified bit range
    if value > mask
        throw(ArgumentError("Value exceeds the range that can be written to the specified bit positions"))
    end
    
    # Clear the bits in the target range
    uInt &= ~(mask << pos1)
    
    # Write the new value into the target range
    uInt |= (value & mask) << pos1
    
    return uInt
end
