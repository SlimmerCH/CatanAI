include("LocalServer.jl")
using .LocalServer

const smooth_hexagon_path::String = "<path d='M239.88,9.31L50.42,118.69c-9.97,5.76-16.12,16.4-16.12,27.92v218.77c0,11.52,6.14,22.16,16.12,27.92l189.46,109.39c9.97,5.76,22.26,5.76,32.24,0l189.46-109.39c9.97-5.76,16.12-16.4,16.12-27.92v-218.77c0-11.52-6.14-22.16-16.12-27.92L272.12,9.31c-9.97-5.76-22.26-5.76-32.24,0Z'/>"
const hexagon_path = """<polygon class="cls-1" points="256 0 34.3 128 34.3 384 256 512 477.7 384 477.7 128 256 0"/>"""
const house_path::String = """<path d="M62.79,29.172l-28-28C34.009,0.391,32.985,0,31.962,0s-2.047,0.391-2.828,1.172l-28,28c-1.562,1.566-1.484,4.016,0.078,5.578c1.566,1.57,3.855,1.801,5.422,0.234L8,33.617V60c0,2.211,1.789,4,4,4h16V48h8v16h16c2.211,0,4-1.789,4-4V33.695l1.195,1.195c1.562,1.562,3.949,1.422,5.516-0.141C64.274,33.188,64.356,30.734,62.79,29.172z"/>"""
const building_path::String = """<path d="M56,0H8C5.789,0,4,1.789,4,4v56c0,2.211,1.789,4,4,4h20V48h8v16h20c2.211,0,4-1.789,4-4V4C60,1.789,58.211,0,56,0z M28,40h-8v-8h8V40z M28,24h-8v-8h8V24z M44,40h-8v-8h8V40z M44,24h-8v-8h8V24z"/>"""
const license::String = """<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/SlimmerCH/CatanAI">CatanAI.jl</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/SlimmerCH">Selim Bucher</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC-SA 4.0<img class="ic ic1" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img class="ic" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>"""

function display!(board::Board2P)
    html::String = """
        <html>
        <head>
        $(read(pwd()*"/src/gui/html/style.html", String))
        </head>
        <body>
            <div class='tiles-grid'>
            $(join(["<svg resource='$(board.static.tile_to_resource[i])' class='hex h$i' viewBox='0 0 512 512'>$smooth_hexagon_path</svg>" for i in 1:19], "\n"))
            $(join(["<div number='$(board.static.tile_to_number[i])' class='number-token h$i'>$(board.static.tile_to_number[i])</div>" for i in 1:19 if board.static.tile_to_number[i] != 0], "\n"))
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p1'>$house_path</svg>" for i in 1:54 if board.dynamic.p1.settlement_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p2'>$house_path</svg>" for i in 1:54 if board.dynamic.p2.settlement_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p1'>$building_path</svg>" for i in 1:54 if board.dynamic.p1.city_bitboard(i) ], "\n") )
            $(join( [ "<svg viewBox='0 0 64 64' class='building n$i p2'>$building_path</svg>" for i in 1:54 if board.dynamic.p2.city_bitboard(i) ], "\n") )
            $(join( [ "<div class='road r$i p1'></div>" for i in 1:72 if board.dynamic.p1.road_bitboard(i) ], "\n") )
            $(join( [ "<div class='road r$i p2'></div>" for i in 1:72 if board.dynamic.p2.road_bitboard(i) ], "\n") )
            </div>
            <div class="footer">$(license)</div>
        </body>
        </html>
    """
    LocalServer.set_response!(html)
    return LocalServer.launch()
end