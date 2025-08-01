include("LocalServer.jl")
using .LocalServer

const smooth_hexagon_path::String = """<path d="M239.88,9.31L50.42,118.69c-9.97,5.76-16.12,16.4-16.12,27.92v218.77c0,11.52,6.14,22.16,16.12,27.92l189.46,109.39c9.97,5.76,22.26,5.76,32.24,0l189.46-109.39c9.97-5.76,16.12-16.4,16.12-27.92v-218.77c0-11.52-6.14-22.16-16.12-27.92L272.12,9.31c-9.97-5.76-22.26-5.76-32.24,0Z"></path>"""
const hexagon_path = """<polygon class="cls-1" points="256 0 34.3 128 34.3 384 256 512 477.7 384 477.7 128 256 0"/>"""
const house_path::String = """<path d="M62.79,29.172l-28-28C34.009,0.391,32.985,0,31.962,0s-2.047,0.391-2.828,1.172l-28,28c-1.562,1.566-1.484,4.016,0.078,5.578c1.566,1.57,3.855,1.801,5.422,0.234L8,33.617V60c0,2.211,1.789,4,4,4h16V48h8v16h16c2.211,0,4-1.789,4-4V33.695l1.195,1.195c1.562,1.562,3.949,1.422,5.516-0.141C64.274,33.188,64.356,30.734,62.79,29.172z"/>"""
const building_path::String = """<path d="M56,0H8C5.789,0,4,1.789,4,4v56c0,2.211,1.789,4,4,4h20V48h8v16h20c2.211,0,4-1.789,4-4V4C60,1.789,58.211,0,56,0z M28,40h-8v-8h8V40z M28,24h-8v-8h8V24z M44,40h-8v-8h8V40z M44,24h-8v-8h8V24z"/>"""
const license::String = """<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/SlimmerCH/CatanAI">CatanAI.jl</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/SlimmerCH">Selim Bucher</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC-SA 4.0<img class="ic ic1" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>"""
const ghost_path::String = """<path d="M168.1 531.1L156.9 540.1C153.7 542.6 149.8 544 145.8 544C136 544 128 536 128 526.2L128 256C128 150 214 64 320 64C426 64 512 150 512 256L512 526.2C512 536 504 544 494.2 544C490.2 544 486.3 542.6 483.1 540.1L471.9 531.1C458.5 520.4 439.1 522.1 427.8 535L397.3 570C394 573.8 389.1 576 384 576C378.9 576 374.1 573.8 370.7 570L344.1 539.5C331.4 524.9 308.7 524.9 295.9 539.5L269.3 570C266 573.8 261.1 576 256 576C250.9 576 246.1 573.8 242.7 570L212.2 535C200.9 522.1 181.5 520.4 168.1 531.1zM288 256C288 238.3 273.7 224 256 224C238.3 224 224 238.3 224 256C224 273.7 238.3 288 256 288C273.7 288 288 273.7 288 256zM384 288C401.7 288 416 273.7 416 256C416 238.3 401.7 224 384 224C366.3 224 352 238.3 352 256C352 273.7 366.3 288 384 288z"/>"""
const harbor_svg::String ="""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M320 128C302.3 128 288 142.3 288 160C288 177.7 302.3 192 320 192C337.7 192 352 177.7 352 160C352 142.3 337.7 128 320 128zM224 160C224 107 267 64 320 64C373 64 416 107 416 160C416 201.8 389.3 237.4 352 250.5L352 508.4C414.9 494.1 462.2 438.7 463.9 371.9L447.8 386C437.8 394.7 422.7 393.7 413.9 383.7C405.1 373.7 406.2 358.6 416.2 349.8L480.2 293.8C489.2 285.9 502.8 285.9 511.8 293.8L575.8 349.8C585.8 358.5 586.8 373.7 578.1 383.7C569.4 393.7 554.2 394.7 544.2 386L528 371.9C525.9 485 433.6 576 320 576C206.4 576 114.1 485 112 371.9L95.8 386.1C85.8 394.8 70.7 393.8 61.9 383.8C53.1 373.8 54.2 358.7 64.2 349.9L128.2 293.9C137.2 286 150.8 286 159.8 293.9L223.8 349.9C233.8 358.6 234.8 373.8 226.1 383.8C217.4 393.8 202.2 394.8 192.2 386.1L176.1 372C177.9 438.8 225.2 494.2 288 508.5L288 250.6C250.7 237.4 224 201.9 224 160.1z"/></svg>"""
const arrow_svg::String = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M566.6 342.6C579.1 330.1 579.1 309.8 566.6 297.3L406.6 137.3C394.1 124.8 373.8 124.8 361.3 137.3C348.8 149.8 348.8 170.1 361.3 182.6L466.7 288L96 288C78.3 288 64 302.3 64 320C64 337.7 78.3 352 96 352L466.7 352L361.3 457.4C348.8 469.9 348.8 490.2 361.3 502.7C373.8 515.2 394.1 515.2 406.6 502.7L566.6 342.7z"/></svg>"""

function display!(board::Board2P; launch_server::Bool=true)
    LocalServer.board_ref = board  # Set the board reference automatically

    # Always show p1 as "You", p2 as "Opponent"
    player = board.dynamic.p1
    opponent = board.dynamic.p2

    current_player = get_next_player(board.dynamic)

    # Resource names and ids
    resource_names = ["Wood", "Brick", "Sheep", "Wheat", "Ore"]
    resource_amounts = [get_card_amount(player, i) for i in 1:5]
    opponent_resource_amounts = [get_card_amount(opponent, i) for i in 1:5]
    
    # Get current player resource amounts for discard popup
    current_player_resource_amounts = [get_card_amount(current_player, i) for i in 1:5]

    # Development card names and ids
    card_names = ["Knight", "Road Building", "Monopoly", "Year of Plenty", "Victory Point"]
    card_amounts = [get_card_amount(player, i) for i in 6:10]
    opponent_card_amounts = [get_card_amount(opponent, i) for i in 6:10]

    # Last rolled dice (read from LocalServer)
    last_dice = LocalServer.last_dice_roll == "" ? "-" : string(LocalServer.last_dice_roll)

    # Player turn indicator
    is_p1_turn = !get_player_turn(board.dynamic)
    turn_color = is_p1_turn ? "#2a88bc" : "#d9300d"
    turn_text = is_p1_turn ? "Your Turn" : "Red's Turn"

    # Generate individual use buttons for each dev card type (excluding Victory Point)
    use_buttons_html = join([
        (card_amounts[i] > 0 && is_devcard_ready(player, i+5)) ? "<button class='use-dev-btn' id='use-devcard-$(i)' data-card-type='$(i)'>Use $(card_names[i])</button>" : ""
        for i in 1:4  # Only first 4 card types (excluding Victory Point)
    ], "\n")

    sidebar_html = """
    <div class="sidebar">
        <h2>You</h2>
        <div class="section">
            <ul class="resource-list">
                $(join([ "<li><span>$(resource_names[i])</span><span>$(resource_amounts[i])</span></li>" for i in 1:5 ], "\n"))
            </ul>
            <button class='trade-btn' id='trade-btn'>Trade Resources</button>
        </div>
        <h2>Development Cards</h2>
        <div class="section">
            <ul class="card-list">
                $(join([ "<li><span>$(card_names[i])</span><span>$(card_amounts[i])</span></li>" for i in 1:5 ], "\n"))
            </ul>
            <button class='dev-card-btn' id='buy-devcard'>Buy Development Card</button>
        </div>
        <div class="section">
            <ul class="card-list">
                <li><span>Victory Points</span><span>$(count_victory_points(player))</span></li>
                <li><span>Army Size</span><span>$(get_army_size(player))</span></li>
                <li><span>Longest Road</span><span>$(get_longest_road(player))</span></li>
            </ul>
        </div>
        $use_buttons_html
    </div>
    """

    # Generate individual use buttons for opponent dev cards (excluding Victory Point)
    opponent_use_buttons_html = join([
        (opponent_card_amounts[i] > 0 && is_devcard_ready(opponent, i+5)) ? "<button class='use-dev-btn' id='use-devcard-opponent-$(i)' data-card-type='$(i)'>Use $(card_names[i])</button>" : ""
        for i in 1:4  # Only first 4 card types (excluding Victory Point)
    ], "\n")

    sidebar_right_html = """
    <div class="sidebar-right" id="sidebar-right">
        <button class="toggle-btn" id="toggle-right">$arrow_svg</button>
        <h2>Opponent</h2>
        <div class="section">
            <ul class="resource-list">
                $(join([ "<li><span>$(resource_names[i])</span><span>$(opponent_resource_amounts[i])</span></li>" for i in 1:5 ], "\n"))
            </ul>
            <button class='trade-btn opponent-btn' id='trade-btn-opponent' disabled>Trade Resources</button>
        </div>
        <h2>Development Cards</h2>
        <div class="section">
            <ul class="card-list">
                $(join([ "<li><span>$(card_names[i])</span><span>$(opponent_card_amounts[i])</span></li>" for i in 1:4 ], "\n"))
            </ul>
            <button class='dev-card-btn opponent-btn' id='buy-devcard-opponent' disabled>Buy Development Card</button>
        </div>
        <div class="section">
            <ul class="card-list">
                <li><span>Victory Points</span><span>$(count_victory_points(opponent))</span></li>
                <li><span>Army Size</span><span>$(get_army_size(opponent))</span></li>
                <li><span>Longest Road</span><span>$(get_longest_road(opponent))</span></li>
            </ul>
        </div>
        $opponent_use_buttons_html
    </div>
    """

    # Bottom left controls
    bottom_controls_html = """
    <div class="bottom-controls">
        <div class="turn-indicator">
            <span class="circle" style="background:$turn_color"></span>
            <span>$turn_text</span>
        </div>
        <div class="control-buttons">
            <button class='end-move-btn' id='end-move-btn'>End Move</button>
        </div>
    </div>
    """

    # Debug information generation
    function format_bitboard(bitboard, mask=nothing)
        if mask !== nothing
            masked = bitboard & mask
            return string(masked, base=2, pad=128)[1:72] * " (masked)\nFull: " * string(bitboard, base=2, pad=128)
        else
            return string(bitboard, base=2, pad=128)
        end
    end

    function get_debug_flags(player::PlayerStats)
        flags = []
        push!(flags, ("Initial Phase Ended", initial_phase_ended(player)))
        push!(flags, ("First Free Road Built", is_first_free_road_built(player)))
        push!(flags, ("Road Forced", is_road_forced(player)))
        
        # Development card ready flags
        for card_id in 6:9
            card_name = ["Knight", "Road Building", "Monopoly", "Year of Plenty"][card_id-5]
            push!(flags, ("$(card_name) Ready", is_devcard_ready(player, card_id)))
        end
        
        # Port access flags
        port_names = ["Wood Port", "Brick Port", "Sheep Port", "Wheat Port", "Ore Port", "Generic Port (3:1)"]
        for port_id in 1:6
            push!(flags, ("$(port_names[port_id])", has_port(player, port_id)))
        end
        
        # Special achievements
        push!(flags, ("Has Longest Road", has_longest_road(player)))
        push!(flags, ("Has Largest Army", has_largest_army(player)))
        
        return flags
    end

    # Generate debug HTML
    debug_html = """
    <div class="debug-container" id="debug-container">
        <button class="debug-close" id="debug-close">&times;</button>
        <div class="debug-header">🐛 DEBUG PANEL 🐛</div>
        
        <div class="debug-section">
            <h3>Game State</h3>
            <div class="debug-bank">
                <h4>Bank & Global State</h4>
                <div class="debug-bitboard">Bank Bitboard: $(format_bitboard(board.dynamic.bank.bitboard))</div>
                <div class="debug-flags">
                    <div>Player Turn: <span class="flag-$(get_player_turn(board.dynamic) ? "true" : "false")">$(get_player_turn(board.dynamic) ? "P2" : "P1")</span></div>
                    <div>P1 Discarding Turn: <span class="flag-$(is_discarding_turn(player) ? "true" : "false")">$(is_discarding_turn(player))</span></div>
                    <div>P2 Discarding Turn: <span class="flag-$(is_discarding_turn(opponent) ? "true" : "false")">$(is_discarding_turn(opponent))</span></div>
                    <div>Robber Position: <span class="flag-true">Tile $(get_robber_position(board.dynamic.bank))</span></div>
                    <div>Bank Dev Cards: Knight=$(get_card_amount(board.dynamic.bank, 6)), Road=$(get_card_amount(board.dynamic.bank, 7)), Monopoly=$(get_card_amount(board.dynamic.bank, 8)), Plenty=$(get_card_amount(board.dynamic.bank, 9)), Victory=$(get_card_amount(board.dynamic.bank, 10))</div>
                </div>
            </div>
        </div>

        <div class="debug-section">
            <h3>Player Bitboards</h3>
            <div class="debug-grid">
                <div class="debug-player">
                    <h4>Player 1 (You)</h4>
                    <div class="debug-bitboard">Road Bitboard: $(format_bitboard(player.road_bitboard, road_bitboard_mask))</div>
                    <div class="debug-bitboard">Settlement Bitboard: $(format_bitboard(player.settlement_bitboard, building_bitboard_mask))</div>
                    <div class="debug-bitboard">City Bitboard: $(format_bitboard(player.city_bitboard, building_bitboard_mask))</div>
                    <div class="debug-flags">
                        $(join(["<div>$(flag[1]): <span class=\"flag-$(flag[2] ? "true" : "false")\">$(flag[2])</span></div>" for flag in get_debug_flags(player)], "\n"))
                        <div>Resources: Wood=$(get_card_amount(player, 1)), Brick=$(get_card_amount(player, 2)), Sheep=$(get_card_amount(player, 3)), Wheat=$(get_card_amount(player, 4)), Ore=$(get_card_amount(player, 5))</div>
                        <div>Buildings: Settlements=$(count_settlements(player)), Cities=$(count_cities(player)), Roads=$(count_roads(player))</div>
                        <div>Victory Points: $(count_victory_points(player)), Army Size: $(get_army_size(player)), Longest Road: $(get_longest_road(player))</div>
                    </div>
                </div>
                
                <div class="debug-player">
                    <h4>Player 2 (Opponent)</h4>
                    <div class="debug-bitboard">Road Bitboard: $(format_bitboard(opponent.road_bitboard, road_bitboard_mask))</div>
                    <div class="debug-bitboard">Settlement Bitboard: $(format_bitboard(opponent.settlement_bitboard, building_bitboard_mask))</div>
                    <div class="debug-bitboard">City Bitboard: $(format_bitboard(opponent.city_bitboard, building_bitboard_mask))</div>
                    <div class="debug-flags">
                        $(join(["<div>$(flag[1]): <span class=\"flag-$(flag[2] ? "true" : "false")\">$(flag[2])</span></div>" for flag in get_debug_flags(opponent)], "\n"))
                        <div>Resources: Wood=$(get_card_amount(opponent, 1)), Brick=$(get_card_amount(opponent, 2)), Sheep=$(get_card_amount(opponent, 3)), Wheat=$(get_card_amount(opponent, 4)), Ore=$(get_card_amount(opponent, 5))</div>
                        <div>Buildings: Settlements=$(count_settlements(opponent)), Cities=$(count_cities(opponent)), Roads=$(count_roads(opponent))</div>
                        <div>Victory Points: $(count_victory_points(opponent)), Army Size: $(get_army_size(opponent)), Longest Road: $(get_longest_road(opponent))</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="debug-section">
            <h3>Bitboard Masks & Constants</h3>
            <div class="debug-bitboard">Building Bitboard Mask: $(format_bitboard(building_bitboard_mask))</div>
            <div class="debug-bitboard">Road Bitboard Mask: $(format_bitboard(road_bitboard_mask))</div>
        </div>

        <div class="debug-instruction">Press Ctrl+D to close | Click × to close</div>
    </div>
    """

    # Resource selection popups
    popup_html = """
    <!-- Discard Popup -->
    <div class="popup-overlay" id="discard-popup">
        <div class="popup-content">
            <div class="popup-title">💸 Discard Cards</div>
            <div class="popup-description">You must discard half of your cards (rounded up). Select cards to discard:</div>
            <div class="discard-requirement" id="discard-requirement">Select 0 cards to discard</div>
            <div class="resource-grid discard-grid">
                <div class="resource-option discard-option" data-resource="1" data-available="$(current_player_resource_amounts[1])">
                    <div class="resource-icon wood">🌲</div>
                    <div class="resource-name">Wood</div>
                    <div class="resource-count">Available: $(current_player_resource_amounts[1])</div>
                    <div class="discard-controls">
                        <button class="discard-btn minus" data-resource="1">-</button>
                        <span class="discard-selected" id="discard-selected-1">0</span>
                        <button class="discard-btn plus" data-resource="1">+</button>
                    </div>
                </div>
                <div class="resource-option discard-option" data-resource="2" data-available="$(current_player_resource_amounts[2])">
                    <div class="resource-icon brick">🧱</div>
                    <div class="resource-name">Brick</div>
                    <div class="resource-count">Available: $(current_player_resource_amounts[2])</div>
                    <div class="discard-controls">
                        <button class="discard-btn minus" data-resource="2">-</button>
                        <span class="discard-selected" id="discard-selected-2">0</span>
                        <button class="discard-btn plus" data-resource="2">+</button>
                    </div>
                </div>
                <div class="resource-option discard-option" data-resource="3" data-available="$(current_player_resource_amounts[3])">
                    <div class="resource-icon sheep">🐑</div>
                    <div class="resource-name">Sheep</div>
                    <div class="resource-count">Available: $(current_player_resource_amounts[3])</div>
                    <div class="discard-controls">
                        <button class="discard-btn minus" data-resource="3">-</button>
                        <span class="discard-selected" id="discard-selected-3">0</span>
                        <button class="discard-btn plus" data-resource="3">+</button>
                    </div>
                </div>
                <div class="resource-option discard-option" data-resource="4" data-available="$(current_player_resource_amounts[4])">
                    <div class="resource-icon wheat">🌾</div>
                    <div class="resource-name">Wheat</div>
                    <div class="resource-count">Available: $(current_player_resource_amounts[4])</div>
                    <div class="discard-controls">
                        <button class="discard-btn minus" data-resource="4">-</button>
                        <span class="discard-selected" id="discard-selected-4">0</span>
                        <button class="discard-btn plus" data-resource="4">+</button>
                    </div>
                </div>
                <div class="resource-option discard-option" data-resource="5" data-available="$(current_player_resource_amounts[5])">
                    <div class="resource-icon ore">⛰️</div>
                    <div class="resource-name">Ore</div>
                    <div class="resource-count">Available: $(current_player_resource_amounts[5])</div>
                    <div class="discard-controls">
                        <button class="discard-btn minus" data-resource="5">-</button>
                        <span class="discard-selected" id="discard-selected-5">0</span>
                        <button class="discard-btn plus" data-resource="5">+</button>
                    </div>
                </div>
            </div>
            <div class="popup-buttons">
                <button class="popup-btn confirm" id="discard-confirm" disabled>Discard Cards</button>
            </div>
        </div>
    </div>

    <!-- Monopoly Popup -->
    <div class="popup-overlay" id="monopoly-popup">
        <div class="popup-content">
            <div class="popup-title">🎯 Monopoly Card</div>
            <div class="popup-description">Choose a resource type to collect from all other players</div>
            <div class="resource-grid">
                <div class="resource-option" data-resource="1">
                    <div class="resource-icon wood">🌲</div>
                    <div class="resource-name">Wood</div>
                </div>
                <div class="resource-option" data-resource="2">
                    <div class="resource-icon brick">🧱</div>
                    <div class="resource-name">Brick</div>
                </div>
                <div class="resource-option" data-resource="3">
                    <div class="resource-icon sheep">🐑</div>
                    <div class="resource-name">Sheep</div>
                </div>
                <div class="resource-option" data-resource="4">
                    <div class="resource-icon wheat">🌾</div>
                    <div class="resource-name">Wheat</div>
                </div>
                <div class="resource-option" data-resource="5">
                    <div class="resource-icon ore">⛰️</div>
                    <div class="resource-name">Ore</div>
                </div>
            </div>
            <div class="selection-counter">Select 1 resource type</div>
            <div class="popup-buttons">
                <button class="popup-btn cancel" id="monopoly-cancel">Cancel</button>
                <button class="popup-btn confirm" id="monopoly-confirm" disabled>Confirm</button>
            </div>
        </div>
    </div>

    <!-- Year of Plenty Popup -->
    <div class="popup-overlay" id="plenty-popup">
        <div class="popup-content">
            <div class="popup-title">🎁 Year of Plenty</div>
            <div class="popup-description">Choose 2 resources to gain from the bank</div>
            <div class="selected-resources" id="plenty-selected" style="display: none;">
                Selected: <span id="plenty-selection-text">None</span>
            </div>
            <div class="resource-grid">
                <div class="resource-option" data-resource="1">
                    <div class="resource-icon wood">🌲</div>
                    <div class="resource-name">Wood</div>
                </div>
                <div class="resource-option" data-resource="2">
                    <div class="resource-icon brick">🧱</div>
                    <div class="resource-name">Brick</div>
                </div>
                <div class="resource-option" data-resource="3">
                    <div class="resource-icon sheep">🐑</div>
                    <div class="resource-name">Sheep</div>
                </div>
                <div class="resource-option" data-resource="4">
                    <div class="resource-icon wheat">🌾</div>
                    <div class="resource-name">Wheat</div>
                </div>
                <div class="resource-option" data-resource="5">
                    <div class="resource-icon ore">⛰️</div>
                    <div class="resource-name">Ore</div>
                </div>
            </div>
            <div class="selection-counter" id="plenty-counter">Select 2 resources (can be the same type)</div>
            <div class="popup-buttons">
                <button class="popup-btn cancel" id="plenty-cancel">Cancel</button>
                <button class="popup-btn confirm" id="plenty-confirm" disabled>Confirm</button>
            </div>
        </div>
    </div>

    <!-- Trading Popup -->
    <div class="popup-overlay" id="trade-popup">
        <div class="popup-content trade-popup-content">
            <div class="popup-title">🤝 Trade Resources</div>
            
            <div class="trade-section">
                <div class="trade-row">
                    <div class="trade-side">
                        <div class="trade-label" id="give-label">Give 4:</div>
                        <div class="resource-grid-small" id="general-trade-give">
                            <!-- Will be populated by JavaScript based on available resources -->
                        </div>
                    </div>
                    <div class="trade-arrow">→</div>
                    <div class="trade-side">
                        <div class="trade-label">Get 1:</div>
                        <div class="resource-grid-small">
                            <div class="resource-option trade-receive" data-resource="1">
                                <div class="resource-icon wood">🌲</div>
                                <div class="resource-name">Wood</div>
                            </div>
                            <div class="resource-option trade-receive" data-resource="2">
                                <div class="resource-icon brick">🧱</div>
                                <div class="resource-name">Brick</div>
                            </div>
                            <div class="resource-option trade-receive" data-resource="3">
                                <div class="resource-icon sheep">🐑</div>
                                <div class="resource-name">Sheep</div>
                            </div>
                            <div class="resource-option trade-receive" data-resource="4">
                                <div class="resource-icon wheat">🌾</div>
                                <div class="resource-name">Wheat</div>
                            </div>
                            <div class="resource-option trade-receive" data-resource="5">
                                <div class="resource-icon ore">⛰️</div>
                                <div class="resource-name">Ore</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="trade-section" id="port-trades" style="display: none;">
                <div id="port-trade-options">
                    <!-- Port trades will be populated by JavaScript -->
                </div>
            </div>

            <div class="selected-trade" id="trade-selected" style="display: none;">
                Selected: <span id="trade-selection-text">None</span>
            </div>

            <div class="popup-buttons">
                <button class="popup-btn cancel" id="trade-cancel">Cancel</button>
                <button class="popup-btn confirm" id="trade-confirm" disabled>Confirm Trade</button>
            </div>
        </div>
    </div>
    """

    html::String = """
        <html>
        <head>
        <meta charset="UTF-8">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet">
        $(read(joinpath(@__DIR__, "html", "style.html"), String))
        </head>
        <body>
            $sidebar_html
            $sidebar_right_html
            $bottom_controls_html
            $debug_html
            $popup_html
            <div class='tiles-grid'>
            <svg viewBox="0 0 640 640" id="ghost" class="ghost h$(get_robber_position(board.dynamic))">$ghost_path</svg>
            $(join(["<div class='port port$i' resource='$r'>$harbor_svg</div>" for (i,r) in enumerate(board.static.ports)], "\n"))
            $(join(["<svg resource='$(board.static.tile_to_resource[i])' class='hex h$i' viewBox='0 0 512 512' data-hex='$i'>$smooth_hexagon_path</svg>" for i in 1:19], "\n"))
            $(join(["<div number='$(board.static.tile_to_number[i])' class='number-token h$i' data-number='$i'>$(board.static.tile_to_number[i])</div>" for i in 1:19 if board.static.tile_to_number[i] != 0], "\n"))
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p1' data-owner='1' data-building='0' data-index='$i'>$house_path</svg>" for i in 1:54 if board.dynamic.p1.settlement_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p2' data-owner='2' data-building='0' data-index='$i'>$house_path</svg>" for i in 1:54 if board.dynamic.p2.settlement_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p1' data-owner='1' data-building='1' data-index='$i'>$building_path</svg>" for i in 1:54 if board.dynamic.p1.city_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p2' data-owner='2' data-building='1' data-index='$i'>$building_path</svg>" for i in 1:54 if board.dynamic.p2.city_bitboard(i) ], "\n") )
            $(join( [ "<div class='road r$i p1' data-road='1' data-index='$i'></div>" for i in 1:72 if board.dynamic.p1.road_bitboard(i) ], "\n") )
            $(join( [ "<div class='road r$i p2' data-road='2' data-index='$i'></div>" for i in 1:72 if board.dynamic.p2.road_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i neutral' data-owner='0' data-building='0' data-index='$i'>$house_path</svg>" for i in 1:54 if !board.dynamic.p1.settlement_bitboard(i) && !board.dynamic.p2.settlement_bitboard(i) && !board.dynamic.p1.city_bitboard(i) && !board.dynamic.p2.city_bitboard(i) ], "\n") )
            $(join( [ "<div class='road r$i neutral' data-road='0' data-index='$i'></div>" for i in 1:72 if !board.dynamic.p1.road_bitboard(i) && !board.dynamic.p2.road_bitboard(i) ], "\n") )
            </div>
            <div class="footer">
                $(license)
            </div>
            <div class="dice-indicator">
                <span class="dice-icon">&#x1F3B2;</span>
                <span>Last Dice: <b id="last-dice">$last_dice</b></span>
            </div>
            <script>
            // Discard functionality
            let discardAmounts = [0, 0, 0, 0, 0, 0]; // Index 0 unused, 1-5 for resources
            const totalCards = $(sum(current_player_resource_amounts));
            const requiredDiscards = Math.ceil(totalCards / 2);
            const isDiscardingTurn = $(is_discarding_turn(current_player) ? "true" : "false");

            function updateDiscardUI() {
                const totalSelected = discardAmounts.slice(1).reduce((sum, amount) => sum + amount, 0);
                const remaining = requiredDiscards - totalSelected;
                
                document.getElementById('discard-requirement').textContent = 
                    remaining > 0 ? `Select \${remaining} more cards to discard` : 
                    remaining === 0 ? 'Ready to discard' : `Selected \${-remaining} too many cards`;
                
                document.getElementById('discard-confirm').disabled = remaining !== 0;
                
                // Update display counters
                for (let i = 1; i <= 5; i++) {
                    document.getElementById(`discard-selected-\${i}`).textContent = discardAmounts[i];
                }
            }

            function openDiscardPopup() {
                if (isDiscardingTurn && requiredDiscards > 0) {
                    document.getElementById('discard-popup').classList.add('show');
                    updateDiscardUI();
                }
            }

            // Discard button event listeners
            document.querySelectorAll('.discard-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    const resource = parseInt(this.dataset.resource);
                    const isPlus = this.classList.contains('plus');
                    const isMinus = this.classList.contains('minus');
                    const available = parseInt(document.querySelector(`[data-resource="\${resource}"]`).dataset.available);

                    if (isPlus && discardAmounts[resource] < available) {
                        discardAmounts[resource]++;
                    } else if (isMinus && discardAmounts[resource] > 0) {
                        discardAmounts[resource]--;
                    }
                    
                    updateDiscardUI();
                    e.stopPropagation();
                });
            });

            // Discard confirm button
            document.getElementById('discard-confirm').addEventListener('click', function(e) {
                const discardData = [
                    discardAmounts[1], // Wood at index 0
                    discardAmounts[2], // Brick at index 1
                    discardAmounts[3], // Sheep at index 2
                    discardAmounts[4], // Wheat at index 3
                    discardAmounts[5]  // Ore at index 4
                ];
                
                fetch('/move', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({
                        type: "discard",
                        cards: discardData
                    })
                }).then(resp => resp.text())
                  .then(msg => {
                      location.reload();
                  });
                
                e.stopPropagation();
            });

            // Auto-open discard popup if it's discarding turn
            if (isDiscardingTurn && requiredDiscards > 0) {
                setTimeout(openDiscardPopup, 100);
            }

            // Debug container toggle
            var debugContainer = document.getElementById('debug-container');
            var debugClose = document.getElementById('debug-close');
            
            // Toggle debug panel with Ctrl+D
            document.addEventListener('keydown', function(e) {
                if (e.ctrlKey && e.key === 'd') {
                    e.preventDefault();
                    debugContainer.classList.toggle('show');
                }
            });
            
            // Close debug panel with close button
            if (debugClose) {
                debugClose.addEventListener('click', function() {
                    debugContainer.classList.remove('show');
                });
            }
            
            // Close debug panel when clicking outside
            debugContainer.addEventListener('click', function(e) {
                if (e.target === debugContainer) {
                    debugContainer.classList.remove('show');
                }
            });

            // Sidebar right open/close state using localStorage
            var sidebarRight = document.getElementById('sidebar-right');
            var toggleBtn = document.getElementById('toggle-right');
            function setSidebarState(open) {
                if (open) {
                    sidebarRight.classList.remove('hide');
                    toggleBtn.classList.remove('flipped');
                } else {
                    sidebarRight.classList.add('hide');
                    toggleBtn.classList.add('flipped');
                }
                localStorage.setItem('sidebarRightOpen', open ? '1' : '0');
            }
            // On load, restore sidebar state
            (function() {
                var open = localStorage.getItem('sidebarRightOpen');
                setSidebarState(open !== '0');
            })();
            if (toggleBtn && sidebarRight) {
                toggleBtn.addEventListener('click', function(e) {
                    var open = sidebarRight.classList.contains('hide');
                    setSidebarState(open);
                    e.stopPropagation();
                });
            }
            // Attach click handlers to board elements
            document.querySelectorAll('[data-hex],[data-settlement],[data-building],[data-road]').forEach(el => {
                el.addEventListener('click', function(e) {
                    let move = null;
                    if (el.dataset.hex) {
                        move = {
                            type: "robber",
                            index: parseInt(el.dataset.hex)
                        };
                    } else if (el.dataset.building) {
                        move = {
                            type: "buy",
                            target: "building",
                            index: parseInt(el.dataset.index)
                        };
                    } else if (el.dataset.road) {
                        move = {
                            type: "buy",
                            target: "road",
                            index: parseInt(el.dataset.index)
                        };
                    }
                    if (move) {
                        fetch('/move', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/json'},
                            body: JSON.stringify(move)
                        }).then(resp => resp.text())
                          .then(msg => {
                              location.reload();
                          });
                    }
                    e.stopPropagation();
                });
            });
            // End Move button handler
            var endMoveBtn = document.getElementById('end-move-btn');
            if (endMoveBtn) {
                endMoveBtn.addEventListener('click', function(e) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({type: "end"})
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });
                    e.stopPropagation();
                });
            }
            // Buy Development Card button
            var buyDevBtn = document.getElementById('buy-devcard');
            if (buyDevBtn) {
                buyDevBtn.addEventListener('click', function(e) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({type: "buy", target: "devcard"})
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });;
                    e.stopPropagation();
                });
            }

            // Trading functionality
            let selectedTradeGive = null;
            let selectedTradeReceive = null;
            let selectedPortTrade = null;

            function openTradePopup() {
                document.getElementById('trade-popup').classList.add('show');
                selectedTradeGive = null;
                selectedTradeReceive = null;
                selectedPortTrade = null;
                updateTradeUI();
                updateGeneralTradeLabels();
                populatePortTrades();
            }

            function closeTradePopup() {
                document.getElementById('trade-popup').classList.remove('show');
                document.querySelectorAll('#trade-popup .resource-option').forEach(el => el.classList.remove('selected'));
                selectedTradeGive = null;
                selectedTradeReceive = null;
                selectedPortTrade = null;
            }

            function updateGeneralTradeLabels() {
                const hasGenericPort = $(has_port(player, 6) ? "true" : "false");
                const giveLabel = document.getElementById('give-label');
                
                if (hasGenericPort) {
                    giveLabel.textContent = 'Give 3:';
                } else {
                    giveLabel.textContent = 'Give 4:';
                }
                
                // Populate general trade give options (excluding resources with 2:1 ports)
                populateGeneralTradeGive();
            }

            function populateGeneralTradeGive() {
                const generalTradeGiveContainer = document.getElementById('general-trade-give');
                const resourceAmounts = [0, $(join(resource_amounts, ", "))];
                const resourceNames = ['', 'Wood', 'Brick', 'Sheep', 'Wheat', 'Ore'];
                const resourceIcons = ['', '🌲', '🧱', '🐑', '🌾', '⛰️'];
                const resourceClasses = ['', 'wood', 'brick', 'sheep', 'wheat', 'ore'];
                const hasGenericPort = $(has_port(player, 6) ? "true" : "false");
                const playerPorts = [$(join([string(has_port(player, i) ? "true" : "false") for i in 1:6], ", "))];
                const tradeAmount = hasGenericPort ? 3 : 4;
                
                let generalTradeHtml = '';
                
                // Add resources that don't have 2:1 ports and have enough resources
                for (let i = 1; i <= 5; i++) {
                    const hasSpecificPort = playerPorts[i-1];
                    const hasEnoughResources = resourceAmounts[i] >= tradeAmount;
                    
                    // Only show if player doesn't have a 2:1 port for this resource and has enough resources
                    if (!hasSpecificPort && hasEnoughResources) {
                        generalTradeHtml += '<div class="resource-option trade-give" data-resource="' + i + '">';
                        generalTradeHtml += '<div class="resource-icon ' + resourceClasses[i] + '">' + resourceIcons[i] + '</div>';
                        generalTradeHtml += '<div class="resource-name">' + resourceNames[i] + '</div>';
                        generalTradeHtml += '</div>';
                    }
                }
                
                if (generalTradeHtml === '') {
                    generalTradeHtml = '<div class="no-general-trades">No general trades available</div>';
                }
                
                generalTradeGiveContainer.innerHTML = generalTradeHtml;
                
                // Add event listeners for general trade give options
                document.querySelectorAll('.trade-give').forEach(option => {
                    option.addEventListener('click', function() {
                        document.querySelectorAll('.trade-give').forEach(el => el.classList.remove('selected'));
                        document.querySelectorAll('.port-receive').forEach(el => el.classList.remove('selected'));
                        this.classList.add('selected');
                        selectedTradeGive = parseInt(this.dataset.resource);
                        selectedPortTrade = null;
                        updateTradeUI();
                    });
                });
            }

            function populatePortTrades() {
                const portTradesContainer = document.getElementById('port-trade-options');
                const portTradesSection = document.getElementById('port-trades');
                const resourceAmounts = [0, $(join(resource_amounts, ", "))];
                const resourceNames = ['', 'Wood', 'Brick', 'Sheep', 'Wheat', 'Ore'];
                const resourceIcons = ['', '🌲', '🧱', '🐑', '🌾', '⛰️'];
                const resourceClasses = ['', 'wood', 'brick', 'sheep', 'wheat', 'ore'];
                
                // Check player ports - these are the port indices that provide 2:1 trades
                const playerPorts = [$(join([string(has_port(player, i) ? "true" : "false") for i in 1:6], ", "))];
                
                let portTradesHtml = '';
                let hasPortTrades = false;
                
                // Add specific resource ports (2:1)
                for (let i = 1; i <= 5; i++) {
                    if (playerPorts[i-1] && resourceAmounts[i] >= 2) {
                        hasPortTrades = true;
                        portTradesHtml += '<div class="trade-row port-trade" data-give="' + i + '" data-receive="0">';
                        portTradesHtml += '<div class="trade-side">';
                        portTradesHtml += '<div class="trade-label">Give 2:</div>';
                        portTradesHtml += '<div class="resource-option selected" data-resource="' + i + '">';
                        portTradesHtml += '<div class="resource-icon ' + resourceClasses[i] + '">' + resourceIcons[i] + '</div>';
                        portTradesHtml += '<div class="resource-name">' + resourceNames[i] + '</div>';
                        portTradesHtml += '</div></div>';
                        portTradesHtml += '<div class="trade-arrow">→</div>';
                        portTradesHtml += '<div class="trade-side">';
                        portTradesHtml += '<div class="trade-label">Get 1:</div>';
                        portTradesHtml += '<div class="resource-grid-small">';
                        for (let j = 1; j <= 5; j++) {
                            if (j !== i) {
                                portTradesHtml += '<div class="resource-option port-receive" data-resource="' + j + '" data-port-give="' + i + '">';
                                portTradesHtml += '<div class="resource-icon ' + resourceClasses[j] + '">' + resourceIcons[j] + '</div>';
                                portTradesHtml += '<div class="resource-name">' + resourceNames[j] + '</div>';
                                portTradesHtml += '</div>';
                            }
                        }
                        portTradesHtml += '</div></div></div>';
                    }
                }
                
                // Show or hide the port trades section based on availability
                if (hasPortTrades) {
                    portTradesSection.style.display = 'block';
                    portTradesContainer.innerHTML = portTradesHtml;
                    
                    // Add event listeners for port trades after they're created
                    setTimeout(() => {
                        document.querySelectorAll('.port-receive').forEach(option => {
                            option.addEventListener('click', function() {
                                // Clear previous selections
                                document.querySelectorAll('.port-receive').forEach(el => el.classList.remove('selected'));
                                document.querySelectorAll('.trade-give, .trade-receive').forEach(el => el.classList.remove('selected'));
                                
                                this.classList.add('selected');
                                selectedPortTrade = {
                                    give: parseInt(this.dataset.portGive),
                                    receive: parseInt(this.dataset.resource)
                                };
                                selectedTradeGive = null;
                                selectedTradeReceive = null;
                                updateTradeUI();
                            });
                        });
                    }, 0);
                } else {
                    portTradesSection.style.display = 'none';
                }
            }

            function updateTradeUI() {
                const confirmBtn = document.getElementById('trade-confirm');
                const selectedDiv = document.getElementById('trade-selected');
                const selectionText = document.getElementById('trade-selection-text');
                
                let canConfirm = false;
                let selectionString = 'None';
                
                if (selectedPortTrade) {
                    const resourceNames = ['', 'Wood', 'Brick', 'Sheep', 'Wheat', 'Ore'];
                    selectionString = 'Port Trade: Give 2 ' + resourceNames[selectedPortTrade.give] + ' → Get 1 ' + resourceNames[selectedPortTrade.receive];
                    canConfirm = true;
                } else if (selectedTradeGive && selectedTradeReceive) {
                    const resourceNames = ['', 'Wood', 'Brick', 'Sheep', 'Wheat', 'Ore'];
                    const hasGenericPort = $(has_port(player, 6) ? "true" : "false");
                    const tradeRatio = hasGenericPort ? '3:1' : '4:1';
                    selectionString = 'General Trade (' + tradeRatio + '): Give ' + resourceNames[selectedTradeGive] + ' → Get ' + resourceNames[selectedTradeReceive];
                    canConfirm = true;
                }
                
                confirmBtn.disabled = !canConfirm;
                
                if (canConfirm) {
                    selectedDiv.style.display = 'block';
                    selectionText.textContent = selectionString;
                } else {
                    selectedDiv.style.display = 'none';
                }
            }

            // Trade button event listener
            document.getElementById('trade-btn').addEventListener('click', function(e) {
                openTradePopup();
                e.stopPropagation();
            });

            // Trade popup event listeners
            document.getElementById('trade-cancel').addEventListener('click', function(e) {
                closeTradePopup();
                e.stopPropagation();
            });
            
            document.getElementById('trade-confirm').addEventListener('click', function(e) {
                let tradeRequest = null;
                
                if (selectedPortTrade) {
                    tradeRequest = {
                        type: "trade",
                        source_resource: selectedPortTrade.give,
                        target_resource: selectedPortTrade.receive
                    };
                } else if (selectedTradeGive && selectedTradeReceive) {
                    tradeRequest = {
                        type: "trade",
                        source_resource: selectedTradeGive,
                        target_resource: selectedTradeReceive
                    };
                }
                
                if (tradeRequest) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(tradeRequest)
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });
                }
                closeTradePopup();
                e.stopPropagation();
            });

            // General trade receive event listeners - need to be added after page load
            setTimeout(() => {
                document.querySelectorAll('.trade-receive').forEach(option => {
                    option.addEventListener('click', function() {
                        document.querySelectorAll('.trade-receive').forEach(el => el.classList.remove('selected'));
                        document.querySelectorAll('.port-receive').forEach(el => el.classList.remove('selected'));
                        this.classList.add('selected');
                        selectedTradeReceive = parseInt(this.dataset.resource);
                        selectedPortTrade = null;
                        updateTradeUI();
                    });
                });
            }, 0);

            // Close trade popup when clicking overlay
            document.getElementById('trade-popup').addEventListener('click', function(e) {
                if (e.target === this) closeTradePopup();
            });

            // Development card use button handlers
            document.querySelectorAll('.use-dev-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    const cardType = parseInt(this.dataset.cardType);
                    
                    if (cardType === 1) { // Knight
                        fetch('/move', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/json'},
                            body: JSON.stringify({type: "use_devcard", card_id: 6})
                        }).then(resp => resp.text())
                          .then(msg => {
                              location.reload();
                          });
                    } else if (cardType === 2) { // Road Building
                        fetch('/move', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/json'},
                            body: JSON.stringify({type: "use_devcard", card_id: 7})
                        }).then(resp => resp.text())
                          .then(msg => {
                              location.reload();
                          });
                    } else if (cardType === 3) { // Monopoly
                        openMonopolyPopup();
                    } else if (cardType === 4) { // Year of Plenty
                        openPlentyPopup();
                    }
                    e.stopPropagation();
                });
            });

            // Monopoly popup functionality
            let selectedMonopolyResource = null;

            function openMonopolyPopup() {
                document.getElementById('monopoly-popup').classList.add('show');
                selectedMonopolyResource = null;
                document.querySelectorAll('#monopoly-popup .resource-option').forEach(el => el.classList.remove('selected'));
                document.getElementById('monopoly-confirm').disabled = true;
            }

            function closeMonopolyPopup() {
                document.getElementById('monopoly-popup').classList.remove('show');
                selectedMonopolyResource = null;
            }

            // Monopoly resource selection
            document.querySelectorAll('#monopoly-popup .resource-option').forEach(option => {
                option.addEventListener('click', function() {
                    document.querySelectorAll('#monopoly-popup .resource-option').forEach(el => el.classList.remove('selected'));
                    this.classList.add('selected');
                    selectedMonopolyResource = parseInt(this.dataset.resource);
                    document.getElementById('monopoly-confirm').disabled = false;
                });
            });

            // Monopoly popup buttons
            document.getElementById('monopoly-cancel').addEventListener('click', function(e) {
                closeMonopolyPopup();
                e.stopPropagation();
            });

            document.getElementById('monopoly-confirm').addEventListener('click', function(e) {
                if (selectedMonopolyResource) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({
                            type: "use_devcard", 
                            card_id: 8,
                            resource1: selectedMonopolyResource
                        })
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });
                }
                closeMonopolyPopup();
                e.stopPropagation();
            });

            // Close monopoly popup when clicking overlay
            document.getElementById('monopoly-popup').addEventListener('click', function(e) {
                if (e.target === this) closeMonopolyPopup();
            });

            // Year of Plenty popup functionality
            let selectedPlentyResources = [];

            function openPlentyPopup() {
                document.getElementById('plenty-popup').classList.add('show');
                selectedPlentyResources = [];
                document.querySelectorAll('#plenty-popup .resource-option').forEach(el => el.classList.remove('selected'));
                document.getElementById('plenty-confirm').disabled = true;
                updatePlentyUI();
            }

            function closePlentyPopup() {
                document.getElementById('plenty-popup').classList.remove('show');
                selectedPlentyResources = [];
            }

            function updatePlentyUI() {
                const counter = document.getElementById('plenty-counter');
                const confirmBtn = document.getElementById('plenty-confirm');
                const selectedDiv = document.getElementById('plenty-selected');
                const selectionText = document.getElementById('plenty-selection-text');
                
                const remaining = 2 - selectedPlentyResources.length;
                counter.textContent = 'Select ' + remaining + ' more resource' + (remaining !== 1 ? 's' : '') + ' (can be the same type)';
                
                if (selectedPlentyResources.length === 2) {
                    confirmBtn.disabled = false;
                    const resourceNames = ['', 'Wood', 'Brick', 'Sheep', 'Wheat', 'Ore'];
                    const names = selectedPlentyResources.map(r => resourceNames[r]);
                    selectionText.textContent = names.join(', ');
                    selectedDiv.style.display = 'block';
                } else {
                    confirmBtn.disabled = true;
                    selectedDiv.style.display = 'none';
                }
            }

            // Year of Plenty resource selection
            document.querySelectorAll('#plenty-popup .resource-option').forEach(option => {
                option.addEventListener('click', function() {
                    if (selectedPlentyResources.length < 2) {
                        const resource = parseInt(this.dataset.resource);
                        selectedPlentyResources.push(resource);
                        updatePlentyUI();
                    }
                });
            });

            // Year of Plenty popup buttons
            document.getElementById('plenty-cancel').addEventListener('click', function(e) {
                closePlentyPopup();
                e.stopPropagation();
            });

            document.getElementById('plenty-confirm').addEventListener('click', function(e) {
                if (selectedPlentyResources.length === 2) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({
                            type: "use_devcard", 
                            card_id: 9,
                            resource1: selectedPlentyResources[0],
                            resource2: selectedPlentyResources[1]
                        })
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });
                }
                closePlentyPopup();
                e.stopPropagation();
            });

            // Close plenty popup when clicking overlay
            document.getElementById('plenty-popup').addEventListener('click', function(e) {
                if (e.target === this) closePlentyPopup();
            });
            </script>
        </body>
        </html>
    """
    LocalServer.set_response!(html)
    if launch_server
        return LocalServer.launch()
    else
        return html
    end
end