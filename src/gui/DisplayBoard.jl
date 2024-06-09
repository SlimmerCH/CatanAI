include("LocalServer.jl")
using .LocalServer

const hexagon_path::String = "<path d='M239.88,9.31L50.42,118.69c-9.97,5.76-16.12,16.4-16.12,27.92v218.77c0,11.52,6.14,22.16,16.12,27.92l189.46,109.39c9.97,5.76,22.26,5.76,32.24,0l189.46-109.39c9.97-5.76,16.12-16.4,16.12-27.92v-218.77c0-11.52-6.14-22.16-16.12-27.92L272.12,9.31c-9.97-5.76-22.26-5.76-32.24,0Z'/>"

function display!(board::Board2P)
    html::String = """
        <html>
        <head>
        $(read(pwd()*"/src/catan/html/style.html", String))
        </head>
        <body>
            <div class='tiles-grid'>
            $(join(["<svg resource='$(board.static.tile_to_resource[i])' class='hex h$i' viewBox='0 0 512 512'>$hexagon_path</svg>" for i in 1:19], "\n"))
            $(join(["<div number='$(board.static.tile_to_number[i])' class='number-token h$i'>$(board.static.tile_to_number[i])</div>" for i in 1:19 if board.static.tile_to_number[i] != 0], "\n"))
            </div>
        </body>
        </html>
    """
    LocalServer.set_response!(html)
    return LocalServer.launch()
end