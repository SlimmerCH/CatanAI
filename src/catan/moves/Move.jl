struct Move
    
    # (AAYY YXXX) trade amount (A+1) of resource type (X) with the bank for 1 resource of type (Y) 
    trade::Vector{UInt8} #

    # (0XXX XXXX) road with id X       
    # (10XX XXXX) building with id X
    # (1100 0000) development card
    buy::Vector{UInt8}

    # (1PPX XXXX) knight card with tile id X, steal from player id P
    # (0001 0000) the first two items in "buy" are roads and are free.
    # (0010 0XXX) monopoly card with resource id X
    # (01YY YXXX) plenty card with resource ids X and Y
    # (0000 0000) no action
    play::UInt8

    function Move(trade::Vector{UInt8} = UInt8[], buy::Vector{UInt8} = UInt8[], play::UInt8 = UInt8(0))
        new(trade, buy, play)
    end
end



include("AtomicMoves.jl")
include("Commit.jl")
include("Validate.jl")