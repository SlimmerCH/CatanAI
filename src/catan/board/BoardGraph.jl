include("../../data/building_adjacency.jl")
include("../../data/road_adjacency.jl")
include("../../data/edge_to_node.jl")
include("../../data/node_to_tile.jl")
include("../../data/tile_to_node.jl")
include("../../data/node_to_port.jl")

# Precompute node_to_edge mapping
node_edges = [Int8[] for _ in 1:54]
for (road_idx, (u, v)) in enumerate(edge_to_node)
    push!(node_edges[u], road_idx)
    push!(node_edges[v], road_idx)
end

# Convert to fixed-size tuples padded with zeros
const node_to_edge::NTuple{54, NTuple{3, Int8}} = ntuple(54) do i
    edges = node_edges[i]
    if length(edges) == 3
        (edges[1], edges[2], edges[3])
    elseif length(edges) == 2
        (edges[1], edges[2], Int8(0))
    elseif length(edges) == 1
        (edges[1], Int8(0), Int8(0))
    else
        (Int8(0), Int8(0), Int8(0))
    end
end

# Precompute node_to_node mapping
node_neighbors = [Int8[] for _ in 1:54]
for (node_idx, adjacent_nodes) in enumerate(building_adjacency)
    for neighbor in adjacent_nodes
        push!(node_neighbors[node_idx], neighbor)
    end
end

# Convert to fixed-size tuples padded with zeros
const node_to_node::NTuple{54, NTuple{3, Int8}} = ntuple(54) do i
    neighbors = node_neighbors[i]
    if length(neighbors) == 3
        (neighbors[1], neighbors[2], neighbors[3])
    elseif length(neighbors) == 2
        (neighbors[1], neighbors[2], Int8(0))
    elseif length(neighbors) == 1
        (neighbors[1], Int8(0), Int8(0))
    else
        (Int8(0), Int8(0), Int8(0))
    end
end