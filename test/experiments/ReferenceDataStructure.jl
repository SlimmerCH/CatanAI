using Random: rand
using Base: summarysize




mutable struct Player
    wood::Int8
    brick::Int8
    sheep::Int8
    wheat::Int8
    stone::Int8
    vp::Int8
    kinght_cards::Int8
    road_cards::Int8
    monopoly_cards::Int8
    plenty_cards::Int8
    point_cards::Int8
    function Player()
        new(rand(Int8), rand(Int8), rand(Int8), rand(Int8), rand(Int8), rand(Int8), rand(Int8), rand(Int8), rand(Int8), rand(Int8), rand(Int8))
    end
end

mutable struct Building
    ownership::Player
    is_city::Bool
end
mutable struct Road
    ownership::Player
end


mutable struct Tile
    nodes::NTuple{6, Building}
    roads::NTuple{6, Road}
    number::Int8
    resource::Int8
end




mutable struct Board
    tiles::NTuple{19, Tile}
    players::NTuple{2, Player}
    bank::Player

    function Board()
        p1 = Player()
        p2 = Player()
        bank = Player()
        tiles = []

        for i in 1:19
            nodes = []
            roads = []
            number = rand(Int8)
            resource = rand(Int8)

            for j in 1:6
                owner = [bank, p1, p2][rand(1:3)]
                is_city = rand(Bool)
                push!(nodes, Building(owner, is_city))
            end

            for j in 1:6
                owner = [bank, p1, p2][rand(1:3)]
                push!(roads, Road(owner))
            end

            nodes = tuple(nodes...)
            roads = tuple(roads...)


            push!(tiles, Tile(nodes, roads, number, resource))
            if i==1
                @show nodes |> summarysize
                @show roads |> summarysize
                @show p1 |> summarysize
                @show p2 |> summarysize
                @show bank |> summarysize
                @show Tile(nodes, roads, number, resource) |> summarysize
            end

        end

        
        tiles = tuple(tiles...)
        @show tiles |> summarysize
        new(tiles, (p1, p2), bank)
    end
end

include("../../data/tile_to_node.jl")



@show Board() |> summarysize