function get_moves(d::DynamicBoard2P, initial_phase = false)::Array{Move}
    if (initial_phase)
        return get_staring_moves(d)
    end
    # the actions will be played in the following order:
    # 1. trade
    # 2. play development cards
    # 3. buy stuff

end

function get_pre_dice_moves(d::DynamicBoard2P)::Array{Move}
    return Move[]
end

function get_staring_moves(d::DynamicBoard2P)::Array{Move}
    moves::Array{Move} = []
    node_to_edge::NTuple{54, NTuple{3, Int8}} = node_to_edge
    for i::UInt8 in 1:54
        if is_buildable(d, i)
            for j in 1:3
                road::Int8 = node_to_edge[i][j]
                if (road != 0)
                    push!(moves, Move([], [i], [road]))
                end
            end
        end
    end
end