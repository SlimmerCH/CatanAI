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