using Test
using Base: summarysize

@testset "Board Operations" begin
    d::DynamicBoard2P = Board2P().dynamic
    bank::Bank = d.bank

    @show bank.bitboard |> bitstring
    
    @test get_player_turn(d) == false
    flip_player_turn(d)
    @test get_player_turn(d) == true
    flip_player_turn(d)
    @test get_player_turn(d) == false

    @test get_card_amount(d.p1, 1) == 0
    @test get_card_amount(d.p1, 2) == 0
    @test get_card_amount(d.p1, 3) == 0
    @test get_card_amount(d.p1, 4) == 0
    @test get_card_amount(d.p1, 5) == 0

    @test has_port(d.p1, 1) == false
    @test has_port(d.p1, 2) == false
    @test has_port(d.p1, 3) == false
    @test has_port(d.p1, 4) == false
    @test has_port(d.p1, 5) == false
    @test has_port(d.p1, 6) == false
    

    set_card_amount(d.p1, 1, 1)
    set_card_amount(d.p1, 2, 2)
    set_card_amount(d.p1, 3, 3)
    set_card_amount(d.p1, 4, 4)
    set_card_amount(d.p1, 5, 5)
    set_card_amount(d.p1, 6, 6)
    set_card_amount(d.p1, 7, 1)
    set_card_amount(d.p1, 8, 2)
    set_card_amount(d.p1, 9, 0)
    set_card_amount(d.p1, 10, 4)

    acquire_port(d.p1, 1)
    acquire_port(d.p1, 5)
    acquire_port(d.p1, 6)

    @test has_port(d.p1, 1) == true
    @test has_port(d.p1, 2) == false
    @test has_port(d.p1, 3) == false
    @test has_port(d.p1, 4) == false
    @test has_port(d.p1, 5) == true
    @test has_port(d.p1, 6) == true

    @test get_card_amount(d.p1, 1) == 1
    @test get_card_amount(d.p1, 2) == 2
    @test get_card_amount(d.p1, 3) == 3
    @test get_card_amount(d.p1, 4) == 4
    @test get_card_amount(d.p1, 5) == 5
    @test get_card_amount(d.p1, 6) == 6
    @test get_card_amount(d.p1, 7) == 1
    @test get_card_amount(d.p1, 8) == 2
    @test get_card_amount(d.p1, 9) == 0
    @test get_card_amount(d.p1, 10) == 4
    @test has_port(d.p1, 1) == true
    @test has_port(d.p1, 2) == false
    @test has_port(d.p1, 3) == false
    @test has_port(d.p1, 4) == false
    @test has_port(d.p1, 5) == true
    @test has_port(d.p1, 6) == true
    @test get_player_turn(d) == false

    @test get_card_amount(bank, 6) == 12 # knights
    @test get_card_amount(bank, 7) == 2 # road cards
    @test get_card_amount(bank, 8) == 2 # year of plenty
    @test get_card_amount(bank, 9) == 2  # monopoly
    @test get_card_amount(bank, 10) == 5 # victory points

    set_card_amount(d.bank, 6, 6)
    set_card_amount(d.bank, 7, 1)
    set_card_amount(d.bank, 8, 2)
    set_card_amount(d.bank, 9, 0)
    set_card_amount(d.bank, 10, 4)
    
    @test get_card_amount(d.bank, 6) == 6
    @test get_card_amount(d.bank, 7) == 1
    @test get_card_amount(d.bank, 8) == 2
    @test get_card_amount(d.bank, 9) == 0
    @test get_card_amount(d.bank, 10) == 4

    for i in 1:54
        @test is_buildable(d, i) == true
    end

    set_building(d.p1, 20, 1)
    set_building(d.p1, 14, 2)
    set_building(d.p2, 32, 1)
    set_building(d.p2, 44, 2)

    @test get_building(d.p1, 20) == 1
    @test get_building(d.p1, 14) == 2
    @test get_building(d.p2, 32) == 1
    @test get_building(d.p2, 44) == 2

    invalid = [
        20,10,19,21,
        14,13,15,24,
        32,31,33,21,
        44,43,45,52
    ]

    for i in invalid
        @test is_buildable(d, i) == false
    end

    for i in 1:54
        if !(i in invalid)
            @test is_buildable(d, i) == true
        end
    end
end