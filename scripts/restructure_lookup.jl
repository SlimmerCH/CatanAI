include("../src/data/node_to_tile.jl")

# Initialize an empty dictionary to store the reverse mapping
tile_to_node = Dict{Int8, Vector{Int}}()

# Populate the dictionary with empty arrays for each tile
for i in 1:19
    tile_to_node[Int8(i)] = Int[]
end

# Fill in the dictionary with the corresponding nodes
for (node, tiles) in enumerate(node_to_tile)
    for tile in tiles
        push!(tile_to_node[tile], node)
    end
end

# Print the resulting dictionary
for tile in sort(collect(keys(tile_to_node)))
    println(tile_to_node[tile],",")
end