struct Move
    trade::Array{}
    building::Array{UInt8} # (0YXXXXXX) X for tile id, Y for building type (settlement or city)
    road::Array{Int8} # edge id
    buy_card::Array{Int8} # crad id
    play_knight::Int8  # 0 or tile id
    play_plenty::UInt8 # (00YYYXXX) X and Y are resource ids
    play_monopoly
    play_road
end

function get_moves()::Array{Move}
end