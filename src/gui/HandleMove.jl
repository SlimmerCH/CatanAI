using ..CatanBoard

function handle_move(move)
    global board_ref
    player = CatanBoard.get_next_player(board_ref.dynamic)

    println("")
    println("Handling move : $(move)")
    println("")

    force_end = false

    # Example: handle buy move
    if move["type"] == "buy"
        if move["target"] == "road"
            purchase = move["index"]
        elseif move["target"] == "building"
            purchase = 0b10000000 | move["index"]
        else
            error("Unknown target for buy move: $(move["target"])")
        end
        move_obj = CatanBoard.Move([], UInt8[purchase])

        @show move_obj

        if !CatanBoard.validate(board_ref, move_obj)
            return
        end
        if move["target"] == "road" && !CatanBoard.initial_phase_ended(player)
            force_end = true
        end

        CatanBoard.commit(board_ref, move_obj, force_end)
    end

    if move["type"] == "end" && CatanBoard.validate(board_ref, Move())
        CatanBoard.commit(board_ref, Move(), true)
    end

    if initial_phase_ended(get_next_player(board_ref.dynamic))
        dice = random_dice()
        roll_dice(dice, board_ref.static, board_ref.dynamic)
    end
end