include("../src/gui/LocalServer.jl")
using .LocalServer

response = "<h1>Hello world!</h1>"
set_response!(response)
task = launch()
fetch(task)