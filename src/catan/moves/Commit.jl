function commit_and_simulate(board::Board2P, move::Move, end_move::Bool = false)

    moving_player::PlayerStats = get_next_player(board.dynamic)
    commit(board, move, end_move)
    next_player::PlayerStats = get_next_player(board.dynamic)

    for purchase::UInt8 in move.buy
        if purchase == 0b11000000
            buy_random_devcard(moving_player, board.dynamic.bank)
        end
    end
    if move.play >> 7 == 1 # Knight
        tile_id::Int8 = move.play & 0b00011111
        if tile_id != 0
            target = ((move.play & 0b01100000) >> 5) + 1
            target_player = target == 1 ? board.dynamic.p1 : board.dynamic.p2
            if is_tile_occupied_by(target_player, tile_id)
                steal_random_resource(moving_player, target_player)
            else
                @info "No resources to steal from player $target."
            end
        end
    end
    last_dice_roll = nothing
    if initial_phase_ended(next_player) && end_move
        last_dice_roll = random_dice()
        roll_dice(last_dice_roll, board.static, board.dynamic)
    end

    return last_dice_roll
end

function commit(board::Board2P, move::Move, end_move::Bool = false)
    # we assume that the move is valid
    println("Committing move.")

    player = get_next_player(board.dynamic)
    
    if  move.play == 0b00010000
        increase_cards(player, 7, -1) # spend road building card
        force_road(player) # force road purchases after road building devcard
    end

    commit_trades(board, move.trade)
    commit_card_play(board, move.play)
    last_road::UInt8 = commit_purchases(board, move.buy)
    

    if (end_move)
        if !initial_phase_ended(player) && count_settlements(player) == 2
            end_initial_phase(player) # end initial phase
            adjacency::NTuple{54, Vector{Int8}} = node_to_tile
            for tile::Int8 in adjacency[get_settlement_of_road(player, last_road)]
                resource::Int8 = board.static.tile_to_resource[tile]
                if resource == 0
                    continue # skip desert
                end
                increase_cards(player, resource, 1)
            end

        end
        
        initialize_turn(board)
    end
end

function initialize_turn(board::Board2P)
    flip_player_turn(board.dynamic)
    player::PlayerStats = get_next_player(board.dynamic)
    for i::Int8 in 6:10
        if get_card_amount(player, i) > 0
            set_devcard_ready(player, i) # card has been in hand for a turn
        end
    end
end

function commit_trades(board::Board2P, trade::Vector{UInt8})
    player::PlayerStats = get_next_player(board.dynamic)
    for trade::UInt8 in trade
        trade_amount = ((trade & 0b11000000) >> 6) + 1
        target = (trade & 0b00111000) >> 3
        source = trade & 0b00000111

        increase_cards(player, source, -trade_amount)
        increase_cards(player, target, 1)
    end
end

function commit_purchases(board::Board2P, buy::Vector{UInt8})::UInt8
    player::PlayerStats = get_next_player(board.dynamic)
    initial_ended::Bool = initial_phase_ended(player)
    forced_road::Bool = is_road_forced(player)

    last_road::UInt8 = 0b0

    for purchase::UInt8 in buy

        if (purchase & 0b10000000) == 0b00000000 # road
            if forced_road && initial_ended # free road from devcard
                if is_first_free_road_built(player)
                    clear_first_free_road_built(player) # clear first free road built
                    clear_force_road(player)
                else
                    set_first_free_road_built(player) # set first free road built
                end
            end
            if !initial_ended
                clear_force_road(player) # clear forced road after building
            end
            if !forced_road
                CatanBoard.buy(player, 1) # spend resource for road
            end
            last_road = purchase & 0b01111111
            set_road(player, last_road) # road index
            update_longest_road(board.dynamic, player)
            continue
        end

        if (purchase & 0b11000000) == 0b10000000 # building
            upgrade_building(player, board.static.ports, purchase & 0b00111111) # 1 for settlement
            if !initial_ended
                force_road(player) # force road after settlement
            end
            continue
        end

        if (purchase & 0b11000000) == 0b11000000 # development card
            println("Buy type devcard")
            continue
        end

        error("Unknown purchase type: $(purchase)")
    end

    return last_road
end

function commit_card_play(board::Board2P, play::UInt8)
    player::PlayerStats = get_next_player(board.dynamic)
    if play == 0
        return # no card played
    elseif play >> 7 == 1 # Knight
        tile_id::Int8 = play & 0b00011111
        robber_position::Int8 = get_robber_position(board.dynamic.bank)
        if robber_position != 0
            increase_cards(player, 6, -1) # spend knight card
        end
        if tile_id == 0 || robber_position != 0
            increment_army(board.dynamic, player)
            unready_all_devcards(player) # play may only play one card per turn
        end
        set_robber_position(board.dynamic.bank, tile_id)
        
    elseif play == 0b00010000 # Road is handled in commit
        unready_all_devcards(player) # play may only play one card per turn
    elseif play >> 5 == 1 # Monopoly
        increase_cards(player, 8, -1)
        monopoly_steal(player, get_other_player(board.dynamic), play & 0b00000111)

        unready_all_devcards(player) # play may only play one card per turn
    elseif play >> 6 == 1 # Plenty
        increase_cards(player, 9, -1)
        increase_cards(player, play & 0b00000111, 1) # resource1
        increase_cards(player, (play & 0b00111000) >> 3, 1) # resource2

        unready_all_devcards(player) # play may only play one card per turn
    else
        error("Unknown card play type: $(play)")
    end
    
end