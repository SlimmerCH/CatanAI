using Random: shuffle

const token_numbers = (5, 2, 6, 3, 8, 10, 9, 12, 11, 4, 8, 10, 9, 4, 5, 6, 3, 11)
const outer_ring_order = (1, 2, 3, 7, 12, 16, 19, 18, 17, 13, 8, 4)
const inner_ring_order = (5, 6, 11, 15, 14, 9)
const center = (10,)

const building_indexes = (
              0x02,0x03,0x04,0x05,0x06,0x07,0x08,
         0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,
    0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,
         0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,
              0x52,0x53,0x54,0x55,0x56,0x57,0x58
)

function random_starting_index()::Int8
    return 2 * rand(Int8(0):Int(5)) + Int8(1)
end

function out_to_inner_ring(index::T)::T where {T<:Integer}
    return T((index + 1) / 2)
end

function generate_tile_to_resource_lookup()::NTuple{19,Int8}
    return tuple(shuffle([0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5])...)
end

function generate_tile_to_number_lookup(tile_to_resource, start_index::Integer=random_starting_index())::NTuple{19,Int8}
    start_index ∈ [1, 3, 5, 7, 9, 11] || throw("Error: The start index has to be 1, 3, 5, 7, 9 or 11.") #
    loop_direction = rand(Bool)

    lookup_table = Vector{Int8}(undef, 19)

    function get_append_function(ring_order, offset::Integer)::Function
        return (i, j) -> begin
            tile_index = ring_order[i]

            is_desert = tile_to_resource[tile_index] == 0
            if is_desert
                lookup_table[tile_index] = 0
            else
                lookup_table[tile_index] = token_numbers[offset+j]
            end

            return is_desert
        end
    end


    offset_1 = loop_trough_ring(outer_ring_order, start_index, loop_direction, get_append_function(outer_ring_order, 0))
    offset_2 = loop_trough_ring(inner_ring_order, out_to_inner_ring(start_index), loop_direction, get_append_function(inner_ring_order, offset_1))
    loop_trough_ring(center, 1, loop_direction, get_append_function(center, offset_1 + offset_2))
    return tuple(lookup_table...)
end

function loop_trough_ring(ring_order::Tuple, start_index::Integer, clockwise::Bool, f::Function)
    spiral_direction = ifelse(clockwise, 1, -1)

    i = start_index
    store_j = 0
    for j in eachindex(ring_order)

        store_j += 1

        if f(i, store_j)
            store_j -= 1
        end

        i += spiral_direction
        if i < 1
            i = length(ring_order)
        elseif i > length(ring_order)
            i = 1
        end
    end
    return store_j
end

function generate_number_to_tile_lookup(tile_to_number)::NTuple{12, Tuple{Int8, Int8}}

    lookup_array = Array{Tuple{Int8, Int8}}(undef, 12)
    for i in 1:12

        if i == 1 || i == 7
            lookup_array[i] = (0, 0)
            continue
        end

        first_tile = findfirst(tile_to_number .== i)
        second_tile = findfirst(tile_to_number[first_tile+1:end] .== i)

        if second_tile === nothing
            second_tile = 0
        else
            second_tile += first_tile
        end

        lookup_array[i] = (first_tile, second_tile)
    end

    # Initializing the number_to_resource tuple
    number_to_tile::NTuple{12, Tuple{Int8, Int8}} = tuple(lookup_array...)

    
    return number_to_tile
end


function generate_ports()::NTuple{9, Int8}
    ports = [1,2,3,4,5,6,6,6,6]
    return Tuple(shuffle(ports))
end

function generate_structure()
    tile_to_resource = generate_tile_to_resource_lookup()
    tile_to_number = generate_tile_to_number_lookup(tile_to_resource)
    number_to_tile = generate_number_to_tile_lookup(tile_to_number)
    ports = generate_ports()
    return tile_to_resource, tile_to_number, number_to_tile, ports
end