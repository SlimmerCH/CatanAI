include("LocalServer.jl")
using .LocalServer

const smooth_hexagon_path::String = """<path d="M239.88,9.31L50.42,118.69c-9.97,5.76-16.12,16.4-16.12,27.92v218.77c0,11.52,6.14,22.16,16.12,27.92l189.46,109.39c9.97,5.76,22.26,5.76,32.24,0l189.46-109.39c9.97-5.76,16.12-16.4,16.12-27.92v-218.77c0-11.52-6.14-22.16-16.12-27.92L272.12,9.31c-9.97-5.76-22.26-5.76-32.24,0Z"></path>"""
const hexagon_path = """<polygon class="cls-1" points="256 0 34.3 128 34.3 384 256 512 477.7 384 477.7 128 256 0"/>"""
const house_path::String = """<path d="M62.79,29.172l-28-28C34.009,0.391,32.985,0,31.962,0s-2.047,0.391-2.828,1.172l-28,28c-1.562,1.566-1.484,4.016,0.078,5.578c1.566,1.57,3.855,1.801,5.422,0.234L8,33.617V60c0,2.211,1.789,4,4,4h16V48h8v16h16c2.211,0,4-1.789,4-4V33.695l1.195,1.195c1.562,1.562,3.949,1.422,5.516-0.141C64.274,33.188,64.356,30.734,62.79,29.172z"/>"""
const building_path::String = """<path d="M56,0H8C5.789,0,4,1.789,4,4v56c0,2.211,1.789,4,4,4h20V48h8v16h20c2.211,0,4-1.789,4-4V4C60,1.789,58.211,0,56,0z M28,40h-8v-8h8V40z M28,24h-8v-8h8V24z M44,40h-8v-8h8V40z M44,24h-8v-8h8V24z"/>"""
const license::String = """<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/SlimmerCH/CatanAI">CatanAI.jl</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/SlimmerCH">Selim Bucher</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC-SA 4.0<img class="ic ic1" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>"""

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
    card_names = ["Knight", "Road", "Monopoly", "Plenty"]
    card_amounts = [get_card_amount(player, i) for i in 6:10]
    opponent_card_amounts = [get_card_amount(opponent, i) for i in 6:10]

    # Show "Use" button if player has any development cards
    show_use = sum(card_amounts) > 0
    show_opponent_use = sum(opponent_card_amounts) > 0

    # Last rolled dice (read from LocalServer)
    last_dice = LocalServer.last_dice_roll == "" ? "-" : string(LocalServer.last_dice_roll)

    # Player turn indicator
    is_p1_turn = !get_player_turn(board.dynamic)
    turn_color = is_p1_turn ? "#2a88bc" : "#d9300d"
    turn_text = is_p1_turn ? "Your Turn" : "Opponent's Turn"

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
                $(join([ "<li><span>$(card_names[i])</span><span>$(card_amounts[i])</span></li>" for i in 1:4 ], "\n"))
            </ul>
        </div>
        $(show_use ? "<button class='use-dev-btn' id='use-devcard'>Use Dev Card</button>" : "")
    </div>
    """

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
        $(show_opponent_use ? "<button class='use-dev-btn' id='use-devcard-opponent'>Use Dev Card</button>" : "")
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

    html::String = """
        <html>
        <head>
        $(read(pwd()*"/src/gui/html/style.html", String))
        </head>
        <body>
            $sidebar_html
            $sidebar_right_html
            $bottom_controls_html
            <div class='tiles-grid'>
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
            // Sidebar right open/close state using localStorage
            var sidebarRight = document.getElementById('sidebar-right');
            var toggleBtn = document.getElementById('toggle-right');
            function setSidebarState(open) {
                if (open) {
                    sidebarRight.classList.remove('hide');
                    toggleBtn.textContent = '>';
                } else {
                    sidebarRight.classList.add('hide');
                    toggleBtn.textContent = '<';
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
                            target: "hex",
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
                    });
                    e.stopPropagation();
                });
            }
            // Use Development Card buttons
            var useDevBtn = document.getElementById('use-devcard');
            if (useDevBtn) {
                useDevBtn.addEventListener('click', function(e) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({type: "use_devcard", player: 1})
                    });
                    e.stopPropagation();
                });
            }
            var useDevOpponentBtn = document.getElementById('use-devcard-opponent');
            if (useDevOpponentBtn) {
                useDevOpponentBtn.addEventListener('click', function(e) {
                    fetch('/move', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({type: "use_devcard", player: 2})
                    });
                    e.stopPropagation();
                });
            }
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