include("LocalServer.jl")
using .LocalServer

const smooth_hexagon_path::String = """<path d="M239.88,9.31L50.42,118.69c-9.97,5.76-16.12,16.4-16.12,27.92v218.77c0,11.52,6.14,22.16,16.12,27.92l189.46,109.39c9.97,5.76,22.26,5.76,32.24,0l189.46-109.39c9.97-5.76,16.12-16.4,16.12-27.92v-218.77c0-11.52-6.14-22.16-16.12-27.92L272.12,9.31c-9.97-5.76-22.26-5.76-32.24,0Z"></path>"""
const hexagon_path = """<polygon class="cls-1" points="256 0 34.3 128 34.3 384 256 512 477.7 384 477.7 128 256 0"/>"""
const house_path::String = """<path d="M62.79,29.172l-28-28C34.009,0.391,32.985,0,31.962,0s-2.047,0.391-2.828,1.172l-28,28c-1.562,1.566-1.484,4.016,0.078,5.578c1.566,1.57,3.855,1.801,5.422,0.234L8,33.617V60c0,2.211,1.789,4,4,4h16V48h8v16h16c2.211,0,4-1.789,4-4V33.695l1.195,1.195c1.562,1.562,3.949,1.422,5.516-0.141C64.274,33.188,64.356,30.734,62.79,29.172z"/>"""
const building_path::String = """<path d="M56,0H8C5.789,0,4,1.789,4,4v56c0,2.211,1.789,4,4,4h20V48h8v16h20c2.211,0,4-1.789,4-4V4C60,1.789,58.211,0,56,0z M28,40h-8v-8h8V40z M28,24h-8v-8h8V24z M44,40h-8v-8h8V40z M44,24h-8v-8h8V24z"/>"""
const license::String = """<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/SlimmerCH/CatanAI">CatanAI.jl</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/SlimmerCH">Selim Bucher</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC-SA 4.0<img class="ic ic1" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>"""
const ghost_path::String = """<path d="M168.1 531.1L156.9 540.1C153.7 542.6 149.8 544 145.8 544C136 544 128 536 128 526.2L128 256C128 150 214 64 320 64C426 64 512 150 512 256L512 526.2C512 536 504 544 494.2 544C490.2 544 486.3 542.6 483.1 540.1L471.9 531.1C458.5 520.4 439.1 522.1 427.8 535L397.3 570C394 573.8 389.1 576 384 576C378.9 576 374.1 573.8 370.7 570L344.1 539.5C331.4 524.9 308.7 524.9 295.9 539.5L269.3 570C266 573.8 261.1 576 256 576C250.9 576 246.1 573.8 242.7 570L212.2 535C200.9 522.1 181.5 520.4 168.1 531.1zM288 256C288 238.3 273.7 224 256 224C238.3 224 224 238.3 224 256C224 273.7 238.3 288 256 288C273.7 288 288 273.7 288 256zM384 288C401.7 288 416 273.7 416 256C416 238.3 401.7 224 384 224C366.3 224 352 238.3 352 256C352 273.7 366.3 288 384 288z"/>"""

function display!(board::Board2P; launch_server::Bool=true)
    LocalServer.board_ref = board  # Set the board reference automatically

    # Always show p1 as "You", p2 as "Opponent"
    player = board.dynamic.p1
    opponent = board.dynamic.p2

    # Resource names and ids
    resource_names = ["Wood", "Brick", "Sheep", "Wheat", "Ore"]
    resource_amounts = [get_card_amount(player, i) for i in 1:5]
    opponent_resource_amounts = [get_card_amount(opponent, i) for i in 1:5]

    # Development card names and ids
    card_names = ["Knight", "Road Building", "Monopoly", "Year of Plenty", "Victory Point"]
    card_amounts = [get_card_amount(player, i) for i in 6:10]
    opponent_card_amounts = [get_card_amount(opponent, i) for i in 6:10]

    # Last rolled dice (read from LocalServer)
    last_dice = LocalServer.last_dice_roll == "" ? "-" : string(LocalServer.last_dice_roll)

    # Player turn indicator
    is_p1_turn = !get_player_turn(board.dynamic)
    turn_color = is_p1_turn ? "#2a88bc" : "#d9300d"
    turn_text = is_p1_turn ? "Your Turn" : "Opponent's Turn"

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
        </div>
        <h2>Development Cards</h2>
        <div class="section">
            <ul class="card-list">
                $(join([ "<li><span>$(card_names[i])</span><span>$(card_amounts[i])</span></li>" for i in 1:5 ], "\n"))
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
        <button class="toggle-btn" id="toggle-right">&lt;</button>
        <h2>Opponent</h2>
        <div class="section">
            <ul class="resource-list">
                $(join([ "<li><span>$(resource_names[i])</span><span>$(opponent_resource_amounts[i])</span></li>" for i in 1:5 ], "\n"))
            </ul>
        </div>
        <h2>Development Cards</h2>
        <div class="section">
            <ul class="card-list">
                $(join([ "<li><span>$(card_names[i])</span><span>$(opponent_card_amounts[i])</span></li>" for i in 1:4 ], "\n"))
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
            <button class='dev-card-btn' id='buy-devcard'>Buy Development Card</button>
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
                    </div>
                </div>
            </div>
        </div>

        <div class="debug-section">
            <h3>Bitboard Masks & Constants</h3>
            <div class="debug-bitboard">Building Bitboard Mask: $(format_bitboard(building_bitboard_mask))</div>
            <div class="debug-bitboard">Road Bitboard Mask: $(format_bitboard(road_bitboard_mask))</div>
            <div class="debug-flags">
                <div>Starting Indices: Resources=$(starting_index[1]), Free Road=$(starting_index[2]), Initial Phase=$(starting_index[3]), Force Road=$(starting_index[4]), DevCard Ready=$(starting_index[5])</div>
                <div>Card Bit Usages: $(join(["$(i)=$(card_bit_usages[i])" for i in 1:10], ", "))</div>
            </div>
        </div>

        <div class="debug-instruction">Press Ctrl+D to close | Click × to close</div>
    </div>
    """

    # Resource selection popups
    popup_html = """
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
    """

    html::String = """
        <html>
        <head>
        <meta charset="UTF-8">
        <script src="https://kit.fontawesome.com/8788d9e4e4.js" crossorigin="anonymous"></script>
        $(read(pwd()*"/src/gui/html/style.html", String))
        </head>
        <body>
            $sidebar_html
            $sidebar_right_html
            $bottom_controls_html
            $debug_html
            $popup_html
            <div class='tiles-grid'>
            <svg viewBox="0 0 640 640" id="ghost" class="ghost h$(get_robber_position(board.dynamic.bank))">$ghost_path</svg>
            $(join(["<svg resource='$(board.static.tile_to_resource[i])' class='hex h$i' viewBox='0 0 512 512' data-hex='$i'>$smooth_hexagon_path</svg>" for i in 1:19], "\n"))
            $(join(["<div number='$(board.static.tile_to_number[i])' class='number-token h$i' data-number='$i'>$(board.static.tile_to_number[i])</div>" for i in 1:19 if board.static.tile_to_number[i] != 0], "\n"))
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p1' data-settlement='1' data-building='0' data-index='$i'>$house_path</svg>" for i in 1:54 if board.dynamic.p1.settlement_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p2' data-settlement='2' data-building='0' data-index='$i'>$house_path</svg>" for i in 1:54 if board.dynamic.p2.settlement_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p1' data-settlement='1' data-building='1' data-index='$i'>$building_path</svg>" for i in 1:54 if board.dynamic.p1.city_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p2' data-settlement='2' data-building='1' data-index='$i'>$building_path</svg>" for i in 1:54 if board.dynamic.p2.city_bitboard(i) ], "\n") )
            $(join( [ "<div class='road r$i p1' data-road='1' data-index='$i'></div>" for i in 1:72 if board.dynamic.p1.road_bitboard(i) ], "\n") )
            $(join( [ "<div class='road r$i p2' data-road='2' data-index='$i'></div>" for i in 1:72 if board.dynamic.p2.road_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i neutral' data-settlement='0' data-building='0' data-index='$i'>$house_path</svg>" for i in 1:54 if !board.dynamic.p1.settlement_bitboard(i) && !board.dynamic.p2.settlement_bitboard(i) && !board.dynamic.p1.city_bitboard(i) && !board.dynamic.p2.city_bitboard(i) ], "\n") )
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
                    toggleBtn.textContent = '';
                } else {
                    sidebarRight.classList.add('hide');
                    toggleBtn.textContent = '';
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
                    } else if (el.dataset.settlement || el.dataset.building) {
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
            // Resource selection popup functionality
            let monopolySelected = null;
            let plentySelected = [];
            const resourceNames = ['', 'Wood', 'Brick', 'Sheep', 'Wheat', 'Ore'];

            // Monopoly popup handlers
            function openMonopolyPopup() {
                document.getElementById('monopoly-popup').classList.add('show');
                monopolySelected = null;
                updateMonopolyUI();
            }

            function closeMonopolyPopup() {
                document.getElementById('monopoly-popup').classList.remove('show');
                document.querySelectorAll('#monopoly-popup .resource-option').forEach(el => el.classList.remove('selected'));
                monopolySelected = null;
            }

            function updateMonopolyUI() {
                const confirmBtn = document.getElementById('monopoly-confirm');
                confirmBtn.disabled = monopolySelected === null;
            }

            // Year of Plenty popup handlers
            function openPlentyPopup() {
                document.getElementById('plenty-popup').classList.add('show');
                plentySelected = [];
                updatePlentyUI();
            }

            function closePlentyPopup() {
                document.getElementById('plenty-popup').classList.remove('show');
                document.querySelectorAll('#plenty-popup .resource-option').forEach(el => el.classList.remove('selected'));
                plentySelected = [];
                document.getElementById('plenty-selected').style.display = 'none';
            }

            function updatePlentyUI() {
                const confirmBtn = document.getElementById('plenty-confirm');
                const selectedDiv = document.getElementById('plenty-selected');
                const selectionText = document.getElementById('plenty-selection-text');
                const counter = document.getElementById('plenty-counter');
                
                confirmBtn.disabled = plentySelected.length !== 2;
                
                if (plentySelected.length > 0) {
                    selectedDiv.style.display = 'block';
                    selectionText.textContent = plentySelected.map(r => resourceNames[r]).join(', ');
                } else {
                    selectedDiv.style.display = 'none';
                }
                
                counter.textContent = 'Select 2 resources (' + plentySelected.length + '/2 selected)';
            }

            // Event listeners for monopoly
            document.getElementById('monopoly-cancel').addEventListener('click', closeMonopolyPopup);
            document.getElementById('monopoly-confirm').addEventListener('click', function() {
                if (monopolySelected !== null) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({
                            type: "use_devcard",
                            card_id: 8,
                            resource1: monopolySelected
                        })
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });
                }
                closeMonopolyPopup();
            });

            document.querySelectorAll('#monopoly-popup .resource-option').forEach(option => {
                option.addEventListener('click', function() {
                    document.querySelectorAll('#monopoly-popup .resource-option').forEach(el => el.classList.remove('selected'));
                    this.classList.add('selected');
                    monopolySelected = parseInt(this.dataset.resource);
                    updateMonopolyUI();
                });
            });

            // Event listeners for year of plenty
            document.getElementById('plenty-cancel').addEventListener('click', closePlentyPopup);
            document.getElementById('plenty-confirm').addEventListener('click', function() {
                if (plentySelected.length === 2) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({
                            type: "use_devcard",
                            card_id: 9,
                            resource1: plentySelected[0],
                            resource2: plentySelected[1]
                        })
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });
                }
                closePlentyPopup();
            });

            document.querySelectorAll('#plenty-popup .resource-option').forEach(option => {
                option.addEventListener('click', function() {
                    const resourceId = parseInt(this.dataset.resource);
                    
                    if (plentySelected.length < 2) {
                        plentySelected.push(resourceId);
                        this.classList.add('selected');
                    } else {
                        // Reset selection if already 2 selected
                        document.querySelectorAll('#plenty-popup .resource-option').forEach(el => el.classList.remove('selected'));
                        plentySelected = [resourceId];
                        this.classList.add('selected');
                    }
                    
                    updatePlentyUI();
                });
            });

            // Close popups when clicking overlay
            document.getElementById('monopoly-popup').addEventListener('click', function(e) {
                if (e.target === this) closeMonopolyPopup();
            });

            document.getElementById('plenty-popup').addEventListener('click', function(e) {
                if (e.target === this) closePlentyPopup();
            });

            // Use Development Card buttons - Updated to handle popups
            document.querySelectorAll('[id^="use-devcard-"]').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    let cardType = parseInt(this.dataset.cardType) + 5;
                    let player = this.id.includes('opponent') ? 2 : 1;
                    
                    // Handle special cards that need resource selection
                    if (cardType === 8) { // Monopoly
                        openMonopolyPopup();
                        return;
                    } else if (cardType === 9) { // Year of Plenty
                        openPlentyPopup();
                        return;
                    }
                    
                    // Handle other cards normally
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({
                            type: "use_devcard", 
                            card_id: cardType
                        })
                    }).then(resp => resp.text())
                      .then(msg => {
                          location.reload();
                      });
                    e.stopPropagation();
                });
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