const node_to_tile::Vector{Vector{Int8}} = [
    [1],           #  1
    [1],           #  2
    [1, 2],        #  3
    [2],           #  4
    [2, 3],        #  5
    [3],           #  6
    [3],           #  7
    [4],           #  8
    [1, 4],        #  9
    [1, 4, 5],     # 10
    [1, 2, 5],     # 11
    [2, 5, 6],     # 12
    [2, 3, 6],     # 13
    [3, 6, 7],     # 14
    [3, 7],        # 15
    [7],           # 16
    [8],           # 17
    [4, 8],        # 18
    [4, 8, 9],     # 19
    [4, 5, 9],     # 20
    [5, 9, 10],    # 21
    [5, 6, 10],    # 22
    [6, 10, 11],   # 23
    [6, 7, 11],    # 24
    [7, 11, 12],   # 25
    [7, 12],       # 26
    [12],          # 27
    [8],           # 28
    [8, 13],       # 29
    [8, 9, 13],    # 30
    [9, 13, 14],   # 31
    [9, 10, 14],   # 32
    [10, 14, 15],  # 33
    [10, 11, 15],  # 34
    [11, 15, 16],  # 35
    [11, 12, 16],  # 36
    [12, 16],      # 37
    [12],          # 38
    [13],          # 39
    [13, 17],      # 40
    [13, 14, 17],  # 41
    [14, 17, 18],  # 42
    [14, 15, 18],  # 43
    [15, 18, 19],  # 44
    [15, 16, 19],  # 45
    [16, 19],      # 46
    [16],          # 47
    [17],          # 48
    [17],          # 49
    [17, 18],      # 50
    [18],          # 51
    [18, 19],      # 52
    [19],          # 53
    [19]           # 54
]


using Random: shuffle

const token_numbers = [5,2,6,3,8,10,9,12,11,4,8,10,9,4,5,6,3,11]
const outer_ring_order = [1,2,3,7,12,16,19,18,17,13,8,4]
const inner_ring_order = [5,6,11,15,14,9]
const center = 10

function random_starting_index()::Int8
    return 2*rand(Int8(0):Int(5))+Int8(1)
end

function out_to_inner_ring(index::T)::T where T <: Integer
    return T((index+1)/2)
end

function generate_tile_to_resource_lookup()::Vector{Int8}
    return [0,1,1,1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,5] |> shuffle
end

function generate_tile_to_number_lookup(tile_to_resource, start_index::Integer = random_starting_index())#::Vector{Int8}
    start_index ∈ [1,3,5,7,9,11] || throw("Error: The start index has to be 1, 3, 5, 7, 9 or 11.") #
    loop_direction = rand(Bool)

    lookup_table = Vector{Int8}(undef, 19)

    function get_append_function(ring_order, offset::Integer)::Function
        return (i, j) -> begin
            tile_index = ring_order[i]

            is_desert = tile_to_resource[tile_index] == 0
            if is_desert
                lookup_table[tile_index] = 0
            else
                lookup_table[tile_index] = token_numbers[offset + j]
            end

            return is_desert
        end
    end


    offset_1 = loop_trough_ring(outer_ring_order, start_index, loop_direction, get_append_function(outer_ring_order, 0))
    offset_2 = loop_trough_ring(inner_ring_order, out_to_inner_ring(start_index), loop_direction, get_append_function(inner_ring_order, offset_1))
    loop_trough_ring([center], 1, loop_direction, get_append_function([center], offset_1+offset_2))
    return lookup_table
end

function loop_trough_ring(ring_order::Vector, start_index::Integer, clockwise::Bool, f::Function)
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