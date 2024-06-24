using BenchmarkTools

# Define a static array
const arr = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

# Define a dictionary
const dict = Dict("a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9, "j" => 10)

# Benchmark array lookup
print("Array: ")
@btime arr[5]

# Benchmark dictionary lookup
print("Dictionary: ")
@btime dict["e"]