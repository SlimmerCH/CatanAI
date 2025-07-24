# This project uses the HTTP.jl library.
# HTTP.jl is licensed under the MIT "Expat" License.

module LocalServer

    using Base: run
    using HTTP
    using Base.Threads: @spawn
    using JSON3
    using ..CatanBoard  # <-- Add this line

    global response_html::String = ""
    global server_task = nothing
    global server_running::Bool = false
    global board_ref = nothing  # Holds the current Board2P object

    function handler(req)
        global response_html, board_ref
        if req.target == "/move" && req.method == "POST"
            move_data = String(req.body)
            move = JSON3.read(move_data, Dict{String,Any})
            handle_move(move)
            # Regenerate HTML after move
            if board_ref !== nothing
                response_html = display!(board_ref; launch_server=false)
            end
            return HTTP.Response(200, "Move received: " * move_data)
        end
        return HTTP.Response(200, response_html)
    end

    include("HandleMove.jl")

    function launch()
        global server_running, server_task
        if !server_running
            server_running = true
            open_in_default_browser("http://localhost:8080/")
            server_task = @spawn HTTP.serve(handler, "127.0.0.1", 8080)
        end
        return server_task
    end

    function set_response!(html::String)
        global response_html = html
    end

    function detectwsl()
        Sys.islinux() &&
        isfile("/proc/sys/kernel/osrelease") &&
        occursin(r"Microsoft|WSL"i, read("/proc/sys/kernel/osrelease", String))
    end

    function open_in_default_browser(url::AbstractString)::Bool
        try
            if Sys.isapple()
                Base.run(`open $url`)
                return true
            elseif Sys.iswindows() || detectwsl()
                Base.run(`cmd.exe /s /c start "" /b $url`)
                return true
            elseif Sys.islinux()
                browser = "xdg-open"
                if isfile(browser)
                    Base.run(`$browser $url`)
                    return true
                else
                    @warn "Unable to find `xdg-open`. Try `apt install xdg-open`"
                    return false
                end
            else
                return false
            end
        catch ex
            return false
        end
    end

    export launch, set_response!

end