function validate(board::Board2P, move::Move)::Bool
    
    # Check if the move is valid

    ##### FOR NOW, THIS WORKS ONLY WITH SINGLE ACTIONS MOVES. NOT WITH MULTIPLE ACTIONS #####

    # This function should implement the game rules to validate the move
    
    # validate if the move is a single action
    if length(move.trade) > 1 + length(move.buy) > 1 + move.play != UInt8(0) > 1
        throw("Move validation contains multiple actions, which is not supported.")
    end

    player::PlayerStats = get_next_player(board.dynamic)

    for trade::UInt8 in move.trade

        if is_discarding_turn(player)
            trade_amount = ((trade & 0b11110000) >> 4)
            resource = trade & 0b00000111
            if !can_afford(player, resource, trade_amount)
                @show [
                get_card_amount(player, 1),
                get_card_amount(player, 2),
                get_card_amount(player, 3),
                get_card_amount(player, 4),
                get_card_amount(player, 5)
            ]
                @warn "Player cannot afford to discard $(trade_amount) of resource $(resource)."
                return false
            end
            continue
        end

        trade_amount = ((trade & 0b11000000) >> 6) + 1
        target = (trade & 0b00111000) >> 3
        source = trade & 0b00000111

        if target == source
            @warn "Trade cannot be made with the same resource type."
            return false
        end

        if !can_afford(player, source, trade_amount)
            @warn "Player cannot afford the trade: $(trade_amount) of resource $(source) for 1 of resource $(target)."
            return false
        end
    end

    if is_discarding_turn(player)
        return true # Discarding turn is valid
    end
    
    if isempty(move.buy) && !initial_phase_ended(player)
        @warn "Player must place a structure."
        return false # Initial phase must be ended before forcing
    end

    if is_robber_pending(board.dynamic.bank) && (!isempty(move.buy) || move.play >> 7 != 1 || move.play & 0b00011111 == 0)
        @warn "Player must place the robber."
        return false
    end

    if !validate_purchases(board, move)
        return false
    end

    if !validate_card_play(board, move)
        return false
    end

    return true
end

function validate_purchases(board::Board2P, move::Move)::Bool
    # Validate the purchases in the move
    player::PlayerStats = get_next_player(board.dynamic)

    for purchase::UInt8 in move.buy

        if is_discarding_turn(player)
            @warn "Player cannot make purchases while discarding."
            return false
        end

        if is_robber_pending(board.dynamic.bank)
            @warn "Player must place robber before building."
            return false
        end

        if (purchase & 0b11000000) == 0b11000000 # development card
            if !can_afford(player, 4)
                @warn "Player cannot afford a development card."
                return false
            end
        elseif (purchase & 0b10000000) == 0b10000000 # building
            building_index = purchase & 0b00111111
            foundation = get_building(player, building_index)
            if foundation == 0 && !is_buildable(board.dynamic, building_index)
                @warn "Building location is obstructed."
                return false
            end

            if is_road_forced(player)
                if !initial_phase_ended(player)
                    @warn "Player must build a road after a settlement."
                else
                    @warn "Player must build a road after a road building card."
                end 
                return false
            end
            if foundation == 0 && !can_afford(player, 2) && initial_phase_ended(player)
                @warn "Player cannot afford a settlement."
                return false
            end

            if foundation == 0 && !building_has_road(player, building_index) && initial_phase_ended(player)
                @warn "Player must build the settlement adjacent to a road."
                return false
            end
            if foundation == 1 && !can_afford(player, 3)
                @warn "Player cannot afford a city."
                return false
            end
        elseif (purchase & 0b10000000) == 0b00000000 # road
            edge_id = purchase & 0b01111111
            if !can_afford(player, 1) && !is_road_forced(player)
                @warn "Player cannot afford a road."
                return false
            end
            if is_road(board.dynamic, edge_id)
                @warn "Player cannot build a road on an already occupied edge."
                return false
            end
            if initial_phase_ended(player) && !has_road_neighbor(player, edge_id)
                @warn "Player must build the road adjacent to a different road."
                return false
            elseif !initial_phase_ended(player)
                parent_settlement = get_settlement_of_road(player, edge_id)
                if parent_settlement == 0
                    @warn "Player must build a road at a settlement."
                    return false
                end
                if building_has_road(player, parent_settlement)
                    @warn "Player must build the road at the settlement without a road."
                    return false
                end
            end
        else
            error("Unknown purchase type: $(purchase)")
        end
    end

    return true
end

function validate_card_play(board::Board2P, move::Move)::Bool
    # Validate the development card play in the move
    player::PlayerStats = get_next_player(board.dynamic)

    if move.play == 0
        return true # No card played, valid move
    elseif move.play >> 7 == 1 # Knight
        if is_discarding_turn(player)
            @warn "Player cannot play a Knight card while discarding."
            return false
        end
        tile_id = move.play & 0b00011111
        if tile_id == 0 && get_card_amount(player, 6) == 0
            @warn "Player does not have a Knight card to play."
            return false
        end
        if tile_id == 0 && !is_devcard_ready(player, 6)
            @warn "Player can not play a Knight card yet."
            return false
        end
        if tile_id != 0 && (get_card_amount(player, 6) == 0 || !is_devcard_ready(player, 6)) && !is_robber_pending(board.dynamic.bank)
            @warn "Player can not relocate the robber."
            return false
        end
        if tile_id == get_robber_position(board.dynamic.bank)
            @warn "Player cannot relocate the robber on the same tile."
            return false
        end
    elseif move.play == 0b00010000 # Road Building
        if is_discarding_turn(player)
            @warn "Player cannot play a Road Building card while discarding."
            return false
        end
        if get_card_amount(player, 7) == 0
            @warn "Player does not have a Road Building card to play."
            return false
        end
        if !is_devcard_ready(player, 7)
            @warn "Player can not play a Road Building card yet."
            return false
        end
    elseif move.play >> 5 == 1 # Monopoly
        if is_discarding_turn(player)
            @warn "Player cannot play a Monopoly card while discarding."
            return false
        end
        res1 = move.play & 0b00111111
        if get_card_amount(player, 8) == 0
            @warn "Player does not have a Monopoly card to play."
            return false
        end
        if !is_devcard_ready(player, 8)
            @warn "Player can not play a Monopoly card yet."
            return false
        end
    elseif move.play >> 6 == 1 # Year of Plenty
        if is_discarding_turn(player)
            @warn "Player cannot play a Year of Plenty card while discarding."
            return false
        end
        res1 = move.play & 0b00000111
        res2 = move.play & 0b00111000
        if get_card_amount(player, 9) == 0
            @warn "Player does not have a Year of Plenty card to play."
            return false
        end
        if !is_devcard_ready(player, 9)
            @warn "Player can not play a Year of Plenty card yet."
            return false
        end
    else
        @warn "Unknown development card play type: $(move.play)"
        return false
    end

    return true
end