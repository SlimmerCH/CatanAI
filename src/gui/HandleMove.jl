using ..CatanBoard

function handle_move(move)
    global board_ref
    @show move
    player = CatanBoard.get_next_player(board_ref.dynamic)

    # Example: handle buy move
    if move["type"] == "buy"
        target = 0b00  # Default target for road
        if move["target"] == "road"
            # target = 0b00
        elseif move["target"] == "building"
            if player.settlement_bitboard(move["index"])
                target = 0b10 # upgrade to city
            else
                target = 0b01 # build settlement
            end
        else
            error("Unknown target for buy move: $(move["target"])")
        end
        move_obj = CatanBoard.Move([], UInt8[UInt8(target << 6 | move["index"])])
        if !CatanBoard.validate(board_ref, move_obj)
            @warn "Invalid move: $(move_obj)"
            return
        end
        CatanBoard.commit(board_ref, move_obj)
    end
end