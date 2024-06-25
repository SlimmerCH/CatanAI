using Test

include("../src/catan/board/CatanBoard.jl")
using .CatanBoard
using Base: summarysize

@testset "Board Operations" begin
    d::DynamicBoard2P = Board2P().dynamic

    @test get_player_turn(d) == true
    flip_player_turn(d)
    @test get_player_turn(d) == false
    flip_player_turn(d)
    @test get_player_turn(d) == true

    @test get_resource(d.p1, 1) == 0
    @test get_resource(d.p1, 2) == 0
    @test get_resource(d.p1, 3) == 0
    @test get_resource(d.p1, 4) == 0
    @test get_resource(d.p1, 5) == 0
    
    @test get_resource(d.bank, 1) == 19
    @test get_resource(d.bank, 2) == 19
    @test get_resource(d.bank, 3) == 19
    @test get_resource(d.bank, 4) == 19
    @test get_resource(d.bank, 5) == 19

    @test get_card(d.bank, 1) == 14
    @test get_card(d.bank, 2) == 2
    @test get_card(d.bank, 3) == 2
    @test get_card(d.bank, 4) == 2
    @test get_card(d.bank, 5) == 5
    

    set_resource(d.p1, 1, 1)
    set_resource(d.p1, 2, 2)
    set_resource(d.p1, 3, 3)
    set_resource(d.p1, 4, 4)
    set_resource(d.p1, 5, 5)
    set_card(d.p1, 1, 6)
    set_card(d.p1, 2, 1)
    set_card(d.p1, 3, 2)
    set_card(d.p1, 4, 0)
    set_card(d.p1, 5, 4)

    @test get_resource(d.p1, 1) == 1
    @test get_resource(d.p1, 2) == 2
    @test get_resource(d.p1, 3) == 3
    @test get_resource(d.p1, 4) == 4
    @test get_resource(d.p1, 5) == 5
    @test get_card(d.p1, 1) == 6
    @test get_card(d.p1, 2) == 1
    @test get_card(d.p1, 3) == 2
    @test get_card(d.p1, 4) == 0
    @test get_card(d.p1, 5) == 4

    set_resource(d.bank, 1, 1)
    set_resource(d.bank, 2, 2)
    set_resource(d.bank, 3, 3)
    set_resource(d.bank, 4, 4)
    set_resource(d.bank, 5, 5)
    set_card(d.bank, 1, 6)
    set_card(d.bank, 2, 1)
    set_card(d.bank, 3, 2)
    set_card(d.bank, 4, 0)
    set_card(d.bank, 5, 4)
    
    @test get_resource(d.bank, 1) == 1
    @test get_resource(d.bank, 2) == 2
    @test get_resource(d.bank, 3) == 3
    @test get_resource(d.bank, 4) == 4
    @test get_resource(d.bank, 5) == 5
    @test get_card(d.bank, 1) == 6
    @test get_card(d.bank, 2) == 1
    @test get_card(d.bank, 3) == 2
    @test get_card(d.bank, 4) == 0
    @test get_card(d.bank, 5) == 4

end
