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

    if isempty(move.buy) && !initial_phase_ended(player)
        @warn "Player must place a structure."
        return false # Initial phase must be ended before forcing
    end

    if get_robber_position(board.dynamic.bank) == 0 && (!isempty(move.buy) || move.play >> 7 != 1 || move.play & 0b00011111 == 0)
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

        if get_robber_position(board.dynamic.bank) == 0
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
            elseif foundation == 1 && !can_afford(player, 3)
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
        tile_id = move.play & 0b00011111
        if tile_id == 0 && get_card_amount(player, 6) == 0
            @warn "Player does not have a Knight card to play."
            return false
        end
        if tile_id == 0 && !is_devcard_ready(player, 6)
            @warn "Player can not play a Knight card yet."
            return false
        end
        if tile_id != 0 && (get_card_amount(player, 6) == 0 || !is_devcard_ready(player, 6)) && get_robber_position(board.dynamic.bank) != 0
            @warn "Player can not relocate the robber."
            return false
        end
    elseif move.play == 0b00010000 # Road Building
        if get_card_amount(player, 7) == 0
            @warn "Player does not have a Road Building card to play."
            return false
        end
        if !is_devcard_ready(player, 7)
            @warn "Player can not play a Road Building card yet."
            return false
        end
    elseif move.play >> 5 == 1 # Monopoly
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