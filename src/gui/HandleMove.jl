using ..CatanBoard

function handle_move(move)
    global board_ref, last_dice_roll
    player = CatanBoard.get_next_player(board_ref.dynamic)

    println("Handling move.")

    force_end = false

    # Example: handle buy move
    if move["type"] == "buy"
        if move["target"] == "road"
            purchase = move["index"]
        elseif move["target"] == "building"
            purchase = 0b10000000 | move["index"]
        elseif move["target"] == "devcard"
            purchase = 0b11000000
        else
            error("Unknown target for buy move: $(move["target"])")
        end
        move_obj = CatanBoard.Move(UInt8[], UInt8[purchase])

        if move["target"] == "road" && !CatanBoard.initial_phase_ended(player)
            force_end = true
        end

        validate_and_play(move_obj, force_end)
    end

    if move["type"] == "end"
        validate_and_play(CatanBoard.Move(), true)
    end

    if move["type"] == "use_devcard"
        card_id = move["card_id"]
        if card_id == 6
            play = 0b10000000  # Knight
        elseif card_id == 7
            play = 0b00010000  # Road Building
        elseif card_id == 8
            if !haskey(move, "resource1")
                @warn "Monopoly card requires resource1 selection"
                return
            end
            res1 = move["resource1"]
            if res1 < 1 || res1 > 5
                @warn "Invalid resource selection for Monopoly: $(res1)"
                return
            end
            play = 0b00100000 | res1 # Monopoly
        elseif card_id == 9
            if !haskey(move, "resource1") || !haskey(move, "resource2")
                @warn "Year of Plenty card requires resource1 and resource2 selections"
                return
            end
            res1 = move["resource1"]
            res2 = move["resource2"]
            if res1 < 1 || res1 > 5 || res2 < 1 || res2 > 5
                @warn "Invalid resource selection for Year of Plenty: $(res1), $(res2)"
                return
            end
            play = 0b01000000 | res1 | (res2 << 3) # Year of Plenty
        else
            error("Unknown development card ID: $card_id")
        end

        move_obj = CatanBoard.Move(UInt8[], UInt8[], UInt8(play))
        validate_and_play(move_obj, false)
    end

    if move["type"] == "robber"
        index = move["index"]
        if index < 0 || index > 19
            @warn "Invalid hex index: $(index)"
            return
        end
        play::UInt8 = 0b10000000 | index
        if get_player_turn(board_ref.dynamic) == 0
            play = play | 0b00100000 # steal from p2
        end
        move_obj = CatanBoard.Move(UInt8[], UInt8[], play)

        validate_and_play(move_obj, false)
    end

    if move["type"] == "trade"
        source::UInt8 = move["source_resource"]
        target::UInt8 = move["target_resource"]
        amount::UInt8 = CatanBoard.get_trade_offer(player, source)
        @show source
        @show target
        @show amount 
        trade::UInt8 = ((amount-1) << 6) | source | (target << 3)
        @show trade |> bitstring
        move_obj = CatanBoard.Move(UInt8[trade], UInt8[], UInt8(0))
        validate_and_play(move_obj, false)
    end
end

function validate_and_play(move, force_end::Bool)
    global board_ref, last_dice_roll
    if !CatanBoard.validate(board_ref, move)
        println("VALIDATION FAILED.")
        return
    end
    dice = CatanBoard.commit_and_simulate(board_ref, move, force_end)
    last_dice_roll = dice === nothing ? last_dice_roll : dice
end